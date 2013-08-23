Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab3HWIIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 04:08:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58970 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab3HWIIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 04:08:07 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-0b-521718651f65
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: rob.herring@calxeda.com, naveenkrishna.ch@gmail.com
Subject: [PATCH v2] ARM: dts: exynos5420/5250: add ADC device tree node
Date: Fri, 23 Aug 2013 13:32:32 +0530
Message-id: <1377244952-25493-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1377166691-5118-1-git-send-email-ch.naveen@samsung.com>
References: <1377166691-5118-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsWyRsSkSjdVQjzI4NksA4v5R86xWvQuuMpm
	senxNVaLy7vmsFnMOL+PyWLRtv/MFodXHGByYPdY8PkKu8fOWXfZPTYvqffo27KK0ePzJrkA
	1igum5TUnMyy1CJ9uwSujE9NixkLzvFUrOvoYmpgXM/VxcjJISFgIrFw00F2CFtM4sK99Wxd
	jFwcQgJLGSW6Hjxjhimaf2oXM0RiOqPEvBnvWSCcHiaJtd9WsIBUsQmYSRxctJodJCEisIBR
	Yu7sLWwgCWYBc4kfb64zgdjCAu4SHc9egcVZBFQlXn76DhbnFXCVePPqNdAgDqB1ChJzJtmA
	hDmBwie/vgS7QkjARWJ++2aoi+axS8z/5AAxRkDi2+RDUK2yEpsOQJVIShxccYNlAqPwAkaG
	VYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxiBQX7637P+HYx3D1gfYkwGGjeRWUo0OR8YJXkl
	8YbGZkYWpiamxkbmlmakCSuJ86q1WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYDR9srh+
	/Q2FIJcpXSaHPVZfNZ70WyHN/b7A71rd0JxQJ6vrryyXVBfd3HBvn7zau7mv1MWSfwsZC731
	3q3F+/uskovvKv4Hcd7LGb4H7F6kWCURuntRWJzy9HWLbAz+BQUtOaHqozc5noFnqrd9ptpL
	58LPztePGU8PmKTRsyaaY2Py310aD5RYijMSDbWYi4oTAVidRVmIAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t9jQd1UCfEgg1WL1C3mHznHatG74Cqb
	xabH11gtLu+aw2Yx4/w+JotF2/4zWxxecYDJgd1jwecr7B47Z91l99i8pN6jb8sqRo/Pm+QC
	WKMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5Q
	UihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGZ8alrMWHCOp2JdRxdTA+N6
	ri5GTg4JAROJ+ad2MUPYYhIX7q1n62Lk4hASmM4oMW/GexYIp4dJYu23FSwgVWwCZhIHF61m
	B0mICCxglJg7ewsbSIJZwFzix5vrTCC2sIC7RMezV2BxFgFViZefvoPFeQVcJd68eg00iANo
	nYLEnEk2IGFOoPDJry/BrhAScJGY376ZeQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5
	uZsYwVH0TGoH48oGi0OMAhyMSjy8E5zFgoRYE8uKK3MPMUpwMCuJ8B74CxTiTUmsrEotyo8v
	Ks1JLT7EmAx01ERmKdHkfGCE55XEGxqbmJsam1qaWJiYWZImrCTOe6DVOlBIID2xJDU7NbUg
	tQhmCxMHp1QDI/tso333jrOwxyaoButUSWos61bsPDzNNSTwgqMVi5/vF1XdtVc7agUWTl6R
	e/LoXL8dn66W1Vxcy/MvVzFOm63e7mVzz2bHN/f+8WrFrt9wyeWMYugJt9Ufj56+UHcpM+Ln
	I0O+sxJFvbsfhbrt2tFZyp78b9rP7suKZkezrlw+6/Z/esK310osxRmJhlrMRcWJAOBysAvm	AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ADC device tree node for exynos5420 and exynos5250

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---

Added recipients accordingly,
./scripts/get_maintainer.pl  -f of the modified files

 arch/arm/boot/dts/exynos5250.dtsi |   11 +++++++++++
 arch/arm/boot/dts/exynos5420.dtsi |   11 +++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 1eec646..518f8cd 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -641,4 +641,15 @@
 		clocks = <&clock 133>, <&clock 339>;
 		clock-names = "sclk_fimd", "fimd";
 	};
+
+	adc: adc@12D10000 {
+		compatible = "samsung,exynos-adc-v1";
+		reg = <0x12D10000 0x100>, <0x10040718 0x4>;
+		interrupts = <0 106 0>;
+		clocks = <&clock 303>;
+		clock-names = "adc";
+		#io-channel-cells = <1>;
+		io-channel-ranges;
+		status = "disabled";
+	};
 };
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 5353e32..0c5c055 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -218,4 +218,15 @@
 		clocks = <&clock 147>, <&clock 421>;
 		clock-names = "sclk_fimd", "fimd";
 	};
+
+	adc: adc@12D10000 {
+		compatible = "samsung,exynos-adc-v2";
+		reg = <0x12D10000 0x100>, <0x10040720 0x4>;
+		interrupts = <0 106 0>;
+		clocks = <&clock 270>;
+		clock-names = "adc";
+		#io-channel-cells = <1>;
+		io-channel-ranges;
+		status = "disabled";
+	};
 };
-- 
1.7.9.5

