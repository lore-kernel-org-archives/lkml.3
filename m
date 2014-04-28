Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbaD1PPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:15:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58610 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756609AbaD1PP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:15:29 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nm@ti.com>
Subject: [PATCH V3 01/20] bus: omap_l3_noc: Fix copyright information
Date: Mon, 28 Apr 2014 10:14:41 -0500
Message-ID: <1398698101-25513-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398698101-25513-1-git-send-email-nm@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
 <1398698101-25513-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an embarrassing patch :(.

Texas Corporation does not make OMAP. Texas Instruments Inc does.

For that matter I dont seem to be able to find a Texas Corporation on
the internet either.

While at it, update coverage to the current year and update the template
to remove redundant information and use the standard boiler plate
licensing.

Signed-off-by: Nishanth Menon <nm@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Tested-by: Darren Etheridge <detheridge@ti.com>
---
change in V3: none
 drivers/bus/omap_l3_noc.c |   18 ++++++------------
 drivers/bus/omap_l3_noc.h |   18 ++++++------------
 2 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index 972691a..1eb6d85 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -1,24 +1,18 @@
 /*
  * OMAP4XXX L3 Interconnect error handling driver
  *
- * Copyright (C) 2011 Texas Corporation
+ * Copyright (C) 2011-2014 Texas Instruments Incorporated - http://www.ti.com/
  *	Santosh Shilimkar <santosh.shilimkar@ti.com>
  *	Sricharan <r.sricharan@ti.com>
  *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
- * USA
  */
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/drivers/bus/omap_l3_noc.h b/drivers/bus/omap_l3_noc.h
index a6ce34d..cc4b1b1 100644
--- a/drivers/bus/omap_l3_noc.h
+++ b/drivers/bus/omap_l3_noc.h
@@ -1,24 +1,18 @@
 /*
  * OMAP4XXX L3 Interconnect  error handling driver header
  *
- * Copyright (C) 2011 Texas Corporation
+ * Copyright (C) 2011-2014 Texas Instruments Incorporated - http://www.ti.com/
  *	Santosh Shilimkar <santosh.shilimkar@ti.com>
  *	sricharan <r.sricharan@ti.com>
  *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
- * USA
  */
 #ifndef __ARCH_ARM_MACH_OMAP2_L3_INTERCONNECT_3XXX_H
 #define __ARCH_ARM_MACH_OMAP2_L3_INTERCONNECT_3XXX_H
-- 
1.7.9.5

