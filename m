Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaCGWjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 17:39:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34200 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbaCGWjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 17:39:39 -0500
Date: Fri, 7 Mar 2014 23:39:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Jones <davej@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [qemu64,+smep,+smap] WARNING: CPU: 1 PID: 0 at
 arch/x86/kernel/cpu/amd.c:220 init_amd()
Message-ID: <20140307223929.GI5255@pd.tnic>
References: <20140307015833.GA10048@localhost>
 <53195336.9080606@linux.intel.com>
 <20140307055035.GA5230@localhost>
 <531A164B.8040402@linux.intel.com>
 <20140307191050.GA10961@redhat.com>
 <531A33A2.5030706@linux.intel.com>
 <20140307213856.GF5255@pd.tnic>
 <20140307220655.GA580@redhat.com>
 <20140307222018.GG5255@pd.tnic>
 <20140307222743.GC580@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140307222743.GC580@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 05:27:43PM -0500, Dave Jones wrote:
> When I wrote it 10 years or so back it made more sense than it
> probably does now, so I'd be ok with just dropping it all too tbh.
> Machines of that vintage probably have bigger problems now anyway.

Yeah.

> I don't recall seeing a report of the taint flag being set ever in
> a Red Hat bug report, but we've seen countless problems from machines
> of that era with dying ram or motherboard capacitors or..

Right, this should be a sufficient indicator that those machines won't
be running modern kernels anymore :-)

Oh, and besides, this really frees up that taint bit TAINT_UNSAFE_SMP
for the forcepae thing. Let me cook up a patch - it looks like 3.14
will be the release where we're getting rid of old platforms - look at
tip/x86/nuke-platforms. :-)

> I still have NexGen docs somewhere ;)

Uuuh, more than ancient, make sure to hold on to those :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
