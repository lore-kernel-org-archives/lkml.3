Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab3JCP5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:57:12 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:41115 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab3JCP5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:57:09 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, daniel.lezcano@linaro.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 01/16] cpuidle: fix indentation of cpumask
Date: Thu,  3 Oct 2013 21:26:40 +0530
Message-Id: <a3cdecab3b369082e68b022c80089d0f3c4cf615.1380815504.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1380815504.git.viresh.kumar@linaro.org>
References: <cover.1380815504.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1380815504.git.viresh.kumar@linaro.org>
References: <cover.1380815504.git.viresh.kumar@linaro.org>
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

