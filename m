Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbaD2I0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:26:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20621 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaD2I0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:26:04 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-a8-535f62182d8f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Daniel Lezcano'" <daniel.lezcano@linaro.org>
Cc: "'Thomas Gleixner'" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Shinya Kuribayashi'" <shinya.kuribayashi.px@renesas.com>,
        "'Magnus Damm'" <damm@opensource.se>
References: <002c01cf6384$781c57b0$68550710$%han@samsung.com>
In-reply-to: <002c01cf6384$781c57b0$68550710$%han@samsung.com>
Subject: [PATCH 1/4] clocksource: em_sti: remove unnecessary OOM messages
Date: Tue, 29 Apr 2014 17:26:00 +0900
Message-id: <002d01cf6384$a6dbcf90$f4936eb0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9jhHgACh38PpSJS1ewNnY0fIuPzwAAAfgQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t8zQ12JpPhgg6ZXShb3H99ispj3Wdbi
	8sJLrBaXd81hs3hz1NNi86apzA5sHneu7WHzeHfuHLvHyh+X2D2+nZnI4tG3ZRWjx+dNcgFs
	UVw2Kak5mWWpRfp2CVwZs9duYyyYyFYxd+IV1gbGFtYuRk4OCQETiROLPkLZYhIX7q1n62Lk
	4hASWMYosX55EztM0Y47u9ghEosYJZonNTJDOL+BnPYjTCBVbAJqEl++HAbrEBEwkHh9+jeY
	zSxwgVHiYFcUiC0kYCsx4cRNNhCbU8BOYs6RfWC2sICnxN9zh8DOYBFQlTg0/SYziM0LVN/+
	5y0rhC0o8WPyPRaImVoS63ceZ4Kw5SU2r3kLVM8BdKm6xKO/uhAnGEm03n8FVS4ise/FO0aI
	Zx6xS1y7mg6xSkDi2+RDLBCtshKbDjBDlEhKHFxxg2UCo8QsJItnIVk8C8niWUg2LGBkWcUo
	mlqQXFCclF5kolecmFtcmpeul5yfu4kRErkTdjDeO2B9iDEZaP1EZinR5Hxg5OeVxBsamxlZ
	mJqYGhuZW5qRJqwkzqv2KClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2PbnvZjC+RLf/P0
	nbGqNmu4YGHIbd3s2WYVIX7aRNq2y77nYa5hgdML3oKdNicnVd4Ja55/qWnh73P9ye/mSovx
	zHxjp1x7qT6/NUyjJmCd/oPqKotH3RqJPyIt77m2uh98N92kzWprQnhiQHX78ucFGUfPPVzg
	vvevk9n7iQuXpr5Tur5irxJLcUaioRZzUXEiAKDFi7jyAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jAV2JpPhgg29PZS3uP77FZDHvs6zF
	5YWXWC0u75rDZvHmqKfF5k1TmR3YPO5c28Pm8e7cOXaPlT8usXt8OzORxaNvyypGj8+b5ALY
	ohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOArlBS
	KEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZsxeu42xYCJbxdyJV1gbGFtY
	uxg5OSQETCR23NnFDmGLSVy4t56ti5GLQ0hgEaNE86RGZgjnN5DTfoQJpIpNQE3iy5fDYB0i
	AgYSr0//BrOZBS4wShzsigKxhQRsJSacuMkGYnMK2EnMObIPzBYW8JT4e+4Q2GYWAVWJQ9Nv
	MoPYvED17X/eskLYghI/Jt9jgZipJbF+53EmCFteYvOat0D1HECXqks8+qsLcYKRROv9V1Dl
	IhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYIT
	wzPpHYyrGiwOMQpwMCrx8HbExAULsSaWFVfmHmKU4GBWEuHNt4oPFuJNSaysSi3Kjy8qzUkt
	PsSYDPToRGYp0eR8YNLKK4k3NDYxM7I0MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwW
	Jg5OqQbGLRwmjpMmc7t3T4u/dtq0n+k2Z/1UWcMyoazQXZIfLzvXtGxzm7T2zIYE51a35PN7
	YvjEDjxOXnfhiF6Jte2Mou93VyjM9P1kJvWTm+/3h+x02XVd20Pf7X2rbZQ0vdHY+Lanq9+1
	SxVbt3AtWdjziy3onIL1JdHPT3t54qb+bTj/2FI/Zdl0JZbijERDLeai4kQAPbdF4FADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The site-specific OOM messages are unnecessary, because they
duplicate the MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/clocksource/em_sti.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/clocksource/em_sti.c b/drivers/clocksource/em_sti.c
index 9d17083..d0a7bd6 100644
--- a/drivers/clocksource/em_sti.c
+++ b/drivers/clocksource/em_sti.c
@@ -318,10 +318,8 @@ static int em_sti_probe(struct platform_device *pdev)
 	int irq;
 
 	p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
-	if (p == NULL) {
-		dev_err(&pdev->dev, "failed to allocate driver data\n");
+	if (p == NULL)
 		return -ENOMEM;
-	}
 
 	p->pdev = pdev;
 	platform_set_drvdata(pdev, p);
-- 
1.7.10.4


