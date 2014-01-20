Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbaATVCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 16:02:08 -0500
Received: from mail-yh0-f53.google.com ([209.85.213.53]:34154 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaATVCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 16:02:06 -0500
From: Fabio Estevam <festevam@gmail.com>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] regulator: pfuze100-regulator: Improve dev_info() message
Date: Mon, 20 Jan 2014 18:53:56 -0200
Message-Id: <1390251236-25647-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

'lay' is not very meaningful, so use it 'layer' instead to let the dev_info()
clearer.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/regulator/pfuze100-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index f68e5d5..ab174f2 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -326,7 +326,7 @@ static int pfuze_identify(struct pfuze_chip *pfuze_chip)
 	if (ret)
 		return ret;
 	dev_info(pfuze_chip->dev,
-		 "Full lay: %x, Metal lay: %x\n",
+		 "Full layer: %x, Metal layer: %x\n",
 		 (value & 0xf0) >> 4, value & 0x0f);
 
 	ret = regmap_read(pfuze_chip->regmap, PFUZE100_FABID, &value);
-- 
1.8.1.2

