Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964842Ab3BHKqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 05:46:54 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:52922 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964774Ab3BHKqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 05:46:51 -0500
From: Vijay Kumar Mishra <vijay.kumar@st.com>
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: <spear-devel@codex.cro.st.com>, <viresh.kumar@linaro.org>,
        Vijay Kumar Mishra <vijay.kumar@st.com>
Subject: [PATCH 1/3] SPEAr13xx_defconfig: Enable Memory split 2G/2G needed
Date: Fri, 8 Feb 2013 16:16:29 +0530
Message-ID: <6cebd9755011670ecaeec7930b3fa7ed0f16b3b6.1360317993.git.vijay.kumar@st.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <cover.1360317993.git.vijay.kumar@st.com>
References: <cover.1360317993.git.vijay.kumar@st.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory split 2G/2G is enabled as needed for SPEAr1310 RevC board to boot.
Before enabling this option the boot was hanging at uncompressing linux.
---
 arch/arm/configs/spear13xx_defconfig |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/configs/spear13xx_defconfig b/arch/arm/configs/spear13xx_defconfig
index 1fdb826..1b5ceff 100644
--- a/arch/arm/configs/spear13xx_defconfig
+++ b/arch/arm/configs/spear13xx_defconfig
@@ -14,13 +14,13 @@ CONFIG_MACH_SPEAR1340=y
 CONFIG_SMP=y
 # CONFIG_SMP_ON_UP is not set
 # CONFIG_ARM_CPU_TOPOLOGY is not set
+CONFIG_VMSPLIT_2G=y
 CONFIG_ARM_APPENDED_DTB=y
 CONFIG_ARM_ATAG_DTB_COMPAT=y
 CONFIG_BINFMT_MISC=y
 CONFIG_NET=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_NAND=y
@@ -62,9 +62,7 @@ CONFIG_GPIO_PL061=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
 CONFIG_MPCORE_WATCHDOG=y
-# CONFIG_HID_SUPPORT is not set
 CONFIG_USB=y
-# CONFIG_USB_DEVICE_CLASS is not set
 CONFIG_USB_EHCI_HCD=y
 CONFIG_USB_OHCI_HCD=y
 CONFIG_MMC=y
-- 
1.7.9.5

