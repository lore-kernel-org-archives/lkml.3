Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab3GBKy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 06:54:27 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:63764 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3GBKyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 06:54:23 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] ARM: orion5x: add missing mbus include
Date: Tue,  2 Jul 2013 12:54:13 +0200
Message-Id: <1372762453-12018-3-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1372762453-12018-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1372762453-12018-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

edmini_v2-setup is missing an include of linux/mbus.h which causes
compiler error because of missing reference to mvebu_mbus_add_window.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk> 
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com> 
Cc: devicetree-discuss@lists.ozlabs.org 
Cc: linux-kernel@vger.kernel.org 
Cc: linux-arm-kernel@lists.infradead.org 
---
 arch/arm/mach-orion5x/edmini_v2-setup.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-orion5x/edmini_v2-setup.c b/arch/arm/mach-orion5x/edmini_v2-setup.c
index 1476155..1cecedc 100644
--- a/arch/arm/mach-orion5x/edmini_v2-setup.c
+++ b/arch/arm/mach-orion5x/edmini_v2-setup.c
@@ -23,6 +23,7 @@
 #include <linux/platform_device.h>
 #include <linux/pci.h>
 #include <linux/irq.h>
+#include <linux/mbus.h>
 #include <linux/mtd/physmap.h>
 #include <linux/mv643xx_eth.h>
 #include <linux/leds.h>
-- 
1.7.2.5

