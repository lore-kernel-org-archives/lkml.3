Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933956AbaHZElr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 00:41:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:61526 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaHZEln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 00:41:43 -0400
X-AuditID: cbfee68d-f79c46d000000b84-02-53fc10057320
From: Chanwoo Choi <cw00.choi@samsung.com>
To: sre@kernel.org, dbaryshkov@gmail.com, dwmw2@infradead.org
Cc: myungjoo.ham@samsung.com, jonghwa3.lee@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 1/2] power: charger-manager: Fix checking of wrong return type
Date: Tue, 26 Aug 2014 13:41:38 +0900
Message-id: <1409028099-6081-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1409028099-6081-1-git-send-email-cw00.choi@samsung.com>
References: <1409028099-6081-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWyRsSkQJdV4E+wwbfTRhbXvzxntZj05D2z
	xcSVk5ktOs8+Yba4vGsOm8Xn3iOMFrcbV7BZnN5d4sDhsXPWXXaPzSu0PDat6mTz6NuyitHj
	8ya5ANYoLpuU1JzMstQifbsErozmgy/YCjZyVvTsvsDWwPiNvYuRk0NCwETiwv6DTBC2mMSF
	e+vZuhi5OIQEljJKfJ7bBVfUemcXE0RiEaPE0eMPWSCcJiaJptuf2ECq2AS0JPa/uAFmiwjY
	SvQ8PcgMUsQsMINR4s6XXlaQhLCAn8TNHesZQWwWAVWJpsufwFbwCrhIXJm+jwVinZzEhz2P
	wOKcAq4Sm99uARrKAbTNRWLRUS+QmRIC89glPs95BjVHQOLb5EMsIDUSArISmw4wQ4yRlDi4
	4gbLBEbhBYwMqxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzECw/30v2e9OxhvH7A+xCjAwajE
	w3sj/newEGtiWXFl7iFGU6ANE5mlRJPzgVGVVxJvaGxmZGFqYmpsZG5ppiTOqyj1M1hIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QD4+3Vz5t/bNE98sBjg5Bg3YNN1oYTPtQcUa/8Iiay6ExC
	c+QxEY/+K2+envZV8WjRtlKQeeIw2UnfPWfSlDRzpuzSZpVPmw2YdDTjt6YLBy9bfkX9Ks9S
	k3SJx+5bdSODyn9tO7eR0YG5MFMrp/S/yYobjSJCguEPzUL+8Dl7fDXbGfdC4yC/EktxRqKh
	FnNRcSIAuGKv7nICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t9jAV1WgT/BBnumaltc//Kc1WLSk/fM
	FhNXTma26Dz7hNni8q45bBafe48wWtxuXMFmcXp3iQOHx85Zd9k9Nq/Q8ti0qpPNo2/LKkaP
	z5vkAlijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0y
	c4BOUVIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmNB98wVawkbOiZ/cF
	tgbGb+xdjJwcEgImEq13djFB2GISF+6tZ+ti5OIQEljEKHH0+EMWCKeJSaLp9ic2kCo2AS2J
	/S9ugNkiArYSPU8PMoMUMQvMYJS486WXFSQhLOAncXPHekYQm0VAVaLp8iewdbwCLhJXpu9j
	gVgnJ/FhzyOwOKeAq8Tmt1uAhnIAbXORWHTUawIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnp
	esn5uZsYwdH0TGoH48oGi0OMAhyMSjy8N+J/BwuxJpYVV+YeYpTgYFYS4WV4CBTiTUmsrEot
	yo8vKs1JLT7EaAp01ERmKdHkfGCk55XEGxqbmBlZGpkbWhgZmyuJ8x5otQ4UEkhPLEnNTk0t
	SC2C6WPi4JRqYLQTLPe4r6tksuJlofHVi5Gb5mU8FVRfw/Kq34i3UFVrXcGyyRJOgezWztHX
	VV1sG0sauKapmDRKbt90TPaopTq7R+QMc40SV6d8pW953wUtmv41tcUaNSnrLvhfczRTctry
	zmeOL0p1hSeu9pdvTpVP/2IW/LGkItVuJX9GeCtnxMoF5gVKLMUZiYZazEXFiQA3SDYUvAIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix minor issue about checking wrong return type.

The of_cm_parse_desc() return ERR_PTR(errnor number) when some error happen
in this function. But, charger_manager_probe() has only checked whether
desc is NULL or not. If of_cm_parse_desc() returns ERR_PTR(-ENOMEM), desc
isn't NULL but desc is (void *)(-ENOMEM). Althouhg some error happen for parsing
DT, charger_manager_probe() can't detect error of desc instance.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/power/charger-manager.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 9e4dab4..a10fb57 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -1677,7 +1677,7 @@ static int charger_manager_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (!desc) {
+	if (IS_ERR(desc)) {
 		dev_err(&pdev->dev, "No platform data (desc) found\n");
 		return -ENODEV;
 	}
-- 
1.8.0

