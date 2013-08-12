Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab3HLKtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:49:40 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:38008 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3HLKth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:49:37 -0400
From: "Lee, Jae-Hong" <pyrasis@gmail.com>
To: gregkh@suse.de
Cc: minchan@kernel.org, linux-kernel@vger.kernel.org,
        "Lee, Jae-Hong" <pyrasis@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=20v3=201/3=5D=20Type=20fix=20on=20HOWTO=20in=20ko=5FKR?=
Date: Mon, 12 Aug 2013 19:49:24 +0900
Message-Id: <1376304566-10714-1-git-send-email-pyrasis@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lee, Jae-Hong" <pyrasis@gmail.com>

This patch fixes some minor typos in Documentation/ko_KR/HOWTO.

Signed-off-by: Lee, Jae-Hong <pyrasis@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
---
 Documentation/ko_KR/HOWTO |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/Documentation/ko_KR/HOWTO b/Documentation/ko_KR/HOWTO
index ab5189a..4aa79f9 100644
--- a/Documentation/ko_KR/HOWTO
+++ b/Documentation/ko_KR/HOWTO
@@ -182,8 +182,8 @@ Documentation/DocBook/ 디렉토리 내에서 만들어지며 PDF, Postscript, H
 프로젝트를 봐야 한다.
     http://kernelnewbies.org
 그곳은 거의 모든 종류의 기본적인 커널 개발 질문들(질문하기 전에 먼저
-아카이브를 찾아봐라. 과거에 이미 답변되었을 수도 있다)을 할수있는 도움이
-될만한 메일링 리스트가 있다. 또한 실시간으로 질문 할수 있는 IRC 채널도
+아카이브를 찾아봐라. 과거에 이미 답변되었을 수도 있다)을 할 수 있는 도움이
+될만한 메일링 리스트가 있다. 또한 실시간으로 질문 할 수 있는 IRC 채널도
 가지고 있으며 리눅스 커널 개발을 배우는 데 유용한 문서들을 보유하고 있다.
 
 웹사이트는 코드구성, 서브시스템들, 그리고 현재 프로젝트들
@@ -245,7 +245,7 @@ Documentation/DocBook/ 디렉토리 내에서 만들어지며 PDF, Postscript, H
     것을 기억해라. 왜냐하면 변경이 자체내에서만 발생하고 추가된 코드가
     드라이버 외부의 다른 부분에는 영향을 주지 않으므로 그런 변경은
     회귀(역자주: 이전에는 존재하지 않았지만 새로운 기능추가나 변경으로 인해
-		생겨난 버그)를 일으킬 만한 위험을 가지고 있지 않기 때문이다. -rc1이
+    생겨난 버그)를 일으킬 만한 위험을 가지고 있지 않기 때문이다. -rc1이
     배포된 이후에 git를 사용하여 패치들을 Linus에게 보낼수 있지만 패치들은
     공식적인 메일링 리스트로 보내서 검토를 받을 필요가 있다.
   - 새로운 -rc는 Linus가 현재 git tree가 테스트 하기에 충분히 안정된 상태에
@@ -472,7 +472,7 @@ bugme-janitor 메일링 리스트(bugzilla에 모든 변화들이 여기서 메
 가능한한 가장 좋은 기술적인 해답을 찾고 있는 커뮤니티에서는 항상
 어떤 패치가 얼마나 좋은지에 관하여 다른 의견들이 있을 수 있다. 여러분은
 협조적이어야 하고 기꺼이 여러분의 생각을 커널 내에 맞추어야 한다. 아니면
-적어도 여러분의 것이 가치있다는 것을 중명하여야 한다. 잘못된 것도 여러분이
+적어도 여러분의 것이 가치있다는 것을 증명하여야 한다. 잘못된 것도 여러분이
 올바른 방향의 해결책으로 이끌어갈 의지가 있다면 받아들여질 것이라는 점을
 기억하라.
 
@@ -488,21 +488,21 @@ bugme-janitor 메일링 리스트(bugzilla에 모든 변화들이 여기서 메
 커널 커뮤니티는 가장 전통적인 회사의 개발 환경과는 다르다. 여기에 여러분들의
 문제를 피하기 위한 목록이 있다.
   여러분들이 제안한 변경들에 관하여 말할 때 좋은 것들 :
-    - "이것은 여러 문제들을 해겹합니다."
+    - "이것은 여러 문제들을 해결합니다."
     - "이것은 2000 라인의 코드를 제거합니다."
     - "이것은 내가 말하려는 것에 관해 설명하는 패치입니다."
-    - "나는 5개의 다른 아키텍쳐에서 그것을 테스트했슴으로..."
-    - "여기에 일련의 작은 패치들이 있슴음로..."
-    - "이것은 일반적인 머신에서 성능을 향상시킴으로..."
+    - "나는 5개의 다른 아키텍쳐에서 그것을 테스트 했으므로..."
+    - "여기에 일련의 작은 패치들이 있으므로..."
+    - "이것은 일반적인 머신에서 성능을 향상함으로..."
 
   여러분들이 말할 때 피해야 할 좋지 않은 것들 :
-    - "우리를 그것을 AIT/ptx/Solaris에서 이러한 방법으로 했다. 그러므로 그것은 좋은 것임에 틀립없다..."
+    - "우리는 그것을 AIX/ptx/Solaris에서 이러한 방법으로 했다. 그러므로 그것은 좋은 것임에 틀림없다..."
     - "나는 20년동안 이것을 해왔다. 그러므로..."
     - "이것은 돈을 벌기위해 나의 회사가 필요로 하는 것이다."
     - "이것은 우리의 엔터프라이즈 상품 라인을 위한 것이다."
     - "여기에 나의 생각을 말하고 있는 1000 페이지 설계 문서가 있다."
     - "나는 6달동안 이것을 했으니..."
-    - "여기에 5000라인 짜리 패치가 있으니..."
+    - "여기에 5000 라인 짜리 패치가 있으니..."
     - "나는 현재 뒤죽박죽인 것을 재작성했다. 그리고 여기에..."
     - "나는 마감시한을 가지고 있으므로 이 패치는 지금 적용될 필요가 있다."
 
@@ -574,6 +574,7 @@ Pat이라는 이름을 가진 여자가 있을 수도 있는 것이다. 리눅
 또한 완성되지 않았고 "나중에 수정될 것이다." 와 같은 것들을 포함하는
 패치들은 받아들여지지 않을 것이라는 점을 유념하라.
 
+
 변경을 정당화해라
 -----------------
 
-- 
1.7.10.4

