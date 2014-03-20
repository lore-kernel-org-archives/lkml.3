Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaCTEj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 00:39:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47077 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaCTEjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 00:39:23 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-98-532a70dd7755
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v3 2/4] ARM: select COMMON_CLK_SAMSUNG for ARCH_EXYNOS and
 ARCH_S3C64XX
Date: Thu, 20 Mar 2014 13:55:23 +0900
Message-id: <1395291325-4043-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1395291325-4043-1-git-send-email-pankaj.dubey@samsung.com>
References: <1394598781-3848-1-git-send-email-pankaj.dubey@samsung.com>
 <1395291325-4043-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t8zQ927BVrBBlMa+S02Pb7GanF51xw2
	ixnn9zFZ3L7Ma7Fo6xd2B1aPluYeNo/NS+o9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK6P3
	yVy2guPsFds+azYwzmfrYuTkkBAwkfhzZB8jhC0mceHeeqA4F4eQwDJGiYPH/zPCFG1cuY8d
	IrGIUeL54b/MEE4bk8SpDweZQarYBHQlnryfC2aLCGRLXJp1iwXEZhYIkbj9YhVQnINDWCBS
	YsPueBCTRUBV4tkNMJNXwF3i3iQ2EFNCQEFiziQbkD5OAQ+JO/Pvs0AsamWUWPZhOdhWCYH/
	bBKNZ6YxgVSxCAhIfJt8iAWiWVZi0wFmiJMlJQ6uuMEygVF4ASPDKkbR1ILkguKk9CJTveLE
	3OLSvHS95PzcTYyQ8J24g/H+AetDjMlA4yYyS4km5wPDP68k3tDYzMjC1MTU2Mjc0ow0YSVx
	3vRHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGKdMv5p62cI21mx2SGP1+68SBcxmQanK
	d2L0Fc2PXj73fUevQqJy84+Hz5WCv9zwMl44YXKokPxvq02zbivkVG5XWzbvy8d/7Lc9m+Rq
	jSxWHKxxV25cdPPF7HTlOV3N99RNK4yWV17Sv7hbWIr7WdhZG+kjK86+S6n2Cu0SDJr97+Jz
	BoupQkosxRmJhlrMRcWJAO2GAIx1AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t9jAd27BVrBBgv3cltsenyN1eLyrjls
	FjPO72OyuH2Z12LR1i/sDqweLc09bB6bl9R79G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5K
	Zl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBaJYWyxJxSoFBAYnGxkr4dpgmh
	IW66FjCNEbq+IUFwPUYGaCBhHWNG75O5bAXH2Su2fdZsYJzP1sXIySEhYCKxceU+dghbTOLC
	vfVAcS4OIYFFjBLPD/9lhnDamCROfTjIDFLFJqAr8eT9XDBbRCBb4tKsWywgNrNAiMTtF6uA
	4hwcwgKREht2x4OYLAKqEs9ugJm8Au4S9yaxgZgSAgoScybZgPRxCnhI3Jl/nwViUSujxLIP
	y5knMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcHc+kdzCuarA4xCjAwajEw7ti
	j2awEGtiWXFl7iFGCQ5mJRFea3etYCHelMTKqtSi/Pii0pzU4kOMyUA3TWSWEk3OB0ZuXkm8
	obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwFj4Ns+Dz9fLpzW48
	Pafy6CnnA5lvTB7X+IbKfl1+fy+vQ4Vx8OxXGbKKOvfrs1o3zZi2OGxWn3Fc5NyE28ujXURP
	1ByxPG8l/vCHpX3kvB3p6zynHuDuzl0cM3X73/dRx5T0DbecPbDg2utPMx5/VpXbmfO3MuX+
	Xf3HXz/0qXgY7H3ZOMNcUomlOCPRUIu5qDgRAKKQ3tXSAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch selects COMMON_CLK_SAMSUNG for EXYNOS and S3C64XX SoC
and removes COMMON_CLK selection as COMMON_CLK_SAMSUNG selects it's dependency.

CC: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e254198..0c15aa7 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -755,7 +755,7 @@ config ARCH_S3C64XX
 	select ARM_VIC
 	select CLKDEV_LOOKUP
 	select CLKSRC_SAMSUNG_PWM
-	select COMMON_CLK
+	select COMMON_CLK_SAMSUNG
 	select CPU_V6K
 	select GENERIC_CLOCKEVENTS
 	select GPIO_SAMSUNG
@@ -834,7 +834,7 @@ config ARCH_EXYNOS
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_SPARSEMEM_ENABLE
 	select ARM_GIC
-	select COMMON_CLK
+	select COMMON_CLK_SAMSUNG
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
 	select HAVE_S3C2410_I2C if I2C
-- 
1.7.10.4

