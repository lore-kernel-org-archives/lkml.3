Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab3BVMlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 07:41:19 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41420 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757238Ab3BVMlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 07:41:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stratos Karafotis <stratosk@semaphore.gr>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 linux-next] cpufreq: ondemand: Calculate gradient of CPU load to early increase frequency
Date: Fri, 22 Feb 2013 13:47:56 +0100
Message-ID: <50459058.dux53WNMZ2@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAOh2x==cjXGqm0+y_-_Zqc1W5f9Gny7gc=CbR=JRJxXOmg4iWA@mail.gmail.com>
References: <51253715.7080600@semaphore.gr> <CAKohpokKCrvMYWQCRWccDJHbBNO7km5-vP=d3TwhDyU7HGX-YA@mail.gmail.com> <CAOh2x==cjXGqm0+y_-_Zqc1W5f9Gny7gc=CbR=JRJxXOmg4iWA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 22, 2013 11:27:09 AM Viresh Kumar wrote:
> On Fri, Feb 22, 2013 at 7:26 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > On 21 February 2013 23:09, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> 
> >> Instead of checking only the absolute value of CPU load_freq to increase
> >> frequency, we detect forthcoming CPU load rise and increase frequency
> >> earlier.
> >>
> >> Every sampling rate, we calculate the gradient of load_freq. If it is
> >> too steep we assume that the load most probably will go over
> >> up_threshold in next iteration(s) and we increase frequency immediately.
> >>
> >> New tuners are introduced:
> >> - early_demand: to enable this functionality (disabled by default).
> >> - grad_up_threshold: over this gradient of load we will increase
> >> frequency immediately.
> >>
> >> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> >
> > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> Rafael,
> 
> I applied it here with my Ack over my patches, for getting a run by
> "kbuild test robot".
> 
> http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/cpufreq-for-3.10

Thanks, but I'm still not entirely sure about the have_multiple_policies stuff
(yes, I saw your arguments) and the v3.10 merge window is still two months
away.  IOW, please slow down a bit.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
