Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab3AYLOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:14:03 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56024 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757055Ab3AYLMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:12:09 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <balbi@ti.com>, <b-cousson@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <s-guiriec@ti.com>, <gg@slimlogic.co.uk>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/6] ARM: dts: omap: add dt data for dwc3
Date: Fri, 25 Jan 2013 16:41:46 +0530
Message-ID: <1359112312-6918-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds dt data to get dwc3 working in omap5.

Changes from v1:
* rename "ctrl_module" to "ctrl-module" and "usb_phy" to "usb-phy"

This patch series is developed on
git://github.com/rrnayak/linux.git omap5-3.8-rc4-base-palmas

This is the last series of the series of patches.
I've kept everything in a single branch
git://gitorious.org/linux-usb/linux-usb.git omap5-with-palmas
(changes up to 23b4dfa2ab7052569cd88acc6383c4b1a8e8a482)

Did enumeration testing on omap5 evm.

Kishon Vijay Abraham I (6):
  ARM: dts: omap5: Add omap control usb data
  ARM: dts: omap5: Add ocp2scp data
  ARM: dts: omap5: Add omap-usb3 and omap-usb2 dt data
  ARM: dts: omap5: add dwc3 omap dt data
  ARM: dts: omap5: add dwc3 core dt data
  ARM: dts: palmas: update dt data for palmas-usb

 arch/arm/boot/dts/omap5.dtsi  |   48 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/palmas.dtsi |    4 ++--
 2 files changed, 50 insertions(+), 2 deletions(-)

-- 
1.7.9.5

