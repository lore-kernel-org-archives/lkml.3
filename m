Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab3CKGcD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 02:32:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59739 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab3CKGcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 02:32:00 -0400
X-AuditID: cbfee68e-b7f946d000001e37-e2-513d7a5fef27
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
In-reply-to: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
Subject: [PATCH 03/14] power: da9030_battery: use devm_kzalloc()
Date: Mon, 11 Mar 2013 15:31:59 +0900
Message-id: <007301ce1e22$224b13b0$66e13b10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4eIfOI6J7YtEddQ/Gjh19YaZUzVAAAB9wQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zI934KttAgx93ZSwObtW0mLhyMrPF
	5YWXWC0u75rD5sDiMaH/E6PH5hVaHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJWxY+4MloJN
	HBU3ppU1MH5h62Lk5JAQMJHof7+fEcIWk7hwbz1QnItDSGAZo8TC6b3sXYwcYEXft9lBxKcz
	Ssy4s5YVwvnFKNG94iorSDebgJrEly+H2UFsEQENibbVU1hAbGaBfInDhy6D2UICthK7f74A
	28YpYCdxY9klsCuEBRwkNp45CBZnEVCVuLF0IdgcXqD6afPPsEDYghI/Jt+DmqklsXlbEyuE
	LS+xec1bZohD1SUe/dWFOMFI4vrJW8wQJSIS+168YwS5WULgGLvEs38voHYJSHybfIgFoldW
	YtMBZkhASEocXHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSkV5yYW1yal66X
	nJ+7iRESj307GG8esD7EmAy0fiKzlGhyPjCe80riDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQS
	SE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAWMDQW2nSHnlybubmtx3JbtUf06fe5p4pp/TM+atd
	667q+DdHFcUthS+c8nmQWauwMff3x7ykdxqJMz4ddHj5werx9MlmUf0r1COEFCssrrWaS8jb
	G03marj1k7vsvnlgfj63qffb5Jj9xpO4YhUcN/stO6dyn8NCnUX6pFjWfXnbz3rfI64psRRn
	JBpqMRcVJwIAIJbvnN0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jQd34KttAg5Y3EhYHt2paTFw5mdni
	8sJLrBaXd81hc2DxmND/idFj8wotj74tqxg9Pm+SC2CJamC0yUhNTEktUkjNS85PycxLt1Xy
	Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaqKRQlphTChQKSCwuVtK3wzQhNMRN1wKm
	MULXNyQIrsfIAA0krGPM2DF3BkvBJo6KG9PKGhi/sHUxcnBICJhIfN9m18XICWSKSVy4tx4o
	zMUhJDCdUWLGnbWsEM4vRonuFVdZQarYBNQkvnw5zA5iiwhoSLStnsICYjML5EscPnQZzBYS
	sJXY/fMFI4jNKWAncWPZJTYQW1jAQWLjmYNgcRYBVYkbSxeCzeEFqp82/wwLhC0o8WPyPaiZ
	WhKbtzWxQtjyEpvXvGWGOFpd4tFfXYgTjCSun7zFDFEiIrHvxTvGCYxCs5BMmoVk0iwkk2Yh
	aVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzjan0nvYFzVYHGIUYCDUYmHd4KObaAQ
	a2JZcWXuIUYJDmYlEd6Vm2wChXhTEiurUovy44tKc1KLDzEmAz06kVlKNDkfmIjySuINjU3M
	jCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoFRY3vkuqpgZo4lxzzfrTdi
	9TjossH98L86ptjdleukVfc1NpQK/e7IOv7cKZCXyYjpRkNarfbXZW5u/2wv8a3ZKrV0I5fv
	t6sPr6x4Uh9W/kAnqbns06TN7kyzuCezpdv5fKl1//PvQN6cl/EdG/+Ivn5vud0j6aWl6dtF
	TO7PV/tMudresDZFiaU4I9FQi7moOBEAuYUnNjoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/power/da9030_battery.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/power/da9030_battery.c b/drivers/power/da9030_battery.c
index e8c5a39..ae6c418 100644
--- a/drivers/power/da9030_battery.c
+++ b/drivers/power/da9030_battery.c
@@ -505,7 +505,7 @@ static int da9030_battery_probe(struct platform_device *pdev)
 	    pdata->charge_millivolt > 4350)
 		return -EINVAL;
 
-	charger = kzalloc(sizeof(*charger), GFP_KERNEL);
+	charger = devm_kzalloc(&pdev->dev, sizeof(*charger), GFP_KERNEL);
 	if (charger == NULL)
 		return -ENOMEM;
 
@@ -557,8 +557,6 @@ err_notifier:
 	cancel_delayed_work(&charger->work);
 
 err_charger_init:
-	kfree(charger);
-
 	return ret;
 }
 
@@ -575,8 +573,6 @@ static int da9030_battery_remove(struct platform_device *dev)
 	da9030_set_charge(charger, 0);
 	power_supply_unregister(&charger->psy);
 
-	kfree(charger);
-
 	return 0;
 }
 
-- 
1.7.2.5


