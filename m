Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab3CKGgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 02:36:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41108 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab3CKGgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 02:36:20 -0400
X-AuditID: cbfee68e-b7f946d000001e37-f2-513d7b6380bc
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
In-reply-to: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
Subject: [PATCH 14/14] power: wm831x_backup: use devm_kzalloc()
Date: Mon, 11 Mar 2013 15:36:19 +0900
Message-id: <007e01ce1e22$bd376a90$37a63fb0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4eIfOI6J7YtEddQ/Gjh19YaZUzVAAAL3pQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zfd3kattAgycnJSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGi9YD7AVXuCqmT25gbGD8xNHFyMkhIWAi8f3NbFYIW0ziwr31
	bCC2kMAyRonJE/1gajb2ngaq4QKKL2KUmL/mFTOEM5tJ4t6O18wgVWwCahJfvhxmB7FFBDQk
	2lZPYQGxmQXyJQ4fuswCMdVWYvfPF4wgNqeAncSNZZfAtgkL2Ev8/38QbA6LgKrE5M9vwC7i
	Baq/+WcyE4QtKPFj8j2omVoSm7c1sULY8hKb17wF6uUAulRd4tFfXYgTjCR+Pp0GVSIise/F
	O0aQmyUE5rFLPJx9gBVil4DEt8mHWCB6ZSU2HWCGeFhS4uCKGywTGCVmIdk8C8nmWUg2z0Ky
	YgEjyypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MkMjq28F484D1IcZkoPUTmaVEk/OBkZlX
	Em9obGZkYWpiamxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsbCxLdy
	qSrdnSsSpSVa+vKUyh7yNC90i/xgeUH7UPDrSTXpipmZn9lzhKfPjf128mH+9QapyhnH44Vm
	/GvPCptg+Vve293+oUyu0eKGFqukprkm9/fF+XzmP/LxUM3m90qy/48cD9235uqiOttNwkoz
	1zssaO75maXjI5rz8MPkyUq5/zRW71JiKc5INNRiLipOBAClezo1wgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgG5ytW2gwbKfIhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x40XrAfaCK1wV0yc3MDYw
	fuLoYuTkkBAwkdjYe5oVwhaTuHBvPVsXIxeHkMAiRon5a14xQzizmSTu7XjNDFLFJqAm8eXL
	YXYQW0RAQ6Jt9RQWEJtZIF/i8KHLYLaQgK3E7p8vGEFsTgE7iRvLLrGB2MIC9hL//x8Em8Mi
	oCox+fMbsM28QPU3/0xmgrAFJX5Mvgc1U0ti87YmVghbXmLzmrdAvRxAl6pLPPqrC3GCkcTP
	p9OgSkQk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefn
	bmIER+4z6R2MqxosDjEKcDAq8fBO0LENFGJNLCuuzD3EKMHBrCTCu3KTTaAQb0piZVVqUX58
	UWlOavEhxmSgRycyS4km5wOTSl5JvKGxiZmRpZGZhZGJuTlpwkrivAdbrQOFBNITS1KzU1ML
	UotgtjBxcEo1MBr83rF6uabQap9u43KXiwtr5R8qJVlZ99Zv1Uny2+gpfb6WNytPvuhoa7HM
	wahtwgYZtfbJ5s92O0xeE/PTMcKXI2FyRq7O7To9d+bHGtmfUhrOPny8Zmbryfhe8wj7uTUn
	K39t25Mvmfp/2aZr0pVSU9+f/8927LjCYWbleaLtmp+PzLBMUmIpzkg01GIuKk4EAELqZh8g	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/power/wm831x_backup.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/power/wm831x_backup.c b/drivers/power/wm831x_backup.c
index d9cc169..58cbb00 100644
--- a/drivers/power/wm831x_backup.c
+++ b/drivers/power/wm831x_backup.c
@@ -169,7 +169,8 @@ static int wm831x_backup_probe(struct platform_device *pdev)
 	struct power_supply *backup;
 	int ret;
 
-	devdata = kzalloc(sizeof(struct wm831x_backup), GFP_KERNEL);
+	devdata = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_backup),
+				GFP_KERNEL);
 	if (devdata == NULL)
 		return -ENOMEM;
 
@@ -197,14 +198,8 @@ static int wm831x_backup_probe(struct platform_device *pdev)
 	backup->num_properties = ARRAY_SIZE(wm831x_backup_props);
 	backup->get_property = wm831x_backup_get_prop;
 	ret = power_supply_register(&pdev->dev, backup);
-	if (ret)
-		goto err_kmalloc;
 
 	return ret;
-
-err_kmalloc:
-	kfree(devdata);
-	return ret;
 }
 
 static int wm831x_backup_remove(struct platform_device *pdev)
@@ -213,7 +208,6 @@ static int wm831x_backup_remove(struct platform_device *pdev)
 
 	power_supply_unregister(&devdata->backup);
 	kfree(devdata->backup.name);
-	kfree(devdata);
 
 	return 0;
 }
-- 
1.7.2.5


