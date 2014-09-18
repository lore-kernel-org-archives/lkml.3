Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbaIRNsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:48:54 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53999 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbaIRNsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:48:53 -0400
Message-ID: <1411048128.18649.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: fan53555: Fixup report wrong vendor message
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Heiko Stuebner <heiko@sntech.de>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 18 Sep 2014 21:48:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/fan53555.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index f2f5535..70b31bf 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -267,8 +267,7 @@ static int fan53555_device_setup(struct fan53555_device_info *di,
 		ret = fan53555_voltages_setup_silergy(di);
 		break;
 	default:
-		dev_err(di->dev,
-			"vendor %d not supported!\n", di->chip_id);
+		dev_err(di->dev, "vendor %d not supported!\n", di->vendor);
 		return -EINVAL;
 	}
 
-- 
1.9.1



