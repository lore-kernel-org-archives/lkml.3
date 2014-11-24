Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbaKXK7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:59:36 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:22552 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbaKXK54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:57:56 -0500
X-AuditID: cbfee68e-f79b46d000002b74-e2-54730f303bc2
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com
Cc: jh80.chung@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        yj44.cho@samsung.com, geunsik.lim@samsung.com,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCHv3 1/3] ARM: exynos: Add Exynos-based boards compatible string
 and description
Date: Mon, 24 Nov 2014 19:57:48 +0900
Message-id: <1416826670-29438-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1416826670-29438-1-git-send-email-cw00.choi@samsung.com>
References: <1416826670-29438-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42JZI2JSpGvAXxxicOCOvsX1L89ZLeYfOcdq
	8WdCK5vFpPsTWCxu/GpjtehdcJXN4mzTG3aLTY+vsVpc3jWHzWLG+X1MFkuvX2SymDB9LYtF
	694j7BYzJr9ks9i7czKjA7/HmnlrGD02repk89i8pN6jb8sqRo/Pm+QCWKO4bFJSczLLUov0
	7RK4Mq5tucRWMFOgYt3CVUwNjFd4uxg5OSQETCRmr3zNAmGLSVy4t56ti5GLQ0hgKaPEhucz
	gRwOsKIpU4oh4tMZJQ42TWeBcJqYJF4f6GcF6WYT0JLY/+IGG4gtIhApsXLdD1aQImaBLUwS
	jyb+ACsSFoiXuLizlRnEZhFQlVi6+ARYA6+Aq8SFydsYIc5QkFi2fCZYPaeAm8TKma/YQWwh
	oJo9F+awgwyVELjFLtG7uI8dYpCAxLfJh1ggTpWV2HSAGWKOpMTBFTdYJjAKL2BkWMUomlqQ
	XFCclF5kpFecmFtcmpeul5yfu4kRGDen/z3r28F484D1IUYBDkYlHt4PG4tChFgTy4orcw8x
	mgJtmMgsJZqcD4zOvJJ4Q2MzIwtTE1NjI3NLMyVx3gSpn8FCAumJJanZqakFqUXxRaU5qcWH
	GJk4OKUaGCet/2qy5br1wkncDKJ/Hu6RtW/YN1FQs9m3p7b118VsM/bguS3lTo5bZI926y35
	NMnjdMrLKc7+ab8K9hS/WHy28kOh8Blu3YwLfpNPTrxe6sp1enee75EjNw+d6g5YGSYd8e57
	8SfpSfI7TkaoKz+o2xC2Yd2r2hUCmwTYLjCZWRvsOM6vY63EUpyRaKjFXFScCACyk1K/lgIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t9jQV0D/uIQgxvH1Cyuf3nOajH/yDlW
	iz8TWtksJt2fwGJx41cbq0XvgqtsFmeb3rBbbHp8jdXi8q45bBYzzu9jslh6/SKTxYTpa1ks
	WvceYbeYMfklm8XenZMZHfg91sxbw+ixaVUnm8fmJfUefVtWMXp83iQXwBrVwGiTkZqYklqk
	kJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SukkJZYk4pUCggsbhY
	Sd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHj2pZLbAUzBSrWLVzF1MB4hbeLkYNDQsBEYsqU
	4i5GTiBTTOLCvfVsXYxcHEIC0xklDjZNZ4FwmpgkXh/oZwWpYhPQktj/4gYbiC0iECmxct0P
	VpAiZoEtTBKPJv4AKxIWiJe4uLOVGcRmEVCVWLr4BFgDr4CrxIXJ2xgh1ilILFs+E6yeU8BN
	YuXMV+wgthBQzZ4Lc9gnMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREclc+kdjCu
	bLA4xCjAwajEw/thY1GIEGtiWXFl7iFGCQ5mJRHefYzFIUK8KYmVValF+fFFpTmpxYcYTYGu
	msgsJZqcD0wYeSXxhsYmZkaWRuaGFkbG5krivDdu5oYICaQnlqRmp6YWpBbB9DFxcEo1MNYm
	Lp11Mvx/lgv/9xtuOVFLbL5/Ldk9//3BxapZf7f59Rv8KOzfx61VlLmu5vDqNyvupfK1ZLNJ
	3TiVvXbinpcrJ2++Fda15MLmSPfU7hyHbxdsUrL1hZ0WmZjFbCszb/sabF+tu6tmgcnSW093
	8OpH75Q3/Mxm+Fw3cY29b2mBy9ryT5PveSqxFGckGmoxFxUnAgB5MSgi4AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the missing compatible/description of Exynos-based boards
to remove following build warning.

	WARNING: DT compatible string "samsung,..." appears un-documented --
	check ./Documentation/devicetree/bindings/

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 .../devicetree/bindings/arm/samsung-boards.txt         | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/samsung-boards.txt b/Documentation/devicetree/bindings/arm/samsung-boards.txt
index 2168ed3..1f8287e 100644
--- a/Documentation/devicetree/bindings/arm/samsung-boards.txt
+++ b/Documentation/devicetree/bindings/arm/samsung-boards.txt
@@ -1,11 +1,19 @@
-* Samsung's Exynos4210 based SMDKV310 evaluation board
-
-SMDKV310 evaluation board is based on Samsung's Exynos4210 SoC.
+* Samsung's Exynos SoC based boards
 
 Required root node properties:
     - compatible = should be one or more of the following.
-        (a) "samsung,smdkv310" - for Samsung's SMDKV310 eval board.
-        (b) "samsung,exynos4210"  - for boards based on Exynos4210 SoC.
+	- "samsung,rinato"	- for Exynos3250-based Samsung Gear2 board.
+	- "samsung,smdkv310"	- for Exynos4210-based Samsung SMDKV310 eval board.
+	- "samsung,trats"	- for Exynos4210-based Tizen Reference board.
+	- "samsung,universal_c210" - for Exynos4210-based Samsung board.
+	- "samsung,smdk4412",	- for Exynos4412-based Samsung SMDK4412 eval board.
+	- "samsung,trats2"	- for Exynos4412-based Tizen Reference board.
+	- "samsung,smdk5250"	- for Exynos5250-based Samsung SMDK5250 eval board.
+	- "samsung,xyref5260"	- for Exynos5260-based Samsung board.
+	- "samsung,smdk5410"	- for Exynos5410-based Samsung SMDK5410 eval board.
+	- "samsung,smdk5420"	- for Exynos5420-based Samsung SMDK5420 eval board.
+	- "samsung,sd5v1"	- for Exynos5440-based Samsung board.
+	- "samsung,ssdk5440"	- for Exynos5440-based Samsung board.
 
 Optional:
     - firmware node, specifying presence and type of secure firmware:
-- 
1.8.5.5

