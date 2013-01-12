Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab3ALFOy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 00:14:54 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:36816 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab3ALFOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 00:14:52 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/5] Cpufreq Fixes for 3.9
Date: Sat, 12 Jan 2013 10:44:37 +0530
Message-Id: <cover.1357967566.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

As requested, i am resending all my cpufreq fixes together. I have added correct
Tested-by flags.

Viresh Kumar (5):
  cpufreq: Manage only online cpus
  cpufreq: Notify governors when cpus are hot-[un]plugged
  cpufreq: Don't use cpu removed during cpufreq_driver_unregister
  cpufreq: Simplify __cpufreq_remove_dev()
  cpufreq: Simplify cpufreq_add_dev()

 drivers/cpufreq/cpufreq.c       | 316 +++++++++++++++++-----------------------
 drivers/cpufreq/cpufreq_stats.c |  27 +++-
 drivers/cpufreq/freq_table.c    |   9 ++
 include/linux/cpufreq.h         |  14 +-
 4 files changed, 178 insertions(+), 188 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

