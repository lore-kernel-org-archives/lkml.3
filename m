Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3IXJO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:14:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22035 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab3IXJO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:14:57 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-3f-524158104143
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
In-reply-to: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
Subject: [PATCH 12/22] backlight: generic_bl: use
 devm_backlight_device_register()
Date: Tue, 24 Sep 2013 18:14:55 +0900
Message-id: <005201ceb906$88f0fc40$9ad2f4c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65BQPO2UlhwYgjRvaJnkuV9ccl+gAAXGHA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zQ12BCMcgg8cXWS3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsEroyJc48w
	FizmrPh7hruB8RV7FyMnh4SAicTvm5eZIGwxiQv31rN1MXJxCAksY5TobtnJClO0/WErK0Ri
	EaPEhqUnGSGcX4wS8249ZASpYhNQk/jy5TDQWA4OEQF9ibYWDZAws0COxP0ns8C2CQnYSqz7
	MBvM5hSwkzi19AwbiC0sECJxZvEcZhCbRUBV4uPpDWA1vED12/fMZIKwBSV+TL7HAjFTS2Lz
	tiZWCFteYvOat8wgayUE1CUe/dUFCYsIGElsOLuSEaJERGLfi3dgJ0sInGOX+HnsEiPELgGJ
	b5MPsUD0ykpsOsAM8a+kxMEVN1gmMErMQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSelFpnrF
	ibnFpXnpesn5uZsYITE5cQfj/QPWhxiTgdZPZJYSTc4HxnReSbyhsZmRhamJqbGRuaUZacJK
	4rzqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhjtvr6XYb1374map8SutsquD6LB01Pa
	tksuZ+/16VoYfHbNreV7zddvPLb7RtGZpQ0PztXfs2/9/6pS4xfTkyvTRDefOS29jjUsUU8r
	PNp/mo7X9mdaIvHx155Eim+RZfza63hBNthyaqOU3XoRwfgK144njF+M7jp8uTMp0GxfDFeJ
	yKO7U/yUWIozEg21mIuKEwFjs0yF3wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAV2BCMcgg/mvGC3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMiXOPMBYs5qz4e4a7gfEVexcjJ4eEgInE9oetrBC2mMSFe+vZ
	uhi5OIQEFjFKbFh6khHC+cUoMe/WQ0aQKjYBNYkvXw4DdXNwiAjoS7S1aICEmQVyJO4/mQU2
	VEjAVmLdh9lgNqeAncSppWfYQGxhgRCJM4vnMIPYLAKqEh9PbwCr4QWq375nJhOELSjxY/I9
	FoiZWhKbtzWxQtjyEpvXvGUGWSshoC7x6K8uSFhEwEhiw9mVjBAlIhL7XrxjnMAoNAvJpFlI
	Js1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYIj/pn0DsZVDRaHGAU4GJV4
	eC8kOAQJsSaWFVfmHmKU4GBWEuG9YesYJMSbklhZlVqUH19UmpNafIgxGejRicxSosn5wGSU
	VxJvaGxiZmRpZGZhZGJuTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2Msw57/9TOe7Xd
	9tCPjAm53POWd7T1fI0P/B7t8Oih/+YnXIra+yvf7u+xPP+r5jrfdjH9JQ1+X475GrRtvcU1
	/7vjriOellk32y+tWXClYtGMiZoJm6ZxHFKReHzm+YbrFxXNPLgaLC72/Xg1i/nauUe+vNOy
	Jqo1q0jHyyoCE/6kjdndP+xnK7EUZyQaajEXFScCAIc/OJg8AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/generic_bl.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/generic_bl.c b/drivers/video/backlight/generic_bl.c
index 48fa914..5d8d652 100644
--- a/drivers/video/backlight/generic_bl.c
+++ b/drivers/video/backlight/generic_bl.c
@@ -93,8 +93,8 @@ static int genericbl_probe(struct platform_device *pdev)
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = machinfo->max_intensity;
-	bd = backlight_device_register(name, &pdev->dev, NULL, &genericbl_ops,
-				       &props);
+	bd = devm_backlight_device_register(&pdev->dev, name, &pdev->dev,
+					NULL, &genericbl_ops, &props);
 	if (IS_ERR(bd))
 		return PTR_ERR(bd);
 
@@ -118,8 +118,6 @@ static int genericbl_remove(struct platform_device *pdev)
 	bd->props.brightness = 0;
 	backlight_update_status(bd);
 
-	backlight_device_unregister(bd);
-
 	dev_info(&pdev->dev, "Generic Backlight Driver Unloaded\n");
 	return 0;
 }
-- 
1.7.10.4


