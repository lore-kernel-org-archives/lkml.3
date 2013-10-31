Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab3JaHrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 03:47:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:52418 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3JaHqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 03:46:45 -0400
X-AuditID: cbfee68f-b7f836d000001b39-3e-52720ae4520c
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        gregkh@linuxfoundation.org, kishon@ti.com, kgene.kim@samsung.com,
        k.debski@samsung.com, s.nawrocki@samsung.com, t.figa@samsung.com,
        balbi@ti.com, jwerner@chromium.org, jg1.han@samsung.com
Subject: [PATCH 3/4] dt: exynos5420: Enable support for USB 3.0 PHY controller
Date: Thu, 31 Oct 2013 13:15:43 +0530
Message-id: <1383205544-32244-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1383205544-32244-1-git-send-email-gautam.vivek@samsung.com>
References: <1383205544-32244-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsWyRsSkSvcJV1GQweV9ihYH79dbzD9yjtWi
	efF6NovLCy+xWnQcesxk8eP1BTaL3gVX2SwuPO1hs9j0+BqrxcK2JSwWl3fNYbOYcX4fk8Wi
	Za3MFofftLNarJ/xmsWB32N2w0UWj/1z17B7bF5S79G3ZRWjx/Eb25k8Pm+SC2CL4rJJSc3J
	LEst0rdL4Mp49HopY8FdjorWPTtZGhinsncxcnJICJhI/JrTwwxhi0lcuLeerYuRi0NIYCmj
	RNPV3SwwRe8utzJDJBYxSux+/YsJwpnCJLHl4H1GkCo2AV2Jpre7wGwRAQeJJUvvgI1iFjjE
	JLF071ywUcICfhLPjiwEs1kEVCVebn0OZvMKeEgsvf4Rap2CxJvbz4DWcXBwCnhKNDTxgoSF
	gEpuLJ3PAjJTQuAWu8TWyfNYIeYISHybfIgFpF5CQFZi0wGodyQlDq64wTKBUXgBI8MqRtHU
	guSC4qT0ImO94sTc4tK8dL3k/NxNjMD4Of3vWf8OxrsHrA8xJgONm8gsJZqcD4y/vJJ4Q2Mz
	IwtTE1NjI3NLM9KElcR57z9MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAyPrlrtTfih3F
	RvO7J+7TNW+ZpfPQqWDp6gON0V8W788quHAtk++uzgPOzN+XErzENzyyeea90q93lWufIO8/
	ZpegQ3H2S4X33gu3VZTf+mjfxMsxTqvLI2f7/fRYeCpNOChadIlBB4PR6qZtXA7c+jMvLLpe
	+Dx9isgjll7B1px7jFv+ZV5jV2Ipzkg01GIuKk4EAKptrTi1AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t9jAd0nXEVBBnv+iFscvF9vMf/IOVaL
	5sXr2SwuL7zEatFx6DGTxY/XF9gsehdcZbO48LSHzWLT42usFgvblrBYXN41h81ixvl9TBaL
	lrUyWxx+085qsX7GaxYHfo/ZDRdZPPbPXcPusXlJvUffllWMHsdvbGfy+LxJLoAtqoHRJiM1
	MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoZCWFssScUqBQ
	QGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxqPXSxkL7nJUtO7ZydLAOJW9i5GTQ0LA
	ROLd5VZmCFtM4sK99WxdjFwcQgKLGCV2v/7FBOFMYZLYcvA+I0gVm4CuRNPbXWC2iICDxJKl
	d8A6mAUOMUks3TuXBSQhLOAn8ezIQjCbRUBV4uXW52A2r4CHxNLrH1kg1ilIvLn9DGg1Bwen
	gKdEQxMvSFgIqOTG0vksExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjs5nUjsY
	VzZYHGIU4GBU4uFl0C0MEmJNLCuuzD3EKMHBrCTCu+0kUIg3JbGyKrUoP76oNCe1+BBjMtBR
	E5mlRJPzgYkjryTe0NjE3NTY1NLEwsTMkjRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoY
	jS2TV2kZzotui9XL3WplFLPafd/Dql5Hr+hz6wR15Kzn5Vxv/5dq9Ougw+IY1oJ/SRqCq43V
	P+32vmfwQuCj48r4T0KBzZcO/45sPsdqx5n3RfSUmdMitu6JAT//Xz+zZi2jjtPFc9O9rOfG
	8D6dN0fL+Kd55LfP3FdtCpS/Mt0oUfGx22GtxFKckWioxVxUnAgA5UpX7RIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree nodes for USB 3.0 PHY present alongwith
USB 3.0 controller Exynos 5420 SoC. This phy driver is
based on generic phy framework.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5420.dtsi |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index d537cd7..5df3308 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -235,4 +235,20 @@
 		io-channel-ranges;
 		status = "disabled";
 	};
+
+	usbphy@12100000 {
+		compatible = "samsung,exynos5420-usb3phy";
+		reg = <0x12100000 0x100 0x10040704 0x4>;
+		clocks = <&clock 366>, <&clock 1>, <&clock 152>;
+		clock-names = "phy", "usb3drd", "sclk_usbphy30";
+		#phy-cells = <0>;
+	};
+
+	usbphy@12500000 {
+		compatible = "samsung,exynos5420-usb3phy";
+		reg = <0x12500000 0x100 0x10040708 0x4>;
+		clocks = <&clock 367>, <&clock 1>, <&clock 153>;
+		clock-names = "phy", "usb3drd", "sclk_usbphy30";
+		#phy-cells = <0>;
+	};
 };
-- 
1.7.6.5

