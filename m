Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab3LZO0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 09:26:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36525 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab3LZO0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 09:26:10 -0500
Date: Thu, 26 Dec 2013 15:26:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Joe Xue <lgxue@hotmail.com>
Cc: "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] Add the LED burst trigger
Message-ID: <20131226142607.GA15225@amd.pavel.ucw.cz>
References: <1387895407-28031-1-git-send-email-lgxue@hotmail.com>
 <20131225230935.GB13593@amd.pavel.ucw.cz>
 <BLU172-W52032BFEF4512123D7516EACC20@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU172-W52032BFEF4512123D7516EACC20@phx.gbl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Yes, Morse code can indicate any means. But when we look at the LEDs, would we like to also have a Morse code book in hand?
> 
> The burst led blink idea is because it is easy to use and easy to describe. Mostly when users on site are describing the LEDs states to the support engineer.
>

Well.. above 7 or so blinks, people will be unable to count. "one
short, one long" will help to extend that. 

Plus, there may be patterns such as "keep it ON, count number of brief
OFFs"... 

That's why I suggested:

> > echo 40> step_length_ms
> > echo "- - - "> pattern
> >
> > do the same trick?
> >
> > Plus, you could for example do
> >
> > echo "- --- "> pattern
> >
> > to do morse code...

Interface

(Note that your client stripped some spaces out of it).

With that, it should be very easy to program all the reasonable
blinking patterns for single LED without PWM.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
