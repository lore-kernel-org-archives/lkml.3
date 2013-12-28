Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab3L1CPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 21:15:17 -0500
Received: from blu0-omc4-s19.blu0.hotmail.com ([65.55.111.158]:22847 "EHLO
	blu0-omc4-s19.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760Ab3L1CPP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 21:15:15 -0500
X-TMN: [Rq80bO6k7mcE7zh/v7t8agfHwQ38m6E0]
X-Originating-Email: [lgxue@hotmail.com]
Message-ID: <BLU172-W8D850A8DEA8C0D87FBF45ACCC0@phx.gbl>
From: Joe Xue <lgxue@hotmail.com>
To: Pavel Machek <pavel@ucw.cz>
CC: "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCH] Add the LED burst trigger
Date: Fri, 27 Dec 2013 21:08:34 -0500
Importance: Normal
In-Reply-To: <20131227095705.GC17143@amd.pavel.ucw.cz>
References: <1387895407-28031-1-git-send-email-lgxue@hotmail.com>,<20131225230935.GB13593@amd.pavel.ucw.cz>,<BLU172-W52032BFEF4512123D7516EACC20@phx.gbl>,<20131226142607.GA15225@amd.pavel.ucw.cz>,<BLU172-W30E6E7C0BC2B6C08FA0552ACCD0@phx.gbl>,<20131227095705.GC17143@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 28 Dec 2013 02:08:35.0431 (UTC) FILETIME=[B70D1770:01CF0371]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

Good idea.
I have finished but I'll change it to this way soon and test it in next some days.

What the idea about the character to indicate stop?

I mean this patten maybe indicate just once maybe indicate repeatedly until the next patten.

What about "/"?
If there is a "/" at end then stop it else repeat it?

Thanks.

Joe

----------------------------------------
> Date: Fri, 27 Dec 2013 10:57:05 +0100
> From: pavel@ucw.cz
> To: lgxue@hotmail.com
> CC: cooloney@gmail.com; rpurdie@rpsys.net; rob@landley.net; milo.kim@ti.com; linux-leds@vger.kernel.org; linux-kernel@vger.kernel.org; linux-doc@vger.kernel.org
> Subject: Re: [PATCH] Add the LED burst trigger
>
> Hi!
>
>> I'm writing the Morse code trigger.
>> what about this
>>
>> echo "-.-. *"> patten
>> -              a long on then a off
>> .              a short on then a off
>> space     a long off
>> *             mean repeat the patten
>> s             mean indicate the patten just one time then stop
>
> Actually, that's a bit more complex that it needs to be.
>
> Make it
>
> "#" -- LED on
>
> " " -- LED off.
>
> To do morse -.-., you use "### # ### # " pattern. But this is more
> flexible, you can for example do "led mostly on, two blinks to off per
> cycle" using
>
> "########### ## ###########"
>
> pattern.
>
> Hmm?
> Pavel
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/ 		 	   		  