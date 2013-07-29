Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab3G2NRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 09:17:37 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62507 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751205Ab3G2NRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 09:17:36 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jason Cooper <jason@lakedaemon.net>, Samuel Ortiz <sameo@linux.intel.com>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] DT, maintainership, development process
Date: Mon, 29 Jul 2013 15:27:44 +0200
Message-ID: <3572404.Lna8dKdTsO@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130729130357.GQ29916@titan.lakedaemon.net>
References: <20130729102452.GA2682@zurbaran> <20130729113526.GB3604@zurbaran> <20130729130357.GQ29916@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 29, 2013 09:03:57 AM Jason Cooper wrote:
> On Mon, Jul 29, 2013 at 01:35:26PM +0200, Samuel Ortiz wrote:
> > On Mon, Jul 29, 2013 at 06:40:32AM -0400, Jason Cooper wrote:
> > > On Mon, Jul 29, 2013 at 12:31:37PM +0200, Jiri Kosina wrote:
> > > > On Mon, 29 Jul 2013, Samuel Ortiz wrote:
> > > > 
> > > > > - Developement process: Jon Corbet's article about our changelog raised
> > > > >   one interesting question: How can we better track how single SOB
> > > > >   patches are getting merged ? Should maintainers add their SOB when
> > > > >   they pull from subsystems maintainers (If they can) ? This is
> > > > >   something I care about from both my MFD and NFC maintainer
> > > > >   perspectives as I both pull from MFD sub maintainers and am John
> > > > >   Linville's NFC sub maintainer.
> > > > 
> > > > This is difficult ... I think that in some sense merging from subsystem 
> > > > maintainer tree can be viewed as an "implicit" Signoff, although this 
> > > > hasn't been formalized anywhere.
> > > > 
> > > > I am afraid there is no way git could handle this easily without rebasing.
> > > 
> > > And that breaks workflows where eg sub-maintainer and maintainer both
> > > contribute to linux-next.  commit-id's _must_ match.  As an example, our
> > > mvebu tree and arm-soc both contribute to linux-next and arm-soc pulls
> > > our branches.
> > 
> > Yes, I'm not saying we should rebase, don't get me wrong.
> > 
> > > Perhaps the merge commit is the place for this?
> > 
> > That would be a first step, but that would obviously not fix the single
> > SOB patches issue.
> 
> Well, is this that maintainers aren't adding a SoB when they apply
> patches from others?  Or, that maintainers are applying their own
> patches, potentially without review?

The purported issue seems to be that some maintainers may apply their own
patches without review and then those commits are difficult to track.

I honestly don't think they are difficult to track as I said here:

http://marc.info/?l=linux-kernel&m=137510284529196&w=4

Whether or not those patches are applied without review is difficult to
establish even if they are posted to mailing lists before applying.

That said we have the same issue with commits with just two SOB tags if
a maintainer applies a patch that nobody has responded to.  Are they going to
be regarded as "suspicious" too now?

And what about trusting maintainers?  If Linus trusts them enough to pull from
them, why can't everybody else trust them enough to assume that they don't do
bad things on purpose?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
