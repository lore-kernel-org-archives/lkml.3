Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3B1IiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:38:11 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:47286 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3B1IiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:38:10 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-aa-512f1770f0b6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 01/19] rtc: rtc-mv: remove erroneous __exit annotation
Date: Thu, 28 Feb 2013 17:38:07 +0900
Message-id: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vju7DHmrOxtsNRmyyH1DU6RVYuA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zQ90Ccf1Ag86v0hZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBlnO98x17wnqNi7ar9bA2Ma9i7GDk5JARMJG7+bGOBsMUkLtxbz9bFyMUhJLCMUeLW
	sW1MMEVbri5ihUhMZ5Q4MHEzC4Tzi1Hi2qRWsFFsAmoSX74cBrI5OEQE9CXaWjRAapgFehkl
	zvTuBqsRFnCTuN19mhHEZhFQlfh9+DEbSD2vgK1E5xdVkDCvgKDEj8n3wC5iFtCSWL/zOBOE
	LS+xec1bZpByCQF1iUd/dSE26UmcW6kEUSEise/FO0aQrRICx9glPnWvZobYJCDxbfIhFohW
	WYlNB5gh3pKUOLjiBssERrFZSBbPQrJ4FpLFs5CsWMDIsopRNLUguaA4Kb3IVK84Mbe4NC9d
	Lzk/dxMjJO4m7mC8f8D6EGMy0PqJzFKiyfnAuM0riTc0NjYxMzE1Mbc0NTclTVhJnFf+kkyg
	kEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsag46IH9ojUbsnz2JG4yyRWMObNw81uvxmF7e03
	iCgvNT/TkR6kxfrZuje2P3cn7/lmdi65hIyJFqVyj2Vepk08UvjG0smq6Yh76yOWQ86zd3Js
	lIjhLoio2mzp1nGdV0f/t/Ub76/2ZXsO/N7z0/pvpknRTK2y9Mt/uqpP/HIL81xdNZvBQYml
	OCPRUIu5qDgRABPTTrjRAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQd0Ccf1Ag7svxSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzDjf+Y694D1HxdpV+9kaGNewdzFyckgImEhs
	ubqIFcIWk7hwbz1bFyMXh5DAdEaJAxM3s0A4vxglrk1qBetgE1CT+PLlMJDNwSEioC/R1qIB
	UsMs0MsocaZ3N1iNsICbxO3u04wgNouAqsTvw4/ZQOp5BWwlOr+ogoR5BQQlfky+xwJiMwto
	SazfeZwJwpaX2LzmLTNIuYSAusSjv7oQm/Qkzq1UgqgQkdj34h3jBEaBWUgGzUIyaBaSQbOQ
	tCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERzVz6R2MK5ssDjEKMDBqMTD22GiFyjE
	mlhWXJl7iFGCg1lJhNeFXz9QiDclsbIqtSg/vqg0J7X4EGMy0JsTmaVEk/OBCSevJN7Q2MTM
	yNLIzMLIxNycNGElcV7GU08ChATSE0tSs1NTC1KLYLYwcXBKNTAqd+UXsrm+m5arM3lZVy+n
	Ji/HdZU2f4/iVUeKJuWlxLdw2lw6dW+61qJK4xkRS7/6Gm26NYfl916TNpMzy/8G79o7SUrq
	4KwNfG1utU+KTG6LNjVrzKmK0tsosszskHchr5m70M/FJx/aTp1fI/e02+0X25tEDQ9x08P9
	TjPKebmX7Q3WO6PEUpyRaKjFXFScCABLVqRILgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__init/__exit annotations for probe()/remove() are supposed to be
__devinit/__devexit, because __init/__exit for probe()/remove()
are not correct. However, __devinit/__devexit are not used,
because CONFIG_HOTPLUG was removed. Thus, these annotations
should be removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-mv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-mv.c b/drivers/rtc/rtc-mv.c
index 57233c8..8cb15d2 100644
--- a/drivers/rtc/rtc-mv.c
+++ b/drivers/rtc/rtc-mv.c
@@ -284,7 +284,7 @@ static int mv_rtc_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __exit mv_rtc_remove(struct platform_device *pdev)
+static int mv_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
@@ -303,7 +303,7 @@ static struct of_device_id rtc_mv_of_match_table[] = {
 #endif
 
 static struct platform_driver mv_rtc_driver = {
-	.remove		= __exit_p(mv_rtc_remove),
+	.remove		= mv_rtc_remove,
 	.driver		= {
 		.name	= "rtc-mv",
 		.owner	= THIS_MODULE,
-- 
1.7.2.5


