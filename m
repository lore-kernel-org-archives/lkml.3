Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaGPVAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:00:42 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49416 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752454AbaGPVAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:00:37 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Sachin Kamat <spk.linux@gmail.com>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Tomasz Figa <t.figa@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Rob Herring <rob.herring@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH 00/14] cpufreq: cpu0: Extend support beyond CPU0, V2
Date: Wed, 16 Jul 2014 23:18:52 +0200
Message-ID: <1450785.beFNo3ByBF@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohpo=bUMKa752fBXZTb0WPYMfJtuR5uk7z-YaXYV63fhJWtg@mail.gmail.com>
References: <cover.1404231535.git.viresh.kumar@linaro.org> <CAKohpo=Z5gEHOC5q40q8dfQfoNP5-WyhjG1arV99zJiG2c+6Xg@mail.gmail.com> <CAKohpo=bUMKa752fBXZTb0WPYMfJtuR5uk7z-YaXYV63fhJWtg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 16, 2014 09:31:54 PM Viresh Kumar wrote:
> Cc'ing Thomas,
> 
> On 8 July 2014 10:20, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > On 4 July 2014 09:51, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> >> Yeah, having something like what you suggested from DT is the perfect
> >> solution to get over this. The only reason why I am not touching that here
> >> is to not delay other patches just because of that.
> >>
> >> There are separate threads going on for that and probably somebody
> >> else was trying to push for that.
> >>
> >> That's it, nothing more. I would definitely like to use those bindings instead
> >>  of the crazy routines we are trying here, once that is finalized :)
> >
> > Do we have some kind of agreement for this temporary solution? Anyways
> > I will kick the other thread again to resolve the bindings soon.
> 
> Hi Mike/Rafael,
> 
> Thomas has a dependency on the patch adding "find_siblings()":
> http://www.spinics.net/lists/arm-kernel/msg348080.html
> 
> Would it be fine to get this temporary solution (Only within cpufreq-cpu0
> file, so that it doesn't become an API) for now and updating it later once
> bindings are closed?

I don't like that idea, but I wonder what other people think.

Rafael

