Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab3HLMzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 08:55:37 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:36443 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3HLMzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 08:55:35 -0400
Message-ID: <5208DB43.6030404@linaro.org>
Date: Mon, 12 Aug 2013 14:55:31 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] clocksource: add an "menu" item to Kconfig
References: <1375873017-30625-1-git-send-email-bigeasy@linutronix.de> <520273FB.3030103@linaro.org> <52027623.20807@linutronix.de> <52027CCD.3060609@linaro.org>
In-Reply-To: <52027CCD.3060609@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 06:58 PM, John Stultz wrote:
> On 08/07/2013 09:30 AM, Sebastian Andrzej Siewior wrote:
>> On 08/07/2013 06:21 PM, John Stultz wrote:
>>> On 08/07/2013 03:56 AM, Sebastian Andrzej Siewior wrote:
>>>> This patch adds a menu item to clocksource' Kconfig file. Without it
>>>> the
>>>> changeable items look somehow lost in the main drivers' menu
>>> So I'd like to push back on this a bit and ask why we need user-visible
>>> clocksource config options?
>> There was one visible Option if I remember correctly. I added two and
>> was wondering once I found them. I do have a PCI card which provides a
>> clock source and clock events device. So I assumed select <m|y> would
>> be doable.
> 
> PCI card, eh? (Heh. In writing my previous mail, I think I even wrote
> "These are clocksources soldered to the motherboard, not pci cards!",
> but deleted it as it didn't seem useful. :)
> 
> So I think that's actually a first for clocksource drivers.
> 
> So, if there are genuinely cross-architecture pluggable clocksources,
> that aren't part of a platform definition, I would be ok with making an
> exception. But I'd want to make sure that we kept a high-bar for adding
> clocksource options, so that folks don't just clutter up the Kconfig menu.
> 
> That said, Daniel (now cc'ed - sorry for not cc'ing you earlier!) is now
> in charge of the clocksource directory, so my objections and wishes
> aren't as important as his.

Sebastian,

instead of adding a menu item in the Kconfig, is it possible to have
this Kconfig PCI board support to select the right driver ?

Thanks
  -- Daniel


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

