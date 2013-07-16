Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab3GPMve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:51:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48333 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540Ab3GPMvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:51:31 -0400
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v2 0/5] ARM: OMAP: DTS/HWMOD/defconfig changes for USB3
Date: Tue, 16 Jul 2013 15:50:32 +0300
Message-ID: <1373979037-27587-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With these patches (plus a few others on the driver side which
will be going upstream soon) I could get functional USB3 with my
omap5-uevm platform.

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

 arch/arm/boot/dts/omap5-uevm.dts           | 10 +++++++
 arch/arm/boot/dts/omap5.dtsi               |  9 +++---
 arch/arm/configs/omap2plus_defconfig       |  9 ++++++
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c | 45 ++++++++++++++++++++++++++++++
 4 files changed, 69 insertions(+), 4 deletions(-)

-- 
1.8.3.3.754.g9c3c367

