Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbaD3FBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 01:01:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59721 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbaD3E7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 00:59:46 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-75-5360833cb457
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3 03/12] ARM: EXYNOS: Cleanup "mach-exynos/common.h" file
Date: Wed, 30 Apr 2014 14:17:28 +0900
Message-id: <1398835057-3860-4-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
References: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t8zY12b5oRgg+XPWCyWTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVwZSy994K54DxbxfX1y1gbGK+ydjFyckgImEgsubSE
	EcIWk7hwbz1bFyMXh5DAMkaJ7X9fsMMU/drXyASRWMQosf/GdqiqNiaJrXePgVWxCehKPHk/
	lxnEFhHIlrjSeJ8ZpIhZYDejRGPjPKAODg5hAS+JzZvNQWpYBFQlOj9OZQGxeQXcJV5uWcMM
	UiIhoCAxZ5INSJhTwENi4e3fYJcKAZU0NPQwgoyUEFjHLrF30wUWiDkCEt8mH2KB6JWV2HSA
	GeJoSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjJOwn7mC8f8D6EGMy
	0LiJzFKiyfnAuMkriTc0NjOyMDUxNTYytzQjTVhJnDf9UVKQkEB6YklqdmpqQWpRfFFpTmrx
	IUYmDk6pBsaAjE8bdOUXfVuUyqN5xdzxYMu2e/lbdoTt3uL1O1L95MoOixdZq95y/kv96aAq
	UeKluUxMe3rgf09H2QPb5TenWQeKWMzTuOK8MGzZ7IDpuf4nn2SXbHXYpRO8svpvxo774hej
	P3Ssjgr9+qbmS1SUtUOacTnXAr2rFn+03yQYfFaadHLa7zwlluKMREMt5qLiRAB76O3+kQIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jAV2b5oRggz/JFssm3WWz6F1wlc1i
	0+NrrBaXd81hs5hxfh+Txe3LvBaLtn5ht1g/4zWLxc1n25ksdrSsZnHg8mhp7mHz2Lyk3qNv
	yypGj8+b5AJYohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8
	AnTdMnOAzlFSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZiy994K54Dxb
	xfX1y1gbGK+ydjFyckgImEj82tfIBGGLSVy4t56ti5GLQ0hgEaPE/hvboZw2Jomtd4+xg1Sx
	CehKPHk/lxnEFhHIlrjSeJ8ZpIhZYDejRGPjPKAODg5hAS+JzZvNQWpYBFQlOj9OZQGxeQXc
	JV5uWcMMUiIhoCAxZ5INSJhTwENi4e3fYAcJAZU0NPQwTmDkXcDIsIpRNLUguaA4KT3XSK84
	Mbe4NC9dLzk/dxMjOKaeSe9gXNVgcYhRgINRiYdXYGt8sBBrYllxZe4hRgkOZiUR3vOVCcFC
	vCmJlVWpRfnxRaU5qcWHGJOBjprILCWanA+M97ySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcK
	CaQnlqRmp6YWpBbBbGHi4JRqYGxM+r+2e83ahKtfrrCtbma5GFo261HJu6ZlVed0IvbLmkyN
	W36v9zzHooj5TcXcdzfNT5Vpu3PB5lj4nvzZtvMv+/TZOCiLm147VGRgnV/w+kaBEf9B33kc
	xUtfBa7VXV4evuPBrqgbfY9WL01h4L54K82Pb4t47StXebM6kycq5xY+t+c5ckuJpTgj0VCL
	uag4EQC5R2L77QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused and unwanted declarations from "mach-exynos/common.h"

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/common.h |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 30123a0..8a4aa0b 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -15,15 +15,6 @@
 #include <linux/reboot.h>
 #include <linux/of.h>
 
-void mct_init(void __iomem *base, int irq_g0, int irq_l0, int irq_l1);
-
-struct map_desc;
-void exynos_init_io(void);
-void exynos_restart(enum reboot_mode mode, const char *cmd);
-void exynos_cpuidle_init(void);
-void exynos_cpufreq_init(void);
-void exynos_init_late(void);
-
 void exynos_firmware_init(void);
 
 #ifdef CONFIG_PINCTRL_EXYNOS
-- 
1.7.10.4

