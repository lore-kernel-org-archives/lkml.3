Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964827Ab3DEBzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:55:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19519 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964769Ab3DEBzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:55:36 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-a4-515e2f178060
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/3] misc: at25: use spi_get_drvdata() and spi_set_drvdata()
Date: Fri, 05 Apr 2013 10:55:35 +0900
Message-id: <000b01ce31a0$a9cc7400$fd655c00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4xoKm1XjxbSUlOS4SxFc1W0tdNQg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsVy+t8zfV1x/bhAg7V71CyaF69ns7i88BKr
	xeVdc9gcmD32z13D7tG3ZRWjx+dNcgHMUVw2Kak5mWWpRfp2CVwZH/7sYy84yVHR+fo2cwPj
	BPYuRk4OCQETiT3fbrJC2GISF+6tZwOxhQSWMUpM+R0FU/NteiNzFyMXUHwRo8Sny7tZIJxf
	jBJPL10E62ATUJP48uUw2FQRAVOJje+nMHYxcnAwC7hIHJ0mAmIKC/hI9D+2BjFZBFQldh9V
	BCnmFbCVWD6lixXCFpT4MfkeC4jNLKAlsX7ncSYIW15i85q3zCCtEgLqEo/+6oKYIgJ6Es/3
	hkBUiEjse/GOEeQuCYFl7BKLm1qZQRIsAgIS3yYfYoFolZXYdIAZ4ilJiYMrbrBMYBSbhWTx
	LCSLZyFZPAvJigWMLKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxQiKpfwfj3QPWhxiTgdZP
	ZJYSTc4HRmJeSbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZ
	ODilGhibQkKNz7QxeETu2L7aM8OwJefdIW3OmQ+tpY6n/Z0k+1+pkCX6/dMHqpcPmL30Y9qv
	+177bVjWSk4nvrW5vcbTFzw7P4W58X2ImnijZKJVp9cbZeHjCsc7Oo5IWE/fdovNaJarzuzP
	Om33xA/tf/K7731e5Vuuqc83bnGaNnfqHs4gtbQHx6cosRRnJBpqMRcVJwIAlnYWi7oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+xgK64flygweQuJYvmxevZLC4vvMRq
	cXnXHDYHZo/9c9ewe/RtWcXo8XmTXABzVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGh
	rqGlhbmSQl5ibqqtkotPgK5bZg7QJiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1G
	BmggYR1jxoc/+9gLTnJUdL6+zdzAOIG9i5GTQ0LAROLb9EZmCFtM4sK99WxdjFwcQgKLGCU+
	Xd7NAuH8YpR4eukiG0gVm4CaxJcvh8G6RQRMJTa+n8LYxcjBwSzgInF0mgiIKSzgI9H/2BrE
	ZBFQldh9VBGkmFfAVmL5lC5WCFtQ4sfkeywgNrOAlsT6nceZIGx5ic1r3jKDtEoIqEs8+qsL
	YooI6Ek83xsCUSEise/FO8YJjAKzkAyahWTQLCSDZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4
	NC9dLzk/dxMjOFKfSe1gXNlgcYhRgINRiYc3oy82UIg1say4MvcQowQHs5II706+uEAh3pTE
	yqrUovz4otKc1OJDjMlAb05klhJNzgcmkbySeENjEzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQn
	lqRmp6YWpBbBbGHi4JRqYDweJdR0YiK7enl73IrGfSIfJhtG/OaQEL8bpcl+PyxW7DnLHJvZ
	kgVuDtIunKt+rTxbv6CbZ/M2zs450vcW5JUWMhzzc1p8c+uFov3XJ5cUqzlOPHMhKTpfIVzr
	YkZRVmrWdtVzD3X/+J7xP912fKr6Od6NAsuFRTRXy9vXylzMVZ3XP+HkWyWW4oxEQy3mouJE
	AJuVR9IYAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/misc/eeprom/at25.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index b08cf8a..ad8fd8e 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -412,7 +412,7 @@ static int at25_probe(struct spi_device *spi)
 	mutex_init(&at25->lock);
 	at25->chip = chip;
 	at25->spi = spi_dev_get(spi);
-	dev_set_drvdata(&spi->dev, at25);
+	spi_set_drvdata(spi, at25);
 	at25->addrlen = addrlen;
 
 	/* Export the EEPROM bytes through sysfs, since that's convenient.
@@ -463,7 +463,7 @@ static int at25_remove(struct spi_device *spi)
 {
 	struct at25_data	*at25;
 
-	at25 = dev_get_drvdata(&spi->dev);
+	at25 = spi_get_drvdata(spi);
 	sysfs_remove_bin_file(&spi->dev.kobj, &at25->bin);
 	kfree(at25);
 	return 0;
-- 
1.7.2.5


