Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab3EPFKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 01:10:16 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:38856 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3EPFKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 01:10:10 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/3] CPUFreq Fixes for 3.10-rc2
Date: Thu, 16 May 2013 10:39:55 +0530
Message-Id: <cover.1368679353.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

Here are few more fixes for 3.10-rc2.

Viresh Kumar (3):
  cpufreq: Add EXPORT_SYMBOL_GPL for have_governor_per_policy
  cpufreq: governors: Move get_governor_parent_kobj() to cpufreq.c
  cpufreq: Drop rwsem lock around CPUFREQ_GOV_POLICY_EXIT

 drivers/cpufreq/cpufreq.c          | 19 +++++++++++++++++--
 drivers/cpufreq/cpufreq_governor.c |  8 --------
 include/linux/cpufreq.h            |  1 +
 3 files changed, 18 insertions(+), 10 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

