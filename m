Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbaCCNze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 08:55:34 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53721 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487AbaCCNz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 08:55:26 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: <anatol.pomozov@gmail.com>, <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <rogerq@ti.com>, <kishon@ti.com>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        <bcousson@baylibre.com>, <tony@atomide.com>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 0/5] Add USB nodes for am43xx epos and gp evm
Date: Mon, 3 Mar 2014 19:23:49 +0530
Message-ID: <1393854834-23810-1-git-send-email-george.cherian@ti.com>
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



George Cherian (5):
  ARM: dts: am43xx clock data
  ARM: dts: AM4372: Add USB nodes
  ARM: dts: am437x-gp-evm: Enable USB
  ARM: dts: am43x-epos-evm: Enable USB
  doc: Add "ti,am437x-dwc3" comaptible for dwc3 glue

 Documentation/devicetree/bindings/usb/omap-usb.txt |  4 +-
 arch/arm/boot/dts/am4372.dtsi                      | 99 ++++++++++++++++++++++
 arch/arm/boot/dts/am437x-gp-evm.dts                | 44 ++++++++++
 arch/arm/boot/dts/am43x-epos-evm.dts               | 44 ++++++++++
 arch/arm/boot/dts/am43xx-clocks.dtsi               | 17 ++++
 5 files changed, 207 insertions(+), 1 deletion(-)

-- 
1.8.3.1

