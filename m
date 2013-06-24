Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab3GCLdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:33:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20188 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab3GCLdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:33:17 -0400
X-AuditID: cbfee68f-b7f436d000000f81-82-51d40bfb0886
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: yadi.brar01@gmail.com, sbkim73@samsung.com, broonie@kernel.org,
        lgirdwood@gmail.com, sameo@linux.intel.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH 4/4] regulator: s2mps11: Add device tree support
Date: Mon, 24 Jun 2013 16:50:58 +0530
Message-id: <1372072858-6559-5-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
References: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42JZI2JSo/uH+0qgQYOQxdSHT9gsDvzZwWjx
	7UoHk8XlXXPYLA6vOMBkcbqb1eLiii9MFnN/N7JazJn+jsmB02PB5yvsHjtn3WX32LSqk83j
	zrU9bB7zTgZ69G1ZxejxeZNcAHsUl01Kak5mWWqRvl0CV8aDM0fYCzq1KuZOE25gbFfuYuTg
	kBAwkeic5tPFyAlkiklcuLeerYuRi0NIYCmjxOKzbcwQCROJaTufMUEkpjNKXF9zkR3CaWOS
	uLr5IjPIJDYBI4lXx+xAGkQEFCQ29z5jBalhFrjEKDFt7xFWkISwgIPE5XWLwKayCKhKPN21
	lh2kl1fARaLtoDDEMgWJ1mWH2EFsTgFXidaXF8DGCwGVNH9kARkpIbCLXWL3wuVMEGMEJL5N
	PsQC8YysxKYDUDdLShxccYNlAqPwAkaGVYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxiBMXD6
	37P+HYx3D1gfYkwGGjeRWUo0OR8YQ3kl8YbGZkYWpiamxkbmlmakCSuJ86q1WAcKCaQnlqRm
	p6YWpBbFF5XmpBYfYmTi4JRqYJwkr5xz0ePsgvqYjP5Lf6oX8+ybpnhgzbfvZ7h1zz0q3N7L
	/ml2yn0WVoGrWuZyS8NDtjdOsmPTfyyg4M/Kldc/O+0Yv6btloPa8h3CDuGbdP7OUgvW+njo
	nmHWG7/dJgIZB29bfNKTlLbsOFpl+frc29/Xvf96bA1KUXq2U2Z1yvKVWu3fjJVYijMSDbWY
	i4oTAVguLOqXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jQd3f3FcCDW7vN7aY+vAJm8WBPzsY
	Lb5d6WCyuLxrDpvF4RUHmCxOd7NaXFzxhcli7u9GVos5098xOXB6LPh8hd1j56y77B6bVnWy
	edy5tofNY97JQI++LasYPT5vkgtgj2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0
	tDBXUshLzE21VXLxCdB1y8wBukxJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEa
	SFjDmPHgzBH2gk6tirnThBsY25W7GDk5JARMJKbtfMYEYYtJXLi3nq2LkYtDSGA6o8T1NRfZ
	IZw2Jomrmy8ydzFycLAJGEm8OmYH0iAioCCxufcZK0gNs8AlRolpe4+wgiSEBRwkLq9bxAxi
	swioSjzdtZYdpJdXwEWi7aAwxDIFidZlh9hBbE4BV4nWlxfAxgsBlTR/ZJnAyLuAkWEVo2hq
	QXJBcVJ6rpFecWJucWleul5yfu4mRnCUPZPewbiqweIQowAHoxIPr8OzS4FCrIllxZW5hxgl
	OJiVRHgn/rkcKMSbklhZlVqUH19UmpNafIgxGeimicxSosn5wASQVxJvaGxibmpsamliYWJm
	SZqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2Mfh6WdqdK1f+3epkvvdTMMHtRqsK+BxUa
	t1bnJxScmHMop1V+rrLel9f9GoyT/+dHHgorPWIxtfHG6wCpiZ4nX7Kql+2U/FF1XJZNd7rp
	r6CVc8+q1XRxPmkPmM31/Mbeef1GD2eE7ZXNDdQX3yCrk2ryYIpr3udfoo3Ch+byzz6TXDbh
	iuRpJZbijERDLeai4kQAo8hNpfYCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support. It parses parent's node to get regulator
constraints. This patch also rearrange code little bit.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/regulator/s2mps11.c |  116 ++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 104 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index d42ad2a..559ad7b 100644
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
 
@@ -287,26 +290,107 @@ static struct regulator_desc regulators[] = {
 	regulator_desc_buck10,
 };
 
