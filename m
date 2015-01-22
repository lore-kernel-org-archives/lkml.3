Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbbAVUmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:42:24 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:40127 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbbAVUih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:38:37 -0500
From: Marek Belisko <marek@goldelico.com>
To: bcousson@baylibre.com, tony@atomide.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        hns@goldelico.com, neilb@suse.de, Marek Belisko <marek@goldelico.com>
Subject: [PATCH 00/13] ARM: dts: omap3-gta04: Various DT fixes
Date: Thu, 22 Jan 2015 21:38:06 +0100
Message-Id: <1421959099-28319-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contains fixes for gta04 devicetree. I collected patches
from H. Nikolaus Schaller + NeilBrown and myself. Patches contains mostly fixes
+ adding new nodes and comments. All changes tested on gta04a4 board.

H. Nikolaus Schaller (5):
  ARM: dts: omap3-gta04: Fix backup-battery charging in devicetree file.
  ARM: dts: omap3-gta04: Fix audio node malformatting
  ARM: dts: omap3-gta04: Enable mcbps2 necessary for audio
  ARM: dts: omap3-gta04: Enable twl audio vibra support
  ARM: dts: omap3-gta04: Enable power-off using twl4030

Marek Belisko (2):
  ARM: dts: omap3-gta04: Fix a GPIO line for bma180 node
  ARM: dts: omap3-gta04: Add ramp value for twl4030 audio

NeilBrown (6):
  ARM: dts: omap3-gta04: add comments about gpios
  ARM: dts: omap3-gta04: enable power-off for wifi card.
  ARM: dts: omap3-gta04: add gyroscope
  ARM: dts: omap3-gta04: only power DSS when necessary.
  ARM: dts: omap3-gta04: uart4 is not connected, so mark it "disabled"
  ARM: dts: omap3-gta04: Disable keypad

 arch/arm/boot/dts/omap3-gta04.dtsi | 54 +++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 15 deletions(-)

-- 
1.9.1

