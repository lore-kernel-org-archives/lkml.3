Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaIXMf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:35:56 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:50523 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaIXMfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:35:54 -0400
Date: Wed, 24 Sep 2014 13:35:48 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Andreas Werner <andreas.werner@men.de>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, linux@roeck-us.net,
        lm-sensors@lm-sensors.org, wim@iguana.be,
        linux-watchdog@vger.kernel.org, cooloney@gmail.com, rpurdie@rpsys.net,
        linux-leds@vger.kernel.org
Subject: Re: [PATCH v6 2/4] drivers/watchdog/menf21bmc_wdt: introduce MEN
 14F021P00 BMC Watchdog driver
Message-ID: <20140924123548.GE32069@lee--X1>
References: <cover.1409161615.git.andreas.werner@men.de>
 <f21b275c79866e0aa9bbc59e195ae5424e538300.1409161615.git.andreas.werner@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f21b275c79866e0aa9bbc59e195ae5424e538300.1409161615.git.andreas.werner@men.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Andreas Werner wrote:

> Added driver to support the 14F021P00 BMC Watchdog.
> The BMC is a Board Management Controller including watchdog functionality.
> 
> Signed-off-by: Andreas Werner <andreas.werner@men.de>
> ---
>  drivers/watchdog/Kconfig         |  10 ++
>  drivers/watchdog/Makefile        |   1 +
>  drivers/watchdog/menf21bmc_wdt.c | 203 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 214 insertions(+)
>  create mode 100644 drivers/watchdog/menf21bmc_wdt.c

I see no reason to keep this dragging on.  I'm going to apply this
along with the remainder of the set and send a pull-request to all the
other Maintainers.  This branch is currently under test.

Any fix-ups for review comments can go in subsequently.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
