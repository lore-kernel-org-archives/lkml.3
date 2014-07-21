Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaGUVFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:05:54 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:58809 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaGUVFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:05:52 -0400
From: Marek Belisko <marek@goldelico.com>
To: bcousson@baylibre.com, tony@atomide.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, hns@goldelico.com,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH 0/7] arm: dts: oma3-gta04: Various updates
Date: Mon, 21 Jul 2014 23:05:20 +0200
Message-Id: <1405976727-15166-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patchset add various improvements to gta04 devicetree.

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

