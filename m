Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaGGDxu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 23:53:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60152 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaGGDxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 23:53:36 -0400
X-AuditID: cbfee690-b7fb56d000003439-81-53ba19bfaac4
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        chow.kim@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v6 1/6] ARM: EXYNOS: Make exynos machine_ops as static
Date: Mon, 07 Jul 2014 09:20:51 +0530
Message-id: <1404705056-11965-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1404705056-11965-1-git-send-email-pankaj.dubey@samsung.com>
References: <1404705056-11965-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42JZI2JSrbtfclewwc0XyhbLJt1ls/i+6wu7
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rX4dPQ/q8WirUAV62e8ZrG4+Ww7kwO3R0tzD5vH
	5iX1Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJUx7cxe9oJ2wYq9qztYGhi38XUxcnJICJhI
	dLf8YoGwxSQu3FvP1sXIxSEksJRRonP2VCaYooZdx1ggEtMZJZafnswM4UxgkrjyYAc7SBWb
	gK7Ek/dzmUFsEYFsif7bq8E6mAVOMUrM3jwNrEhYwE1i+dqvQAkODhYBVYneexEgYV4BD4ne
	m3uYQMISAgoScybZgIQ5BTwllnyYBDZSCKjk7rlDjCAjJQTWsUvM3HUaLMEiICDxbfIhFohe
	WYlNB5ghjpaUOLjiBssERuEFjAyrGEVTC5ILipPSi0z0ihNzi0vz0vWS83M3MQIj4PS/ZxN2
	MN47YH2IMRlo3ERmKdHkfGAE5ZXEGxqbGVmYmpgaG5lbmpEmrCTOq/YoKUhIID2xJDU7NbUg
	tSi+qDQntfgQIxMHp1QDY3Fwt7ewgWHeogDPi4F1Rx4e3+Xo8mmxuPJyjknmG7/OWXtRifN3
	w/0rN9fs7Dzk/MihWX9/weynL6ZHPJUq3v85S8vn+BmrNHm75RsnT9xeY/aV4cLEcyevT2xe
	y9ax6sZk8U1rL1co/1nu22N0bPHLWgFuw+e9BzZyfXaqeGJwJH6ZNvNGgXQlluKMREMt5qLi
	RADS9jtplgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t9jQd39kruCDTZflrFYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWqWD/jNYvFzWfbmRy4PVqae9g8
	Ni+p9+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygo5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGdPO
	7GUvaBes2Lu6g6WBcRtfFyMnh4SAiUTDrmMsELaYxIV769m6GLk4hASmM0osPz2ZGcKZwCRx
	5cEOdpAqNgFdiSfv5zKD2CIC2RL9t1ezgBQxC5xilJi9eRpYkbCAm8TytV+BEhwcLAKqEr33
	IkDCvAIeEr039zCBhCUEFCTmTLIBCXMKeEos+TAJbKQQUMndc4cYJzDyLmBkWMUomlqQXFCc
	lJ5rpFecmFtcmpeul5yfu4kRHF/PpHcwrmqwOMQowMGoxMN7YNXOYCHWxLLiytxDjBIczEoi
	vGfcgEK8KYmVValF+fFFpTmpxYcYTYFumsgsJZqcD4z9vJJ4Q2MTc1NjU0sTCxMzSyVx3oOt
	1oFCAumJJanZqakFqUUwfUwcnFINjC1FW151R7m1eTJ27ukIeMskqfhu65L9J//82HPnkbr7
	v7eb26dvazEzdZi5cXbY7Gk5dmGLe6cUR7/uX7Fupxfv5I0ta4IVVP0lFXaucTWLOOJRd0VO
	5FOKLsNGvhu8YS7dBsL3/H97OKpM2LveYn/v/izJX0d52ZnK7rgc5Zsiq3znWITFbyWW4oxE
	Qy3mouJEAASwSajFAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As machine function ops are used only in this file let's make
them static. Also remove unused and unwanted declarations from
common.h.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/common.h |    8 --------
 arch/arm/mach-exynos/exynos.c |    6 +++---
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 3371669..152b464 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -111,17 +111,9 @@ IS_SAMSUNG_CPU(exynos5800, EXYNOS5800_SOC_ID, EXYNOS5_SOC_MASK)
 #define soc_is_exynos5() (soc_is_exynos5250() || soc_is_exynos5410() || \
 			  soc_is_exynos5420() || soc_is_exynos5800())
 
-void mct_init(void __iomem *base, int irq_g0, int irq_l0, int irq_l1);
-
-struct map_desc;
 extern void __iomem *sysram_ns_base_addr;
 extern void __iomem *sysram_base_addr;
-void exynos_init_io(void);
-void exynos_restart(enum reboot_mode mode, const char *cmd);
 void exynos_sysram_init(void);
-void exynos_cpuidle_init(void);
-void exynos_cpufreq_init(void);
-void exynos_init_late(void);
 
 void exynos_firmware_init(void);
 
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 471422e..ff60b4c 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -143,7 +143,7 @@ static struct map_desc exynos5_iodesc[] __initdata = {
 	},
 };
 
-void exynos_restart(enum reboot_mode mode, const char *cmd)
+static void exynos_restart(enum reboot_mode mode, const char *cmd)
 {
 	struct device_node *np;
 	u32 val = 0x1;
@@ -206,7 +206,7 @@ void __init exynos_sysram_init(void)
 	}
 }
 
-void __init exynos_init_late(void)
+static void __init exynos_init_late(void)
 {
 	if (of_machine_is_compatible("samsung,exynos5440"))
 		/* to be supported later */
@@ -253,7 +253,7 @@ static void __init exynos_map_io(void)
 		iotable_init(exynos5_iodesc, ARRAY_SIZE(exynos5_iodesc));
 }
 
-void __init exynos_init_io(void)
+static void __init exynos_init_io(void)
 {
 	debug_ll_io_init();
 
-- 
1.7.9.5

