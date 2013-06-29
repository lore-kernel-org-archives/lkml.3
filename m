Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab3GHNBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:01:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64412 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab3GHM7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 08:59:53 -0400
X-AuditID: cbfee68e-b7f276d000002279-d3-51dab7c85660
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: sbkim73@samsung.com, broonie@kernel.org, lgirdwood@gmail.com,
        sameo@linux.intel.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, sachin.kamat@linaro.org,
        yadi.brar01@gmail.com, Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [v2 PATCH 3/6] regulator: s2mps11: Add DT support
Date: Sat, 29 Jun 2013 18:21:17 +0530
Message-id: <1372510280-31931-4-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1372510280-31931-1-git-send-email-yadi.brar@samsung.com>
References: <1372510280-31931-1-git-send-email-yadi.brar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42JZI2JSrXti+61Ag45uBYupD5+wWRz4s4PR
	4tuVDiaLy7vmsFkcXnGAyeLkn15Gi9PdrBYXV3xhspj7u5HVYs70d0wOXB4LPl9h99g56y67
	x6ZVnWwed67tYfOYdzLQo2/LKkaPz5vkAtijuGxSUnMyy1KL9O0SuDI+7VjMUvBLomL14l72
	BsZvIl2MnBwSAiYSH7etYIGwxSQu3FvPBmILCSxllNj7ohKmZtbiP0A1XEDxRYwSGxruM0M4
	bUwSi45OB+rg4GATMJJ4dcwOpEFEQEFic+8zVpAaZoG3jBJLl94A2yAsYCWx5GoLE4jNIqAq
	8f3UIzCbV8BVYvfjI+wQ2xQkWpcdArM5BdwkuiZfZ4K4yFXi4552JpChEgKH2CVm/pjHCDFI
	QOLb5EMsIEdICMhKbDrADDFHUuLgihssExiFFzAyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P
	3cQIjIrT/5717WC8ecD6EGMy0LiJzFKiyfnAqMoriTc0NjOyMDUxNTYytzQjTVhJnFetxTpQ
	SCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6NzxZHtoW9OavqbV1+Z086stenOKfPqxvPPuxXr
	+JpFVl1dtXhPzI0bF2qWvP967OTdE2Jng+6vbJNyuXZhKtczf89l08+Y98haxLlJTEif8MF4
	sli4n1Tyidmxbixdt/M2VyywiJj/fwN7gekTvawjkxZKsW41P7X3rgRrWtyfAs/LJ+s/BkYp
	sRRnJBpqMRcVJwIAH7OdJqACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jAd0T228FGkzqEreY+vAJm8WBPzsY
	Lb5d6WCyuLxrDpvF4RUHmCxO/ulltDjdzWpxccUXJou5vxtZLeZMf8fkwOWx4PMVdo+ds+6y
	e2xa1cnmcefaHjaPeScDPfq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7U
	zMBQ19DSwlxJIS8xN9VWycUnQNctMwfoPCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFB
	cD1GBmggYQ1jxqcdi1kKfklUrF7cy97A+E2ki5GTQ0LARGLW4j8sELaYxIV769m6GLk4hAQW
	MUpsaLjPDOG0MUksOjodKMPBwSZgJPHqmB1Ig4iAgsTm3mesIDXMAm8ZJZYuvQE2SVjASmLJ
	1RYmEJtFQFXi+6lHYDavgKvE7sdH2CG2KUi0LjsEZnMKuEl0Tb4OViMEVPNxTzvTBEbeBYwM
	qxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCo+6Z1A7GlQ0WhxgFOBiVeHglTt8MFGJNLCuu
	zD3EKMHBrCTCK856K1CINyWxsiq1KD++qDQntfgQYzLQVROZpUST84EJIa8k3tDYxNzU2NTS
	xMLEzJI0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGOXlGm7ekecV/Ni0nc1pY5BQzwlB
	AesJFpxT78zYq7E8z61j5dbAy5kvPossD17u6ZgRzPXmsNC+6yLL7vBsiBVQOeFYy1MjOH+1
	0AumdWZvmJ/MlLy+/pKKY8jqTddvvtGJLui293o9MbTosP61mdtPu8/Vuqg1S185YAbT5KvX
	P9uwX4hT/qHEUpyRaKjFXFScCAC2EES6/gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DT support for parsing regulators constraints for parent(mfd)
node and moves some common intialising code out of loop while registering.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/regulator/s2mps11.c |   48 +++++++++++++++++++++++++++++++++---------
 1 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 4bebcb6..4157759 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -20,9 +20,12 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/mfd/samsung/core.h>
 #include <linux/mfd/samsung/s2mps11.h>
 
+#define S2MPS11_REGULATOR_CNT ARRAY_SIZE(regulators)
+
 struct s2mps11_info {
 	struct regulator_dev *rdev[S2MPS11_REGULATOR_MAX];
 
@@ -407,22 +410,38 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 {
 	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct sec_platform_data *pdata = dev_get_platdata(iodev->dev);
+	struct of_regulator_match rdata[S2MPS11_REGULATOR_MAX];
+	struct device_node *reg_np = NULL;
 	struct regulator_config config = { };
 	struct s2mps11_info *s2mps11;
 	int i, ret;
 	unsigned char ramp_enable, ramp_reg = 0;
 
-	if (!pdata) {
-		dev_err(pdev->dev.parent, "Platform data not supplied\n");
-		return -ENODEV;
-	}
-
 	s2mps11 = devm_kzalloc(&pdev->dev, sizeof(struct s2mps11_info),
 				GFP_KERNEL);
 	if (!s2mps11)
 		return -ENOMEM;
 
-	platform_set_drvdata(pdev, s2mps11);
+	if (!iodev->dev->of_node)
+		goto p_data;
+
+	for (i = 0; i < S2MPS11_REGULATOR_CNT; i++)
+		rdata[i].name = regulators[i].name;
+
+	reg_np = of_find_node_by_name(iodev->dev->of_node, "regulators");
+	if (!reg_np) {
+		dev_err(&pdev->dev, "could not find regulators sub-node\n");
+		return -EINVAL;
+	}
+
+	of_regulator_match(&pdev->dev, reg_np, rdata, S2MPS11_REGULATOR_MAX);
+
+	goto common_reg;
+p_data:
+	if (!pdata) {
+		dev_err(pdev->dev.parent, "Platform data not supplied\n");
+		return -ENODEV;
+	}
 
 	s2mps11->ramp_delay2 = pdata->buck2_ramp_delay;
 	s2mps11->ramp_delay34 = pdata->buck34_ramp_delay;
@@ -454,12 +473,19 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay9);
 	sec_reg_write(iodev, S2MPS11_REG_RAMP_BUCK, ramp_reg);
 
-	for (i = 0; i < S2MPS11_REGULATOR_MAX; i++) {
+common_reg:
+	platform_set_drvdata(pdev, s2mps11);
 
-		config.dev = &pdev->dev;
-		config.regmap = iodev->regmap;
-		config.init_data = pdata->regulators[i].initdata;
-		config.driver_data = s2mps11;
+	config.dev = &pdev->dev;
+	config.regmap = iodev->regmap;
+	config.driver_data = s2mps11;
+	for (i = 0; i < S2MPS11_REGULATOR_MAX; i++) {
+		if (!reg_np) {
+			config.init_data = pdata->regulators[i].initdata;
+		} else {
+			config.init_data = rdata[i].init_data;
+			config.of_node = rdata[i].of_node;
+		}
 
 		s2mps11->rdev[i] = regulator_register(&regulators[i], &config);
 		if (IS_ERR(s2mps11->rdev[i])) {
-- 
1.7.0.4

