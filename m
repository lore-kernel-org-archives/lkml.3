Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbaBKTVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:21:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311AbaBKTIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:08:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nell Hardcastle <nell@spicious.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.10 76/79] intel_pstate: Add Haswell CPU models
Date: Tue, 11 Feb 2014 11:06:20 -0800
Message-Id: <20140211184723.169745574@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184720.928667275@linuxfoundation.org>
References: <20140211184720.928667275@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -523,6 +523,11 @@ static const struct x86_cpu_id intel_pst
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


