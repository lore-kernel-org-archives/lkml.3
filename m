Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab3HLNGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:06:15 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:61856 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab3HLNGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:06:12 -0400
Message-ID: <5208DDC0.5090200@linaro.org>
Date: Mon, 12 Aug 2013 15:06:08 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] clocksource: add an "menu" item to Kconfig
References: <1375873017-30625-1-git-send-email-bigeasy@linutronix.de> <520273FB.3030103@linaro.org> <52027623.20807@linutronix.de> <52027CCD.3060609@linaro.org> <5208DB43.6030404@linaro.org> <5208DD60.7080402@linutronix.de>
In-Reply-To: <5208DD60.7080402@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 03:04 PM, Sebastian Andrzej Siewior wrote:
> On 08/12/2013 02:55 PM, Daniel Lezcano wrote:
>> Sebastian,
> 
> Hi Daniel,
> 
>> instead of adding a menu item in the Kconfig, is it possible to have
>> this Kconfig PCI board support to select the right driver ?
> 
> I decided to go with only with "tristate" so it does not pop up in
> Kconfig and will be selected by the MFD/PCI driver. Is this what you
> have in mind?

Yes, right. The clocksource's Kconfig is kept untouched.

Thanks
  -- Daniel

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

