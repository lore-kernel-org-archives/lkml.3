Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaE0OT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:19:26 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46369 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbaE0OTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:19:25 -0400
Message-ID: <53849EB7.9090302@linux.vnet.ibm.com>
Date: Tue, 27 May 2014 10:18:31 -0400
From: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Reply-To: jjherne@linux.vnet.ibm.com
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Sasha Levin <sasha.levin@oracle.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
References: <537119EF.2060102@oracle.com> <20140512200135.GL1421@htj.dyndns.org> <53718119.1090000@cn.fujitsu.com> <537180B9.6080407@oracle.com> <53739F3B.4060608@linux.vnet.ibm.com> <53758B12.8060609@cn.fujitsu.com> <20140516115737.GP11096@twins.programming.kicks-ass.net> <CACvQF52-jUMzK32uoDCb8zn0RZsiC9uzUOq+ZBRXK22esYKS0g@mail.gmail.com> <20140516162945.GZ11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140516162945.GZ11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052714-0320-0000-0000-000003616F00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 12:29 PM, Peter Zijlstra wrote:
> On Sat, May 17, 2014 at 12:18:06AM +0800, Lai Jiangshan wrote:
>> so the scheduler/set_cpus_allowed_ptr()/cpu_active_mask should be the first
>> place to fix.
>
> I'm not arguing about that, not to mention that this is userspace
> exposed and nobody protects that.
>
> But I was expecting kernel stuff that calls it on hotplug to be
> serialized thusly, but apparently not so.
>

Was a final patch posted for this issue? The discussion made it sound 
like there were still a few things to figure out before we could resolve 
this bug. I can recreate this as needed and I'm happy to test any patches.

-- 
-- Jason J. Herne (jjherne@linux.vnet.ibm.com)

