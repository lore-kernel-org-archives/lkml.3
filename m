Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab3BVBC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 20:02:26 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:39089 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681Ab3BVBCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 20:02:24 -0500
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2013 20:02:24 EST
From: Ian Lartey <ian@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com, sameo@linux.intel.com
Cc: ldewangan@nvidia.com, Graeme Gregory <gg@slimlogic.co.uk>,
        Ian Lartey <ian@slimlogic.co.uk>
Subject: [PATCH 1/2] regulator: palmas fix SMPS no voltages
Date: Fri, 22 Feb 2013 00:52:04 +0000
Message-Id: <1361494325-4416-1-git-send-email-ian@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graeme Gregory <gg@slimlogic.co.uk>

Number of voltages for SMPS regulators was off by one.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
---
 drivers/regulator/palmas-regulator.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index cde13bb..39cf146 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -4,6 +4,7 @@
  * Copyright 2011-2012 Texas Instruments Inc.
  *
  * Author: Graeme Gregory <gg@slimlogic.co.uk>
+ * Author: Ian Lartey <ian@slimlogic.co.uk>
  *
  *  This program is free software; you can redistribute it and/or modify it
  *  under  the terms of the GNU General  Public License as published by the
@@ -156,7 +157,7 @@ static const struct regs_info palmas_regs_info[] = {
  *
  * So they are basically (maxV-minV)/stepV
  */
-#define PALMAS_SMPS_NUM_VOLTAGES	116
+#define PALMAS_SMPS_NUM_VOLTAGES	117
 #define PALMAS_SMPS10_NUM_VOLTAGES	2
 #define PALMAS_LDO_NUM_VOLTAGES		50
 
-- 
1.7.0.4

