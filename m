Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab3FRKAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:00:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39797 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab3FRKAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:00:45 -0400
Date: Tue, 18 Jun 2013 12:00:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: mingo@redhat.com, linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com
Subject: Re: [PATCH 0/3] sched: Sched Domains: Fixups
Message-ID: <20130618100039.GK3204@twins.programming.kicks-ass.net>
References: <cover.1370861520.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1370861520.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 04:27:17PM +0530, Viresh Kumar wrote:
> Peter/Ingo,
> 
> These are minor fixes that I could find for code responsible for creating sched
> domains. They are rebased of my earlier fixes:
> 
> https://lkml.org/lkml/2013/6/4/253
> 
> I couldn't find them in linux-next or tip/master and so giving this link.
> 
> Viresh Kumar (3):
>   sched: don't initialize alloc_state in build_sched_domains
>   sched: don't sd->child to NULL when it is already NULL
>   sched: Create for_each_sd_topology()
> 
>  kernel/sched/core.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 

Thanks!
