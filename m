Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbaCNTtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 15:49:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50500 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750757AbaCNTtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 15:49:32 -0400
Date: Fri, 14 Mar 2014 20:49:30 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: leds-atmel-pwm and atmel-pwm-bl removal
Message-ID: <20140314194930.GF3106@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With the new generic pwm framework and the pwm-atmel driver using it, we
don't need leds-atmel-pwm or atmel-pwm-bl anymore. However, a few boards
are still using those:

arch/arm/mach-at91/board-sam9263ek.c
arch/arm/mach-at91/board-sam9m10g45ek.c
arch/avr32/boards/atngw100/mrmt.c
arch/avr32/boards/merisc/setup.c
arch/avr32/boards/favr-32/setup.c

Some other avr32 boards are compiling it as a module but don't seem to
make any use of it.

I will take care of the mach-at91 boards and I can test on those. I can
do the same for the avr32 boards but I won't be able to test (only
to compile). Is anyone of you interested in testing those changes ?

I couldn't reach the initial authors of those files...

Could we simply remove the driver from the avr32 boards ? I'm under the
impression that they don't get much interest anyway, since april 2009,
I only see tree wide changes and I can't believe they didn't get broken
a way or another.

Regards,

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
