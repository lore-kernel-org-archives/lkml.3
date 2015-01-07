Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbbAGOJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:09:52 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:10368 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbbAGOIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:08:30 -0500
X-AuditID: cbfee68d-f79296d000004278-1a-54ad3ddaadde
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel@vger.kernel.org, Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH RESEND v2 1/4] ARM: dts: Add exynos_usbphy node for exynos3250
Date: Wed, 07 Jan 2015 23:08:18 +0900
Message-id: <1420639701-1524-2-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420639701-1524-1-git-send-email-jaewon02.kim@samsung.com>
References: <1420639701-1524-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWyRsSkQPeW7doQgy+N8hbXvzxntdjRcITV
	ov/xa2aLy7vmsFnMOL+PyYHVY9OqTjaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyrj3Yztb
	QSN7xflLV5kbGK+xdjFyckgImEh0/Ohkg7DFJC7cWw9kc3EICSxllJi0dwoLTNGcGQ2sEInp
	jBIbf65mgXDamCQOXrjODFLFJqAt8X39YqAqDg4RAUWJzQsUQGqYBSYxSty4twJsnbCAn8S/
	fQvAbBYBVYk134+zg9i8Au4SXQu+gfVKCChIzJlkAxLmFPCQ2PvnKCOILQRU8ufZLbAjJAR+
	s0k8/fqZHWKOgMS3yYdYIHplJTYdYIY4WlLi4IobLBMYhRcwMqxiFE0tSC4oTkovMtQrTswt
	Ls1L10vOz93ECAzf0/+e9e5gvH3A+hCjAAejEg9vQd+aECHWxLLiytxDjKZAGyYyS4km5wOj
	JK8k3tDYzMjC1MTU2Mjc0kxJnFdR6mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsbQ3WYc
	5x5Y+9bbHD1zlUGjyr36sQFr2oWamUcXWcbqSTxoz2T7Knrb95+eS+nb7f9ynNVCGq3CeRcd
	djy56xx/4Cae2sQ73jtW+eQHf1I4bWPAHFL9bNqvzju/hKp/FB25H2tU+DC5vjA07diJI+de
	5erMDHuZIxl2rmlPU3/RFt13H/j/n1ZiKc5INNRiLipOBADedcclWgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t9jQd1btmtDDP7slbC4/uU5q8WOhiOs
	Fv2PXzNbXN41h81ixvl9TA6sHptWdbJ59G1ZxejxeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhDWPGvR/b2Qoa2SvOX7rK3MB4jbWLkZNDQsBEYs6MBihbTOLCvfVs
	XYxcHEIC0xklNv5czQLhtDFJHLxwnRmkik1AW+L7+sVAHRwcIgKKEpsXKIDUMAtMYpS4cW8F
	2CRhAT+Jf/sWgNksAqoSa74fZwexeQXcJboWfAPrlRBQkJgzyQYkzCngIbH3z1FGEFsIqOTP
	s1usExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjo5nUjsYVzZYHGIU4GBU4uEt
	6FsTIsSaWFZcmXuIUYKDWUmE980voBBvSmJlVWpRfnxRaU5q8SFGU6CjJjJLiSbnAyM3ryTe
	0NjEzMjSyNzQwsjYXEmcV8m+LURIID2xJDU7NbUgtQimj4mDU6qBMWKehMkR5urtHP1yO8QD
	X7wTe1VyYgdDuLBfze6VhsI8kvLe9Rv9sz9u1PR4pjNxWeY2Yc/dcx5zGm58tV3okZjf+f2T
	M6Jq3tgdcV3kcqJv6p8o+eqQOyXH18972iW7/R/X137Wo7qhjscY5JJXvZ23fYXED5+zki/2
	/46w+Hn8wr1+q2xFTyWW4oxEQy3mouJEAAOz4XakAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree node for exynos_usbphy to use USB 2.0 Device.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 2246549..27d385f 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -279,6 +279,16 @@
 			status = "disabled";
 		};
 
+		exynos_usbphy: exynos-usbphy@125B0000 {
+			compatible = "samsung,exynos3250-usb2-phy";
+			reg = <0x125B0000 0x100>;
+			samsung,pmureg-phandle = <&pmu_system_controller>;
+			clocks = <&cmu CLK_USBOTG>, <&cmu CLK_SCLK_UPLL>;
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

