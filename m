Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaBLFTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 00:19:51 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:21660 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaBLFTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 00:19:50 -0500
X-AuditID: cbfee690-b7f266d00000287c-6d-52fb0474a95b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Herbert Xu'" <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, "'Jamie Iles'" <jamie@jamieiles.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000001cf27b1$acf29f30$06d7dd90$%han@samsung.com>
In-reply-to: <000001cf27b1$acf29f30$06d7dd90$%han@samsung.com>
Subject: [PATCH 2/2] hwrng: pixocell - Use devm_ioremap_resource()
Date: Wed, 12 Feb 2014 14:19:48 +0900
Message-id: <000101cf27b2$0caf9810$260ec830$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8nsadSW6n/hyJ4ROCDFcv21NZRfwAAB0Ug
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zY90Slt9BBhO2W1l0v5KxmLF5PpPF
	5YWXWC0u75rD5sDise2Aqsee7v/sHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJVx+cF6toJG
	7oq2t8cZGxjnc3YxcnJICJhIrN56hhHCFpO4cG89WxcjF4eQwDJGid5X79hhis7Me84MkZjO
	KPGq4xAjhPMLqOrIRCaQKjYBNYkvXw6DdYgI6En0rW8EG8sskCVxcekJMFtIwFbiQd9HFhCb
	U8BO4m//Z2YQW1jASWL/1TdgvSwCqhIH7k0Equfg4AWqf9phAxLmFRCU+DH5HgvESC2J9TuP
	M0HY8hKb17xlBimXEFCXePRXF+ICI4mdi9czQ5SISOx78Q7sZAmBU+wSB6e2MUGsEpD4NvkQ
	C0SvrMSmA8wQ/0pKHFxxg2UCo8QsJJtnIdk8C8nmWUhWLGBkWcUomlqQXFCclF5kolecmFtc
	mpeul5yfu4kREpETdjDeO2B9iDEZaP1EZinR5HxgROeVxBsamxlZmJqYGhuZW5qRJqwkzqv2
	KClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+Oce0sTwz8sVHMQ/7nz0K9Nkf8Xxlk3K4lI
	Sj/cmlXJlsamGz9Z4kDZudYWzu8lx5RXODOUCOjEpvqe3HbwWZnthnmpift27ngh5LfpvfQ1
	36YVzQt4l4kvuHj78rETEWr+dpUTVn7gPKVXtyUkM+DY7Wk9v9MOTzDPOLF0Q5OyaMjb87NE
	pl1QYinOSDTUYi4qTgQAvXsQy94CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQd0Slt9BBsePm1l0v5KxmLF5PpPF
	5YWXWC0u75rD5sDise2Aqsee7v/sHn1bVjF6fN4kF8AS1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvh2lCaIibrgVM
	Y4Sub0gQXI+RARpIWMeYcfnBeraCRu6KtrfHGRsY53N2MXJySAiYSJyZ95wZwhaTuHBvPVsX
	IxeHkMB0RolXHYcYIZxfjBK9RyYygVSxCahJfPlymB3EFhHQk+hb38gIYjMLZElcXHoCzBYS
	sJV40PeRBcTmFLCT+Nv/GWyDsICTxP6rb8B6WQRUJQ7cmwhUz8HBC1T/tMMGJMwrICjxY/I9
	FoiRWhLrdx5ngrDlJTavecsMUi4hoC7x6K8uxAVGEjsXr2eGKBGR2PfiHeMERqFZSCbNQjJp
	FpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHO/PpHYwrmywOMQowMGoxMPL
	4PkrSIg1say4MvcQowQHs5IIr/4JoBBvSmJlVWpRfnxRaU5q8SHGZKA/JzJLiSbnA1NRXkm8
	obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwnrnglP/jgh7vrHuO
	HkemXbWrq/RYJ7DYRSry1NFlDtEzbh5d8O1L9dnlgdVSInzZ4dvq35yeZxy54/2ctQ3RO19+
	dT99+JfnNEtv9k/Vp/KPXHD4e0R9Y8Euz44zDdV1J2927nJfeDArPDr4efyrKin7aVUzF4dl
	iXTae6m8XhbcfPJw2ivdh0osxRmJhlrMRcWJACdmezE7AwAA
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
 drivers/char/hw_random/picoxcell-rng.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/char/hw_random/picoxcell-rng.c b/drivers/char/hw_random/picoxcell-rng.c
index 3d4c229..c03beee 100644
--- a/drivers/char/hw_random/picoxcell-rng.c
+++ b/drivers/char/hw_random/picoxcell-rng.c
@@ -104,22 +104,9 @@ static int picoxcell_trng_probe(struct platform_device *pdev)
 	int ret;
 	struct resource *mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	if (!mem) {
-		dev_warn(&pdev->dev, "no memory resource\n");
-		return -ENOMEM;
-	}
-
-	if (!devm_request_mem_region(&pdev->dev, mem->start, resource_size(mem),
-				     "picoxcell_trng")) {
-		dev_warn(&pdev->dev, "unable to request io mem\n");
-		return -EBUSY;
-	}
-
-	rng_base = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
-	if (!rng_base) {
-		dev_warn(&pdev->dev, "unable to remap io mem\n");
-		return -ENOMEM;
-	}
+	rng_base = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(rng_base))
+		return PTR_ERR(rng_base);
 
 	rng_clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(rng_clk)) {
-- 
1.7.10.4


