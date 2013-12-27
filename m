Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab3L0J5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 04:57:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33272 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab3L0J5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 04:57:09 -0500
Date: Fri, 27 Dec 2013 10:57:05 +0100
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
Message-ID: <20131227095705.GC17143@amd.pavel.ucw.cz>
References: <1387895407-28031-1-git-send-email-lgxue@hotmail.com>
 <20131225230935.GB13593@amd.pavel.ucw.cz>
 <BLU172-W52032BFEF4512123D7516EACC20@phx.gbl>
 <20131226142607.GA15225@amd.pavel.ucw.cz>
 <BLU172-W30E6E7C0BC2B6C08FA0552ACCD0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BLU172-W30E6E7C0BC2B6C08FA0552ACCD0@phx.gbl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I'm writing the Morse code trigger.
> what about this
> 
> echo "-.-. *"> patten
> -              a long on then a off
> .              a short on then a off
> space     a long off
> *             mean repeat the patten
> s             mean indicate the patten just one time then stop

Actually, that's a bit more complex that it needs to be.

Make it

"#" -- LED on

" " -- LED off.

To do morse -.-., you use "### # ### #    " pattern. But this is more
flexible, you can for example do "led mostly on, two blinks to off per
cycle" using

"########### ## ###########"

pattern.

Hmm?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
