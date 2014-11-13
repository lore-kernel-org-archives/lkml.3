Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372AbaKMQWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 11:22:08 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36403 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327AbaKMQWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 11:22:06 -0500
Date: Thu, 13 Nov 2014 17:21:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Pali Roh?r <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg
Subject: Re: N900 modem support in 3.18-rc1
Message-ID: <20141113162155.GA8512@xo-6d-61-c0.localdomain>
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
User-Agent: Mutt/1.5.21 (2010-09-15)
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

Yes, it now works great.

> > Do you have an example client that can talk to ofonod?
> 
> I have not yet played with userland stuff. You could try
> telepathy-ring, which integrates the ofono into the telepathy
> framework.

Ok, I took a look, and telepathy-ring is not in debian, and has
a lot of dependencies.

OTOH ofono seems pretty reasonable. So I played a bit, and result
is python/pygtk gui which can receive an sms, initiate a call, and
report missed call. If someone wants to play, source is at

https://gitorious.org/tui/tui/source/b6141107e9341a1412720aed4b0d09143dfa2f4e:ofone

Best regards,
									Pavel



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
