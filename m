Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaL2AFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 19:05:25 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:40700 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaL2AEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 19:04:31 -0500
X-AuditID: cbfee691-f79b86d000004a5a-73-54a09a877280
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv6 8/9] ARM: dts: exynos: Add PPMU node to Exynos3250-based
 Rinato/Monk board
Date: Mon, 29 Dec 2014 09:04:12 +0900
Message-id: <1419811453-16160-9-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1419811453-16160-1-git-send-email-cw00.choi@samsung.com>
References: <1419811453-16160-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSrNs+a0GIwfWHShaP1yxmsrj+5Tmr
	xfwj51gtJt2fwGLx+oWhRe+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdYtWuP4wO/B5r5q1h9Ng56y67x+I9L5k8Ni+p9+jbsorR4/MmuQC2KC6blNSc
	zLLUIn27BK6M5/OOsBUcFqrY2/2NpYHxA18XIyeHhICJxPfz0xkhbDGJC/fWs3UxcnEICSxl
	lJj4ZhsjTFHz0z5GiMR0Ronjj7qgnCYmib1bprGCVLEJaEnsf3GDDcQWEZCRuLpxOwtIEbNA
	I7PEl2X/mUASwgJxErePNYE1sAioSqyf/hyoiIODV8BVYtvcCohtChLLls8EK+EUcJPYc+IG
	M4gtBFRy/v9BVpCZEgL32CX6965nhpgjIPFt8iGwORICshKbDjBDzJGUOLjiBssERuEFjAyr
	GEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MQLj5/S/ZxN3MN4/YH2IUYCDUYmHd8Kx+SFCrIll
	xZW5hxhNgTZMZJYSTc4HRmleSbyhsZmRhamJqbGRuaWZkjivjvTPYCGB9MSS1OzU1ILUovii
	0pzU4kOMTBycUg2Mhxe+87wdIcs9h8n31dTLB0ROLriw1k3iycoPf9lYtTasCmcU+JN+wP2/
	hct+tUdL1uS/+Fs9Z/F8nzb28p9PLWtmKhjdEjZsWV3cdGqDl4DoAd7uLREF1wJbT1xZ1a+a
	GX1M/2zday3/VfMzLpzKyKubWRV2WqzjOuP/2TJ/lzSvX5EwVTzCQomlOCPRUIu5qDgRAEqV
	4h2aAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jQd32WQtCDLqeS1k8XrOYyeL6l+es
	FvOPnGO1mHR/AovF6xeGFr0LrrJZnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i1W7/jA68HusmbeG0WPnrLvsHov3vGTy2Lyk3qNvyypGj8+b5ALYohoYbTJS
	E1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOATlZSKEvMKQUK
	BSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZjyfd4St4LBQxd7ubywNjB/4uhg5OSQE
	TCSan/YxQthiEhfurWfrYuTiEBKYzihx/FEXI4TTxCSxd8s0VpAqNgEtif0vbrCB2CICMhJX
	N25nASliFmhklviy7D8TSEJYIE7i9rEmsAYWAVWJ9dOfAxVxcPAKuEpsm1sBsU1BYtnymWAl
	nAJuEntO3GAGsYWASs7/P8g6gZF3ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzg6Hwm
	vYNxVYPFIUYBDkYlHt4Jx+aHCLEmlhVX5h5ilOBgVhLhNSpbECLEm5JYWZValB9fVJqTWnyI
	0RToqInMUqLJ+cDEkVcSb2hsYmZkaWRuaGFkbK4kzqtk3xYiJJCeWJKanZpakFoE08fEwSnV
	wGjO84Tr3o/aU9fE/eWmq1ZWSksEN/1YwDVly9Tj7XfrKvfxC12YaGSyrKTo9cYe13/Pj3T8
	a9rI+y79qymHSOzHn5qrNn45kfculjFKnq12xuM8hYLvE425LjUfWXp2yncTAffD33Q+LJU6
	nJJz3O5uCt/913uvTIszEhD7fvi4jFGZ9TzRR6ZKLMUZiYZazEXFiQBOLLd/5AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add PPMU dt node to Exynos3250-base Rinato/Monk board. The PPMU node
is used to get the utilization of DMC0/DMC1/LEFTBUS/RIGHTBUS Block.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250-monk.dts   | 40 +++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos3250-rinato.dts | 40 +++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-monk.dts b/arch/arm/boot/dts/exynos3250-monk.dts
index 24822aa..fcceb59 100644
--- a/arch/arm/boot/dts/exynos3250-monk.dts
+++ b/arch/arm/boot/dts/exynos3250-monk.dts
@@ -420,6 +420,46 @@
 	status = "okay";
 };
 
+&ppmu_dmc0 {
+	status = "okay";
+
+	events {
+		ppmu_dmc0_3: ppmu-event3-dmc0 {
+			event-name = "ppmu-event3-dmc0";
+		};
+	};
+};
+
+&ppmu_dmc1 {
+	status = "okay";
+
+	events {
+		ppmu_dmc1_3: ppmu-event3-dmc1 {
+			event-name = "ppmu-event3-dmc1";
+		};
+	};
+};
+
+&ppmu_leftbus {
+	status = "okay";
+
+	events {
+		ppmu_leftbus_3: ppmu-event3-leftbus {
+			event-name = "ppmu-event3-leftbus";
+		};
+	};
+};
+
+&ppmu_rightbus {
+	status = "okay";
+
+	events {
+		ppmu_rightbus_3: ppmu-event3-rightbus {
+			event-name = "ppmu-event3-rightbus";
+		};
+	};
+};
+
 &xusbxti {
 	clock-frequency = <24000000>;
 };
diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 6ac1e4e..60948ae 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -524,6 +524,46 @@
 	status = "okay";
 };
 
+&ppmu_dmc0 {
+	status = "okay";
+
+	events {
+		ppmu_dmc0_3: ppmu-event3-dmc0 {
+			event-name = "ppmu-event3-dmc0";
+		};
+	};
+};
+
+&ppmu_dmc1 {
+	status = "okay";
+
+	events {
+		ppmu_dmc1_3: ppmu-event3-dmc1 {
+			event-name = "ppmu-event3-dmc1";
+		};
+	};
+};
+
+&ppmu_leftbus {
+	status = "okay";
+
+	events {
+		ppmu_leftbus_3: ppmu-event3-leftbus {
+			event-name = "ppmu-event3-leftbus";
+		};
+	};
+};
+
+&ppmu_rightbus {
+	status = "okay";
+
+	events {
+		ppmu_rightbus_3: ppmu-event3-rightbus {
+			event-name = "ppmu-event3-rightbus";
+		};
+	};
+};
+
 &xusbxti {
 	clock-frequency = <24000000>;
 };
-- 
1.8.5.5

