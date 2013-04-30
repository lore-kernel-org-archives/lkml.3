Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab3D3Oci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 10:32:38 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:38105 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3D3Oce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 10:32:34 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/2] CPUFreq core fixes for v3.10-rc2
Date: Tue, 30 Apr 2013 20:02:16 +0530
Message-Id: <cover.1367332148.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just saw your pull request and so these should go in rc2 now.

These are fixes for cpufreq core and common governor part. They mostly impact
systems which have set have_governor_per_policy to true. i.e. big LITTLE cpufreq
driver.

Viresh Kumar (2):
  cpufreq: governors: Fix CPUFREQ_GOV_POLICY_{INIT|EXIT} notifiers
  cpufreq: Issue CPUFREQ_GOV_POLICY_EXIT notifier before dropping
    policy refcount

 drivers/cpufreq/cpufreq.c          |  6 +++---
 drivers/cpufreq/cpufreq_governor.c | 11 +++++++----
 drivers/cpufreq/cpufreq_governor.h |  1 +
 3 files changed, 11 insertions(+), 7 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

