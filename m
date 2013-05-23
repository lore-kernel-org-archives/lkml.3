Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946Ab3EWMwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:52:15 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64680 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758335Ab3EWMwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:52:10 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: greg@kroah.com, rob@landley.net
Cc: Ben Minerds <PuZZleDucK@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] Documentation: Replacing reference to broken submission format URL
Date: Thu, 23 May 2013 22:49:57 +1000
Message-Id: <b8531ed3e293a3dd41f5d62f02229c7dbf279a5a.1369312746.git.PuZZleDucK@gmail.com>
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

 Replacing refs to broken URL with internal documentation reference, and a
 little whitespace shuffle to keep it under 80 chars wide.

 Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
---
 Documentation/HOWTO                   | 10 +++++-----
 Documentation/SubmittingPatches       |  2 +-
 Documentation/ja_JP/HOWTO             |  8 ++++----
 Documentation/ja_JP/SubmittingPatches |  2 +-
 Documentation/ko_KR/HOWTO             |  2 +-
 Documentation/zh_CN/HOWTO             |  2 +-
 Documentation/zh_CN/SubmittingPatches |  2 +-
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index 11e597e..fba34c0 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -110,11 +110,11 @@ required reading:
     subject to scrutiny for content and style), but not following them
     will almost always prevent it.
 
-    Other excellent descriptions of how to create patches properly are:
-	"The Perfect Patch"
-		Documentation/development-process/patches/The-Perfect-Patch.txt
-	"Linux kernel patch submission format"
-		http://linux.yyz.us/patch-format.html
+  Other excellent descriptions of how to create patches properly are:
+    "The Perfect Patch"
+      Documentation/development-process/patches/The-Perfect-Patch.txt
+    "Linux kernel patch submission format"
+      Documentation/development-process/patches/Patch-Submission-Format.txt
 
   Documentation/stable_api_nonsense.txt
     This file describes the rationale behind the conscious decision to
diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index d59975f..8cd0e1e 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -718,7 +718,7 @@ Andrew Morton, "The perfect patch" (tpp).
   Documentation/development-process/patches/The-Perfect-Patch.txt
 
 Jeff Garzik, "Linux kernel patch submission format".
-  <http://linux.yyz.us/patch-format.html>
+  Documentation/development-process/patches/Patch-Submission-Format.txt
 
 Greg Kroah-Hartman, "How to piss off a kernel subsystem maintainer".
   <http://www.kroah.com/log/linux/maintainer.html>
diff --git a/Documentation/ja_JP/HOWTO b/Documentation/ja_JP/HOWTO
index 365262d..98a74a2 100644
--- a/Documentation/ja_JP/HOWTO
+++ b/Documentation/ja_JP/HOWTO
@@ -148,10 +148,10 @@ linux-api@ver.kernel.org に送ることを勧めます。
 
      この他にパッチを作る方法についてのよくできた記述は-
 
-	"The Perfect Patch"
-		Documentation/development-process/patches/The-Perfect-Patch.txt
-	"Linux kernel patch submission format"
-		http://linux.yyz.us/patch-format.html
+    "The Perfect Patch"
+      Documentation/development-process/patches/The-Perfect-Patch.txt
+    "Linux kernel patch submission format"
+      Documentation/development-process/patches/Patch-Submission-Format.txt
 
   Documentation/stable_api_nonsense.txt
      このファイルはカーネルの中に不変のAPIを持たないことにした意識的な
diff --git a/Documentation/ja_JP/SubmittingPatches b/Documentation/ja_JP/SubmittingPatches
index b688892..e9b2cc5 100644
--- a/Documentation/ja_JP/SubmittingPatches
+++ b/Documentation/ja_JP/SubmittingPatches
@@ -698,7 +698,7 @@ Andrew Morton, "The perfect patch" (tpp).
   Documentation/development-process/patches/The-Perfect-Patch.txt
 
 Jeff Garzik, "Linux kernel patch submission format".
-  <http://linux.yyz.us/patch-format.html>
+  Documentation/development-process/patches/Patch-Submission-Format.txt
 
 Greg Kroah-Hartman, "How to piss off a kernel subsystem maintainer".
   <http://www.kroah.com/log/2005/03/31/>
diff --git a/Documentation/ko_KR/HOWTO b/Documentation/ko_KR/HOWTO
index 18a6e61..518497f 100644
--- a/Documentation/ko_KR/HOWTO
+++ b/Documentation/ko_KR/HOWTO
@@ -124,7 +124,7 @@ mtk.manpages@gmail.com의 메인테이너에게 보낼 것을 권장한다.
     "The Perfect Patch"
         Documentation/development-process/patches/The-Perfect-Patch.txt
     "Linux kernel patch submission format"
-        http://linux.yyz.us/patch-format.html
+        Documentation/development-process/patches/Patch-Submission-Format.txt
 
    Documentation/stable_api_nonsense.txt
     이 문서는 의도적으로 커널이 불변하는 API를 갖지 않도록 결정한
diff --git a/Documentation/zh_CN/HOWTO b/Documentation/zh_CN/HOWTO
index a55c358..21860d1 100644
--- a/Documentation/zh_CN/HOWTO
+++ b/Documentation/zh_CN/HOWTO
@@ -114,7 +114,7 @@ Linux内核代码中包含有大量的文档。这些文档对于学习如何与
     "The Perfect Patch"
         Documentation/development-process/patches/The-Perfect-Patch.txt
     "Linux kernel patch submission format"
-        http://linux.yyz.us/patch-format.html
+        Documentation/development-process/patches/Patch-Submission-Format.txt
 
   Documentation/stable_api_nonsense.txt
     论证内核为什么特意不包括稳定的内核内部API，也就是说不包括像这样的特
diff --git a/Documentation/zh_CN/SubmittingPatches b/Documentation/zh_CN/SubmittingPatches
index 779a065..37e9303 100644
--- a/Documentation/zh_CN/SubmittingPatches
+++ b/Documentation/zh_CN/SubmittingPatches
@@ -397,7 +397,7 @@ Andrew Morton, "The perfect patch" (tpp).
   Documentation/development-process/patches/The-Perfect-Patch.txt
 
 Jeff Garzik, "Linux kernel patch submission format".
-  <http://linux.yyz.us/patch-format.html>
+  Documentation/development-process/patches/Patch-Submission-Format.txt
 
 Greg Kroah-Hartman, "How to piss off a kernel subsystem maintainer".
   <http://www.kroah.com/log/2005/03/31/>
-- 
1.8.1.2

