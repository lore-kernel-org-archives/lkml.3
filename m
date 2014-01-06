Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbaAFNGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 08:06:05 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:59610 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbaAFNFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 08:05:50 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: gregkh@linuxfoundation.org
Cc: minchan@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 3/3] Documentation: HOWTO: update for 2.6.x -> 3.x versioning in ko_KR
Date: Mon,  6 Jan 2014 22:05:11 +0900
Message-Id: <1389013511-13740-3-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389013511-13740-1-git-send-email-sj38.park@gmail.com>
References: <1389013511-13740-1-git-send-email-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

English version HOWTO updated the versioning but Korean version didn't.
Update it now.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 Documentation/ko_KR/HOWTO | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/ko_KR/HOWTO b/Documentation/ko_KR/HOWTO
index 07ec392..1b71af4 100644
--- a/Documentation/ko_KR/HOWTO
+++ b/Documentation/ko_KR/HOWTO
@@ -222,16 +222,16 @@ Documentation/DocBook/ 디렉토리 내에서 만들어지며 PDF, Postscript, H
 리눅스 커널 개발 프로세스는 현재 몇몇 다른 메인 커널 "브랜치들"과
 서브시스템에 특화된 커널 브랜치들로 구성된다. 몇몇 다른 메인
 브랜치들은 다음과 같다.
-  - main 2.6.x 커널 트리
-  - 2.6.x.y - 안정된 커널 트리
-  - 2.6.x -git 커널 패치들
-  - 2.6.x -mm 커널 패치들
+  - main 3.x 커널 트리
+  - 3.x.y - 안정된 커널 트리
+  - 3.x -git 커널 패치들
+  - 3.x -mm 커널 패치들
   - 서브시스템을 위한 커널 트리들과 패치들
 
-2.6.x 커널 트리
+3.x 커널 트리
 ---------------
 
-2.6.x 커널들은 Linux Torvalds가 관리하며 kernel.org의 pub/linux/kernel/v2.6/
+3.x 커널들은 Linux Torvalds가 관리하며 kernel.org의 pub/linux/kernel/v3.x/
 디렉토리에서 참조될 수 있다.개발 프로세스는 다음과 같다.
   - 새로운 커널이 배포되자마자 2주의 시간이 주어진다. 이 기간동은
     메인테이너들은 큰 diff들을 Linus에게 제출할 수 있다. 대개 이 패치들은
@@ -262,20 +262,20 @@ Andrew Morton의 글이 있다.
          버그의 상황에 따라 배포되는 것이지 미리정해 놓은 시간에 따라
          배포되는 것은 아니기 때문이다."
 
-2.6.x.y - 안정 커널 트리
+3.x.y - 안정 커널 트리
 ------------------------
 
-4 자리 숫자로 이루어진 버젼의 커널들은 -stable 커널들이다. 그것들은 2.6.x
+3 자리 숫자로 이루어진 버젼의 커널들은 -stable 커널들이다. 그것들은 3.x
 커널에서 발견된 큰 회귀들이나 보안 문제들 중 비교적 작고 중요한 수정들을
 포함한다.
 
 이것은 가장 최근의 안정적인 커널을 원하는 사용자에게 추천되는 브랜치이며,
 개발/실험적 버젼을 테스트하는 것을 돕고자 하는 사용자들과는 별로 관련이 없다.
 
-어떤 2.6.x.y 커널도 사용할 수 없다면 그때는 가장 높은 숫자의 2.6.x
+어떤 3.x.y 커널도 사용할 수 없다면 그때는 가장 높은 숫자의 3.x
 커널이 현재의 안정 커널이다.
 
-2.6.x.y는 "stable" 팀<stable@vger.kernel.org>에 의해 관리되며 거의 매번 격주로
+3.x.y는 "stable" 팀<stable@vger.kernel.org>에 의해 관리되며 거의 매번 격주로
 배포된다.
 
 커널 트리 문서들 내에 Documentation/stable_kernel_rules.txt 파일은 어떤
@@ -283,14 +283,14 @@ Andrew Morton의 글이 있다.
 진행되는지를 설명한다.
 
 
-2.6.x -git 패치들
+3.x -git 패치들
 ------------------
 git 저장소(그러므로 -git이라는 이름이 붙음)에는 날마다 관리되는 Linus의
 커널 트리의 snapshot 들이 있다. 이 패치들은 일반적으로 날마다 배포되며
 Linus의 트리의 현재 상태를 나타낸다. 이 패치들은 정상적인지 조금도
 살펴보지 않고 자동적으로 생성된 것이므로 -rc 커널들 보다도 더 실험적이다.
 
-2.6.x -mm 커널 패치들
+3.x -mm 커널 패치들
 ---------------------
 Andrew Morton에 의해 배포된 실험적인 커널 패치들이다. Andrew는 모든 다른
 서브시스템 커널 트리와 패치들을 가져와서 리눅스 커널 메일링 리스트로
-- 
1.8.1.2

