Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab3HLKt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:49:59 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:38860 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3HLKt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:49:58 -0400
From: "Lee, Jae-Hong" <pyrasis@gmail.com>
To: gregkh@suse.de
Cc: minchan@kernel.org, linux-kernel@vger.kernel.org,
        "Lee, Jae-Hong" <pyrasis@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=20v3=202/3=5D=20Type=20fix=20on=20stable=5Fapi=5Fnonsense=2Etxt?=
Date: Mon, 12 Aug 2013 19:49:25 +0900
Message-Id: <1376304566-10714-2-git-send-email-pyrasis@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376304566-10714-1-git-send-email-pyrasis@gmail.com>
References: <1376304566-10714-1-git-send-email-pyrasis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lee, Jae-Hong" <pyrasis@gmail.com>

This patch fixes some minor typos in Documentation/ko_KR/stable_api_nonsense.txt

Signed-off-by: Lee, Jae-Hong <pyrasis@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
---
 Documentation/ko_KR/stable_api_nonsense.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/ko_KR/stable_api_nonsense.txt b/Documentation/ko_KR/stable_api_nonsense.txt
index 8f2b0e1..51f85ad 100644
--- a/Documentation/ko_KR/stable_api_nonsense.txt
+++ b/Documentation/ko_KR/stable_api_nonsense.txt
@@ -106,12 +106,12 @@ Greg Kroah-Hartman <greg@kroah.com>
 ---------------------------------
 
 리눅스 커널 드라이버를 계속해서 메인 커널 트리에 반영하지 않고
-유지보수하려고 하는 사름들과 이 문제를 논의하게 되면 훨씬 더
+유지보수하려고 하는 사람들과 이 문제를 논의하게 되면 훨씬 더
 "논란의 여지가 많은" 주제가 될 것이다.
 
 리눅스 커널 개발은 끊임없이 빠른 속도로 이루어지고 있으며 결코
 느슨해진 적이 없다. 커널 개발자들이 현재 인터페이스들에서 버그를
-발견하거나 무엇인가 할수 있는 더 좋은 방법을 찾게 되었다고 하자.
+발견하거나 무엇인가 할 수 있는 더 좋은 방법을 찾게 되었다고 하자.
 그들이 발견한 것을 실행한다면 아마도 더 잘 동작하도록 현재 인터페이스들을
 수정하게 될 것이다. 그들이 그런 일을 하게되면 함수 이름들은 변하게 되고,
 구조체들은 늘어나거나 줄어들게 되고, 함수 파라미터들은 재작업될 것이다.
@@ -174,7 +174,7 @@ GPL을 따르는 배포 드라이버에 관해 얘기하고 있다는 것을 상
 동작하는 것을 보장한다.
 
 메인 커널 트리에 여러분의 드라이버를 반영하면 얻게 되는 장점들은 다음과 같다.
-   - 관리의 드는 비용(원래 개발자의)은 줄어줄면서 드라이버의 질은 향상될 것이다.
+   - 관리에 드는 비용(원래 개발자의)은 줄어줄면서 드라이버의 질은 향상될 것이다.
    - 다른 개발자들이 여러분의 드라이버에 기능들을 추가 할 것이다.
    - 다른 사람들은 여러분의 드라이버에 버그를 발견하고 수정할 것이다.
    - 다른 사람들은 여러분의 드라이버의 개선점을 찾을 줄 것이다.
-- 
1.7.10.4

