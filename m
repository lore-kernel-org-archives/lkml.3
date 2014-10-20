Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaJTMJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:09:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63308 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaJTMIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:08:49 -0400
X-AuditID: cbfee68e-f79b46d000002b74-73-5444fb4faa2b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: viresh.kumar@linaro.org, tomasz.figa@gmail.com
Cc: kgene.kim@samsung.com, thomas.ab@samsung.com, kyungmin.park@samsung.com,
        inki.dae@samsung.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 3/4] ARM: exynos: Add exynos3250 compatible to use generic
 cpufreq driver
Date: Mon, 20 Oct 2014 21:08:41 +0900
Message-id: <1413806922-22722-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1413806922-22722-1-git-send-email-cw00.choi@samsung.com>
References: <1413806922-22722-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWyRsSkUNf/t0uIQcNXI4vrX56zWky6P4HF
	onfBVTaLs01v2C02Pb7GanF51xw2i8+9RxgtZpzfx2TRsYzRYtWuP4wWG796OHB77Jx1l93j
	zrU9bB6bl9R79G1ZxejxeZNcAGsUl01Kak5mWWqRvl0CV8bcvxPZCp6yVxzb4NrAeJ6ti5GT
	Q0LAROLM7QdMELaYxIV764HiXBxCAksZJc7MvssEUzT14EwmiMR0Roknd2cyQzhNTBIX//9m
	BKliE9CS2P/iBthYEQEjiVU7l7KCFDEL9DFJ/F/8hB0kISwQK3H83AUWEJtFQFVi49mPzCA2
	r4CrRFfbWUaIdXISH/Y8AqvnFHCTWHN/FpgtBFRzq6cJbKiEwCZ2iQsdU5ghBglIfJt8CGgo
	B1BCVmLTAWaIOZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kZFecWJucWleul5yfu4mRmAsnP73
	rG8H480D1ocYBTgYlXh4d5i5hAixJpYVV+YeYjQF2jCRWUo0OR8YcXkl8YbGZkYWpiamxkbm
	lmZK4rwJUj+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDqJS3OYH77/FCTg+531wcHWVaa
	CcqeXxXiavRPc5NCr5Zg7fXjuwo3ZKXrcceX90pNvRolzRj+omzVrvJ93jd21OrNz9VnlZ4Q
	KXfia4JcT8KsrcdLJfSOX3loZKHkItei/SusPa6Y8WlKnwPDf0nf9dtXO9fWTr/rcKQj/pjy
	/ny76F8mnEosxRmJhlrMRcWJAOgjBpuAAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jQV3/3y4hBkdva1pc//Kc1WLS/Qks
	Fr0LrrJZnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLjmWMFqt2/WG02PjVw4HbY+esu+we
	d67tYfPYvKTeo2/LKkaPz5vkAlijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS
	1jBmzP07ka3gKXvFsQ2uDYzn2boYOTkkBEwkph6cyQRhi0lcuLceKM7FISQwnVHiyd2ZzBBO
	E5PExf+/GUGq2AS0JPa/uAHWLSJgJLFq51JWkCJmgT4mif+Ln7CDJIQFYiWOn7vAAmKzCKhK
	bDz7kRnE5hVwlehqO8sIsU5O4sOeR2D1nAJuEmvuzwKzhYBqbvU0sU5g5F3AyLCKUTS1ILmg
	OCk911CvODG3uDQvXS85P3cTIzjSnkntYFzZYHGIUYCDUYmHd4eZS4gQa2JZcWXuIUYJDmYl
	Ed6ob0Ah3pTEyqrUovz4otKc1OJDjKZAV01klhJNzgcmgbySeENjEzMjSyNzQwsjY3Mlcd4D
	rdaBQgLpiSWp2ampBalFMH1MHJxSDYzmJxv47ZwkTcxcnjIeUffZXRn5+OnLIwqpCUkc7Mn3
	Q9eaVbkrc/SFvdwm3nMy43YHt3C1sobqcu/lRm2nXnZ1708W3PMr/bb4l/Cae/+KfpYfSvje
	ufrs6ktTVmW18Mi4XxVmfhqouOdL4KIzfAnaS+aq32t7wqB+Ji/j02tOXm3pPTOVbymxFGck
	GmoxFxUnAgCQ/PxIygIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add exynos3250 compatible string to exynos_cpufreq_matches
for supporting generic cpufreq driver on Exynos3250.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/exynos.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index a1be294..c835a389 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -286,6 +286,7 @@ static const struct of_device_id exynos_cpufreq_matches[] = {
 	{ .compatible = "samsung,exynos5420", .data = "arm-bL-cpufreq-dt" },
 	{ .compatible = "samsung,exynos5250", .data = "cpufreq-dt" },
 	{ .compatible = "samsung,exynos4210", .data = "cpufreq-dt" },
+	{ .compatible = "samsung,exynos3250", .data = "cpufreq-dt" },
 	{ .compatible = "samsung,exynos5440", .data = "exynos5440-cpufreq" },
 	{ /* sentinel */ }
 };
-- 
1.8.0

