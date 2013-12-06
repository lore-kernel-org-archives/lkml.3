Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab3LFJFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:05:48 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:63297 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892Ab3LFJFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:05:38 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: gregkh@linuxfoundation.org
Cc: minchan@kernel.org, pyrasis@gamil.com, harryxiyou@gmail.com,
        tshibata@ab.jp.nec.com, rob@landley.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 4/4] Documentation: ja_JP: Update broken link to tpp
Date: Fri,  6 Dec 2013 18:04:45 +0900
Message-Id: <1386320685-28484-4-git-send-email-sj38.park@gmail.com>
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
 Documentation/ja_JP/HOWTO | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/ja_JP/HOWTO b/Documentation/ja_JP/HOWTO
index 8148a47..0091a82 100644
--- a/Documentation/ja_JP/HOWTO
+++ b/Documentation/ja_JP/HOWTO
@@ -149,7 +149,7 @@ linux-api@ver.kernel.org に送ることを勧めます。
      この他にパッチを作る方法についてのよくできた記述は-
 
 	"The Perfect Patch"
-		http://userweb.kernel.org/~akpm/stuff/tpp.txt
+		http://www.ozlabs.org/~akpm/stuff/tpp.txt
 	"Linux kernel patch submission format"
 		http://linux.yyz.us/patch-format.html
 
@@ -622,7 +622,7 @@ Linux カーネルコミュニティは、一度に大量のコードの塊を
 これについて全てがどのようにあるべきかについての詳細は、以下のドキュメ
 ントの ChangeLog セクションを見てください-
   "The Perfect Patch"
-      http://userweb.kernel.org/~akpm/stuff/tpp.txt
+      http://www.ozlabs.org/~akpm/stuff/tpp.txt
 
 これらのどれもが、時にはとても困難です。これらの慣例を完璧に実施するに
 は数年かかるかもしれません。これは継続的な改善のプロセスであり、そのた
-- 
1.8.1.2

