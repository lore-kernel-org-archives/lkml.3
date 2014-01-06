Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbaAFNy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 08:54:58 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62302 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaAFNy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 08:54:57 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: gregkh@linuxfoundation.org, minchan@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] Documentation: HOWTO: Updates on subsystem trees, patchwork, -next (vs. -mm) in ko_KR
Date: Mon,  6 Jan 2014 22:54:41 +0900
Message-Id: <1389016481-14422-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The update did not applied on Korean translation although it applied on
English documentation. Apply it on Korean translation now.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 Documentation/ko_KR/HOWTO | 104 +++++++++++++++-------------------------------
 1 file changed, 33 insertions(+), 71 deletions(-)

diff --git a/Documentation/ko_KR/HOWTO b/Documentation/ko_KR/HOWTO
index 1b71af4..dc2ff8f 100644
--- a/Documentation/ko_KR/HOWTO
+++ b/Documentation/ko_KR/HOWTO
@@ -225,8 +225,8 @@ Documentation/DocBook/ 디렉토리 내에서 만들어지며 PDF, Postscript, H
   - main 3.x 커널 트리
   - 3.x.y - 안정된 커널 트리
   - 3.x -git 커널 패치들
-  - 3.x -mm 커널 패치들
   - 서브시스템을 위한 커널 트리들과 패치들
+  - 3.x - 통합 테스트를 위한 next 커널 트리
 
 3.x 커널 트리
 ---------------
@@ -235,7 +235,7 @@ Documentation/DocBook/ 디렉토리 내에서 만들어지며 PDF, Postscript, H
 디렉토리에서 참조될 수 있다.개발 프로세스는 다음과 같다.
   - 새로운 커널이 배포되자마자 2주의 시간이 주어진다. 이 기간동은
     메인테이너들은 큰 diff들을 Linus에게 제출할 수 있다. 대개 이 패치들은
-    몇 주 동안 -mm 커널내에 이미 있었던 것들이다. 큰 변경들을 제출하는 데
+    몇 주 동안 -next 커널내에 이미 있었던 것들이다. 큰 변경들을 제출하는 데
     선호되는 방법은  git(커널의 소스 관리 툴, 더 많은 정보들은 http://git.or.cz/
     에서 참조할 수 있다)를 사용하는 것이지만 순수한 패치파일의 형식으로 보내는
     것도 무관하다.
@@ -290,77 +290,39 @@ git 저장소(그러므로 -git이라는 이름이 붙음)에는 날마다 관
 Linus의 트리의 현재 상태를 나타낸다. 이 패치들은 정상적인지 조금도
 살펴보지 않고 자동적으로 생성된 것이므로 -rc 커널들 보다도 더 실험적이다.
 
-3.x -mm 커널 패치들
----------------------
-Andrew Morton에 의해 배포된 실험적인 커널 패치들이다. Andrew는 모든 다른
-서브시스템 커널 트리와 패치들을 가져와서 리눅스 커널 메일링 리스트로
-온 많은 패치들과 한데 묶는다. 이 트리는 새로운 기능들과 패치들을 위한
-장소를 제공하는 역할을 한다. 하나의 패치가 -mm에 한동안 있으면서 그 가치가
-증명되게 되면 Andrew나 서브시스템 메인테이너는 그것을 메인라인에 포함시키기
-위하여 Linus에게 보낸다.
-
-커널 트리에 포함하고 싶은 모든 새로운 패치들은 Linus에게 보내지기 전에
--mm 트리에서 테스트를 하는 것을 적극 추천한다.
-
-이 커널들은 안정되게 사용할 시스템에서에 실행하는 것은 적합하지 않으며
-다른 브랜치들의 어떤 것들보다 위험하다.
-
-여러분이 커널 개발 프로세스를 돕길 원한다면 이 커널 배포들을 사용하고
-테스트한 후 어떤 문제를 발견하거나 또는 모든 것이 잘 동작한다면 리눅스
-커널 메일링 리스트로 피드백을 해달라.
-
-이 커널들은 일반적으로 모든 다른 실험적인 패치들과 배포될 당시의
-사용가능한 메인라인 -git 커널들의 몇몇 변경을 포함한다.
-
--mm 커널들은 정해진 일정대로 배포되지 않는다. 하지만 대개 몇몇 -mm 커널들은
-각 -rc 커널(1부터 3이 흔함) 사이에서 배포된다.
-
 서브시스템 커널 트리들과 패치들
 -------------------------------
