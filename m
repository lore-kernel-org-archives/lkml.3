Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab3A2Pdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:33:50 -0500
Received: from mercuryimc.plus.com ([80.229.200.144]:55794 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753857Ab3A2Pds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:33:48 -0500
X-Greylist: delayed 1812 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2013 10:33:48 EST
Message-ID: <5107E4C7.6000008@mimc.co.uk>
Date: Tue, 29 Jan 2013 15:03:35 +0000
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: ARM: OMAP2+: omap2plus_defconfig: enable omap1 rtc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BeagleBone dev kit uses the built-in RTC module, so
it would be nice to have this built by default in the
omap2plus defconfig.

Signed-off-by: Mark Jackson <mpfj@newflow.co.uk>
---
 arch/arm/configs/omap2plus_defconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index 82ce8d7..d852775 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -199,6 +199,7 @@ CONFIG_MMC_OMAP_HS=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_TWL92330=y
 CONFIG_RTC_DRV_TWL4030=y
+CONFIG_RTC_DRV_OMAP=y
 CONFIG_DMADEVICES=y
 CONFIG_DMA_OMAP=y
 CONFIG_EXT2_FS=y
