Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbaGQEBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 00:01:41 -0400
Received: from mail-yk0-f181.google.com ([209.85.160.181]:33972 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaGQEBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 00:01:39 -0400
Message-ID: <53C74ABB.5060006@gmail.com>
Date: Thu, 17 Jul 2014 00:02:03 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
CC: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu 1/2] rcu: Rationalize kthread spawning
References: <20140714100604.GA9905@linux.vnet.ibm.com> <1405332404-10094-1-git-send-email-paulmck@linux.vnet.ibm.com> <53C73BA3.1070303@oracle.com>
In-Reply-To: <53C73BA3.1070303@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 10:57 PM, Sasha Levin wrote:
> On 07/14/2014 06:06 AM, Paul E. McKenney wrote:
>> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>>
>> Currently, RCU spawns kthreads from several different early_initcall()
>> functions.  Although this has served RCU well for quite some time,
>> as more kthreads are added a more deterministic approach is required.
>> This commit therefore causes all of RCU's early-boot kthreads to be
>> spawned from a single early_initcall() function.
>>
>> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Hey Paul,
> 
> I've updated to today's -next and my VM started hanging on boot. Bisect
> pointed out this patch.
> 
> I don't have any further info right now, but can provide whatever you'll
> find useful.

Hi Sasha,

Could you attach the config file which is failing for a start? 

Thanks,
--
Pranith

> 
> 
> Thanks,
> Sasha
> 

