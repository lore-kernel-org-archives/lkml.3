Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaIXQSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:18:45 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:62791 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaIXQSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:18:44 -0400
Date: Wed, 24 Sep 2014 17:18:37 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Andreas Werner <andreas.werner@men.de>, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, lm-sensors@lm-sensors.org, wim@iguana.be,
        linux-watchdog@vger.kernel.org, cooloney@gmail.com, rpurdie@rpsys.net,
        linux-leds@vger.kernel.org
Subject: Re: [PATCH v6 0/4] Introduce MEN 14F021P00 BMC driver series
Message-ID: <20140924161837.GA7113@lee--X1>
References: <cover.1409161615.git.andreas.werner@men.de>
 <20140924144829.GK32069@lee--X1>
 <20140924154503.GA12403@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140924154503.GA12403@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014, Guenter Roeck wrote:

> On Wed, Sep 24, 2014 at 03:48:29PM +0100, Lee Jones wrote:
> > Guenter, Bryan, Wim,
> > 
> > The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:
> > 
> >   Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-hwmon-leds-watchdog-v3.18
> > 
> > for you to fetch changes up to 964356938fcd3c0001a786f55b9f0a0fbe47656a:
> > 
> >   hwmon: (menf21bmc) Introduce MEN14F021P00 BMC HWMON driver (2014-09-24 15:36:33 +0100)
> > 
> > ----------------------------------------------------------------
> > Immutable branch between MFD, HWMON, LEDs and Watchdog for v3.18
> > 
> I assume you'll push it all through mfd, correct ?

The idea is for all the affected Maintainers to pull this branch in to
their own trees.  If you guys don't, there will be a good chance of
conflict during the merge-window, which will subsequently upset Linus.

So in answer to your question; yes I'll be taking this, but so should
each of you.

> > ----------------------------------------------------------------
> > Andreas Werner (4):
> >       mfd: menf21bmc: Introduce MEN 14F021P00 BMC MFD Core driver
> >       watchdog: menf21bmc_wdt: Introduce MEN 14F021P00 BMC Watchdog driver
> >       leds: leds-menf21bmc: Introduce MEN 14F021P00 BMC LED driver
> >       hwmon: (menf21bmc) Introduce MEN14F021P00 BMC HWMON driver
> > 
> >  Documentation/hwmon/menf21bmc    |  50 +++++++++
> >  drivers/hwmon/Kconfig            |  10 ++
> >  drivers/hwmon/Makefile           |   1 +
> >  drivers/hwmon/menf21bmc_hwmon.c  | 230 +++++++++++++++++++++++++++++++++++++++
> >  drivers/leds/Kconfig             |   9 ++
> >  drivers/leds/Makefile            |   1 +
> >  drivers/leds/leds-menf21bmc.c    | 131 ++++++++++++++++++++++
> >  drivers/mfd/Kconfig              |  15 +++
> >  drivers/mfd/Makefile             |   1 +
> >  drivers/mfd/menf21bmc.c          | 132 ++++++++++++++++++++++
> >  drivers/watchdog/Kconfig         |  10 ++
> >  drivers/watchdog/Makefile        |   1 +
> >  drivers/watchdog/menf21bmc_wdt.c | 203 ++++++++++++++++++++++++++++++++++
> >  13 files changed, 794 insertions(+)
> >  create mode 100644 Documentation/hwmon/menf21bmc
> >  create mode 100644 drivers/hwmon/menf21bmc_hwmon.c
> >  create mode 100644 drivers/leds/leds-menf21bmc.c
> >  create mode 100644 drivers/mfd/menf21bmc.c
> >  create mode 100644 drivers/watchdog/menf21bmc_wdt.c
> > 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
