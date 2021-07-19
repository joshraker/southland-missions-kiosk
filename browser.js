const homeUrl = 'https://www.southlandchurch.org';
let isLoading = false;

const webview = document.querySelector('webview');
const sadWebview = document.querySelector('#sad-webview');
const locationElement = document.querySelector('#location');
const locationForm = document.querySelector('#location-form');
const terminateButton = document.querySelector('#terminate');
const controls = document.querySelector('#controls');
const homeButton = document.querySelector('#home');
const reloadButton = document.querySelector('#reload');
const backButton = document.querySelector('#back');
const forwardButton = document.querySelector('#forward');

function navigateTo(url) {
  resetExitedState();
  webview.src = url;
}

function navigateHome() {
  navigateTo(homeUrl);
}

function doLayout() {
  const controlsHeight = controls.offsetHeight;
  const windowWidth = document.documentElement.clientWidth;
  const windowHeight = document.documentElement.clientHeight;
  const webviewWidth = windowWidth;
  const webviewHeight = windowHeight - controlsHeight;

  webview.style.width = webviewWidth + 'px';
  webview.style.height = webviewHeight + 'px';

  sadWebview.style.width = webviewWidth + 'px';
  sadWebview.style.height = webviewHeight * 2/3 + 'px';
  sadWebview.style.paddingTop = webviewHeight/3 + 'px';
}

function handleExit(event) {
  console.log(event.type);
  document.body.classList.add('exited');
  if (event.type == 'abnormal') {
    document.body.classList.add('crashed');
  } else if (event.type == 'killed') {
    document.body.classList.add('killed');
  }
}

function resetExitedState() {
  document.body.classList.remove('exited');
  document.body.classList.remove('crashed');
  document.body.classList.remove('killed');
}

function handleLoadCommit(event) {
  resetExitedState();
  if (!event.isTopLevel) {
    return;
  }

  locationElement.value = event.url;
  backButton.disabled = !webview.canGoBack();
  forwardButton.disabled = !webview.canGoForward();
}

function handleLoadStart(event) {
  document.body.classList.add('loading');
  isLoading = true;

  resetExitedState();
  if (!event.isTopLevel) {
    return;
  }

  locationElement.value = event.url;
}

function handleLoadStop(event) {
  // We don't remove the loading class immediately, instead we let the animation
  // finish, so that the spinner doesn't jerkily reset back to the 0 position.
  isLoading = false;
}

function handleLoadAbort(event) {
  console.log('oadAbort');
  console.log('  url: ' + event.url);
  console.log('  isTopLevel: ' + event.isTopLevel);
  console.log('  type: ' + event.type);
}

function handleLoadRedirect(event) {
  resetExitedState();
  if (!event.isTopLevel) {
    return;
  }

  locationElement.value = event.newUrl;
}

window.onresize = doLayout;
doLayout();

backButton.onclick = function() {
  webview.back();
};

forwardButton.onclick = function() {
  webview.forward();
};

homeButton.onclick = navigateHome;
navigateHome();

reloadButton.onclick = function() {
  if (isLoading) {
    webview.stop();
  } else {
    webview.reload();
  }
};

reloadButton.addEventListener(
  'webkitAnimationIteration',
  function() {
    if (!isLoading) {
      document.body.classList.remove('loading');
    }
  }
);

terminateButton.onclick = function() {
  webview.terminate();
};

locationForm.onsubmit = function(e) {
  e.preventDefault();
  navigateTo(locationElement.value);
};

webview.addEventListener('exit', handleExit);
webview.addEventListener('loadstart', handleLoadStart);
webview.addEventListener('loadstop', handleLoadStop);
webview.addEventListener('loadabort', handleLoadAbort);
webview.addEventListener('loadredirect', handleLoadRedirect);
webview.addEventListener('loadcommit', handleLoadCommit);
