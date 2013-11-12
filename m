Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab3KLN5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 08:57:10 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:33291 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753327Ab3KLNyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 08:54:10 -0500
From: <srinivas.kandagatla@st.com>
To: <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, <stephen.gallimore@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@stlinux.com>, <linux-pm@vger.kernel.org>
Subject: [PATCH RFC 06/10] ARM: STi: Add reset controller support to mach-sti Kconfig
Date: Tue, 12 Nov 2013 13:52:51 +0000
Message-ID: <1384264371-7568-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1384264311-7308-1-git-send-email-srinivas.kandagatla@st.com>
References: <1384264311-7308-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Gallimore <stephen.gallimore@st.com>

This patch selects reset controller support for ARCH_STI and
selects the reset controllers for STiH415 and STiH416 SoCs.

Signed-off-by: Stephen Gallimore <stephen.gallimore@st.com>
---
 arch/arm/mach-sti/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-sti/Kconfig b/arch/arm/mach-sti/Kconfig
index 835833e..b7c527e 100644
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
 	  Electronics family StiH415 parts, primarily targetted at set-top-box
@@ -37,6 +39,7 @@ config SOC_STIH415
 config SOC_STIH416
 	bool "STiH416 STMicroelectronics Consumer Electronics family"
 	default y
+	select STIH416_RESET
 	help
 	  This enables support for STMicroelectronics Digital Consumer
 	  Electronics family StiH416 parts, primarily targetted at set-top-box
-- 
1.7.6.5

