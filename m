Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab3DPJYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:24:33 -0400
Received: from relay1.sgi.com ([192.48.179.29]:40663 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab3DPJYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:24:31 -0400
Date: Tue, 16 Apr 2013 04:24:29 -0500
From: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Robin Holt <holt@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Russ Anderson <rja@sgi.com>,
        Shawn Guo <shawn.guo@linaro.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Patch -v3 4/4] Make reboot_cpuid a kernel parameter.
Message-ID: <20130416092429.GI3658@sgi.com>
References: <20130415171225.GC3658@sgi.com>
 <20130415171635.GI3672@sgi.com>
 <71f0c948-cdea-4e8e-86a3-088d306388b9@email.android.com>
 <20130415173324.GD3658@sgi.com>
 <0d5a866d-3d40-4592-bb9d-d938fb3312e2@email.android.com>
 <20130415182258.GE3658@sgi.com>
 <20130416090109.GB8438@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416090109.GB8438@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 11:01:09AM +0200, Ingo Molnar wrote:
> 
> * Robin Holt <holt@sgi.com> wrote:
> 
> > On Mon, Apr 15, 2013 at 10:47:49AM -0700, H. Peter Anvin wrote:
> > > We usually don't break working user setups as a matter if policy.  Only if it can't be avoided.
> > > 
> > > Robin Holt <holt@sgi.com> wrote:
> > > 
> > > >On Mon, Apr 15, 2013 at 10:18:31AM -0700, H. Peter Anvin wrote:
> > > >> Um... doesn't this break anyone who currently depends on this?
> > > >
> > > >Yes.  That is also why I kept this separate and not tagged for
> > > >stable. They would need to start using the more general kernel
> > > >parameter
> > > >to get the same functionality.  Should I have done it differently?
> > 
> > How about:
> > Author: Robin Holt <holt@sgi.com>
> > Date:   Mon Apr 15 11:39:33 2013 -0500
> > 
> >     Make reboot_cpuid a kernel parameter.
> >     
> >     Moving the reboot=s<##> parameter for x86 to a kernel parameter
> >     proper.  I did not find any other arch that was specifying the
> >     reboot cpu.
> >     
> >     I left a compatibility mode in there.  The new parameter always
> >     takes precedence.  I also fixed up the current code to support
> >     up to cpuid's up to the current max of 4096.
> 
> Looks pretty nice and clean to me, as the old boot parameter still keeps working.
> 
> Mind sending an updated series that includes all the fixes and the Tested-by from 
> Shawn Guo?

Will do.  I am still going through the comments from Joe Perches to the
third patch.  Already have added the Tested-by to just the first patch.
Otherwise, I am ready to send -v4.

Robin
