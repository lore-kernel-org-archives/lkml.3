Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab3HTHDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:03:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49491 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab3HTHDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:03:22 -0400
X-AuditID: cbfee68e-b7f276d000002279-73-521314b9ef50
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/6] mfd: max8997: use devm_*() functions
Date: Tue, 20 Aug 2013 16:03:20 +0900
Message-id: <005501ce9d73$5abdef80$1039ce80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6dc1R8g79VzzyFTE+e1519TXJs0g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zQ92dIsJBBl8+81lcXniJ1eL+16OM
	Fpd3zWGzON3N6sDicefaHjaPeScDPfq2rGL0+LxJLoAlissmJTUnsyy1SN8ugSvj8nzZguU8
	FQu3XWRuYGzm6mLk5JAQMJF49XMlE4QtJnHh3nq2LkYuDiGBZYwSl1bOZoQper2zmREisYhR
	YubBZSwQzi9GiZ0f14JVsQmoSXz5cpi9i5GDQ0TAT6JhBZjJLOAicXSaCEiFsIClxKP9S8Cq
	WQRUJWZfn8cMYvMCxZ+/PcACYQtK/Jh8D8xmFtCSWL/zOBOELS+xec1bZoh7FCR2nH0NNkdE
	QE9ixZcn7BA1IhL7XrwDu1NCYB27xJ3ve9gglglIfJt8iAXkHgkBWYlNB6DmSEocXHGDZQKj
	2Cwkq2chWT0LyepZSFYsYGRZxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iRESX307GG8esD7E
	mAy0fiKzlGhyPjA+80riDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1J
	LT7EyMTBKdXAKPDj4q+V7zh7nC+eCU7lqVNmUuVVS9u1huHTKu4X66WOiogwLClamhW/+9/u
	D41FszVdDH5e0E5782dd7/HrP1QEnvzYbvrjxnHhbdveXmCYcjF3xwGvVfUc3qeudy9sznhw
	XHb/saxaf9N9Km/Tp74PMjoW98ZxxwLd2i9/xdS9/7em/2U7/UCJpTgj0VCLuag4EQAeYtHD
	xQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xgO5OEeEggxnTuS0uL7zEanH/61FG
	i8u75rBZnO5mdWDxuHNtD5vHvJOBHn1bVjF6fN4kF8AS1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvh2lCaIibrgVM
	Y4Sub0gQXI+RARpIWMeYcXm+bMFynoqF2y4yNzA2c3UxcnJICJhIvN7ZzAhhi0lcuLeerYuR
	i0NIYBGjxMyDy1ggnF+MEjs/rgWrYhNQk/jy5TB7FyMHh4iAn0TDCjCTWcBF4ug0EZAKYQFL
	iUf7l4BVswioSsy+Po8ZxOYFij9/e4AFwhaU+DH5HpjNLKAlsX7ncSYIW15i85q3zBD3KEjs
	OPsabI6IgJ7Eii9P2CFqRCT2vXjHOIFRYBaSUbOQjJqFZNQsJC0LGFlWMYqmFiQXFCel5xrp
	FSfmFpfmpesl5+duYgRH7zPpHYyrGiwOMQpwMCrx8HYoCQUJsSaWFVfmHmKU4GBWEuF1+Q8U
	4k1JrKxKLcqPLyrNSS0+xJgM9OlEZinR5HxgYskriTc0NjEzsjQyszAyMTcnTVhJnPdgq3Wg
	kEB6YklqdmpqQWoRzBYmDk6pBsaYaQEOGwq2XQtbI9rh8SPjGLe6CdeyFaJPqhskp6seEONL
	ns9zq09/1adrcYuyNztF+XJwnPr3/fzUW7Y6384uuHpwbUJyjJ5a3qotZhEy36avKXw38cCF
	L7deHv5oqCt2+OevsrOWjim7zm6pLt+R4f7edfKMT/csml6dUA5Qkp8nmh7PcC9aiaU4I9FQ
	i7moOBEAKiWy4SIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/max8997.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index 1523047..cee098c 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -191,7 +191,8 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 	struct max8997_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	int ret = 0;
 
-	max8997 = kzalloc(sizeof(struct max8997_dev), GFP_KERNEL);
+	max8997 = devm_kzalloc(&i2c->dev, sizeof(struct max8997_dev),
+				GFP_KERNEL);
 	if (max8997 == NULL)
 		return -ENOMEM;
 
@@ -203,14 +204,12 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 
 	if (max8997->dev->of_node) {
 		pdata = max8997_i2c_parse_dt_pdata(max8997->dev);
-		if (IS_ERR(pdata)) {
-			ret = PTR_ERR(pdata);
-			goto err;
-		}
+		if (IS_ERR(pdata))
+			return PTR_ERR(pdata);
 	}
 
 	if (!pdata)
-		goto err;
+		return ret;
 
 	max8997->pdata = pdata;
 	max8997->ono = pdata->ono;
@@ -250,8 +249,6 @@ err_mfd:
 	i2c_unregister_device(max8997->muic);
 	i2c_unregister_device(max8997->haptic);
 	i2c_unregister_device(max8997->rtc);
-err:
-	kfree(max8997);
 	return ret;
 }
 
@@ -263,7 +260,6 @@ static int max8997_i2c_remove(struct i2c_client *i2c)
 	i2c_unregister_device(max8997->muic);
 	i2c_unregister_device(max8997->haptic);
 	i2c_unregister_device(max8997->rtc);
-	kfree(max8997);
 
 	return 0;
 }
-- 
1.7.10.4


