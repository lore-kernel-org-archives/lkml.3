Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191Ab3CEEsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 23:48:31 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:30681 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462Ab3CEEsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 23:48:30 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-33-5135791dcd9b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <006301ce195c$7dee06c0$79ca1440$%han@samsung.com>
In-reply-to: <006301ce195c$7dee06c0$79ca1440$%han@samsung.com>
Subject: [PATCH 3/3] mfd: davinci_voicecodec: use module_platform_driver_probe()
Date: Tue, 05 Mar 2013 13:48:28 +0900
Message-id: <006501ce195c$ae106a00$0a313e00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ZXH0Yw9kuA009QHe2/LULknNrfgAACCsg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t8zY13ZStNAg84TTBaXF15itbi8aw6b
	xeluVgdmj3knAz36tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr4+5ZrYJlHBVfdz1mamCcxd7F
	yMkhIWAi0XZqKwuELSZx4d56NhBbSGAZo8T1WYwwNR+P9wLFuYDi0xklls1YzQrh/GKUaPsy
	gwmkik1ATeLLl8NgU0UEtCS6j50H6uDgYBZwkTg6TQRiqK3E1t/PwEo4Bewkrr49AFYiLBAg
	sfdPEYjJIqAqcfFxDEgFL1D1/80H2CFsQYkfk++BnckMNHzztiZWCFteYvOat8wgrRIC6hKP
	/upC7DeSeDqrnRGiRERi34t3jCAHSwjsYpd4/78PrJdFQEDi2+RDLBC9shKbDjBDfCspcXDF
	DZYJjBKzkGyehWTzLCSbZyFZsYCRZRWjaGpBckFxUnqRqV5xYm5xaV66XnJ+7iZGSNRN3MF4
	/4D1IcZkoPUTmaVEk/OBUZtXEm9obGxiZmJqYm5pam5KmrCSOK/8JZlAIYH0xJLU7NTUgtSi
	+KLSnNTiQ4xMHJxSDYxZR+/frk3xeXxjyuQJq17N8Q1MdLSbdlmr98hLT9d+WeVbD/QPqGc7
	+llYHNCrTi987b/JJtiqdX9kR/FC+XuF5dG+nGtviltvXD37y+vy8HURJ8MKJ97lNVaRycyt
	PD+h74bonXYGBY/P3+w1JXg1+SJ6djKtsl8xOep5wv0VCxqiniTtOabEUpyRaKjFXFScCACx
	TUiM0AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQV2ZStNAg0PnrS0uL7zEanF51xw2
	i9PdrA7MHvNOBnr0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6h
	pYW5kkJeYm6qrZKLT4CuW2YO0B4lhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZo
	IGEdY8bds1oFyzgqvu56zNTAOIu9i5GTQ0LAROLj8V42CFtM4sK99UA2F4eQwHRGiWUzVrNC
	OL8YJdq+zGACqWITUJP48uUwWLeIgJZE97HzQB0cHMwCLhJHp4mAhIUEbCW2/n4GVsIpYCdx
	9e0BsBJhgQCJvX+KQEwWAVWJi49jQCp4gar/bz7ADmELSvyYfI8FxGYGGr55WxMrhC0vsXnN
	W2aQVgkBdYlHf3Uh9htJPJ3VzghRIiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5
	oDgpPddQrzgxt7g0L10vOT93EyM4qp9J7WBc2WBxiFGAg1GJh5fhqEmgEGtiWXFl7iFGCQ5m
	JRHe+7ymgUK8KYmVValF+fFFpTmpxYcYk4H+nMgsJZqcD0w4eSXxhsYmZkaWRmYWRibm5qQJ
	K4nzMp56EiAkkJ5YkpqdmlqQWgSzhYmDU6qBkY/lct2ZsiVBPc/+TDOs1GhmtviW906R+eyG
	tw9tr+tryG+5dXnhk1eSTy5eXNQ3hytR8cI6/VknK2ds45d3L7laYtf92uRQ8B8D7smGxj/j
	p3laGc2aJpL6vDnc0dj79rUD8avFIjxvLL1qoXFt8fmHXY8Fz6828gpTjJkwNWCfntv9eVvP
	NSixFGckGmoxFxUnAgAY+5EvLgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses module_platform_driver_probe() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/davinci_voicecodec.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/davinci_voicecodec.c b/drivers/mfd/davinci_voicecodec.c
index c0bcc87..c60ab0c 100644
--- a/drivers/mfd/davinci_voicecodec.c
+++ b/drivers/mfd/davinci_voicecodec.c
@@ -177,17 +177,7 @@ static struct platform_driver davinci_vc_driver = {
 	.remove	= davinci_vc_remove,
 };
 
-static int __init davinci_vc_init(void)
-{
-	return platform_driver_probe(&davinci_vc_driver, davinci_vc_probe);
-}
-module_init(davinci_vc_init);
-
-static void __exit davinci_vc_exit(void)
-{
-	platform_driver_unregister(&davinci_vc_driver);
-}
-module_exit(davinci_vc_exit);
+module_platform_driver_probe(davinci_vc_driver, davinci_vc_probe);
 
 MODULE_AUTHOR("Miguel Aguilar");
 MODULE_DESCRIPTION("Texas Instruments DaVinci Voice Codec Core Interface");
-- 
1.7.2.5


