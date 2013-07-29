Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab3G2SlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:41:11 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:29368 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab3G2SlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:41:07 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/DByCXh2pxiyVGj69xPqcxdwhqzEMnXNI=
Date: Mon, 29 Jul 2013 14:41:01 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] DT, maintainership,
 development process
Message-ID: <20130729184101.GX29916@titan.lakedaemon.net>
References: <20130729102452.GA2682@zurbaran>
 <20130729113526.GB3604@zurbaran>
 <20130729130357.GQ29916@titan.lakedaemon.net>
 <3572404.Lna8dKdTsO@vostro.rjw.lan>
 <20130729181733.GB31172@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729181733.GB31172@tuxdriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 02:17:34PM -0400, John W. Linville wrote:
> On Mon, Jul 29, 2013 at 03:27:44PM +0200, Rafael J. Wysocki wrote:
> 
> > That said we have the same issue with commits with just two SOB tags if
> > a maintainer applies a patch that nobody has responded to.  Are they going to
> > be regarded as "suspicious" too now?
> > 
> > And what about trusting maintainers?  If Linus trusts them enough to pull from
> > them, why can't everybody else trust them enough to assume that they don't do
> > bad things on purpose?
> 
> Not just Linus -- it's 'turtles all the way down' here.  As someone
> else suggested, a Singed-off-by in the merge commit should suffice
> here.  Although, I haven't always made a habit of adding S-o-b to
> merge commits either...

Even then, you are the author of the merge commit.  So the original
question of tracking a 'chain-of-custody' from submitter to Linus' tree
is still answerable.  Even if there is only a single SoB in the patch.

thx,

Jason.
