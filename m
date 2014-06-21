Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbaFUNJD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 09:09:03 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:55310 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbaFUNJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 09:09:01 -0400
Message-ID: <53A583DC.504@ahsoftware.de>
Date: Sat, 21 Jun 2014 15:08:44 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>, John Whitmore <arigead@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: rtc/hctosys.c Problem during kernel boot
References: <20140611230127.GA28066@griso.site> <CANcMJZDqAmdFLYq2LW60zU_d05Pv8tcYE1Nb=ftZcj5UukxqaA@mail.gmail.com>
In-Reply-To: <CANcMJZDqAmdFLYq2LW60zU_d05Pv8tcYE1Nb=ftZcj5UukxqaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.06.2014 01:53, schrieb John Stultz:

> You can read some of the previous discussion here:
> https://lkml.org/lkml/2013/6/17/533
>
> I'd be very interested in patches to resolve this!

And the silence as response to my repost of my already working patches 
just proved that isn't true.

So (John Whitmore), I suggest to not post patches, Linux kernel 
maintainers don't really have an interest in getting things done or to 
fix bugs, they just need fresh meat they can review in order to have job 
security and prove their status.

I really wonder what's their expectation. Do they really think other 
people have to incorporate their (often silly) requests, making the 
maintainers themself not responsible for their requested changes? Do 
they think other people have fun and time to write and post patches 
again and again just to make some arbitrary maintainer happy?

If there really would be an interest, a reasonable approach would be to 
just take my patches and put a patch on top with whatever changes 
someone thinks are needed. As I don't think there are changes needed, I 
will not add such changes using my name as author.

And don't try to tell me I'm uncooperative. I've spend time to write 
these patches and even have written documentation I don't need myself. 
The uncooperative people which are blocking almost everthing and which 
do ignore bugs have become these people which are calling themself Linux 
kernel maintainers which do expect other people have to play remote 
keyboard and have to take responsibility for changes maintainers don't 
want to be responsible for themself.

So the above quoted sentence is just another "marketing" verbiage, at 
least in my point of view.

Alexander Holler

