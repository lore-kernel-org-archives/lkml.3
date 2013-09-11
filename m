Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab3IKLCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:02:43 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36926 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab3IKLCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:02:41 -0400
From: Koen Kooi <koen@dominion.thruhere.net>
To: linux-omap@vger.kernel.org
Cc: bcousson@baylibre.com, tony@atomide.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>
Subject: [PATCHv2 0/2] ARM: dts: Beaglebone MMC fixes
Date: Wed, 11 Sep 2013 13:02:25 +0200
Message-Id: <1378897347-11840-1-git-send-email-koen@dominion.thruhere.net>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are two patches to fix MMC on beaglebone, one fixes card detect on BBW,
the other adds the eMMC entry for BBB and its fixed regulator.

This series depends on:

http://comments.gmane.org/gmane.linux.kernel.stable/63648
https://lkml.org/lkml/2013/9/10/454
http://comments.gmane.org/gmane.linux.kernel.mmc/22381

Or as git-cherry would put it:

[koen@rrMBP patches]$ git cherry -v
+ c8436cd15251ea42c7f2decd1cc972de536a7573 ARM: OMAP2+: am335x-bone*: add DT for BeagleBone Black
+ 34596cb58346612101b168b34b7ee75b8b0e9500 ARM: EDMA: Fix clearing of unused list for DT DMA resources
+ af7f273dfbeeec7669c01a81b8c02f4af2fcf1b9 ARM: dts: add AM33XX EDMA support
+ a85f9acc8f48a7cb1a07fb93fcba7bd43aa9c853 ARM: dts: add AM33XX SPI DMA support
+ 72a42fa0b42051251c554d9f75f42b3e9bc6ec8a ARM: dts: add AM33XX MMC support and documentation
+ 93205a3735613d674b209c3c75ad3e0a7d6be136 arm: bone: dts: add CD for mmc1
+ b1bd98705a2da3d02f197d29ca040008ad8c662c am335x-boneblack: add eMMC DT entry

Also available as a git branch at https://github.com/koenkooi/linux/commits/mainline

Changes since v1:
	Removed ti,non-removable entry from eMMC node, see http://marc.info/?l=linux-arm-kernel&m=137889435710552&w=2
---

Alexander Holler (1):
  arm: bone: dts: add CD for mmc1

Koen Kooi (1):
  am335x-boneblack: add eMMC DT entry

 arch/arm/boot/dts/am335x-bone-common.dtsi | 21 +++++++++++++++++++++
 arch/arm/boot/dts/am335x-bone.dts         |  4 ----
 arch/arm/boot/dts/am335x-boneblack.dts    | 15 +++++++++++++++
 3 files changed, 36 insertions(+), 4 deletions(-)

-- 
1.8.2.1

