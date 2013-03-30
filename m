Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab3C3F5f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 01:57:35 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:60337 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab3C3F5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 01:57:34 -0400
Message-ID: <1364623049.3568.2.camel@phoenix>
Subject: [PATCH] regulator: max1586: Constify v6_voltages_uv table
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 30 Mar 2013 13:57:29 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make v6_voltages_uv to be const unsigned int.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max1586.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index 8c5a54f..dac0490 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -56,7 +56,7 @@ struct max1586_data {
  *   set V6 to either 0V, 1.8V, 2.5V, 3V depending on (x & 0x3)
  * As regulator framework doesn't accept voltages to be 0V, we use 1uV.
  */
-static int v6_voltages_uv[] = { 1, 1800000, 2500000, 3000000 };
+static const unsigned int v6_voltages_uv[] = { 1, 1800000, 2500000, 3000000 };
 
 /*
  * V3 voltage
-- 
1.7.10.4



