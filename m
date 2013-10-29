Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab3J2MBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 08:01:23 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64714 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754513Ab3J2MBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 08:01:21 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [GIT PULL]: CPUFreq: ARM Updates for 3.13
Date: Tue, 29 Oct 2013 13:13:25 +0100
Message-ID: <4380344.Im7FREWokp@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <526FA367.5020705@arm.com>
References: <CAKohpombdzugLe0Q2NUttrapJuSqMDz41ECdxcHfh5dtPgiV0Q@mail.gmail.com> <51241428.cPzYVVdugk@vostro.rjw.lan> <526FA367.5020705@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 29, 2013 12:00:39 PM Sudeep KarkadaNagesha wrote:
> Hi Rafael,
> 
> On 29/10/13 12:05, Rafael J. Wysocki wrote:
> > On Tuesday, October 29, 2013 10:57:40 AM Sudeep KarkadaNagesha wrote:
> >> Hi Viresh,
> >>
> >> On 28/10/13 21:49, Viresh Kumar wrote:
> >>> Hi Rafael,
> >>>
> >>> I have pushed ARM cpufreq patches for v3.13, you can pull them from my
> >>> repo. Sorry if I am late...
> >>>
> >>> The following changes since commit 959f58544b7f20c92d5eb43d1232c96c15c01bfb:
> >>>
> >>>   Linux 3.12-rc7 (2013-10-27 16:12:03 -0700)
> >>>
> >>> are available in the git repository at:
> >>>
> >>>   git://git.linaro.org/people/vireshk/linux.git cpufreq-next-for-3.13
> >>>
> >>> for you to fetch changes up to 2332c7a7a8c1979de68429dcdcb125037ef35f4b:
> >>>
> >>>   cpufreq: arm_big_little: reconfigure switcher behavior at run time
> >>> (2013-10-29 03:18:41 +0530)
> >>>
> >>> ----------------------------------------------------------------
> >>> Nicolas Pitre (1):
> >>>       cpufreq: arm_big_little: reconfigure switcher behavior at run time
> >>>
> >>> Sudeep KarkadaNagesha (5):
> >>>       cpufreq: arm-big-little: use clk_get instead of clk_get_sys
> >>
> >> This is already pulled by Rafael, I can see it in linux-pm.git. So you can drop
> >> that.
> >>
> >>>       ARM: vexpress/TC2: add support for CPU DVFS
> >>>       ARM: vexpress/TC2: add cpu clock support
> >>>       cpufreq: arm_big_little: add vexpress SPC interface driver
> >>>       ARM: vexpress/TC2: register vexpress-spc cpufreq device
> >>>
> >>
> >> I also see that the changes for renaming opp_* to dev_pm_opp_* are pulled in.
> >> This requires some fixup in patch 2 and 4 in this list. I can fixup by rebasing
> >> on Rafael's tree. Let me know if you need me to do that.
> > 
> > Yes, please rebase and send the patches to me directly (and CC to the list,
> > of course).
> > 
> Ok, just to be sure, is below branch the right one to rebase ?
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git linux-next

Yes, it is.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
