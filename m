Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3HVCRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:17:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13990 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab3HVCRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:17:10 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-45-521574a5d8ee
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002501ce9edd$95cbb740$c16325c0$%han@samsung.com>
In-reply-to: <002501ce9edd$95cbb740$c16325c0$%han@samsung.com>
Subject: [PATCH 3/3] pcmcia: sa1100: remove unnecessary platform_set_drvdata()
Date: Thu, 22 Aug 2013 11:17:09 +0900
Message-id: <002701ce9edd$b4997540$1dcc5fc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6e3ZW0yWqkn3rITp+VdERxCde4wAAABQew
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zY92lJaJBBk3/dS3mrF/DZnF54SVW
	i8u75rBZTO77xeLA4nFixm8Wj81L6j36tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr4+GxDYwF
	k9gqPj36x9TA2MPaxcjJISFgIjFr9ikmCFtM4sK99WxdjFwcQgLLGCWOnl/B3sXIAVY0c1oK
	RHw6o8SnG59YIZxfjBInetYygnSzCahJfPlyGKxBREBfoq1FA8RkFsiQeHM1FaRCSMBW4v+V
	A2wgNqeAncTFixfBbGEBP4m53yezg9gsAqoS25Y2gU3kBarvOfyACcIWlPgx+R4LiM0soCWx
	fudxJghbXmLzmrfMEGeqSzz6qwsSFhEwktgz4QxUuYjEvhfvGEEulhA4xy4x6UcjE8QuAYlv
	kw+xQPTKSmw6wAwJBkmJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT0osM9YoT
	c4tL89L1kvNzNzFC4rF3B+PtA9aHGJOB1k9klhJNzgfGc15JvKGxmZGFqYmpsZG5pRlpwkri
	vGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGAU4Ge99fG3VIvuQ552SVuPhFU/upz8s
	qtrqpFbz2bwiLqTdu/n5K3FZu6t9d1Oatz+Qfrpntqi2nvaT9Mufy4+FLT2dFh53+1TFQs3M
	bcxmjwQPKzBuPuV7fAqDws/COW47H+fNjzU6t/m1tfvchYcz1mY1M11iuG5/bOONU+kfPHh0
	WLt91JVYijMSDbWYi4oTARPEMoTdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jQd2lJaJBBlfWaFnMWb+GzeLywkus
	Fpd3zWGzmNz3i8WBxePEjN8sHpuX1Hv0bVnF6PF5k1wAS1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8bDYxsYCyaxVXx69I+pgbGHtYuRg0NCwERi5rSULkZOIFNM4sK9
	9WxdjFwcQgLTGSU+3fjECuH8YpQ40bOWEaSKTUBN4suXw+wgzSIC+hJtLRogJrNAhsSbq6kg
	FUICthL/rxxgA7E5BewkLl68CGYLC/hJzP0+mR3EZhFQldi2tAlsIi9Qfc/hB0wQtqDEj8n3
	WEBsZgEtifU7jzNB2PISm9e8ZYY4WV3i0V9dkLCIgJHEnglnoMpFJPa9eMc4gVFoFpJJs5BM
	moVk0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBEf7M+kdjKsaLA4xCnAwKvHw
	XtgpEiTEmlhWXJl7iFGCg1lJhFdaSzRIiDclsbIqtSg/vqg0J7X4EGMy0KMTmaVEk/OBiSiv
	JN7Q2MTMyNLIzMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhinnzjkP2n/xnfN
	Ijf4f+75vm+9ygdlrcv/Dn9Z6GKx80TZhoRHZ1QP/ZX5sbviYfPn3yG7mXX8TnoWJZ/b0yn9
	4e/i77EVU1NytAW4r2z6W8E54dhhj1epa/142lxW3WBhsogrkFST4+A/VKg5pfXKlrRssaN7
	tI+Wpa800PtetKxOVTnWW/e8EktxRqKhFnNRcSIAzN0stDoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pcmcia/sa1100_generic.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pcmcia/sa1100_generic.c b/drivers/pcmcia/sa1100_generic.c
index ff8a027..fed68e6 100644
--- a/drivers/pcmcia/sa1100_generic.c
+++ b/drivers/pcmcia/sa1100_generic.c
@@ -88,8 +88,6 @@ static int sa11x0_drv_pcmcia_remove(struct platform_device *dev)
 	struct skt_dev_info *sinfo = platform_get_drvdata(dev);
 	int i;
 
-	platform_set_drvdata(dev, NULL);
-
 	for (i = 0; i < sinfo->nskt; i++)
 		soc_pcmcia_remove_one(&sinfo->skt[i]);
 
-- 
1.7.10.4


