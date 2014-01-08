Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbaAHBDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 20:03:38 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:49116 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbaAHBDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 20:03:35 -0500
X-AuditID: cbfee68e-b7f566d000002344-70-52cca3dbec7a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Sascha Hauer'" <s.hauer@pengutronix.de>
References: <002001cf0c0d$461abfa0$d2503ee0$%han@samsung.com>
In-reply-to: <002001cf0c0d$461abfa0$d2503ee0$%han@samsung.com>
Subject: [PATCH 2/3] regulator: mc13892: Fix checkpatch issue
Date: Wed, 08 Jan 2014 10:03:22 +0900
Message-id: <002101cf0c0d$6d90d470$48b27d50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8MDUYAj2m3DqtwQ9mZHqZTKqWOEAAABFPg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zQ93bi88EGSxbzmkx9eETNovLCy+x
	Wny70sFkcXnXHDaLv9s3sTiweuycdZfdY9OqTjaP/r8GHn1bVjF6fN4kF8AaxWWTkpqTWZZa
	pG+XwJVx89RC9oJ/ohWLjrSwNjAuFu5i5OSQEDCRWH13MTuELSZx4d56ti5GLg4hgWWMEjNm
	PWOBKfrc2c4CkZjOKHFtayM7hPOLUWLu/K2sIFVsAmoSX74cBkpwcIgIqEr8f+UOUsMsMI1R
	YlXfW2aQGiEBW4lv588xgticAnYSLx40gvUKA8V/3v0KVsMC1Lvk2mM2EJsXKD5nygF2CFtQ
	4sfke2AXMQtoSazfeZwJwpaX2LwGZD4H0KXqEo/+6oKERQSMJL5N3MoOUSIise/FO0aQeyQE
	brFL3Oj4yg6xS0Di2+RDLBC9shKbDjBDPCwpcXDFDZYJjBKzkGyehWTzLCSbZyFZsYCRZRWj
	aGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGSKT27WC8ecD6EGMy0PqJzFKiyfnASM8riTc0NjOy
	MDUxNTYytzQjTVhJnHfRw6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYx+eml3Ig4tb5Yp
	OGxamnFl3mdB9lnWvoz+awVc1oVOmRTo1f+/7PVn2TMz7Nl2G72e3/qlbLfY8yoru+AzXpql
	EY8fSHZW3PtaVfooNuGK99R3WrPdJ2n8UMz4vzqqr8Cdld+WNV667PpktbZfBdYSM5yXM4d/
	kAtx+3bWj//7pNLcm8oR3kosxRmJhlrMRcWJAFfeulzqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd3bi88EGRxbwmox9eETNovLCy+x
	Wny70sFkcXnXHDaLv9s3sTiweuycdZfdY9OqTjaP/r8GHn1bVjF6fN4kF8Aa1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYcfPUQvaCf6IVi460sDYwLhbuYuTkkBAwkfjc
	2c4CYYtJXLi3nq2LkYtDSGA6o8S1rY3sEM4vRom587eyglSxCahJfPlyGCjBwSEioCrx/5U7
	SA2zwDRGiVV9b5lBaoQEbCW+nT/HCGJzCthJvHjQCNYrDBT/efcrWA0LUO+Sa4/ZQGxeoPic
	KQfYIWxBiR+T74FdxCygJbF+53EmCFteYvMakPkcQJeqSzz6qwsSFhEwkvg2cSs7RImIxL4X
	7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4DTwTGoH
	48oGi0OMAhyMSjy8N9TOBAmxJpYVV+YeYpTgYFYS4T3WDRTiTUmsrEotyo8vKs1JLT7EmAz0
	6ERmKdHkfGCKyiuJNzQ2MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkG
	RkedqCSeGYxrYx/Kzwk0LhG5UFFpu+TVhTtzBcI6vgj3vDdU+ep0Ruhv8+uAL0vvv1VR3Pfn
	XFHeW9tc9sZ76bUXPVxXSMQKXvS7M9Eg6FXFv4A3V9YGdiWJmjm9OCvzLavl8kKByoN3z/Zt
	be6TF7rc9Us1qVeV+dsns0up7G9Zi69wvpA6qMRSnJFoqMVcVJwIABOwH91HAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch warnings.

  WARNING: Avoid unnecessary line continuations
  WARNING: line over 80 characters

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/mc13892-regulator.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 96c9f80..f374fa5 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -274,25 +274,25 @@ static struct mc13xxx_regulator mc13892_regulators[] = {
 	MC13892_SW_DEFINE(SW4, SWITCHERS3, SWITCHERS3, mc13892_sw),
 	MC13892_FIXED_DEFINE(SWBST, SWITCHERS5, mc13892_swbst),
 	MC13892_FIXED_DEFINE(VIOHI, REGULATORMODE0, mc13892_viohi),
-	MC13892_DEFINE_REGU(VPLL, REGULATORMODE0, REGULATORSETTING0,	\
+	MC13892_DEFINE_REGU(VPLL, REGULATORMODE0, REGULATORSETTING0,
 		mc13892_vpll),
-	MC13892_DEFINE_REGU(VDIG, REGULATORMODE0, REGULATORSETTING0,	\
+	MC13892_DEFINE_REGU(VDIG, REGULATORMODE0, REGULATORSETTING0,
 		mc13892_vdig),
-	MC13892_DEFINE_REGU(VSD, REGULATORMODE1, REGULATORSETTING1,	\
+	MC13892_DEFINE_REGU(VSD, REGULATORMODE1, REGULATORSETTING1,
 		mc13892_vsd),
-	MC13892_DEFINE_REGU(VUSB2, REGULATORMODE0, REGULATORSETTING0,	\
+	MC13892_DEFINE_REGU(VUSB2, REGULATORMODE0, REGULATORSETTING0,
 		mc13892_vusb2),
-	MC13892_DEFINE_REGU(VVIDEO, REGULATORMODE1, REGULATORSETTING1,	\
+	MC13892_DEFINE_REGU(VVIDEO, REGULATORMODE1, REGULATORSETTING1,
 		mc13892_vvideo),
-	MC13892_DEFINE_REGU(VAUDIO, REGULATORMODE1, REGULATORSETTING1,	\
+	MC13892_DEFINE_REGU(VAUDIO, REGULATORMODE1, REGULATORSETTING1,
 		mc13892_vaudio),
-	MC13892_DEFINE_REGU(VCAM, REGULATORMODE1, REGULATORSETTING0,	\
+	MC13892_DEFINE_REGU(VCAM, REGULATORMODE1, REGULATORSETTING0,
 		mc13892_vcam),
-	MC13892_DEFINE_REGU(VGEN1, REGULATORMODE0, REGULATORSETTING0,	\
+	MC13892_DEFINE_REGU(VGEN1, REGULATORMODE0, REGULATORSETTING0,
 		mc13892_vgen1),
-	MC13892_DEFINE_REGU(VGEN2, REGULATORMODE0, REGULATORSETTING0,	\
+	MC13892_DEFINE_REGU(VGEN2, REGULATORMODE0, REGULATORSETTING0,
 		mc13892_vgen2),
-	MC13892_DEFINE_REGU(VGEN3, REGULATORMODE1, REGULATORSETTING0,	\
+	MC13892_DEFINE_REGU(VGEN3, REGULATORMODE1, REGULATORSETTING0,
 		mc13892_vgen3),
 	MC13892_FIXED_DEFINE(VUSB, USB1, mc13892_vusb),
 	MC13892_GPO_DEFINE(GPO1, POWERMISC, mc13892_gpo),
@@ -476,8 +476,8 @@ static int mc13892_sw_regulator_set_voltage_sel(struct regulator_dev *rdev,
 	}
 
 	mc13xxx_lock(priv->mc13xxx);
-	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13892_regulators[id].vsel_reg, mask,
-			      reg_value);
+	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13892_regulators[id].vsel_reg,
+			      mask, reg_value);
 	mc13xxx_unlock(priv->mc13xxx);
 
 	return ret;
-- 
1.7.10.4


