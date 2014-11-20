Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbaKTO0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:26:42 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:61872 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592AbaKTO01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:26:27 -0500
X-AuditID: cbfee68e-f79b46d000002b74-0b-546dfa113065
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH 1/2] ARM: dts: add pwm node for exynos4412-trats2
Date: Thu, 20 Nov 2014 23:26:15 +0900
Message-id: <1416493576-10129-1-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsWyRsSkWFfwV26IwaZ7bBbXvzxntdjRcITV
	onfBVTaLy7vmsFnMOL+PyYHVo2/LKkaPz5vkApiiuGxSUnMyy1KL9O0SuDLOvn7CVvCateLn
	zIssDYxPWLoYOTkkBEwk3mzZywphi0lcuLeerYuRi0NIYCmjxPY9Z9hgis53/WSHSExnlNjx
	7zUzhNPGJPHqyBcmkCo2AW2J7+sXg40SEVCT6Fm8lRGkiFlgEqPE96cPmEESwgKOEpO3zwAb
	yyKgKrF862pGEJtXwENia+tSoBoOoHUKEnMm2YD0SgjcZ5N4cmY5VL2AxLfJh1ggamQlNh1g
	hrhOUuLgihssExgFFzAyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQIDMPT/5717WC8ecD6
	EKMAB6MSD2+CRW6IEGtiWXFl7iFGU6ANE5mlRJPzgcGeVxJvaGxmZGFqYmpsZG5ppiTOmyD1
	M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY77jweMrlGevSp5xxmaq26In+85bPe77aBAu
	4Wp5fdvV5E696O/hJnmT9V32HyvgX11zpGRy6MZ9Z14FfVvkLH3YJmSv250nFvNFf31dtFTl
	i4pNVROz9sJGVuXb+9w8p1yf8i9e7dqFo0XX7u+QVW9ZcHPJ70srGv8qly6SPjvFVtFyZhfb
	hSglluKMREMt5qLiRABp0MMGPgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t9jQV2BX7khBrsu2Fhc//Kc1WJHwxFW
	i94FV9ksLu+aw2Yx4/w+JgdWj74tqxg9Pm+SC2CKamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGHMOPv6CVvBa9aKnzMvsjQwPmHpYuTkkBAwkTjf9ZMdwhaTuHBvPVsXIxeH
	kMB0Rokd/14zQzhtTBKvjnxhAqliE9CW+L5+MSuILSKgJtGzeCsjSBGzwCRGie9PHzCDJIQF
	HCUmb5/BBmKzCKhKLN+6mhHE5hXwkNjauhSohgNonYLEnEk2Exi5FzAyrGIUTS1ILihOSs81
	0itOzC0uzUvXS87P3cQIDvJn0jsYVzVYHGIU4GBU4uFNsMgNEWJNLCuuzD3EKMHBrCTCu/A9
	UIg3JbGyKrUoP76oNCe1+BCjKdDyicxSosn5wAjMK4k3NDYxM7I0Mje0MDI2VxLnvXETqEkg
	PbEkNTs1tSC1CKaPiYNTqoGxu+qDtNx3sd9Vxd3ruDj4jHT857F8jzCexZq1x+zWyk+unD6s
	tw4WHLT9psD6+ErI0+bZ06JOTj+8r776xMPa1O1xBjN7PIXkte8e+cTI82L6PPd9+YsuGM56
	cEH0uMs8rr/sL3fLMDdMuu+36/3PfyH33aY5yjSkx+ny3Y6ct/I2Y9hGH8HJSizFGYmGWsxF
	xYkAYMq/BogCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add PWM(Pulse Width Modulation) node and
handle to use pwm property.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 8ee20bd..72462e8 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -636,6 +636,13 @@
 		};
 	};
 
+	pwm: pwm@139D0000 {
+		pinctrl-0 = <&pwm0_out>;
+		pinctrl-names = "default";
+		samsung,pwm-outputs = <0>;
+		status = "okay";
+	};
+
 	dsi_0: dsi@11C80000 {
 		vddcore-supply = <&ldo8_reg>;
 		vddio-supply = <&ldo10_reg>;
-- 
1.7.9.5

