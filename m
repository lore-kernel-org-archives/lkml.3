Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab3GBKyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 06:54:24 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:54192 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3GBKyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 06:54:23 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] ARM: mvebu: fixes for v3.11
Date: Tue,  2 Jul 2013 12:54:11 +0200
Message-Id: <1372762453-12018-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set comprises two unrelated fixes for Marvell SoCs based on
what is currently in next-20130701. There may be fixes already pending
for the issues.

The first patch is a clean-up patch removing dmacap,memset from the
device tree binding and users. DMA_MEMSET support has been removed from
DMA API and mv_xor driver.

The second patch fixes compilation of orion5x edmini_v2 by adding a
missing include.

devicetree-discuss is added on Cc for completeness, this is all Marvell
related and should go through Jason Cooper's branch if there are no
objections.

Sebastian Hesselbarth (2):
  ARM: remove dmacap,memset from Device tree binding
  ARM: orion5x: add missing mbus include

 Documentation/devicetree/bindings/dma/mv-xor.txt |    2 --
 arch/arm/boot/dts/armada-370.dtsi                |    2 --
 arch/arm/boot/dts/armada-xp.dtsi                 |    2 --
 arch/arm/boot/dts/dove.dtsi                      |    2 --
 arch/arm/boot/dts/kirkwood.dtsi                  |    2 --
 arch/arm/boot/dts/orion5x.dtsi                   |    1 -
 arch/arm/mach-orion5x/edmini_v2-setup.c          |    1 +
 7 files changed, 1 insertions(+), 11 deletions(-)

---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
-- 
1.7.2.5

