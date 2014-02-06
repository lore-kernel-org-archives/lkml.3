Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbaBFITq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 03:19:46 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:45960 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbaBFITo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 03:19:44 -0500
X-AuditID: cbfee68f-b7f156d00000276c-00-52f3459edb11
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Eric Miao'" <eric.y.miao@gmail.com>
References: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
In-reply-to: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
Subject: [PATCH 04/12] backlight: corgi_lcd: Remove unnecessary OOM messages
Date: Thu, 06 Feb 2014 17:19:42 +0900
Message-id: <000501cf2314$2fa64e60$8ef2eb20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8jE27bRmoXkttyRH6rTI4zkLyyhgAAIRXg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t8zA915rp+DDKZ/NreYs34Nm8WOtuNs
	FpcXXmK1uLxrDpsDi8fOWXfZPU7M+M3i0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBmTV11n
	K+hjq7jfNpO1gbGDtYuRk0NCwERibmcDE4QtJnHh3no2EFtIYBmjxLWF3F2MHGA1S2a6dDFy
	AYUXMUrcXnaOHcL5xSix8PYysEFsAmoSX74cZgdpEBHQl2hr0QAxmQWyJU7vdoEYaSux+/RJ
	sGpOATuJbZ9amUBKhAV8JP6fSgQJswioSrx794YVJMwLVP5xcSZImFdAUOLH5HssIDazgJbE
	+p3HmSBseYnNa94yQxypLvHory5IWETASOLDx2VQ5SIS+168YwS5V0LgHLvEiSddbBCrBCS+
	TT7EAtErK7HpADMkDCQlDq64wTKBUWIWks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y1itO
	zC0uzUvXS87P3cQIicX+HYx3D1gfYkwGWj+RWUo0OR8Yy3kl8YbGZkYWpiamxkbmlmakCSuJ
	895/mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgbHn3pdev3erjmo2Siun/RbyuJmw712b
	+oVVVc27Z154KeT3Z96luRMW3wv/es7MnWPevIk/FI7Lcf/LD573XcnF/YhXyi7vhxrd/vHn
	Ds1XYq1hiFu3asudn43bpjV+WPR/a1lYTKZX9g/7Kxo3Om4/38j+Xi7x7PUp8m+veXw93ev7
	9eP/xl1pSizFGYmGWsxFxYkAOTuY79sCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAd15rp+DDF6tNLGYs34Nm8WOtuNs
	FpcXXmK1uLxrDpsDi8fOWXfZPU7M+M3i0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZk1ddZyvoY6u43zaTtYGxg7WLkYNDQsBEYslMly5GTiBTTOLC
	vfVsXYxcHEICixglbi87xw7h/GKUWHh7GStIFZuAmsSXL4fZQZpFBPQl2lo0QExmgWyJ07vB
	5ggJ2ErsPn0SrJpTwE5i26dWJpASYQEfif+nEkHCLAKqEu/evQG7gBeo/OPiTJAwr4CgxI/J
	91hAbGYBLYn1O48zQdjyEpvXvGWGOFhd4tFfXZCwiICRxIePy6DKRST2vXjHOIFRaBaSSbOQ
	TJqFZNIsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgTH+jOpHYwrGywOMQpwMCrx
	8G5Y/ylIiDWxrLgy9xCjBAezkgjvVvPPQUK8KYmVValF+fFFpTmpxYcYk4H+nMgsJZqcD0xD
	eSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAmBVsXHalhyX3
	5Y9pdps7OZfUtgguKPR8J726zlzk/KFvX9ecl+g1nsVYc2V75iXrP2qxPDtK3Es7nTvWfY8+
	yi9iLxDLta/q+u/f19d5V5x45a29fM5rt66Jx0/n3fg+84WJhXGCy2a7azNmf9yUF+TRI3Xr
	gsbZ/YF/v/A/YjC/d1b4tf4FGSWW4oxEQy3mouJEAHgzI+85AwAA
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
 drivers/video/backlight/corgi_lcd.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index db8db5f..51d18d6 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -543,10 +543,8 @@ static int corgi_lcd_probe(struct spi_device *spi)
 	}
 
 	lcd = devm_kzalloc(&spi->dev, sizeof(struct corgi_lcd), GFP_KERNEL);
-	if (!lcd) {
-		dev_err(&spi->dev, "failed to allocate memory\n");
+	if (!lcd)
 		return -ENOMEM;
-	}
 
 	lcd->spi_dev = spi;
 
-- 
1.7.10.4


