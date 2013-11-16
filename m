Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab3KPO6V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 09:58:21 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52534 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752941Ab3KPO6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 09:58:12 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lan Tianyu <tianyu.lan@intel.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Update PATCH 1/1] Cpufreq: Make governor data on nonboot cpus across system suspend/resume
Date: Sat, 16 Nov 2013 16:10:45 +0100
Message-ID: <2340396.PKx5xUKfbU@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpomKqJ-Vb68JvmBdTM-QbrszLH1BLQ14s5H1JzVZBTzpYA@mail.gmail.com>
References: <1384495294-10565-1-git-send-email-tianyu.lan@intel.com> <9847309.KdKOG5y1Zx@vostro.rjw.lan> <CAKohpomKqJ-Vb68JvmBdTM-QbrszLH1BLQ14s5H1JzVZBTzpYA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 16, 2013 08:27:07 PM Viresh Kumar wrote:
> On 16 November 2013 20:11, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Saturday, November 16, 2013 11:59:59 AM Lan Tianyu wrote:
> 
> >> Defaultly, all cpus use ondemand governor after bootup. Change one
> >> non-boot cpu's governor to conservative,
> >
> > Well, why would anyone want to do that?  Just out of curiosity ...
> 
> People may want to use different group/cluster/socket of CPUs differently,
> with different kind of policies. Maybe performance governor for boot cpu
> and ondemand for others.
> 
> This bug would also be there for big LITTLE where we want to have
> separate set of tunables for big and LITTLE clusters for the same type
> of governor.
> 
> > So this is acpi-cpufreq, right?
> 
> Probably yes, I saw something similar somewhere.. But this is driver
> independent..
> 
> > The patch looks basically OK to me, but ->
> 
> We wouldn't need this patch if my other patch (where I am disabling
> governors in suspend/resume goes in, in any form)..

Yes, I know that, but I don't think this is the right approach.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
