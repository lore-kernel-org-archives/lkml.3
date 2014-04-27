Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbaD0Htx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:49:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31256 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbaD0HkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:40:06 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-34-535cb4559bdc
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, pullip.cho@samsung.com,
        a.motakis@virtualopensystems.com, grundler@chromium.org,
        joro@8bytes.org, prathyush.k@samsung.com, rahul.sharma@samsung.com,
        sachin.kamat@linaro.org, supash.ramaswamy@linaro.org,
        Varun.Sethi@freescale.com, s.nawrocki@samsung.com, t.figa@samsung.com,
        joshi@samsung.com
Subject: [PATCH v12 28/31] ARM: dts: add System MMU nodes of exynos4210
Date: Sun, 27 Apr 2014 13:08:00 +0530
Message-id: <1398584283-22846-29-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsWyRsSkSjd0S0ywwZfZ5hZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltGi53stksX7GaxaLVbv+MFrMvLWGxUHY48nBeUwesxsusnj8O9zP5LFz
	1l12jzvX9rB5bF5S7zH5xnJGj74tqxg9Pm+S87hy9AxTAFcUl01Kak5mWWqRvl0CV8bFP3IF
	W7kqWi8sZ29g3MTRxcjJISFgInHk9xVmCFtM4sK99WxdjFwcQgJLGSUOrj7GDFM0fdJeFhBb
	SGARo8Tt134QRROYJP4evs8GkmATMJTYfu8KK0hCRGA1o0TfxTPsIA6zwF0miTmr3jGCVAkL
	uEtcuPgczGYRUJWYt/sPkM3BwSvgIdHWVAtiSggoSMyZZANSwQkUfXJnD9Rid4m3p76AzZcQ
	mMohcejgbxaIMQIS3yYfYoHolZXYdADqaEmJgytusExgFF7AyLCKUTS1ILmgOCm9yEivODG3
	uDQvXS85P3cTIzAWT/971reD8eYB60OMyUDjJjJLiSbnA2M5ryTe0NjMyMLUxNTYyNzSjDRh
	JXHeRQ+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwKjDskPcP31auwLFk/ePiz1JZYXUt
	DFO7vbL+LVC+1x39/nRm1EF1hic5Xyb97Pjbtpdj66Pz/Amscx89WbvaeanP8jmXtpy6tyT3
	S+DZmPXCd8MfJUhInK9iNOROCjjBMW37j5QirZ/czw5s23D3V3vjDffAfQuC5z2yi9jsJuU+
	cef1SctlW5RYijMSDbWYi4oTAXwVXkDbAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t9jAd3QLTHBBl2bdC3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFt83/WF3aJ3wVU2i02Pr7FaXN41h81ixvl9TBYXVmxkt/jXe5DRYsqi
	w6wWh9+0s1qc/NPLaNFyvZfJYv2M1ywWq3b9YbSYeWsNi4Owx5OD85g8ZjdcZPH4d7ifyWPn
	rLvsHneu7WHz2Lyk3mPyjeWMHn1bVjF6fN4k53Hl6BmmAK6oBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKDXlBTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGENYwZF//IFWzlqmi9sJy9gXETRxcjJ4eEgInE9El7WSBsMYkL99az
	gdhCAosYJW6/9uti5AKyJzBJ/D18HyzBJmAosf3eFVaQhIjAakaJvotn2EEcZoG7TBJzVr1j
	BKkSFnCXuHDxOZjNIqAqMW/3HyCbg4NXwEOirakWxJQQUJCYM8kGpIITKPrkzh4WiMXuEm9P
	fWGdwMi7gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwpD+T2sG4ssHiEKMAB6MSD+8C
	yZhgIdbEsuLK3EOMEhzMSiK8nNOBQrwpiZVVqUX58UWlOanFhxiTgW6ayCwlmpwPTEJ5JfGG
	xibmpsamliYWJmaWpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cDotWD9DRset3X++/6u
	iPhekbfS60RzoOi5X3Vvy7433jPJuGRqO8OfU+WUuoBQ5/5bHL4FPuerDB1uqr+KTTSXnVnA
	r3r536MLdleD501TUdKxvPUk3uVZ9bEcyztCpWtm9Qq8rTQ7tH2/RcGvObvUd1tw+54NL9ts
	PmmL3uVgVZfk+QelO2yUWIozEg21mIuKEwEc8vHPOAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

This patch adds System MMUs that are specific to exynos4210.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 arch/arm/boot/dts/exynos4210.dtsi |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index cacf614..0b4ece1 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -114,7 +114,7 @@
 		status = "disabled";
 	};
 
-	g2d@12800000 {
+	g2d: g2d@12800000 {
 		compatible = "samsung,s5pv210-g2d";
 		reg = <0x12800000 0x1000>;
 		interrupts = <0 89 0>;
@@ -153,4 +153,25 @@
 			samsung,lcd-wb;
 		};
 	};
+
+	sysmmu_g2d: sysmmu@12A20000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x12A20000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 7>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_G2D>;
+		samsung,power-domain = <&pd_lcd0>;
+		mmu-masters = <&g2d>;
+	};
+
+	sysmmu_fimd1: sysmmu@12220000 {
+		compatible = "samsung,sysmmu-v1";
+		interrupt-parent = <&combiner>;
+		reg = <0x12220000 0x1000>;
+		interrupts = <5 3>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_FIMD1>;
+		samsung,power-domain = <&pd_lcd1>;
+	};
 };
-- 
1.7.9.5

