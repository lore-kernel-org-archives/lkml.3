Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965477Ab3E2JsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:48:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12108 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964948Ab3E2JsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:48:14 -0400
X-AuditID: cbfee68f-b7f436d000000f81-04-51a5cedc797d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Praveen Paneri'" <p.paneri@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 2/2] ARM: dts: Add USB PHY node to Exynos4210
Date: Wed, 29 May 2013 18:48:12 +0900
Message-id: <000201ce5c51$a261d530$e7257f90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5cUZt7g7aF98F5SBCGXAfzxmJyhw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zA92755YGGuztYrJou3KQ3eLywkus
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsji/pZPJ4tiMJYwOHB53ru1h89i8pN6jb8sqRo/Pm+QC
	WKK4bFJSczLLUov07RK4Mia1PGEqmMJe0Xj8NWMD4wPWLkZODgkBE4kPe28zQthiEhfurWfr
	YuTiEBJYxihxvmsbO0xR19fzYA1CAtMZJV5sr4Yo+sUocWhbIxNIgk1ATeLLl8NADRwcIgLe
	Eqv+xoPUMAt8YJSY+PgH2AZhAVuJee0n2UBsFgFVieblT8DivAKWEv1X1rBC2IISPybfYwGx
	mQW0JNbvPM4EYctLbF7zlhniIAWJHWdfg/WKCOhJfD9xnRmiRkRi34t3jCCLJQSusUu8+9fN
	ArFMQOLb5EMsIMdJCMhKbDoANUdS4uCKGywTGMVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILi
	pPQiY73ixNzi0rx0veT83E2MkGjs38F494D1IcZkoPUTmaVEk/OB0ZxXEm9obGZkYWpiamxk
	bmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsYUji3HTeITnOq6xXYu7Xhq
	nn3o+wmOopxbGRmGtS6i3AGTlNkl2wyYmW1VY9xWtH47m/89qyHcozZf5Ppv292ZvH4hRYWd
	OX5T+0OlNsmlm/xhV9m8z6105WRjRxeznk5Jqzj7n5viZxf8WH5Gw/fAyaX/bP5PN8pQ4eU0
	63p771VsgFuzEktxRqKhFnNRcSIAaisO2twCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jQd0755YGGvzrs7Zou3KQ3eLywkus
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsji/pZPJ4tiMJYwOHB53ru1h89i8pN6jb8sqRo/Pm+QC
	WKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5Q
	UihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWZMannCVDCFvaLx+GvGBsYH
	rF2MnBwSAiYSXV/PQ9liEhfurWcDsYUEpjNKvNhe3cXIBWT/YpQ4tK2RCSTBJqAm8eXLYfYu
	Rg4OEQFviVV/40FqmAU+MEpMfPyDEaRGWMBWYl77SbBBLAKqEs3Ln4DFeQUsJfqvrGGFsAUl
	fky+xwJiMwtoSazfeZwJwpaX2LzmLTPEQQoSO86+BusVEdCT+H7iOjNEjYjEvhfvGCcwCsxC
	MmoWklGzkIyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgWH8mvYNxVYPFIUYB
	DkYlHt6Ar0sChVgTy4orcw8xSnAwK4nwpgouDRTiTUmsrEotyo8vKs1JLT7EmAz06URmKdHk
	fGAayiuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGRh+29Z9m
	2x55aLu7sjuOadKKg2+tZjV/Sj8+McDukkvvnXcCjDxzck5N/Z/TZ83NkKDgNIl/5pz2SO3M
	eVcW34/7+1SRNeP1kYMG1gYFzWon1P8HrD0878wU8XJGjuNWF+9O9O+8sXLu/XSl2I65bA81
	2KSPBZhqvpob/PzSb0VpzrWrQ76IP1ViKc5INNRiLipOBADWZuVcOQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device node for USB 2.0 PHY controller to Exynos4210.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Tested on Exynos4210.

 arch/arm/boot/dts/exynos4210.dtsi |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index 3c173c7..bec6637 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -135,6 +135,20 @@
 		clock-names = "usbhost";
 	};
 
+	usb2_phy: usbphy@125b0000 {
+		compatible = "samsung,exynos4210-usb2phy";
+		reg = <0x125b0000 0x100>;
+		clocks = <&clock 2>, <&clock 305>;
+		clock-names = "xusbxti", "usb_device";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		usbphy-sys {
+			reg = <0x10020704 0x8>;
+		};
+	};
+
 	g2d@12800000 {
 		compatible = "samsung,s5pv210-g2d";
 		reg = <0x12800000 0x1000>;
-- 
1.7.10.4


