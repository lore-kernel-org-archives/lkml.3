Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab3B1IkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:40:21 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:20864 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab3B1IkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:40:19 -0500
X-AuditID: cbfee690-b7f6b6d000004563-32-512f17f180d5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
In-reply-to: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
Subject: [PATCH 04/19] rtc: omap: remove erroneous __init/__exit annotations
Date: Thu, 28 Feb 2013 17:40:17 +0900
Message-id: <00a801ce158f$3c6239e0$b526ada0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vju7DHmrOxtsNRmyyH1DU6RVYuAAAD/Og
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zY92P4vqBBusv2lgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVMfFDJ1NBO0/F/PnxDYwTuboYOTkkBEwkVr/cwQxhi0lcuLeeDcQWEljGKPH3vhNM
	TdPtR8wQ8emMEsu++XUxcgHZvxglNmztZQRJsAmoSXz5cpi9i5GDQ0RAX6KtRQOkhlmgl1Hi
	TO9udohmW4ljbW0sIDangJ3E76dHWUFsYQEfiW9HL4ItYBFQldhz+DnYTF6g+kWv7rNA2IIS
	PybfA7OZBbQk1u88zgRhy0tsXvOWGWSvhIC6xKO/uiBhEQEjidar/9kgSkQk9r14xwhyj4TA
	PXaJRQdWskPsEpD4NvkQC0SvrMSmA9BwkJQ4uOIGywRGiVlINs9CsnkWks2zkKxYwMiyilE0
	tSC5oDgpvchErzgxt7g0L10vOT93EyMkSifsYLx3wPoQYzLQ+onMUqLJ+cAozyuJNzQ2NjEz
	MTUxtzQ1NyVNWEmcV/6STKCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxtUKTb8qOWa4HWe5
	OKfyUMC/5935PsHhijb8abuuf5/v71+5Oopp0uW8c1pyymHK7lULNHddLNh6ftFsE129tDvr
	vD635x346SxlsuOaQfpe16tizWFTdkdkPbazfWERrsb5bbqLwR2X+6967fsfH/SXspz0f/a1
	ZRGmHy02ibYrHnl3c7vNISWW4oxEQy3mouJEAAv1cOToAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd2P4vqBBkcPW1gsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmDHxQydTQTtPxfz58Q2ME7m6GDk5JARMJJpu
	P2KGsMUkLtxbzwZiCwlMZ5RY9s2vi5ELyP7FKLFhay8jSIJNQE3iy5fD7F2MHBwiAvoSbS0a
	IDXMAr2MEmd6d7NDNNtKHGtrYwGxOQXsJH4/PcoKYgsL+Eh8O3oRbBmLgKrEnsPPwWbyAtUv
	enWfBcIWlPgx+R6YzSygJbF+53EmCFteYvOat8wgeyUE1CUe/dUFCYsIGEm0Xv3PBlEiIrHv
	xTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgJPJPe
	wbiqweIQowAHoxIPb4eJXqAQa2JZcWXuIUYJDmYlEV4Xfv1AId6UxMqq1KL8+KLSnNTiQ4zJ
	QI9OZJYSTc4HJqi8knhDYxMzI0sjMwsjE3Nz0oSVxHkZTz0JEBJITyxJzU5NLUgtgtnCxMEp
	1cCYGnC64F7i+9be4xY1TTqtRjzHf/18Kuh43vzt4QU8+9ak93Acqj/22iry1PG9tw+KnTp4
	4cT5MsEmlj0bbjsfYlc+wH5jskjty5fJ77c9ydh6z7phhnsGS27FSdsFVw6vjNkaeWBnrckh
	CfYnlflx1tOvW5zbb/jho0FwqN7ejNs2e2/+u7KkU4mlOCPRUIu5qDgRAAdEDEFGAwAA
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
 drivers/rtc/rtc-omap.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index 6009714..366e220 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -322,7 +322,7 @@ static const struct of_device_id omap_rtc_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, omap_rtc_of_match);
 
-static int __init omap_rtc_probe(struct platform_device *pdev)
+static int omap_rtc_probe(struct platform_device *pdev)
 {
 	struct resource		*res, *mem;
 	struct rtc_device	*rtc;
@@ -461,7 +461,7 @@ fail:
 	return -EIO;
 }
 
-static int __exit omap_rtc_remove(struct platform_device *pdev)
+static int omap_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_device	*rtc = platform_get_drvdata(pdev);
 	struct resource		*mem = dev_get_drvdata(&rtc->dev);
@@ -538,7 +538,7 @@ static void omap_rtc_shutdown(struct platform_device *pdev)
 
 MODULE_ALIAS("platform:omap_rtc");
 static struct platform_driver omap_rtc_driver = {
-	.remove		= __exit_p(omap_rtc_remove),
+	.remove		= omap_rtc_remove,
 	.suspend	= omap_rtc_suspend,
 	.resume		= omap_rtc_resume,
 	.shutdown	= omap_rtc_shutdown,
-- 
1.7.2.5


