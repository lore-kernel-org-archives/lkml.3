Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934576Ab3DGXBP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:01:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26188 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934465Ab3DGXBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:01:13 -0400
X-AuditID: cbfee690-b7f656d0000007e3-d7-5161fab73daa
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Kukjin'" <kgene.kim@samsung.com>,
        "'Rafael J. Wysocki'" <rjw@sisk.pl>
References: 
In-reply-to: 
Subject: [RESEND PATCH 3.8-stable] cpufreq: exynos: Get booting freq value in
 exynos_cpufreq_init
Date: Mon, 08 Apr 2013 08:01:10 +0900
Message-id: <004701ce33e3$cbcb8ab0$6362a010$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAEJzDJAAtZcuQA==
Content-language: ko
x-cr-hashedpuzzle: ADs0 CDG/ IEtz Joj2 LbwG NyKk ObOE PjWE QH4m htS9 lkqn ra71
 uomA xSIu xwEK
 x2WB;5;agBoAGIAaQByAGQALgBjAGgAbwBpAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAawBnAGUAbgBlAC4AawBpAG0AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcgBqAHcAQABzAGkAcwBrAC4AcABsADsAcwB0AGEAYgBsAGUAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{A6DD71E0-77AD-4F3E-A2A1-9DD0951831AD};agBoAGIAaQByAGQALgBjAGgAbwBpAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Sun,
 07 Apr 2013 23:01:02
 GMT;WwBSAEUAUwBFAE4ARAAgAFAAQQBUAEMASAAgADMALgA4AC0AcwB0AGEAYgBsAGUAXQAgAGMAcAB1AGYAcgBlAHEAOgAgAGUAeAB5AG4AbwBzADoAIABHAGUAdAAgAGIAbwBvAHQAaQBuAGcAIABmAHIAZQBxACAAdgBhAGwAdQBlACAAaQBuACAAZQB4AHkAbgBvAHMAXwBjAHAAdQBmAHIAZQBxAF8AaQBuAGkAdAA=
x-cr-puzzleid: {A6DD71E0-77AD-4F3E-A2A1-9DD0951831AD}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zQ93tvxIDDS4eFbZY0sxt0bvgKpvF
	5V1z2Cz6F/YyWSzY+IjRgdWjb8sqRo9Hi1sYPT5vkgtgjuKySUnNySxLLdK3S+DKuHyth62g
	lbviSmcLawPjBs4uRk4OCQETib+TbjJD2GISF+6tZ+ti5OIQEljGKPH/6FR2mKIr7Z0sEIlF
	jBLvJyyGqvrLKLF8612wdjYBXYlj67ewgtgiAt4Sp6b8AopzcDALJEvsaOUFMYUEuCVWNweB
	VHAK8Eis+9MJ1ikMVHHwSS8LiM0ioCpxakE72BReATuJSR9nsEHYghI/Jt8Dq2EW0JJYv/M4
	E4QtL7F5zVuwTRIC6hKP/upCHOAkMeHrLWaIEhGJfS/eMYJcLCEwgU3i3ONJrBB/mUo07JjB
	DpF4xC5xdNExNogjBCS+TT7EAjFUVmLTAWgASUocXHGDZQKj1CwkJ81CctIsJCfNQrJ7ASPL
	KkbR1ILkguKk9CITveLE3OLSvHS95PzcTYyQGJ6wg/HeAetDjMlA6ycyS4km5wNTQF5JvKGx
	mZGFqYmpsZG5pRlpwkrivOot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGDWEc3s65vEw
	rXj1JEnLha+qT7vkvd3FucYzt+yauKCCb46wr3NQgMuLjzsW9S3qcVl+U61T5Y7Wq4ZPLiZu
	l295d8ZGRnH/377j0aML35wtn0WuUH4oo76VLWlG0z93rZKpAnrWLcf/mEUd0X0778DXS/My
	rdNj1f+q/YuKXBx7ZOVrxtc8PkosxRmJhlrMRcWJABMCH0D3AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jAd3tvxIDDc7+4LVY0sxt0bvgKpvF
	5V1z2Cz6F/YyWSzY+IjRgdWjb8sqRo9Hi1sYPT5vkgtgjmpgtMlITUxJLVJIzUvOT8nMS7dV
	8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBWqmkUJaYUwoUCkgsLlbSt8M0ITTETdcC
	pjFC1zckCK7HyAANJKxjzLh8rYetoJW74kpnC2sD4wbOLkZODgkBE4kr7Z0sELaYxIV769m6
	GLk4hAQWMUq8n7AYyvnLKLF8611mkCo2AV2JY+u3sILYIgLeEqem/AKKc3AwCyRL7GjlBTGF
	BLglVjcHgVRwCvBIrPvTCdYpDFRx8Ekv2C4WAVWJUwvawabwCthJTPo4gw3CFpT4MfkeWA2z
	gJbE+p3HmSBseYnNa96CbZIQUJd49FcX4gAniQlfbzFDlIhI7HvxjhHkYgmBCWwS5x5PYoX4
	y1SiYccM9gmMIrOQrJiFZMUsJCtmIZm1gJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZw
	gngmvYNxVYPFIUYBDkYlHt4DXxMDhVgTy4orcw8xSnAwK4nw9j4ECvGmJFZWpRblxxeV5qQW
	H2JMBobARGYp0eR8YPLKK4k3NDYxM7I0MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwW
	Jg5OqQbGOX9+rtqXG9aybqWA1S3razMkS55fd3758pbTqVOvdVfuNuVknTdVxfXCmaBsl3gZ
	ToVlbxIZuk8HWHR8Mpxl9ebHvr186hWM6u+aQ7/YuGwue/BpjugF7ZruS4GVh7+WRWUWbuw2
	K71RG/R9u635lCMtXbMvmlho6u235jKRWu6+/k15S+duJZbijERDLeai4kQAf+OoXlQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.8-stable tree, should we
applyit?

------------------

From: "Jonghwan Choi <jhbird.choi@samsung.com>"

commit 6e45eb12fd1c741d556bf264ee98853b5f3104e5 upstream

Boot_freq is for saving booting freq. But exynos_cpufreq_cpu_init
is called in hotplug. If boot_freq is existed in exynos_cpufreq_cpu_init,
boot_freq could be changed.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/cpufreq/exynos-cpufreq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/exynos-cpufreq.c
b/drivers/cpufreq/exynos-cpufreq.c
index 7012ea8..41fc550 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -222,8 +222,6 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy
*policy)
 
 	cpufreq_frequency_table_get_attr(exynos_info->freq_table,
policy->cpu);
 
-	locking_frequency = exynos_getspeed(0);
-
 	/* set the transition latency value */
 	policy->cpuinfo.transition_latency = 100000;
 
@@ -288,6 +286,8 @@ static int __init exynos_cpufreq_init(void)
 		goto err_vdd_arm;
 	}
 
+	locking_frequency = exynos_getspeed(0);
+
 	register_pm_notifier(&exynos_cpufreq_nb);
 
 	if (cpufreq_register_driver(&exynos_driver)) {
-- 
1.7.9.5

