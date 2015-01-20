Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbbATKFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:05:46 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32488 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbbATKFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:05:09 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-bc-54be28485e24
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-api@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 5/5] MAINTAINERS: Add entry for Maxim chargers on Samsung
 boards
Date: Tue, 20 Jan 2015 11:00:56 +0100
Message-id: <1421748056-25735-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1421748056-25735-1-git-send-email-k.kozlowski@samsung.com>
References: <1421748056-25735-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsVy+t/xa7oeGvtCDOadkrXYOGM9q8WkJ++Z
	LeYfOcdqMXHlZGaL1y8MLc42vWG3uP/1KKPF5u8dbBaXd81hs/jce4TR4nQ3q8Xp3SUOPB47
	Z91l99i8Qstj06pONo871/awecw7GejRt2UVo8fnTXIB7FFcNimpOZllqUX6dglcGSv2OxRc
	4qjoWL+StYFxA3sXIyeHhICJxMqZq9ggbDGJC/fWA9lcHEICSxklbsw7zw7h9DFJfL36gQWk
	ik3AWGLz8iVgVSICe5gkPr1YwQriMAtMY5S4cOo7M0iVsECoxPdLc5lAbBYBVYlp7/eDdfMK
	uEssnf6VBWKfnMTJY5NZQWxOAQ+JH3OPgsWFgGrW/+thmsDIu4CRYRWjaGppckFxUnquoV5x
	Ym5xaV66XnJ+7iZGSFB+2cG4+JjVIUYBDkYlHl6NnD0hQqyJZcWVuYcYJTiYlUR4eyT2hQjx
	piRWVqUW5ccXleakFh9iZOLglGpgNI58VLp6t9zSDwJuMhvXGUYl8Ewt36joeUv5ufqC3ak5
	wio72msm/F6xbMpOv9wuyS9p1zY9iXwY07hl/V0r8RW2NxY0zBF5eU5e+c8WtvjgWdWfay/y
	iNTPrfc8Hvh/jjgPh6nmlGdTitSrhdxr3r85/HKHwMt9H36qxMs+la1MFbupZRDMp8RSnJFo
	qMVcVJwIAHSQl2QoAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add myself as supporter to help in reviewing patches for Maxim 14577 and
77693 MUIC charger drivers. These are used on Exynos-based boards
(Trats 2, Gear 1 and Gear 2).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-By: Sebastian Reichel <sre@kernel.org>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index dbc17b3b51d4..c6fbb8cb58de 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6152,6 +6152,13 @@ F:	Documentation/devicetree/bindings/i2c/max6697.txt
 F:	drivers/hwmon/max6697.c
 F:	include/linux/platform_data/max6697.h
 
+MAXIM MUIC CHARGER DRIVERS FOR EXYNOS BASED BOARDS
+M:	Krzysztof Kozlowski <k.kozlowski@samsung.com>
+L:	linux-pm@vger.kernel.org
+S:	Supported
+F:	drivers/power/max14577_charger.c
+F:	drivers/power/max77693_charger.c
+
 MAXIRADIO FM RADIO RECEIVER DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
-- 
1.9.1

