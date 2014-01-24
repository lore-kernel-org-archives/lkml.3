Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750827AbaAXDQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 22:16:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaAXDQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 22:16:12 -0500
Date: Fri, 24 Jan 2014 11:15:51 +0800
From: Dave Young <dyoung@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sasha Levin <sasha.levin@oracle.com>,
        Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] sched: Use a static_key for sched_clock_stable
Message-ID: <20140124031551.GC4922@dhcp-16-126.nay.redhat.com>
References: <52DFD50E.800@oracle.com>
 <20140122183538.GA389@x4>
 <20140122184253.GN30183@twins.programming.kicks-ass.net>
 <20140122190905.GA391@x4>
 <20140122191254.GA390@x4>
 <20140122201605.GU11314@laptop.programming.kicks-ass.net>
 <20140122210814.GC9481@laptop.programming.kicks-ass.net>
 <20140123015354.GB3768@dhcp-16-126.nay.redhat.com>
 <20140123021028.GE3768@dhcp-16-126.nay.redhat.com>
 <20140123165655.GY31570@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123165655.GY31570@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/14 at 05:56pm, Peter Zijlstra wrote:
> On Thu, Jan 23, 2014 at 10:10:28AM +0800, Dave Young wrote:
> > Hmm, seems the my physical machine is booting fine with this patch. kvm
> > guest problem still exist, but that kvm thing might be other problem.
> 
> Dave, could you try with tip/master, Ingo pushed out all the fixes
> gathered.

tip/master works fine for me.

> 
> Lacking that, could you perhaps provide the .config you use for your
> guest and a kvm invocation?
> 
> I used a defconfig with KVM_GUEST=y, which was enough to enable kvmclock
> support and then started with:
> 
> kvm -kernel defconfig-build/arch/x86/boot/bzImage -nographic -append "console=ttyS0" -smp 2

I use qemu-system-x86_64 with efi ovmf firmware, I think the problem
has been resolved in tip/master, if you still want the .config please
let me know.

Thanks
Dave
