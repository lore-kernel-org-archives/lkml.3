Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058AbaEIQld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:41:33 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:38990 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012AbaEIQla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:41:30 -0400
Message-ID: <536D0531.5080606@linaro.org>
Date: Sat, 10 May 2014 00:41:21 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Morten Rasmussen <morten.rasmussen@arm.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "wangyun@linux.vnet.ibm.com" <wangyun@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [RESEND PATCH V5 0/8] remove cpu_load idx
References: <1397616209-27275-1-git-send-email-alex.shi@linaro.org> <20140429145221.GH2639@e103034-lin> <5360C15B.9060608@linaro.org> <53689E62.9090403@linaro.org> <20140506114315.GG11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140506114315.GG11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


于 5/6/14, 19:43, Peter Zijlstra 写道:
> On Tue, May 06, 2014 at 04:33:38PM +0800, Alex Shi wrote:
>>> Maybe the predication is reasonable on per task history. but on a cpu
>>> load history, with many tasks rebalance. No testing show current method
>>> is helpful.
>>>
>>> For task load change, scheduler has no idea for its future except guess
>>> from its history. but for cpu load change, scheduler know this from task
>>> wakeup and balance, which both under control and its aim.
>>>
>>>
>>> I think the first patch of this serial has the same effect of LB_LIAS
>>> disable. and previous result show performance is good.
>>>
>>> Anyway, I just pushed the following patch to github, maybe fengguang's
>>> testing system will care this.
>> Fengguang,
>>
>> Are there any performance change on
>> https://github.com/alexshi/power-scheduling.git noload repository?
> You forgot to qualify that with the important bit; on _large_ systems.
> Esp. non fully connected numa boxen. Also, I'm not sure Wu has workloads
> that are typical of such systems -- even if he has such machines, which
> I don't know either.

Fengguang,
Why not introduce your machines and workloads to US? It is a good chance 
to sell your system. :)
>
> Enterprise distro testing has _some_ of that, but the very sad truth is
> that most enterprise users lag behind at least a full release cycle. So
> by the time people start using the kernel, its so old nobody really
> cares anymore :-(
It sounds so bad.
Does redhat like to take some action for this? You have big impact to 
Linux community!

and what's your plan for this patch set?
It remove much of tick precess, and performance looks good as far as 
testing. :)

>
>

