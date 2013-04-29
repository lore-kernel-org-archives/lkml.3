Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab3D2JfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:35:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23910 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3D2Je6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:34:58 -0400
X-AuditID: cbfee68d-b7f016d000007930-91-517e3ec15049
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH RESEND 2/7] watchdog: bcm63xx_wdt: use devm_ioremap_nocache()
Date: Mon, 29 Apr 2013 18:34:57 +0900
Message-id: <000c01ce44bc$cfed7830$6fc86890$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5EvM8DAPd75royTcaLV+FwlS+vYw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t8zQ92DdnWBBk3/FS3mrF/DZnF54SVW
	i8u75rBZ3Fi3j93i1owXrA6sHtc2i3mcmPGbxaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	Jrx5xF7wmbdixqPnLA2MF7m7GDk5JARMJJ7suckKYYtJXLi3nq2LkYtDSGAZo8SLE9eZYYqm
	P/7GDpFYxCix/eN/RgjnF6NEY8MPsHY2ATWJL18OA1VxcIgI6Eu0tWiA1DALdDBKHHi6FKxG
	WMBXov/yDkYQm0VAVeLIoc1gG3gFLCVOrW1nh7AFJX5MvscCYjMLaEms33mcCcKWl9i85i3U
	RQoSO86+BpsjIqAn0dF3kB2iRkRi34t3YMdJCOxjl3j5aCkTxDIBiW+TD7GAHCchICux6QDU
	HEmJgytusExgFJuFZPUsJKtnIVk9C8mKBYwsqxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzFC
	Iq53B+PtA9aHGJOB1k9klhJNzgdGbF5JvKGxmZGFqYmpsZG5pRlpwkrivGot1oFCAumJJanZ
	qakFqUXxRaU5qcWHGJk4OKUaGH3+POgI2T35mdWE3qinOXFqs/M5def4+LMGCLHOuH5SLVdv
	tmPywxK5yTujfMJmFH18eKjmuNLhzwJXsk6qqj27a8oj895vQ0el7cKTcTN3fJ9r6yCeuO6f
	EYP2Ti77ypBJskX+PcLuF6w85CPuaUr+v/3U3ehW7+0fn9tfvVbsijn59nHGeSWW4oxEQy3m
	ouJEAGnQQyTOAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jAd2DdnWBBmdPyFrMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFrRkvWB1YPa5tFvM4MeM3i0ffllWMHp83yQWwRDUw2mSkJqakFimk5iXn
	p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA7VVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYxZkx484i94DNvxYxHz1kaGC9ydzFyckgImEhMf/yNHcIW
	k7hwbz1bFyMXh5DAIkaJ7R//M0I4vxglGht+sIJUsQmoSXz5chiog4NDREBfoq1FA6SGWaCD
	UeLA06VgNcICvhL9l3cwgtgsAqoSRw5tZgaxeQUsJU6tbWeHsAUlfky+xwJiMwtoSazfeZwJ
	wpaX2LzmLTPERQoSO86+BpsjIqAn0dF3kB2iRkRi34t3jBMYBWYhGTULyahZSEbNQtKygJFl
	FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwPD+T3sG4qsHiEKMAB6MSD2/A5tpAIdbEsuLK
	3EOMEhzMSiK8KyzrAoV4UxIrq1KL8uOLSnNSiw8xJgN9OpFZSjQ5H5hq8kriDY1NzIwsjcws
	jEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBsfTivLrqOUctZS51Lck6sqXD/taj
	X7FH6tm42W6Z/HklLWrvN+NSGhfX6b0vztsuv8uczT/j1a+P70SmnvnLwe3Ytbxx/oL8ppWm
	X1gf7N/vrC8w+ZILo4KGrsMq4zKj+EC18+WdziJHO9STnrWs5BffaL5q8oMXxjZPvvPZec+8
	dFnD/VbFTiWW4oxEQy3mouJEAFuBTHUrAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap_nocache() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/bcm63xx_wdt.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/watchdog/bcm63xx_wdt.c b/drivers/watchdog/bcm63xx_wdt.c
index b2b80d4..a14a58d 100644
--- a/drivers/watchdog/bcm63xx_wdt.c
+++ b/drivers/watchdog/bcm63xx_wdt.c
@@ -16,6 +16,7 @@
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
@@ -249,7 +250,8 @@ static int bcm63xx_wdt_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	bcm63xx_wdt_device.regs = ioremap_nocache(r->start, resource_size(r));
+	bcm63xx_wdt_device.regs = devm_ioremap_nocache(&pdev->dev, r->start,
+							resource_size(r));
 	if (!bcm63xx_wdt_device.regs) {
 		dev_err(&pdev->dev, "failed to remap I/O resources\n");
 		return -ENXIO;
@@ -258,7 +260,7 @@ static int bcm63xx_wdt_probe(struct platform_device *pdev)
 	ret = bcm63xx_timer_register(TIMER_WDT_ID, bcm63xx_wdt_isr, NULL);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to register wdt timer isr\n");
-		goto unmap;
+		return ret;
 	}
 
 	if (bcm63xx_wdt_settimeout(wdt_time)) {
@@ -281,8 +283,6 @@ static int bcm63xx_wdt_probe(struct platform_device *pdev)
 
 unregister_timer:
 	bcm63xx_timer_unregister(TIMER_WDT_ID);
-unmap:
-	iounmap(bcm63xx_wdt_device.regs);
 	return ret;
 }
 
@@ -293,7 +293,6 @@ static int bcm63xx_wdt_remove(struct platform_device *pdev)
 
 	misc_deregister(&bcm63xx_wdt_miscdev);
 	bcm63xx_timer_unregister(TIMER_WDT_ID);
-	iounmap(bcm63xx_wdt_device.regs);
 	return 0;
 }
 
-- 
1.7.2.5


