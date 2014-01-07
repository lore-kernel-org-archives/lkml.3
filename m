Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaAGMQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:16:36 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37467 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaAGMQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:16:28 -0500
From: Roger Quadros <rogerq@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v3 0/4] USB Host support for OMAP5 uEVM (for 3.14)
Date: Tue, 7 Jan 2014 17:44:45 +0530
Message-ID: <1389096889-22179-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit & Tony,

This patchset brings up USB Host ports and Ethernet port on
the OMAP5 uEVM board.

It depends on the TI Clock DT conversion patches [1].

[1] - http://article.gmane.org/gmane.linux.ports.arm.kernel/289895

cheers,
-roger

Roger Quadros (4):
  ARM: dts: OMAP5: Add 60MHz clock reference to USB Host module
  ARM: dts: omap4-panda: Provide USB PHY clock
  ARM: dts: omap5-uevm: Provide USB PHY clock
  ARM: OMAP2+: Remove legacy_init_ehci_clk()

 arch/arm/boot/dts/omap4-panda-common.dtsi |  8 ++------
 arch/arm/boot/dts/omap5-uevm.dts          |  8 ++------
 arch/arm/boot/dts/omap5.dtsi              |  2 ++
 arch/arm/mach-omap2/pdata-quirks.c        | 16 ----------------
 4 files changed, 6 insertions(+), 28 deletions(-)

-- 
1.8.3.2

