Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965618AbaH0X3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:29:35 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60018 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965495AbaH0X3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:29:32 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: intel_pstate: Add CPU ID for Braswell processor
Date: Thu, 28 Aug 2014 01:48:42 +0200
Message-ID: <1489037.zFJ48ZYqaQ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53FE0BB1.9060201@gmail.com>
References: <1408701944-14734-1-git-send-email-mika.westerberg@linux.intel.com> <CAKohpo=7CyRT7szhJAQXjRfBFyw_6LuHSdVS39z=899T0eBoMg@mail.gmail.com> <53FE0BB1.9060201@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 27, 2014 09:47:45 AM Dirk Brandewie wrote:
> On 08/22/2014 03:19 AM, Viresh Kumar wrote:
> > On 22 August 2014 15:35, Mika Westerberg
> > <mika.westerberg@linux.intel.com> wrote:
> >> This is pretty much the same as Intel Baytrail, only the CPU ID is
> >> different. Add the new ID to the supported CPU list.
> >>
> >> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >> Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>
> >
> > Dirk might be away on holidays..
> 
> Yes Sorry
> 
> Acked-by: Dirk Brandewie <dirk.j.brandewie@intel.com>

Queued up for 3.17-rc3, thanks!

> 
> >
> >> ---
> >>   drivers/cpufreq/intel_pstate.c | 1 +
> >>   1 file changed, 1 insertion(+)
> >>
> >> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> >> index c5eac949760d..a3cf8994160b 100644
> >> --- a/drivers/cpufreq/intel_pstate.c
> >> +++ b/drivers/cpufreq/intel_pstate.c
> >> @@ -660,6 +660,7 @@ static const struct x86_cpu_id intel_pstate_cpu_ids[] = {
> >>          ICPU(0x3f, core_params),
> >>          ICPU(0x45, core_params),
> >>          ICPU(0x46, core_params),
> >> +       ICPU(0x4c, byt_params),
> >>          ICPU(0x4f, core_params),
> >>          ICPU(0x56, core_params),
> >>          {}
> >
> > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
