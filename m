Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbaAHBCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 20:02:24 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:28831 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaAHBCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 20:02:18 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-8f-52cca39894f0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/3] regulator: core: Fix checkpatch issue
Date: Wed, 08 Jan 2014 10:02:16 +0900
Message-id: <002001cf0c0d$461abfa0$d2503ee0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8MDUYAj2m3DqtwQ9mZHqZTKqWOEA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zY90Zi88EGXxfbmMx9eETNovLCy+x
	Wny70sFkcXnXHDYHFo+ds+6ye2xa1cnm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBkdv3UL
	pghWrJop2cC4l7eLkZNDQsBE4suSuWwQtpjEhXvrgWwuDiGBZYwSU3b9YoUpet3xhgUiMZ1R
	4lbnQlYI5xejxPET+5hBqtgE1CS+fDnM3sXIwSEioCrx/5U7iMkskCvRvS0dpEJYwEri/PN1
	YNUsQBUXtixmArF5BWwlXh/9ywxhC0r8mHyPBcRmFtCSWL/zOBOELS+xec1bZpCREgLqEo/+
	6oKERQT0JD5vWgtVIiKx78U7RpDLJAQ2sUv82HeCCWKXgMS3yYdYIHplJTYdYIZ4S1Li4Iob
	LBMYxWYh2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYyQ+Jq4g/H+
	AetDjMlA6ycyS4km5wPjM68k3tDYzMjC1MTU2Mjc0ow0YSVx3vRHSUFCAumJJanZqakFqUXx
	RaU5qcWHGJk4OKUaGMM+nw1J+PXc2ekUk8ISB0EWhqCW85Y3HrN/lhaYtDnL6WLzYoNfAZMf
	XbfQ8F3Cfs24TtVomVVpkLxnk+g65l+Zmr6dn3m9a+5WuG0wnrclcnGqQEbVywsnvNxret85
	/mkv38xU28H1jt1ktURNvMH0N4tXZS1UOn05/cL8mG//67S3bjjnpcRSnJFoqMVcVJwIAFqk
	p1PFAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xoO6MxWeCDA4esLCY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpsDi8fOWXfZPTat6mTz6NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMjt+6BVMEK1bNlGxg3MvbxcjJISFgIvG64w0LhC0mceHeerYu
	Ri4OIYHpjBK3OheyQji/GCWOn9jHDFLFJqAm8eXLYfYuRg4OEQFVif+v3EFMZoFcie5t6SAV
	wgJWEuefrwOrZgGquLBlMROIzStgK/H66F9mCFtQ4sfke2B7mQW0JNbvPM4EYctLbF7zlhlk
	pISAusSjv7ogYREBPYnPm9ZClYhI7HvxjnECo8AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihO
	Ss811CtOzC0uzUvXS87P3cQIjt5nUjsYVzZYHGIU4GBU4uG9oXYmSIg1say4MvcQowQHs5II
	77FuoBBvSmJlVWpRfnxRaU5q8SHGZKBHJzJLiSbnAxNLXkm8obGJmZGlkZmFkYm5OWnCSuK8
	B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwiqTN2Md6aJ6Mx7mexb4aebH5ZXpWv1hlk1+cTWdq
	y7GMK7Q/e2PfsuPpmozzV5vf/sDEWl9uGbo/wOuZjOKxM2WPnx5dezfjwSRLhgMtp22UY97u
	cCtnmBd0l1PQb1lv22P7k9c9PuZzRJQpCDU/+HTMKq/tVXtK3pkVTw4nXwiYdvS2qvwSJZbi
	jERDLeai4kQA/L5tlSIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch errors and warnings.

  ERROR: trailing whitespace
  ERROR: return is not a function, parentheses are not required
  WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/core.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9888f26..b38a6b6 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1334,9 +1334,8 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 	 * If we have return value from dev_lookup fail, we do not expect to
 	 * succeed, so, quit with appropriate error value
 	 */
-	if (ret && ret != -ENODEV) {
+	if (ret && ret != -ENODEV)
 		goto out;
-	}
 
 	if (!devname)
 		devname = "deviceless";
@@ -2245,7 +2244,7 @@ int regulator_is_supported_voltage(struct regulator *regulator,
 	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE)) {
 		ret = regulator_get_voltage(regulator);
 		if (ret >= 0)
-			return (min_uV <= ret && ret <= max_uV);
+			return min_uV <= ret && ret <= max_uV;
 		else
 			return ret;
 	}
@@ -2417,7 +2416,7 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 	ret = regulator_check_voltage(rdev, &min_uV, &max_uV);
 	if (ret < 0)
 		goto out;
-	
+
 	/* restore original values in case of error */
 	old_min_uV = regulator->min_uV;
 	old_max_uV = regulator->max_uV;
@@ -2431,7 +2430,7 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 	ret = _regulator_do_set_voltage(rdev, min_uV, max_uV);
 	if (ret < 0)
 		goto out2;
-	
+
 out:
 	mutex_unlock(&rdev->mutex);
 	return ret;
@@ -3836,9 +3835,8 @@ static int __init regulator_init_complete(void)
 			 * goes wrong. */
 			rdev_info(rdev, "disabling\n");
 			ret = ops->disable(rdev);
-			if (ret != 0) {
+			if (ret != 0)
 				rdev_err(rdev, "couldn't disable: %d\n", ret);
-			}
 		} else {
 			/* The intention is that in future we will
 			 * assume that full constraints are provided
-- 
1.7.10.4


