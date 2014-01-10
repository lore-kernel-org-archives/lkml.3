Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbaAJLom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 06:44:42 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:35878 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaAJLok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:44:40 -0500
X-AuditID: cbfee68f-b7f156d00000276c-f1-52cfdd22515c
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 6/8 v3] ARM: dts: exynos5250/5420: add dt node for sss module
Date: Fri, 10 Jan 2014 17:14:51 +0530
Message-id: <1389354291-32051-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389243621-13245-1-git-send-email-ch.naveen@samsung.com>
References: <1389243621-13245-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWyRsSkRlfp7vkgg0Ur5C1eHtK06H4lY9G7
	4Cqbxf17P5ksLu+aw2Yx4/w+JotF2/4zW6za9YfR4uycQ0wOnB47Z91l99h2QNWjb8sqRo/P
	m+QCWKK4bFJSczLLUov07RK4Mnb0XGAs+MVd8XvjfvYGxg+cXYycHBICJhId39YxQthiEhfu
	rWfrYuTiEBJYyiix8/8tNpiiz0/eQiUWMUosftME5fQzSbTubmACqWITMJM4uGg1O4gtIuAs
	8bt5DStIEbPAAUaJddNPgY0SFvCVeNj2HsxmEVCVWLHjOVgDr4CrxK3vf4Du4ABapyAxZ5IN
	SJhTwE3i55LVLCC2EFDJuXaYUxexSzydIgMxRkDi2+RDLBCtshKbDjBDlEhKHFxxg2UCo/AC
	RoZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGIGhfvrfs/4djHcPWB9iTAYaN5FZSjQ5Hxgr
	eSXxhsZmRhamJqbGRuaWZqQJK4nz3n+YFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBkefc
	h4fatwUili89tLZkxvneSd84d01e8ySGs/ZjW/uhyFmTCnctNyxgqOI1iQzSXd3Xff6x/gq9
	JV+O/pyz0sbptmLNfj6Z1labxNV68Xu9z5VZvJ2ymqVl3caVrmv9eL7OmvJdc+ZZfsMfE0Q5
	3/uvvZM3eeP9y2WPN8+Wf7mt2Ln0iUJ7UJsSS3FGoqEWc1FxIgDHq90fiwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9jAV2lu+eDDB5NFbN4eUjTovuVjEXv
	gqtsFvfv/WSyuLxrDpvFjPP7mCwWbfvPbLFq1x9Gi7NzDjE5cHrsnHWX3WPbAVWPvi2rGD0+
	b5ILYIlqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
	AbpESaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5ixo+cCY8Ev7orfG/ez
	NzB+4Oxi5OSQEDCR+PzkLRuELSZx4d56IJuLQ0hgEaPE4jdNUE4/k0Tr7gYmkCo2ATOJg4tW
	s4PYIgLOEr+b17CCFDELHGCUWDf9FNgoYQFfiYdt78FsFgFViRU7noM18Aq4Stz6/oexi5ED
	aJ2CxJxJNiBhTgE3iZ9LVrOA2EJAJefa1zFOYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10v
	OT93EyM4lp5J72Bc1WBxiFGAg1GJh7dg1vkgIdbEsuLK3EOMEhzMSiK85heAQrwpiZVVqUX5
	8UWlOanFhxiTgY6ayCwlmpwPjPO8knhDYxNzU2NTSxMLEzNL0oSVxHkPtloHCgmkJ5akZqem
	FqQWwWxh4uCUamDsWO/cUnphxpIX2xT5ojItr925IPy5gEti07+zP/4XhMwTntcwOWOu2DKn
	n7pMYbyPD955o+OxcP3/oAYZgSlG89KnF7lxiux7/TGeSc8itElz4VqvBdOZrTPOTRESklvS
	tk2ebw1TRnurVHsvJ+Pjd1kZNaf591wXXGxTLtEuwu6pWFBo+1aJpTgj0VCLuag4EQBrRIPL
	6QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the device tree node for SSS module
found on Exynos5420 and Exynos5250

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
TO: <linux-samsung-soc@vger.kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: <linux-crypto@vger.kernel.org>
---
Changes since v2:
1. Added device tree node for SSS on Exynos5250 aswell

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
+		clocks = <&clock 346>;
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

