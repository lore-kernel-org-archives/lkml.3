Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaHDQHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:07:19 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38679 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaHDQHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:07:18 -0400
MIME-Version: 1.0
Reply-To: markus@gutschke.com
In-Reply-To: <20140804141613.GB24261@amd.pavel.ucw.cz>
References: <CALGCz1qs2A7BCbcK3vzYRxJeOESVKc7c9kcSpP0NrQFLr1UpUg@mail.gmail.com>
 <CALGCz1oYYkKp1frPF4vExiwqW=euYY8An+Yum4U-qsBc5NyjFg@mail.gmail.com>
 <1405587482.28592.64.camel@rzhang1-toshiba> <CALGCz1qzmK_0Mq8JNFYUnGtDGWSqYoHfqv0MKbqG1RySQ4bt6g@mail.gmail.com>
 <1405988531.2455.14.camel@rzhang1-toshiba> <CALGCz1okgr4K9S+6NfohM1Y3LregQLEKaj7FuON0xkk7xX1Jhg@mail.gmail.com>
 <20140804141613.GB24261@amd.pavel.ucw.cz>
From: Markus Gutschke <markus@gutschke.com>
Date: Mon, 4 Aug 2014 09:06:52 -0700
X-Google-Sender-Auth: _vZjKUCFkU8beEi0H6TFOZmpu5Y
Message-ID: <CALGCz1oG2g-UsK7FnxRRj7R5n6yxwJey0EBcP8ctRYSGjfw==Q@mail.gmail.com>
Subject: Re: 3.16-rcX crashes on resume from Suspend-To-RAM
To: Pavel Machek <pavel@ucw.cz>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for checking in. And no, I have not heard from Zhang since my
last e-mail. I suspect he is still working on finding a solution. But
you are of course right, reverting the patch in the meantime might be
a good idea. I would love to be able to suspend my laptop again. But I
defer to Zhang for the final decision. As long as it gets fixed
eventually, I can personally live with a few weeks of delay while
things get worked out. And of course, as offered before, I'll run
whatever tests Zhang asks me to do.


Markus

On Mon, Aug 4, 2014 at 7:16 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Sat 2014-07-26 08:52:34, Markus Gutschke wrote:
>> Sorry for the delay. Remotely debugging kernels over a shared and
>> flaky 1MBps terrestrial wireless connection is quite a new experience
>> to me.
>>
>> In any case, I was able to collect all the data that you asked for. I
>> then used "pm-suspend" to put the machine to sleep and asked a helper
>> to physically press the power button to wake the computer back up. My
>> helper told me that it crashed just as before, and they had to
>> power-cycle the machine to bring it back to life.
>>
>> Please let me know, what other data I can get for you. And thank you
>> very much for putting up with my slow turn-around. I should have much
>> better response time again in about two to three weeks when I return
>> to civilization.
>
> Was this solved, somehow?
>
> If not, can we revert the patch that causes it?
>                                                                 Pavel
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
