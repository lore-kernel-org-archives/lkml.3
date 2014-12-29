Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaL2AF3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 19:05:29 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:40700 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbaL2AE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 19:04:29 -0500
X-AuditID: cbfee691-f79b86d000004a5a-6f-54a09a87910e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv6 5/9] ARM: dts: Add PPMU dt node for Exynos3250 SoC
Date: Mon, 29 Dec 2014 09:04:09 +0900
Message-id: <1419811453-16160-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1419811453-16160-1-git-send-email-cw00.choi@samsung.com>
References: <1419811453-16160-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSots+a0GIQWO7iMXjNYuZLK5/ec5q
	Mf/IOVaLSfcnsFi8fmFo0bvgKpvF2aY37BabHl9jtbi8aw6bxefeI4wWM87vY7JYev0ik8Xt
	xhVsFo9XvGW3WLXrD6MDv8eaeWsYPXbOusvusXjPSyaPzUvqPfq2rGL0+LxJLoAtissmJTUn
	syy1SN8ugSvj/8HvbAXLxCsOTfjL2MA4XaiLkZNDQsBEYv+Kc8wQtpjEhXvr2boYuTiEBJYy
	Siy8+poZpuj8v4mMILaQwHRGianrbSCKmpgkGs+/B0uwCWhJ7H9xgw3EFhGQkbi6cTsLSBGz
	QCOzxJdl/5lAEsICLhJTzrxlAbFZBFQldh/5CdbMK+Aq0ftmEyvENgWJZctngtmcAm4Se07c
	YIbY7Cpx/v9BVpChEgK32CX2tLYzQgwSkPg2+RDQUA6ghKzEpgNQV0tKHFxxg2UCo/ACRoZV
	jKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGIHxc/rfs4k7GO8fsD7EKMDBqMTDO+HY/BAh1sSy
	4srcQ4ymQBsmMkuJJucDozSvJN7Q2MzIwtTE1NjI3NJMSZxXR/pnsJBAemJJanZqakFqUXxR
	aU5q8SFGJg5OqQbGGKPFZ2T7VVgu2VUWtF7zmLvtVtiLT98P/eurfpjBfrX39KbHsR/rpsy3
	nJUc7exkqvjEae55DSVt9+fqb54vl6ifvmLloqd33r8T2CGrs6slxP9k43a7/6VqP6z2JE4I
	2PWMvyrqf+7x+NWSYoxfBJTtFfvOqgeVGbVYNK5a8XPNhW9/FY38lViKMxINtZiLihMBNdcl
	+JoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jQd32WQtCDI4d5LZ4vGYxk8X1L89Z
	LeYfOcdqMen+BBaL1y8MLXoXXGWzONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFqt2/WF04PdYM28No8fOWXfZPRbvecnksXlJvUffllWMHp83yQWwRTUw2mSk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAnaykUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzPh/8DtbwTLxikMT/jI2ME4X6mLk5JAQ
	MJE4/28iI4QtJnHh3no2EFtIYDqjxNT1Nl2MXEB2E5NE4/n3YEVsAloS+1/cACsSEZCRuLpx
	OwtIEbNAI7PEl2X/mUASwgIuElPOvGUBsVkEVCV2H/kJ1swr4CrR+2YTK8Q2BYlly2eC2ZwC
	bhJ7TtxghtjsKnH+/0HWCYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIER+cz6R2M
	qxosDjEKcDAq8fBOODY/RIg1say4MvcQowQHs5IIr1HZghAh3pTEyqrUovz4otKc1OJDjKZA
	V01klhJNzgcmjrySeENjEzMjSyNzQwsjY3MlcV4l+7YQIYH0xJLU7NTUgtQimD4mDk6pBsat
	BmcDrW3nbTkXonL87T8La/VT6ddC7zYoKZ0su3V+jvrH3xvf/V/geLtnunqb8aOwP20My+aF
	2/04/MekLFxi6taYZE+tqhtGNyXanpa7LVEKtT96RcE2LXjN6nyjqNeaEeU5/8KOeL9US727
	M3VBy+/8zGvHVq6bIKsvqb7vMZ8rQ3fxgv9KLMUZiYZazEXFiQCbq6y15AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add PPMU (Platform Performance Monitoring Unit) dt node
to estimate the utilization of each IP in Exynos SoC throught DEVFREQ Event
subsystem.

This patch adds following PPMU dt nodes:
- PPMU_DMC0     0x106a0000
- PPMU_DMC1     0x106b0000
- PPMU_RIGHTBUS 0x112A0000
- PPMU_LEFTBUS  0x116A0000
- PPMU_CAMIF    0x11AC0000
- PPMU_LCD0     0x11E40000
- PPMU_FSYS     0x12630000
- PPMU_3D       0x13220000
- PPMU_MFC      0x13660000
- PPMU_CPU      0x106c0000

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 74 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 2246549..9ed1260 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -515,6 +515,80 @@
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
+		ppmu_fsys: ppmu_fsys@12630000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x12630000 0x2000>;
+			clocks = <&cmu CLK_PPMUFILE>;
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
+		ppmu_mfc: ppmu_mfc@13660000 {
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

