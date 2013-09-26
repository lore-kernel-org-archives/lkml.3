Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab3IZCHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:07:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33192 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3IZCHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:07:38 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-a8-524396e8d0d3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Heiko Stuebner'" <heiko@sntech.de>,
        "'Axel Lin'" <axel.lin@ingics.com>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
In-reply-to: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
Subject: [PATCH V2 07/18] regulator: lp3971: use devm_regulator_register()
Date: Thu, 26 Sep 2013 11:07:36 +0900
Message-id: <000d01ceba5d$2bb4b0f0$831e12d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66XGktrYXfQ+q4TvOtJpq/iZ1T4wAAJkkA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zY92X05yDDD5EWhyZ85XZYurDJ2wW
	/x+9ZrW4vPASq8W3Kx1MFpd3zWFzYPPYOesuu0fbzzKPTas62Tz6tqxi9Nh+bR6zx+dNcgFs
	UVw2Kak5mWWpRfp2CVwZm2afZyvo4a5Y8PE6UwNjO2cXIyeHhICJRPeRl4wQtpjEhXvr2boY
	uTiEBJYxSvTOWMAKU/Rr7xpmiMQiRomt99+zQji/GCU+TtkNVsUmoCbx5cth9i5GDg4RAVWJ
	/6/cQWqYBbYySmyZdJIdpEZIwFbi1O+LbCA2p4CdxOlrG8F6hQW8JBrv3waLswD1Xt78A+wk
	XqD61d/aWCFsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDLJXQkBd4tFfXZCwiICRxLw9U9kg
	SkQk9r14xwhyj4TAR3aJxl3fWCF2CUh8m3yIBaJXVmLTAWaIhyUlDq64wTKBUWIWks2zkGye
	hWTzLCQrFjCyrGIUTS1ILihOSi8y1CtOzC0uzUvXS87P3cQIid3eHYy3D1gfYkwGWj+RWUo0
	OR8Y+3kl8YbGZkYWpiamxkbmlmakCSuJ86q1WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRq
	YNzkyOF5Tfaz8ZyY98lTduSsnvqRnzvRUG+C6lfpnskSep8OFDcm5ARxf3SeNaHJ81JNt3bO
	sa1fnGN3agXHv495373+5h3F3FydraJZTopc5xVNit/c29rsar4weHN84MEX+k0MrPXyXgaH
	di17cS5O5WC3bsG3uCM9rg5nGeQvXKnI0ea5qsRSnJFoqMVcVJwIABYi0LrzAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jAd0X05yDDB49srQ4Mucrs8XUh0/Y
	LP4/es1qcXnhJVaLb1c6mCwu75rD5sDmsXPWXXaPtp9lHptWdbJ59G1Zxeix/do8Zo/Pm+QC
	2KIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5Q
	UihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWZsmn2eraCHu2LBx+tMDYzt
	nF2MnBwSAiYSv/auYYawxSQu3FvP1sXIxSEksIhRYuv996wQzi9GiY9TdrOCVLEJqEl8+XKY
	vYuRg0NEQFXi/yt3kBpmga2MElsmnWQHqRESsJU49fsiG4jNKWAncfraRrBeYQEvicb7t8Hi
	LEC9lzf/YASxeYHqV39rY4WwBSV+TL7HAmIzC2hJrN95nAnClpfYvOYtM8heCQF1iUd/dUHC
	IgJGEvP2TGWDKBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtc
	mpeul5yfu4kRnBqeSe9gXNVgcYhRgINRiYf3ArNzkBBrYllxZe4hRgkOZiUR3m9GQCHelMTK
	qtSi/Pii0pzU4kOMyUCPTmSWEk3OB6atvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeW
	pGanphakFsFsYeLglGpgVLMTns42tdjpdolyg9Q1Rt30vCcFGzbG7HnjXPR7bn6328rXZdlp
	J8xNJwvZ8y/Rd9xU+v+eVmA+y1w/HuVdZ483vvuYNCV+8/pqF6cs7oanO0VK8rR5Ko59vNGx
	3mW/9sM/5z592BatnSon0W5smykoImpQq5RbJLx8otCcT0EuDNEuuT+VWIozEg21mIuKEwGs
	FY7FUQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/lp3971.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index 5a4604e..97452a2 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -400,8 +400,9 @@ static int setup_regulators(struct lp3971 *lp3971,
 		config.init_data = reg->initdata;
 		config.driver_data = lp3971;
 
-		lp3971->rdev[i] = regulator_register(&regulators[reg->id],
-						     &config);
+		lp3971->rdev[i] = devm_regulator_register(lp3971->dev,
+							  &regulators[reg->id],
+							  &config);
 		if (IS_ERR(lp3971->rdev[i])) {
 			err = PTR_ERR(lp3971->rdev[i]);
 			dev_err(lp3971->dev, "regulator init failed: %d\n",
@@ -413,8 +414,6 @@ static int setup_regulators(struct lp3971 *lp3971,
 	return 0;
 
 error:
-	while (--i >= 0)
-		regulator_unregister(lp3971->rdev[i]);
 	kfree(lp3971->rdev);
 	lp3971->rdev = NULL;
 err_nomem:
@@ -463,10 +462,6 @@ static int lp3971_i2c_probe(struct i2c_client *i2c,
 static int lp3971_i2c_remove(struct i2c_client *i2c)
 {
 	struct lp3971 *lp3971 = i2c_get_clientdata(i2c);
-	int i;
-
-	for (i = 0; i < lp3971->num_regulators; i++)
-		regulator_unregister(lp3971->rdev[i]);
 
 	kfree(lp3971->rdev);
 
-- 
1.7.10.4


