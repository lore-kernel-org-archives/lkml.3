Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab3L1AhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 19:37:11 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64149 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753674Ab3L1AhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 19:37:09 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: David Woodfall <dave@dawoodfall.net>
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-pm@vger.kernel.org
Subject: Re: Problem with cpufreq and i5 since post 3.9.0
Date: Sat, 28 Dec 2013 01:50:40 +0100
Message-ID: <1593264.QxQbtiBB9a@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131228000900.GJ17115@Blackswan>
References: <20131227185924.GH17115@Blackswan> <20131227195350.GI17115@Blackswan> <20131228000900.GJ17115@Blackswan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: +Viresh and linux-pm

On Saturday, December 28, 2013 12:09:01 AM David Woodfall wrote:
> On (27/12/13 19:53), Dave Woodfall <dave@dawoodfall.net> put forth the proposition:
> >On (27/12/13 20:44), Heinz Diehl <htd@fancy-poultry.org> put forth the proposition:
> >>On 27.12.2013, David Woodfall wrote:
> >>
> >>>But any of the newer kernel versions I've tested only give me
> >>>performance and powersave.
> >>
> >>I don't use any Fedora kernel, so I can't tell which governors are
> >>enabled in those. You should check the value of "CONFIG_CPU_FREQ_GOV"
> >>in the respective .config file for your installed kernel.
> >>
> >>In short: It seems that only "performance" and "powersave" are
> >>compiled in.
> >
> >No, I used the same .config in all versions that I tested. I've also
> >tried setting them as modules rather than built-in. This is the stock
> >slackware .config:
> >
> >CONFIG_CPU_FREQ=y
> >CONFIG_CPU_FREQ_TABLE=m
> >CONFIG_CPU_FREQ_GOV_COMMON=y
> >CONFIG_CPU_FREQ_STAT=m
> >CONFIG_CPU_FREQ_STAT_DETAILS=y
> ># CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> >CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
> ># CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
> ># CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> >CONFIG_CPU_FREQ_GOV_PERFORMANCE=m
> >CONFIG_CPU_FREQ_GOV_POWERSAVE=m
> >CONFIG_CPU_FREQ_GOV_USERSPACE=y
> >CONFIG_CPU_FREQ_GOV_ONDEMAND=m
> >CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m
> >
> >And modprobing any governor module does not change the output of 
> >scaling_available_governors.
> >
> >-Dave
> 
> I'm also experiencing this with a Intel G640 dual core machine.
> Exactly the same effect.

Do you have CONFIG_X86_INTEL_PSTATE set?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
