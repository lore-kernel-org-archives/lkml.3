Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792Ab3BFVq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:46:58 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:38324 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758167Ab3BFVqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:46:53 -0500
Date: Wed, 6 Feb 2013 22:46:46 +0100
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
Message-ID: <20130206214646.GA28135@gmail.com>
References: <1356564746.7010.56.camel@shinybook.infradead.org>
 <50DB9FA5.6070704@infradead.org>
 <alpine.DEB.2.02.1302041002430.6063@chino.kir.corp.google.com>
 <20130204184436.GA13256@gmail.com>
 <alpine.DEB.2.02.1302041053330.6063@chino.kir.corp.google.com>
 <20130204191408.GA32081@kroah.com>
 <20130204191334.GB14837@gmail.com>
 <CAOJsxLFy7K0cY-8SH4dXs=agYqCN8wW0eC2tQxFxfV8cf7uWqg@mail.gmail.com>
 <alpine.DEB.2.02.1302061209450.18172@chino.kir.corp.google.com>
 <20130207080236.ae38366537cf3f13b9668606@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130207080236.ae38366537cf3f13b9668606@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi David,
> 
> On Wed, 6 Feb 2013 12:12:57 -0800 (PST) David Rientjes <rientjes@google.com> wrote:
> >
> > On Wed, 6 Feb 2013, Pekka Enberg wrote:
> > 
> > > > Yeah, that's a good idea - I think Pekka can apply that change
> > > > just fine to help anyone doing merges - I don't think kconfig
> > > > treats it as a fatal error.
> > > 
> > > Applied, thanks guys!
> > 
> > Adding Stephen to the cc.
> > 
> > What's the endgame for kvmtool/next?  The patch that this fixes has been 
> > sitting in linux-next for over 15 months and hasn't been pulled by Linus, 
> > yet some find it to be quite useful.
> > 
> > Is it a permanent addition to linux-next, is there a route to mainline, 
> > or something else?
> 
> Linus has said that he will not take the kvmtool tree in its 
> current form, but would prefer that it be a separate project, 
> so I should really drop it from linux-next (and ask the tip 
> guys to remove it from their auto-latest branch).
> 
> I have actually been meaning to get back to this, so, today I 
> will drop the kvmtool tree and, Ingo, if you could (at your 
> convenience i.e. when you are next rebasing it) remove it from 
> tip/auto-latest, thanks.

Pekka still intends to send it in the next merge window AFAIK, 
and I use it for testing rather frequently so I'm not going to 
remove it from my tree for the time being.

Note that I never actually had any maintenance problems due to 
it: it's orthogonal, and as long as you don't use it explicitly 
(such as its 'make kvmconfig' feature - which is rather handy) 
it never actually broke anything.

Thanks,

	Ingo
