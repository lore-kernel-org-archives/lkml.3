Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab3LMWYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:24:53 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:50931 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab3LMWYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:24:52 -0500
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
To: tglx@linutronix.de
Subject: [PATCH] irq-gic: remove file name from heading comment
Date: Sat, 14 Dec 2013 02:24:53 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.32.26-175.fc12.i686.PAE; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201312140224.53928.sergei.shtylyov@cogentembedded.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File names in the heading comments  fell out of favor long ago, and this one
weren't even changed when the driver was moved from arch/arm/common/, so remove
it at last...

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
The patch is against the 'irq/core' branch of the 'tip.git' repo.

 drivers/irqchip/irq-gic.c |    2 --
 1 file changed, 2 deletions(-)

Index: tip/drivers/irqchip/irq-gic.c
===================================================================
--- tip.orig/drivers/irqchip/irq-gic.c
+++ tip/drivers/irqchip/irq-gic.c
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/arm/common/gic.c
- *
  *  Copyright (C) 2002 ARM Limited, All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify
