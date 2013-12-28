Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab3L1KQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 05:16:26 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48021 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab3L1KQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 05:16:24 -0500
Date: Sat, 28 Dec 2013 11:16:22 +0100
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
Message-ID: <20131228101622.GA13564@amd.pavel.ucw.cz>
References: <1387895407-28031-1-git-send-email-lgxue@hotmail.com>
 <20131225230935.GB13593@amd.pavel.ucw.cz>
 <BLU172-W52032BFEF4512123D7516EACC20@phx.gbl>
 <20131226142607.GA15225@amd.pavel.ucw.cz>
 <BLU172-W30E6E7C0BC2B6C08FA0552ACCD0@phx.gbl>
 <20131227095705.GC17143@amd.pavel.ucw.cz>
 <BLU172-W8D850A8DEA8C0D87FBF45ACCC0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU172-W8D850A8DEA8C0D87FBF45ACCC0@phx.gbl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Good idea.
> I have finished but I'll change it to this way soon and test it in next some days.
> 
> What the idea about the character to indicate stop?
> 
> I mean this patten maybe indicate just once maybe indicate repeatedly until the next patten.
> 
> What about "/"?
> If there is a "/" at end then stop it else repeat it?

Actually, I'd put a do_repeat attribute somewhere instead of using
magic character for automatic repeats.

And while " " for pause and "#" for light would work. Maybe we chould
do "\0" for pause and "\177" for light... and interpret everything
between as an intensity. That will make it useful for LEDs with
variable intensites, too...

Thanks,
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
