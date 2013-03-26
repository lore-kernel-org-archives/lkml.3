Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934545Ab3CZOlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:41:14 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:59678 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934491Ab3CZOlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:41:12 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, shawn.guo@linaro.org
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arvind.chauhan@arm.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, rob.herring@calxeda.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: cpu0: Fix mistake in Documentation example
Date: Tue, 26 Mar 2013 20:10:46 +0530
Message-Id: <225d20676ec96aa81683f23485f0339e32a22917.1364308732.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"clock-latency" is incorrectly written as "transition-latency" in an example
present in Documentation of cpufreq-cpu0. Fix it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
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

