Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaKJRoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:44:06 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:64948 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbaKJRoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:44:03 -0500
Date: Mon, 10 Nov 2014 17:43:55 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, arnd@arndb.de,
        johan@kernel.org, daniel.baluta@intel.com, laurentiu.palcu@intel.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [GIT PULL] Immutable branch between MFD, GPIO and I2C
Message-ID: <20141110174355.GM24004@x1>
References: <1415281685-14866-1-git-send-email-octavian.purdila@intel.com>
 <20141110151226.GD24004@x1>
 <20141110160426.GK24004@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141110160426.GK24004@x1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please don't pull this -- it is missing a patch.
> 
> Will fix.

Okay, dependency fixed.  Sorry for the fuss.  Pull when ready.

> > [Subject change -- in case you miss it]
> > 
> > Linus, Wolfram,
> > 
> > Enjoy!
> > 
> > The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:
> > 
> >   Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/ib-mfd-gpio-i2c-v3.19
> > 
> > for you to fetch changes up to e7d146b11a8a33b6033220b0f4fc4de2ab29218a:
> > 
> >   gpio: add support for the Diolan DLN-2 USB GPIO driver (2014-11-10 15:05:49 +0000)
> > 
> > ----------------------------------------------------------------
> > Immutable branch between MFD, GPIO and I2C
> > 
> > ----------------------------------------------------------------
> > Daniel Baluta (1):
> >       gpio: add support for the Diolan DLN-2 USB GPIO driver
> > 
> > Laurentiu Palcu (1):
> >       i2c: add support for Diolan DLN-2 USB-I2C adapter
> > 
> > Octavian Purdila (1):
> >       mfd: Add support for Diolan DLN-2 devices
> > 
> >  drivers/gpio/Kconfig          |  12 +
> >  drivers/gpio/Makefile         |   1 +
> >  drivers/gpio/gpio-dln2.c      | 553 ++++++++++++++++++++++++++++++
> >  drivers/i2c/busses/Kconfig    |  10 +
> >  drivers/i2c/busses/Makefile   |   1 +
> >  drivers/i2c/busses/i2c-dln2.c | 267 +++++++++++++++
> >  drivers/mfd/Kconfig           |  10 +
> >  drivers/mfd/Makefile          |   1 +
> >  drivers/mfd/dln2.c            | 763 ++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/mfd/dln2.h      | 103 ++++++
> >  10 files changed, 1721 insertions(+)
> >  create mode 100644 drivers/gpio/gpio-dln2.c
> >  create mode 100644 drivers/i2c/busses/i2c-dln2.c
> >  create mode 100644 drivers/mfd/dln2.c
> >  create mode 100644 include/linux/mfd/dln2.h
> > 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
