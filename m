Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606AbaGCQ3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:29:17 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:54845 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759480AbaGCQ3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:29:14 -0400
Date: Thu, 3 Jul 2014 12:29:10 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Michael wang <wangyun@linux.vnet.ibm.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: select 'idle' cfs_rq per task-group to prevent
 tg-internal imbalance
In-Reply-To: <20140702131507.GM3588@twins.programming.kicks-ass.net>
Message-ID: <alpine.LFD.2.11.1407031227270.6220@knanqh.ubzr>
References: <53A11A89.5000602@linux.vnet.ibm.com> <20140623094251.GS19860@laptop.programming.kicks-ass.net> <53A8F1DE.2060908@linux.vnet.ibm.com> <20140701082020.GL6758@twins.programming.kicks-ass.net> <53B273A2.5050500@linux.vnet.ibm.com>
 <20140701085658.GM6758@twins.programming.kicks-ass.net> <53B372C6.5000107@linux.vnet.ibm.com> <20140702124918.GE19379@twins.programming.kicks-ass.net> <20140702131507.GM3588@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2014, Peter Zijlstra wrote:

> On Wed, Jul 02, 2014 at 02:49:18PM +0200, Peter Zijlstra wrote:
> > Clearly I need to go take out all these things because people don't seem
> > to know this and SCHED_DEBUG isn't a big enough hint. Tedious.
> 
> Maybe this would be enough clue?
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 4c52907a6d8b..e2dd5ca9e6bf 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -470,6 +470,7 @@ extern enum system_states {
>  #define TAINT_FIRMWARE_WORKAROUND	11
>  #define TAINT_OOT_MODULE		12
>  #define TAINT_UNSIGNED_MODULE		13
> +#define TAINT_DEBUG			14

LOL  ;-)


Nicolas
