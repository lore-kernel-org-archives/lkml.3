Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaIBKIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:08:44 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:48115 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaIBKIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:08:42 -0400
MIME-Version: 1.0
In-Reply-To: <1407852737-17265-1-git-send-email-matthias.bgg@gmail.com>
References: <1407852737-17265-1-git-send-email-matthias.bgg@gmail.com>
Date: Tue, 2 Sep 2014 12:08:40 +0200
Message-ID: <CABuKBeKBr_-riVqDzhepE9goosuaNocHH0K=5XsONEEvSXPi_w@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] tty: serial: Add mediatek UART driver
From: Matthias Brugger <matthias.bgg@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>, jslaby@suse.cz,
        Grant Likely <grant.likely@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alan Cox <alan@linux.intel.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Yingjoe Chen <yingjoe.chen@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-12 16:12 GMT+02:00 Matthias Brugger <matthias.bgg@gmail.com>:
> This patch set adds support for the UART found in Mediatek SoCs.
> The chip is a changed version of a 8250 controller.
> Especially it introduces a new register called highspeed. The value
> in this register has to be set depending on the baudrate. The value
> in the register influences the way the divisor has to be calculated.
>
> The patch series is build against v3.16-rc1 and tested on mt6589. Should
> work as well on mt6577 and mt6582.
>
> Thanks,
> Matthias

Ping: Does anyone has any comment on this series?
Sorry, last mail was HTML by accident.

>
> Changes for v4:
> - delete owner in platform driver instance
> - pass plattform_device to mtk8250_probe_of
> - reorganise probe function to error out early
> - Fix DTS documentation
>
> Changes for v3:
> - use dev_warn instead of pr_warn
> - use 8250_core function to update termios
>
> Changes for v2:
> - drop 8250_core capability extension for the chip
> - encapsulate set_termios in the driver method
>
> ---
>
> Matthias Brugger (2):
>   tty: serial: 8250: Add Mediatek UART driver
>   DTS: serial: Add bindings documention for the Mediatek UARTs
>
>  .../devicetree/bindings/serial/mtk-uart.txt        |   20 ++
>  drivers/tty/serial/8250/8250_mtk.c                 |  294 ++++++++++++++++++++
>  drivers/tty/serial/8250/Kconfig                    |    7 +
>  drivers/tty/serial/8250/Makefile                   |    1 +
>  4 files changed, 322 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/serial/mtk-uart.txt
>  create mode 100644 drivers/tty/serial/8250/8250_mtk.c
>
> --
> 1.7.9.5
>



-- 
motzblog.wordpress.com
