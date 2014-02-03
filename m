Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbaBCOgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 09:36:09 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:53068 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845AbaBCOgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 09:36:04 -0500
From: <srinivas.kandagatla@st.com>
To: <linux-arm-kernel@lists.infradead.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@stlinux.com>, Arnd Bergmann <arnd@arndb.de>,
        <stephen.gallimore@st.com>, Olof Johansson <olof@lixom.net>
Subject: [PATCH v2 6/6] ARM: STi: Add reset controller support to mach-sti Kconfig
Date: Mon, 3 Feb 2014 14:29:04 +0000
Message-ID: <1391437744-12184-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391437665-11913-1-git-send-email-srinivas.kandagatla@st.com>
References: <1391437665-11913-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Gallimore <stephen.gallimore@st.com>

This patch selects reset controller support for ARCH_STI and
selects the reset controllers for STiH415 and STiH416 SoCs.

Signed-off-by: Stephen Gallimore <stephen.gallimore@st.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 arch/arm/mach-sti/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-sti/Kconfig b/arch/arm/mach-sti/Kconfig
index d71654b..2550620 100644
--- a/arch/arm/mach-sti/Kconfig
+++ b/arch/arm/mach-sti/Kconfig
@@ -7,6 +7,7 @@ menuconfig ARCH_STI
 	select PINCTRL
 	select PINCTRL_ST
 	select MFD_SYSCON
+	select ARCH_HAS_RESET_CONTROLLER
 	select MIGHT_HAVE_CACHE_L2X0
 	select HAVE_SMP
 	select HAVE_ARM_SCU if SMP
@@ -28,6 +29,7 @@ if ARCH_STI
 config SOC_STIH415
 	bool "STiH415 STMicroelectronics Consumer Electronics family"
 	default y
+	select STIH415_RESET
 	help
 	  This enables support for STMicroelectronics Digital Consumer
 	  Electronics family StiH415 parts, primarily targeted at set-top-box
@@ -37,6 +39,7 @@ config SOC_STIH415
 config SOC_STIH416
 	bool "STiH416 STMicroelectronics Consumer Electronics family"
 	default y
+	select STIH416_RESET
 	help
 	  This enables support for STMicroelectronics Digital Consumer
 	  Electronics family StiH416 parts, primarily targeted at set-top-box
-- 
1.7.9.5

