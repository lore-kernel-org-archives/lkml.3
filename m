Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694AbaKUNwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 08:52:37 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:21533 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758341AbaKUNwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 08:52:33 -0500
X-AuditID: cbfee68d-f79296d000004278-26-546f439fb33b
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org, balbi@ti.com,
        kishon@ti.com
Cc: linux-omap@vger.kernel.org, gregkh@linuxfoundation.org,
        tomasz.figa@gmail.com, s.nawrocki@samsung.com, robh+dt@kernel.org,
        stern@rowland.harvard.edu, kgene.kim@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 09/11] arm64: exynos: Add bus1 pinctrl node on exynos7
Date: Fri, 21 Nov 2014 19:05:52 +0530
Message-id: <1416576954-11997-10-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com>
References: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSqzvfOT/EoHeitsXB+/UW84+cY7Vo
	u3KQ3aJ58Xo2i94FV9ksLjztYbO4vGsOm8XsJf0sFjPO72OyWLSsldmide8RdovDb9pZLSb8
	vsBmsWrXH0YHPo+ds+6ye2xa1cnmsX/uGnaP2Xd/MHr0bVnF6HH8xnYmj8+b5ALYo7hsUlJz
	MstSi/TtErgy1s5cy1jwn6/i9x+5BsYJPF2MnBwSAiYSPctWMkLYYhIX7q1n62Lk4hASWMoo
	cXj5VnaYol+nX7BCJKYzSqx9fJoFwpnAJHFtwU9WkCo2AV2Jpre7wEaJCMxmlGg7KARSxCxw
	j1Hi8/vvLCAJYQE3iU2PmsGKWARUJTY9XQ62glfAU+JSbyeQzQG0TkFiziQbkDAnULhl/WUm
	EFtIwENiza7djCAzJQTusUsc67vGDDFHQOLb5EMsEL2yEpsOMENcLSlxcMUNlgmMwgsYGVYx
	iqYWJBcUJ6UXGeoVJ+YWl+al6yXn525iBMbP6X/Pencw3j5gfYhRgINRiYfXUDo/RIg1say4
	MvcQoynQhonMUqLJ+cAozSuJNzQ2M7IwNTE1NjK3NFMS51WU+hksJJCeWJKanZpakFoUX1Sa
	k1p8iJGJg1OqgdGjSOXnhtbQqU/Td999xn7vz6QdtW9Xcs9JSNoSaLTC/Hn98erXcdWn7Eo4
	5AViZ37j/XDFsvjz1bz66Mxry9iE1hm33b6gJf0+8t4LOanElFjzpwVP05mOv5GWOL9Rs/TA
	539J/Nvnx0/f36F+OPlM2fPoNvnlnL2xtsebnzPvDlhkXFSYukeJpTgj0VCLuag4EQBmNHB4
	mgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jQd35zvkhBnfOKlocvF9vMf/IOVaL
	tisH2S2aF69ns+hdcJXN4sLTHjaLy7vmsFnMXtLPYjHj/D4mi0XLWpktWvceYbc4/Kad1WLC
	7wtsFqt2/WF04PPYOesuu8emVZ1sHvvnrmH3mH33B6NH35ZVjB7Hb2xn8vi8SS6APaqB0SYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6GYlhbLEnFKg
	UEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bamWsZC/7zVfz+I9fAOIGni5GTQ0LA
	ROLX6ResELaYxIV769m6GLk4hASmM0qsfXyaBcKZwCRxbcFPsCo2AV2Jpre7GEFsEYHZjBJt
	B4VAipgF7jFKfH7/nQUkISzgJrHpUTNYEYuAqsSmp8vZQWxeAU+JS72dQDYH0DoFiTmTbEDC
	nEDhlvWXmUBsIQEPiTW7djNOYORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4Op9J
	7WBc2WBxiFGAg1GJh/fD9LwQIdbEsuLK3EOMEhzMSiK85cL5IUK8KYmVValF+fFFpTmpxYcY
	TYGOmsgsJZqcD0wceSXxhsYm5qbGppYmFiZmlkrivDdu5oYICaQnlqRmp6YWpBbB9DFxcEo1
	MB6/2XBld7OLYnaNWJuoVZkr87f/Cu/vf/yYEfh10Yd7bepmU82vScd9D1zrc2HuhMZm2+MS
	6wVLbweVs3JXRb0+GlBfbWCnx7/4/sXPbzMn/H2qn/cijW92keTBgsmOhxROH7vHxLG6efZp
	6zq53+v0VgQ6Tu4/++fdJsa0w4vf3H1jzymbyKTEUpyRaKjFXFScCADTndxm5AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUS1 pinctrl provides gpios for usb and power regulator
available on exynos7-espresso board. So add relevant device
node for pinctrl-bus1.

Signed-off-by: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm64/boot/dts/exynos/exynos7-pinctrl.dtsi |   26 +++++++++++++++++++++++
 arch/arm64/boot/dts/exynos/exynos7.dtsi         |    7 ++++++
 2 files changed, 33 insertions(+)

diff --git a/arch/arm64/boot/dts/exynos/exynos7-pinctrl.dtsi b/arch/arm64/boot/dts/exynos/exynos7-pinctrl.dtsi
index 2eef4a2..9648e03 100644
--- a/arch/arm64/boot/dts/exynos/exynos7-pinctrl.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos7-pinctrl.dtsi
@@ -335,6 +335,32 @@
 	};
 };
 
+&pinctrl_bus1 {
+	gpf0: gpf0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpf4: gpf4 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gph1: gph1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+};
+
 &pinctrl_nfc {
 	gpj0: gpj0 {
 		gpio-controller;
diff --git a/arch/arm64/boot/dts/exynos/exynos7.dtsi b/arch/arm64/boot/dts/exynos/exynos7.dtsi
index d7a37c3..90048b2 100644
--- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
@@ -26,6 +26,7 @@
 		pinctrl5 = &pinctrl_ese;
 		pinctrl6 = &pinctrl_fsys0;
 		pinctrl7 = &pinctrl_fsys1;
+		pinctrl8 = &pinctrl_bus1;
 	};
 
 	cpus {
@@ -242,6 +243,12 @@
 			interrupts = <0 383 0>;
 		};
 
+		pinctrl_bus1: pinctrl@14870000 {
+			compatible = "samsung,exynos7-pinctrl";
+			reg = <0x14870000 0x1000>;
+			interrupts = <0 384 0>;
+		};
+
 		pinctrl_nfc: pinctrl@14cd0000 {
 			compatible = "samsung,exynos7-pinctrl";
 			reg = <0x14cd0000 0x1000>;
-- 
1.7.10.4

