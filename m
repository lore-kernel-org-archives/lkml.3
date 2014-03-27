Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbaC0SVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 14:21:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60258 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756810AbaC0SVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 14:21:04 -0400
Date: Thu, 27 Mar 2014 19:21:00 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Bryan Wu <cooloney@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-arm-kernel@lists.infradead.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-leds@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 00/16] move at91 and avr32 to the PWM framework, remove
 obsolete drivers
Message-ID: <20140327182100.GH2915@piout.net>
References: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
 <5334633E.6050708@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5334633E.6050708@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 27/03/2014 at 18:43:26 +0100, Nicolas Ferre wrote :
> On 19/03/2014 14:03, Alexandre Belloni :
> > Alexandre Belloni (16):
> >   ARM: at91: at91sam9g45: switch to generic PWM framework
> >   ARM: at91: sam9m10g45ek: use generic leds_pwm driver
> >   ARM: at91: at91sam9263: switch to generic PWM framework
> >   ARM: at91: sam9263ek: use generic leds_pwm driver
> >   ARM: at91: at91sam9rl: switch to generic PWM framework
> >   ARM: at91: remove useless at91_pwm_leds()
> >   PWM: atmel: allow building for AVR32
> >   backlight: pwm_bl: set pwm polarity when using platform data

Please wait for Thierry Reding to comment on this one...

> >   avr32/at32ap: switch to the generic PWM framework
> >   avr32: MRMT: use generic leds_pwm driver
> >   avr32: merisc: use generic leds_pwm driver
> >   avr32: favr-32: use generic pwm_bl driver
> >   avr32: update defconfig to use the generic PWM framework
> >   backlight: atmel-pwm-bl: remove obsolete driver
> >   leds: atmel-pwm: remove obsolete driver

...watch out for the small typo (pawm-atmel) I made there...

> >   misc: atmel_pwm: remove obsolete driver
> 
> I am fine with the whole series. For the AT91 specific bits, you can add my:
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> It is a very nice cleanup and I can take the series with me in the AT91
> git tree (likely the at91-3.16-cleanup or at91-3.16-drivers branch) if
> everybody agree.
> 

... but I believe you can take it through your tree as it mostly depends
on AT91 and Hans-Christian seemed fine with the modifications on avr32.

Regards,

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
