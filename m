Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaBPTF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 14:05:28 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:52461 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752987AbaBPTF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 14:05:27 -0500
Message-ID: <1392577524.28866.32.camel@x220>
Subject: [PATCH] arm: sti: Remove SOC_STIH415 and SOC_STIH416
From: Paul Bolle <pebolle@tiscali.nl>
To: Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: Richard Weinberger <richard@nod.at>, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, linux-kernel@vger.kernel.org
Date: Sun, 16 Feb 2014 20:05:24 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2014 19:05:25.0308 (UTC) FILETIME=[0C6D07C0:01CF2B4A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbols SOC_STIH415 and SOC_STIH416 were added in v3.11.
They have never been used. They default to "y" but nothing cares. They
can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "git grep".

 arch/arm/mach-sti/Kconfig | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/arch/arm/mach-sti/Kconfig b/arch/arm/mach-sti/Kconfig
index d71654b..c360ae1 100644
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
-	  Electronics family StiH415 parts, primarily targeted at set-top-box
-	  and other digital audio/video applications using Flattned Device
-	  Trees.
-
-config SOC_STIH416
-	bool "STiH416 STMicroelectronics Consumer Electronics family"
-	default y
-	help
-	  This enables support for STMicroelectronics Digital Consumer
-	  Electronics family StiH416 parts, primarily targeted at set-top-box
-	  and other digital audio/video applications using Flattened Device
-	  Trees.
-
-endif
-- 
1.8.5.3

