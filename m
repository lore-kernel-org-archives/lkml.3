Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbaH0BKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:10:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65027 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579AbaH0BKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:10:40 -0400
X-AuditID: cbfee68e-f79536d000000fd1-80-53fd300bd315
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
In-reply-to: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
Subject: [PATCH V2 04/18] backlight: ams369fg06: remove 'else' after a return
Date: Wed, 27 Aug 2014 10:10:34 +0900
Message-id: <004801cfc193$b449ea50$1cddbef0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/Bk2mhX0elbPeNSwiBLjt5Esz7eAAAD4YA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zQ11ug7/BBocXsFoc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBmre2ax
	Fqxkr/hwYDFjA2MvWxcjJ4eEgInE7ieTGCFsMYkL99aDxYUEljFKbHihBVPz+OYCqPgiRom1
	l/i6GLmA7N+MEt97P4El2ATUJL58OcwOYosIKEhs7n3GCmIzC+RK/J65khGi2Vbi8sK1TCA2
	p4CdxOwP08HqhQV8JT5/OgBWwyKgKnF3/kmwGl6g+u3nutkhbEGJH5PvsUDM1JJYv/M4E4Qt
	L7F5zVvmLkYOoEPVJR791YU4wUhi4oIrzBAlIhL7XrxjBLlZQuAYu8Tl/oVQuwQkvk0+xALR
	Kyux6QAzxL+SEgdX3GCZwCgxC8nmWUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6UXGekVJ+YWl+al
	6yXn525ihMRk3w7GmwesDzEKcDAq8fB+WPAnWIg1say4MvcQoynQRROZpUST84GRn1cSb2hs
	ZmRhamJqbGRuaaYkzpsg9TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+PGH1xpk0TdPD96
	Sjn9+FoXc39F1pq0JqXGa+sXpcQ7xOknlNzhe3479emVxOUSrJMk5Epncj2/sHizl+kKNtfk
	nVoLj9ce7P7S31myLsNigUhmwIm5mU02/8/uD4++cNfNYOdhkViFyc6PUmY9Knwqflk33vZS
	kfYcBfmK52qMcm8EDvgtklNiKc5INNRiLipOBAD8SyIkxAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jAV1ug7/BBouuMFoc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZq3tmsRasZK/4cGAxYwNjL1sXIyeHhICJxOObC6BsMYkL99aD
	2UICixgl1l7i62LkArJ/M0p87/0ElmATUJP48uUwO4gtIqAgsbn3GSuIzSyQK/F75kpGiGZb
	icsL1zKB2JwCdhKzP0wHqxcW8JX4/OkAWA2LgKrE3fknwWp4geq3n+tmh7AFJX5MvscCMVNL
	Yv3O40wQtrzE5jVvmbsYOYAOVZd49FcX4gQjiYkLrjBDlIhI7HvxjnECo9AsJJNmIZk0C8mk
	WUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjvlnUjsYVzZYHGIU4GBU4uH9uOBP
	sBBrYllxZe4hRgkOZiUR3mSFv8FCvCmJlVWpRfnxRaU5qcWHGE2BHp3ILCWanA9MR3kl8YbG
	JmZGlkZmFkYm5uZK4rwHWq0DhQTSE0tSs1NTC1KLYPqYODilGhhlJiz/zJPvK/pOZ53sH32l
	lnmWhfffBf58EaH4LHWay7lbNs9PPpzu9C9Q3u3+5APV/66cPOIkYHFd6srTnlslBy0ko3+v
	bGl4Gno167bnW2HO5Tfr7M9wPEh45bOrNX5K2I1fiw0l5fxPbe0r03jZ9SHvZ5bI9+bH8c2q
	xco/5107/GK7/a5vSizFGYmGWsxFxYkAG+bc6w8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following checkpatch warning.

  WARNING: else is not generally useful after a break or return

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/video/backlight/ams369fg06.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
index 4726c8be626f..5f897f99cc9b 100644
--- a/drivers/video/backlight/ams369fg06.c
+++ b/drivers/video/backlight/ams369fg06.c
@@ -325,11 +325,11 @@ static int ams369fg06_power_on(struct ams369fg06 *lcd)
 	if (!pd->reset) {
 		dev_err(lcd->dev, "reset is NULL.\n");
 		return -EINVAL;
-	} else {
-		pd->reset(lcd->ld);
-		msleep(pd->reset_delay);
 	}
 
+	pd->reset(lcd->ld);
+	msleep(pd->reset_delay);
+
 	ret = ams369fg06_ldi_init(lcd);
 	if (ret) {
 		dev_err(lcd->dev, "failed to initialize ldi.\n");
-- 
2.0.0


