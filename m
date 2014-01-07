Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbaAGJJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:09:47 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:40655 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaAGJJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:09:43 -0500
Date: Tue, 7 Jan 2014 09:09:38 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Add GPIO support for the MAX6650/6651 ICs
Message-ID: <20140107090938.GF3182@lee--X1>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387814889-16670-1-git-send-email-lpapp@kde.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't send private, off-list emails for poking or anything else
related to upstreamming patches.

> Important text here later. It is now just an attempt to get some feedback about
> the design of the new features. This set has only been compilation tested, and
> has many errors with checkpatch.pl, et al. Really, the point is only to get
> feedback about the direction, as there has been a lot of paid work put into
> this to work better with upstream after the previously rejected change simple
> hwmon change.

If you want to obtain time/advice from maintainers, most of which are
already snowed-under, you have to earn it. Making submissions such as
these are not conducive to your cause. Fix the Checkpatch errors and
do your damnedest to ensure the code is the finest standard it can be.

If you fail to adhere to these [1] three documents accidentally, then
you will be guided. If you do so on purpose by sending intentionally
sloppy code, then you are unlikely to gain any attention at all.

[1]
  Documentation/CodingStyle
  Documentation/email-clients.txt
  Documentation/SubmittingPatches

> Laszlo Papp (3):
>   mfd: MAX6650/6651 support
>   hwmon: (max6650) Convert to be a platform driver
>   gpio: MAX6650/6651 support
> 
>  drivers/gpio/Kconfig                |  14 ++
>  drivers/gpio/Makefile               |   2 +
>  drivers/gpio/gpio-max6651.c         |  72 +++++++++
>  drivers/gpio/gpio-max665x.c         | 301 ++++++++++++++++++++++++++++++++++++
>  drivers/hwmon/Kconfig               |   2 +-
>  drivers/hwmon/max6650.c             | 150 +++++++++---------
>  drivers/mfd/Kconfig                 |  11 ++
>  drivers/mfd/Makefile                |   1 +
>  drivers/mfd/max6651.c               | 132 ++++++++++++++++
>  include/linux/mfd/max6651-private.h |  63 ++++++++
>  10 files changed, 675 insertions(+), 73 deletions(-)
>  create mode 100644 drivers/gpio/gpio-max6651.c
>  create mode 100644 drivers/gpio/gpio-max665x.c
>  create mode 100644 drivers/mfd/max6651.c
>  create mode 100644 include/linux/mfd/max6651-private.h
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
