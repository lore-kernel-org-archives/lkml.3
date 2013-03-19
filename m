Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab3CSO1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:27:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53267 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab3CSO13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:27:29 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <b-cousson@ti.com>
CC: <linux@arm.linux.org.uk>, <rnayak@ti.com>, <balbi@ti.com>, <rogerq@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 0/2] Device tree support for OMAP4 SCRM clocks
Date: Tue, 19 Mar 2013 16:26:58 +0200
Message-ID: <1363703220-4777-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Based on the discussion in [1], I've implemented device tree
provider for the AUXCLKs on OMAP4.

Please let me know if there are any issues.

This is important to get USB Host support working on Panda with
device tree boot on 3.10.

Roger Quadros (2):
  ARM: OMAP4: clock: Add device tree support for AUXCLKs
  ARM: dts: omap4-panda: Provide PHY clock information

 .../devicetree/bindings/clock/omap4-clock.txt      |   32 ++++++++++++++++++
 arch/arm/boot/dts/omap4-panda.dts                  |    2 +
 arch/arm/boot/dts/omap4.dtsi                       |    5 +++
 arch/arm/mach-omap2/board-generic.c                |    2 +-
 arch/arm/mach-omap2/cclock44xx_data.c              |   35 ++++++++++++++++++++
 arch/arm/mach-omap2/clock44xx.h                    |    1 +
 arch/arm/mach-omap2/common.h                       |    9 +++++
 arch/arm/mach-omap2/io.c                           |    6 +++
 8 files changed, 91 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/omap4-clock.txt

-- 
1.7.4.1

