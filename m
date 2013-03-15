Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab3COIFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 04:05:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45634 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab3COIEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 04:04:22 -0400
X-AuditID: cbfee68e-b7f946d000001e37-7a-5142d604f0a4
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, balbi@ti.com,
        rob.herring@calxeda.com, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, grant.likely@secretlab.ca,
        dianders@chromium.org, jg1.han@samsung.com, p.paneri@samsung.com
Subject: [PATCH v5 2/3] ARM: exynos5250: dts: Enabling dwc3-exynos driver
Date: Fri, 15 Mar 2013 13:32:13 +0530
Message-id: <1363334534-21901-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1363334534-21901-1-git-send-email-gautam.vivek@samsung.com>
References: <1363334534-21901-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWyRsSkRpflmlOgwZUdVhYL25awWFzeNYfN
	Ysb5fUwWi5a1MjuweHzeJBfAGMVlk5Kak1mWWqRvl8CV8WKPbsEvzoqN/ycyNjB+Z+9i5OSQ
	EDCROLx+HTOELSZx4d56ti5GLg4hgaWMEpvff2KDKdp35SA7RGIRo8TlVzOgqqYwSfT+/MYK
	UsUmoCvR9HYXI4gtIpAuseDzByYQm1ngO6PEnr2cILawgKfE8i1PwKayCKhK7Np4FszmFfCQ
	eDBnLyPENgWJN7efgZ3ECVT/60IfUJwDaJmHxLZXYHslBJ6zSXzrWskMMUdA4tvkQywgNRIC
	shKbDkB9IylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXGekVJ+YWl+al6yXn525iBIbn6X/P+nYw
	3jxgfYgxGWjcRGYp0eR8YHjnlcQbGpsZWZiamBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBa
	FF9UmpNafIiRiYNTqoExYX1eea3dBQ8t/xYVR/4b1Vd8D/y99Cp0SWXN4rrLaUm3WWVyL1Ss
	vLvMdPtdqZptf3fKxYW8vJwhUtSX6rFC7PQ85pMBRUckrzNO5G6ceMPj8jeWW0nMl1adYPTv
	Cdtu9VDywXoTzaX+v+VK9OUOBd0Xsq5vaT+r1b8oNj9in8m7pGv1zlOVWIozEg21mIuKEwEv
	piIwZQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t9jAV2Wa06BBj0vNSwWti1hsbi8aw6b
	xYzz+5gsFi1rZXZg8fi8SS6AMaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJc
	SSEvMTfVVsnFJ0DXLTMHaImSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCG
	MePFHt2CX5wVG/9PZGxg/M7excjJISFgIrHvykEoW0ziwr31bF2MXBxCAosYJS6/mgHlTGGS
	6P35jRWkik1AV6Lp7S5GEFtEIF1iwecPTCA2s8B3Rok9ezlBbGEBT4nlW56wgdgsAqoSuzae
	BbN5BTwkHszZywixTUHize1nzCA2J1D9rwt9QHEOoGUeEttesU1g5F3AyLCKUTS1ILmgOCk9
	10ivODG3uDQvXS85P3cTIzj4n0nvYFzVYHGIUYCDUYmH1+GhY6AQa2JZcWXuIUYJDmYlEd6P
	F50ChXhTEiurUovy44tKc1KLDzEmAx01kVlKNDkfGJl5JfGGxibmpsamliYWJmaWpAkrifMe
	bLUOFBJITyxJzU5NLUgtgtnCxMEp1cAoEm206+8b8ZtPXj5SexW+Y91CMS1W07OpHQ+1bnhP
	uLTyju3Pg7uebfhnVJL78H613O/X178ttQqI7NNoTg045/xWirOs/Wiikcgsp18Ku3czrJ6f
	qy0Y4XV2+qzyn23B3WdfeXq+ztTJPr3Udk/SQ9f4f6JvXsnxFDkszPpo23L0y7+yj3KblFiK
	MxINtZiLihMBfhbsesICAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding DWC3 device tree node for Exynos5250 needed to
parse device tree data.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 5b6f8c8..e0feedb 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -398,7 +398,23 @@
 		dma-names = "tx", "rx";
 	};
 
-	usbphy@12100000 {
+	usb@12000000 {
+		compatible = "samsung,exynos5250-dwusb3";
+		clocks = <&clock 286>;
+		clock-names = "usbdrd30";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		dwc3 {
+			compatible = "synopsys,dwc3";
+			reg = <0x12000000 0x10000>;
+			interrupts = <0 72 0>;
+			usb-phy = <&usb2_phy &usb3_phy>;
+		};
+	};
+
+	usb3_phy: usbphy@12100000 {
 		compatible = "samsung,exynos5250-usb3phy";
 		reg = <0x12100000 0x100>;
 		clocks = <&clock 1>, <&clock 286>;
@@ -430,7 +446,7 @@
 		clock-names = "usbhost";
 	};
 
-	usbphy@12130000 {
+	usb2_phy: usbphy@12130000 {
 		compatible = "samsung,exynos5250-usb2phy";
 		reg = <0x12130000 0x100>;
 		clocks = <&clock 1>, <&clock 285>;
-- 
1.7.6.5

