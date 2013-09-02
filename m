Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab3IBBZU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 21:25:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26247 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab3IBBZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 21:25:17 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-e9-5223e8fab7a3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vinod Koul'" <vinod.koul@intel.com>
Cc: "'Dan Williams'" <djbw@fb.com>, linux-kernel@vger.kernel.org,
        "'Zhangfei Gao'" <zhangfei.gao@linaro.org>,
        "'Kai Yang'" <jean.yangkai@huawei.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004c01cea77a$ffd30030$ff790090$%han@samsung.com>
In-reply-to: <004c01cea77a$ffd30030$ff790090$%han@samsung.com>
Subject: PATCH 2/2] dma: k3dma: use devm_ioremap_resource() instead of
 devm_request_and_ioremap()
Date: Mon, 02 Sep 2013 10:25:13 +0900
Message-id: <004d01cea77b$46152550$d23f6ff0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6nev+73G/gftskTrSsjC4jQpqUyAAAAbaA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zY91fL5SDDDpecVps7n/AZrH46SwW
	i8sLL7FaXN41h83iZd9+Foubay6wO7B5TGx+x+7RcuQtq8fiPS+ZPO5c28Pm0bdlFaPH501y
	AWxRXDYpqTmZZalF+nYJXBkPf6xjLJjDVnHwQwt7A+N01i5GTg4JAROJ1qbpTBC2mMSFe+vZ
	uhi5OIQEljFKvOlezw5TtL5rDztEYhGjxMLv31kgnF+MEjsezmMGqWITUJP48uUwUBUHh4iA
	usTS6zIgNcwC2xglnm7bAbZCSMBWYtaVThYQm1PATmL/9JtgvcICyRKvZrazgdgsAqoS7//f
	ZASxeYHq90yawAZhC0r8mHwPrJdZQEti/c7jTBC2vMTmNW+ZQfZKAO199FcXJCwiYCRxr3cO
	G0SJiMS+F+8YQe6REPjILvHl8Q12iF0CEt8mH2KB6JWV2HSAGeJhSYmDK26wTGCUmIVk8ywk
	m2ch2TwLyYoFjCyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MULid+IOxvsHrA8xJgOtn8gs
	JZqcD4z/vJJ4Q2MzIwtTE1NjI3NLM9KElcR51VusA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFw
	SjUwphzSveRie9vg/HG2Lyv+9cpsnTo33H7JH6UyXhHHadkuBad1FLZaO8ydu+L0uo1nZ8Wv
	eu48zeTh3I+hF2RFT7N/8y57c7xpRag+f/LpyxrZb8O11bvc9q2O23ott8Hh3JZPl6rWW7K+
	ypdOXOeYYblBJTnOacvcFYfzWZbKpYlG7GnkvP9gnhJLcUaioRZzUXEiACyKbYD1AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jAd1fL5SDDKa2sFls7n/AZrH46SwW
	i8sLL7FaXN41h83iZd9+Foubay6wO7B5TGx+x+7RcuQtq8fiPS+ZPO5c28Pm0bdlFaPH501y
	AWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3
	KCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzHv5Yx1gwh63i4IcW9gbG
	6axdjJwcEgImEuu79rBD2GISF+6tZ+ti5OIQEljEKLHw+3cWCOcXo8SOh/OYQarYBNQkvnw5
	DNTBwSEioC6x9LoMSA2zwDZGiafbdjCB1AgJ2ErMutLJAmJzCthJ7J9+E6xXWCBZ4tXMdjYQ
	m0VAVeL9/5uMIDYvUP2eSRPYIGxBiR+T74H1MgtoSazfeZwJwpaX2LzmLTPIXgmgvY/+6oKE
	RQSMJO71zmGDKBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtc
	mpeul5yfu4kRnByeSe1gXNlgcYhRgINRiYe3YoVykBBrYllxZe4hRgkOZiUR3qrnQCHelMTK
	qtSi/Pii0pzU4kOMyUCPTmSWEk3OByauvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeW
	pGanphakFsFsYeLglGpglJ+VpX7GkytjemrY2slqp6ceOeSkHRD8MFi8feLevHjNyUfe/5p8
	ZOuELQsnOlm6db/64TRV7oT13V8rlsuYSmQYRs6Ya8Lv7fLB/8J5uY6dLz8+VHItnZHn67dR
	afI5f++cAz1zVnzMW56dxWLDLcJ86sNkMbFJe3q5W1oOtGyQDnmRLvTNW4mlOCPRUIu5qDgR
	ADUrEWxSAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap_resource() because devm_request_and_ioremap() is
obsoleted by devm_ioremap_resource().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/dma/k3dma.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/k3dma.c b/drivers/dma/k3dma.c
index ef7bc85..a2c330f 100644
--- a/drivers/dma/k3dma.c
+++ b/drivers/dma/k3dma.c
@@ -673,9 +673,9 @@ static int k3_dma_probe(struct platform_device *op)
 	if (!d)
 		return -ENOMEM;
 
-	d->base = devm_request_and_ioremap(&op->dev, iores);
-	if (!d->base)
-		return -EADDRNOTAVAIL;
+	d->base = devm_ioremap_resource(&op->dev, iores);
+	if (IS_ERR(d->base))
+		return PTR_ERR(d->base);
 
 	of_id = of_match_device(k3_pdma_dt_ids, &op->dev);
 	if (of_id) {
-- 
1.7.10.4


