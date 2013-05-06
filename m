Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab3EFEhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 00:37:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:47098 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab3EFEhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 00:37:23 -0400
X-AuditID: cbfee68f-b7f066d000003683-2c-518733794bf3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Herbert Xu'" <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org, "'Matt Mackall'" <mpm@selenic.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 1/4] hwrng: atmel - remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 13:37:13 +0900
Message-id: <004601ce4a13$60fa6620$22ef3260$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KE0wUUmE8xx7vT3icNOlUsrysBQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zQ91K4/ZAg9+7ZSy6X8lYXF54idXi
	8q45bBYLtvUxOrB4bDug6tG3ZRWjR9/LDYwenzfJBbBEcdmkpOZklqUW6dslcGVc3+JUcImt
	4sft10wNjCdZuxg5OSQETCS+Tb7FDmGLSVy4t54NxBYSWMYoMb+zEqZm1d1TQPVcQPHpjBK/
	n01ihyj6xSixpT8SxGYTUJP48uUwWFxEQE+ib30jI4jNLJAmsX3jf7ChwgK+EncevAerYRFQ
	lXh/6jHYEbwClhITN/xngbAFJX5MvscC0aslsX7ncSYIW15i85q3zBAHKUjsOPuaEWbXzK/z
	2SBqRCT2vXjHCHKohMAqdokFr69ALRMA+vIQ0FAOoISsxKYDUHMkJQ6uuMEygVFsFpLVs5Cs
	noVk9SwkKxYwsqxiFE0tSC4oTkovMtYrTswtLs1L10vOz93ECImv/h2Mdw9YH2JMBlo/kVlK
	NDkfGJ95JfGGxmZGFqYmpsZG5pZmpAkrifOqtVgHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCU
	amBs2Vkm92aLc72Ici+7g993rThOpt16G5UN+p9Jd/ZvXWstq82ZuULYxWtB6ISj+xXWHQwX
	OKw/udfhyfIp55vbozy9p8jvO2Te90xU9Z3sChUnnUO/rdvKNzec+yIfudPuxJfZPOVmT12P
	/RI891br9fOFZT/sn4t3R232f5Jp259Xc850j5ASS3FGoqEWc1FxIgBm/ofgxQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jQd1K4/ZAg7ZuSYvuVzIWlxdeYrW4
	vGsOm8WCbX2MDiwe2w6oevRtWcXo0fdyA6PH501yASxRDYw2GamJKalFCql5yfkpmXnptkre
	wfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUAblRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0
	Ruj6hgTB9RgZoIGEdYwZ17c4FVxiq/hx+zVTA+NJ1i5GTg4JAROJVXdPQdliEhfurWfrYuTi
	EBKYzijx+9kkdpCEkMAvRokt/ZEgNpuAmsSXL4fB4iICehJ96xsZQWxmgTSJ7Rv/s4HYwgK+
	EncevAerYRFQlXh/6jHYAl4BS4mJG/6zQNiCEj8m32OB6NWSWL/zOBOELS+xec1bZoiDFCR2
	nH3NCLNr5tf5bBA1IhL7XrxjnMAoMAvJqFlIRs1CMmoWkpYFjCyrGEVTC5ILipPSc430ihNz
	i0vz0vWS83M3MYLj95n0DsZVDRaHGAU4GJV4eAuetAUKsSaWFVfmHmKU4GBWEuH12QsU4k1J
	rKxKLcqPLyrNSS0+xJgM9OlEZinR5HxgaskriTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6
	YklqdmpqQWoRzBYmDk6pBkaDID193ybzuI/CR2p6+99o6PZd1zm77dCGWzFzfmtd1PJ/0R4z
	50reA4/JzbnrvjAbVZcxPXNVyHC+p/paYaVT47oTm9Z6b0jq1AtRLPPJ0mlOmLNx7vH191bk
	Xlw45elDg6vPw+5aHbQ5+SLm6SnRNxcY3coqLA1ezC3xq7PeHXRgpcH6/nolluKMREMt5qLi
	RABgqlWEIwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/char/hw_random/atmel-rng.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index 7c73d4a..bf9fc6b 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -108,8 +108,6 @@ static int atmel_trng_remove(struct platform_device *pdev)
 	clk_disable(trng->clk);
 	clk_put(trng->clk);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.5


