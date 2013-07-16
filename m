Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567Ab3GPRdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:33:53 -0400
Received: from tex.lwn.net ([70.33.254.29]:47464 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932872Ab3GPRdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:33:51 -0400
Date: Tue, 16 Jul 2013 11:33:49 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Rob Landley <rob@landley.net>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] Documentation: update references to v2.6.x in
 development-process
Message-ID: <20130716113349.274da843@lwn.net>
In-Reply-To: <1373931284-26333-1-git-send-email-paul.gortmaker@windriver.com>
References: <1373931284-26333-1-git-send-email-paul.gortmaker@windriver.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.18; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jul 2013 19:34:44 -0400
Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> The last mainline release of a v2.6.x kernel was back in May 2011.
> Here we update references to be 3.x based, which also means updating
> some dates and statistics.

Ccing the author of the document never hurts :)

I actually went through this exercise a while back, but somehow never got
around to sending the changes out into the world.  Easily distracted, I
guess.  Anyway, you can put my Acked-by on your changes if you like.

> On a similar note, I was thinking about the recent thread on linux-next
> where we were indicating that people shouldn't rebase linux-next content
> on a whim, and that new devel (vs. bugfix) content shouldn't appear in
> the linux-next content during the merge window.  There is no question
> that the linux-next process is integral to the main flow of patches to
> mainline, so I think Documentation/development-process/2.Process (the
> same file) should also capture those points in the linux-next section.
> Do you have some pre-canned text we can insert there, or should I draft
> something up for you to review?

Seems useful, I could also try to help with this if you run out of steam.
I'd be more inclined to put it into section 7, though, since it's the sort
of thing early-stage developers don't normally need to worry about.

Thanks,

jon
