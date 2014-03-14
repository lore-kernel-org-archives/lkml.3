Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbaCNFBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:01:36 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9394 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaCNFBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:01:33 -0400
X-AuditID: cbfee690-b7f266d00000287c-53-53228d2907f2
Date: Fri, 14 Mar 2014 14:01:29 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v11 01/27] iommu/exynos: do not include removed header
Message-id: <20140314140129.68a41cc1bd9e0a48a198ca13@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zfV3NXqVgg9ufdC3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4Mr4MVu14CBHxe2/65kaGCewdzFyckgImEhsb13FCmGL
	SVy4t56ti5GLQ0hgGaNEz+q3LDBFtz6sgUosYpR4d6uNEcKZzCTxeE4HE0gVi4CqxLQXJ5lB
	bDYBLYnVc4+DFYkItDFJfG08xALiMAvMZZZ4tvYp2EJhATeJBWtuge3gFXCUmHy7BWqfhcSF
	pg52iLigxI/J98DizEBTN29rYoWw5SU2r3nLDDJUQqCTQ2L1rDmsEGcISHybDLKNAyghK7Hp
	ADPETEmJgytusExgFJmFZOwsJGNnIRm7gJF5FaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZI
	/E7YwXjvgPUhxmSglROZpUST84Hxn1cSb2hsZmRhamJqbGRuaUaasJI4r9qjpCAhgfTEktTs
	1NSC1KL4otKc1OJDjEwcnFINjJZ3+/ap+dUKnDaX5rtSIdz6cs+Ve39+7WeMF3vAMPsKV2Pg
	a9GIymWiKS8rtKqWTJE2cJD/oMp28FO8bkZ168V+x85d192vpkz5ulHhrc456Y/ZbT43FII2
	/Uhi2CdrV75SIdGD7amDffM9ixdni5adNF/5l39Hd/flyrCeTXwvFhn0916wUWIpzkg01GIu
	Kk4EALrygkD1AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jAV3NXqVgg77JGhZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls9j0+BqrxeVdc9gsZpzfx2RxYcVGdospiw6zWhx+085qcfJP
	L6PF+hmvWSxm3lrD4sDv8eTgPCaP2Q0XWTz+He5n8rhzbQ+bx+Yl9R6Tbyxn9OjbsorR4/Mm
	OY8rR88wBXBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gB9oKRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM+DFbteAgR8Xt
	v+uZGhgnsHcxcnJICJhI3Pqwhg3CFpO4cG89kM3FISSwiFHi3a02RghnMpPE4zkdTCBVLAKq
	EtNenGQGsdkEtCRWzz0OViQi0MYk8bXxEAuIwywwl1ni2dqnrCBVwgJuEgvW3GIBsXkFHCUm
	325hgdhnIXGhqYMdIi4o8WPyPbA4M9DUzduaWCFseYnNa94yT2Dkm4WkbBaSsllIyhYwMq9i
	FE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE4Oz6R3MK5qsDjEKMDBqMTDO+OoYrAQa2JZcWXu
	IUYJDmYlEd6qCKVgId6UxMqq1KL8+KLSnNTiQ4zJQH9PZJYSTc4HJq68knhDYxMzI0sjMwsj
	E3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamC0rOWWXZbMb8ERc1Ik6pJh0M8zm9+J
	HlC8EPqmb2dkibruxOwjkVu2ia3clLxj1uHXkxdvSYxcYZFlyjQ//lGfOTOvnNO634a+jA9X
	Sco32O4QnPfnwC3jny1Hvid0XbsUGbZHXDGot6Im+f+M4If/OAuKTzytDQrn6J5dEKb5/IKq
	xpavHGuVWIozEg21mIuKEwFdBdMYUgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 25e9d28d92 (ARM: EXYNOS: remove system mmu initialization from
exynos tree) removed arch/arm/mach-exynos/mach/sysmmu.h header without
removing remaining use of it from exynos-iommu driver, thus causing a
compilation error.

This patch fixes the error by removing respective include line
from exynos-iommu.c.

CC: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 0740189..4876d35 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -12,6 +12,7 @@
 #define DEBUG
 #endif
 
+#include <linux/kernel.h>
 #include <linux/io.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
@@ -29,8 +30,6 @@
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 
-#include <mach/sysmmu.h>
-
 /* We does not consider super section mapping (16MB) */
 #define SECT_ORDER 20
 #define LPAGE_ORDER 16
-- 
1.7.9.5

