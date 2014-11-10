Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaKJPhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:37:32 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:45633 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaKJPh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:37:29 -0500
MIME-Version: 1.0
In-Reply-To: <20141110151019.GC24004@x1>
References: <1415281685-14866-1-git-send-email-octavian.purdila@intel.com>
	<20141110151019.GC24004@x1>
Date: Mon, 10 Nov 2014 17:37:28 +0200
Message-ID: <CAE1zotLmLMLm=3HMmL55TXWf4frCryWCLGnhEUw8f9H+GpY4tA@mail.gmail.com>
Subject: Re: [PATCH v11 0/3] add support for Diolan DLN-2
From: Octavian Purdila <octavian.purdila@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Wolfram Sang <wsa@the-dreams.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Johan Hovold <johan@kernel.org>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 5:10 PM, Lee Jones <lee.jones@linaro.org> wrote:
> Linus, Wolfram,
>
> Enjoy!
>
> The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:
>
>   Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/ib-mfd-gpio-i2c-v3.19

Hi Lee,

Not sure if this matter, but this tree seems to miss the
mfd_add_hotplug_devices patches from Johan, which are needed by the
patches below.

>
> for you to fetch changes up to e7d146b11a8a33b6033220b0f4fc4de2ab29218a:
>
>   gpio: add support for the Diolan DLN-2 USB GPIO driver (2014-11-10 15:05:49 +0000)
>
> ----------------------------------------------------------------
> Immutable branch between MFD, GPIO and I2C
>
> ----------------------------------------------------------------
> Daniel Baluta (1):
>       gpio: add support for the Diolan DLN-2 USB GPIO driver
>
> Laurentiu Palcu (1):
>       i2c: add support for Diolan DLN-2 USB-I2C adapter
>
> Octavian Purdila (1):
>       mfd: Add support for Diolan DLN-2 devices
>
>  drivers/gpio/Kconfig          |  12 +
>  drivers/gpio/Makefile         |   1 +
>  drivers/gpio/gpio-dln2.c      | 553 ++++++++++++++++++++++++++++++
>  drivers/i2c/busses/Kconfig    |  10 +
>  drivers/i2c/busses/Makefile   |   1 +
>  drivers/i2c/busses/i2c-dln2.c | 267 +++++++++++++++
>  drivers/mfd/Kconfig           |  10 +
>  drivers/mfd/Makefile          |   1 +
>  drivers/mfd/dln2.c            | 763 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/dln2.h      | 103 ++++++
>  10 files changed, 1721 insertions(+)
>  create mode 100644 drivers/gpio/gpio-dln2.c
>  create mode 100644 drivers/i2c/busses/i2c-dln2.c
>  create mode 100644 drivers/mfd/dln2.c
>  create mode 100644 include/linux/mfd/dln2.h
>
> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
