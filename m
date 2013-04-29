Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab3D2NZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 09:25:12 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:60994 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab3D2NZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 09:25:09 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/5] CPUFreq: ARM big LITTLE Fixes
Date: Mon, 29 Apr 2013 18:54:43 +0530
Message-Id: <cover.1367241503.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

I know I am late for this merge window and you have already closed the gates :)
If you can still take them, its good, otherwise we will push this for v3.10-rc2.

These are minor fixes for ARM big LITTLE cpufreq driver. It doesn't impact any
other driver or cpufreq core and are fairly independent.

Viresh Kumar (5):
  cpufreq: ARM big LITTLE: Select PM_OPP
  cpufreq: ARM big LITTLE DT: Return correct transition latency
  cpufreq: ARM big LITTLE DT: Return CPUFREQ_ETERNAL if clock-latency
    isn't found
  cpufreq: ARM big LITTLE: Move cpu_to_cluster() to arm_big_little.h
  cpufreq: ARM big LITTLE: Improve print message

 drivers/cpufreq/Kconfig.arm         | 1 +
 drivers/cpufreq/arm_big_little.c    | 7 +------
 drivers/cpufreq/arm_big_little.h    | 5 +++++
 drivers/cpufreq/arm_big_little_dt.c | 9 +++++----
 4 files changed, 12 insertions(+), 10 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

