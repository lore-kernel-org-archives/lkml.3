Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaFWVgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 17:36:17 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:47144 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaFWVgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 17:36:16 -0400
MIME-Version: 1.0
In-Reply-To: <53A583DC.504@ahsoftware.de>
References: <20140611230127.GA28066@griso.site>
	<CANcMJZDqAmdFLYq2LW60zU_d05Pv8tcYE1Nb=ftZcj5UukxqaA@mail.gmail.com>
	<53A583DC.504@ahsoftware.de>
Date: Mon, 23 Jun 2014 14:36:15 -0700
Message-ID: <CALAqxLUYbp9qXpFusw=Nteqht33Lz9ch5g6Ptv1cMoFEgC+M9Q@mail.gmail.com>
Subject: Re: rtc/hctosys.c Problem during kernel boot
From: John Stultz <john.stultz@linaro.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: John Whitmore <arigead@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2014 at 6:08 AM, Alexander Holler <holler@ahsoftware.de> wrote:
> Am 12.06.2014 01:53, schrieb John Stultz:
>
>> You can read some of the previous discussion here:
>> https://lkml.org/lkml/2013/6/17/533
>>
>> I'd be very interested in patches to resolve this!
>
>
> And the silence as response to my repost of my already working patches just
> proved that isn't true.

You put in your patches the following:
"Besides discussing possible *real* bugs, I don't care what any person
 (including maintainers) will request. I'm fine with these patches (I'm
 using them since a year) and I don't play remote keyboard or
 patch ping-pong. If someone want changes I suggest he gets responsible
 for them himself and just puts a patch on top of my patches. And in any
 case, feel free to completely ignore these patches."

I've pointed out problems with your patchset earlier, and you refuse
to address them. That's totally your prerogative, and that's fine, but
I don't know how I should respond here.

I agree that there is an issue here that your patches try to address,
which needs to be fixed, but I'm hoping John Whitmore might be able to
read the discussion and either rework your patches or write his own to
address the issue without the problems in your patch I pointed out.

I've removed the rest of your anti-maintainer rant here, but I will
say that I do very much understand that the upstream kernel community
process can be frustrating at times. I have myself had to start over
many many times on patches when maintainers request, and sometimes my
patches don't ever make it past the bar for acceptance. So I very much
do see this from both sides, and despite my frustration, I appreciate
that folks are looking over my patches carefully for design and
maintenance issues, because without the high standards, the kernel
code would be in much worse shape.

Similarly I appreciate your continued participation here, even if its
just to resend your patches and provide more context to others wanting
to solve the issue properly. But it might be better not get into
personal tangents, and instead focus on the technical merits and
issues with the potential approaches.

thanks
-john