+static void s2mps11_pmic_set_buck_ramp(struct regulator_init_data *init_data,
+					struct s2mps11_info *s2mps11, int id)
+{
+	unsigned int ramp_rate;
+
+	if (!init_data)
+		return;
+
+	ramp_rate = init_data->constraints.ramp_delay;
+
+	switch (id) {
+	case S2MPS11_BUCK2:
+		s2mps11->ramp_delay2 = ramp_rate;
+		break;
+	case S2MPS11_BUCK3:
+	case S2MPS11_BUCK4:
+		if (ramp_rate > s2mps11->ramp_delay34)
+			s2mps11->ramp_delay34 = ramp_rate;
+		break;
+	case S2MPS11_BUCK5:
+		s2mps11->ramp_delay5 = ramp_rate;
+		break;
+	case S2MPS11_BUCK1:
+	case S2MPS11_BUCK6:
+		if (ramp_rate > s2mps11->ramp_delay16)
+			s2mps11->ramp_delay16 = ramp_rate;
+		break;
+	case S2MPS11_BUCK7:
+	case S2MPS11_BUCK8:
+	case S2MPS11_BUCK10:
+		if (ramp_rate > s2mps11->ramp_delay7810)
+			s2mps11->ramp_delay7810 = ramp_rate;
+		break;
+	case S2MPS11_BUCK9:
+		s2mps11->ramp_delay9 = ramp_rate;
+	}
+}
+
+static void s2mps11_pmic_parse_dt(struct of_regulator_match *rdata,
+					struct s2mps11_info *s2mps11)
+{
+	if (!of_find_property(rdata[S2MPS11_BUCK2].of_node,
+				"regulator-ramp-disable", NULL))
+		s2mps11->buck2_ramp = true;
+
+	if (!of_find_property(rdata[S2MPS11_BUCK3].of_node,
+				"regulator-ramp-disable", NULL))
+		s2mps11->buck3_ramp = true;
+
+	if (!of_find_property(rdata[S2MPS11_BUCK4].of_node,
+				"regulator-ramp-disable", NULL))
+		s2mps11->buck4_ramp = true;
+
+	if (!of_find_property(rdata[S2MPS11_BUCK6].of_node,
+				"regulator-ramp-disable", NULL))
+		s2mps11->buck6_ramp = true;
+}
+
 static int s2mps11_pmic_probe(struct platform_device *pdev)
 {
 	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct sec_platform_data *pdata = dev_get_platdata(iodev->dev);
+	struct of_regulator_match rdata[S2MPS11_REGULATOR_MAX];
+	struct device_node *reg_np = NULL;
 	struct regulator_config config = { };
 	struct s2mps11_info *s2mps11;
-	int i, ret;
+	int i, id, ret;
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
+	if (iodev->dev->of_node)
+		goto p_data;
+
+	for (i = 0; i < S2MPS11_REGULATOR_CNT; i++) {
+		id = regulators[i].id;
+		rdata[id].name = regulators[i].name;
+	}
+
+	reg_np = of_find_node_by_name(iodev->dev->of_node, "regulators");
+	if (!reg_np) {
+		dev_err(&pdev->dev, "could not find regulators sub-node\n");
+		return -EINVAL;
+	}
+
+	of_regulator_match(&pdev->dev, reg_np, rdata, S2MPS11_REGULATOR_MAX);
+
+	s2mps11_pmic_parse_dt(rdata, s2mps11);
+
+	for (id = S2MPS11_BUCK1; id <= S2MPS11_BUCK9; id++)
+		s2mps11_pmic_set_buck_ramp(rdata[id].init_data, s2mps11, id);
+
+	goto set_ramp;
+p_data:
+	if (!pdata) {
+		dev_err(pdev->dev.parent, "Platform data not supplied\n");
+		return -ENODEV;
+	}
 
 	s2mps11->ramp_delay2 = pdata->buck2_ramp_delay;
 	s2mps11->ramp_delay34 = pdata->buck34_ramp_delay;
@@ -320,6 +404,7 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 	s2mps11->buck3_ramp = pdata->buck3_ramp_enable;
 	s2mps11->buck4_ramp = pdata->buck4_ramp_enable;
 
+set_ramp:
 	ramp_enable = (s2mps11->buck2_ramp << 3) | (s2mps11->buck3_ramp << 2) |
 		(s2mps11->buck4_ramp << 1) | s2mps11->buck6_ramp ;
 
@@ -338,12 +423,19 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay9);
 	sec_reg_write(iodev, S2MPS11_REG_RAMP_BUCK, ramp_reg);
 
-	for (i = 0; i < S2MPS11_REGULATOR_MAX; i++) {
+	platform_set_drvdata(pdev, s2mps11);
 
-		config.dev = &pdev->dev;
-		config.regmap = iodev->regmap;
-		config.init_data = pdata->regulators[i].initdata;
-		config.driver_data = s2mps11;
+	config.dev = &pdev->dev;
+	config.regmap = iodev->regmap;
+	config.driver_data = s2mps11;
+	for (i = 0; i < S2MPS11_REGULATOR_MAX; i++) {
+		if (reg_np) {
+			config.init_data = pdata->regulators[i].initdata;
+		} else {
+			id = regulators[i].id;
+			config.init_data = rdata[id].init_data;
+			config.of_node = rdata[id].of_node;
+		}
 
 		s2mps11->rdev[i] = regulator_register(&regulators[i], &config);
 		if (IS_ERR(s2mps11->rdev[i])) {
-- 
1.7.0.4

