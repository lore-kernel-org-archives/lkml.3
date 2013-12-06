Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab3LFJGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:06:21 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34020 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106Ab3LFJFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:05:30 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: gregkh@linuxfoundation.org
Cc: minchan@kernel.org, pyrasis@gamil.com, harryxiyou@gmail.com,
        tshibata@ab.jp.nec.com, rob@landley.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 2/4] Documentation: ko_KR: Update broken link to tpp
Date: Fri,  6 Dec 2013 18:04:43 +0900
Message-Id: <1386320685-28484-2-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386320685-28484-1-git-send-email-sj38.park@gmail.com>
References: <1386320685-28484-1-git-send-email-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Links for 'The Perfect Patch' which described on HOWTO document is
broken. Change those links to the copy at ozlabs.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 Documentation/ko_KR/HOWTO | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/ko_KR/HOWTO b/Documentation/ko_KR/HOWTO
index 680e646..d61a45a 100644
--- a/Documentation/ko_KR/HOWTO
+++ b/Documentation/ko_KR/HOWTO
@@ -122,7 +122,7 @@ mtk.manpages@gmail.com의 메인테이너에게 보낼 것을 권장한다.
 
     올바른 패치들을 만드는 법에 관한 훌륭한 다른 문서들이 있다.
     "The Perfect Patch"
-        http://userweb.kernel.org/~akpm/stuff/tpp.txt
+        http://www.ozlabs.org/~akpm/stuff/tpp.txt
     "Linux kernel patch submission format"
         http://linux.yyz.us/patch-format.html
 
@@ -597,7 +597,7 @@ Pat이라는 이름을 가진 여자가 있을 수도 있는 것이다. 리눅
 
 이것이 무엇인지 더 자세한 것을 알고 싶다면 다음 문서의 ChageLog 항을 봐라.
    "The Perfect Patch"
-    http://userweb.kernel.org/~akpm/stuff/tpp.txt
+    http://www.ozlabs.org/~akpm/stuff/tpp.txt
 
 
 
-- 
1.8.1.2

