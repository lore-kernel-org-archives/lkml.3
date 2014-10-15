Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951AbaJOCfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 22:35:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30206 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682AbaJOCfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 22:35:19 -0400
Message-ID: <543DDD5E.9080602@oracle.com>
Date: Tue, 14 Oct 2014 22:35:10 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        paulmck@linux.vnet.ibm.com, htejun@gmail.com
Subject: Re: rcu_preempt detected stalls.
References: <20141013173504.GA27955@redhat.com>
In-Reply-To: <20141013173504.GA27955@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2014 01:35 PM, Dave Jones wrote:
> oday in "rcu stall while fuzzing" news:
> 
> INFO: rcu_preempt detected stalls on CPUs/tasks:
> 	Tasks blocked on level-0 rcu_node (CPUs 0-3): P766 P646
> 	Tasks blocked on level-0 rcu_node (CPUs 0-3): P766 P646
> 	(detected by 0, t=6502 jiffies, g=75434, c=75433, q=0)

I've complained about RCU stalls couple days ago (in a different context)
on -next. I guess whatever causing them made it into Linus's tree?

https://lkml.org/lkml/2014/10/11/64


Thanks,
Sasha
