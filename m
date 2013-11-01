Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab3KAAFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 20:05:53 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62985 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751517Ab3KAAFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 20:05:52 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stratos Karafotis <stratosk@semaphore.gr>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Henrik Nilsson <Karl.Henrik.Nilsson@gmail.com>
Subject: Re: [PATCH] cpufreq: ondemand: Remove redundant return statement
Date: Fri, 01 Nov 2013 01:18 +0100
Message-ID: <7457887.jzoQrnelyS@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohponQ+oRYpdYrpKV3=GMh6ACQr+E+WygLHk0mdC+ivjeP_Q@mail.gmail.com>
References: <5272A118.1090908@semaphore.gr> <CAKohponQ+oRYpdYrpKV3=GMh6ACQr+E+WygLHk0mdC+ivjeP_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 01, 2013 12:09:16 AM Viresh Kumar wrote:
> On 31 October 2013 23:57, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> > After commit dfa5bb622555d9da0df21b50f46ebdeef390041b
> > "cpufreq: ondemand: Change the calculation of target frequency",
> > this return statement is no longer needed.
> >
> > Reported-by: Henrik Nilsson <Karl.Henrik.Nilsson@gmail.com>
> > Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> > ---
> >  drivers/cpufreq/cpufreq_ondemand.c | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> > index 32f26f6..18d4091 100644
> > --- a/drivers/cpufreq/cpufreq_ondemand.c
> > +++ b/drivers/cpufreq/cpufreq_ondemand.c
> > @@ -168,7 +168,6 @@ static void od_check_cpu(int cpu, unsigned int load)
> >                         dbs_info->rate_mult =
> >                                 od_tuners->sampling_down_factor;
> >                 dbs_freq_increase(policy, policy->max);
> > -               return;
> >         } else {
> >                 /* Calculate the next frequency proportional to load */
> >                 unsigned int freq_next;
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Queued up for 3.13, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
