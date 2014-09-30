Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbaI3Jp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 05:45:29 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:42435 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaI3JpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 05:45:25 -0400
From: Chris Zhong <zyw@rock-chips.com>
To: dianders@chromium.org, heiko@sntech.de
Cc: linux-rockchip@lists.infradead.org, Chris Zhong <zyw@rock-chips.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: rk808: Fix min_uV for DCDC1 & DCDC2
Date: Tue, 30 Sep 2014 17:44:54 +0800
Message-Id: <1412070294-5535-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The min_uv in DCDC1 & DCDC2 should be 712.5mv

Signed-off-by: Chris Zhong <zyw@rock-chips.com>

---

 drivers/regulator/rk808-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/rk808-regulator.c b/drivers/regulator/rk808-regulator.c
index e305416..196a5c8 100644
--- a/drivers/regulator/rk808-regulator.c
+++ b/drivers/regulator/rk808-regulator.c
@@ -44,7 +44,7 @@ static const int rk808_buck_config_regs[] = {
 };
 
 static const struct regulator_linear_range rk808_buck_voltage_ranges[] = {
-	REGULATOR_LINEAR_RANGE(700000, 0, 63, 12500),
+	REGULATOR_LINEAR_RANGE(712500, 0, 63, 12500),
 };
 
 static const struct regulator_linear_range rk808_buck4_voltage_ranges[] = {
-- 
1.7.9.5

