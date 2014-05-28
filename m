Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaE1LKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 07:10:23 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8302 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbaE1LKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 07:10:20 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-cc-5385c4191eff
From: Chanwoo Choi <cw00.choi@samsung.com>
To: sbkim73@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 3/4] regulator: s2mps11: Set offset to voltage hexadecimal code
 of S2MPU02 LDO regulators
Date: Wed, 28 May 2014 20:10:10 +0900
Message-id: <1401275411-21947-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1401275411-21947-1-git-send-email-cw00.choi@samsung.com>
References: <1401275411-21947-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSqCt5pDXY4Mc9U4upD5+wWVz/8pzV
	ovPsE2aLs01v2C3ufz3KaPHtSgeTxeVdc9gsbjeuYLM43c1qcXHFFyYHLo+ds+6ye2xa1cnm
	cefaHjaPeScDPfq2rGL0+LxJLoAtissmJTUnsyy1SN8ugSujubOLueCJRMXWk5tZGhhviHQx
	cnBICJhIXG926GLkBDLFJC7cW8/WxcjFISSwlFHiz++ZLBAJE4mGLW/YIRLTGSWmft/OCJIQ
	Emhikph02hDEZhPQktj/4gZYt4hAL6NE/8x+JpAEs0ClxO11t8AmCQtkS6z5/IgVxGYRUJU4
	O7GLGcTmFXCVuDa1kwlim5zEhz2P2EFsTgE3icXdq1gglrlKnN/YywyyQEJgF7vE6s1X2SEG
	CUh8m3yIBeIdWYlNB5gh5khKHFxxg2UCo/ACRoZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmb
	GIGxcPrfs4k7GO8fsD7EmAw0biKzlGhyPjCW8kriDY3NjCxMTUyNjcwtzUgTVhLnTX+UFCQk
	kJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBMWtDQpuX3qLd2tvzDY50xTbr+d/jyXY8WW2WPifM
	1P55yYvLNwvO5ZiZrK8zFM2aHMZ97pjBcjatSV9Xeubo3WLpTBRYF7zy1sE3Ee9qVqW0Cx8U
	sekw0J9cs0N04ZegS9l3CjybFL749x+WuWu9WXzlwbsab7pD1m7ct+rNkcI4zfW31KwVlFiK
	MxINtZiLihMBuXesu5sCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t9jQV3JI63BBjfuaVlMffiEzeL6l+es
	Fp1nnzBbnG16w25x/+tRRotvVzqYLC7vmsNmcbtxBZvF6W5Wi4srvjA5cHnsnHWX3WPTqk42
	jzvX9rB5zDsZ6NG3ZRWjx+dNcgFsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaW
	FuZKCnmJuam2Si4+AbpumTlAlykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkAD
	CWsYM5o7u5gLnkhUbD25maWB8YZIFyMnh4SAiUTDljfsELaYxIV769m6GLk4hASmM0pM/b6d
	ESQhJNDEJDHptCGIzSagJbH/xQ2wIhGBXkaJ/pn9TCAJZoFKidvrbrGA2MIC2RJrPj9iBbFZ
	BFQlzk7sYgaxeQVcJa5N7WSC2CYn8WHPI7DNnAJuEou7V7FALHOVOL+xl3kCI+8CRoZVjKKp
	BckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGx9kxqB+PKBotDjAIcjEo8vAcWtwQLsSaWFVfmHmKU
	4GBWEuE139saLMSbklhZlVqUH19UmpNafIgxGeiqicxSosn5wDSQVxJvaGxiZmRpZG5oYWRs
	TpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MGuqCFwXNNfky1A1lUvvnyq9xdvFKmc0t
	3am5+ff5ncciXPxL5Ir3dYUtEWu+KL3JJ3v9L/Gvprn1Jr+OdUadef1f1SH38tJVOfz5n2V9
	d0udDhD8f3bSMrM9wtemBQWv2KIhMvPATrZJB3/fEUlQvs/FmXPR+5e+3ybXH/+zlyW3Sqo8
	m/lNiaU4I9FQi7moOBEAQYX6ZfkCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwa Lee <jonghwa3.lee@samsung.com>

