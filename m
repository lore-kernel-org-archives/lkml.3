Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab3EFDfX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 23:35:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25441 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab3EFDfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 23:35:22 -0400
X-AuditID: cbfee68f-b7f066d000003683-56-518724f82b95
From: Jingoo Han <jg1.han@samsung.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>,
        "'Dan Carpenter'" <dan.carpenter@oracle.com>
Subject: [PATCH 6/7] gpio: timberdale: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 12:35:19 +0900
Message-id: <001c01ce4a0a$bb7c58a0$327509e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KClqaV0pAVJq/QLuukkrmdv3xFQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zI90fKu2BBlO26lu8/jedxeLVmY1s
	FpcXXmK1mPJnOZPF5V1z2BxYPe5c28Pm8fHpLRaPvi2rGD1+vtTx+LxJLoA1issmJTUnsyy1
	SN8ugStjwqk2xoJrbBXf5h1lbmA8w9rFyMkhIWAi8WLWCmYIW0ziwr31bF2MXBxCAssYJY4s
	ms0IU/So6TsrRGIRo0T/x1lQzi9Gia/HbzGBVLEJqEl8+XKYHcQWEdCTuHGhgxGkiFlgDqPE
	7RVTWEASwgIBEv1fjgLt4OBgEVCVmPk7DiTMK2Ap0fTsNDOELSjxY/I9sHJmAS2J9TuPM0HY
	8hKb17yFOlVBYsfZ14wwu/Z1HWOGqBGR2PfiHdheCYFD7BITGg+CDWIREJD4NvkQC8heCQFZ
	iU0HoOZIShxccYNlAqPYLCSrZyFZPQvJ6llIVixgZFnFKJpakFxQnJReZKxXnJhbXJqXrpec
	n7uJERJ7/TsY7x6wPsSYDLR+IrOUaHI+MHbzSuINjc2MLExNTI2NzC3NSBNWEudVa7EOFBJI
	TyxJzU5NLUgtii8qzUktPsTIxMEp1cAYf/nSBT2x5C9bkmVYIlifmIg+a+6c1rv6y/dtu9U2
	2VnEK3Rlz93truEufFXnZWWmVpqQVJJHSFXntHOrEo9tP18jeGjzzwzL//c8glTqFP/MTXZ+
	f37jW4k/c3Zfl2fuTFsu9jXu5GtxAftlq9+Fz35w6e7fY3Nr3srPL3/A55sseGT7xfmOSizF
	GYmGWsxFxYkArIHqLNMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd0fKu2BBr8bpC1e/5vOYvHqzEY2
	i8sLL7FaTPmznMni8q45bA6sHneu7WHz+Pj0FotH35ZVjB4/X+p4fN4kF8Aa1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYMeFUG2PBNbaKb/OOMjcwnmHtYuTkkBAwkXjU
	9B3KFpO4cG89WxcjF4eQwCJGif6Ps1ghnF+MEl+P32ICqWITUJP48uUwO4gtIqAnceNCByNI
	EbPAHEaJ2yumsIAkhAUCJPq/HAUaxcHBIqAqMfN3HEiYV8BSounZaWYIW1Dix+R7YOXMAloS
	63ceZ4Kw5SU2r3nLDHGRgsSOs68ZYXbt6zrGDFEjIrHvxTvGCYwCs5CMmoVk1Cwko2YhaVnA
	yLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIziyn0nvYFzVYHGIUYCDUYmHt+BJW6AQa2JZ
	cWXuIUYJDmYlEV6fvUAh3pTEyqrUovz4otKc1OJDjMlAj05klhJNzgcmnbySeENjEzMjSyMz
	CyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYNSPYL+eyq/C52Wgz/Tw4qr6Rw8m
	qjAcex9gIzs/Nr+pb+8Lp6e87FNvFTy32Fp9yiv0u9ImPR+H09aBc389nS6vMWNq2RXt5R9V
	fvbVe99V0JJLeVebt+Za/Zv2i03lMy+a6ucef7H+/Ne9+zlXCuh2c23/HXrqxqLvK9s+TN/X
	cuN2rOfyA1ZKLMUZiYZazEXFiQBKJJ9AMAMAAA==
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
 drivers/gpio/gpio-timberdale.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-timberdale.c b/drivers/gpio/gpio-timberdale.c
index 4377405..4c65f88 100644
--- a/drivers/gpio/gpio-timberdale.c
+++ b/drivers/gpio/gpio-timberdale.c
@@ -342,8 +342,6 @@ static int timbgpio_remove(struct platform_device *pdev)
 	release_mem_region(iomem->start, resource_size(iomem));
 	kfree(tgpio);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.5


