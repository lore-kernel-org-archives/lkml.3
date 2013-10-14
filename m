Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab3JNIxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:53:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53903 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab3JNIxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:53:42 -0400
X-AuditID: cbfee68e-b7f756d000004512-0e-525bb115bf55
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Laxman Dewangan'" <ldewangan@nvidia.com>
References: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com>
In-reply-to: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com>
Subject: [PATCH 10/11] regulator: tps65910: Fix checkpatch issue
Date: Mon, 14 Oct 2013 17:53:40 +0900
Message-id: <000901cec8ba$e1393ca0$a3abb5e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7IuZK01KcLw1AZSDCREfGxHfkpOgAAS7nQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zA13RjdFBBlueM1lMffiEzeLywkus
	Fkv3rWax+Halg8ni8q45bA6sHjtn3WX32LSqk82jt/kdm0ffllWMHp83yQWwRnHZpKTmZJal
	FunbJXBlTOxuYClo5K9Y/vkMWwPjJp4uRk4OCQETiePHTzBC2GISF+6tZ+ti5OIQEljGKNE2
	9xA7TFFr2xc2EFtIYBGjxN+pohBFvxglWj5dBOtmE1CT+PLlMFADB4eIgKrE/1fuIDXMAtMZ
	Jc7OvM8O0Wwrcff0JWYQm1PATmLht10sILawgINE88SrTCA2C1Dv9q6TYDW8QPXT9r5gg7AF
	JX5MvgdWzyygJbF+53EmCFteYvOat8wgeyUE1CUe/dWFOMFI4tAxeYgKEYl9L94xgpwjIXCN
	XeLX6deMEKsEJL5NPsQC0SorsekAM8S7khIHV9xgmcAoMQvJ4llIFs9CsngWkhULGFlWMYqm
	FiQXFCelFxnpFSfmFpfmpesl5+duYoTEad8OxpsHrA8xJgOtn8gsJZqcD4zzvJJ4Q2MzIwtT
	E1NjI3NLM9KElcR51VqsA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw9p5bf/+q0Red6Rn/
	ZU18lnv3Bml7Lb2xRX6Cxn3Zrs/hS+Z6TK6K1hU8PymEzcHIoEMpL37KItewW6WTY1We7zya
	1fzIy/Lb36YK96MTygXv3jY4kNf2I+rZkZ27DthPOGbeNuvJ/ky/koSu3cHTc97LJ5kWV6tu
	4jv77O7ErfaTjFpmeIvKK7EUZyQaajEXFScCAGhOcTXpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jAV2RjdFBBm8/WltMffiEzeLywkus
	Fkv3rWax+Halg8ni8q45bA6sHjtn3WX32LSqk82jt/kdm0ffllWMHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZkzsbmApaOSvWP75DFsD4yaeLkZODgkBE4nW
	ti9sELaYxIV768FsIYFFjBJ/p4p2MXIB2b8YJVo+XWQESbAJqEl8+XKYvYuRg0NEQFXi/yt3
	kBpmgemMEmdn3meHaLaVuHv6EjOIzSlgJ7Hw2y4WEFtYwEGieeJVJhCbBah3e9dJsBpeoPpp
	e1+wQdiCEj8m3wOrZxbQkli/8zgThC0vsXnNW2aQvRIC6hKP/upCnGAkceiYPESFiMS+F+8Y
	JzAKzUIyaBaSQbOQDJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOAk8ExqB+PK
	BotDjAIcjEo8vAJO0UFCrIllxZW5hxglOJiVRHgF5wGFeFMSK6tSi/Lji0pzUosPMSYD/TmR
	WUo0OR+YoPJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgVE5
	1j9alZfhyJf43p7vS86VBs51MrnUUyL+gH9thoDnEfeZd2KztnJbqGwWbghwdjpgeWGS7+lD
	7wxsxGQ5zBTjyl1/8Wv6KC1VqwqctNbdJ0T07VtD/hKGFQ3Kjzrncq3mOXpaKaJk2dHQ5OgX
	04R/65z5v523894DI+P/17NX58lul3trqsRSnJFoqMVcVJwIAErrXTFGAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch errors and warning.

  ERROR: spaces required around that '=' (ctx:VxV)
  ERROR: space required before the open parenthesis '('
  WARNING: line over 80 characters

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/tps65910-regulator.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index ccde074..23f8d1c 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -481,7 +481,7 @@ static int tps65910_get_voltage_dcdc_sel(struct regulator_dev *dev)
 
 	/* multiplier 0 == 1 but 2,3 normal */
 	if (!mult)
-		mult=1;
+		mult = 1;
 
 	if (sr) {
 		/* normalise to valid range */
@@ -685,7 +685,7 @@ static int tps65910_list_voltage_dcdc(struct regulator_dev *dev,
 	case TPS65910_REG_VDD2:
 		mult = (selector / VDD1_2_NUM_VOLT_FINE) + 1;
 		volt = VDD1_2_MIN_VOLT +
-				(selector % VDD1_2_NUM_VOLT_FINE) * VDD1_2_OFFSET;
+			(selector % VDD1_2_NUM_VOLT_FINE) * VDD1_2_OFFSET;
 		break;
 	case TPS65911_REG_VDDCTRL:
 		volt = VDDCTRL_MIN_VOLT + (selector * VDDCTRL_OFFSET);
@@ -703,7 +703,7 @@ static int tps65911_list_voltage(struct regulator_dev *dev, unsigned selector)
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
 	int step_mv = 0, id = rdev_get_id(dev);
 
-	switch(id) {
+	switch (id) {
 	case TPS65911_REG_LDO1:
 	case TPS65911_REG_LDO2:
 	case TPS65911_REG_LDO4:
@@ -1074,7 +1074,7 @@ static int tps65910_probe(struct platform_device *pdev)
 	tps65910_reg_set_bits(pmic->mfd, TPS65910_DEVCTRL,
 				DEVCTRL_SR_CTL_I2C_SEL_MASK);
 
-	switch(tps65910_chip_id(tps65910)) {
+	switch (tps65910_chip_id(tps65910)) {
 	case TPS65910:
 		pmic->get_ctrl_reg = &tps65910_get_ctrl_register;
 		pmic->num_regulators = ARRAY_SIZE(tps65910_regs);
-- 
1.7.10.4


