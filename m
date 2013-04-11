Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936309Ab3DKPSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:18:49 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:34915 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab3DKPSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:18:48 -0400
Message-ID: <1365693520.4218.1.camel@phoenix>
Subject: [RESEND][PATCH 1/3] regulator: twl: Remove VDD1_VSEL_table and
 VDD2_VSEL_table
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Tero Kristo <t-kristo@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 11 Apr 2013 23:18:40 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit ba305e31 "regulator: twl: fix twl4030 support for smps regulators",
VDD1_VSEL_table and VDD2_VSEL_table are not used any more. Remove them.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/regulator/twl-regulator.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index f705d25..d62604c0 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -441,12 +441,6 @@ static const u16 VSIM_VSEL_table[] = {
 static const u16 VDAC_VSEL_table[] = {
 	1200, 1300, 1800, 1800,
 };
-static const u16 VDD1_VSEL_table[] = {
-	800, 1450,
-};
-static const u16 VDD2_VSEL_table[] = {
-	800, 1450, 1500,
-};
 static const u16 VIO_VSEL_table[] = {
 	1800, 1850,
 };
-- 
1.7.10.4



