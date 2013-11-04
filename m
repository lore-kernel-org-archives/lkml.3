Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab3KDIjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 03:39:00 -0500
Received: from top.free-electrons.com ([176.31.233.9]:60989 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751519Ab3KDIi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 03:38:59 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: benh@kernel.crashing.org, paulus@samba.org, galak@kernel.crashing.org,
        vitb@kernel.crashing.org, marcelo@kvack.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] powerpc: remove unused REDBOOT Kconfig parameter
Date: Mon,  4 Nov 2013 09:38:56 +0100
Message-Id: <1383554336-3829-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the REDBOOT Kconfig parameter,
which was no longer used anywhere in the source code
and Makefiles.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/powerpc/Kconfig                | 3 ---
 arch/powerpc/platforms/83xx/Kconfig | 1 -
 arch/powerpc/platforms/8xx/Kconfig  | 1 -
 3 files changed, 5 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 38f3b7e47ec5..f02a41935c95 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -205,9 +205,6 @@ config DEFAULT_UIMAGE
 	  Used to allow a board to specify it wants a uImage built by default
 	default n
 
-config REDBOOT
-	bool
-
 config ARCH_HIBERNATION_POSSIBLE
 	bool
 	default y
diff --git a/arch/powerpc/platforms/83xx/Kconfig b/arch/powerpc/platforms/83xx/Kconfig
index 670a033264c0..2bdc8c862c46 100644
--- a/arch/powerpc/platforms/83xx/Kconfig
+++ b/arch/powerpc/platforms/83xx/Kconfig
@@ -99,7 +99,6 @@ config SBC834x
 config ASP834x
 	bool "Analogue & Micro ASP 834x"
 	select PPC_MPC834x
-	select REDBOOT
 	help
 	  This enables support for the Analogue & Micro ASP 83xx
 	  board.
diff --git a/arch/powerpc/platforms/8xx/Kconfig b/arch/powerpc/platforms/8xx/Kconfig
index 8dec3c0911ad..bd6f1a1cf922 100644
--- a/arch/powerpc/platforms/8xx/Kconfig
+++ b/arch/powerpc/platforms/8xx/Kconfig
@@ -45,7 +45,6 @@ config PPC_EP88XC
 config PPC_ADDER875
 	bool "Analogue & Micro Adder 875"
 	select CPM1
-	select REDBOOT
 	help
 	  This enables support for the Analogue & Micro Adder 875
 	  board.
-- 
1.8.1.2

