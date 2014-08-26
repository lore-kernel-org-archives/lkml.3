Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbaHZONi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:13:38 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41922 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758272AbaHZONg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:13:36 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-cf-53fc960e89e3
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH] ARM: dts: exynos4x12: Fix pull setting in sd4_width8 pin group
Date: Tue, 26 Aug 2014 16:13:25 +0200
Message-id: <1409062405-15215-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 2.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJMWRmVeSWpSXmKPExsVy+t/xK7p80/4EG7z6YGjRu+Aqm8Wmx9dY
	LS7vmsNmMeP8PiaLtUfuslusn/GaxYHNY/OSeo++LasYPT5vkgtgjuKySUnNySxLLdK3S+DK
	WNS0jalgNVvFxgP32RsY57B2MXJySAiYSDx6d4oFwhaTuHBvPVsXIxeHkMBSRondEy4wQjh9
	TBJLv/xjBqliE1CT+NzwiA3EFhFQlfjctoAdxGYW2MsocWunKogtLOAv0X7oJdhUFqCaa+c/
	gNXzCjhJTD09lRlim5zEqo37mCYwci9gZFjFKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERIG
	X3YwLj5mdYhRgINRiYf3Q8nvYCHWxLLiytxDjBIczEoivD+S/gQL8aYkVlalFuXHF5XmpBYf
	YmTi4JRqYOSYUzll89M7EavFz6c8YFzYucR3rY+0/qP6ddWe51MToj7d5z+31I2hI5td5Gl/
	4JWulqApOnJf/+140x7n8CLaLcE+xEhXddf9CU8D0hv1duUGzOLLPeow42KAJKsP28MdbCcV
	w+9J5caHCGwo/6nDFCE4oTUumWupw+X1P394C6frGmzwVmIpzkg01GIuKk4EAGOTcrnhAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The group has the samsung,pin-pud property set to 4, which is not a
correct value. This patch fixes this by replacing it with 3, which is
the correct value for pull-up.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/boot/dts/exynos4x12-pinctrl.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi b/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi
index 927fec6..c141931 100644
--- a/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi
@@ -691,7 +691,7 @@
 		sd4_bus8: sd4-bus-width8 {
 			samsung,pins = "gpk1-3", "gpk1-4", "gpk1-5", "gpk1-6";
 			samsung,pin-function = <4>;
-			samsung,pin-pud = <4>;
+			samsung,pin-pud = <3>;
 			samsung,pin-drv = <3>;
 		};
 
-- 
2.0.4

