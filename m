Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894Ab3EWMwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:52:04 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:41684 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758335Ab3EWMwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:52:00 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: greg@kroah.com, rob@landley.net
Cc: Ben Minerds <PuZZleDucK@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] Documentation: Replacing references to broken perfect patch URL
Date: Thu, 23 May 2013 22:49:55 +1000
Message-Id: <42f2e378e1b0417c716f308915c76b30d1e26983.1369312746.git.PuZZleDucK@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1369312746.git.PuZZleDucK@gmail.com>
References: <cover.1369312746.git.PuZZleDucK@gmail.com>
In-Reply-To: <cover.1369312746.git.PuZZleDucK@gmail.com>
References: <cover.1369312746.git.PuZZleDucK@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Replacing refs to broken URL with internal documentation reference.

 Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
---
 Documentation/HOWTO                   | 4 ++--
 Documentation/SubmittingPatches       | 2 +-
 Documentation/ja_JP/HOWTO             | 4 ++--
 Documentation/ja_JP/SubmittingPatches | 2 +-
 Documentation/ko_KR/HOWTO             | 4 ++--
 Documentation/zh_CN/HOWTO             | 4 ++--
 Documentation/zh_CN/SubmittingPatches | 2 +-
 7 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index a9f288f..11e597e 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -112,7 +112,7 @@ required reading:
 
     Other excellent descriptions of how to create patches properly are:
 	"The Perfect Patch"
-		http://userweb.kernel.org/~akpm/stuff/tpp.txt
+		Documentation/development-process/patches/The-Perfect-Patch.txt
 	"Linux kernel patch submission format"
 		http://linux.yyz.us/patch-format.html
 
@@ -579,7 +579,7 @@ all time.  It should describe the patch completely, containing:
 For more details on what this should all look like, please see the
 ChangeLog section of the document:
   "The Perfect Patch"
-      http://userweb.kernel.org/~akpm/stuff/tpp.txt
+      Documentation/development-process/patches/The-Perfect-Patch.txt
 
 
 
diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 6e97e73..d59975f 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -715,7 +715,7 @@ SECTION 3 - REFERENCES
 ----------------------
 
 Andrew Morton, "The perfect patch" (tpp).
-  <http://userweb.kernel.org/~akpm/stuff/tpp.txt>
+  Documentation/development-process/patches/The-Perfect-Patch.txt
 
 Jeff Garzik, "Linux kernel patch submission format".
   <http://linux.yyz.us/patch-format.html>
diff --git a/Documentation/ja_JP/HOWTO b/Documentation/ja_JP/HOWTO
index 050d37f..365262d 100644
--- a/Documentation/ja_JP/HOWTO
+++ b/Documentation/ja_JP/HOWTO
@@ -149,7 +149,7 @@ linux-api@ver.kernel.org に送ることを勧めます。
      この他にパッチを作る方法についてのよくできた記述は-
 
 	"The Perfect Patch"
-		http://userweb.kernel.org/~akpm/stuff/tpp.txt
+		Documentation/development-process/patches/The-Perfect-Patch.txt
 	"Linux kernel patch submission format"
 		http://linux.yyz.us/patch-format.html
 
@@ -622,7 +622,7 @@ Linux カーネルコミュニティは、一度に大量のコードの塊を
 これについて全てがどのようにあるべきかについての詳細は、以下のドキュメ
 ントの ChangeLog セクションを見てください-
   "The Perfect Patch"
-      http://userweb.kernel.org/~akpm/stuff/tpp.txt
+      Documentation/development-process/patches/The-Perfect-Patch.txt
 
 これらのどれもが、時にはとても困難です。これらの慣例を完璧に実施するに
 は数年かかるかもしれません。これは継続的な改善のプロセスであり、そのた
diff --git a/Documentation/ja_JP/SubmittingPatches b/Documentation/ja_JP/SubmittingPatches
index 97f78dd..b688892 100644
--- a/Documentation/ja_JP/SubmittingPatches
+++ b/Documentation/ja_JP/SubmittingPatches
@@ -695,7 +695,7 @@ gcc においては、マクロと同じくらい軽いです。
 ----------------------
 
 Andrew Morton, "The perfect patch" (tpp).
-  <http://userweb.kernel.org/~akpm/stuff/tpp.txt>
+  Documentation/development-process/patches/The-Perfect-Patch.txt
 
 Jeff Garzik, "Linux kernel patch submission format".
   <http://linux.yyz.us/patch-format.html>
diff --git a/Documentation/ko_KR/HOWTO b/Documentation/ko_KR/HOWTO
index 2f48f20..18a6e61 100644
--- a/Documentation/ko_KR/HOWTO
+++ b/Documentation/ko_KR/HOWTO
@@ -122,7 +122,7 @@ mtk.manpages@gmail.com의 메인테이너에게 보낼 것을 권장한다.
 
     올바른 패치들을 만드는 법에 관한 훌륭한 다른 문서들이 있다.
     "The Perfect Patch"
-        http://userweb.kernel.org/~akpm/stuff/tpp.txt
+        Documentation/development-process/patches/The-Perfect-Patch.txt
     "Linux kernel patch submission format"
         http://linux.yyz.us/patch-format.html
 
@@ -596,7 +596,7 @@ Pat이라는 이름을 가진 여자가 있을 수도 있는 것이다. 리눅
 
 이것이 무엇인지 더 자세한 것을 알고 싶다면 다음 문서의 ChageLog 항을 봐라.
    "The Perfect Patch"
-    http://userweb.kernel.org/~akpm/stuff/tpp.txt
+    Documentation/development-process/patches/The-Perfect-Patch.txt
 
 
 
diff --git a/Documentation/zh_CN/HOWTO b/Documentation/zh_CN/HOWTO
index 7fba5aa..a55c358 100644
--- a/Documentation/zh_CN/HOWTO
+++ b/Documentation/zh_CN/HOWTO
@@ -112,7 +112,7 @@ Linux内核代码中包含有大量的文档。这些文档对于学习如何与
 
     其他关于如何正确地生成补丁的优秀文档包括：
     "The Perfect Patch"
-        http://userweb.kernel.org/~akpm/stuff/tpp.txt
+        Documentation/development-process/patches/The-Perfect-Patch.txt
     "Linux kernel patch submission format"
         http://linux.yyz.us/patch-format.html
 
@@ -515,7 +515,7 @@ Linux内核社区并不喜欢一下接收大段的代码。修改需要被恰当
 
 想了解它具体应该看起来像什么，请查阅以下文档中的“ChangeLog”章节：
   “The Perfect Patch”
-  	 http://userweb.kernel.org/~akpm/stuff/tpp.txt
+  	 Documentation/development-process/patches/The-Perfect-Patch.txt
 
 
 这些事情有时候做起来很难。要在任何方面都做到完美可能需要好几年时间。这是
diff --git a/Documentation/zh_CN/SubmittingPatches b/Documentation/zh_CN/SubmittingPatches
index 0f4385a..779a065 100644
--- a/Documentation/zh_CN/SubmittingPatches
+++ b/Documentation/zh_CN/SubmittingPatches
@@ -394,7 +394,7 @@ Static inline 函数相比宏来说，是好得多的选择。Static inline 函
 ----------------
 
 Andrew Morton, "The perfect patch" (tpp).
-  <http://userweb.kernel.org/~akpm/stuff/tpp.txt>
+  Documentation/development-process/patches/The-Perfect-Patch.txt
 
 Jeff Garzik, "Linux kernel patch submission format".
   <http://linux.yyz.us/patch-format.html>
-- 
1.8.1.2

