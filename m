Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3J3WwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:52:20 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:34729 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab3J3WwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:52:18 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, viresh.kumar@linaro.org
Subject: [PATCH V2 Resend 00/16] CPUFreq Cleanup Part V
Date: Thu, 31 Oct 2013 04:21:58 +0530
Message-Id: <cover.1383173230.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

Thanks for applying the first four sets.

This is the last set that I had for v3.13, see if you can get it applied for
v3.13.. It shouldn't create much issues I believe, as the changes shouldn't make
any difference in the way code is supposed to work..

I know this might be late for 3.13, but I am just trying my luck :)

Viresh Kumar (16):
  cpufreq: create cpufreq_generic_get() routine
  cpufreq: at32ap: use cpufreq_generic_get() routine
  cpufreq: cpu0: use cpufreq_generic_get() routine
  cpufreq: davinci: use cpufreq_generic_get() routine
  cpufreq: dbx500: use cpufreq_generic_get() routine
  cpufreq: exynos: use cpufreq_generic_get() routine
  cpufreq: imx6q: use cpufreq_generic_get() routine
  cpufreq: loongson2: use cpufreq_generic_get() routine
  cpufreq: omap: use cpufreq_generic_get() routine
  cpufreq: ppc: use cpufreq_generic_get() routine
  cpufreq: s3c: use cpufreq_generic_get() routine
  cpufreq: s5pv210: use cpufreq_generic_get() routine
  cpufreq: spear: use cpufreq_generic_get() routine
  cpufreq: tegra: remove target_cpu_speed[] array
  cpufreq: tegra: use cpufreq_generic_get() routine
  cpufreq: unicore2: use cpufreq_generic_get() routine

 drivers/cpufreq/at32ap-cpufreq.c      | 17 ++++--------
 drivers/cpufreq/cpufreq-cpu0.c        |  8 ++----
 drivers/cpufreq/cpufreq.c             | 26 +++++++++++++-----
 drivers/cpufreq/davinci-cpufreq.c     | 14 +++-------
 drivers/cpufreq/dbx500-cpufreq.c      | 19 ++-----------
 drivers/cpufreq/exynos-cpufreq.c      | 10 +++----
 drivers/cpufreq/exynos5440-cpufreq.c  | 33 ++++++++++-------------
 drivers/cpufreq/imx6q-cpufreq.c       |  8 ++----
 drivers/cpufreq/loongson2_cpufreq.c   | 15 ++++-------
 drivers/cpufreq/omap-cpufreq.c        | 32 +++++++---------------
 drivers/cpufreq/ppc-corenet-cpufreq.c | 17 +++---------
 drivers/cpufreq/s3c24xx-cpufreq.c     | 10 +++----
 drivers/cpufreq/s3c64xx-cpufreq.c     | 33 +++++++++--------------
 drivers/cpufreq/s5pv210-cpufreq.c     | 21 +++++----------
 drivers/cpufreq/spear-cpufreq.c       |  8 ++----
 drivers/cpufreq/tegra-cpufreq.c       | 50 ++++++-----------------------------
 drivers/cpufreq/unicore2-cpufreq.c    | 21 ++++++---------
 include/linux/cpufreq.h               |  3 +++
 18 files changed, 113 insertions(+), 232 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

