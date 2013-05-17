Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab3EQOi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 10:38:29 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:51686 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab3EQOi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 10:38:26 -0400
From: dirk.brandewie@gmail.com
To: linux-pm@vger.kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>, torvalds@linux-foundation.org
Subject: [PATCH] cpufreq/intel_pstate: Add additional supported CPU ID's
Date: Fri, 17 May 2013 07:38:17 -0700
Message-Id: <1368801497-13072-1-git-send-email-dirk.j.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

Add CPU ID's for supported Sandybridge and Ivybrigde processors.

Cc: torvalds@linux-foundation.org
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/intel_pstate.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 1813311..85b1fd8 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -520,7 +520,9 @@ static void intel_pstate_timer_func(unsigned long __data)
 
 static const struct x86_cpu_id intel_pstate_cpu_ids[] = {
 	ICPU(0x2a, default_policy),
+	ICPU(0x25, default_policy),
 	ICPU(0x2d, default_policy),
+	ICPU(0x3a, default_policy),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_pstate_cpu_ids);
-- 
1.7.7.6

