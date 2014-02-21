Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbaBUN5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:57:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46775 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800AbaBUMte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:34 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nell Hardcastle <nell@spicious.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Zhang, Xiong Y" <xiong.y.zhang@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 016/121] intel_pstate: Add Haswell CPU models
Date: Fri, 21 Feb 2014 12:47:20 +0000
Message-Id: <1392986945-9693-17-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nell Hardcastle <nell@spicious.com>

commit 6cdcdb793791f776ea9408581b1242b636d43b37 upstream.

Enable the intel_pstate driver for Haswell CPUs. One missing Ivy Bridge
model (0x3E) is also included. Models referenced from
tools/power/x86/turbostat/turbostat.c:has_nehalem_turbo_ratio_limit

Signed-off-by: Nell Hardcastle <nell@spicious.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Zhang, Xiong Y <xiong.y.zhang@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpufreq/intel_pstate.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 8d10dda..c61fd64 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -527,6 +527,11 @@ static const struct x86_cpu_id intel_pstate_cpu_ids[] = {
 	ICPU(0x2a, default_policy),
 	ICPU(0x2d, default_policy),
 	ICPU(0x3a, default_policy),
+	ICPU(0x3c, default_policy),
+	ICPU(0x3e, default_policy),
+	ICPU(0x3f, default_policy),
+	ICPU(0x45, default_policy),
+	ICPU(0x46, default_policy),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_pstate_cpu_ids);
-- 
1.9.0

