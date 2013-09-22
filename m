Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab3IVBVe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 21:21:34 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:50207 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab3IVBV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 21:21:29 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, daniel.lezcano@linaro.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 01/21] cpuidle: fix indentation of cpumask
Date: Sun, 22 Sep 2013 06:50:53 +0530
Message-Id: <eaff05d5201fc70c52aec578a35e265a65b0711b.1379779777.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpumask is indented using spaces instead of tabs. Fix it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/cpuidle.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 781addc..c082425 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -114,7 +114,7 @@ struct cpuidle_driver {
 	int			safe_state_index;
 
 	/* the driver handles the cpus in cpumask */
-	struct cpumask       *cpumask;
+	struct cpumask		*cpumask;
 };
 
 #ifdef CONFIG_CPU_IDLE
-- 
1.7.12.rc2.18.g61b472e

