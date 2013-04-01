Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab3DAM6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 08:58:19 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:47748 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745Ab3DAM6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 08:58:14 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/9] cpufreq: cpu0: Fix mistake in Documentation example
Date: Mon,  1 Apr 2013 18:27:41 +0530
Message-Id: <b2577e655ec7b069dd6318193a1d7e94f0d1b4f7.1364820620.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1364820620.git.viresh.kumar@linaro.org>
References: <cover.1364820620.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364820620.git.viresh.kumar@linaro.org>
References: <cover.1364820620.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"clock-latency" is incorrectly written as "transition-latency" in an example
present in Documentation of cpufreq-cpu0. Fix it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
---
 Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
index 4416ccc..051f764 100644
--- a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
+++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
@@ -32,7 +32,7 @@ cpus {
 			396000  950000
 			198000  850000
 		>;
-		transition-latency = <61036>; /* two CLK32 periods */
+		clock-latency = <61036>; /* two CLK32 periods */
 	};
 
 	cpu@1 {
-- 
1.7.12.rc2.18.g61b472e

