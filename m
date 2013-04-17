Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966054Ab3DQJ1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 05:27:45 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42253 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965719Ab3DQJ1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 05:27:43 -0400
Date: Wed, 17 Apr 2013 11:27:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
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
Message-ID: <20130417092737.GA12402@pd.tnic>
References: <20130416095827.GJ3672@sgi.com>
 <20130416113256.GA10452@gmail.com>
 <20130416120624.GO3658@sgi.com>
 <20130416140101.GS3658@sgi.com>
 <20130417074653.GA31607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130417074653.GA31607@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 09:46:53AM +0200, Ingo Molnar wrote:
> What you mention here should indeed already be handled by the
> architecture hotplug code (for example on x86 the boot CPU cannot be
> hot-removed).

Supposedly, some new Intels (I think Ivybridge or so) can actually be
hot-removed.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
