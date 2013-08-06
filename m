Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab3HFJOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 05:14:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25866 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab3HFJON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 05:14:13 -0400
X-AuditID: cbfee691-b7fef6d000002d62-32-5200be65ef5f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Barry Song <baohua.song@csr.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 3/3] pinctrl: sirf: add missing __iomem annotation
Date: Tue, 06 Aug 2013 18:14:12 +0900
Message-id: <000301ce9285$510a2c90$f31e85b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6ShTPJlpGZ7VWgRm6CTcuDhH1cVg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t8zI93UfQxBBhsvM1m8nHmV1eLywkus
	FlP+LGeyuLxrDpsDi8eunXNYPe5c28Pm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBn9DSfZ
	Cw5xV8xcc42tgfEbZxcjJ4eEgInE1q6HLBC2mMSFe+vZuhi5OIQEljFKbJ59hxmmqO/KGajE
	IkaJa1u+gXUICfxilPh5Tx3EZhNQk/jy5TA7iC0ioCfx5msLmM0skCbxt3URI4gtLOAk8brz
	JFicRUBVYvHur2ALeAUsJQ7f7meEsAUlfky+xwLRqyWxfudxJghbXmLzmrdQBylI7Dj7mhFm
	17P/TawQNSIS+168YwQ5VEJgHbvE741zWSGWCUh8m3wIaCgHUEJWYtMBqDmSEgdX3GCZwCg2
	C8nqWUhWz0KyehaSFQsYWVYxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525ihMTZxB2M9w9YH2JM
	Blo/kVlKNDkfGKd5JfGGxmZGFqYmpsZG5pZmpAkrifOqt1gHCgmkJ5akZqemFqQWxReV5qQW
	H2Jk4uCUamCcs+eFp5dhiXH/yvSgo+8Uq5MlE8/OsF4kHb6jdlIVw6mVuv4+FZqnrr9JPHPi
	+vIkw9Pqs3QeL5aXTzs8TWzKRtUtoV9f/y6+KKNsxKt68HvD3bYVHOcCn8U9nvpy4Z0J3jvz
	4vqXXN2br6Fz1U1tmrNg2MQoI/+ERev9cvQm19frbORwSk1XYinOSDTUYi4qTgQAUwJ/0ckC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t9jAd2UfQxBBqd+WFu8nHmV1eLywkus
	FlP+LGeyuLxrDpsDi8eunXNYPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZ/Q0n2QsOcVfMXHONrYHxG2cXIyeHhICJRN+VM2wQtpjEhXvr
	gWwuDiGBRYwS17Z8YwFJCAn8YpT4eU8dxGYTUJP48uUwO4gtIqAn8eZrC5jNLJAm8bd1ESOI
	LSzgJPG68yRYnEVAVWLx7q/MIDavgKXE4dv9jBC2oMSPyfdYIHq1JNbvPM4EYctLbF7zlhni
	IAWJHWdfM8Lseva/iRWiRkRi34t3jBMYBWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6h
	XnFibnFpXrpecn7uJkZwFD+T2sG4ssHiEKMAB6MSD2/i1f+BQqyJZcWVuYcYJTiYlUR4VXYy
	BAnxpiRWVqUW5ccXleakFh9iTAb6dCKzlGhyPjDB5JXEGxqbmBlZGplZGJmYm5MmrCTOe6DV
	OlBIID2xJDU7NbUgtQhmCxMHp1QD49rtZvovP23o2JjLE6vwcFXmqskZgh/Vsw/NY9kSqhQR
	8uH2y9VvDfVEPAX4bqrcmrtH1Y3zyZMm9TNWDyxj4pwDjlyL//haPspBxlIzdUeT+FUOP6F7
	B3NdP/7lD36/ZXXS34sPuldGH5RU/disHbH6x6nbSq5XKw4fFD5oEsX0d7mG2b3n15RYijMS
	DbWYi4oTAQBe7mEmAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added missing __iomem annotation in order to fix the following
sparse warnings:

drivers/pinctrl/sirf/pinctrl-sirf.c:846:14: warning: incorrect type in assignment (different address spaces)
drivers/pinctrl/sirf/pinctrl-sirf.c:846:14:    expected void *regs
drivers/pinctrl/sirf/pinctrl-sirf.c:846:14:    got void [noderef] <asn:2>*
drivers/pinctrl/sirf/pinctrl-sirf.c:869:33: warning: incorrect type in assignment (different address spaces)
drivers/pinctrl/sirf/pinctrl-sirf.c:869:33:    expected void [noderef] <asn:2>*regs
drivers/pinctrl/sirf/pinctrl-sirf.c:869:33:    got void *regs
drivers/pinctrl/sirf/pinctrl-sirf.c:909:17: warning: incorrect type in argument 1 (different address spaces)
drivers/pinctrl/sirf/pinctrl-sirf.c:909:17:    expected void volatile [noderef] <asn:2>*addr
drivers/pinctrl/sirf/pinctrl-sirf.c:909:17:    got void *regs

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pinctrl/sirf/pinctrl-sirf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sirf/pinctrl-sirf.c b/drivers/pinctrl/sirf/pinctrl-sirf.c
index 0792e8d..26f946a 100644
--- a/drivers/pinctrl/sirf/pinctrl-sirf.c
+++ b/drivers/pinctrl/sirf/pinctrl-sirf.c
@@ -833,7 +833,7 @@ static int sirfsoc_gpio_probe(struct device_node *np)
 {
 	int i, err = 0;
 	struct sirfsoc_gpio_bank *bank;
-	void *regs;
+	void __iomem *regs;
 	struct platform_device *pdev;
 	bool is_marco = false;
 
-- 
1.7.10.4


