Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab3EFDcW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 23:32:22 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41629 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab3EFDcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 23:32:21 -0400
X-AuditID: cbfee691-b7fe56d000004b96-db-518724440b6e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>, "'Lee Jones'" <lee.jones@linaro.org>
Subject: [PATCH 5/7] gpio: tc3589x: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 12:32:19 +0900
Message-id: <001b01ce4a0a$5076bb90$f16432b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KCiP2WB7V5Vq3SQ6DMyAoQ9shww==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t8zfV0XlfZAgwUPBS1endnIZnF54SVW
	i/tfjzJaTPmznMni8q45bA6sHneu7WHz6NuyitHj50sdj8+b5AJYorhsUlJzMstSi/TtErgy
	9p24wVqwia3i5db7TA2Mq1i7GDk5JARMJHYceMQOYYtJXLi3ng3EFhJYxijx6p8PTE3zzXlA
	9VxA8emMEnvOvIVyfjFKNN7YzAxSxSagJvHly2GwSSICehI3LnQwgtjMAlMYJf59yQKxhQV8
	Jb4vWwq2gUVAVeL90lNgV/AKWEpsmdzOAmELSvyYfI8FoldLYv3O40wQtrzE5jVvmSEuUpDY
	cfY1I8yuPxNeMEPUiEjse/GOEeQ4CYFt7BIT7x1lhFgmIPFt8iGgoRxACVmJTQeg5khKHFxx
	g2UCo9gsJKtnIVk9C8nqWUhWLGBkWcUomlqQXFCclF5kqlecmFtcmpeul5yfu4kREm8TdzDe
	P2B9iDEZaP1EZinR5HxgvOaVxBsamxlZmJqYGhuZW5qRJqwkzqveYh0oJJCeWJKanZpakFoU
	X1Sak1p8iJGJg1OqgVFm2Zqzk2zvarLvF9S+WsiovvnFm2ThqPxbYu5s3lLMM5eYWZ39ZDbl
	ba+A4BKmtin1f1gt8hof79o0oXx78r975XdXhm/vWO6Y+ybv3pW1aon524us5QS/Vu0IZzsl
	MWXppJOZ915WdK6Lzth3roFrrQ7PnGfVb5zaP7XH8qzXD+w1ODfZ8YgSS3FGoqEWc1FxIgAd
	FbDezQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jQV0XlfZAg88/eS1endnIZnF54SVW
	i/tfjzJaTPmznMni8q45bA6sHneu7WHz6NuyitHj50sdj8+b5AJYohoYbTJSE1NSixRS85Lz
	UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA9ioplCXmlAKFAhKLi5X07TBN
	CA1x07WAaYzQ9Q0JgusxMkADCesYM/aduMFasImt4uXW+0wNjKtYuxg5OSQETCSab86DssUk
	Ltxbz9bFyMUhJDCdUWLPmbesEM4vRonGG5uZQarYBNQkvnw5zA5iiwjoSdy40MEIYjMLTGGU
	+PclC8QWFvCV+L5sKRuIzSKgKvF+6SmwDbwClhJbJrezQNiCEj8m32OB6NWSWL/zOBOELS+x
	ec1bZoiLFCR2nH3NCLPrz4QXzBA1IhL7XrxjnMAoMAvJqFlIRs1CMmoWkpYFjCyrGEVTC5IL
	ipPScw31ihNzi0vz0vWS83M3MYLj+ZnUDsaVDRaHGAU4GJV4eAuetAUKsSaWFVfmHmKU4GBW
	EuH12QsU4k1JrKxKLcqPLyrNSS0+xJgM9OlEZinR5HxgqskriTc0NjEzsjQyszAyMTcnTVhJ
	nPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBsbEUF25ygJ22foTG3c1rRKasIb3lEXSltc7G2P9
	c4zmRnP1u6Wvat71RkfpgQ1/aNOyNq41W7av+mC+J0buMKcO5/TVLwPlns7ZkXj8r56U0r1C
	04LbjP6K3gFs3L17L4md63uYW5R447X5lLfyMX9DjaPfzY/pPHonfnZk9O2uzQ+Xnt+9V0qJ
	pTgj0VCLuag4EQAerEMyKwMAAA==
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
 drivers/gpio/gpio-tc3589x.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-tc3589x.c b/drivers/gpio/gpio-tc3589x.c
index d34d80d..4a5de27 100644
--- a/drivers/gpio/gpio-tc3589x.c
+++ b/drivers/gpio/gpio-tc3589x.c
@@ -407,7 +407,6 @@ static int tc3589x_gpio_remove(struct platform_device *pdev)
 
 	free_irq(irq, tc3589x_gpio);
 
-	platform_set_drvdata(pdev, NULL);
 	kfree(tc3589x_gpio);
 
 	return 0;
-- 
1.7.2.5


