Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbaCJJXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:23:46 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:43805 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbaCJJXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:23:44 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V1 Resend 0/3] CPUFreq: Minor cleanups for 3.15
Date: Mon, 10 Mar 2014 14:53:32 +0530
Message-Id: <cover.1394431858.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are few minor cleanups for cpufreq core and drivers. The first two removes
per-cpu cpufreq_show_table variable and moves that information in struct
cpufreq_policy. And the last one removes unnecessary frozen variable/parameters.

Just rebased over latest bleeding-edge branch and resent.

Viresh Kumar (3):
  cpufreq: add 'freq_table' in struct cpufreq_policy
  cpufreq: Remove cpufreq_generic_exit()
  cpufreq: Remove unnecessary variable/parameter 'frozen'

 drivers/cpufreq/acpi-cpufreq.c         |  1 -
 drivers/cpufreq/arm_big_little.c       |  1 -
 drivers/cpufreq/blackfin-cpufreq.c     |  1 -
 drivers/cpufreq/cpufreq-cpu0.c         |  1 -
 drivers/cpufreq/cpufreq.c              | 58 ++++++++++++++++------------------
 drivers/cpufreq/cris-artpec3-cpufreq.c |  1 -
 drivers/cpufreq/cris-etraxfs-cpufreq.c |  1 -
 drivers/cpufreq/davinci-cpufreq.c      |  1 -
 drivers/cpufreq/e_powersaver.c         |  1 -
 drivers/cpufreq/elanfreq.c             |  1 -
 drivers/cpufreq/exynos-cpufreq.c       |  1 -
 drivers/cpufreq/exynos5440-cpufreq.c   |  1 -
 drivers/cpufreq/freq_table.c           | 46 +++++----------------------
 drivers/cpufreq/ia64-acpi-cpufreq.c    |  1 -
 drivers/cpufreq/imx6q-cpufreq.c        |  1 -
 drivers/cpufreq/kirkwood-cpufreq.c     |  1 -
 drivers/cpufreq/longhaul.c             |  1 -
 drivers/cpufreq/loongson2_cpufreq.c    |  1 -
 drivers/cpufreq/omap-cpufreq.c         |  1 -
 drivers/cpufreq/p4-clockmod.c          |  1 -
 drivers/cpufreq/pasemi-cpufreq.c       |  1 -
 drivers/cpufreq/powernow-k6.c          |  1 -
 drivers/cpufreq/powernow-k7.c          |  2 --
 drivers/cpufreq/powernow-k8.c          |  2 --
 drivers/cpufreq/ppc-corenet-cpufreq.c  |  1 -
 drivers/cpufreq/ppc_cbe_cpufreq.c      |  1 -
 drivers/cpufreq/pxa2xx-cpufreq.c       |  1 -
 drivers/cpufreq/pxa3xx-cpufreq.c       |  1 -
 drivers/cpufreq/sc520_freq.c           |  1 -
 drivers/cpufreq/sh-cpufreq.c           |  1 -
 drivers/cpufreq/sparc-us2e-cpufreq.c   |  4 +--
 drivers/cpufreq/sparc-us3-cpufreq.c    |  4 +--
 drivers/cpufreq/spear-cpufreq.c        |  1 -
 drivers/cpufreq/speedstep-centrino.c   |  2 --
 drivers/cpufreq/speedstep-ich.c        |  1 -
 drivers/cpufreq/speedstep-smi.c        |  1 -
 drivers/cpufreq/tegra-cpufreq.c        |  1 -
 include/linux/cpufreq.h                | 11 +------
 38 files changed, 39 insertions(+), 120 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

