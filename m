Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbaBGIOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:14:09 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:37904 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaBGIOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:14:06 -0500
X-AuditID: cbfee68e-b7f566d000002344-84-52f495cd26e0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "' Kevin Wells'" <kevin.wells@nxp.com>,
        "'Roland Stigge'" <stigge@antcom.de>
References: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
In-reply-to: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
Subject: [PATCH 04/10] rtc: rtc-lpc32xx: Remove unnecessary OOM messages
Date: Fri, 07 Feb 2014 17:14:04 +0900
Message-id: <001501cf23dc$910b7c20$b3227460$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8j2qAzLOfgRWJTRVWYElXe2alJBAAAd9cQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zQ92zU78EGbTM4rNYcvEqu8Wc9WvY
	LF4e0rS4vPASq8X9vcIWl3fNYbPY39nBaDF5yVlWBw6POVN3M3rsmXiSzePEjN8sHhvf7WDy
	6NuyitFj+ryfTB6fN8kFsEdx2aSk5mSWpRbp2yVwZZy7dIu9YAlbxeu9D9kbGGeydjFycEgI
	mEi8/MjTxcgJZIpJXLi3ng3EFhJYxiixvyceIm4icbX7HAtEfBGjxM05+l2MXED2L0aJww3t
	TCAJNgE1iS9fDrODzBQR0Jdoa9EAqWEWuMkocWjZCiaIZluJX5+XsILYnAJ2EotOnAW7QVjA
	Q6JtSgyIySKgKnF6ugNIBS9Q9YxL/1khbEGJH5PvgZ3ALKAlsX7ncSYIW15i85q3zBCfqEs8
	+qsLEhYRMJKY/LwFqlxEYt+Ld4wg10gINHJIbFq1GCzBIiAg8W3yIRaIXlmJTQeYIb6VlDi4
	4gbLBEaJWUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIySe+3Yw
	3jxgfYgxGWj9RGYp0eR8YDrIK4k3NDYzsjA1MTU2Mrc0I01YSZx30cOkICGB9MSS1OzU1ILU
	ovii0pzU4kOMTBycUg2MiyVfL3vH+7Wp4IrEpJhKxcWsRX8s/RW7D280ehH1fN38+I/v74Vr
	TxQ52CHcq3Q96/+jeQwrH/21ZpbvyKzPuM9ZXlvwXXZu2c9Tkj85nFe3HXVjqJjZteZbQVt0
	7A2vX9PsDxxauvxHJfNcMe7LfwsqPCrMDvX8FOxpOcD/ovTnjJovFxwSlFiKMxINtZiLihMB
	VRGSmP0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jAd2zU78EGXy+w2mx5OJVdos569ew
	Wbw8pGlxeeElVov7e4UtLu+aw2axv7OD0WLykrOsDhwec6buZvTYM/Ekm8eJGb9ZPDa+28Hk
	0bdlFaPH9Hk/mTw+b5ILYI9qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LI
	S8xNtVVy8QnQdcvMATpKSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5hx
	7tIt9oIlbBWv9z5kb2CcydrFyMkhIWAicbX7HAuELSZx4d56NhBbSGARo8TNOfpdjFxA9i9G
	icMN7UwgCTYBNYkvXw6zdzFycIgI6Eu0tWiA1DAL3GSUOLRsBRNEs63Er89LwBZwCthJLDpx
	lhWkXljAQ6JtSgyIySKgKnF6ugNIBS9Q9YxL/1khbEGJH5PvgZ3DLKAlsX7ncSYIW15i85q3
	zCCtEgLqEo/+6oKERQSMJCY/b4EqF5HY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBc
	UJyUnmuoV5yYW1yal66XnJ+7iRGcMJ5J7WBc2WBxiFGAg1GJh/fE0s9BQqyJZcWVuYcYJTiY
	lUR4fzZ8CRLiTUmsrEotyo8vKs1JLT7EmAz050RmKdHkfGAyyyuJNzQ2MTOyNDKzMDIxNydN
	WEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGRmXG/b8vZZ5umN3I4N1Wor7gwJRWd6fXcgoJ
	zYdKXp6LiXMLcgvfNMP78ZNaTivuk32TL/3Xiz6Vc5o7yo7Va8/ZYl3Dt0Jb4/5rXnbZ/9aw
	I/iN5JYda/RzD6hKqZ/K/JoyzbFXM3362Zplrw60f9iReWg7YyjH1G9RMQ+unD/118mz4pXv
	WiWW4oxEQy3mouJEAIL4RQpcAwAA
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
 drivers/rtc/rtc-lpc32xx.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-lpc32xx.c b/drivers/rtc/rtc-lpc32xx.c
index bfdbcb8..f130c08 100644
--- a/drivers/rtc/rtc-lpc32xx.c
+++ b/drivers/rtc/rtc-lpc32xx.c
@@ -211,10 +211,9 @@ static int lpc32xx_rtc_probe(struct platform_device *pdev)
 	}
 
 	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
-	if (unlikely(!rtc)) {
-		dev_err(&pdev->dev, "Can't allocate memory\n");
+	if (unlikely(!rtc))
 		return -ENOMEM;
-	}
+
 	rtc->irq = rtcirq;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-- 
1.7.10.4


