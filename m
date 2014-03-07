Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaCGL6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 06:58:37 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38142 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbaCGL6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 06:58:36 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <balbi@ti.com>, <rogerq@ti.com>, <kishon@ti.com>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        <tony@atomide.com>, <anatol.pomozov@gmail.com>,
        <bcousson@baylibre.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v3 0/5] Add USB nodes for am43xx epos and gp evm 
Date: Fri, 7 Mar 2014 17:26:57 +0530
Message-ID: <1394193422-18242-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series adds USB dt nodes for am43xx epos and gp evm

Boot tested with  Benoit's for_3.15 + following patches

https://patchwork.kernel.org/patch/3600821/
https://patchwork.kernel.org/patch/3600831/
https://patchwork.kernel.org/patch/3600851/
https://patchwork.kernel.org/patch/3600841/


Changes from v1 -> v2
	* Reorder "doc: Add "ti,am437x-dwc3" comaptible for dwc3 glue"
	* Address v1 coments on "ARM: dts: AM4372: Add USB nodes"  

Changes from v2 -> v3
	* Removed unwanted dwc3_1 and dwc3_2 nodes from am437x-gp-evm.dts 
	  and am43x-epos-evm.dts 

George Cherian (5):
  doc: Add "ti,am437x-dwc3" comaptible for dwc3 glue
  ARM: dts: am43xx clock data
  ARM: dts: AM4372: Add USB nodes
  ARM: dts: am437x-gp-evm: Enable USB
  ARM: dts: am43x-epos-evm: Enable USB

 Documentation/devicetree/bindings/usb/omap-usb.txt |  4 +-
 arch/arm/boot/dts/am4372.dtsi                      | 95 ++++++++++++++++++++++
 arch/arm/boot/dts/am437x-gp-evm.dts                | 18 ++++
 arch/arm/boot/dts/am43x-epos-evm.dts               | 18 ++++
 arch/arm/boot/dts/am43xx-clocks.dtsi               | 17 ++++
 5 files changed, 151 insertions(+), 1 deletion(-)

-- 
1.8.3.1

