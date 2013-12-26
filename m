Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab3LZQ6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 11:58:52 -0500
Received: from blu0-omc4-s5.blu0.hotmail.com ([65.55.111.144]:32439 "EHLO
	blu0-omc4-s5.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753554Ab3LZQ6s convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 11:58:48 -0500
X-TMN: [gA4hzdOSWDPdIevQbDwnIqOsLPeb3hjR]
X-Originating-Email: [lgxue@hotmail.com]
Message-ID: <BLU172-W413E574F382D098B5F9028ACC20@phx.gbl>
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
Date: Thu, 26 Dec 2013 11:58:47 -0500
Importance: Normal
In-Reply-To: <BLU172-W3236C029069708048D5697ACC20@phx.gbl>
References: <1387895407-28031-1-git-send-email-lgxue@hotmail.com>,<20131225230935.GB13593@amd.pavel.ucw.cz>,<BLU172-W52032BFEF4512123D7516EACC20@phx.gbl>,<20131226142607.GA15225@amd.pavel.ucw.cz>,<BLU172-W3236C029069708048D5697ACC20@phx.gbl>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 26 Dec 2013 16:58:47.0247 (UTC) FILETIME=[BE25EDF0:01CF025B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I think Pavel's suggestion is a good idea, I'm starting to write another trigger named Morse code trigger.

I prefer to keeping this burst trigger and add another Morse code trigger for different application. But I know the Morse code trigger will be the super set of the burst. Say the patten ... Morse code is same as the 3 times burst blinking.

Anyway, after I finish that trigger, let community to decide which one will be adapted, or both.

Any suggestion about the new Morse trigger, please let me know.

Thank you Pavel.

Joe

----------------------------------------
> From: lgxue@hotmail.com
> To: pavel@ucw.cz
> CC: cooloney@gmail.com; rpurdie@rpsys.net; rob@landley.net; milo.kim@ti.com; linux-leds@vger.kernel.org; linux-kernel@vger.kernel.org; linux-doc@vger.kernel.org
> Subject: RE: [PATCH] Add the LED burst trigger
> Date: Thu, 26 Dec 2013 10:02:38 -0500
>
> Hi Pavel,
>
> Yes, your suggest looks reasonable. Only issue maybe is not easy to called by program. After all, the interface is called by program more ofter then by human being.
>
> I would like to change the way what you suggest, let see if other guys agree with your idea.
>
> Before that, I'll submit another change as per Geert's suggest that change HZ to Hz.
>
> Joe
>
> ----------------------------------------
>> Date: Thu, 26 Dec 2013 15:26:08 +0100
>> From: pavel@ucw.cz
>> To: lgxue@hotmail.com
>> CC: cooloney@gmail.com; rpurdie@rpsys.net; rob@landley.net; milo.kim@ti.com; linux-leds@vger.kernel.org; linux-kernel@vger.kernel.org; linux-doc@vger.kernel.org
>> Subject: Re: [PATCH] Add the LED burst trigger
>>
>> Hi!
>>
>>> Yes, Morse code can indicate any means. But when we look at the LEDs, would we like to also have a Morse code book in hand?
>>>
>>> The burst led blink idea is because it is easy to use and easy to describe. Mostly when users on site are describing the LEDs states to the support engineer.
>>>
>>
>> Well.. above 7 or so blinks, people will be unable to count. "one
>> short, one long" will help to extend that.
>>
>> Plus, there may be patterns such as "keep it ON, count number of brief
>> OFFs"...
>>
>> That's why I suggested:
>>
>>>> echo 40> step_length_ms
>>>> echo "- - - "> pattern
>>>>
>>>> do the same trick?
>>>>
>>>> Plus, you could for example do
>>>>
>>>> echo "- --- "> pattern
>>>>
>>>> to do morse code...
>>
>> Interface
>>
>> (Note that your client stripped some spaces out of it).
>>
>> With that, it should be very easy to program all the reasonable
>> blinking patterns for single LED without PWM.
>> Pavel
>> --
>> (english) http://www.livejournal.com/~pavelmachek
>> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at http://www.tux.org/lkml/ --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/ 		 	   		  