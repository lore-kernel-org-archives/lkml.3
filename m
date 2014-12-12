Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887AbaLLI1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:27:44 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:55354 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759848AbaLLI1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:27:40 -0500
X-AuditID: cbfee68d-f79296d000004278-f0-548aa6f6c2ed
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: kgene.kim@samsung.com, rafael.j.wysocki@intel.com, a.kesavan@samsung.com,
        tomasz.figa@gmail.com, b.zolnierkie@samsung.com,
        k.kozlowski@samsung.com, cw00.choi@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCHv3 5/7] ARM: dts: Add PPMU dt node for Exynos3250
Date: Fri, 12 Dec 2014 17:27:30 +0900
Message-id: <1418372852-12454-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1418372852-12454-1-git-send-email-cw00.choi@samsung.com>
References: <1418372852-12454-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWyRsSkSPfbsq4QgxW7JCwer1nMZLFxxnpW
	i+tfnrNazD9yjtXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF7cYVbBaP
	V7xlt1i16w+jA5/Hzll32T0W73nJ5LF5Sb1H35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVwZfw6
	u5CpYItoxdW14g2MbwW6GDk5JARMJF4vOsoMYYtJXLi3nq2LkYtDSGApo0TTjy0sMEV3N56D
	SixilFg6Yw6U08QkcW7WfrB2NgEtif0vbrCB2CIC5hK7lv4EK2IWuMQksX1mDxNIQljARWLh
	myNgRSwCqhKHV80DW8Er4CqxYNJiVoh1ChLLls8EszkF3CReXN3A2MXIAbTNVeLnkjqQmRIC
	x9gltv8/ywwxR0Di2+RDLCA1EgKyEpsOQL0jKXFwxQ2WCYzCCxgZVjGKphYkFxQnpRcZ6hUn
	5haX5qXrJefnbmIERsrpf896dzDePmB9iFGAg1GJh/dFaleIEGtiWXFl7iFGU6ANE5mlRJPz
	gfGYVxJvaGxmZGFqYmpsZG5ppiTOqyj1M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo8iN
	V7FtmdLdOUUW+3c2GT6aXsh8yeH+5TV7Obl1/wW9PPGkxv3Mwb2C3/Y8Tc6+pNPzmfXOS1tr
	pfIrJcsecWw17A9on99bssm7W1nl24P1gfuXLc+vseflrZZxzLbWufvcaHujv3+bCAdb78HD
	HYyaz1d35erPzFGdx+CaF7OV9ymPf8UFJZbijERDLeai4kQAnFfk7o8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t9jAd1vy7pCDBYvEbB4vGYxk8XGGetZ
	La5/ec5qMf/IOVaL1y8MLXoXXGWzONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWtxtXsFk8
	XvGW3WLVrj+MDnweO2fdZfdYvOclk8fmJfUefVtWMXp83iQXwBrVwGiTkZqYklqkkJqXnJ+S
	mZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SokkJZYk4pUCggsbhYSd8O04TQ
	EDddC5jGCF3fkCC4HiMDNJCwhjHj19mFTAVbRCuurhVvYHwr0MXIySEhYCJxd+M5NghbTOLC
	vfVANheHkMAiRomlM+ZAOU1MEudm7WcGqWIT0JLY/+IGWIeIgLnErqU/wYqYBS4xSWyf2cME
	khAWcJFY+OYIWBGLgKrE4VXzWEBsXgFXiQWTFrNCrFOQWLZ8JpjNKeAm8eLqBsYuRg6gba4S
	P5fUTWDkXcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOA6fSe1gXNlgcYhRgINRiYf3
	RWpXiBBrYllxZe4hRgkOZiUR3r9RQCHelMTKqtSi/Pii0pzU4kOMpkBHTWSWEk3OB6aIvJJ4
	Q2MTMyNLI3NDCyNjcyVxXiX7thAhgfTEktTs1NSC1CKYPiYOTqkGxg2uc9T+OtkVih/Mqf2n
	zlBTwTT/rc9tTZZJ947fbJO07PPaPLdC7pWuwaST5zkyl84zbBO2ufuIafXbf/3PE5c95++f
	5aK0nPO8YHyqi7OVhffl9S/inU3EP/9zOSDL7zX1y77IuaFhTLXvnuR897ZvnPVqo/PXZZFX
	p/JNLtrtYnfbedWcj0osxRmJhlrMRcWJACyupmbZAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add PPMU (Performance Profiling Monitoring Units) dt node
to estimate the utilization of each IP in Exynos SoC throught DEVFREQ Event
subsystem.

This patch adds following PPMU dt nodes:
- PPMU_DMC0	0x106a0000
- PPMU_DMC1	0x106b0000
- PPMU_RIGHTBUS 0x112A0000
- PPMU_LEFTBUS  0x116A0000
- PPMU_CAMIF    0x11AC0000
- PPMU_LCD0     0x11E40000
- PPMU_3D       0x13220000
- PPMU_MFC_L    0x13660000
- PPMU_CPU	0x106c0000

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 66 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index c743f60..70a9120 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -529,6 +529,72 @@
 			compatible = "arm,cortex-a7-pmu";
 			interrupts = <0 18 0>, <0 19 0>;
 		};
+
+		ppmu_dmc0: ppmu_dmc0@106a0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x106a0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_dmc1: ppmu_dmc1@106b0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x106b0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_cpu: ppmu_cpu@106c0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x106c0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_rightbus: ppmu_rightbus@112a0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x112a0000 0x2000>;
+			clocks = <&cmu CLK_PPMURIGHT>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_leftbus: ppmu_leftbus0@116a0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x116a0000 0x2000>;
+			clocks = <&cmu CLK_PPMULEFT>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_camif: ppmu_camif@11ac0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x11ac0000 0x2000>;
+			clocks = <&cmu CLK_PPMUCAMIF>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_lcd0: ppmu_lcd0@11e40000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x11e40000 0x2000>;
+			clocks = <&cmu CLK_PPMULCD0>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_g3d: ppmu_g3d@13220000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x13220000 0x2000>;
+			clocks = <&cmu CLK_PPMUG3D>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_mfc_l: ppmu_mfc_l@13660000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x13660000 0x2000>;
+			clocks = <&cmu CLK_PPMUMFC_L>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
 	};
 };
 
-- 
1.8.5.5

