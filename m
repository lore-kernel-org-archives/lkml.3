Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab3BFGX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 01:23:57 -0500
Received: from mail.candelatech.com ([208.74.158.172]:39915 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab3BFGX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 01:23:56 -0500
Message-ID: <5111F6F6.7010402@candelatech.com>
Date: Tue, 05 Feb 2013 22:23:50 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: Question on lockdep and MAX_LOCK_DEPTH
References: <5111AD8D.1080005@candelatech.com>   <20130206015430.GA9161@home.goodmis.org>  <5111BF51.5010607@candelatech.com>  <1360119124.2621.37.camel@gandalf.local.home>  <5111CE60.4080403@candelatech.com> <1360125419.2621.39.camel@gandalf.local.home>
In-Reply-To: <1360125419.2621.39.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 08:36 PM, Steven Rostedt wrote:
> On Tue, 2013-02-05 at 19:30 -0800, Ben Greear wrote:
>
>> It's huge, so here's a link:
>>
>> http://www.candelatech.com/~greearb/debug.tgz
>>
>
> The trace shows that __netif_receive_skb() is grabbing an
> rcu_read_lock() but never releasing it. But I don't see any possible way
> that can be true in the code.
>
> Can you apply the following patch and run the trace again. I'd like to
> see if the code is going in the path I expect it is.

I'll look at this in detail tomorrow.  I have a few patches in dev.c code, maybe
I merged something badly....

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

