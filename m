Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbaGHA6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:58:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55435 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbaGGXyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Keerthy <j-keerthy@ti.com>, Felipe Balbi <balbi@ti.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.15 087/122] regulator: tps65218: Correct the the config register for LDO1
Date: Mon,  7 Jul 2014 16:57:29 -0700
Message-Id: <20140707235736.869841117@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keerthy <j-keerthy@ti.com>

commit 0eada6a1fc85a98ce69a199e46925abd6a7001c2 upstream.

Correct the the config register for LDO1.

Fixes: 90e7d5262796 (regulator: tps65218: Add Regulator driver for
TPS65218 PMIC)
Signed-off-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/tps65218-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/tps65218-regulator.c
+++ b/drivers/regulator/tps65218-regulator.c
@@ -226,7 +226,7 @@ static const struct regulator_desc regul
 			   1, -1, -1, TPS65218_REG_ENABLE1,
 			   TPS65218_ENABLE1_DC6_EN, NULL, NULL, 0),
 	TPS65218_REGULATOR("LDO1", TPS65218_LDO_1, tps65218_ldo1_dcdc34_ops, 64,
-			   TPS65218_REG_CONTROL_DCDC4,
+			   TPS65218_REG_CONTROL_LDO1,
 			   TPS65218_CONTROL_LDO1_MASK, TPS65218_REG_ENABLE2,
 			   TPS65218_ENABLE2_LDO1_EN, NULL, ldo1_dcdc3_ranges,
 			   2),


