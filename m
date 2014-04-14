Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750975AbaDNG4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 02:56:43 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:52920 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaDNG4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 02:56:42 -0400
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: [PATCH] .gitignore: ignore Module.symvers in all directories
Date: Mon, 14 Apr 2014 14:56:15 +0800
Message-Id: <415f152dbdb6d675ebca57afd8bfbc785a70cfd1.1397458539.git.gamerh2o@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using `make M=/path/to/driver modules` to build a module, file
Module.symvers will be created in that directory, so it's better to
ignore it in all directories.

Slightly reordered, let specific file names behind general ones.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 .gitignore | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/.gitignore b/.gitignore
index 7e9932e..3aa8145 100644
--- a/.gitignore
+++ b/.gitignore
@@ -22,7 +22,6 @@
 *.lst
 *.symtypes
 *.order
-modules.builtin
 *.elf
 *.bin
 *.gz
@@ -33,6 +32,8 @@ modules.builtin
 *.lzo
 *.patch
 *.gcno
+modules.builtin
+Module.symvers
 
 #
 # Top-level generic files
@@ -44,7 +45,6 @@ modules.builtin
 /vmlinuz
 /System.map
 /Module.markers
-/Module.symvers
 
 #
 # Debian directory (make deb-pkg)
-- 
1.9.0

