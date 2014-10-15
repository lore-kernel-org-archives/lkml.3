Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaJOWgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 18:36:32 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35188 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750809AbaJOWgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 18:36:31 -0400
Date: Wed, 15 Oct 2014 23:36:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: Paolo Pisati <p.pisati@gmail.com>, Jason Baron <jbaron@redhat.com>,
        David Miller <davem@davemloft.net>,
        Laura Abbott <lauraa@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: arm: JUMP_LABEL and DEBUG_SET_MODULE_RONX should be mutually
 exclusive?
Message-ID: <20141015223617.GM27405@n2100.arm.linux.org.uk>
References: <20141015122102.GB4427@stinkpad>
 <CAGXu5jLEAjR+X0KnnipGH2gp569_PFp5DYyfgXU=Szxgk5EcpA@mail.gmail.com>
 <20141015220943.GK27405@n2100.arm.linux.org.uk>
 <CAGXu5j+kxThAzwytKTv-033-jY5hTxT80PNiXp144mE=eay99Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+kxThAzwytKTv-033-jY5hTxT80PNiXp144mE=eay99Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 05:21:29PM -0500, Kees Cook wrote:
> On Wed, Oct 15, 2014 at 5:09 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Wed, Oct 15, 2014 at 08:34:17AM -0700, Kees Cook wrote:
> >> On Wed, Oct 15, 2014 at 5:21 AM, Paolo Pisati <p.pisati@gmail.com> wrote:
> >> > Hi,
> >> >
> >> > i keep hitting this with BRIDGE=m, JUMP_LABEL=y and DEBUG_SET_MODULE_RONX=y:
> >>
> >> I think my RO/NX patch series solves this. I sent a pull request, but
> >> I haven't seen any movement on it. :(
> >
> > Sorry Kees.
> >
> > However, even if I had looked at it, I would /not/ have been able to
> > pull it.  It does the absolutely fatal thing for any pull request:
> >
> > The following changes since commit cc31d8f887953e9824c4d9333b15c335ee7d1b65:
> >
> >   Merge branches 'fiq' (early part), 'fixes' and 'misc' into for-next (2014-09-2+6 14:40:19 +0100)
> >
> > That commit is on my "for-next" branch.  The clue is in the name. :)
> > Just like trying to base commits onto the linux-next tree, trying to
> > base commits on an aggregate branch intended for linux-next usage
> > doesn't work for all the same reasons.
> 
> Ah! My mistake; I was trying to figure out which branch would be best
> for you to pull from. What do you prefer I use as the base for the
> pull request?

I much prefer branches against one of Linus' release points than some
point in someone elses tree - unless, of course, there are dependencies
that need to be solved (which means there should be something in the
pull request explaining that.)

If it conflicts with something I have in my tree, then that's generally
not a problem unless the conflict is horrid, at which point it can be
discussed.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
