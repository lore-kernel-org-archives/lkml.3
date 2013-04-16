Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab3DPJBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:01:17 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:46541 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab3DPJBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:01:14 -0400
Date: Tue, 16 Apr 2013 11:01:09 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Robin Holt <holt@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Russ Anderson <rja@sgi.com>, Shawn Guo <shawn.guo@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
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
Message-ID: <20130416090109.GB8438@gmail.com>
References: <20130415171225.GC3658@sgi.com>
 <20130415171635.GI3672@sgi.com>
 <71f0c948-cdea-4e8e-86a3-088d306388b9@email.android.com>
 <20130415173324.GD3658@sgi.com>
 <0d5a866d-3d40-4592-bb9d-d938fb3312e2@email.android.com>
 <20130415182258.GE3658@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130415182258.GE3658@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robin Holt <holt@sgi.com> wrote:

> On Mon, Apr 15, 2013 at 10:47:49AM -0700, H. Peter Anvin wrote:
> > We usually don't break working user setups as a matter if policy.  Only if it can't be avoided.
> > 
> > Robin Holt <holt@sgi.com> wrote:
> > 
> > >On Mon, Apr 15, 2013 at 10:18:31AM -0700, H. Peter Anvin wrote:
> > >> Um... doesn't this break anyone who currently depends on this?
> > >
> > >Yes.  That is also why I kept this separate and not tagged for
> > >stable. They would need to start using the more general kernel
> > >parameter
> > >to get the same functionality.  Should I have done it differently?
> 
> How about:
> Author: Robin Holt <holt@sgi.com>
> Date:   Mon Apr 15 11:39:33 2013 -0500
> 
>     Make reboot_cpuid a kernel parameter.
>     
>     Moving the reboot=s<##> parameter for x86 to a kernel parameter
>     proper.  I did not find any other arch that was specifying the
>     reboot cpu.
>     
>     I left a compatibility mode in there.  The new parameter always
>     takes precedence.  I also fixed up the current code to support
>     up to cpuid's up to the current max of 4096.

Looks pretty nice and clean to me, as the old boot parameter still keeps working.

Mind sending an updated series that includes all the fixes and the Tested-by from 
Shawn Guo?

Thanks,

	Ingo
