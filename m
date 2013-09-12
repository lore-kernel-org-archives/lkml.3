Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab3ILURq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:17:46 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37353 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab3ILURl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:17:41 -0400
Date: Thu, 12 Sep 2013 13:17:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Travis <travis@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dimitri Sivanich <sivanich@sgi.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] x86/UV: Add ability to disable UV NMI handler
Message-ID: <20130912201717.GX3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130905225032.879120272@asylum.americas.sgi.com>
 <20130905225034.343366161@asylum.americas.sgi.com>
 <20130909124349.GY31370@twins.programming.kicks-ass.net>
 <522E0037.3090107@sgi.com>
 <20130910090349.GN26785@twins.programming.kicks-ass.net>
 <20130912172731.GR3966@linux.vnet.ibm.com>
 <52320F18.4040407@sgi.com>
 <20130912194833.GW8742@dangermouse.emea.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912194833.GW8742@dangermouse.emea.sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091220-7164-0000-0000-00000195A03A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 08:48:33PM +0100, Hedi Berriche wrote:
> On Thu, Sep 12, 2013 at 19:59 Mike Travis wrote:
> | On 9/12/2013 10:27 AM, Paul E. McKenney wrote:
> |
> | > But what is it that you are looking for?  If you want to silence it
> | > completely, the rcu_cpu_stall_suppress boot/sysfs parameter is what
> | > you want to use.
> | 
> | We have by default rcutree.rcu_cpu_stall_suppress=1 on the kernel
> | cmdline.  I'll double check if it was set during my testing.
> 
> FWIW, for recent enough kernels the correct boot parameter is
> rcupdate.rcu_cpu_stall_suppress.
> 
> It used to be rcutree.rcu_cpu_stall_suppress, but that has changed after
> commit 6bfc09e.

Good point, Hedi!  That change happened when rcutiny gained RCU CPU
stall warning capability.

							Thanx, Paul

