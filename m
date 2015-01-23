Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbbAWO0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:26:20 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:55866 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbbAWOYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:24:02 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-f9-54c25980cbea
From: Jaehoon Chung <jh80.chung@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: kgene@kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Jaehoon Chung <jh80.chung@samsung.com>
Subject: [PATCH] ARM: dts: Add sd0_rst pinctrl node to exynos5420
Date: Fri, 23 Jan 2015 23:23:58 +0900
Message-id: <1422023038-11842-1-git-send-email-jh80.chung@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWyRsSkQLch8lCIwfKdUhbzj5xjtbjxq43V
	ov/xa2aLy7vmsFnMOL+PyYHVY9OqTjaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyuha/Jux
	4CJrxc8PtxkbGM+xdDFyckgImEis2XYTyhaTuHBvPVsXIxeHkMBSRolL194wwxSt3jyJFSIx
	nVHi78UZUE4bk0Trjq1sIFVsAjoS278dZwKxRQRUJT63LWAHsZkFKiTObXwNFhcWcJTY9LYd
	zGYBqpm5fzOYzSvgJrFl53/GLkYOoG0KEnMm2YDMlxB4zCZxdOUjqHoBiW+TD7FA1MhKbDoA
	dZykxMEVN1gmMAouYGRYxSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iREYjqf/PZuwg/HeAetD
	jAIcjEo8vA1bDoYIsSaWFVfmHmI0BdowkVlKNDkfGPR5JfGGxmZGFqYmpsZG5pZmSuK8r6V+
	BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgjP9SxVfNe8baQL57xbtZRbt2GO51kG2znKZd
	us+O6z5L24acma1dbNMTeTzSK/M8N5peVDXYo2hzQN+R4cZcT4mTPA9u6fctX7VlquDz64Eu
	v2+xK/9/4/ygclHRsSDj1pLQnvvM0/z2Rwj3Kif22H4Ofx6+78p9jdnGLx9ceej+ze2uyJ5Z
	SizFGYmGWsxFxYkAC1t7dUICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsVy+t9jQd2GyEMhBiuOC1vMP3KO1eLGrzZW
	i/7Hr5ktLu+aw2Yx4/w+JgdWj02rOtk8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/d
	Vsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2inkkJZYk4pUCggsbhYSd8O04TQEDdd
	C5jGCF3fkCC4HiMDNJCwhjGja/FvxoKLrBU/P9xmbGA8x9LFyMkhIWAisXrzJFYIW0ziwr31
	bF2MXBxCAtMZJf5enMEK4bQxSbTu2MoGUsUmoCOx/dtxJhBbREBV4nPbAnYQm1mgQuLcxtdg
	cWEBR4lNb9vBbBagmpn7N4PZvAJuElt2/mfsYuQA2qYgMWeSzQRG7gWMDKsYRVMLkguKk9Jz
	DfWKE3OLS/PS9ZLzczcxgoP9mdQOxpUNFocYBTgYlXh4G7YcDBFiTSwrrsw9xCjBwawkwmut
	eShEiDclsbIqtSg/vqg0J7X4EKMp0PKJzFKiyfnASMwriTc0NjEzsjQyN7QwMjZXEudVsm8L
	ERJITyxJzU5NLUgtgulj4uCUamBMq5/DySfmour5fp2xyyPlw9e6btw58jhksaJkLhfLsRlG
	D88Gfch9+MKYp3et4relP/Y625yZK7NxTU/vi6WXv/IfvR9x/g7HjwWLp8Vt/RyUu12w+mTv
	XJ4kp8MqPkXJteq/Pjyud/K8uT+ZY+mS0ArJlli3310921e9aj+86v3xf6VP5x8uVWIpzkg0
	1GIuKk4EAKzsatKMAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sd0_rst node to exynos5420-pinctrl.dtsi.
(It's used on odroid-xu3 board)

Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
---
 arch/arm/boot/dts/exynos5420-pinctrl.dtsi |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-pinctrl.dtsi b/arch/arm/boot/dts/exynos5420-pinctrl.dtsi
index ba686e4..315cad7 100644
--- a/arch/arm/boot/dts/exynos5420-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos5420-pinctrl.dtsi
@@ -194,6 +194,11 @@
 			samsung,pin-drv = <3>;
 		};
 
+		sd0_rst: sd0-rst {
+			samsung,pins = "gpd1-0";
+			samsung,pin-function = <1>;
+		};
+
 		sd1_clk: sd1-clk {
 			samsung,pins = "gpc1-0";
 			samsung,pin-function = <2>;
-- 
1.7.9.5

