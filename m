Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab3LAXzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 18:55:48 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:27680 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab3LAXzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 18:55:45 -0500
X-AuditID: cbfee68f-b7f336d00000481b-7c-529bcc7f37d2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/8] backlight: jornada720: use devm_backlight_device_register()
Date: Mon, 02 Dec 2013 08:55:43 +0900
Message-id: <000001ceeef0$d88a7f40$899f7dc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7u8NgcVnqPK6OFQjq+Xy+HsAignw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t8zA936M7ODDNZMlrOYs34Nm8XlhZdY
	LS7vmsPmwOxxYsZvFo++LasYPT5vkgtgjuKySUnNySxLLdK3S+DKOLD5InPBT+6KV3OfsDUw
	/uHsYuTkkBAwkTj+9xkbhC0mceHeeiCbi0NIYBmjxM0tbUwwRSvnbmaFSExnlOg/+Y4RwvnF
	KPGnbwkjSBWbgJrEly+H2bsYOThEBPQl2lo0QExmAReJo9NEQCqEBQIkdkw5B7aMRUBVYt/0
	V+wgNq+ArcSGqV8ZIWxBiR+T77GA2MwCWhLrdx5ngrDlJTavecsMMlJCQF3i0V9diEV6Eo9O
	BUFUiEjsewFxmITAKnaJb8/7oFYJSHybfIgFolVWYtMBZoivJCUOrrjBMoFRbBaSxbOQLJ6F
	ZPEsJCsWMLKsYhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAiJpv4djHcPWB9iTAZaP5FZSjQ5
	HxiNeSXxhsZmRhamJqbGRuaWZqQJK4nz3n+YFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB
	Md7bbD3HyqeXzs9+eKL0UEW2kJLLN7tqydudq2btCJh74fmt1z3LbupEPJjHYfyTJ/V8SPJJ
	tovhV/vELNbsPZz37L3WZL3eT6wxfN2PxLd8vFDy1W3NlgXeGlJSXoFz389MzlhhY8yl+Xf2
	6zJT9e3cUzNOtRn9ufzT/dL89SwfOW+/8Uv0KVZiKc5INNRiLipOBABOUCfFvAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+xoG79mdlBBl/XSVnMWb+GzeLywkus
	Fpd3zWFzYPY4MeM3i0ffllWMHp83yQUwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdj
	ZIAGEtYxZhzYfJG54Cd3xau5T9gaGP9wdjFyckgImEisnLuZFcIWk7hwbz1bFyMXh5DAdEaJ
	/pPvGCGcX4wSf/qWMIJUsQmoSXz5cpi9i5GDQ0RAX6KtRQPEZBZwkTg6TQSkQlggQGLHlHNs
	IDaLgKrEvumv2EFsXgFbiQ1TvzJC2IISPybfYwGxmQW0JNbvPM4EYctLbF7zlhlkpISAusSj
	v7oQi/QkHp0KgqgQkdj34h3jBEaBWUgGzUIyaBaSQbOQtCxgZFnFKJpakFxQnJSea6hXnJhb
	XJqXrpecn7uJERyrz6R2MK5ssDjEKMDBqMTDW3FsdpAQa2JZcWXuIUYJDmYlEV6Lr7OChHhT
	EiurUovy44tKc1KLDzEmA/05kVlKNDkfmEbySuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQ
	nliSmp2aWpBaBLOFiYNTqoFx8sTXV1N1PJVen/9U8UU2eqrMxmNBuVvddzSElfCFmdxOynim
	9Pzl7GKbqxvydhlPn9IupVVZd9CS9U+01pUA+ZdvRaWe+v2fEL6M2/v9vTUGmv9ltYxkdIPn
	WC60O+F7i+ObVFP5R6PZW569XfBf/c/deb1dRXN4lHTtrfgXBjssObbkU8JVJZbijERDLeai
	4kQAttr9bxkDAAA=
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
 drivers/video/backlight/jornada720_bl.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/video/backlight/jornada720_bl.c b/drivers/video/backlight/jornada720_bl.c
index 3ccb893..6ce96b4 100644
--- a/drivers/video/backlight/jornada720_bl.c
+++ b/drivers/video/backlight/jornada720_bl.c
@@ -115,9 +115,10 @@ static int jornada_bl_probe(struct platform_device *pdev)
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = BL_MAX_BRIGHT;
-	bd = backlight_device_register(S1D_DEVICENAME, &pdev->dev, NULL,
-				       &jornada_bl_ops, &props);
 
+	bd = devm_backlight_device_register(&pdev->dev, S1D_DEVICENAME,
+					&pdev->dev, NULL, &jornada_bl_ops,
+					&props);
 	if (IS_ERR(bd)) {
 		ret = PTR_ERR(bd);
 		dev_err(&pdev->dev, "failed to register device, err=%x\n", ret);
@@ -139,18 +140,8 @@ static int jornada_bl_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int jornada_bl_remove(struct platform_device *pdev)
-{
-	struct backlight_device *bd = platform_get_drvdata(pdev);
-
-	backlight_device_unregister(bd);
-
-	return 0;
-}
-
 static struct platform_driver jornada_bl_driver = {
 	.probe		= jornada_bl_probe,
-	.remove		= jornada_bl_remove,
 	.driver	= {
 		.name	= "jornada_bl",
 	},
-- 
1.7.10.4


