Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab3ILKuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:50:35 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:65203 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753897Ab3ILKud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:50:33 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: "cpufreq: fix serialization issues with freq change notifiers" breaks cpufreq too
Date: Thu, 12 Sep 2013 13:01:35 +0200
Message-ID: <3488595.xbBYlylYai@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpomuJNQmk5fg5en5usPgipj7hzXUVNMhz1MjAS-47X4Ggg@mail.gmail.com>
References: <Pine.LNX.4.64.1309091656200.6602@axis700.grange> <52310E43.1090808@intel.com> <CAKohpomuJNQmk5fg5en5usPgipj7hzXUVNMhz1MjAS-47X4Ggg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 12, 2013 11:06:14 AM Viresh Kumar wrote:
> On 12 September 2013 06:13, Rafael J. Wysocki
> <rafael.j.wysocki@intel.com> wrote:
> > Yes, if you can point to a specific driver having this problem.
> 
> There are so many of those (I know it because I went through almost all drivers
> recently with my cleanup series): cpufreq-cpu0, omap-cpufreq,
> exynos-cpufreq, etc..
> 
> They all do this:
> 
> A. If new freq is more than old: Increase voltage
> B. Change freq
> C. If new freq is less than old: decrease voltage

Well, if there's more than one it's even simpler.  You can just pick one. :-)

Like, "for example, <driver name> does the following ... which may cause the
hardware to misbehave, because ...".

Thanks,
Rafael

