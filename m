Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab3DSH4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 03:56:39 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:43073 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab3DSH4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 03:56:37 -0400
Date: Fri, 19 Apr 2013 09:56:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Russ Anderson <rja@sgi.com>, Shawn Guo <shawn.guo@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>,
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
Subject: Re: [Patch -v4 1/4] Migrate shutdown/reboot to boot cpu.
Message-ID: <20130419075629.GE20897@gmail.com>
References: <20130416095827.GJ3672@sgi.com>
 <20130416113256.GA10452@gmail.com>
 <20130416120624.GO3658@sgi.com>
 <20130416140101.GS3658@sgi.com>
 <20130417074653.GA31607@gmail.com>
 <20130417092737.GA12402@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130417092737.GA12402@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Wed, Apr 17, 2013 at 09:46:53AM +0200, Ingo Molnar wrote:
>
> > What you mention here should indeed already be handled by the architecture 
> > hotplug code (for example on x86 the boot CPU cannot be hot-removed).
> 
> Supposedly, some new Intels (I think Ivybridge or so) can actually be 
> hot-removed.

There are WIP patches in existence that remove the limitations on the kernel side, 
but they are not upstream yet, so currently the constraint exists upstream.

Thanks,

	Ingo
