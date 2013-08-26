Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab3HZGSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 02:18:03 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:37661 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab3HZGSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 02:18:01 -0400
MIME-Version: 1.0
Date: Mon, 26 Aug 2013 11:48:00 +0530
Message-ID: <CAKohpoksNiGT+r3JTY6KFwnDFA5OYE-vQe8W_9GT-fN21UMrfQ@mail.gmail.com>
Subject: [GIT PULL]: CPUFreq: ARM Fixes for 3.12
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joseph Lo <josephl@nvidia.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

Hopefully this is the last patch for 3.12 for ARM CPUFreq subsystem.

The following changes since commit b36f4be3de1b123d8601de062e7dbfc904f305fb:

  Linux 3.11-rc6 (2013-08-18 14:36:53 -0700)

are available in the git repository at:

  git://git.linaro.org/people/vireshk/linux.git cpufreq-fixes

for you to fetch changes up to b192b910f3832793082c1a18262c4da0efe121ae:

  cpufreq: tegra: fix the wrong clock name (2013-08-23 21:58:28 +0530)

----------------------------------------------------------------
Joseph Lo (1):
      cpufreq: tegra: fix the wrong clock name

 drivers/cpufreq/tegra-cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
