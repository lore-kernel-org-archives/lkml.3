Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab3AYCZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:25:26 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34033 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755851Ab3AYCZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:25:00 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <rob.herring@calxeda.com>, <rob@landley.net>, <tony@atomide.com>,
        <balbi@ti.com>, <b-cousson@ti.com>, <rnayak@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
CC: <grant.likely@secretlab.ca>, <linux@arm.linux.org.uk>, <kishon@ti.com>
Subject: [PATCH v2 0/3] ARM: dts: omap: add dt data for MUSB
Date: Fri, 25 Jan 2013 07:54:34 +0530
Message-ID: <1359080677-5381-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds dt data to get MUSB working in omap4 and omap3.
Long time back a patch series with the same title was sent but only
a part of it got merged. The rest of it wasn't merged because of
adding omap control usb data to glue and usb phy.

Now there exists a separate driver for control usb and hence added a
separate dt node for control usb.

Changes from v1:
* "ti,has_mailbox" property is removed and "ti,type" property is added
  and filled with value "1" to specify it has a mailbox

This series was developed on
git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git xceiv
+ "usb: musb: add driver for control module" patch series

Did basic enumeration testing in omap4 panda, omap4 sdp and omap3 beagle.

I've kept this patch series and all the patch series to follow in a single branch
git://gitorious.org/linux-usb/linux-usb.git omap5-with-palmas
(changes up to 23b4dfa2ab7052569cd88acc6383c4b1a8e8a482)

Kishon Vijay Abraham I (3):
  ARM: dts: omap: Add omap control usb data
  ARM: dts: omap: Add omap-usb2 dt data
  ARM: dts: omap: Add usb_otg and glue data

 Documentation/devicetree/bindings/usb/omap-usb.txt |    2 ++
 arch/arm/boot/dts/omap3-beagle-xm.dts              |    6 +++++
 arch/arm/boot/dts/omap3-evm.dts                    |    6 +++++
 arch/arm/boot/dts/omap3-overo.dtsi                 |    6 +++++
 arch/arm/boot/dts/omap3.dtsi                       |   12 ++++++++++
 arch/arm/boot/dts/omap4-panda.dts                  |    6 +++++
 arch/arm/boot/dts/omap4-sdp.dts                    |    6 +++++
 arch/arm/boot/dts/omap4.dtsi                       |   25 ++++++++++++++++++++
 arch/arm/boot/dts/twl4030.dtsi                     |    2 +-
 9 files changed, 70 insertions(+), 1 deletion(-)

-- 
1.7.9.5

