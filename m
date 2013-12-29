Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab3L2AXu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 19:23:50 -0500
Received: from blu0-omc4-s34.blu0.hotmail.com ([65.55.111.173]:35887 "EHLO
	blu0-omc4-s34.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751047Ab3L2AXt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 19:23:49 -0500
X-TMN: [KkUz0Gw6UV6v3CoK4es+E1qTgmUGYE11]
X-Originating-Email: [lgxue@hotmail.com]
Message-ID: <BLU172-W44367CDA588A7077F0987ACCF0@phx.gbl>
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
Date: Sat, 28 Dec 2013 19:23:47 -0500
Importance: Normal
In-Reply-To: <20131228192630.GA28026@amd.pavel.ucw.cz>
References: <1387895407-28031-1-git-send-email-lgxue@hotmail.com>,<20131225230935.GB13593@amd.pavel.ucw.cz>,<BLU172-W52032BFEF4512123D7516EACC20@phx.gbl>,<20131226142607.GA15225@amd.pavel.ucw.cz>,<BLU172-W30E6E7C0BC2B6C08FA0552ACCD0@phx.gbl>,<20131227095705.GC17143@amd.pavel.ucw.cz>,<BLU172-W8D850A8DEA8C0D87FBF45ACCC0@phx.gbl>,<20131228101622.GA13564@amd.pavel.ucw.cz>,<BLU172-W7ED2FA23CAA436EA47FCBACCC0@phx.gbl>,<20131228192630.GA28026@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 29 Dec 2013 00:23:48.0355 (UTC) FILETIME=[3E132D30:01CF042C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

I have finished the patten trigger and have tested it.
Do you mind me putting your name as suggest-by? For part idea is from you.

Joe
----------------------------------------
> Date: Sat, 28 Dec 2013 20:26:30 +0100
> From: pavel@ucw.cz
> To: lgxue@hotmail.com
> CC: cooloney@gmail.com; rpurdie@rpsys.net; rob@landley.net; milo.kim@ti.com; linux-leds@vger.kernel.org; linux-kernel@vger.kernel.org; linux-doc@vger.kernel.org
> Subject: Re: [PATCH] Add the LED burst trigger
>
> Hi!
>
>>> And while " " for pause and "#" for light would work. Maybe we chould
>>> do "\0" for pause and "\177" for light... and interpret everything
>>> between as an intensity. That will make it useful for LEDs with
>>> variable intensites, too...
>>
>> "\0" is not easy to give if application is a script.
>> intensity is a good idea, but makes it more complex, and user need to convert the "\num" to a ASCII code.
>>
>
>
> OTOH it is easier for C programs _and_ we can support different
> brightness levels.
>
> It is not that bad from script:
>
> echo -ne '\0\051\0377'> foo...
>
> Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/ 		 	   		  