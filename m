Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076Ab3BHOzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:55:46 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:58956 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758353Ab3BHOzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:55:45 -0500
Date: Fri, 8 Feb 2013 15:55:39 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
Message-ID: <20130208145539.GC30334@gmail.com>
References: <alpine.DEB.2.02.1302041002430.6063@chino.kir.corp.google.com>
 <20130204184436.GA13256@gmail.com>
 <alpine.DEB.2.02.1302041053330.6063@chino.kir.corp.google.com>
 <20130204191408.GA32081@kroah.com>
 <20130204191334.GB14837@gmail.com>
 <CAOJsxLFy7K0cY-8SH4dXs=agYqCN8wW0eC2tQxFxfV8cf7uWqg@mail.gmail.com>
 <alpine.DEB.2.02.1302061209450.18172@chino.kir.corp.google.com>
 <20130207080236.ae38366537cf3f13b9668606@canb.auug.org.au>
 <20130206214646.GA28135@gmail.com>
 <20130208084029.d7d97d6e26580a5512712f91@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208084029.d7d97d6e26580a5512712f91@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Ingo,
> 
> On Wed, 6 Feb 2013 22:46:46 +0100 Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Pekka still intends to send it in the next merge window AFAIK, 
> 
> That has been true since v3.2 :-(

Yes, and it's improving rather nicely - but was not 
useful/interesting enough (yet) for Linus to pull.

So far it has over three dozen contributors, most of the commits 
come from active kernel developers.

> > and I use it for testing rather frequently so I'm not going 
> > to remove it from my tree for the time being.
> 
> I didn't ask you to remove it from your tree, I just would 
> like it removed from that branch that is included in 
> linux-next (tip/auto-latest).  I know others who also use it 
> for testing.

tip:master and tip:auto-latest are one and the same (with a time 
delay), so that I can merge faster to linux-next, and so that 
linux-next can benefit from the strong coverage testing of -tip.

> > Note that I never actually had any maintenance problems due 
> > to it: it's orthogonal, and as long as you don't use it 
> > explicitly (such as its 'make kvmconfig' feature - which is 
> > rather handy) it never actually broke anything.
> 
> I don't doubt any of that, it is just that Linus has 
> explicitly said that he will not pull it into his tree.  Thus, 
> it should not be in linux-next.

I'll remove it if Linus insists on it, but I think you guys are 
putting form before substance and utility :-(

tools/kvm/ is a useful utility to kernel development, that in 
just this past cycle was used as an incubator to:

  - port KVM functionality to a new architecture
  - port lockdep to user-space
  - test bzImages before booting them on real hardware

It was also used to prototype kernel features in the past. It's 
a project that is alive and useful.

While there's a metric ton of crap in the kernel, which is not 
useful to anyone, which has ongoing costs, and which nobody here 
complains about.

What harm has tools/kvm/ done to you?

I just checked, in the past it has not broken linux-next *once* 
- this current thread is about tools/kvm/ funcionality (for 
which Pekka has already applied the fix).

*Please* don't try to harm useful code just for the heck of it.

As long as the project keeps improving and as long as Pekka 
keeps trying his luck with the upstream merge in the next merge 
window, and as long as its benefits overweigh its costs, I see 
no reason not to include it - I am eating my own dog food.

Please stop this silliness, IMO it's not constructive at all ...

Thanks,

	Ingo
