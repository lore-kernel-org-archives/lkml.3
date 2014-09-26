Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbaIZKZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:25:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616AbaIZJqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 047/142] regulator: arizona-ldo1: remove bypass functionality
Date: Fri, 26 Sep 2014 11:44:18 +0200
Message-Id: <a068339caabfcb209bf5417f2a162af691ba5f86.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5b919f3ebb533cbe400664837e24f66a0836b907 upstream.

WM5110/8280 devices do not support bypass mode for LDO1 so remove
the bypass callbacks registered with regulator core.

Signed-off-by: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/regulator/arizona-ldo1.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index 7917bb2fa834..406e50ef5152 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -141,8 +141,6 @@ static struct regulator_ops arizona_ldo1_ops = {
 	.map_voltage = regulator_map_voltage_linear,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
-	.get_bypass = regulator_get_bypass_regmap,
-	.set_bypass = regulator_set_bypass_regmap,
 };
 
 static const struct regulator_desc arizona_ldo1 = {
-- 
2.1.0

