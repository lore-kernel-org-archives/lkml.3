Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbaEGMSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:18:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57904 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645AbaEGMSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:18:45 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <rnayak@ti.com>,
        <marc.zyngier@arm.com>, <grant.likely@linaro.org>,
        <mark.rutland@arm.com>, <tglx@linutronix.de>, <galak@codeaurora.org>,
        <santosh.shilimkar@ti.com>, <nm@ti.com>, <bcousson@baylibre.com>,
        <robherring2@gmail.com>
CC: Sricharan R <r.sricharan@ti.com>
Subject: [PATCH V6 0/2] arm: dts: dra7: Updates for adding crossbar device
Date: Wed, 7 May 2014 17:46:36 +0530
Message-ID: <1399464998-23216-1-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some socs have a large number of interrupts requests to service
the needs of its many peripherals and subsystems. All of the interrupt
requests lines from the subsystems are not needed at the same
time, so they have to be muxed to the controllers appropriately.
In such places a interrupt controllers are preceded by an
IRQ CROSSBAR that provides flexibility in muxing the device interrupt
requests to the controller inputs.

The dts file update to support the crossbar device and convert
peripheral irq numbers to crossbar number are added here.

This is a rebase on top of 3.15-rc4

This series depends on crossbar-driver-fixes sent below
http://marc.info/?l=linux-omap&m=139929963420299&w=2

[V6] Reordered patch 3 to patch 1 and
     squashed patch 2 and 3 from V5 in to patch 2

Sricharan R (2):
  arm: dts: dra7: Add routable-irqs property for gic node
  arm: dts: dra7: Add crossbar device binding

 arch/arm/boot/dts/dra7.dtsi |  109 +++++++++++++++++++++++++------------------
 1 file changed, 63 insertions(+), 46 deletions(-)

-- 
1.7.9.5

