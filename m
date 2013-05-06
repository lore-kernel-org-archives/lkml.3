Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab3EFEkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 00:40:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34841 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab3EFEkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 00:40:23 -0400
X-AuditID: cbfee68d-b7f016d000007930-26-51873435ddb5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Herbert Xu'" <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org, "'Matt Mackall'" <mpm@selenic.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 4/4] hwrng: tx4939 - remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 13:40:21 +0900
Message-id: <004901ce4a13$d14b7360$73e25a20$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KE8Czjmf+pnA5Tqe0g9sYqixAug==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zfV1Tk/ZAg2+LbSy6X8lYXF54idXi
	8q45bBYLtvUxOrB4bDug6tG3ZRWjR9/LDYwenzfJBbBEcdmkpOZklqUW6dslcGX8nnGUtaCZ
	vWJO427WBsbvrF2MnBwSAiYSV6e+h7LFJC7cW8/WxcjFISSwjFHi/84HzDBF934eZoRITGeU
	uDvhLlTVL0aJ3293M4FUsQmoSXz5cpgdxBYR0JPoW9/ICGIzC6RJbN/4nw3EFhbwk9i6YTYL
	iM0ioCpx7cw7sF5eAUuJ9hU72CFsQYkfk++xQPRqSazfeZwJwpaX2LzmLdRFChI7zr5mhNl1
	/zbEfGYBEYl9L96BXSohsIpdYsPZTjaIZQIS3yYfAhrKAZSQldh0AGqOpMTBFTdYJjCKzUKy
	ehaS1bOQrJ6FZMUCRpZVjKKpBckFxUnpRYZ6xYm5xaV56XrJ+bmbGCFR1ruD8fYB60OMyUDr
	JzJLiSbnA6M0ryTe0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOM
	TBycUg2MJowMT6tz659PfuL5x211fCmXxfdkgYdfKmL68nc+udUxT5k7led229Zoy85Xtz77
	V6/Z9eSQqqmXWtz5I5MOTN6zdOadj4KvLKZbhF24JLjx306Nd/KKeo0M3zlebTv5XutVznKm
	N/v2rNj9/krdcf5EM+kdm9QP+b9d/8ppthDbopNLBCRvWCuxFGckGmoxFxUnAgCLzg/LyAIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jQV1Tk/ZAg8/HTCy6X8lYXF54idXi
	8q45bBYLtvUxOrB4bDug6tG3ZRWjR9/LDYwenzfJBbBENTDaZKQmpqQWKaTmJeenZOal2yp5
	B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gBtVFIoS8wpBQoFJBYXK+nbYZoQGuKmawHT
	GKHrGxIE12NkgAYS1jFm/J5xlLWgmb1iTuNu1gbG76xdjJwcEgImEvd+HmaEsMUkLtxbz9bF
	yMUhJDCdUeLuhLtQzi9Gid9vdzOBVLEJqEl8+XKYHcQWEdCT6FvfCNbNLJAmsX3jfzYQW1jA
	T2LrhtksIDaLgKrEtTPvwHp5BSwl2lfsYIewBSV+TL7HAtGrJbF+53EmCFteYvOat8wQFylI
	7Dj7mhFm1/3bEPOZBUQk9r14xziBUWAWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca6hUn
	5haX5qXrJefnbmIEx/AzqR2MKxssDjEKcDAq8fAWPGkLFGJNLCuuzD3EKMHBrCTC67MXKMSb
	klhZlVqUH19UmpNafIgxGejTicxSosn5wPSSVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB
	9MSS1OzU1ILUIpgtTBycUg2MPdlyR15EW+sbZF9k+9Uee/KGeDyD5/wPQQd3zih/9uNC7PaH
	XbmMSY8W9W6tD4yr3rb6ic5jhUlibz9URmrejd34tlh08n32SdUHl5/wilCc7/u56BWXU+W1
	A1VHbveuOnZ45m9+K0vjl5++Gws6p83WfrLvutIB0/vnbtzlu3TM7dUip9BFmkosxRmJhlrM
	RcWJABfZjpolAwAA
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
 drivers/char/hw_random/tx4939-rng.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/char/hw_random/tx4939-rng.c b/drivers/char/hw_random/tx4939-rng.c
index d34a24a..00593c8 100644
--- a/drivers/char/hw_random/tx4939-rng.c
+++ b/drivers/char/hw_random/tx4939-rng.c
@@ -154,7 +154,6 @@ static int __exit tx4939_rng_remove(struct platform_device *dev)
 	struct tx4939_rng *rngdev = platform_get_drvdata(dev);
 
 	hwrng_unregister(&rngdev->rng);
-	platform_set_drvdata(dev, NULL);
 	return 0;
 }
 
-- 
1.7.2.5


