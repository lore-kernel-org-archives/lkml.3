Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762502Ab3ECGTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:19:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:61092 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762165Ab3ECGTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:19:04 -0400
X-AuditID: cbfee68d-b7f016d000007930-c9-518356d7ada9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Subject: [PATCH 3/4] backlight: lp8788: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:19:03 +0900
Message-id: <000d01ce47c6$1b93c990$52bb5cb0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HxfyLw4mYBAYGSOSxCSUgdmpo4A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t8zQ93rYc2BBkemKFnMWb+GzeLyrjls
	Frt3PWV1YPY4MeM3i8ee+T9YPT5vkgtgjuKySUnNySxLLdK3S+DKePH2O0vBCvaKaY1NrA2M
	89m6GDk5JARMJDY9XM8KYYtJXLi3HijOxSEksIxR4vn6M+xdjBxgRfv2M0HEpzNKrJywgx3C
	+cUo0XT8LztIN5uAmsSXL4fBGkQE9CXaWjRAwswC/hKbv60FKxEWCJa4tW0n2GIWAVWJM8vn
	gNm8ApYSTR0fWSBsQYkfk++xQPRqSazfeZwJwpaX2LzmLTPEoQoSO86+ZgSxRQT0JFraHrNC
	1IhI7HvxjhHkNgmBZewSO9r2M0MsE5D4NvkQC8QzshKbDkDNkZQ4uOIGywRGsVlIVs9CsnoW
	ktWzkKxYwMiyilE0tSC5oDgpvchQrzgxt7g0L10vOT93EyMkonp3MN4+YH2IMRlo/URmKdHk
	fGBE5pXEGxqbGVmYmpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB
	Mb/SdevniH8H2FjTnmmcL9z71G/ZUfsmT5Zw5Ulrs/ZzH255uenQ8Y/yKU5xpdc38Sxi7dtt
	eUQne491j825dvVHfCnXdkx7fOTgp9Uvuurff2G5umTTltyOHV7bZA9z73/vnXsj4knatX1b
	JwetbZd0vBvqcGKPVJ/6nWPVoXPdk8SbllyN+ajEUpyRaKjFXFScCAB1s3bmvgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xoO71sOZAg02f5SzmrF/DZnF51xw2
	i927nrI6MHucmPGbxWPP/B+sHp83yQUwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdj
	ZIAGEtYxZrx4+52lYAV7xbTGJtYGxvlsXYwcHBICJhL79jN1MXICmWISF+6tBwpzcQgJTGeU
	WDlhBzuE84tRoun4X3aQKjYBNYkvXw6zgzSLCOhLtLVogISZBfwlNn9bC1YiLBAscWvbTjYQ
	m0VAVeLM8jlgNq+ApURTx0cWCFtQ4sfkeywQvVoS63ceZ4Kw5SU2r3nLDHGQgsSOs68ZQWwR
	AT2JlrbHrBA1IhL7XrxjnMAoMAvJqFlIRs1CMmoWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz
	0vWS83M3MYLj9Zn0DsZVDRaHGAU4GJV4eBVamgKFWBPLiitzDzFKcDArifC6/QAK8aYkVlal
	FuXHF5XmpBYfYkwG+nQis5Rocj4wleSVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1
	OzW1ILUIZgsTB6dUA6P6h0CemeVaP+7yPA/btUQ/O8r5X6jW4en7w7VE75w5dmZDksK1tR0X
	f3Ptidd4yXnlx9OESe9Lb6rPYtQ/8KQtZCuLwKvUuXp8MWH5x/jF6oXnmWY3+ieZHCj7oXI4
	Mbvkn/gRvuOMHKzaP8VCNrbby2/jfLHhvubFOZ6/uM1nz/jMImgab6zEUpyRaKjFXFScCACe
	aEchGwMAAA==
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
 drivers/video/backlight/lp8788_bl.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/lp8788_bl.c b/drivers/video/backlight/lp8788_bl.c
index 4bb8b4f..980855e 100644
--- a/drivers/video/backlight/lp8788_bl.c
+++ b/drivers/video/backlight/lp8788_bl.c
@@ -312,7 +312,6 @@ static int lp8788_backlight_remove(struct platform_device *pdev)
 	backlight_update_status(bl_dev);
 	sysfs_remove_group(&pdev->dev.kobj, &lp8788_attr_group);
 	lp8788_backlight_unregister(bl);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
-- 
1.7.2.5


