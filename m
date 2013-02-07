Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472Ab3BGXBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 18:01:19 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:59953 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756383Ab3BGXBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 18:01:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: valdis.kletnieks@vt.edu, artem.savkov@gmail.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com, dirk.brandewie@gmail.com
Subject: Re: [PATCH 0/4] CPUFreq Fixes for 3.9
Date: Fri, 08 Feb 2013 00:07:37 +0100
Message-ID: <1947746.IyFppZQEx8@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohponLrVG+ubf5Ok+7AvoWKRF16YLqUEWAU6hH7-H_R=r0Ow@mail.gmail.com>
References: <cover.1360232293.git.viresh.kumar@linaro.org> <2158181.aoVXdpLJe2@vostro.rjw.lan> <CAKohponLrVG+ubf5Ok+7AvoWKRF16YLqUEWAU6hH7-H_R=r0Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 07, 2013 06:52:20 PM Viresh Kumar wrote:
> On 7 February 2013 18:35, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > I think they all make sense, so applied to linux-next.
> >
> > I would prefer not to make any more changes to cpufreq before v3.9 from now on,
> > except for fixes and maybe the Drik's patchset that I kind of scheduled for
> 
> Dirk :)

Yes, sorry Dirk.

> > merging into bleeding-edge later today.
> 
> I probably have few more for you. Some sparse warnings to be fixed for
> Dirks work and an dangling exynos patch which is waiting for your reply :)

Which Exynos patch?

BTW, there still are locking problems in linux-next.  Why do we need
to take cpufreq_driver_lock() around driver->init() in cpufreq_add_dev(),
in particular?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
