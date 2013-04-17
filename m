Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966795Ab3DQOyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:54:07 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:51368 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966592Ab3DQOyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:54:06 -0400
Message-ID: <1366210440.15800.0.camel@phoenix>
Subject: [PATCH 1/2] regulator: ab8500: Remove unused voltage_shift field
 from struct expand_register
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 17 Apr 2013 22:54:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The voltage_shift field of struct expand_register is not used now, remove it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 279793e..ece31a3 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -89,7 +89,6 @@ struct ab8500_regulator_info {
 		u8 voltage_bank;
 		u8 voltage_reg;
 		u8 voltage_mask;
-		u8 voltage_shift;
 	} expand_register;
 };
 
@@ -1532,7 +1531,6 @@ static struct ab8500_regulator_info
 			.voltage_bank		= 0x04,
 			.voltage_reg		= 0x01,
 			.voltage_mask		= 0x10,
-			.voltage_shift		= 1,
 		}
 	},
 	[AB8540_LDO_AUX4] = {
-- 
1.7.10.4



