Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760499AbaGRGBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 02:01:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33985 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbaGRF7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 01:59:54 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-1a-53c8b7d8ba56
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com
Cc: kgene.kim@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, kyungmin.park@samsung.com,
        t.figa@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv6 4/4] ARM: dts: Fix wrong compatible string for Exynos3250 ADC
Date: Fri, 18 Jul 2014 14:59:46 +0900
Message-id: <1405663186-26464-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsWyRsSkSPfG9hPBBjvui1rcfX6Y0eL6l+es
	FvOPnGO16H+zkNXi3KuVjBYPmlYxWfQuuMpmcbbpDbvFpsfXWC0Wti1hsZh35B2LxeVdc9gs
	Zpzfx2Sx9PpFJosJ09eyWLy9M53FonXvEXaL9TNeszgIeayZt4bR43JfL5PHyuVf2Dw2r9Dy
	2LSqE8hYUu/Rt2UVo8fnTXIBHFFcNimpOZllqUX6dglcGQ2LH7IUHOSs6G0Pa2D8xN7FyMkh
	IWAi8fXvc1YIW0ziwr31bF2MXBxCAksZJfYdfsIGUzTvZTMzRGIRo8S31Z1QThOTxOHZm5lA
	qtgEtCT2v7gB1iEioC0xYWEH2Chmgb3MEtvXv2cGSQgL+Euc3HYQyObgYBFQlTjy2AwkzCvg
	KtHTeJAZYpucxIc9j8DO4xRwk/jXexXsPCGgmkl955lAZkoI/GSXmHb0OlgRi4CAxLfJh1hA
	ZkoIyEpsOgA1R1Li4IobLBMYhRcwMqxiFE0tSC4oTkovMtUrTswtLs1L10vOz93ECIy30/+e
	TdzBeP+A9SHGZKBxE5mlRJPzgfGaVxJvaGxmZGFqYmpsZG5pRpqwkjhv+qOkICGB9MSS1OzU
	1ILUovii0pzU4kOMTBycUg2MzGVRM1rz1HXP8/5yy1d2sJ+i2uDh8rtmb3LA7lwOQS62NZ8Y
	BHcbTV7okcPFnTalkbE7dg7bs8N3r79jUwsx298nekzRd3qtGxO7y5e/GlP2spyXSa5cbKXZ
	zCbwUeF+/d4ppZETDq0Tu3ptx7VZGfusboX1XpX/opsVdUZzbdiaD/Xpl/mUWIozEg21mIuK
	EwH9AXW5zQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t9jAd0b208EG6zZz2tx9/lhRovrX56z
	Wsw/co7Vov/NQlaLc69WMlo8aFrFZNG74CqbxdmmN+wWmx5fY7VY2LaExWLekXcsFpd3zWGz
	mHF+H5PF0usXmSwmTF/LYvH2znQWi9a9R9gt1s94zeIg5LFm3hpGj8t9vUweK5d/YfPYvELL
	Y9OqTiBjSb1H35ZVjB6fN8kFcEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqY
	KynkJeam2iq5+AToumXmAP2ipFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSs
	YcxoWPyQpeAgZ0Vve1gD4yf2LkZODgkBE4l5L5uZIWwxiQv31rN1MXJxCAksYpT4trqTGcJp
	YpI4PHszE0gVm4CWxP4XN9hAbBEBbYkJCzvAOpgF9jJLbF//HmyUsIC/xMltB4FsDg4WAVWJ
	I4/NQMK8Aq4SPY0HobbJSXzY8wjsCk4BN4l/vVdZQWwhoJpJfeeZJjDyLmBkWMUomlqQXFCc
	lJ5rpFecmFtcmpeul5yfu4kRHM3PpHcwrmqwOMQowMGoxMNrcfN4sBBrYllxZe4hRgkOZiUR
	3uz7QCHelMTKqtSi/Pii0pzU4kOMpkBHTWSWEk3OByaavJJ4Q2MTMyNLI3NDCyNjcyVx3oOt
	1oFCAumJJanZqakFqUUwfUwcnFINjD5v1iQvffXu+LG4+D1njdd8EP5X9NbMg7PVmF+r7bad
	sl3VbpMZz9UdVc/zHjumek7JzXLJPSVZ1dKHHVwOMu/PRbl7vozI+5rFnuzR5ij6Xkj8qZNP
	OsNnrndcE7P49j868LH6d1qIRT9Dz6Ul3Kbs7VIdTGdt5/DuVPtWEnF9Oa9WQNFVJZbijERD
	Leai4kQA5+AfwPwCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fix wrong compatible string for Exynos3250 ADC. Exynos3250 SoC
need to control only special clock for ADC. Exynos SoC except for Exynos3250
has not included special clock for ADC. The exynos ADC driver can control
special clock if compatible string is 'exynos3250-adc-v2'.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 3d3c45b..e039818 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -391,10 +391,10 @@
 		};
 
 		adc: adc@126C0000 {
-			compatible = "samsung,exynos-adc-v3";
+			compatible = "samsung,exynos3250-adc-v2";
 			reg = <0x126C0000 0x100>, <0x10020718 0x4>;
 			interrupts = <0 137 0>;
-			clock-names = "adc", "sclk_tsadc";
+			clock-names = "adc", "sclk_adc";
 			clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
 			#io-channel-cells = <1>;
 			io-channel-ranges;
-- 
1.8.0

