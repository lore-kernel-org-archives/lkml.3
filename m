Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaIJXZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 19:25:42 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:41586 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaIJXZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 19:25:40 -0400
Date: Wed, 10 Sep 2014 19:25:37 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 0/2] sched/idle : find the best idle CPU with cpuidle
 info
In-Reply-To: <4753245.VagS0oaVYJ@vostro.rjw.lan>
Message-ID: <alpine.LFD.2.11.1409101918330.16533@knanqh.ubzr>
References: <1409844730-12273-1-git-send-email-nicolas.pitre@linaro.org> <alpine.LFD.2.11.1409101734470.16533@knanqh.ubzr> <4753245.VagS0oaVYJ@vostro.rjw.lan>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014, Rafael J. Wysocki wrote:

> On Wednesday, September 10, 2014 05:35:27 PM Nicolas Pitre wrote:
> > 
> > Ping.
> 
> Is this urgent, and if so, then why?

What makes you think this could be urgent?

After almost a week after the original posting without any feedback, one 
may simply wonder if things could have accidentally fell into a crack, 
that's all.

> 
> > On Thu, 4 Sep 2014, Nicolas Pitre wrote:
> > 
> > > This is a rework of the series initially posted by Daniel Lezcano here:
> > > 
> > > http://news.gmane.org/group/gmane.linux.power-management.general/thread=44161
> > > 
> > > Those patches were straightened up, commit logs are more comprehensive,
> > > bugs were fixed, etc.
> > > 
> > > 
> > >  drivers/cpuidle/cpuidle.c |  6 ++++++
> > >  kernel/sched/fair.c       | 43 ++++++++++++++++++++++++++++++++++-------
> > >  kernel/sched/idle.c       |  6 ++++++
> > >  kernel/sched/sched.h      | 39 +++++++++++++++++++++++++++++++++++++
> > >  4 files changed, 87 insertions(+), 7 deletions(-)
> > > 
> > > 
> > > Nicolas
> > > 
> > > 
> > > _______________________________________________
> > > linaro-kernel mailing list
> > > linaro-kernel@lists.linaro.org
> > > http://lists.linaro.org/mailman/listinfo/linaro-kernel
> > > 
> > > 
> 
> -- 
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
> 
> 
