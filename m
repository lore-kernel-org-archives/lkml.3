Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab3IRDXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 23:23:50 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35198 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751020Ab3IRDXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 23:23:49 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: srinivas.kandagatla@st.com, stuart.menefy@st.com
Cc: linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ARM: STi: remove unused Kconfig parameters
Date: Wed, 18 Sep 2013 05:23:42 +0200
Message-Id: <1379474622-4715-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the 'SOC_STIH415' and 'SOC_STIH416'
parameters, which are used nowhere else in the source code
and Makefiles.

Will they be needed in code that hasn't been submitted yet?

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/mach-sti/Kconfig | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/arch/arm/mach-sti/Kconfig b/arch/arm/mach-sti/Kconfig
index 835833e..bef1a9f 100644
--- a/arch/arm/mach-sti/Kconfig
+++ b/arch/arm/mach-sti/Kconfig
@@ -21,26 +21,3 @@ menuconfig ARCH_STI
 	  for discovery
 	  More information at Documentation/arm/STiH41x and
 	  at Documentation/devicetree
-
-
-if ARCH_STI
-
-config SOC_STIH415
-	bool "STiH415 STMicroelectronics Consumer Electronics family"
-	default y
-	help
-	  This enables support for STMicroelectronics Digital Consumer
-	  Electronics family StiH415 parts, primarily targetted at set-top-box
-	  and other digital audio/video applications using Flattned Device
-	  Trees.
-
-config SOC_STIH416
-	bool "STiH416 STMicroelectronics Consumer Electronics family"
-	default y
-	help
-	  This enables support for STMicroelectronics Digital Consumer
-	  Electronics family StiH416 parts, primarily targetted at set-top-box
-	  and other digital audio/video applications using Flattened Device
-	  Trees.
-
-endif
-- 
1.8.1.2

