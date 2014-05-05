Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaEEIIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:08:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:46110 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158AbaEEIIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:08:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,986,1389772800"; 
   d="scan'208";a="526078589"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, rajeev.d.muralidhar@intel.com,
        vishwesh.m.rudramuni@intel.com, nicole.chalhoub@intel.com,
        ajaya.durg@intel.com, harinarayanan.seshadri@intel.com,
        yuyang.du@intel.com
Subject: [RFC PATCH 05/12 v1] CONFIG for Workload Consolidation
Date: Mon,  5 May 2014 08:02:45 +0800
Message-Id: <1399248172-13871-6-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399248172-13871-1-git-send-email-yuyang.du@intel.com>
References: <1399248172-13871-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 arch/x86/Kconfig |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9bfac8d..0999c16 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -808,6 +808,16 @@ config CPU_CONCURRENCY
 	  load balancing for power efficiency without sacrificing performance.
 	  If unsure say N here.
 
+config WORKLOAD_CONSOLIDATION
+	bool "CPU Workload Consolidation"
+	default n
+	depends on CPU_CONCURRENCY
+	---help---
+	  CPU Workload Consolidation is a new CPU PM module, which uses the CPU
+	  concurrency of the CPU, and allows asymmetric concurrency across CPUs to
+	  reduce the SW and HW overhead to increase load balance efficiency and
+	  conserve energy. If unsure say N here.
+
 source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
-- 
1.7.9.5

