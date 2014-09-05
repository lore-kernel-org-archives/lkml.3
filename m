Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbaIEBOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 21:14:31 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:59903 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642AbaIEBOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 21:14:30 -0400
Message-ID: <1409879666.5208.2.camel@phoenix>
Subject: [PATCH] regulator: hi6421: Fix misleading comment
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: Guodong Xu <guodong.xu@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 05 Sep 2014 09:14:26 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/hi6421-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/hi6421-regulator.c b/drivers/regulator/hi6421-regulator.c
index e389920..a8c362c 100644
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
-- 
1.9.1



