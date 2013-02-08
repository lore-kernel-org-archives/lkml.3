Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946993Ab3BHT4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:56:18 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35261 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946936Ab3BHT4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:56:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: valdis.kletnieks@vt.edu, artem.savkov@gmail.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Subject: Re: [PATCH 0/4] CPUFreq Fixes for 3.9
Date: Fri, 08 Feb 2013 21:02:37 +0100
Message-ID: <1653071.l2kN4Hy2U6@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpokp4YrxKHibewdt+3-WF7P2Fa_bvRidHpjd9SpsT6bPpw@mail.gmail.com>
References: <cover.1360232293.git.viresh.kumar@linaro.org> <2130803.VQA31hf2jE@vostro.rjw.lan> <CAKohpokp4YrxKHibewdt+3-WF7P2Fa_bvRidHpjd9SpsT6bPpw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 08, 2013 08:06:52 PM Viresh Kumar wrote:
> On 8 February 2013 18:02, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > So as I said, please rework the fixes on top of linux-pm.git/pm-cpufreq.
> 
> I already did. Please check for-rafael branch

Cool.  This is the one I'm supposed to apply, then?

> > Moreover, I'd very much prefer it if you fixed the problems introduced by
> > b8eed8a "cpufreq: Simplify __cpufreq_remove_dev()" separately and *then* any
> > other locking problems you're seeing in the code, although people are not
> > reporting them.
> >
> > You seem to have a clear picture of how the code should work now, so that
> > won't be a big trouble I guess.
> 
> For me all problems are fixed in the current code. :)

Sounds great. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
