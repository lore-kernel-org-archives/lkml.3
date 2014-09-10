Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaIJGtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 02:49:53 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:38846 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaIJGtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 02:49:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140909233141.GB28142@google.com>
References: <1410221424-20590-1-git-send-email-anupc@chromium.org>
	<CAKohponb199_zt11M2J39yHn45MjFMSrT+hPBp7rbqiHu4vKpQ@mail.gmail.com>
	<CAN1Daczk+YT3ETviCL5d7xLGKzRL+AAo1z6rLs=r+j5+r45-xw@mail.gmail.com>
	<CAOh2x==oX4HN2NJ=bMUzyuL0K9KdrmV7HjRctX9dio7yw-4sbQ@mail.gmail.com>
	<20140909233141.GB28142@google.com>
Date: Wed, 10 Sep 2014 12:19:51 +0530
Message-ID: <CAKohpo=GWbWNFg7=w-Lw5w4fWk1+okRwv0rQwX82XMTg8s_9Lw@mail.gmail.com>
Subject: Re: [PATCH] intel_pstate: track and export frequency residency stats
 via sysfs.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Anup Chenthamarakshan <anupc@chromium.org>
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Sameer Nanda <snanda@chromium.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 September 2014 05:01, Anup Chenthamarakshan <anupc@chromium.org> wrote:
> Here's a comparison of time taken to run intel_pstate_set_pstate() using
> different approaches:
>                                   average time for a transition
> no stats                                      4.7us
> intel_pstate-stats                            5.7us
> direct call to cpufreq_stat_notifier_trans    8.1us
> cpufreq-notifier-event                       10.6us
>
>
> I was wrong about the 5x increase (got tripped by calls to
> intel_pstate_set_pstate where no change in P-state actually happened)

Okay, lets see if this is the right thing to do or not first. So
finish your discussion with
Dirk and then we will see what's the best way to do it.
