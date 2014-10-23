Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbaJWJwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 05:52:53 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:40685 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaJWJwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 05:52:51 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [PATCH/TRIVIAL 1/4] cpufreq: cpufreq-dt: Move newline to end of error message
Date: Thu, 23 Oct 2014 11:52:54 +0200
Message-Id: <1414057977-4191-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the error message is needlessly splitted across two lines.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
---
 drivers/cpufreq/cpufreq-dt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq-dt.c b/drivers/cpufreq/cpufreq-dt.c
index 92c162af5045a2da..685f59598137ea03 100644
--- a/drivers/cpufreq/cpufreq-dt.c
+++ b/drivers/cpufreq/cpufreq-dt.c
@@ -192,7 +192,7 @@ static int cpufreq_init(struct cpufreq_policy *policy)
 
 	ret = allocate_resources(policy->cpu, &cpu_dev, &cpu_reg, &cpu_clk);
 	if (ret) {
-		pr_err("%s: Failed to allocate resources\n: %d", __func__, ret);
+		pr_err("%s: Failed to allocate resources: %d\n", __func__, ret);
 		return ret;
 	}
 
-- 
1.9.1

