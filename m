Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaB0LhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:37:18 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:9185 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbaB0LhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:37:16 -0500
X-AuditID: cbfee68f-b7f156d00000276c-d4-530f236b7f47
From: Jingoo Han <jg1.han@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>
Cc: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000801cf33b0$1f9876e0$5ec964a0$%han@samsung.com>
In-reply-to: <000801cf33b0$1f9876e0$5ec964a0$%han@samsung.com>
Subject: [PATCH 2/2] extcon: gpio: Use SIMPLE_DEV_PM_OPS macro
Date: Thu, 27 Feb 2014 20:37:15 +0900
Message-id: <000901cf33b0$43786ca0$ca6945e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8zsB9vKpqotdqpRImP5zt9se4HagAAAakA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t8zfd1sZf5gg3ffrCyuf3nOanF54SUg
	sWsOm8XtxhVsDiwefVtWMXp83iQXwBTFZZOSmpNZllqkb5fAlfHm60Wmgna2ihnTJrE3MPaz
	djFyckgImEjcfHyEGcIWk7hwbz1bFyMXh5DAMkaJi5MvsXcxcoAV3fmuARGfzihxcPY8Rgjn
	N6NEw5UPYJPYBNQkvnw5zA5iiwhoSUzsnMkEYjMLFErcvjEXrEZIwFbiyvkFLCA2p4CdxIJP
	D8BsYSC7+cF9sHoWAVWJZ9u/MoLYvED1Ta2PmSBsQYkfk++xQMzUkli/8zjUfHmJzWveMkMc
	qi7x6K8uxAlGEmeW3GWGKBGR2PfiHSPEk9vYJVoPSECsEpD4NvkQC0SrrMSmA9BwkJQ4uOIG
	ywRGiVlIFs9CsngWksWzkGxYwMiyilE0tSC5oDgpvchYrzgxt7g0L10vOT93EyMk/vp3MN49
	YH2IMRlo/URmKdHkfGD85pXEGxqbGVmYmpgaG5lbmpEmrCTOe/9hUpCQQHpiSWp2ampBalF8
	UWlOavEhRiYOTqkGxuwfspUXPIQrirTUt286skV88p+slSbZIcu/1ZpcvOI63/Dl/G7lLS8u
	HU+fdkihaFpuEovJOjsBSWGlN+cr/siFTq89n3w97cnij2/kPX46st+XZFvoIm17trFV4NEl
	aWe3j26ZcgIrv638k7n4xOnZxuGX3p8sjrtWd2OCfJqa+t7PUU95pyixFGckGmoxFxUnAgBH
	WhME1QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jQd1sZf5ggzcTzC2uf3nOanF54SUg
	sWsOm8XtxhVsDiwefVtWMXp83iQXwBTVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhr
	aGlhrqSQl5ibaqvk4hOg65aZA7RJSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EB
	GkhYx5jx5utFpoJ2tooZ0yaxNzD2s3YxcnBICJhI3Pmu0cXICWSKSVy4t56ti5GLQ0hgOqPE
	wdnzGCGc34wSDVc+sIJUsQmoSXz5cpgdxBYR0JKY2DmTCcRmFiiUuH1jLliNkICtxJXzC1hA
	bE4BO4kFnx6A2cJAdvOD+2D1LAKqEs+2f2UEsXmB6ptaHzNB2IISPybfY4GYqSWxfudxqPny
	EpvXvGWGOFpd4tFfXYgTjCTOLLnLDFEiIrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1
	ILmgOCk911CvODG3uDQvXS85P3cTIzi+n0ntYFzZYHGIUYCDUYmHV4GNL1iINbGsuDL3EKME
	B7OSCO96Jv5gId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYSTc4Hpp68knhDYxMzI0sjMwsjE3Nz
	0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamCUvi1uaT+lQ9QzdhObiZC4kG6L/JfGbPMO
	mdV5S+rFme5eTvVaou16sd28eObdiCDH68I7hKdesb9z0Ezorq5Ymmor3zPOdO+FqTFReYrX
	ZIo3MPSVFiXl1E/9H7YkL1zwycMtcVPzmF6e+m2TdtVA4WF3flli8HVt379b49VsdFuiXhpc
	UWIpzkg01GIuKk4EAGLFtQ8zAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use SIMPLE_DEV_PM_OPS macro in order to make the code simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/extcon/extcon-gpio.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index a63a6b2..13d5222 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -176,9 +176,7 @@ static int gpio_extcon_resume(struct device *dev)
 }
 #endif
 
-static const struct dev_pm_ops gpio_extcon_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(NULL, gpio_extcon_resume)
-};
+static SIMPLE_DEV_PM_OPS(gpio_extcon_pm_ops, NULL, gpio_extcon_resume);
 
 static struct platform_driver gpio_extcon_driver = {
 	.probe		= gpio_extcon_probe,
-- 
1.7.10.4


