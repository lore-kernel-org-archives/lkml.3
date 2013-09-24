Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab3IXJQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:16:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22268 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab3IXJQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:16:17 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-e6-5241585ff272
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
In-reply-to: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
Subject: [PATCH 14/22] backlight: kb3886_bl: use
 devm_backlight_device_register()
Date: Tue, 24 Sep 2013 18:16:15 +0900
Message-id: <005401ceb906$b826b590$287420b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65BQPO2UlhwYgjRvaJnkuV9ccl+gAAZmcQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zI934CMcgg8aL0hZz1q9hs7i88BKr
	xeVdc9gsdu96yurA4nFixm8Wjz3zf7B69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8brLWoF
	K3gqfjZnNDBO4Opi5OSQEDCR+LDrOSOELSZx4d56ti5GLg4hgWWMEvf/TGSHK9rygw3EFhKY
	ziixa2IARNEvRonWph/MIAk2ATWJL18OAzVwcIgI6Eu0tWiAhJkFciTuP5nFDtFrK7Huw2ww
	m1PATuLU0jNgM4UFgiXerTsNZrMIqEr0T/zICmLzAtV/uLKdDcIWlPgx+R4LxEwtic3bmlgh
	bHmJzWveMoOslRBQl3j0VxckLCJgJPG4q4sNokREYt+Ld4wgJ0sInGKXuP1pPSvELgGJb5MP
	sUD0ykpsOsAM8a6kxMEVN1gmMErMQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSelFpnrFibnF
	pXnpesn5uZsYIfE4cQfj/QPWhxiTgdZPZJYSTc4HxnNeSbyhsZmRhamJqbGRuaUZacJK4rzq
	LdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhg958z4KavJxd/cO4XROZ25asr9nl8Lbztc
	5P4p9ddDuWDX/t0KtlcreHaEBFpHxlqGGe5ynSskLfBn98RqxtLZbq4H5+qVFHEU2Lp5nLUy
	EZz6a4vexqcM+tfqVl/i+2/1dK6qT+wWhVPPdIUCztp/6jZba9tV8cv+8ub8oKqHQkn7dlx6
	LqrEUpyRaKjFXFScCADI3y8T3QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jQd34CMcggz+PxC3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaM11vUClbwVPxszmhgnMDVxcjJISFgIvFhyw82CFtM4sK99WC2
	kMB0RoldEwO6GLmA7F+MEq1NP5hBEmwCahJfvhxm72Lk4BAR0Jdoa9EACTML5EjcfzKLHaLX
	VmLdh9lgNqeAncSppWfAZgoLBEu8W3cazGYRUJXon/iRFcTmBar/cGU7G4QtKPFj8j0WiJla
	Epu3NbFC2PISm9e8ZQZZKyGgLvHory5IWETASOJxVxcbRImIxL4X7xgnMArNQjJpFpJJs5BM
	moWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Gh/Jr2DcVWDxSFGAQ5GJR7eCwkO
	QUKsiWXFlbmHGCU4mJVEeG/YOgYJ8aYkVlalFuXHF5XmpBYfYkwGenQis5Rocj4wEeWVxBsa
	m5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+N8FgVLzvOnWjuY7gX4
	hJXsfrYquXK+4Aqtg8c1bovfivu86KfazovLZ/533sGn45k5UzV3WffO88mtUkmrDFti3+bN
	l/o69x+v1kfWyIbq/xUqTf9/SRe+T7iW3sfsVft7XvYk3u05MRHePWv+euv3By7TrjY9wc96
	1P/80g4N753rX0+bEq7EUpyRaKjFXFScCABcM/IOOgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/kb3886_bl.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/video/backlight/kb3886_bl.c b/drivers/video/backlight/kb3886_bl.c
index 5bacabb..7592cc2 100644
--- a/drivers/video/backlight/kb3886_bl.c
+++ b/drivers/video/backlight/kb3886_bl.c
@@ -150,10 +150,10 @@ static int kb3886bl_probe(struct platform_device *pdev)
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = machinfo->max_intensity;
-	kb3886_backlight_device = backlight_device_register("kb3886-bl",
-							    &pdev->dev, NULL,
-							    &kb3886bl_ops,
-							    &props);
+	kb3886_backlight_device = devm_backlight_device_register(&pdev->dev,
+							"kb3886-bl", &pdev->dev,
+							NULL, &kb3886bl_ops,
+							&props);
 	if (IS_ERR(kb3886_backlight_device))
 		return PTR_ERR(kb3886_backlight_device);
 
@@ -166,18 +166,8 @@ static int kb3886bl_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int kb3886bl_remove(struct platform_device *pdev)
-{
-	struct backlight_device *bd = platform_get_drvdata(pdev);
-
-	backlight_device_unregister(bd);
-
-	return 0;
-}
-
 static struct platform_driver kb3886bl_driver = {
 	.probe		= kb3886bl_probe,
-	.remove		= kb3886bl_remove,
 	.driver		= {
 		.name	= "kb3886-bl",
 		.pm	= &kb3886bl_pm_ops,
-- 
1.7.10.4


