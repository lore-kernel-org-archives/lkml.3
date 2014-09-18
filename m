Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbaIRAjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 20:39:39 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:32773 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbaIRAjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 20:39:37 -0400
Date: Wed, 17 Sep 2014 20:39:34 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 0/2] sched/idle : find the best idle CPU with cpuidle
 info
In-Reply-To: <alpine.LFD.2.11.1409101734470.16533@knanqh.ubzr>
Message-ID: <alpine.LFD.2.11.1409172037340.8647@knanqh.ubzr>
References: <1409844730-12273-1-git-send-email-nicolas.pitre@linaro.org> <alpine.LFD.2.11.1409101734470.16533@knanqh.ubzr>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ping-ping.

On Wed, 10 Sep 2014, Nicolas Pitre wrote:

> 
> Ping.
> 
> 
> On Thu, 4 Sep 2014, Nicolas Pitre wrote:
> 
> > This is a rework of the series initially posted by Daniel Lezcano here:
> > 
> > http://news.gmane.org/group/gmane.linux.power-management.general/thread=44161
> > 
> > Those patches were straightened up, commit logs are more comprehensive,
> > bugs were fixed, etc.
> > 
> > 
> >  drivers/cpuidle/cpuidle.c |  6 ++++++
> >  kernel/sched/fair.c       | 43 ++++++++++++++++++++++++++++++++++-------
> >  kernel/sched/idle.c       |  6 ++++++
> >  kernel/sched/sched.h      | 39 +++++++++++++++++++++++++++++++++++++
> >  4 files changed, 87 insertions(+), 7 deletions(-)
> > 
> > 
> > Nicolas
> > 
> > 
> > _______________________________________________
> > linaro-kernel mailing list
> > linaro-kernel@lists.linaro.org
> > http://lists.linaro.org/mailman/listinfo/linaro-kernel
> > 
> > 
> 
