Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbaDYMP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:15:28 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20365 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbaDYMPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:15:03 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-5b-535a51c6d08a
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, s.nawrocki@samsung.com,
        b.zolnierkie@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 02/10] ARM: EXYNOS: Cleanup "mach-exynos/common.h" file
Date: Fri, 25 Apr 2014 21:32:38 +0900
Message-id: <1398429166-5539-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+Zse6xwKhgg+l3+C02zljParFs0l02
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGuxaOsXdovDb9pZLdbPeM1icfPZdiaLHS2rWRx4
	PFqae9g8Ni+p9+jbsorR4/MmuQCWKC6blNSczLLUIn27BK6MI5s/sBasZat4veszawPjFtYu
	Rk4OCQETiU17nzJB2GISF+6tZ+ti5OIQEljGKHH14FR2mKLjN28xQSQWMUp8mtLGAuG0MUm0
	3VkPVsUmoCvx5P1cZhBbRCBb4krjfTCbWeA9o8Tnw+ogtrCAl8SDGVPZQGwWAVWJSReXg63m
	FXCXmHb7OFCcA2ibgsScSTYgYU4BD4kTyz+yQ+xqZZQ4//s2C8RFu9glLn0yg5gjIPFt8iEW
	iF5ZiU0HmCFKJCUOrrjBMoFReAEjwypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MkFjo28F4
	84D1IcZkoHETmaVEk/OBsZRXEm9obGZkYWpiamxkbmlGmrCSOO+ih0lBQgLpiSWp2ampBalF
	8UWlOanFhxiZODilGhhdTOq42afxGy5lO2TReHBZ+5w30QE3Yj1vB7zZuuQbx4W2ya/CDKsD
	fk/dWRz3+sT9aells6dxJp0tWlAZNGX+ZEa5HZUNX7esfimy4rlP/Ktje05fWHft19X8wEv+
	p1c23XhUEZ8wcbPcxrRXz1ZEMj/6XLrrozT3TX+PNr2ZLw1eRX3k2aW1R4mlOCPRUIu5qDgR
	AO7waB2bAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t9jAd1jgVHBBofOcVtsnLGe1WLZpLts
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mddi0dYv7BaH37SzWqyf8ZrF4uaz7UwWO1pWszjw
	eLQ097B5bF5S79G3ZRWjx+dNcgEsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaW
	FuZKCnmJuam2Si4+AbpumTlAlykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkAD
	CesYM45s/sBasJat4vWuz6wNjFtYuxg5OSQETCSO37zFBGGLSVy4t56ti5GLQ0hgEaPEpylt
	LBBOG5NE25317CBVbAK6Ek/ez2UGsUUEsiWuNN4Hs5kF3jNKfD6sDmILC3hJPJgxlQ3EZhFQ
	lZh0cTnYBl4Bd4lpt48DxTmAtilIzJlkAxLmFPCQOLH8IzvErlZGifO/b7NMYORdwMiwilE0
	tSC5oDgpPddIrzgxt7g0L10vOT93EyM41p5J72Bc1WBxiFGAg1GJh3eCbGSwEGtiWXFl7iFG
	CQ5mJRHeD35RwUK8KYmVValF+fFFpTmpxYcYk4GumsgsJZqcD0wDeSXxhsYmZkaWRmYWRibm
	5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAqJ1haGXT+55lg3lKWvTpHxfjL0/1lnX1
	0UrXTfcLN3tq6rR5WmbVJVZjsXucb0tWlDasFOA6tUuVQ/709oIbN7bqn5/ZLXWNf9qt/1dq
	/ufK3Dj08Vnctr13fuxabB4uqFi9el1mu9LX4J27FCsXMD7cmmuqP71c8Pn+80Wdtdm31TWM
	M2cfUmIpzkg01GIuKk4EAM3FTeL5AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused and unwanted declarations from "mach-exynos/common.h"

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/common.h |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 9ef3f83..31c5964 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -15,14 +15,8 @@
 #include <linux/reboot.h>
 #include <linux/of.h>
 
-void mct_init(void __iomem *base, int irq_g0, int irq_l0, int irq_l1);
-
-struct map_desc;
-void exynos_init_io(void);
-void exynos_restart(enum reboot_mode mode, const char *cmd);
 void exynos_cpuidle_init(void);
 void exynos_cpufreq_init(void);
-void exynos_init_late(void);
 
 void exynos_firmware_init(void);
 
-- 
1.7.10.4

