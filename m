Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab3AYJcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 04:32:47 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:58803 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab3AYJcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 04:32:45 -0500
Date: Fri, 25 Jan 2013 10:32:41 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        X86 ML <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 1/2] x86, Kconfig: Move PARAVIRT_DEBUG into the paravirt
 menu
Message-ID: <20130125093241.GA19717@gmail.com>
References: <20130124173555.GJ13463@pd.tnic>
 <1359049194-17505-1-git-send-email-bp@alien8.de>
 <20130125082126.GD25314@gmail.com>
 <20130125085146.GA23404@pd.tnic>
 <20130125092032.GC31478@gmail.com>
 <20130125092915.GB23404@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125092915.GB23404@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Fri, Jan 25, 2013 at 10:20:32AM +0100, Ingo Molnar wrote:

> > Maybe it's related, but I had to resolve two conflicts when 
> > merging your two patches to tip:x86/cpu and then to 
> > tip:master - first in arch/x86/Kconfig, then in 
> > arch/x86/include/asm/hypervisor.h.
> >
> > The second conflict looked harmless, due to:
> >
> >   4cca6ea04d31 x86/apic: Allow x2apic without IR on VMware platform
> 
> Ok, I've triggered it here with one of my 64-bit randconfigs 
> and have a fix already. Tell me against which branch you want 
> the patches done and I'll prep them so - currently I'm doing 
> them ontop of rc4+ and tip/master from yesterday.

That's ok. I'll apply them to tip:x86/cpu and then resolve the 
conflicts against tip:master.

Thanks,

	Ingo
