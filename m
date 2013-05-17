Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab3EQQKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 12:10:37 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:53982 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab3EQQKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 12:10:35 -0400
From: dirk.brandewie@gmail.com
To: linux-pm@vger.kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>, torvalds@linux-foundation.org
Subject: [PATCH] cpufreq/intel_pstate: Add additional supported CPU ID
Date: Fri, 17 May 2013 09:10:24 -0700
Message-Id: <1368807024-15251-1-git-send-email-dirk.j.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1368801497-13072-1-git-send-email-dirk.j.brandewie@gmail.com>
References: <1368801497-13072-1-git-send-email-dirk.j.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

Add CPU ID for Ivybrigde processor.

Cc: torvalds@linux-foundation.org
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/intel_pstate.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 1813311..d1e36fe 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -521,6 +521,7 @@ static void intel_pstate_timer_func(unsigned long __data)
 static const struct x86_cpu_id intel_pstate_cpu_ids[] = {
 	ICPU(0x2a, default_policy),
 	ICPU(0x2d, default_policy),
+	ICPU(0x3a, default_policy),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_pstate_cpu_ids);
-- 
1.7.7.6

