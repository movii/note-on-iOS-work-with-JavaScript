(function (win, doc) {
  'use strict' 
  const $ = (selector) => doc.querySelector(selector)
  
  function changePageBackgroundColor () {
    let page = $('div.page')
    page.style.backgroundColor = "RGBA(194, 243, 200, 1.00)";
  }

  function addFakeSignalButton () {
    let $li = doc.createElement('li')
      , $a = doc.createElement('a')

    $a.setAttribute('href', 'javascript:;')
    $a.classList.add('btn__send-signal')
    $a.innerHTML = 'Send Singal <)))'

    $li.appendChild($a)

    $('.quick-nav').appendChild($li)
    
    $('.btn__send-signal').addEventListener('click', e => {
      e.preventDefault();

      win.webkit.messageHandlers.WKMesesgaSignal.postMessage({
        'title': 'Message Posted from JavaScript',
        'desc': 'using window.webkit.messageHandlers.WKMessageSingal'
      })

    }, {capture: false})
  }

  win.changePageBackgroundColor = changePageBackgroundColor
  win.addFakeSignalButton = addFakeSignalButton
}(window, document));
