Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaGQC6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 22:58:49 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48431 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaGQC6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 22:58:45 -0400
Message-ID: <53C73BA3.1070303@oracle.com>
Date: Wed, 16 Jul 2014 22:57:39 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
CC: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH RFC tip/core/rcu 1/2] rcu: Rationalize kthread spawning
References: <20140714100604.GA9905@linux.vnet.ibm.com> <1405332404-10094-1-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1405332404-10094-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 06:06 AM, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Currently, RCU spawns kthreads from several different early_initcall()
> functions.  Although this has served RCU well for quite some time,
> as more kthreads are added a more deterministic approach is required.
> This commit therefore causes all of RCU's early-boot kthreads to be
> spawned from a single early_initcall() function.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Hey Paul,

I've updated to today's -next and my VM started hanging on boot. Bisect
pointed out this patch.

I don't have any further info right now, but can provide whatever you'll
find useful.


Thanks,
Sasha

