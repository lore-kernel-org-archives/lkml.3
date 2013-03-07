Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043Ab3CGNjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 08:39:15 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53432 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758728Ab3CGNfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 08:35:43 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <balbi@ti.com>, <kishon@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 0/7] ARM: dts: omap: Add dts data for USB
Date: Thu, 7 Mar 2013 19:05:13 +0530
Message-ID: <1362663320-23799-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

Here are the dt data patches to get usb device functional in OMAP platforms.

All the patches deal with modifying arch/arm/boot except one which modifies
Documentation/../usb/omap-usb.txt

Changes from v2:
* squashed the dt data for dwc3-omap with dwc3 core into a single patch.

Changes from v1:
Patch *ARM: dts: omap: Add usb_otg and glue data* has some properties with
names that has "_". It's replaced with a "-" here.

This patch is developed on Linux 3.9-rc1.

Kishon Vijay Abraham I (7):
  ARM: dts: omap: Add omap control usb data
  ARM: dts: omap: Add omap-usb2 dt data
  ARM: dts: omap: Add usb_otg and glue data
  ARM: dts: omap5: Add omap control usb data
  ARM: dts: omap5: Add ocp2scp data
  ARM: dts: omap5: Add omap-usb3 and omap-usb2 dt data
  ARM: dts: omap5: add dwc3 omap and dwc3 core dt data

 Documentation/devicetree/bindings/usb/omap-usb.txt |    1 +
 arch/arm/boot/dts/omap3-beagle-xm.dts              |    6 +++
 arch/arm/boot/dts/omap3-evm.dts                    |    6 +++
 arch/arm/boot/dts/omap3-overo.dtsi                 |    6 +++
 arch/arm/boot/dts/omap3.dtsi                       |   12 +++++
 arch/arm/boot/dts/omap4-panda.dts                  |    6 +++
 arch/arm/boot/dts/omap4-sdp.dts                    |    6 +++
 arch/arm/boot/dts/omap4.dtsi                       |   26 +++++++++++
 arch/arm/boot/dts/omap5.dtsi                       |   48 ++++++++++++++++++++
 arch/arm/boot/dts/twl4030.dtsi                     |    2 +-
 10 files changed, 118 insertions(+), 1 deletion(-)

-- 
1.7.10.4

