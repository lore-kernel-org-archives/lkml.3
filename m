Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab3EBSZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:25:56 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:53413 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932708Ab3EBSZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:25:55 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] ARM: dove: prepare and move to orion irqchip driver
Date: Thu,  2 May 2013 20:25:37 +0200
Message-Id: <1367519140-19716-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set moves Dove to the recently introduced irqchip driver
for Marvell Orion SoCs. First, init code for timer and mv643xx_eth
is added to prepare legacy non-DT drivers for virtual irqs provided by
irqchip drivers. Then DT enabled boards for Dove are moved to the
orion irqchip driver.

Note: This patch set depends on irqchip driver for Orion SoCs patch.

Sebastian Hesselbarth (3):
  ARM: dove: add DT parsing for legacy mv643xx_eth
  ARM: dove: add DT parsing for legacy timer
  ARM: dove: move DT boards to orion irqchip driver

 arch/arm/boot/dts/dove.dtsi   |   18 ++++++++-
 arch/arm/mach-dove/Kconfig    |    1 +
 arch/arm/mach-dove/Makefile   |    4 +-
 arch/arm/mach-dove/board-dt.c |   77 ++++++++++++++++++++++++++++++++++++-----
 4 files changed, 87 insertions(+), 13 deletions(-)
---
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Jean-Francois Moine <moinejf@free.fr>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.7.2.5

