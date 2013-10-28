Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab3J1Vtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 17:49:31 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:53510 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab3J1Vt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 17:49:29 -0400
MIME-Version: 1.0
Date: Tue, 29 Oct 2013 03:19:28 +0530
Message-ID: <CAKohpombdzugLe0Q2NUttrapJuSqMDz41ECdxcHfh5dtPgiV0Q@mail.gmail.com>
Subject: [GIT PULL]: CPUFreq: ARM Updates for 3.13
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

I have pushed ARM cpufreq patches for v3.13, you can pull them from my
repo. Sorry if I am late...

The following changes since commit 959f58544b7f20c92d5eb43d1232c96c15c01bfb:

  Linux 3.12-rc7 (2013-10-27 16:12:03 -0700)

are available in the git repository at:

  git://git.linaro.org/people/vireshk/linux.git cpufreq-next-for-3.13

for you to fetch changes up to 2332c7a7a8c1979de68429dcdcb125037ef35f4b:

  cpufreq: arm_big_little: reconfigure switcher behavior at run time
(2013-10-29 03:18:41 +0530)

----------------------------------------------------------------
Nicolas Pitre (1):
      cpufreq: arm_big_little: reconfigure switcher behavior at run time

Sudeep KarkadaNagesha (5):
      cpufreq: arm-big-little: use clk_get instead of clk_get_sys
      ARM: vexpress/TC2: add support for CPU DVFS
      ARM: vexpress/TC2: add cpu clock support
      cpufreq: arm_big_little: add vexpress SPC interface driver
      ARM: vexpress/TC2: register vexpress-spc cpufreq device

Viresh Kumar (1):
      cpufreq: arm_big_little: add in-kernel switching (IKS) support

 arch/arm/mach-vexpress/Kconfig         |  12 +
 arch/arm/mach-vexpress/Makefile        |   3 +-
 arch/arm/mach-vexpress/spc.c           | 366 +++++++++++++++++++++++++++-
 arch/arm/mach-vexpress/spc.h           |   2 +-
 arch/arm/mach-vexpress/tc2_pm.c        |   7 +-
 drivers/cpufreq/Kconfig.arm            |   8 +
 drivers/cpufreq/Makefile               |   1 +
 drivers/cpufreq/arm_big_little.c       | 420 ++++++++++++++++++++++++++++++---
 drivers/cpufreq/arm_big_little.h       |   5 -
 drivers/cpufreq/vexpress-spc-cpufreq.c |  69 ++++++
 10 files changed, 853 insertions(+), 40 deletions(-)
 create mode 100644 drivers/cpufreq/vexpress-spc-cpufreq.c
