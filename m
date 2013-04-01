Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070Ab3DAJuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:50:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48110 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758420Ab3DAJuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:50:51 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-06-5159587952c5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 27/27] rtc: rtc-v3020: use devm_*() functions
Date: Mon, 01 Apr 2013 18:50:49 +0900
Message-id: <002601ce2ebe$63efb1c0$2bcf1540$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAAS/DA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zA93KiMhAg3OTTS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DK6F0ZVbCMu+LIqhbmBsbpnF2MnBwSAiYSR/98Z4awxSQu3FvP1sXIxSEksIxRYvnl
	O6wwRVceLWOFSCxilDh44CELhPOLUeLf4/9sIFVsAmoSX74cZu9i5OAQEdCXaGvRAKlhFuhl
	lDjTu5sdpEZIwFbix1mIdZwCdhJvFs5jBLGFgeIrHl1lAbFZBFQlZjY/ZgaZwwsU/3IjFyTM
	KyAo8WPyPbASZgEtifU7jzNB2PISm9e8BSuXEFCXePRXFyQsImAkMf/dJahyEYl9L94xgpwj
	IfCIXaJz6X5WiFUCEt8mH2KB6JWV2HQAGhCSEgdX3GCZwCgxC8nmWUg2z0KyeRaSFQsYWVYx
	iqYWJBcUJ6UXGesVJ+YWl+al6yXn525ihMRp/w7GuwesDzEmA62fyCwlmpwPjPO8knhDYzMj
	C1MTU2Mjc0sz0oSVxHnVWqwDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAevF15faqEym65
	lX0ZpSUFi7s7Xs+bxzzlm0mr3fuakkWyigsmLIlju7eD4fRJBcWZlUcdXN+sqX/nv3F1TeiO
	w19fnTqncjib5XxO/iznVXOvVJjnx3P/vKJjsljn/a4vUfOLSjZs+lG6K+fYeXXFU8eern2/
	RP/umdNfIg24Djz+pnbPpfhUjBJLcUaioRZzUXEiAJcIQYvpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jAd3KiMhAg+3thhZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZvSujCpYxl1xZFULcwPjdM4uRk4OCQETiSuP
	lrFC2GISF+6tZ+ti5OIQEljEKHHwwEMWCOcXo8S/x//ZQKrYBNQkvnw5zN7FyMEhIqAv0dai
	AVLDLNDLKHGmdzc7SI2QgK3Ej7PfmUFsTgE7iTcL5zGC2MJA8RWPrrKA2CwCqhIzmx8zg8zh
	BYp/uZELEuYVEJT4MfkeWAmzgJbE+p3HmSBseYnNa96ClUsIqEs8+qsLEhYRMJKY/+4SVLmI
	xL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4CTw
	TGoH48oGi0OMAhyMSjy8ERciAoVYE8uKK3MPMUpwMCuJ8Pp8AwrxpiRWVqUW5ccXleakFh9i
	TAb6cyKzlGhyPjBB5ZXEGxqbmBlZGplZGJmYm5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMH
	p1QDY4dq6mF1odIO4/kPmB6Gv9RecXZyjaKn6N/8vNzPfv6HpzvLCNV+4fxvt4w95ZQJV4bS
	35m/t054dlrskW2Lk8S27LINb47MuGS8qibqWLngUo9jk9b/6V9iU8yyTO6Kj8icNws2zTL+
	Lrv3ekvaNWeN8+3bA3uv6K23rz5ieOjOt60Prv9m+qjEUpyRaKjFXFScCAD8HfKkRgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-v3020.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/rtc-v3020.c b/drivers/rtc/rtc-v3020.c
index 600798c..d87878e 100644
--- a/drivers/rtc/rtc-v3020.c
+++ b/drivers/rtc/rtc-v3020.c
@@ -296,7 +296,7 @@ static int rtc_probe(struct platform_device *pdev)
 	int i;
 	int temp;
 
-	chip = kzalloc(sizeof *chip, GFP_KERNEL);
+	chip = devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
@@ -340,8 +340,8 @@ static int rtc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, chip);
 
-	chip->rtc = rtc_device_register("v3020",
-				&pdev->dev, &v3020_rtc_ops, THIS_MODULE);
+	chip->rtc = devm_rtc_device_register(&pdev->dev, "v3020",
+					&v3020_rtc_ops, THIS_MODULE);
 	if (IS_ERR(chip->rtc)) {
 		retval = PTR_ERR(chip->rtc);
 		goto err_io;
@@ -352,21 +352,14 @@ static int rtc_probe(struct platform_device *pdev)
 err_io:
 	chip->ops->unmap_io(chip);
 err_chip:
-	kfree(chip);
-
 	return retval;
 }
 
 static int rtc_remove(struct platform_device *dev)
 {
 	struct v3020 *chip = platform_get_drvdata(dev);
-	struct rtc_device *rtc = chip->rtc;
-
-	if (rtc)
-		rtc_device_unregister(rtc);
 
 	chip->ops->unmap_io(chip);
-	kfree(chip);
 
 	return 0;
 }
-- 
1.7.2.5


