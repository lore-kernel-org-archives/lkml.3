Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab3AWJZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:25:27 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37013 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439Ab3AWJZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:25:24 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <khilman@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <dwmw2@infradead.org>
CC: <afzal@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <nsekhar@ti.com>,
        <gururaja.hebbar@ti.com>, Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 0/4] LOW power sleep support for OMAP nand driver
Date: Wed, 23 Jan 2013 14:56:12 +0530
Message-ID: <1358933176-12409-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds low power transition support for OMAP NAND driver.
This includes low power transition support of
- GPMC module
- ELM module
- OMAP2 NAND driver

Low power transition support tested on am335x-evm with NAND flash support.
This patch series based on [1] and depends on [2] and is available [2]

1. ARM: OMAP2+: AM33XX: Add suspend-resume support
   http://comments.gmane.org/gmane.linux.ports.arm.omap/91405
2. https://github.com/avinashphilip/am335x_linux/commits/NAND_supend_resume_support

Philip Avinash (4):
  arch: arm: gpmc: gpmc migration support
  mtd: devices: elm: Low power transition support
  arm: gpmc: Low power transition support
  mtd: nand: omap2: Low power transition support

 arch/arm/mach-omap2/gpmc.c   |   22 ++++++++++++++++++++--
 arch/arm/mach-omap2/pm34xx.c |    5 -----
 drivers/mtd/devices/elm.c    |   40 ++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/nand/omap2.c     |   19 +++++++++++++++++++
 4 files changed, 79 insertions(+), 7 deletions(-)

-- 
1.7.9.5

