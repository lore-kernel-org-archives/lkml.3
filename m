Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbaAIWpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 17:45:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35478 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbaAIWpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 17:45:43 -0500
Date: Thu, 9 Jan 2014 23:45:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Bryan Wu <cooloney@gmail.com>
Cc: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, milo kim <milo.kim@ti.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>
Subject: Re: Broken locking in leds-lp5523.c
Message-ID: <20140109224541.GA19516@amd.pavel.ucw.cz>
References: <20140107204233.GA22413@amd.pavel.ucw.cz>
 <CAK5ve-Kk9BuH=56F98aZOgPS+w-=8iF0HtpOYWNjRN8am2Zqjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ve-Kk9BuH=56F98aZOgPS+w-=8iF0HtpOYWNjRN8am2Zqjg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Now, this is untested patch from my reverse-engineering. I hope I
> > understood things right...
> >
> > In particular, there's unbalanced unlock in
> > lp5523_update_program_memory, and lp5523_update_program_memory needs
> > to be protected by the lock.
> >
> > Comments? Does someone maintain this?
> >
> 
> Actually the locking issue was fixed in my for-next branch,
> http://git.kernel.org/cgit/linux/kernel/git/cooloney/linux-leds.git/commit/?h=for-next&id=0d70bdb957cde2c25a4b3e4c93d0d33403795be9
> 

Yes, that should solve it. Thanks!
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
