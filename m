Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbaLWMq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 07:46:59 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:17765 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127AbaLWMqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 07:46:55 -0500
X-AuditID: cbfee68e-f79b46d000002b74-56-5499642eaf43
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene@kernel.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH 1/4] ARM: dts: Add exynos_usbphy node for exynos3250
Date: Tue, 23 Dec 2014 21:46:29 +0900
Message-id: <1419338792-22853-2-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1419338792-22853-1-git-send-email-jaewon02.kim@samsung.com>
References: <1419338792-22853-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsWyRsSkWFc/ZWaIwZJZzBbXvzxntdjRcITV
	ov/xa2aLy7vmsFnMOL+PyWLRslZmBzaPTas62Tz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr
	49Kf50wFi9gr9jReZ2xg/MjaxcjJISFgIvHnfj8LhC0mceHeerYuRi4OIYGljBJvl2wFKuIA
	K5p9OhsiPp1R4v+VO8wQThuTxK/Vl8G62QS0Jb6vXwzWICKgKLF5gQJIDbPAekaJHRtusYHU
	CAu4SExsXQW2mUVAVWLqpJVMIPW8Ah4SnzY7Q+xSkJgzyQbE5BTwlFi4Uw+kWAioYNOSSewg
	EyUEmtklJl6cxQwxRUDi2+RDLBCtshKbDjBDvCIpcXDFDZYJjMILGBlWMYqmFiQXFCelFxnp
	FSfmFpfmpesl5+duYgSG8Ol/z/p2MN48YH2IUYCDUYmH9+e5GSFCrIllxZW5hxhNgTZMZJYS
	Tc4HRkpeSbyhsZmRhamJqbGRuaWZkjhvgtTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M
	/B0f1xxec1+zevI0PpZ9bex+M7+Lf/SOuP9980bLqzq8kwpizrUVsiR0sq3xWy4yoWvyDN7V
	gcvebI2ZwW6bsPxLWMOu/RLNvBuTWzR+7KuR6ZIq+cofsHufa/JmNt8pUQW9E9aGil9q5Dm+
	VWBVZ6T4wWtT2C5pSR2bb2ScURAg8efTvA4zJZbijERDLeai4kQAiltGPFwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t9jQV29lJkhBusOWFpc//Kc1WJHwxFW
	i/7Hr5ktLu+aw2Yx4/w+JotFy1qZHdg8Nq3qZPPo27KK0ePzJrkA5qgGRpuM1MSU1CKF1Lzk
	/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoMVKCmWJOaVAoYDE4mIlfTtM
	E0JD3HQtYBojdH1DguB6jAzQQMIaxoxLf54zFSxir9jTeJ2xgfEjaxcjB4eEgInE7NPZXYyc
	QKaYxIV769m6GLk4hASmM0r8v3KHGcJpY5L4tfoyC0gVm4C2xPf1i8GaRQQUJTYvUACpYRZY
	zyixY8MtNpAaYQEXiYmtq1hBbBYBVYmpk1YygdTzCnhIfNrsDLFXQWLOJBsQk1PAU2LhTj2Q
	YiGggk1LJrFPYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Qp5J72Bc1WBxiFGA
	g1GJh3fBmRkhQqyJZcWVuYcYJTiYlUR4lQNnhgjxpiRWVqUW5ccXleakFh9iNAU6aSKzlGhy
	PjB680riDY1NzIwsjcwNLYyMzZXEeZXs20KEBNITS1KzU1MLUotg+pg4OKUaGLeqzv11y3H2
	z9k6q7b5vZXncrGRNBQOO7ntyQX+6TYHCjdv5mgzOCEi07KD+4/ORmZxvYBgg1N5ZQXVomat
	Nyyrpv5YHOW9/t/2zgVMT6dPPbg6xJnDw83Nhu9dyg+eY9GaSpVG0zumzPuWfGnaZbb0vnK5
	fVkOH15XHi3I2fGZKWiueeZGDSWW4oxEQy3mouJEAFoY1FqmAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree node for exynos_usbphy to use USB 2.0 Device.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 2246549..d976007 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -279,6 +279,17 @@
 			status = "disabled";
 		};
 
+		exynos_usbphy: exynos-usbphy@125B0000 {
+			compatible = "samsung,exynos3250-usb2-phy";
+			reg = <0x125B0000 0x100>;
+			samsung,pmureg-phandle = <&pmu_system_controller>;
+			samsung,sysreg-phandle = <&sys_reg>;
+			clocks = <&cmu CLK_USBOTG>, <&xusbxti>;
+			clock-names = "phy", "ref";
+			#phy-cells = <1>;
+			status = "disabled";
+		};
+
 		amba {
 			compatible = "arm,amba-bus";
 			#address-cells = <1>;
-- 
1.7.9.5

