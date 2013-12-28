Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab3L1NkJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 08:40:09 -0500
Received: from [65.55.111.173] ([65.55.111.173]:32886 "EHLO
	blu0-omc4-s34.blu0.hotmail.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755356Ab3L1NkH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 08:40:07 -0500
X-TMN: [QDAPvtLYAG7AAKiL34JQG88WTLds4hXv]
X-Originating-Email: [lgxue@hotmail.com]
Message-ID: <BLU172-W7ED2FA23CAA436EA47FCBACCC0@phx.gbl>
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
Date: Sat, 28 Dec 2013 08:39:46 -0500
Importance: Normal
In-Reply-To: <20131228101622.GA13564@amd.pavel.ucw.cz>
References: <1387895407-28031-1-git-send-email-lgxue@hotmail.com>,<20131225230935.GB13593@amd.pavel.ucw.cz>,<BLU172-W52032BFEF4512123D7516EACC20@phx.gbl>,<20131226142607.GA15225@amd.pavel.ucw.cz>,<BLU172-W30E6E7C0BC2B6C08FA0552ACCD0@phx.gbl>,<20131227095705.GC17143@amd.pavel.ucw.cz>,<BLU172-W8D850A8DEA8C0D87FBF45ACCC0@phx.gbl>,<20131228101622.GA13564@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 28 Dec 2013 13:39:47.0126 (UTC) FILETIME=[461B8D60:01CF03D2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>> Good idea.
>> I have finished but I'll change it to this way soon and test it in next some days.
>>
>> What the idea about the character to indicate stop?
>>
>> I mean this patten maybe indicate just once maybe indicate repeatedly until the next patten.
>>
>> What about "/"?
>> If there is a "/" at end then stop it else repeat it?
>
> Actually, I'd put a do_repeat attribute somewhere instead of using
> magic character for automatic repeats.

Use this way, the user or application don't have to access two attribution files to control LEDs, and without "/" is default. If application need to blink patten once just give a "/" at the end of patten.

> And while " " for pause and "#" for light would work. Maybe we chould
> do "\0" for pause and "\177" for light... and interpret everything
> between as an intensity. That will make it useful for LEDs with
> variable intensites, too...

"\0" is not easy to give if application is a script.
intensity is a good idea, but makes it more complex, and user need to convert the "\num" to a ASCII code.

Joe 		 	   		  