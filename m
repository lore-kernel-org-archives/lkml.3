Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaDYMP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:15:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39628 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbaDYMPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:15:05 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-e2-535a51c8ed01
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, s.nawrocki@samsung.com,
        b.zolnierkie@samsung.com
Subject: [PATCH v2 05/10] ARM: EXYNOS: Remove regs-pmu.h header dependency from
 pm_domain
Date: Fri, 25 Apr 2014 21:32:41 +0900
Message-id: <1398429166-5539-6-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42I5/e+Zse6JwKhgg9YGZYuNM9azWiybdJfN
	onfBVTaLTY+vsVpc3jWHzWLG+X1MFrcv81ocftPOarF+xmsWi5vPtjNZ7GhZzeLA7dHS3MPm
	sXlJvUffllWMHp83yQWwRHHZpKTmZJalFunbJXBlvDyzmq3gNnfFt99nmBsYP3N2MXJySAiY
	SHxcsZgZwhaTuHBvPVsXIxeHkMAyRol1V8+wwhQdOdfMBGILCSxilFi2qByiqI1J4mX3HbAE
	m4CuxJP3c8EmiQhkS1xpvM8MUsQscIRR4vabY2BFwgLREqdX3WIEsVkEVCV2PNjIBmLzCrhL
	7OhZBbSNA2ibgsScSTYgYU4BD4kTyz+yQyxrZZQ4//s2C4gjIbCNXWLOiStsEIMEJL5NPsQC
	0SwrsekA1DuSEgdX3GCZwCi8gJFhFaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZIDPTuYLx9
	wPoQYzLQuInMUqLJ+cAYyiuJNzQ2M7IwNTE1NjK3NCNNWEmcN+lhUpCQQHpiSWp2ampBalF8
	UWlOavEhRiYOTqkGRtawd7yzuKsVxDdyV3D8vXc1VY374XeVBY53OKpypMPX1ISbR7p6c/Z2
	9US42TkEqqSmcMyr7Lm65EBi4hvxBU8Xz1/F1f3ifme1j5H//qzmRfcZlNh1RYyvSIq9lP1s
	d++roZJo7h3m6glrRPgvfpyXbWjQZBRU/+3yovVBx2dzfJlVlDpbiaU4I9FQi7moOBEAEnLa
	w5cCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jAd0TgVHBBisOyVlsnLGe1WLZpLts
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mdfi8Jt2Vov1M16zWNx8tp3JYkfLahYHbo+W5h42
	j81L6j36tqxi9Pi8SS6AJaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEv
	MTfVVsnFJ0DXLTMH6CglhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8bL
	M6vZCm5zV3z7fYa5gfEzZxcjJ4eEgInEkXPNTBC2mMSFe+vZQGwhgUWMEssWlXcxcgHZbUwS
	L7vvgBWxCehKPHk/lxnEFhHIlrjSeJ8ZpIhZ4AijxO03x8CKhAWiJU6vusUIYrMIqErseLAR
	bCqvgLvEjp5VrF2MHEDbFCTmTLIBCXMKeEicWP6RHWJZK6PE+d+3WSYw8i5gZFjFKJpakFxQ
	nJSea6RXnJhbXJqXrpecn7uJERxhz6R3MK5qsDjEKMDBqMTDO0E2MliINbGsuDL3EKMEB7OS
	CO8Hv6hgId6UxMqq1KL8+KLSnNTiQ4zJQFdNZJYSTc4HRn9eSbyhsYmZkaWRmYWRibk5acJK
	4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTDyewoG/VXdNKOhobTXxNFZNNMgPfuMKY+mtK0G
	g8/Ta3I7nU4//uyVynBO+u/bZdyVGw3dMpcFTF9tLiWp8mj614bw+l95RivatWzdC173ibz6
	/H0TQ+39eJOaZ9tiNaRdo798btvz5emG5h7mhT/UGCynr0y+//vFrmcKP7gXRX75UPxWtEuJ
	pTgj0VCLuag4EQCGHG189AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Young-Gun Jang <yg1004.jang@samsung.com>

Current "pm_domain.c" file uses "S5P_INT_LOCAL_PWR_EN" definition from
"regs-pmu.h" and hence needs to include this header file. As there is
no other user of "S5P_INT_LOCAL_PWR_EN" definition other than pm_domain,
to remove "regs-pmu.h" header file dependency from "pm_domain.c"  it's
better we define this definition in "pm_domain.c" file itself and thus it
will help in removing header file inclusion from "pm_domain.c".

Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
---
 arch/arm/mach-exynos/pm_domains.c |    2 +-
 arch/arm/mach-exynos/regs-pmu.h   |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/pm_domains.c b/arch/arm/mach-exynos/pm_domains.c
index fe6570e..f676b0a 100644
--- a/arch/arm/mach-exynos/pm_domains.c
+++ b/arch/arm/mach-exynos/pm_domains.c
@@ -22,7 +22,7 @@
 #include <linux/of_platform.h>
 #include <linux/sched.h>
 
-#include "regs-pmu.h"
+#define S5P_INT_LOCAL_PWR_EN 0x7
 
 /*
  * Exynos specific wrapper around the generic power domain
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index 4ee706d..bfebe84 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -116,7 +116,6 @@
 #define S5P_PAD_RET_EBIB_OPTION			S5P_PMUREG(0x31A8)
 
 #define S5P_CORE_LOCAL_PWR_EN			0x3
-#define S5P_INT_LOCAL_PWR_EN			0x7
 
 #define S5P_CHECK_SLEEP				0x00000BAD
 
-- 
1.7.10.4

