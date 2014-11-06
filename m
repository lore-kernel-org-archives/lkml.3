Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaKFWuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:50:12 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52172 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaKFWuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:50:09 -0500
Date: Thu, 6 Nov 2014 23:50:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg
Subject: Re: N900 modem support in 3.18-rc1
Message-ID: <20141106225005.GA14002@amd>
References: <20141104205117.GA17606@amd>
 <201411052137.31452@pali>
 <20141105203918.GA29199@amd>
 <201411052206.05379@pali>
 <20141105220359.GA32052@amd>
 <20141105234555.GA7097@earth.universe>
 <20141106124711.GA26944@amd>
 <20141106180335.GA21513@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106180335.GA21513@earth.universe>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I actually had pm=0 on the command line, but I removed it now, and no
> > change: [...]
> > 
> > Let me try with explicit =1. .. aha, that helps. Thanks!
> 
> mh seems I actually missed to make 1 the default value. I will
> prepare a patch for that.
> 
> I assume, that the example ofono commands work for you now?

Yes. I was able to get list of networks. It stops working after a
while, for unknown reasons.

BTW... I'm using Debian-7.7 and did

XKBMODEL="nokiarx51"
XKBLAYOUT="us"

(from https://wiki.debian.org/MaemoAndSqueeze). Keyboard works well
-- except "p" key. arrow-P (0) works ok. Do you see that, too?

> > Do you have an example client that can talk to ofonod?
> 
> I have not yet played with userland stuff. You could try
> telepathy-ring, which integrates the ofono into the telepathy
> framework.

Thanks for the pointer.

> > What is needed to get voice calls to work?
> 
> There's still a kernel driver missing in mainline for exchanging
> voice data between the modem and the cpu (called cmt-speech).
> 
> BTW the CMT driver should be removed from your kernel tree; its a
> deprecated variant of mainline's nokia-modem driver. Thus I guess
> the cmt-speech driver, which is available in your kernel tree, is
> not properly integrated into the changes I did during mainlining
> the other modem related drivers.

Aha, so CONFIG_CMT is the same thing as CONFIG_NOKIA_NODEM? Ok, will
disable that. Speech... if you'd have version I could test, I'll
happily do that.

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
