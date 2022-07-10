const homeUrl = 'https://southland-missions.joshraker.com';

const webview = document.querySelector('webview');
const homeButton = document.querySelector('#home');
const backButton = document.querySelector('#back');
const forwardButton = document.querySelector('#forward');

function navigateTo(url) {
  webview.src = url;
}

function navigateHome() {
  navigateTo(homeUrl);
}

function handleLoadCommit(event) {
  if (!event.isTopLevel) {
    return;
  }

  backButton.disabled = !webview.canGoBack();
  forwardButton.disabled = !webview.canGoForward();
}

backButton.onclick = function() {
  webview.back();
};

forwardButton.onclick = function() {
  webview.forward();
};

homeButton.onclick = navigateHome;
navigateHome();

webview.addEventListener('loadcommit', handleLoadCommit);
