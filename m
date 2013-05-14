Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab3ENBTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:19:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13689 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab3ENBTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:19:45 -0400
X-AuditID: cbfee68e-b7f276d000002279-a8-5191912caf36
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: EXYNOS: add PM dependency to PM_GENERIC_DOMAINS for
 Exynos4210
Date: Tue, 14 May 2013 10:19:40 +0900
Message-id: <001a01ce5041$1b9ddd30$52d99790$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5QQPv+I07TYJ0PRkOy30RMNp0g0w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t8zfV2diRMDDR5fMre4vPASq0Xvgqts
	FpseX2O1uLxrDpvFjPP7mBxYPTYvqffo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujM3L3jAX
	fOWveLr0LUsDYwdfFyMHh4SAicSVBZpdjJxAppjEhXvr2boYuTiEBJYxSkz4Pp0ZImEiMev7
	AlaIxCJGiZ7OL8wQzi9GidXtfWBVbAJqEl++HGYHsUUENCSe7j7CCFLELNDLKPFtwlOwhLBA
	mMTJT1/YQGwWAVWJvovvweK8ApYSK+6vZISwBSV+TL7HAmIzC2hJrN95nAnClpfYvOYt1EkK
	EjvOvmaEWKYn0XdwJjNEjYjEvhfvwBZLCGxil3jV+osdYpmAxLfJh1ggfpaV2HQAao6kxMEV
	N1gmMIrNQrJ6FpLVs5CsnoVkxQJGllWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYIXHWt4Px
	5gHrQ4zJQOsnMkuJJucD4zSvJN7Q2MzIwtTE1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi
	+KLSnNTiQ4xMHJxSDYw+Ze1beOf7r+A88XSuZMA+Q+XpbW9Xf9y17aFd7OyTx3bcSdj7Xlw2
	2W6OivH1esPDS4sNj1neqjDoy37JcD3TXuMii9C5c5ybf5tculKbdeDhPfmta/xKDi+x/7zs
	k0NUfsUstgduezdsncD5q8Hmc+BnvjsTP53JXHY1NsNXxiq6cIfIm9VnlFiKMxINtZiLihMB
	tOdh3skCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t9jAV2diRMDDe5sMra4vPASq0Xvgqts
	FpseX2O1uLxrDpvFjPP7mBxYPTYvqffo27KK0ePzJrkA5qgGRpuM1MSU1CKF1Lzk/JTMvHRb
	Je/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoJVKCmWJOaVAoYDE4mIlfTtME0JD3HQt
	YBojdH1DguB6jAzQQMI6xozNy94wF3zlr3i69C1LA2MHXxcjJ4eEgInErO8LWCFsMYkL99az
	dTFycQgJLGKU6On8wgzh/GKUWN3exwxSxSagJvHly2F2EFtEQEPi6e4jjCBFzAK9jBLfJjwF
	SwgLhEmc/PSFDcRmEVCV6Lv4HizOK2ApseL+SkYIW1Dix+R7LCA2s4CWxPqdx5kgbHmJzWve
	MkOcpCCx4+xrRohlehJ9B2cyQ9SISOx78Y5xAqPALCSjZiEZNQvJqFlIWhYwsqxiFE0tSC4o
	TkrPNdQrTswtLs1L10vOz93ECI7jZ1I7GFc2WBxiFOBgVOLhbaibGCjEmlhWXJl7iFGCg1lJ
	hHc/L1CINyWxsiq1KD++qDQntfgQYzLQpxOZpUST84EpJq8k3tDYxMzI0sjMwsjE3Jw0YSVx
	3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGJm/N3jeXbSyVk9tofl5TYUb0dHWb/zYPh49oHVZ
	UVrNRPPg3SNz2f0iHxU94bzQ4bD0byBD+YqulMqsvOJ70/IS6npzPzSF3v6Vu7Q4Ik5WN6n7
	vVdn38XP5kt3td2btu3Os4w1J5OzS56HxnBOs7qqL/1oBd+CVyeu5ef6SV84lSMe80QqUoml
	OCPRUIu5qDgRAHBEyXMnAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PM_GENERIC_DOMAINS needs PM dependency.

Fixed build warning as below:

warning: (PLAT_S3C64XX && CPU_EXYNOS4210) selects PM_GENERIC_DOMAINS which has unmet direct dependencies (PM)
warning: (PLAT_S3C64XX && CPU_EXYNOS4210) selects PM_GENERIC_DOMAINS which has unmet direct dependencies (PM)
arch/arm/kernel/return_address.c:63:2: warning: #warning "TODO: return_address should use unwind tables" [-Wcpp]
drivers/base/power/domain.c: In function '__pm_genpd_add_device':
drivers/base/power/domain.c:1422:2: error: implicit declaration of function 'genpd_acquire_lock'
[-Werror=implicit-function-declaration]
drivers/base/power/domain.c:1466:2: error: implicit declaration of function 'genpd_release_lock'
[-Werror=implicit-function-declaration]
drivers/base/power/domain.c: In function 'pm_genpd_add_subdomain':
drivers/base/power/domain.c:1649:3: error: implicit declaration of function 'genpd_sd_counter_inc'
[-Werror=implicit-function-declaration]
drivers/base/power/domain.c: In function 'pm_genpd_remove_subdomain':
drivers/base/power/domain.c:1721:4: error: implicit declaration of function 'genpd_sd_counter_dec'
[-Werror=implicit-function-declaration]
drivers/base/power/domain.c: In function 'pm_genpd_attach_cpuidle':
drivers/base/power/domain.c:1887:2: error: implicit declaration of function 'genpd_recalc_cpu_exit_latency'
[-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 arch/arm/mach-exynos/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index d19edff..1f7ddb2 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -34,7 +34,7 @@ config CPU_EXYNOS4210
 	default y
 	depends on ARCH_EXYNOS4
 	select ARM_CPU_SUSPEND if PM
-	select PM_GENERIC_DOMAINS
+	select PM_GENERIC_DOMAINS if PM
 	select S5P_PM if PM
 	select S5P_SLEEP if PM
 	select SAMSUNG_DMADEV
-- 
1.7.2.5