-많은 다른 커널 서브시스템 개발자들은 커널의 다른 부분들에서 무슨 일이
-일어나고 있는지를 볼수 있도록 그들의 개발 트리를 공개한다. 이 트리들은
-위에서 설명하였던 것 처럼 -mm 커널 배포들로 합쳐진다.
-
-다음은  활용가능한 커널 트리들을 나열한다.
-  git trees:
-    - Kbuild development tree, Sam Ravnborg < sam@ravnborg.org>
-    git.kernel.org:/pub/scm/linux/kernel/git/sam/kbuild.git
-
-    - ACPI development tree, Len Brown <len.brown@intel.com >
-    git.kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
-
-    - Block development tree, Jens Axboe <jens.axboe@oracle.com>
-    git.kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
-
-    - DRM development tree, Dave Airlie <airlied@linux.ie>
-    git.kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
-
-    - ia64 development tree, Tony Luck < tony.luck@intel.com>
-    git.kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
-
-    - infiniband, Roland Dreier <rolandd@cisco.com >
-    git.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
-
-    - libata, Jeff Garzik <jgarzik@pobox.com>
-    git.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
-
-    - network drivers, Jeff Garzik <jgarzik@pobox.com>
-    git.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
-
-    - pcmcia, Dominik Brodowski < linux@dominikbrodowski.net>
-    git.kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
-
-    - SCSI, James Bottomley < James.Bottomley@SteelEye.com>
-    git.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
-
-  quilt trees:
-    - USB, PCI, Driver Core, and I2C, Greg Kroah-Hartman < gregkh@linuxfoundation.org>
-    kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
-    - x86-64, partly i386, Andi Kleen < ak@suse.de>
-        ftp.firstfloor.org:/pub/ak/x86_64/quilt/
-
-  다른 커널 트리들은 http://kernel.org/git와 MAINTAINERS 파일에서 참조할 수
-  있다.
+다양한 커널 서브시스템의 메인테이너들 --- 그리고 많은 커널 서브시스템 개발자들
+--- 은 그들의 현재 개발 상태를 소스 저장소로 노출한다. 이를 통해 다른 사람들도
+커널의 다른 영역에 어떤 변화가 이루어지고 있는지 알 수 있다. 급속히 개발이
+진행되는 영역이 있고 그렇지 않은 영역이 있으므로, 개발자는 다른 개발자가 제출한
+수정 사항과 자신의 수정사항의 충돌이나 동일한 일을 동시에 두사람이 따로
+진행하는 사태를 방지하기 위해 급속히 개발이 진행되고 있는 영역에 작업의
+베이스를 맞춰줄 것이 요구된다.
+
+대부분의 이러한 저장소는 git 트리지만, git이 아닌 SCM으로 관리되거나, quilt
+시리즈로 제공되는 패치들도 존재한다. 이러한 서브시스템 저장소들은 MAINTAINERS
+파일에 나열되어 있다. 대부분은 http://git.kernel.org 에서 볼 수 있다.
+
+제안된 패치는 서브시스템 트리에 커밋되기 전에 메일링 리스트를 통해
+리뷰된다(아래의 관련 섹션을 참고하기 바란다). 일부 커널 서브시스템의 경우, 이
+리뷰 프로세스는 patchwork라는 도구를 통해 추적된다. patchwork은 등록된 패치와
+패치에 대한 코멘트, 패치의 버전을 볼 수 있는 웹 인터페이스를 제공하고,
+메인테이너는 패치를 리뷰 중, 리뷰 통과, 또는 반려됨으로 표시할 수 있다.
+대부분의 이러한 patchwork 사이트는 http://patchwork.kernel.org/ 또는
+http://patchwork.ozlabs.org/ 에 나열되어 있다.
+
+3.x - 통합 테스트를 위한 next 커널 트리
+-----------------------------------------
+서브시스템 트리들의 변경사항들은 mainline 3.x 트리로 들어오기 전에 통합
+테스트를 거쳐야 한다. 이런 목적으로, 모든 서브시스템 트리의 변경사항을 거의
+매일 받아가는 특수한 테스트 저장소가 존재한다:
+       http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git
+       http://linux.f-seidel.de/linux-next/pmwiki/
+
+이런 식으로, -next 커널을 통해 다음 머지 기간에 메인라인 커널에 어떤 변경이
+가해질 것인지 간략히 알 수 있다. 모험심 강한 테스터라면 -next 커널에서 테스트를
+수행하는 것도 좋을 것이다.
 
 버그 보고
 ---------
-- 
1.8.1.2

