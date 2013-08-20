Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab3HTGjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:39:49 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:60883 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab3HTGjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:39:46 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/5] cpufreq: align closing brace '}' of an if block
Date: Tue, 20 Aug 2013 12:08:22 +0530
Message-Id: <32c32e6a67ea0a10381dcd214a2d6c1475eb81fb.1376979090.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376979090.git.viresh.kumar@linaro.org>
References: <cover.1376979090.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376979090.git.viresh.kumar@linaro.org>
References: <cover.1376979090.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch caused this:

commit 3de9bdeb28638e164d1f0eb38dd68e3f5d2ac95c
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Tue Aug 6 22:53:13 2013 +0530

    cpufreq: improve error checking on return values of __cpufreq_governor()

Lets fix it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index c0ef84d..fedc842 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1253,7 +1253,7 @@ static int __cpufreq_remove_dev(struct device *dev,
 						__func__);
 				return ret;
 			}
-	}
+		}
 
 		if (!frozen) {
 			lock_policy_rwsem_read(cpu);
-- 
1.7.12.rc2.18.g61b472e

