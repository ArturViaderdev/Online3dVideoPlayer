// 3D Vision Player - sends the current video page (or a link) to 3dvision-play through the
// native messaging host installed by install.sh. Works in Firefox and Chrome/Chromium.
const api = typeof browser !== "undefined" ? browser : chrome;
const HOST = "com.arturviader.threedvision";
const LAYOUTS = [
  ["auto", "Auto"],
  ["half", "Half SBS"],
  ["full", "Full SBS"],
  ["htab", "Half Top-Bottom"],
  ["tab", "Full Top-Bottom"],
];

function setStatus(text, title) {
  try {
    api.action.setBadgeText({ text });
    api.action.setBadgeBackgroundColor({ color: text === "!" ? "#c00" : "#76b900" });
    if (title) api.action.setTitle({ title });
    if (text) setTimeout(() => api.action.setBadgeText({ text: "" }), 4000);
  } catch (e) {}
}

// pause the page's video and return where it was, so playback continues from there
async function grabPosition(tabId) {
  try {
    const res = await api.scripting.executeScript({
      target: { tabId },
      func: () => {
        const v = [...document.querySelectorAll("video")].find((x) => x.duration > 0);
        if (!v) return 0;
        v.pause();
        return v.currentTime || 0;
      },
    });
    return (res && res[0] && res[0].result) || 0;
  } catch (e) {
    return 0;
  }
}

async function play(url, layout, start) {
  if (!/^https?:\/\//.test(url || "")) {
    setStatus("!", "3D Vision: not a web video");
    return;
  }
  try {
    const resp = await api.runtime.sendNativeMessage(HOST, { url, layout: layout || "auto", start: start || 0 });
    if (resp && resp.ok) setStatus("3D", "3D Vision: playing");
    else setStatus("!", "3D Vision: " + ((resp && resp.error) || "error"));
  } catch (e) {
    setStatus("!", "3D Vision: native host not installed (run install.sh) - " + e);
  }
}

api.action.onClicked.addListener(async (tab) => {
  const start = await grabPosition(tab.id);
  play(tab.url, "auto", start);
});

function createMenus() {
  api.contextMenus.removeAll(() => {
    api.contextMenus.create({ id: "nv3d", title: "3D Vision", contexts: ["page", "video", "link"] });
    for (const [id, title] of LAYOUTS)
      api.contextMenus.create({ id: "nv3d-" + id, parentId: "nv3d", title, contexts: ["page", "video", "link"] });
  });
}
api.runtime.onInstalled.addListener(createMenus);
if (api.runtime.onStartup) api.runtime.onStartup.addListener(createMenus);

api.contextMenus.onClicked.addListener(async (info, tab) => {
  if (!info.menuItemId.startsWith("nv3d-")) return;
  const layout = info.menuItemId.slice(5);
  if (info.linkUrl) return play(info.linkUrl, layout, 0);  // a link: start from the beginning
  const start = tab ? await grabPosition(tab.id) : 0;
  play(info.pageUrl || (tab && tab.url), layout, start);
});
