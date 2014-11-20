Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbaKTXlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 18:41:47 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:62251 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117AbaKTXlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 18:41:46 -0500
From: Anjana Sasindran <anjanasasindran123@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Anjana Sasindran <anjanasasindran123@gmail.com>
Subject: [PATCH] Staging:skein: Fix trailing  whitespace error
Date: Fri, 21 Nov 2014 05:11:27 +0530
Message-Id: <1416526887-8566-1-git-send-email-anjanasasindran123@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch.pl error:

ERROR: trailing whitespace

Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
---
 arch/arm/boot/dts/include/dt-bindings   | 1 -
 arch/metag/boot/dts/include/dt-bindings | 1 -
 arch/mips/boot/dts/include/dt-bindings  | 1 -
 drivers/staging/skein/skein_generic.c   | 2 --
 4 files changed, 5 deletions(-)
 delete mode 120000 arch/arm/boot/dts/include/dt-bindings
 delete mode 120000 arch/metag/boot/dts/include/dt-bindings
 delete mode 120000 arch/mips/boot/dts/include/dt-bindings

diff --git a/arch/arm/boot/dts/include/dt-bindings b/arch/arm/boot/dts/include/dt-bindings
deleted file mode 120000
index 08c00e4..0000000
--- a/arch/arm/boot/dts/include/dt-bindings
+++ /dev/null
@@ -1 +0,0 @@
-../../../../../include/dt-bindings
\ No newline at end of file
diff --git a/arch/metag/boot/dts/include/dt-bindings b/arch/metag/boot/dts/include/dt-bindings
deleted file mode 120000
index 08c00e4..0000000
--- a/arch/metag/boot/dts/include/dt-bindings
+++ /dev/null
@@ -1 +0,0 @@
-../../../../../include/dt-bindings
\ No newline at end of file
diff --git a/arch/mips/boot/dts/include/dt-bindings b/arch/mips/boot/dts/include/dt-bindings
deleted file mode 120000
index 08c00e4..0000000
--- a/arch/mips/boot/dts/include/dt-bindings
+++ /dev/null
@@ -1 +0,0 @@
-../../../../../include/dt-bindings
\ No newline at end of file
diff --git a/drivers/staging/skein/skein_generic.c b/drivers/staging/skein/skein_generic.c
index 60d16b6..7096d5a 100644
--- a/drivers/staging/skein/skein_generic.c
+++ b/drivers/staging/skein/skein_generic.c
@@ -190,8 +190,6 @@ static int __init skein_generic_init(void)
 		goto unreg512;
 
 	return 0;
-
-		
 unreg512:
 	crypto_unregister_shash(&alg512);
 unreg256:
-- 
1.9.1