Different with s2mps1x series, s2mpus02's LDO has offset in voltage hexadecimal
code, which is used as in selector in regulator subsystem. It means the value of
minimum voltage is not start with 0x0, but has certain offset.
(as like BUCK regulator in both of s2mps1x and s2mpu02)

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/regulator/s2mps11.c         | 5 +++++
 include/linux/mfd/samsung/s2mpu02.h | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 064d44b..6e7b322 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -732,6 +732,7 @@ static struct regulator_ops s2mpu02_buck_ops = {
 	.owner		= THIS_MODULE,			\
 	.min_uV		= S2MPU02_LDO_MIN_900MV,	\
 	.uV_step	= S2MPU02_LDO_STEP_12_5MV,	\
+	.linear_min_sel	= S2MPU02_LDO_GROUP1_START_SEL,	\
 	.n_voltages	= S2MPU02_LDO_N_VOLTAGES,	\
 	.vsel_reg	= S2MPU02_REG_L1CTRL,		\
 	.vsel_mask	= S2MPU02_LDO_VSEL_MASK,	\
@@ -746,6 +747,7 @@ static struct regulator_ops s2mpu02_buck_ops = {
 	.owner		= THIS_MODULE,			\
 	.min_uV		= S2MPU02_LDO_MIN_1050MV,	\
 	.uV_step	= S2MPU02_LDO_STEP_25MV,	\
+	.linear_min_sel	= S2MPU02_LDO_GROUP2_START_SEL,	\
 	.n_voltages	= S2MPU02_LDO_N_VOLTAGES,	\
 	.vsel_reg	= S2MPU02_REG_L2CTRL1,		\
 	.vsel_mask	= S2MPU02_LDO_VSEL_MASK,	\
@@ -760,6 +762,7 @@ static struct regulator_ops s2mpu02_buck_ops = {
 	.owner		= THIS_MODULE,			\
 	.min_uV		= S2MPU02_LDO_MIN_900MV,	\
 	.uV_step	= S2MPU02_LDO_STEP_12_5MV,	\
+	.linear_min_sel	= S2MPU02_LDO_GROUP1_START_SEL,	\
 	.n_voltages	= S2MPU02_LDO_N_VOLTAGES,	\
 	.vsel_reg	= S2MPU02_REG_L3CTRL + num - 3,	\
 	.vsel_mask	= S2MPU02_LDO_VSEL_MASK,	\
@@ -774,6 +777,7 @@ static struct regulator_ops s2mpu02_buck_ops = {
 	.owner		= THIS_MODULE,			\
 	.min_uV		= S2MPU02_LDO_MIN_1050MV,	\
 	.uV_step	= S2MPU02_LDO_STEP_25MV,	\
+	.linear_min_sel	= S2MPU02_LDO_GROUP2_START_SEL,	\
 	.n_voltages	= S2MPU02_LDO_N_VOLTAGES,	\
 	.vsel_reg	= S2MPU02_REG_L3CTRL + num - 3,	\
 	.vsel_mask	= S2MPU02_LDO_VSEL_MASK,	\
@@ -788,6 +792,7 @@ static struct regulator_ops s2mpu02_buck_ops = {
 	.owner		= THIS_MODULE,			\
 	.min_uV		= S2MPU02_LDO_MIN_1600MV,	\
 	.uV_step	= S2MPU02_LDO_STEP_50MV,	\
+	.linear_min_sel	= S2MPU02_LDO_GROUP3_START_SEL,	\
 	.n_voltages	= S2MPU02_LDO_N_VOLTAGES,	\
 	.vsel_reg	= S2MPU02_REG_L3CTRL + num - 3,	\
 	.vsel_mask	= S2MPU02_LDO_VSEL_MASK,	\
diff --git a/include/linux/mfd/samsung/s2mpu02.h b/include/linux/mfd/samsung/s2mpu02.h
index 98406f4..c70d3e3 100644
--- a/include/linux/mfd/samsung/s2mpu02.h
+++ b/include/linux/mfd/samsung/s2mpu02.h
@@ -181,6 +181,10 @@ enum S2MPU02_regulators {
 #define S2MPU02_LDO_STEP_25MV		25000
 #define S2MPU02_LDO_STEP_50MV		50000
 
+#define S2MPU02_LDO_GROUP1_START_SEL	0x8
+#define S2MPU02_LDO_GROUP2_START_SEL	0xA
+#define S2MPU02_LDO_GROUP3_START_SEL	0x10
+
 #define S2MPU02_LDO_VSEL_MASK		0x3F
 #define S2MPU02_BUCK_VSEL_MASK		0xFF
 #define S2MPU02_ENABLE_MASK		(0x03 << S2MPU02_ENABLE_SHIFT)
-- 
1.8.0

