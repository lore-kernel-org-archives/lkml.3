Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab3DZMgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:36:15 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:46745 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab3DZMgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:36:13 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: MAINTAINERS: Add co-maintainer
Date: Fri, 26 Apr 2013 18:06:00 +0530
Message-Id: <19a42d164b0e68a3ac16cd8865f0587ce383f5bf.1366979508.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With prior discussions (Over private emails) with current Maintainer of cpufreq
framework (Rafael), I am adding myself as a co-maintainer of cpufreq framework.

This would mostly be for cpufreq core and ARM drivers but not restricted to
them.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 68d376e..bcef513 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2211,6 +2211,7 @@ F:	drivers/net/ethernet/ti/cpmac.c
 
 CPU FREQUENCY DRIVERS
 M:	Rafael J. Wysocki <rjw@sisk.pl>
+M:	Viresh Kumar <viresh.kumar@linaro.org>
 L:	cpufreq@vger.kernel.org
 L:	linux-pm@vger.kernel.org
 S:	Maintained
-- 
1.7.12.rc2.18.g61b472e

