// 용어 사전 검색 — 용어·영문 이름·한 줄 정의에서 찾고, 맞는 줄이 없는 분류는 통째로 숨깁니다.
(function () {
  var input = document.getElementById("glossary-q");
  if (!input) return;

  var status = document.getElementById("glossary-status");
  var empty = document.getElementById("glossary-empty");
  var groups = document.querySelectorAll(".glossary-group");

  function run() {
    // 띄어쓰기로 나눈 단어가 모두 들어 있는 줄만 남깁니다.
    var words = input.value.trim().toLowerCase().split(/\s+/).filter(Boolean);
    var total = 0;

    groups.forEach(function (group) {
      var shown = 0;
      group.querySelectorAll("tbody tr").forEach(function (row) {
        var text = row.getAttribute("data-search") || "";
        var hit = words.every(function (w) { return text.indexOf(w) !== -1; });
        row.hidden = !hit;
        if (hit) shown++;
      });
      group.hidden = shown === 0;
      total += shown;
    });

    status.textContent = words.length ? total + "개 찾음" : "";
    empty.hidden = total > 0;
  }

  input.addEventListener("input", run);

  // 주소에 ?q=검색어 가 있으면 바로 걸러서 보여 줍니다.
  var q = new URLSearchParams(location.search).get("q");
  if (q) { input.value = q; run(); }
})();
