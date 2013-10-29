Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab3J2K52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:57:28 -0400
Received: from service87.mimecast.com ([91.220.42.44]:53811 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab3J2K50 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:57:26 -0400
Message-ID: <526F94A4.7080706@arm.com>
Date: Tue, 29 Oct 2013 10:57:40 +0000
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [GIT PULL]: CPUFreq: ARM Updates for 3.13
References: <CAKohpombdzugLe0Q2NUttrapJuSqMDz41ECdxcHfh5dtPgiV0Q@mail.gmail.com>
In-Reply-To: <CAKohpombdzugLe0Q2NUttrapJuSqMDz41ECdxcHfh5dtPgiV0Q@mail.gmail.com>
X-OriginalArrivalTime: 29 Oct 2013 10:57:23.0991 (UTC) FILETIME=[A5F62270:01CED495]
X-MC-Unique: 113102910572402701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On 28/10/13 21:49, Viresh Kumar wrote:
> Hi Rafael,
> 
> I have pushed ARM cpufreq patches for v3.13, you can pull them from my
> repo. Sorry if I am late...
> 
> The following changes since commit 959f58544b7f20c92d5eb43d1232c96c15c01bfb:
> 
>   Linux 3.12-rc7 (2013-10-27 16:12:03 -0700)
> 
> are available in the git repository at:
> 
>   git://git.linaro.org/people/vireshk/linux.git cpufreq-next-for-3.13
> 
> for you to fetch changes up to 2332c7a7a8c1979de68429dcdcb125037ef35f4b:
> 
>   cpufreq: arm_big_little: reconfigure switcher behavior at run time
> (2013-10-29 03:18:41 +0530)
> 
> ----------------------------------------------------------------
> Nicolas Pitre (1):
>       cpufreq: arm_big_little: reconfigure switcher behavior at run time
> 
> Sudeep KarkadaNagesha (5):
>       cpufreq: arm-big-little: use clk_get instead of clk_get_sys

This is already pulled by Rafael, I can see it in linux-pm.git. So you can drop
that.

>       ARM: vexpress/TC2: add support for CPU DVFS
>       ARM: vexpress/TC2: add cpu clock support
>       cpufreq: arm_big_little: add vexpress SPC interface driver
>       ARM: vexpress/TC2: register vexpress-spc cpufreq device
> 

I also see that the changes for renaming opp_* to dev_pm_opp_* are pulled in.
This requires some fixup in patch 2 and 4 in this list. I can fixup by rebasing
on Rafael's tree. Let me know if you need me to do that.

Regards,
Sudeep

> Viresh Kumar (1):
>       cpufreq: arm_big_little: add in-kernel switching (IKS) support
> 
>  arch/arm/mach-vexpress/Kconfig         |  12 +
>  arch/arm/mach-vexpress/Makefile        |   3 +-
>  arch/arm/mach-vexpress/spc.c           | 366 +++++++++++++++++++++++++++-
>  arch/arm/mach-vexpress/spc.h           |   2 +-
>  arch/arm/mach-vexpress/tc2_pm.c        |   7 +-
>  drivers/cpufreq/Kconfig.arm            |   8 +
>  drivers/cpufreq/Makefile               |   1 +
>  drivers/cpufreq/arm_big_little.c       | 420 ++++++++++++++++++++++++++++++---
>  drivers/cpufreq/arm_big_little.h       |   5 -
>  drivers/cpufreq/vexpress-spc-cpufreq.c |  69 ++++++
>  10 files changed, 853 insertions(+), 40 deletions(-)
>  create mode 100644 drivers/cpufreq/vexpress-spc-cpufreq.c
> 


