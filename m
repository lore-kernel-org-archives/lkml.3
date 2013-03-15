Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3COJQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:16:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61114 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab3COJQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:16:12 -0400
X-AuditID: cbfee68d-b7f786d000005188-ab-5142e6db20d5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <006201ce215d$6f133d10$4d39b730$%han@samsung.com>
In-reply-to: <006201ce215d$6f133d10$4d39b730$%han@samsung.com>
Subject: [PATCH 6/6] gpio: pcf857x: use devm_kzalloc()
Date: Fri, 15 Mar 2013 18:16:11 +0900
Message-id: <006701ce215d$bc2af4d0$3480de70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4hXW7HXikowtUaTheLztVYvIsx2AAAEEbQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t8zI93bz5wCDb5tVba4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZrz7vZi94yFFx4sNn1gbGPvYuRg4OCQETicVP1bsYOYFMMYkL
	99azgdhCAssYJX6sEIQpmXzBCSK8iFGi84llFyMXkD2bSeJL60ZmkASbgJrEly+H2UFsEQE9
	iRsXOhhBbGaBIonnXbNYIZptJY5c/8QCYnMK2Ek8W9fHCjJfWMBMomlSAEiYRUBVYuOJK2Ct
	vEDlF782M0PYghI/Jt9jgRipJbF+53EmCFteYvOat8wQZ6pLPPqrC3GBkcSzFdfYIUpEJPa9
	eMcIcrKEwDx2iWPPljJB7BKQ+Db5EAtEr6zEpgPMkFCQlDi44gbLBEaJWUg2z0KyeRaSzbOQ
	rFjAyLKKUTS1ILmgOCm9yFCvODG3uDQvXS85P3cTIySiencw3j5gfYgxGWj9RGYp0eR8YETm
	lcQbGpsZWZiamBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFx6Zbw
	V7FtZ2N2iW4JPRKx8bnwpqaWI1JahY9OMHcee19+cE7lub/Gj7kfZuy8ZXbN9yfjIdV5DC/n
	vvrImvnko5b5mR2T7dgYTj3VvVBi/2hdlvf8E3m8uUvXVHPJb5t81+TR3wn9U+Z3v53ToxNu
	YsGs8nyNhd/vNhvxh1pzBU9t/z255P+9ACWW4oxEQy3mouJEAA6euQW+AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgO7tZ06BBu/ny1tc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjFefd7MXPOSoOPHhM2sD
	Yx97FyMHh4SAicTkC05djJxAppjEhXvr2UBsIYFFjBKdTyy7GLmA7NlMEl9aNzKDJNgE1CS+
	fDnMDmKLCOhJ3LjQwQhiMwsUSTzvmsUK0WwrceT6JxYQm1PATuLZuj5WkF3CAmYSTZMCQMIs
	AqoSG09cAWvlBSq/+LWZGcIWlPgx+R4LxEgtifU7jzNB2PISm9e8ZYY4WV3i0V9diAuMJJ6t
	uMYOUSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/
	dxMjOGafSe1gXNlgcYhRgINRiYf3QL9DoBBrYllxZe4hRgkOZiURXk8vx0Ah3pTEyqrUovz4
	otKc1OJDjMlAj05klhJNzgemk7ySeENjEzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YW
	pBbBbGHi4JRqYDR+zbTG65jfh7h4cbc1lz6dbV0icnzTcd+0Z7rVNf7PhWcYbjrc4VH7qufr
	XJNT7hqiURVsT1TSTv5dvknDUdrbo9mMe+KBCNeKtJANnsmz793rMur3U8vXK92hVlDv2BhT
	+LdcSe1ZF4O4vPyrvn1yMU7Jzy6x7X24oyrmYLvOyzpedqswJZbijERDLeai4kQAlJFFEh0D	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/gpio/gpio-pcf857x.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
index a19b745..4f76514 100644
--- a/drivers/gpio/gpio-pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -267,7 +267,7 @@ static int pcf857x_probe(struct i2c_client *client,
 	}
 
 	/* Allocate, initialize, and register this gpio_chip. */
-	gpio = kzalloc(sizeof *gpio, GFP_KERNEL);
+	gpio = devm_kzalloc(&client->dev, sizeof(*gpio), GFP_KERNEL);
 	if (!gpio)
 		return -ENOMEM;
 
@@ -390,7 +390,6 @@ fail:
 	if (pdata && client->irq)
 		pcf857x_irq_domain_cleanup(gpio);
 
-	kfree(gpio);
 	return status;
 }
 
@@ -415,9 +414,7 @@ static int pcf857x_remove(struct i2c_client *client)
 		pcf857x_irq_domain_cleanup(gpio);
 
 	status = gpiochip_remove(&gpio->chip);
-	if (status == 0)
-		kfree(gpio);
-	else
+	if (status)
 		dev_err(&client->dev, "%s --> %d\n", "remove", status);
 	return status;
 }
-- 
1.7.2.5


