Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124Ab3BZLxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 06:53:44 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:39242 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759043Ab3BZLxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 06:53:42 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kuninori.morimoto.gx@renesas.com, linux-sh@vger.kernel.org,
        benh@kernel.crashing.org, grant.likely@secretlab.ca,
        horms@verge.net.au, Magnus Damm <magnus.damm@gmail.com>,
        tglx@linutronix.de
Date: Tue, 26 Feb 2013 20:59:23 +0900
Message-Id: <20130226115923.5630.46380.sendpatchset@w520>
In-Reply-To: <20130226115834.5630.45471.sendpatchset@w520>
References: <20130226115834.5630.45471.sendpatchset@w520>
Subject: [PATCH 05/05] irqchip: intc-irqpin: GPL header for platform data
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add GPL header to platform data include file.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Thanks to Kuninori Morimoto for this suggestion.

 include/linux/platform_data/irq-renesas-intc-irqpin.h |   19 +++++++++++++++++
 1 file changed, 19 insertions(+)

--- 0002/include/linux/platform_data/irq-renesas-intc-irqpin.h
+++ work/include/linux/platform_data/irq-renesas-intc-irqpin.h	2013-02-26 19:57:03.000000000 +0900
@@ -1,3 +1,22 @@
+/*
+ * Renesas INTC External IRQ Pin Driver
+ *
+ *  Copyright (C) 2013 Magnus Damm
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
 #ifndef __IRQ_RENESAS_INTC_IRQPIN_H__
 #define __IRQ_RENESAS_INTC_IRQPIN_H__
 
