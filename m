Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab3BOF7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 00:59:35 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:25850 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3BOF7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 00:59:34 -0500
X-AuditID: cbfee68f-b7f656d000000d78-cb-511dcec57127
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001201ce0b41$4900c4d0$db024e70$%han@samsung.com>
In-reply-to: <001201ce0b41$4900c4d0$db024e70$%han@samsung.com>
Subject: [PATCH 04/11] rtc: rtc-ds2404: use dev_err() instead of printk()
Date: Fri, 15 Feb 2013 14:59:32 +0900
Message-id: <001501ce0b41$a0368370$e0a38a50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LQUiQnZ5yIGDDRaO8BQe4Zm4AfgAADxZA
Content-language: ko
x-cr-hashedpuzzle: F7KT J3dp RCkr SojQ fTw/ f31h gDWi hOgX hdZ0 iVXF ooxc pN0U
 prw3 sq98 t7fk
 uNtb;5;YQAuAHoAdQBtAG0AbwBAAHQAbwB3AGUAcgB0AGUAYwBoAC4AaQB0ADsAYQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcgB0AGMALQBsAGkAbgB1AHgAQABnAG8AbwBnAGwAZQBnAHIAbwB1AHAAcwAuAGMAbwBtAA==;Sosha1_v1;7;{13DF5FAD-4F7D-4F81-8E2E-050855A443A7};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Fri,
 15 Feb 2013 05:59:25
 GMT;WwBQAEEAVABDAEgAIAAwADQALwAxADEAXQAgAHIAdABjADoAIAByAHQAYwAtAGQAcwAyADQAMAA0ADoAIAB1AHMAZQAgAGQAZQB2AF8AZQByAHIAKAApACAAaQBuAHMAdABlAGEAZAAgAG8AZgAgAHAAcgBpAG4AdABrACgAKQA=
x-cr-puzzleid: {13DF5FAD-4F7D-4F81-8E2E-050855A443A7}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t8zA92j52QDDe5N4bW4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZa77IFPzhqFj0rIWtgXE2excjJ4eEgInEq8V3WCFsMYkL99az
	dTFycQgJLGOUmPqsgxmm6Mat2ywQiemMEls/nmeEcGYzSdx49IQJpIpNQE3iy5fDQGM5OEQE
	9CXaWjRAapgFehklzvTuBlsnJGArMeHTOrCpnAJ2Et//PGQDsYUFPCWO7nvMCNLLIqAq0fIQ
	rIQXqPz9815WCFtQ4sfkeywgNrOAlsTmbU2sELa8xOY1b5lBWiUE1CUe/dWFuMBI4uw1NogK
	EYl9L96BXSwh8IJVYvqTD0wQf5lK3Nkwgx0isYtdYt+6NrAOFgEBiW+TD7FAzJSV2HQAGg6S
	EgdX3GCZwCg1C8lFs5BcNAvJRbOQ7F7AyLKKUTS1ILmgOCm9yFivODG3uDQvXS85P3cTIyQO
	+3cw3j1gfYgxGWj9RGYp0eR8YBznlcQbGhubmJmYmphbmpqbkiasJM4rf0kmUEggPbEkNTs1
	tSC1KL6oNCe1+BAjEwenVAOjxrw5HOcki1rcd9SuuxbNk/baq/3Y9eJQ2ykzNB497lU2t3be
	l3Hp0BaLtwqyf9mf7OUw43WQcE3QD2j9M5/VK814WqpknOXjxWr6i95JvD+blOHO0uUt9tZg
	SlBKvuKDy1GxZW+WbEvhvhyifOq7Es88T4WbB4Jn6EW1lsx85LWEpZ317R8lluKMREMt5qLi
	RABSyXGB2QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jQd2j52QDDW70sVtc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjDVfZAr+cFQsetbC1sA4
	m72LkZNDQsBE4sat2ywQtpjEhXvr2boYuTiEBKYzSmz9eJ4RwpnNJHHj0RMmkCo2ATWJL18O
	A3VzcIgI6Eu0tWiA1DAL9DJKnOndDTZVSMBWYsKndcwgNqeAncT3Pw/ZQGxhAU+Jo/seM4L0
	sgioSrQ8BCvhBSp//7yXFcIWlPgx+R7YQcwCWhKbtzWxQtjyEpvXvGUGaZUQUJd49FcX4gIj
	ibPX2CAqRCT2vXgHdrGEwAtWielPPjBB/GUqcWfDDPYJjCKzkGyYhWTDLCQbZiGZtYCRZRWj
	aGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcJQ/k9rBuLLB4hCjAAejEg+vgIRsoBBrYllxZe4h
	RgkOZiUR3jUhQCHelMTKqtSi/Pii0pzU4kOMyUD/T2SWEk3OByagvJJ4Q2MTMyNLIzMLIxNz
	c9KElcR5GU89CRASSE8sSc1OTS1ILYLZwsTBKdXAOL9o+XyuFxo3upX1ruU7qD0r6t7aPenF
	/eaUqsXqdfv0emOO6B3gmuF1QpB36aywlR/WsAtJVm2wru6tLgtd1Rq4uob7S4Lqk7giNdX8
	v/7L69apXTieea1i1TEV3hr2DcwLfWpjWGw/BaxtWDNxQ3V3+Xo+7o0PPW3d1py9cvnM1IPd
	T/8xKLEUZyQaajEXFScCAFU4cBY2AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warning as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-ds2404.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-ds2404.c b/drivers/rtc/rtc-ds2404.c
index 4539e37..b04fc42 100644
--- a/drivers/rtc/rtc-ds2404.c
+++ b/drivers/rtc/rtc-ds2404.c
@@ -70,7 +70,7 @@ static int ds2404_gpio_map(struct ds2404 *chip, struct platform_device *pdev,
 	for (i = 0; i < ARRAY_SIZE(ds2404_gpio); i++) {
 		err = gpio_request(ds2404_gpio[i].gpio, ds2404_gpio[i].name);
 		if (err) {
-			printk(KERN_ERR "error mapping gpio %s: %d\n",
+			dev_err(&pdev->dev, "error mapping gpio %s: %d\n",
 				ds2404_gpio[i].name, err);
 			goto err_request;
 		}
@@ -177,7 +177,7 @@ static void ds2404_write_memory(struct device *dev, u16 offset,
 
 	for (i = 0; i < length; i++) {
 		if (out[i] != ds2404_read_byte(dev)) {
-			printk(KERN_ERR "read invalid data\n");
+			dev_err(dev, "read invalid data\n");
 			return;
 		}
 	}
-- 
1.7.2.5


