Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3EFEWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 00:22:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49344 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab3EFEWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 00:22:43 -0400
X-AuditID: cbfee690-b7f136d000000fea-3a-518730112afd
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 6/8] jz4740-battery: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 13:22:41 +0900
Message-id: <003b01ce4a11$59740c00$0c5c2400$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KEUs8suF00BNzTYeuer72MANH4w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t8zQ11Bg/ZAg8/dZhYHt2paTFw5mdni
	8sJLrBZLJs9ntbi8aw6bA6vHhP5PjB6bV2h5LHlziNWjb8sqRo/Pm+QCWKO4bFJSczLLUov0
	7RK4MjYvOc1UcICj4vqrqgbGZvYuRk4OCQETid5tzcwQtpjEhXvr2boYuTiEBJYxSiy60M3S
	xcgBVnRtfwVIjZDAdEaJT2vsIGp+MUpMPvuXBSTBJqAm8eXLYbChIgIaEm2rp7CAFDELTGaU
	2N+wjQ0kISzgJ3F301OwIhYBVYm/XzYxgti8ApYSH/Z9YYOwBSV+TL4HNpRZQEti/c7jTBC2
	vMTmNW+hLlWQ2HH2NSPEMj2Jxpl3WSFqRCT2vXjHCLJYQuAQu8TzPevZIJYJSHybfAjqG1mJ
	TQeg5khKHFxxg2UCo9gsJKtnIVk9C8nqWUhWLGBkWcUomlqQXFCclF5kolecmFtcmpeul5yf
	u4kREnUTdjDeO2B9iDEZaP1EZinR5Hxg1OaVxBsamxlZmJqYGhuZW5qRJqwkzqveYh0oJJCe
	WJKanZpakFoUX1Sak1p8iJGJg1OqgVFtk/1uy82WFub2R02nb/rkWDMpKUBP9WnZUbcFbOse
	t8zdu3yFtOVuU3aF0v0rS74dFissC7q++RFf0fOMpttXjt+fv0Clzp/BfMdOizU8M3nmZR/Z
	ztHHp1VX7m6RasNd4mHzVlC9zbTvX8r8v4VWkR93mEe9PJH1SzX5/RdrAZVW/0PTFZVYijMS
	DbWYi4oTAWcaOZ3QAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jQV1Bg/ZAgymzdC0ObtW0mLhyMrPF
	5YWXWC2WTJ7PanF51xw2B1aPCf2fGD02r9DyWPLmEKtH35ZVjB6fN8kFsEY1MNpkpCampBYp
	pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAO1WUihLzCkFCgUkFhcr
	6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWZsXnKaqeAAR8X1V1UNjM3sXYwcHBICJhLX9ld0
	MXICmWISF+6tZwOxhQSmM0p8WmPXxcgFZP9ilJh89i8LSIJNQE3iy5fD7CC2iICGRNvqKSwg
	RcwCkxkl9jdsA+sWFvCTuLvpKVgRi4CqxN8vmxhBbF4BS4kP+76wQdiCEj8m3wMbyiygJbF+
	53EmCFteYvOat8wQFylI7Dj7mhFimZ5E48y7rBA1IhL7XrxjnMAoMAvJqFlIRs1CMmoWkpYF
	jCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJj+pn0DsZVDRaHGAU4GJV4eAuetAUKsSaW
	FVfmHmKU4GBWEuH12QsU4k1JrKxKLcqPLyrNSS0+xJgM9OlEZinR5HxguskriTc0NjEzsjQy
	szAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBsbMVzpL3r76ZlgxfZn13sNVDrw/
	gieHdXkfuP720BTdGVPz8+8fLzLnv3is2P+oS3TUuuOHzeomWzl+rYm1eNDgEF7y8+jy0vi3
	y2qmnr8s8GN/gNmVr1Mk5ap37GtIC//fNt3+9a4NrGd1v7WeEjhwf9sRp+lC2y5bKTzlmb/f
	q1ZRLkKqKyRciaU4I9FQi7moOBEACcXyUi0DAAA=
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
 drivers/power/jz4740-battery.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
index c675553..d9686aa 100644
--- a/drivers/power/jz4740-battery.c
+++ b/drivers/power/jz4740-battery.c
@@ -292,7 +292,7 @@ static int jz_battery_probe(struct platform_device *pdev)
 			jz_battery);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request irq %d\n", ret);
-		goto err;
+		return ret;
 	}
 	disable_irq(jz_battery->irq);
 
@@ -349,8 +349,6 @@ err_free_gpio:
 		gpio_free(jz_battery->pdata->gpio_charge);
 err_free_irq:
 	free_irq(jz_battery->irq, jz_battery);
-err:
-	platform_set_drvdata(pdev, NULL);
 	return ret;
 }
 
-- 
1.7.2.5


