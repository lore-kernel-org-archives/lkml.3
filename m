Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab3GQR5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:57:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50409 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab3GQR5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:57:44 -0400
Date: Wed, 17 Jul 2013 18:57:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        CAI Qian <caiqian@redhat.com>, David Lang <david@lang.hm>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Olivier Galibert <galibert@pobox.com>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML
Message-ID: <20130717175721.GT4165@ZenIV.linux.org.uk>
References: <20130716212704.GB9371@thunk.org>
 <20130716224357.GK4994@xanatos>
 <1374015299.6458.76.camel@gandalf.local.home>
 <20130716231217.GL4994@xanatos>
 <51E5D7C8.5000306@gmail.com>
 <1374018809.2249.29.camel@leira.trondhjem.org>
 <1000066089.1803398.1374046596236.JavaMail.root@redhat.com>
 <20130717144849.GB16513@xanatos>
 <1374073771.6458.143.camel@gandalf.local.home>
 <alpine.DEB.2.02.1307171759100.8258@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307171759100.8258@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 06:00:46PM +0100, Stefano Stabellini wrote:
> On Wed, 17 Jul 2013, Steven Rostedt wrote:
> > The last thing I want to do is to lower the quality of the kernel just
> > to get a wider range of developers.
> 
> Can we stop bringing the quality of the code into the discussion?

No.

> I think it's pretty clear that one doesn't need to be verbally abusive
> in order to stop bad code from getting into the kernel.

At the risk of sounding pedantic...  The above is true *and* irrelevant
as stated, and any attempts to read it in less irrelevant way result
in statements that are absolutely non-obvious and very likely false.
	* some amount of bad code will be getting into the kernel, in
any scenario short of complete cessation of development
	* there certainly are ways to prevent any given bad code from
getting into the kernel, once you have identified it.  Even leaving
aside completely ridiculous ones ("after WW3 nobody will push that into
the tree", etc.), one can always watch all trees for specific code and
refuse to pull if it has slipped in.
	* "once you have identified it" part of the above is essential
and does not scale.
In other words, it's not "can we stop it from happening", it's "how
much will be slippling in with given setup".  And _this_ is where your
position becomes completely unfounded.  It's not at all clear that
vague alternatives being proposed will *not* result in more crap getting
in.
