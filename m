Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbaHGTia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 15:38:30 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:34424 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaHGTi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 15:38:29 -0400
Date: Thu, 7 Aug 2014 21:38:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        David Rientjes <rientjes@google.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Add "make tinyconfig" to configure the tiniest
 possible kernel
Message-ID: <20140807193824.GA2351@ravnborg.org>
References: <20140806222419.GA2566@jtriplet-mobl1>
 <20140806223152.GA14348@jtriplet-mobl1>
 <20140807160352.GB1382@ravnborg.org>
 <20140807190243.GA5580@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807190243.GA5580@jtriplet-mobl1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > > diff --git a/arch/x86/configs/tiny.config b/arch/x86/configs/tiny.config
> > > new file mode 100644
> > > index 0000000..8f0e54c
> > > --- /dev/null
> > > +++ b/arch/x86/configs/tiny.config
> > > @@ -0,0 +1,5 @@
> > > +CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> > > +CONFIG_KERNEL_XZ=y
> > > +CONFIG_NOHIGHMEM=y
> > > +CONFIG_OPTIMIZE_INLINING=y
> > > +CONFIG_SLOB=y
> > All the above are general options that apply equal to arm than to x86.
> 
> NOHIGHMEM isn't.
You are right - as it is x86 specific it should had been prefixed
with X86_ to document so.

As the symbol is only relevant for X86 it will not hurt anyone else,
so it is OK to have it.
But it would be nice to document in tiny.config that
this is a X86 specific symbol.

	Sam
