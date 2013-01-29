Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab3A2BhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:37:23 -0500
Received: from mga03.intel.com ([143.182.124.21]:9756 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124Ab3A2BhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:37:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,555,1355126400"; 
   d="scan'208";a="249467638"
Message-ID: <510727FF.4010406@intel.com>
Date: Tue, 29 Jan 2013 09:38:07 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Borislav Petkov <bp@alien8.de>, torvalds@linux-foundation.org,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
References: <1359261385.5803.46.camel@marge.simpson.net>  <20130127103508.GB8894@pd.tnic> <51052ACB.3070703@intel.com>  <1359301903.5805.11.camel@marge.simpson.net>  <1359350266.5783.39.camel@marge.simpson.net>  <20130128095501.GB6109@pd.tnic>  <1359369884.5783.117.camel@marge.simpson.net>  <20130128112922.GA29384@pd.tnic>  <1359372743.5783.136.camel@marge.simpson.net>  <1359373246.5783.138.camel@marge.simpson.net>  <20130128152241.GC6109@pd.tnic> <1359388558.5783.171.camel@marge.simpson.net>
In-Reply-To: <1359388558.5783.171.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2013 11:55 PM, Mike Galbraith wrote:
> On Mon, 2013-01-28 at 16:22 +0100, Borislav Petkov wrote: 
>> On Mon, Jan 28, 2013 at 12:40:46PM +0100, Mike Galbraith wrote:
>>>> No no, that's not restricted to one node.  It's just overloaded because
>>>> I turned balancing off at the NODE domain level.
>>>
>>> Which shows only that I was multitasking, and in a rush.  Boy was that
>>> dumb.  Hohum.
>>
>> Ok, let's take a step back and slow it down a bit so that people like me
>> can understand it: you want to try it with disabled load balancing on
>> the node level, AFAICT. But with that many tasks, perf will suck anyway,
>> no? Unless you want to benchmark the numa-aware aspect and see whether
>> load balancing on the node level feels differently, perf-wise?
> 
> The broken thought was, since it's not wakeup path, stop node balance..
> but killing all of it killed FORK/EXEC balance, oops.

Um. sure. so guess all of tasks just running on one node.
> 
> I think I'm done with this thing though.  See mail I just sent.   There
> are better things to do than letting box jerk my chain endlessly ;-)
> 
> -Mike
> 


-- 
Thanks Alex
