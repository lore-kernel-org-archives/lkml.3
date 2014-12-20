Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaLTQRB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 11:17:01 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:50152 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaLTQQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 11:16:59 -0500
Date: Sat, 20 Dec 2014 08:16:54 -0800
From: Darren Hart <dvhart@infradead.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>, mjg59@srcf.ucam.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] dell-wmi: Don't send unneeded keypresses
Message-ID: <20141220161654.GA16404@vmdeb7>
References: <1417648583-9336-1-git-send-email-gabriele.mzt@gmail.com>
 <201412052207.35676@pali>
 <20141203180329.GB20370@vmdeb7>
 <201412201010.18151@pali>
 <20141220151108.GA11752@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141220151108.GA11752@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2014 at 04:11:08PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > > Ok, I agree that it is subjective how serious it is...
> > > > Just to remind that patch fixing problem described in
> > > > 
> > > > http://www.spinics.net/lists/platform-driver-x86/msg05922.ht
> > > > ml
> > > > http://www.spinics.net/lists/platform-driver-x86/msg05924.h
> > > > tml
> > > 
> > > I don't have any objection to sending this back to stable.
> > > Stable is for fixing REAL bugs, as opposed to theorhetical
> > > races, etc. This is a "real" bug.
> > > 
> > > As to not chaning behavior, if it's OK for mainline, it's OK
> > > for stable. At least that is my understanding of it. Folks
> > > are free to verify with Greg if they disagree.
> > 
> > Darren, so how you decided? Now when patches are in linus tree, 
> > are you going to send them to stable tree?
> 
> Please don't. -stable is for serious mainline bugs people are actually
> hitting. Null pointer dereference counts, if people actually hit
> it. This is more behaviour change, and yes, the new behaviour is
> better, but it is really different class.

In this case I agree with Pavel. While the patches are small enough, fix one
thing each, etc, it isn't clear from the description exactly how these patches
affect users.

If you can articulate how they are "real bugs that bother people" (see
stable_kernel_rules.txt) we can reconsider. I should have pushed for better
commit messages on these it appears as this should be obvious from those, but it
isn't - at least not to me at 8:15am ;-)

-- 
Darren Hart
Intel Open Source Technology Center
