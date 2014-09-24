Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaIXONb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:13:31 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:52744 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaIXON3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:13:29 -0400
Date: Wed, 24 Sep 2014 15:13:22 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Andreas Werner <andreas.werner@men.de>, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, lm-sensors@lm-sensors.org, wim@iguana.be,
        linux-watchdog@vger.kernel.org, cooloney@gmail.com, rpurdie@rpsys.net,
        linux-leds@vger.kernel.org
Subject: Re: [PATCH v6 2/4] drivers/watchdog/menf21bmc_wdt: introduce MEN
 14F021P00 BMC Watchdog driver
Message-ID: <20140924141322.GG32069@lee--X1>
References: <cover.1409161615.git.andreas.werner@men.de>
 <f21b275c79866e0aa9bbc59e195ae5424e538300.1409161615.git.andreas.werner@men.de>
 <20140924123548.GE32069@lee--X1>
 <5422C612.70906@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5422C612.70906@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014, Guenter Roeck wrote:
> On 09/24/2014 05:35 AM, Lee Jones wrote:
> >On Wed, 27 Aug 2014, Andreas Werner wrote:
> >
> >>Added driver to support the 14F021P00 BMC Watchdog.
> >>The BMC is a Board Management Controller including watchdog functionality.
> >>
> >>Signed-off-by: Andreas Werner <andreas.werner@men.de>
> >>---
> >>  drivers/watchdog/Kconfig         |  10 ++
> >>  drivers/watchdog/Makefile        |   1 +
> >>  drivers/watchdog/menf21bmc_wdt.c | 203 +++++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 214 insertions(+)
> >>  create mode 100644 drivers/watchdog/menf21bmc_wdt.c
> >
> >I see no reason to keep this dragging on.  I'm going to apply this
> >along with the remainder of the set and send a pull-request to all the
> >other Maintainers.  This branch is currently under test.
> >
> >Any fix-ups for review comments can go in subsequently.
> >
> Tend to agree. I thought I sent it before, but in case I didn't
> 
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> 
> [ for the watchdog driver ]

Sorry Guenter, the branch is tested, tagged and pushed.

Will be sending a pull-request shortly.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
