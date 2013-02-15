Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab3BOOXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 09:23:14 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:34068 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab3BOOXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 09:23:12 -0500
Message-ID: <1360938181.7815.1.camel@phoenix>
Subject: [PATCH] regulator: twl: Remove VDD1_VSEL_table and VDD2_VSEL_table
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Tero Kristo <t-kristo@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 15 Feb 2013 22:23:01 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit ba305e31 "regulator: twl: fix twl4030 support for smps regulators",
VDD1_VSEL_table and VDD2_VSEL_table are not used any more. Remove them.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/twl-regulator.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 74508cc..683d314 100644
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
1.7.9.5



