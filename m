Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab3HGQ65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:58:57 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:58133 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab3HGQ64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:58:56 -0400
Message-ID: <52027CCD.3060609@linaro.org>
Date: Wed, 07 Aug 2013 09:58:53 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH] clocksource: add an "menu" item to Kconfig
References: <1375873017-30625-1-git-send-email-bigeasy@linutronix.de> <520273FB.3030103@linaro.org> <52027623.20807@linutronix.de>
In-Reply-To: <52027623.20807@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 09:30 AM, Sebastian Andrzej Siewior wrote:
> On 08/07/2013 06:21 PM, John Stultz wrote:
>> On 08/07/2013 03:56 AM, Sebastian Andrzej Siewior wrote:
>>> This patch adds a menu item to clocksource' Kconfig file. Without it the
>>> changeable items look somehow lost in the main drivers' menu
>> So I'd like to push back on this a bit and ask why we need user-visible
>> clocksource config options?
> There was one visible Option if I remember correctly. I added two and
> was wondering once I found them. I do have a PCI card which provides a
> clock source and clock events device. So I assumed select <m|y> would
> be doable.

PCI card, eh? (Heh. In writing my previous mail, I think I even wrote 
"These are clocksources soldered to the motherboard, not pci cards!", 
but deleted it as it didn't seem useful. :)

So I think that's actually a first for clocksource drivers.

So, if there are genuinely cross-architecture pluggable clocksources, 
that aren't part of a platform definition, I would be ok with making an 
exception. But I'd want to make sure that we kept a high-bar for adding 
clocksource options, so that folks don't just clutter up the Kconfig menu.

That said, Daniel (now cc'ed - sorry for not cc'ing you earlier!) is now 
in charge of the clocksource directory, so my objections and wishes 
aren't as important as his.

thanks
-john

