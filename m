Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbaJBMXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:23:42 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47470 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaJBMW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:22:27 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-64-542d437f7bf9
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-api@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 7/7] ARM: multi_v7_defconfig: Enable Maxim 77693 charger
Date: Thu, 02 Oct 2014 14:22:08 +0200
Message-id: <1412252528-30148-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1412252528-30148-1-git-send-email-k.kozlowski@samsung.com>
References: <1412252528-30148-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t/xq7r1zrohBle3alpsnLGe1WLSugNM
	FpOevGe2mH/kHKvFxJWTmS363yxktTj3aiWjxdHfBRavXxha9C64ymZxtukNu8X9r0cZLTZ/
	72Cz2PT4GqvF5V1z2Cw+9x5htJhxfh+Txe3LvBZrj9xlt1h6/SKTxYTpa1ksWvceYbc43c1q
	cXp3icWqXX8YHSQ91sxbw+jR0tzD5nG5r5fJ4+/z6ywef1e9YPbYOesuu8fK5V/YPDav0PLY
	tKqTzePOtT1sHvNOBnpsXlLv0bdlFaPH501yAXxRXDYpqTmZZalF+nYJXBlt66+zFrxgrTj9
	ZgdbA2M3axcjJ4eEgInE9/YV7BC2mMSFe+vZuhi5OIQEljJKPH/2lhXC6WOSeNTzkRGkik3A
	WGLz8iVgVSICf5klJnx/xQTiMAs8ZZY4t2EL2FxhAQ+J2afngHWwCKhKXGz+wgxi8wq4Syy4
	/YgFYp+cxMljk8HqOYHq576dCHaHEFBNW9MqtgmMvAsYGVYxiqaWJhcUJ6XnGuoVJ+YWl+al
	6yXn525ihETWlx2Mi49ZHWIU4GBU4uHNaNAJEWJNLCuuzD3EKMHBrCTC+8ReN0SINyWxsiq1
	KD++qDQntfgQIxMHp1QD4zyFqCOlO7Q8LtopSykcqnf4lfDqjIOSkirnEQ7Grf9WrSkTk5GY
	1+pvYlvBvtvqzO/Am26mL9t/PK8VLff4d/rG5JRDMcGcPJlaN0QTRTdeO7Vix7mHty2faCZE
	rdpyhzGh3Ul6wd1r8kmSrG75ur2vanPetH5y50ra+OvZ2W7Whww/LrnHK7EUZyQaajEXFScC
	AIzd9reKAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the max77693 charger driver used on Trats2 board. This allows
querying the charging status through power supply interface.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index a25549d015e8..54367775aade 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -248,6 +248,7 @@ CONFIG_GPIO_TPS6586X=y
 CONFIG_GPIO_TPS65910=y
 CONFIG_BATTERY_SBS=y
 CONFIG_CHARGER_TPS65090=y
+CONFIG_CHARGER_MAX77693=y
 CONFIG_POWER_RESET_AS3722=y
 CONFIG_POWER_RESET_GPIO=y
 CONFIG_POWER_RESET_SUN6I=y
-- 
1.9.1

