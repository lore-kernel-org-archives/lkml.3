Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaAYV3f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 16:29:35 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:60823 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaAYV3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 16:29:33 -0500
From: Marek Belisko <marek@goldelico.com>
To: bcousson@baylibre.com, tony@atomide.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        neilb@suse.de, hns@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH 0/9] ARM: dts: omap3-gta04: Various devicetree updates.
Date: Sat, 25 Jan 2014 22:28:54 +0100
Message-Id: <1390685343-11663-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pathes fix some wrong property issues and add some new devices to
devicetree. This was tested on linux-next (next-20140124).

Marek Belisko (6):
  ARM: dts: omap3-gta04: Fix mmc1 properties.
  ARM: dts: omap3-gta04: Add basic sound support.
  ARM: dts: omap3-gta04: Add twl4030 charger.
  ARM: dts: omap3-gta04: Add touchscreen properties.
  ARM: dts: omap3-gta04: Add support for magnetometer.
  ARM: dts: omap3-gta04: Add ti,omap36xx to compatible property to avoid
    problems with booting.

NeilBrown (3):
  ARM: dts: omap3-gta04: Fix 'aux' gpio key flags.
  ARM: dts: omap3-gta04: Add bma180 accelerometer.
  ARM: dts: omap3-gta04: Enable mmc2 for wifi.

 arch/arm/boot/dts/omap3-gta04.dts | 58 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 4 deletions(-)

-- 
1.8.3.2

