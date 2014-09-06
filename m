Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333AbaIFM7p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 08:59:45 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33921 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaIFM7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 08:59:42 -0400
Message-ID: <1410008376.4265.1.camel@phoenix>
Subject: [PATCH v2] regulator: hi6421: Fix misleading comment
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: Guodong Xu <guodong.xu@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 06 Sep 2014 20:59:36 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/hi6421-regulator.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/hi6421-regulator.c b/drivers/regulator/hi6421-regulator.c
index e389920..156d0d1 100644
--- a/drivers/regulator/hi6421-regulator.c
+++ b/drivers/regulator/hi6421-regulator.c
@@ -37,7 +37,7 @@ struct hi6421_regulator_pdata {
  * struct hi6421_regulator_info - hi6421 regulator information
  * @desc: regulator description
  * @mode_mask: ECO mode bitmask of LDOs; for BUCKs, this masks sleep
- * @eco_microamp: eco mode load upper limit (in mA), valid for LDOs only
+ * @eco_microamp: eco mode load upper limit (in uA), valid for LDOs only
  */
 struct hi6421_regulator_info {
 	struct regulator_desc	desc;
@@ -164,7 +164,7 @@ static const struct regulator_ops hi6421_buck345_ops;
  * emask - enable mask
  * odelay - off/on delay time in uS
  * ecomask - eco mode mask
- * ecoamp - eco mode load uppler limit in mA
+ * ecoamp - eco mode load uppler limit in uA
  */
 #define HI6421_LDO(_id, v_table, vreg, vmask, ereg, emask,		\
 		   odelay, ecomask, ecoamp)				\
@@ -200,7 +200,7 @@ static const struct regulator_ops hi6421_buck345_ops;
  * emask - enable mask
  * odelay - off/on delay time in uS
  * ecomask - eco mode mask
- * ecoamp - eco mode load uppler limit in mA
+ * ecoamp - eco mode load uppler limit in uA
  */
 #define HI6421_LDO_LINEAR(_id, _min_uV, n_volt, vstep, vreg, vmask,	\
 			  ereg, emask, odelay, ecomask, ecoamp)		\
@@ -237,7 +237,7 @@ static const struct regulator_ops hi6421_buck345_ops;
  * emask - enable mask
  * odelay - off/on delay time in uS
  * ecomask - eco mode mask
- * ecoamp - eco mode load uppler limit in mA
+ * ecoamp - eco mode load uppler limit in uA
  */
 #define HI6421_LDO_LINEAR_RANGE(_id, n_volt, volt_ranges, vreg, vmask,	\
 				ereg, emask, odelay, ecomask, ecoamp)	\
-- 
1.9.1



