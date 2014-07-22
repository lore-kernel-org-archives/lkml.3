Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbaGVTan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:30:43 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44380 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbaGVTal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:30:41 -0400
From: Marek Belisko <marek@goldelico.com>
To: bcousson@baylibre.com, tony@atomide.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, hns@goldelico.com,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH v2 0/7] arm: dts: oma3-gta04: Various updates
Date: Tue, 22 Jul 2014 21:30:13 +0200
Message-Id: <1406057420-22269-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patchset add various improvements to gta04 devicetree.

Changes from v1:
- added description to all patches

Marek Belisko (7):
  arm: dts: omap3-gta04: Add nand support
  arm: dts: omap3-gta04: Fix magnetometer model
  arm: dts: omap3-gta04: Add wifi reset node
  arm: dts: omap3-gta04: Move spi gpio pins to pmx_core2
  arm: dts: omap3-gta04: Add USB host support
  arm: dts: omap3-gta04: Add display alias
  arm: dts: omap3-gta04: Add twl4030 regulators parameters

 arch/arm/boot/dts/omap3-gta04.dts | 150 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 145 insertions(+), 5 deletions(-)

-- 
1.9.1

