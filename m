Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab3KTH7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 02:59:03 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:44232 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab3KTH65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 02:58:57 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, horms@verge.net.au,
        linux-sh@vger.kernel.org
Date: Wed, 20 Nov 2013 16:59:39 +0900
Message-Id: <20131120075939.23557.49793.sendpatchset@w520>
In-Reply-To: <20131120075921.23557.23231.sendpatchset@w520>
References: <20131120075921.23557.23231.sendpatchset@w520>
Subject: [PATCH 02/05] ARM: shmobile: Add r8a7790 clocks for thermal devices
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add the r8a7790 DT thermal device to the legacy clocks.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/arm/mach-shmobile/clock-r8a7790.c |    1 +
 1 file changed, 1 insertion(+)

--- 0001/arch/arm/mach-shmobile/clock-r8a7790.c
+++ work/arch/arm/mach-shmobile/clock-r8a7790.c	2013-11-20 08:22:32.000000000 +0900
@@ -286,6 +286,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("e6530000.i2c", &mstp_clks[MSTP929]),
 	CLKDEV_DEV_ID("e6540000.i2c", &mstp_clks[MSTP928]),
 	CLKDEV_DEV_ID("r8a7790-ether", &mstp_clks[MSTP813]),
+	CLKDEV_DEV_ID("e61f0000.thermal", &mstp_clks[MSTP522]),
 	CLKDEV_DEV_ID("rcar_thermal", &mstp_clks[MSTP522]),
 	CLKDEV_DEV_ID("ee200000.mmc", &mstp_clks[MSTP315]),
 	CLKDEV_DEV_ID("sh_mmcif.0", &mstp_clks[MSTP315]),
