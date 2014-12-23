Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbaLWMrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 07:47:52 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:49880 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbaLWMqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 07:46:43 -0500
X-AuditID: cbfee691-f79b86d000004a5a-73-5499642fa92c
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene@kernel.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH 2/4] ARM: dts: Add hsotg node for exynos3250
Date: Tue, 23 Dec 2014 21:46:30 +0900
Message-id: <1419338792-22853-3-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1419338792-22853-1-git-send-email-jaewon02.kim@samsung.com>
References: <1419338792-22853-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsWyRsSkUFc/ZWaIQfs8bovrX56zWuxoOMJq
	0f/4NbPF5V1z2CxmnN/HZLFoWSuzA5vHplWdbB59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CV
	MWF9L3vBB7aKle9+sjYw7mHtYuTgkBAwkXiwsLyLkRPIFJO4cG89WxcjF4eQwFJGiZN7njDC
	1Lx6xA0Rn84osXDuHEYIp41J4tfqyywg3WwC2hLf1y8GGyoioCixeYECSA2zwHpGiR0bbrGB
	xIUFbCRm/GYEKWcRUJVY/n4NmM0r4CExY+0bdohdChJzJtmAmJwCnhILd+qBVAgBVWxaMokd
	ZKKEQDO7xK/f35ggxghIfJt8iAWiVVZi0wFmiFckJQ6uuMEygVF4ASPDKkbR1ILkguKk9CJT
	veLE3OLSvHS95PzcTYzAAD7979nEHYz3D1gfYhTgYFTi4V1wZkaIEGtiWXFl7iFGU6ANE5ml
	RJPzgXGSVxJvaGxmZGFqYmpsZG5ppiTOqyP9M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD
	49K2Nd5705tEOr8r7+0qWPzljbpgEWfctW2n2nyN439PzrtmNH3jpKx0l3gP3uLZHUcqjiid
	KeA2/xmh1Jb1UnyKfccTrZrdOYIrNnDeMUp/sUzZr13OZtKy4PfPH718dqXhJcvc1FUzGHo2
	NKl//X+874khI6/bQ7ergfM9HN5vu7HvtNpzeSWW4oxEQy3mouJEAETVANhbAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t9jQV39lJkhBmfuMltc//Kc1WJHwxFW
	i/7Hr5ktLu+aw2Yx4/w+JotFy1qZHdg8Nq3qZPPo27KK0ePzJrkA5qgGRpuM1MSU1CKF1Lzk
	/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoMVKCmWJOaVAoYDE4mIlfTtM
	E0JD3HQtYBojdH1DguB6jAzQQMIaxowJ63vZCz6wVax895O1gXEPaxcjB4eEgInEq0fcXYyc
	QKaYxIV769m6GLk4hASmM0osnDuHEcJpY5L4tfoyC0gVm4C2xPf1i8GaRQQUJTYvUACpYRZY
	zyixY8MtNpC4sICNxIzfjCDlLAKqEsvfrwGzeQU8JGasfcMOsVdBYs4kGxCTU8BTYuFOPZAK
	IaCKTUsmsU9g5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzhCnknvYFzVYHGIUYCD
	UYmHd8GZGSFCrIllxZW5hxglOJiVRHiVA2eGCPGmJFZWpRblxxeV5qQWH2I0BbppIrOUaHI+
	MHrzSuINjU3MjCyNzA0tjIzNlcR5lezbQoQE0hNLUrNTUwtSi2D6mDg4pRoYeY8dmVgUWJks
	Pv9VvfO5vR1e2d3rQqzn8X7dJ8m/VW7KxCPTJy/ir2SJePph7epgwTOT02Y9YI4OqpfZz+AZ
	eTB5Ya1BzOzDN++tn/bpwy/eF96hD39cdei7WRMuveHP+nOrrsU61wX43ij9nTL/XNS9YKm2
	yVOkRZyVuBcnp1p5JPK+idOYosRSnJFoqMVcVJwIANej6KGmAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree node for hsotg to control USB 2.0 Device.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index d976007..e5c891a 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -255,6 +255,17 @@
 			status = "disabled";
 		};
 
+		hsotg: hsotg@12480000 {
+			compatible = "snps,dwc2";
+			reg = <0x12480000 0x20000>;
+			interrupts = <0 141 0>;
+			clocks = <&cmu CLK_USBOTG>;
+			clock-names = "otg";
+			phys = <&exynos_usbphy 0>;
+			phy-names = "usb2-phy";
+			status = "disabled";
+		};
+
 		mshc_0: mshc@12510000 {
 			compatible = "samsung,exynos5250-dw-mshc";
 			reg = <0x12510000 0x1000>;
-- 
1.7.9.5

