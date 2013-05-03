Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762746Ab3ECGaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:30:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60597 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762633Ab3ECGaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:30:30 -0400
X-AuditID: cbfee68d-b7f016d000007930-86-518359855233
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 17/42] rtc: rtc-ep93xx: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:30:29 +0900
Message-id: <001f01ce47c7$b4b41d90$1e1c58b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Hx7QN1t+XTxbDRjy0Jx4Iyxr9xg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t8zY93WyOZAg0etJhZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBl7LsTVjCNo2Lt/JtsDYxP2boYOTkkBEwkrhx+DWWLSVy4tx7MFhJYxijx86QFTE3n
	jllAcS6g+HRGidMrG1khin4xSuy4kgtiswmoSXz5cpi9i5GDQ0RAX6KtRQOknlmgm1HiUfNc
	ZpAaYYFgiVfP3jGC2CwCqhKLH+0Fi/MKWEqsWHmYBcIWlPgx+R6YzSygJbF+53EmCFteYvOa
	t8wQBylI7Dj7GmyOiICexLwNa9ggakQk9r2AmC8hcIhdovFrJsQuAYlvkw+xgNwmISArsekA
	1BhJiYMrbrBMYBSbhWTzLCSbZyHZPAvJhgWMLKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcx
	QqKudwfj7QPWhxiTgdZPZJYSTc4HRm1eSbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp
	2ampBalF8UWlOanFhxiZODilGhinzXouILZkj8UvK8Z5O6R00n40zZ0zaYJV5MZtty6YrPA+
	NZMz6c3SmDcLT51UvZjf9lHZ18xv2/2FR4LfvDgZe7THfo2u29JbZoK/3ol9fsK/Y+6SqU/8
	PJln3z60/QyX2J5HFhsKGQ9PZ6myPdqqWbLa9NRT60MfPA/ovKivbFPqmBT3I/OPoxJLcUai
	oRZzUXEiALQGen7QAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQd3WyOZAg1lNBhZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZuy7E1YwjaNi7fybbA2MT9m6GDk5JARMJDp3
	zIKyxSQu3FsPZHNxCAlMZ5Q4vbKRFSQhJPCLUWLHlVwQm01ATeLLl8PsXYwcHCIC+hJtLRog
	9cwC3YwSj5rnMoPUCAsES7x69o4RxGYRUJVY/GgvWJxXwFJixcrDLBC2oMSPyffAbGYBLYn1
	O48zQdjyEpvXvGWGOEhBYsfZ12BzRAT0JOZtWMMGUSMise/FO8YJjAKzkIyahWTULCSjZiFp
	WcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOK6fSe9gXNVgcYhRgINRiYdXoaUpUIg1
	say4MvcQowQHs5IIr9sPoBBvSmJlVWpRfnxRaU5q8SHGZKBPJzJLiSbnA1NOXkm8obGJmZGl
	kZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwJsv51Ti1fMq4EPtkzsr6dn+P
	VsFHbOZecYGuzbXXTXbtbvyiO99j+WZh00cGBf/0st0/yMa1Ti8N0t8nutCC+Zz6gf+tbtyr
	fturM1QIx3jUcfO+2O2zQCkjzXqmsOBC+xc90wQzen4vt9cQzaycZXpq6bKAU+UxbtHrzBU0
	2I4HT0o7t1+JpTgj0VCLuag4EQBhU65VLwMAAA==
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
 drivers/rtc/rtc-ep93xx.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-ep93xx.c b/drivers/rtc/rtc-ep93xx.c
index 5807b77..549b3c3 100644
--- a/drivers/rtc/rtc-ep93xx.c
+++ b/drivers/rtc/rtc-ep93xx.c
@@ -167,7 +167,6 @@ static int ep93xx_rtc_probe(struct platform_device *pdev)
 	return 0;
 
 exit:
-	platform_set_drvdata(pdev, NULL);
 	pdev->dev.platform_data = NULL;
 	return err;
 }
@@ -175,7 +174,6 @@ exit:
 static int ep93xx_rtc_remove(struct platform_device *pdev)
 {
 	sysfs_remove_group(&pdev->dev.kobj, &ep93xx_rtc_sysfs_files);
-	platform_set_drvdata(pdev, NULL);
 	pdev->dev.platform_data = NULL;
 
 	return 0;
-- 
1.7.2.5


