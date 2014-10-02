Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaJBMXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:23:24 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42668 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbaJBMW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:22:27 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-62-542d437e5c22
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
Subject: [PATCH 6/7] ARM: exynos_defconfig: Enable Maxim 77693 charger
Date: Thu, 02 Oct 2014 14:22:07 +0200
Message-id: <1412252528-30148-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1412252528-30148-1-git-send-email-k.kozlowski@samsung.com>
References: <1412252528-30148-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t/xq7p1zrohBk93a1psnLGe1WLSugNM
	FpOevGe2mH/kHKvFxJWTmS363yxktTj3aiWjxdHfBRavXxha9C64ymZxtukNu8X9r0cZLTZ/
	72Cz2PT4GqvF5V1z2Cw+9x5htJhxfh+Txe3LvBZrj9xlt1h6/SKTxYTpa1ksWvceYbc43c1q
	cXp3icWqXX8YHSQ91sxbw+jR0tzD5nG5r5fJ4+/z6ywef1e9YPbYOesuu8fK5V/YPDav0PLY
	tKqTzePOtT1sHvNOBnpsXlLv0bdlFaPH501yAXxRXDYpqTmZZalF+nYJXBmbnpxgKTjFWrHo
	6SzWBsaXLF2MnBwSAiYSnVv2MELYYhIX7q1nA7GFBJYySsw6ENDFyAVk9zFJLJr1hhUkwSZg
	LLF5+RI2kISIwF9miQnfXzGBOMwCT5klzm3YAlYlLOAmMedrKxOIzSKgKvHgM0gHBwevgLvE
	x2+8ENvkJE4emwxWzingITH37UR2iM3uEm1Nq9gmMPIuYGRYxSiaWppcUJyUnmuoV5yYW1ya
	l66XnJ+7iRESVV92MC4+ZnWIUYCDUYmHN6NBJ0SINbGsuDL3EKMEB7OSCO8Te90QId6UxMqq
	1KL8+KLSnNTiQ4xMHJxSDYwMZ88wZzTmdwUVXmXgvSJ9Ivb1Xc81/av2335Xdj4/ZOLbrqyL
	dxfI3lquZt/u5HvpeETW/1dByg9OfH5WaLJo8eto38V5N2P33JJrLrwXq2+T0vFuQlNdpSt3
	dVPguYqZhT05MZ/79plrVPh/XyZWdIxV13e21M77ogn503+JabZLZe25KaDEUpyRaKjFXFSc
	CADezw5jiAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the max77693 charger driver used on Trats2 board. This allows
querying the charging status through power supply interface.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/configs/exynos_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
index b14d8c3f7e12..78a963de612a 100644
--- a/arch/arm/configs/exynos_defconfig
+++ b/arch/arm/configs/exynos_defconfig
@@ -79,6 +79,7 @@ CONFIG_DEBUG_GPIO=y
 CONFIG_POWER_SUPPLY=y
 CONFIG_BATTERY_SBS=y
 CONFIG_CHARGER_TPS65090=y
+CONFIG_CHARGER_MAX77693=y
 # CONFIG_HWMON is not set
 CONFIG_THERMAL=y
 CONFIG_EXYNOS_THERMAL=y
-- 
1.9.1

