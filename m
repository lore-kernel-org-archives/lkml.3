Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaAOMPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 07:15:52 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:20151
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751253AbaAOMPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 07:15:47 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h2487h1155h)
From: Prabhakar Kushwaha <prabhakar@freescale.com>
To: <arnd@arndb.de>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <scottwood@freescale.com>,
        Prabhakar Kushwaha <prabhakar@freescale.com>
Subject: [PATCH 2/2][v2] powerpc/config: Enable memory driver
Date: Wed, 15 Jan 2014 17:43:47 +0530
Message-ID: <1389788027-25476-1-git-send-email-prabhakar@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Freescale IFC controller has been moved to driver to driver/memory.

So enable memory driver in powerpc config

Signed-off-by: Prabhakar Kushwaha <prabhakar@freescale.com>
---
 changes for v2: Sending as it is

 arch/powerpc/configs/corenet32_smp_defconfig |    1 +
 arch/powerpc/configs/corenet64_smp_defconfig |    1 +
 arch/powerpc/configs/mpc85xx_defconfig       |    1 +
 arch/powerpc/configs/mpc85xx_smp_defconfig   |    1 +
 4 files changed, 4 insertions(+)

diff --git a/arch/powerpc/configs/corenet32_smp_defconfig b/arch/powerpc/configs/corenet32_smp_defconfig
index bbd794d..087d437 100644
--- a/arch/powerpc/configs/corenet32_smp_defconfig
+++ b/arch/powerpc/configs/corenet32_smp_defconfig
@@ -142,6 +142,7 @@ CONFIG_RTC_DRV_DS3232=y
 CONFIG_RTC_DRV_CMOS=y
 CONFIG_UIO=y
 CONFIG_STAGING=y
+CONFIG_MEMORY=y
 CONFIG_VIRT_DRIVERS=y
 CONFIG_FSL_HV_MANAGER=y
 CONFIG_EXT2_FS=y
diff --git a/arch/powerpc/configs/corenet64_smp_defconfig b/arch/powerpc/configs/corenet64_smp_defconfig
index 63508dd..25b03f8 100644
--- a/arch/powerpc/configs/corenet64_smp_defconfig
+++ b/arch/powerpc/configs/corenet64_smp_defconfig
@@ -129,6 +129,7 @@ CONFIG_EDAC=y
 CONFIG_EDAC_MM_EDAC=y
 CONFIG_DMADEVICES=y
 CONFIG_FSL_DMA=y
+CONFIG_MEMORY=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 CONFIG_ISO9660_FS=m
diff --git a/arch/powerpc/configs/mpc85xx_defconfig b/arch/powerpc/configs/mpc85xx_defconfig
index d2e0fab..87aad6d 100644
--- a/arch/powerpc/configs/mpc85xx_defconfig
+++ b/arch/powerpc/configs/mpc85xx_defconfig
@@ -213,6 +213,7 @@ CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_CMOS=y
 CONFIG_DMADEVICES=y
 CONFIG_FSL_DMA=y
+CONFIG_MEMORY=y
 # CONFIG_NET_DMA is not set
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
diff --git a/arch/powerpc/configs/mpc85xx_smp_defconfig b/arch/powerpc/configs/mpc85xx_smp_defconfig
index 4cb7b59..d5d6915 100644
--- a/arch/powerpc/configs/mpc85xx_smp_defconfig
+++ b/arch/powerpc/configs/mpc85xx_smp_defconfig
@@ -214,6 +214,7 @@ CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_CMOS=y
 CONFIG_DMADEVICES=y
 CONFIG_FSL_DMA=y
+CONFIG_MEMORY=y
 # CONFIG_NET_DMA is not set
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
-- 
1.7.9.5



