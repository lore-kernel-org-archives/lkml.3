Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab3GQRKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:10:44 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:46008 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979Ab3GQRKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:10:41 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 1/3] arm: zynq: slcr: Remove redundant header #includes
Date: Wed, 17 Jul 2013 10:10:13 -0700
Message-Id: <1374081015-31431-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.3.3
In-Reply-To: <1374081015-31431-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1374081015-31431-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/mach-zynq/slcr.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index 50d008d..232c275 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -14,18 +14,8 @@
  * 02139, USA.
  */
 
-#include <linux/export.h>
 #include <linux/io.h>
-#include <linux/fs.h>
-#include <linux/interrupt.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/of_address.h>
-#include <linux/uaccess.h>
-#include <linux/platform_device.h>
-#include <linux/slab.h>
-#include <linux/string.h>
 #include <linux/clk/zynq.h>
 #include "common.h"
 
-- 
1.8.3.3

