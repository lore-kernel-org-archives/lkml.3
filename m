Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbaJWSz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 14:55:58 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42860 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbaJWSz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 14:55:57 -0400
Message-ID: <54494F2F.6020005@oracle.com>
Date: Thu, 23 Oct 2014 14:55:43 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        htejun@gmail.com
Subject: Re: rcu_preempt detected stalls.
References: <20141013173504.GA27955@redhat.com> <543DDD5E.9080602@oracle.com> <20141023183917.GX4977@linux.vnet.ibm.com>
In-Reply-To: <20141023183917.GX4977@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2014 02:39 PM, Paul E. McKenney wrote:
> On Tue, Oct 14, 2014 at 10:35:10PM -0400, Sasha Levin wrote:
>> On 10/13/2014 01:35 PM, Dave Jones wrote:
>>> oday in "rcu stall while fuzzing" news:
>>>
>>> INFO: rcu_preempt detected stalls on CPUs/tasks:
>>> 	Tasks blocked on level-0 rcu_node (CPUs 0-3): P766 P646
>>> 	Tasks blocked on level-0 rcu_node (CPUs 0-3): P766 P646
>>> 	(detected by 0, t=6502 jiffies, g=75434, c=75433, q=0)
>>
>> I've complained about RCU stalls couple days ago (in a different context)
>> on -next. I guess whatever causing them made it into Linus's tree?
>>
>> https://lkml.org/lkml/2014/10/11/64
> 
> And on that one, I must confess that I don't see where the RCU read-side
> critical section might be.
> 
> Hmmm...  Maybe someone forgot to put an rcu_read_unlock() somewhere.
> Can you reproduce this with CONFIG_PROVE_RCU=y?

Paul, if that was directed to me - Yes, I see stalls with CONFIG_PROVE_RCU
set and nothing else is showing up before/after that.


Thanks,
Sasha

