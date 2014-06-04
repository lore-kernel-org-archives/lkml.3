Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbaFDCYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 22:24:18 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:32599 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754584AbaFDCYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 22:24:17 -0400
X-IronPort-AV: E=Sophos;i="4.98,969,1392134400"; 
   d="scan'208";a="31415891"
Message-ID: <538E8462.80309@cn.fujitsu.com>
Date: Wed, 4 Jun 2014 10:28:50 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <jjherne@linux.vnet.ibm.com>, Sasha Levin <sasha.levin@oracle.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
References: <537119EF.2060102@oracle.com> <20140512200135.GL1421@htj.dyndns.org> <53718119.1090000@cn.fujitsu.com> <537180B9.6080407@oracle.com> <53739F3B.4060608@linux.vnet.ibm.com> <53758B12.8060609@cn.fujitsu.com> <20140516115737.GP11096@twins.programming.kicks-ass.net> <CACvQF52-jUMzK32uoDCb8zn0RZsiC9uzUOq+ZBRXK22esYKS0g@mail.gmail.com> <20140516162945.GZ11096@twins.programming.kicks-ass.net> <53849EB7.9090302@linux.vnet.ibm.com> <20140527142637.GB19143@laptop.programming.kicks-ass.net> <53875F09.3090607@linux.vnet.ibm.com> <538DB076.4090704@cn.fujitsu.com>
In-Reply-To: <538DB076.4090704@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 07:24 PM, Lai Jiangshan wrote:
> Hi, Jason
> 
> Could you test again after the following command has done.
> (if Peter hasn't asked you test with this command before nor he doesn't stop you now) 
> 
> echo NO_TTWU_QUEUE > /sys/kernel/debug/sched_features


Off-topic!

Why sched_features is in debugfs? I thought it is in procfs or sysfs.
