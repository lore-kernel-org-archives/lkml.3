Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349Ab3EWKo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:44:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54410 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758305Ab3EWKoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:44:55 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-0c-519df326bf9a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Guenter Roeck'" <linux@roeck-us.net>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 5/5] watchdog: wm831x: use platform_{get,set}_drvdata()
Date: Thu, 23 May 2013 19:44:53 +0900
Message-id: <003801ce57a2$8f0dae40$ad290ac0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Xoo5FKFWlT1+HQj+9Xzwmcm/ahw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zfV21z3MDDTq6RCzmrF/DZnF54SVW
	i8u75rBZ3Fi3j93iycIzTBa3ZrxgdWDzuLZZzOPEjN8sHju/N7B79G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV0bvlinMBUs4Ko5vWcPawPiHrYuRk0NCwERiz6yXLBC2mMSFe+uB4lwcQgLL
	GCUmXD/PDFO0/t4MJojEdEaJ1jVHmCGcXyDOC3aQKjYBNYkvXw4D2RwcIgL6Em0tGiA1zAIb
	GCVO/v8LViMs4C5x68wXRhCbRUBV4kPveiYQm1fAUmLD5ndsELagxI/J98BOYhbQkli/8zgT
	hC0vsXnNW6iLFCR2nH0NNkdEQE/iztl5bBA1IhL7XrxjBFksIXCKXWLSwv/sEMsEJL5NPsQC
	cpyEgKzEpgNQcyQlDq64wTKBUWwWktWzkKyehWT1LCQrFjCyrGIUTS1ILihOSi8y0StOzC0u
	zUvXS87P3cQIicIJOxjvHbA+xJgMtH4is5Rocj4wivNK4g2NzYwsTE1MjY3MLc1IE1YS51Vv
	sQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwFgZ2po/8wx7q2SNxYrMvxtv9MxovZlvXOq4
	1a+EwU0s2W9OY8len4zKWptaBbnwogthTz42mKVZCXCFpJQpJXfVX9ln8kNaT8BRQfTEr69R
	wSvXqkkKRBx5rX2Bm2mTU5xs++yNha5XxZY7WdQ86Vk24ZD7fn7vpjbTOaqP7pq+4JBb/vCc
	EktxRqKhFnNRcSIA+ZYF+dgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jQV21z3MDDQ63CFjMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFk4VnmCxuzXjB6sDmcW2zmMeJGb9ZPHZ+b2D36NuyitHj8ya5ANaoBkab
	jNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKALlBTKEnNK
	gUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZvVumMBcs4ag4vmUNawPjH7YuRk4O
	CQETifX3ZjBB2GISF+6tB4pzcQgJTGeUaF1zhBnC+QXivGAHqWITUJP48uUwkM3BISKgL9HW
	ogFSwyywgVHi5P+/YDXCAu4St858YQSxWQRUJT70rgfbwCtgKbFh8zs2CFtQ4sfkeywgNrOA
	lsT6nceZIGx5ic1r3jJDXKQgsePsa7A5IgJ6EnfOzmODqBGR2PfiHeMERoFZSEbNQjJqFpJR
	s5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHOPPpHcwrmqwOMQowMGoxMMrcXtO
	oBBrYllxZe4hRgkOZiUR3s09cwOFeFMSK6tSi/Lji0pzUosPMSYDfTqRWUo0OR+YfvJK4g2N
	TcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgXHu1rasi7XX9Tecu9Wd
	cfftj3U7a07yKUslR2i7rd/7IJr3893oLTqfNhxdeHX/pjXzrl5SLr385/zL46yW11+/2ek7
	hXFK4zJmhRzrLx+N5B2mLtieGX7317PsDunL0inTF4Qqa+dnzpunn//UOk725INbN4tFpHmX
	CybrHDdIvnqo98mUx3f6lViKMxINtZiLihMBEAi0azUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
so we can directly pass a struct platform_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/wm831x_wdt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
index 9dcb6d0..6c302fd 100644
--- a/drivers/watchdog/wm831x_wdt.c
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -281,7 +281,7 @@ static int wm831x_wdt_probe(struct platform_device *pdev)
 		goto err_gpio;
 	}
 
-	dev_set_drvdata(&pdev->dev, driver_data);
+	platform_set_drvdata(pdev, driver_data);
 
 	return 0;
 
@@ -294,7 +294,7 @@ err:
 
 static int wm831x_wdt_remove(struct platform_device *pdev)
 {
-	struct wm831x_wdt_drvdata *driver_data = dev_get_drvdata(&pdev->dev);
+	struct wm831x_wdt_drvdata *driver_data = platform_get_drvdata(pdev);
 
 	watchdog_unregister_device(&driver_data->wdt);
 
-- 
1.7.10.4


