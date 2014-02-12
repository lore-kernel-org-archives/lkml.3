Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbaBLFbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 00:31:53 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24351 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaBLFbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 00:31:51 -0500
X-AuditID: cbfee68e-b7f566d000002344-8f-52fb07464a03
From: Jingoo Han <jg1.han@samsung.com>
To: "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>,
        "'Patil, Rachna'" <rachna@ti.com>
Subject: [PATCH] mfd: ti_am335x_tscadc: Use devm_ioremap_resource()
Date: Wed, 12 Feb 2014 14:31:49 +0900
Message-id: <000201cf27b3$ba62cc60$2f286520$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8ns7SQohyaxrOtRD2by1Re7cNcwA==
Content-language: ko
x-cr-hashedpuzzle: FhXK Iznt MFPI O2zZ Pq7p b5dk c6NI hGWa mAIW p7+9 xqa2 yj7T
 zx6R 0XFI 7izR
 AAF4MA==;6;YgBpAGcAZQBhAHMAeQBAAGwAaQBuAHUAdAByAG8AbgBpAHgALgBkAGUAOwBqAGcAMQAuAGgAYQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABlAGUALgBqAG8AbgBlAHMAQABsAGkAbgBhAHIAbwAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHIAYQBjAGgAbgBhAEAAdABpAC4AYwBvAG0AOwBzAGEAbQBlAG8AQABsAGkAbgB1AHgALgBpAG4AdABlAGwALgBjAG8AbQA=;Sosha1_v1;7;{3FE5E4AD-8845-4C3E-939E-00D6A876701E};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Wed,
 12 Feb 2014 05:31:39
 GMT;WwBQAEEAVABDAEgAXQAgAG0AZgBkADoAIAB0AGkAXwBhAG0AMwAzADUAeABfAHQAcwBjAGEAZABjADoAIABVAHMAZQAgAGQAZQB2AG0AXwBpAG8AcgBlAG0AYQBwAF8AcgBlAHMAbwB1AHIAYwBlACgAKQA=
x-cr-puzzleid: {3FE5E4AD-8845-4C3E-939E-00D6A876701E}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zY1039t9BBh8/sVpMuziJ2eLywkus
	Fve/HmW0uLxrDpvF9Ff32S1Od7M6sHncubaHzePduXPsHvNOBnr0bVnF6HH8xnYmj8+b5ALY
	orhsUlJzMstSi/TtErgymn7+ZS/4yFvxZu4m1gbGK9xdjJwcEgImEq+PHWWFsMUkLtxbz9bF
	yMUhJLCMUWLj9GfMMEXN7a9YIRKLGCXe71zEAuH8YpR4ta6JEaSKTUBN4suXw+wgtgiQfXPP
	LCaQImaBU4wSq1cdYAJJCAs4S+yf3coGYrMIqEpsObMIbAWvgK3E3K+nGCFsQYkfk++xgNjM
	AloS63ceZ4Kw5SU2r3kLVM8BdJK6xKO/uhC79CTmNe9ghSgRkdj34h0jyF4JgResEkvOTmWH
	eMFUYlXnHzaIxFt2iRcndzJCHCEg8W3yIRaIobISmw5AvSwpcXDFDZYJjBKzkJw0C8lJs5Cc
	NAvJ7gWMLKsYRVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxQuK3bwfjzQPWhxiTgdZPZJYSTc4H
	xn9eSbyhsZmRhamJqbGRuaUZacJK4ryLHiYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBU
	YsvLlcmTCLy0oIgnb9LpmdlmfqZn3pTNqND9cuozi/zd9w8m3Xh/KT7l2O/Zly6835rx3/xY
	CVNYyowdmteV+vky5unMa+aujKo0vJWpfZxRsYs/Pchh5y7XY5U3GyrF47oX6vRftnAqyRSx
	uTxbxeV9yiU5/zc2xzj9ONQuKk3W3iEuc1CJpTgj0VCLuag4EQAn+qWr9QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jAV039t9BBhMCLKZdnMRscXnhJVaL
	+1+PMlpc3jWHzWL6q/vsFqe7WR3YPO5c28Pm8e7cOXaPeScDPfq2rGL0OH5jO5PH501yAWxR
	DYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBHKCmU
	JeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzmn7+ZS/4yFvxZu4m1gbGK9xd
	jJwcEgImEs3tr1ghbDGJC/fWs3UxcnEICSxilHi/cxELhPOLUeLVuiZGkCo2ATWJL18Os4PY
	IkD2zT2zmECKmAVOMUqsXnWACSQhLOAssX92KxuIzSKgKrHlzCJmEJtXwFZi7tdTjBC2oMSP
	yfdYQGxmAS2J9TuPM0HY8hKb17wFqucAOkld4tFfXYhdehLzmnewQpSISOx78Y4RZK+EwAtW
	iSVnp7JDvGAqsarzD9sERqFZSFbMQrJiFpIVs5DMWsDIsopRNLUguaA4KT3XUK84Mbe4NC9d
	Lzk/dxMjODU8k9rBuLLB4hCjAAejEg8vg+evICHWxLLiytxDjBIczEoivPongEK8KYmVValF
	+fFFpTmpxYcYk4EhMJFZSjQ5H5i28kriDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5Ykpqd
	mlqQWgSzhYmDU6qBUYe1X/4IN1fNs6D1zWYC7TNVtu1cl9yk83PXlq/9mXeXlNRl3Vp6KN5B
	Y7rfLVGRLt8av3Uvta7ufHj+bHfJZgeZyjVfduQeUvk5a8mchqIDPIKKEQUf1kyUzjF9ZfOb
	VbzE1HXCno8PVgckHGHYrL2xrTj9I7tjbd9N2RKZpQrXLyaFP7oerMRSnJFoqMVcVJwIAGIq
	duRRAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap_resource() in order to make the code simpler,
and remove redundant return value check of platform_get_resource()
because the value is checked by devm_ioremap_resource().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/ti_am335x_tscadc.c |   23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index d4e8604..e0e081e 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -184,12 +184,6 @@ static	int ti_tscadc_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "no memory resource defined.\n");
-		return -EINVAL;
-	}
-
 	/* Allocate memory for device */
 	tscadc = devm_kzalloc(&pdev->dev,
 			sizeof(struct ti_tscadc_dev), GFP_KERNEL);
@@ -206,19 +200,10 @@ static	int ti_tscadc_probe(struct platform_device *pdev)
 	} else
 		tscadc->irq = err;
 
-	res = devm_request_mem_region(&pdev->dev,
-			res->start, resource_size(res), pdev->name);
-	if (!res) {
-		dev_err(&pdev->dev, "failed to reserve registers.\n");
-		return -EBUSY;
-	}
-
-	tscadc->tscadc_base = devm_ioremap(&pdev->dev,
-			res->start, resource_size(res));
-	if (!tscadc->tscadc_base) {
-		dev_err(&pdev->dev, "failed to map registers.\n");
-		return -ENOMEM;
-	}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	tscadc->tscadc_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(tscadc->tscadc_base))
+		return PTR_ERR(tscadc->tscadc_base);
 
 	tscadc->regmap_tscadc = devm_regmap_init_mmio(&pdev->dev,
 			tscadc->tscadc_base, &tscadc_regmap_config);
-- 
1.7.10.4


