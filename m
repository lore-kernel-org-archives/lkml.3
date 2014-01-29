Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaA2Jb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:31:26 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16462 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaA2JY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:24:57 -0500
X-AuditID: cbfee690-b7f266d00000287c-ab-52e8c8e8c732
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 6/9 v5] ARM: dts: exynos5250/5420: add dt node for sss module
Date: Wed, 29 Jan 2014 14:54:47 +0530
Message-id: <1390987487-18830-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389777397-15193-1-git-send-email-ch.naveen@samsung.com>
References: <1389777397-15193-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWyRsSkWvfFiRdBBqs/8Fi8PKRpMf/IOVaL
	7lcyFr0LrrJZ3L/3k8ni8q45bBYzzu9jsli07T+zxdk5h5gcOD12zrrL7rHtgKpH35ZVjB6f
	N8kFsERx2aSk5mSWpRbp2yVwZTzcf5Ot4DlPxdZdU5gaGE9xdTFyckgImEjMu9PCDGGLSVy4
	t56ti5GLQ0hgKaNET+sydpii/gc72CES0xklDtxdzAKSEBLoZ5LY9tMXxGYTMJM4uGg1WIOI
	gLPE7+Y1rCANzAJHGSUu7z4ElhAW8JVYu6GBDcRmEVCV6F3zkBHE5hVwlZgx+S/QGRxA2xQk
	5kyyAQlzCrhJTD2+EWqXq8STv/9YIQ5axi5x6pcvxBgBiW+TD7FAtMpKbDoA9YykxMEVN1gm
	MAovYGRYxSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iREY6Kf/PZuwg/HeAetDjMlA4yYyS4km
	5wMjJa8k3tDYzMjC1MTU2Mjc0ow0YSVxXrVHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUa
	GKcuOtjieKucaZ5B8swVbLa2n2w1c0qnsyz+sT5+jfGs/CmWf62LwvZ8LPnUmNdpZRfHLv+k
	d+7CawsUKpfu2HHg9kGj+CkXhBvfh8/1M5XpNFv8Lt8gxUH4R3y+X9GErq1Z4i4pH70eMtjO
	uObk0qP7LV5bb+f0U/LvbuiVxwhO/v69iXNDnRJLcUaioRZzUXEiAGuneamKAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jQd0XJ14EGcx/y2zx8pCmxfwj51gt
	ul/JWPQuuMpmcf/eTyaLy7vmsFnMOL+PyWLRtv/MFmfnHGJy4PTYOesuu8e2A6oefVtWMXp8
	3iQXwBLVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZ
	A3SJkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHj4f6bbAXPeSq27prC
	1MB4iquLkZNDQsBEov/BDnYIW0ziwr31bF2MXBxCAtMZJQ7cXcwCkhAS6GeS2PbTF8RmEzCT
	OLhoNViDiICzxO/mNawgDcwCRxklLu8+BJYQFvCVWLuhgQ3EZhFQlehd85ARxOYVcJWYMfkv
	cxcjB9A2BYk5k2xAwpwCbhJTj2+E2uUq8eTvP9YJjLwLGBlWMYqmFiQXFCel5xrqFSfmFpfm
	pesl5+duYgRH0jOpHYwrGywOMQpwMCrx8K64+DxIiDWxrLgy9xCjBAezkgjviU0vgoR4UxIr
	q1KL8uOLSnNSiw8xJgMdNZFZSjQ5HxjleSXxhsYm5qbGppYmFiZmlqQJK4nzHmi1DhQSSE8s
	Sc1OTS1ILYLZwsTBKdXAuPScl0/+yt8rVxqU5d7XPCMm8CI69du1Km+73fIhHIp7tPYYJs14
	V/u5tezw64vS5dq9hSc9TjjbXwpKthI64rP2zpLl97/X/jvLMq/XaIOmhXnYGc25W5gnW1YJ
	uOh7vLiZ7M7hmnovvj5ry247v8nl38WqvHZoMrc9njcz7mfZTNYXkVu3KLEUZyQaajEXFScC
	AHoGq0DoAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the device tree node for SSS module
found on Exynos5420 and Exynos5250

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
TO: <linux-samsung-soc@vger.kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: <linux-crypto@vger.kernel.org>
---
Changes since v4:
None
Changes since v3:
1. Modified the SSS clock ID as per dt-bindings for Exynos5250 in
   samsung-clk.git tree.

 arch/arm/boot/dts/exynos5250.dtsi |    8 ++++++++
 arch/arm/boot/dts/exynos5420.dtsi |   10 ++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index c341e55..1d249df 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -704,4 +704,12 @@
 		io-channel-ranges;
 		status = "disabled";
 	};
+
+	sss@10830000 {
+		compatible = "samsung,exynos4210-secss";
+		reg = <0x10830000 0x10000>;
+		interrupts = <0 112 0>;
+		clocks = <&clock 348>;
+		clock-names = "secss";
+	};
 };
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 11dd202..56a3f3e 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -652,4 +652,14 @@
 		clocks = <&clock 319>, <&clock 318>;
 		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
 	};
+
+	sss@10830000 {
+		compatible = "samsung,exynos4210-secss";
+		reg = <0x10830000 0x10000>;
+		interrupts = <0 112 0>;
+		clocks = <&clock 471>;
+		clock-names = "secss";
+		samsung,power-domain = <&g2d_pd>;
+	};
+
 };
-- 
1.7.9.5

