Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab3E0CFI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 22:05:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8398 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab3E0CFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 22:05:06 -0400
X-AuditID: cbfee691-b7fef6d000002d62-68-51a2bf50df70
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2] ARM: EXYNOS: add PM dependency to PM_GENERIC_DOMAINS
Date: Mon, 27 May 2013 11:05:03 +0900
Message-id: <000501ce5a7e$9a2b4830$ce81d890$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5afn3dpBnxJ4PgSGe6nOQ4zKiYEQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zI92A/YsCDSa94rS4vPASq0Xvgqts
	FpseX2O1uLxrDpvFjPP7mBxYPTYvqffo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujFdrDrMX
	TBCpODvJoIHxqGAXIyeHhICJxPNd21ghbDGJC/fWs4HYQgLLGCW2r7WHqem8sp4FIj6dUeLY
	8+guRi4g+xejxPrLf8Ea2ATUJL58OcwOYosIaEg83X2EEaSIWaCXUeLbhKdgCWEBD4m+u2fA
	GlgEVCXmnOgCs3kFLCUe71zDDGELSvyYfA9sG7OAlsT6nceZIGx5ic1r3jJDXKQgsePsa0aI
	ZXoSL7fuhqoXkdj34h0jRM06dol/7ZYQuwQkvk0+BFTDARSXldh0AGqMpMTBFTdYJjCKzUKy
	eRaSzbOQbJ6FZMMCRpZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGCERNnEH4/0D1ocYk4HW
	T2SWEk3OB0ZoXkm8obGZkYWpiamxkbmlGWnCSuK86i3WgUIC6YklqdmpqQWpRfFFpTmpxYcY
	mTg4pRoYWRw2fnrav3PLE/tQgeWblBo3B1Z0PO+/7TPh3sfNVgFPjvkuZbxR58R6IqD0yb6b
	FzdUftz6pdjr/oe9SodLXSuvLD2x4aJo4qa4FWvOrvQpszBWebhyDhNTk9cc47ncLzYdn9HB
	p6F/oUzHRXW/m7CZ2r93bZ8b9h/QmX7aTGSb6xz/rEK5y0osxRmJhlrMRcWJAGhK7QPGAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jQd2A/YsCDSb/ZbG4vPASq0Xvgqts
	FpseX2O1uLxrDpvFjPP7mBxYPTYvqffo27KK0ePzJrkA5qgGRpuM1MSU1CKF1Lzk/JTMvHRb
	Je/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoJVKCmWJOaVAoYDE4mIlfTtME0JD3HQt
	YBojdH1DguB6jAzQQMI6xoxXaw6zF0wQqTg7yaCB8ahgFyMnh4SAiUTnlfUsELaYxIV769lA
	bCGB6YwSx55HdzFyAdm/GCXWX/4LlmATUJP48uUwO4gtIqAh8XT3EUaQImaBXkaJbxOegiWE
	BTwk+u6eAWtgEVCVmHOiC8zmFbCUeLxzDTOELSjxY/I9sM3MAloS63ceZ4Kw5SU2r3nLDHGR
	gsSOs68ZIZbpSbzcuhuqXkRi34t3jBMYBWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6h
	XnFibnFpXrpecn7uJkZwDD+T2sG4ssHiEKMAB6MSD++PWYsChVgTy4orcw8xSnAwK4nwJkQD
	hXhTEiurUovy44tKc1KLDzEmA306kVlKNDkfmF7ySuINjU3MjCyNzCyMTMzNSRNWEuc90God
	KCSQnliSmp2aWpBaBLOFiYNTqoGRaaPWqSNyLldZSx49u19WybNtu86/r/NbH7/fZ5wXMuGA
	Zd68SaXvF63Udl318s6KhJA3vb7xfpN8yoTLM21stAReGGvaHpkg4DlheXvkmmnHp3Cu+7n/
	Ic9ndtaj0m0Lv2/5eF2Uo+f/xZZNzFXXdwWvqlP98+uSoG45i5nnLKOSql3F3kkflFiKMxIN
	tZiLihMBDojNVSUDAAA=
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
Changes since v1:
- Fixed PLAT_S3C64XX together as Kukjin Kim mentioned

 arch/arm/mach-exynos/Kconfig  |    2 +-
 arch/arm/mach-s3c64xx/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 6e77432..352e8d0 100644
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
diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
index 2057853..c04c4ee 100644
--- a/arch/arm/mach-s3c64xx/Kconfig
+++ b/arch/arm/mach-s3c64xx/Kconfig
@@ -8,7 +8,7 @@ config PLAT_S3C64XX
 	bool
 	depends on ARCH_S3C64XX
 	default y
-	select PM_GENERIC_DOMAINS
+	select PM_GENERIC_DOMAINS if PM
 	select SAMSUNG_WAKEMASK
 	help
 	  Base platform code for any Samsung S3C64XX device
-- 
1.7.2.5


