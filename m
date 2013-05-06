Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3EFEXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 00:23:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32520 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab3EFEXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 00:23:47 -0400
X-AuditID: cbfee68d-b7f016d000007930-18-518730517c1f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 7/8] rx51_battery: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 13:23:45 +0900
Message-id: <003c01ce4a11$7f83b300$7e8b1900$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KEWZIzMEj5CCKSt2tBvaJOHE13w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zI91Ag/ZAg6+HzS0ObtW0mLhyMrPF
	5YWXWC0u75rD5sDiMaH/E6PH5hVaHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJXR8/wQe0Ev
	Z8X5lX8YGxiPsXcxcnBICJhIzD9v0sXICWSKSVy4t56ti5GLQ0hgGaPEu8V72SESJhJ3ln6B
	SkxnlFjecZQZJCEk8ItR4uIZUxCbTUBN4suXw2ANIgIaEm2rp7CA2MwCuRL7Hk5jA7GFBXwk
	Fs/9wwKymEVAVeLVfF+QMK+ApcSsiRvYIWxBiR+T70G1akms33mcCcKWl9i85i0zxD0KEjvO
	vmaEWKUn0XhnNRtEjYjEvhfvGEHulBBYxy7R/WkeK0iCRUBA4tvkQywQD8tKbDoANUdS4uCK
	GywTGMVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MkPjq3cF4
	+4D1IcZkoPUTmaVEk/OB8ZlXEm9obGZkYWpiamxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpR
	fFFpTmrxIUYmDk6pBsb6eI5dziqbRaZld24VVL0pk3Uj88rR62/d+m9+vaD3iXnDPNZApg7p
	HQfiFfIuy27d+/RY1PlytXTt0PhlLzuCF6cG3whovP7hefmVfHdOYSsBCelWZfufG+8xFzvP
	yQk4cHrrBpaqHxEtQqtWsu65yiL+aQaLpal5eOnsbQFO+TNiVV4ZMCixFGckGmoxFxUnAgDY
	Qq4yxQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jQd1Ag/ZAgxs3jSwObtW0mLhyMrPF
	5YWXWC0u75rD5sDiMaH/E6PH5hVaHn1bVjF6fN4kF8AS1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvh2lCaIibrgVM
	Y4Sub0gQXI+RARpIWMeY0fP8EHtBL2fF+ZV/GBsYj7F3MXJySAiYSNxZ+oUNwhaTuHBvPZDN
	xSEkMJ1RYnnHUWaQhJDAL0aJi2dMQWw2ATWJL18OgzWLCGhItK2ewgJiMwvkSux7OA1skLCA
	j8TiuX+A4hwcLAKqEq/m+4KEeQUsJWZN3MAOYQtK/Jh8D6pVS2L9zuNMELa8xOY1b5kh7lGQ
	2HH2NSPEKj2Jxjur2SBqRCT2vXjHOIFRYBaSUbOQjJqFZNQsJC0LGFlWMYqmFiQXFCel5xrp
	FSfmFpfmpesl5+duYgTH7zPpHYyrGiwOMQpwMCrx8BY8aQsUYk0sK67MPcQowcGsJMLrsxco
	xJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnA1JJXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutA
	IYH0xJLU7NTUgtQimC1MHJxSDYxep77sZKr1XXPpSvqKzt9v9ycoHl3yLPzKn8mGt+Z8/5Vw
	b7LtFMa80PfFPHyeZ4Kua5TKXDa4L7ak+WLE6QuNZh9U38c8KTlX8uJ4Y42ePfd23y/L+r8E
	cvzXmb5F6P6diF2T/Z5fijNuu9y4RMjkuqEP170HB/amaenV8vreEH73ItYqWrNEiaU4I9FQ
	i7moOBEAcGLc1yMDAAA=
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
 drivers/power/rx51_battery.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/power/rx51_battery.c b/drivers/power/rx51_battery.c
index cbde1d6..8a6288d 100644
--- a/drivers/power/rx51_battery.c
+++ b/drivers/power/rx51_battery.c
@@ -216,10 +216,8 @@ static int rx51_battery_probe(struct platform_device *pdev)
 	di->bat.get_property = rx51_battery_get_property;
 
 	ret = power_supply_register(di->dev, &di->bat);
-	if (ret) {
-		platform_set_drvdata(pdev, NULL);
+	if (ret)
 		return ret;
-	}
 
 	return 0;
 }
@@ -229,7 +227,6 @@ static int rx51_battery_remove(struct platform_device *pdev)
 	struct rx51_device_info *di = platform_get_drvdata(pdev);
 
 	power_supply_unregister(&di->bat);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
-- 
1.7.2.5


