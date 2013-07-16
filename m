Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab3GPCO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 22:14:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:61083 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab3GPCO0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 22:14:26 -0400
Date: Mon, 15 Jul 2013 22:13:50 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Rob Landley <rob@landley.net>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Documentation: update references to v2.6.x in
 development-process
Message-ID: <20130716021349.GA26761@windriver.com>
References: <1373931284-26333-1-git-send-email-paul.gortmaker@windriver.com>
 <20130716101543.b458d507331c4ac32fe6686e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20130716101543.b458d507331c4ac32fe6686e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH] Documentation: update references to v2.6.x in development-process] On 16/07/2013 (Tue 10:15) Stephen Rothwell wrote:

> Hi Paul,
> 
> Good work!
> 
> On Mon, 15 Jul 2013 19:34:44 -0400 Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> >
> >  Linux-next trees are announced on the linux-kernel and linux-next mailing
> >  lists when they are assembled; they can be downloaded from:
> >  
> > -	http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/
> > +	https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/
> 
> Maybe:
> 
> "	git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> 
> Or as patches relative to Linus' latest -rc or releases from:
> 
> 	https://www.kernel.org/pub/linux/kernel/next/
> 
> Or viewed online at:
> 
> 	https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/
> "
> 
> Or maybe that is a bit verbose.

Probably no harm in it.  I'd cc'd you and akpm for exactly that reason;
I wasn't sure I'd updated to the authoratative source.  I'll fold that
into a v2 once there has been a chance for other feedback to come in.

On a similar note, I was thinking about the recent thread on linux-next
where we were indicating that people shouldn't rebase linux-next content
on a whim, and that new devel (vs. bugfix) content shouldn't appear in
the linux-next content during the merge window.  There is no question
that the linux-next process is integral to the main flow of patches to
mainline, so I think Documentation/development-process/2.Process (the
same file) should also capture those points in the linux-next section.
Do you have some pre-canned text we can insert there, or should I draft
something up for you to review?

Thanks,
Paul.
--

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


