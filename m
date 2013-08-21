Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab3HUOcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:32:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41577 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab3HUOcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:32:07 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>, <balbi@ti.com>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ian.campbell@citrix.com>,
        <linux@arm.linux.org.uk>, <javier.martinez@collabora.co.uk>,
        <devicetree@vger.kernel.org>, <kishon@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH v3 0/5]  ARM: OMAP: DTS/HWMOD/defconfig changes for USB3
Date: Wed, 21 Aug 2013 20:01:29 +0530
Message-ID: <1377095494-15380-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>

With these patches (plus a few others on the driver side which
will be going upstream soon) I could get functional USB3 with my
omap5-uevm platform.

Changes since v2:
	- added dt properties for enabling vbus/id interrupts and fixed
vbus-supply value after SMPS10 is modeled as 2 regulators

Changes since v1:
	- split ocp2scp dts and hwmod data into separate patches
	- reorganize the series in order to group DTS, hwmod and defconfig
	  changes

Benoit Cousson (1):
  arm: omap5: hwmod: add missing ocp2scp hwmod data

Felipe Balbi (4):
  arm: omap5: dts: fix reg property size
  arm: omap5: dts: fix ocp2scp DTS data
  arm: omap5: dts: add palmas-usb node
  arm: omap2plus_defconfig: enable dwc3 and dependencies

 arch/arm/boot/dts/omap5-uevm.dts           |   12 ++++++++
 arch/arm/boot/dts/omap5.dtsi               |    9 +++---
 arch/arm/configs/omap2plus_defconfig       |    9 ++++++
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c |   45 ++++++++++++++++++++++++++++
 4 files changed, 71 insertions(+), 4 deletions(-)

-- 
1.7.10.4

