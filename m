Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbaLWDUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 22:20:51 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:33717 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbaLWDSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 22:18:24 -0500
X-AuditID: cbfee68f-f791c6d000004834-29-5498defbee2e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCHv5 7/9] ARM: dts: Add PPMU dt node for Exynos5260 SoC
Date: Tue, 23 Dec 2014 12:18:15 +0900
Message-id: <1419304697-14789-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1419304697-14789-1-git-send-email-cw00.choi@samsung.com>
References: <1419304697-14789-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42JZI2JSpPvn3owQg+v/mSwer1nMZHH9y3NW
	i/lHzrFaTLo/gcViSTO3xesXhha9C66yWZxtesNusenxNVaLy7vmsFl87j3CaDHj/D4mi6XX
	LzJZ3G5cwWbxeMVbdotVu/4wOgh4rJm3htFj56y77B6L97xk8ti8pN6jb8sqRo/Pm+QC2KK4
	bFJSczLLUov07RK4MjbMmMJSsF264mrfHtYGxuOiXYycHBICJhJN5zYyQthiEhfurWfrYuTi
	EBJYyiix69tdVpiiFXvbmCESixgl9rdOh6pqYpL4e+grE0gVm4CWxP4XN9hAbBEBGYmrG7ez
	gBQxC6xilmg9vgKsSFjAReL9j1UsIDaLgKrE9YsXmUFsXgFXiYXfFjJBrFOQWLZ8JthqTgE3
	iT/znoLZQkA1EzuuM4EMlRC4xy7xafZLVohBAhLfJh8CGsoBlJCV2HSAGWKOpMTBFTdYJjAK
	L2BkWMUomlqQXFCclF5krFecmFtcmpeul5yfu4kRGEmn/z3r38F494D1IUYBDkYlHt4FZ2aE
	CLEmlhVX5h5iNAXaMJFZSjQ5HxiveSXxhsZmRhamJqbGRuaWZkrivAulfgYLCaQnlqRmp6YW
	pBbFF5XmpBYfYmTi4JRqYEyU2rkogSP7fHWD6vf3fWZs7PP7/i2sWCHy60VnxuakFyIGdSfE
	9LP/lE7ZZvIzhn33At8r/k1rq1QYzzRunOp6O+bBtkkTlBcFyEjuerHd+tYSUVc+pxuy/x2k
	Jy5ZVq37/+NsQVaf0OUpLUpPihj0t3MIZ907EmSb4qi/vKXG0v5M/oIbmkosxRmJhlrMRcWJ
	ADLfPEyfAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9jAd3f92aEGPTNMbN4vGYxk8X1L89Z
	LeYfOcdqMen+BBaLJc3cFq9fGFr0LrjKZnG26Q27xabH11gtLu+aw2bxufcIo8WM8/uYLJZe
	v8hkcbtxBZvF4xVv2S1W7frD6CDgsWbeGkaPnbPusnss3vOSyWPzknqPvi2rGD0+b5ILYItq
	YLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMATpbSaEs
	MacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5ixYcYUloLt0hVX+/awNjAeF+1i
	5OSQEDCRWLG3jRnCFpO4cG89WxcjF4eQwCJGif2t06GcJiaJv4e+MoFUsQloSex/cYMNxBYR
	kJG4unE7C0gRs8AqZonW4yvAioQFXCTe/1jFAmKzCKhKXL94EWwFr4CrxMJvC5kg1ilILFs+
	kxXE5hRwk/gz7ymYLQRUM7HjOtMERt4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYLj
	9Jn0DsZVDRaHGAU4GJV4eBecmREixJpYVlyZe4hRgoNZSYRXvRUoxJuSWFmVWpQfX1Sak1p8
	iNEU6KqJzFKiyfnAFJJXEm9obGJmZGlkbmhhZGyuJM6rZN8WIiSQnliSmp2aWpBaBNPHxMEp
	1cDoudboSt7bG7U3n/AbmK3S6wy1dfx28Eb6nhfaswxsb/orc7skrnn3seSc781dyxSbBJ+d
	XMhfq5RYwZDLPEFVatVB581yy08pLjdMXlT0oos/b6N43HymhK/+IcvN7+ecFDu0wUBIRI3D
	9ItmCX+jgPbdpfb2O1X8173Qu3T6+J2WCvZv/W5KLMUZiYZazEXFiQBSLNt66QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds PPMU (Performance Profiling Monitoring Unit) dt node
Exynos5260 SoC.

Exynos5260 SoC has following PPMU IPs:
- PPMU_DREX0_S0 0x10c60000
- PPMU_DREX0_S1 0x10c70000
- PPMU_DREX1_S0 0x10c80000
- PPMU_DREX1_S1 0x10c90000
- PPMU_EAGLE    0x10cc0000
- PPMU_KFC      0x10cd0000
- PPMU_MFC      0x11040000
- PPMU_G3D      0x11880000
- PPMU_FSYS     0x12220000
- PPMU_ISP      0x13370000
- PPMU_FICM     0x13cb0000
- PPMU_GSCL     0x13e60000
- PPMU_MSCL     0x13ee0000
- PPMU_FIMD0X   0x145b0000
- PPMU_FIMD1X   0x145c0000

The drivers/devfreq/exynos/exynos5_bus.c supports the memory bus frequency/
voltage scaling of Exynos5260 SoC with DEVFREQ framework.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Abhilash Kesavan <a.kesavan@samsung.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/boot/dts/exynos5260.dtsi | 90 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5260.dtsi b/arch/arm/boot/dts/exynos5260.dtsi
index 36da38e..26f3074 100644
--- a/arch/arm/boot/dts/exynos5260.dtsi
+++ b/arch/arm/boot/dts/exynos5260.dtsi
@@ -307,6 +307,96 @@
 			fifo-depth = <64>;
 			status = "disabled";
 		};
+
+		ppmu_drex0_s0: ppmu_drex0_s0@10c60000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x10c60000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_drex0_s1: ppmu_drex0_s1@10c70000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x10c70000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_drex1_s0: ppmu_drex1_s0@10c80000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x10c80000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_drex1_s1: ppmu_drex1_s1@10c90000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x10c90000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_eagle: ppmu_eagle@10cc0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x10cc0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_kfc: ppmu_kfc@10cd0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x10cd0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_mfc: ppmu_mfc@11040000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x11040000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_g3d: ppmu_g3d@11880000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x11880000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_fsys: ppmu_fsys@12220000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x12220000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_isp: ppmu_isp@13370000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x13370000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_fimc: ppmu_fimc@13cb0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x13cb0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_gscl: ppmu_gscl@13e60000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x13e60000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_mscl: ppmu_gscl@13ee0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x13ee0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_fimd0x: ppmu_fimd0x@145b0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x145b0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_fimd1x: ppmu_fimd1x@145c0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x145c0000 0x2000>;
+			status = "disabled";
+		};
 	};
 };
 
-- 
1.8.5.5

