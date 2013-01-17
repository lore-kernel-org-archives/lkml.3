Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab3AQMCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 07:02:17 -0500
Received: from outbound-mail02.westnet.com.au ([203.10.1.243]:40319 "EHLO
	outbound-mail02.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753880Ab3AQMCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 07:02:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAMbm91CVhxBY/2dsb2JhbAANN745gxEBAQEEeAEQCxgJFg8JAwIBAgFFBg0BBQIBAa9okhONAIQ4A6lcgV0
X-IronPort-AV: E=Sophos;i="4.84,484,1355068800"; 
   d="scan'208";a="305750796"
Message-ID: <50F7E83E.8000105@uclinux.org>
Date: Thu, 17 Jan 2013 22:02:06 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Arnd Bergmann <arnd@arndb.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
        Alex Courbot <acourbot@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Steven King <sfking@fdwdc.com>
Subject: Re: [PATCH 0/4] gpio: introduce descriptor-based interface
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com> <201301091046.13020.arnd@arndb.de> <2270940.DTxEYMZtED@percival> <201301101008.45091.arnd@arndb.de> <CACRpkda6dqAj+DzrMCnKET7Z9PtuW0+k9ea3YDL8Z1D=oFVRpQ@mail.gmail.com>
In-Reply-To: <CACRpkda6dqAj+DzrMCnKET7Z9PtuW0+k9ea3YDL8Z1D=oFVRpQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

(My gerg@snapgear.com email no longer gets to me, gerg@uclinux.org is
the best direct email for me now).

On 01/17/2013 09:15 PM, Linus Walleij wrote:
> On Thu, Jan 10, 2013 at 11:08 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
>> I've tried to find platforms that don't yet use GPIOLIB and fortunately
>> there are very few left:
>>
>> I found two that provide the generic gpio interfaces when gpiolib
>> is disabled, but use gpiolib otherwise for the same hardware,
>> arch/m68k/include/asm/mcfgpio.h and arch/blackfin/include/asm/gpio.h.
>> I would assume that we can simply remove the non-gpiolib shortcut
>> here at cost of a small overhead.
> 
> Geert/Greg: interested in looking into this issue?
> 
> The GPIO maintainers want to get rid of non-gpiolib platforms.

Steven King did most of the ColdFire GPIO work (CC'ed on this).
Steven: are you happy to drop the non-gpiolib support?

Regards
Greg

