Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab3FUKn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 06:43:59 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:57414 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754067Ab3FUKn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 06:43:56 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@stlinux.com,
        Arnd Bergmann <arnd@arndb.de>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH v4 5/7] ARM:stixxxx: Add stixxxx options to  multi_v7_defconfig
Date: Fri, 21 Jun 2013 11:39:35 +0100
Message-Id: <1371811175-27409-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1371811076-27168-1-git-send-email-srinivas.kandagatla@st.com>
References: <1371811076-27168-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch adds stih415 and stih416 support to multi_v7_defconfig.
CONFIG_ARM_ERRATA_754322 is removed as it is selected by the stixxxx
mach level kconfig.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 arch/arm/configs/multi_v7_defconfig |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index f2b4957..c0cfac0 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -9,11 +9,11 @@ CONFIG_PLAT_SPEAR=y
 CONFIG_ARCH_SPEAR13XX=y
 CONFIG_MACH_SPEAR1310=y
 CONFIG_MACH_SPEAR1340=y
+CONFIG_ARCH_STIXXXX=y
 CONFIG_ARCH_SUNXI=y
 CONFIG_ARCH_SIRF=y
 CONFIG_ARCH_WM8850=y
 CONFIG_ARCH_ZYNQ=y
-CONFIG_ARM_ERRATA_754322=y
 CONFIG_SMP=y
 CONFIG_AEABI=y
 CONFIG_HIGHMEM=y
@@ -43,6 +43,8 @@ CONFIG_SERIAL_SIRFSOC_CONSOLE=y
 CONFIG_SERIAL_VT8500=y
 CONFIG_SERIAL_VT8500_CONSOLE=y
 CONFIG_SERIAL_OF_PLATFORM=y
+CONFIG_SERIAL_ST_ASC=y
+CONFIG_SERIAL_ST_ASC_CONSOLE=y
 CONFIG_IPMI_HANDLER=y
 CONFIG_IPMI_SI=y
 CONFIG_I2C=y
-- 
1.7.6.5

