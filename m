Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab3LKUPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 15:15:31 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:42337 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab3LKUP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 15:15:27 -0500
MIME-Version: 1.0
In-Reply-To: <1386364179-28650-1-git-send-email-delicious.quinoa@gmail.com>
References: <1386364179-28650-1-git-send-email-delicious.quinoa@gmail.com>
Date: Wed, 11 Dec 2013 14:15:25 -0600
Message-ID: <CANk1AXS=CADN53aO5KVN3UorddJ0wZ2PTqwo2XmeRuxYe_DoLg@mail.gmail.com>
Subject: Re: [PATCH v9] gpio: add a driver for Synopsys DesignWare APB GPIO
From: delicious quinoa <delicious.quinoa@gmail.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jamie Iles <jamie@jamieiles.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        delicious quinoa <delicious.quinoa@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 6, 2013 at 3:09 PM, Alan Tull <delicious.quinoa@gmail.com> wrote:
> From: Alan Tull <atull@altera.com>
>
> Hi Linus,
>
> If you don't have any further comments, can you take this patch?
>
> Alan

Basically, this is a driver that Jamie wrote and was upstreaming a few
years ago.  For some reason it never quite made it into the kernel.  I
picked it up, updated the interrupt support, posted it to the list and
went through some reviews with it.

This driver has been reviewed, I hope it can make it into the kernel.

Alan

>
> Jamie Iles (1):
>   gpio: add a driver for the Synopsys DesignWare APB GPIO block
>
>  .../devicetree/bindings/gpio/snps-dwapb-gpio.txt   |   59 +++
>  drivers/gpio/Kconfig                               |    9 +
>  drivers/gpio/Makefile                              |    1 +
>  drivers/gpio/gpio-dwapb.c                          |  415 ++++++++++++++++++++
>  4 files changed, 484 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
>  create mode 100644 drivers/gpio/gpio-dwapb.c
>
> --
> 1.7.9.5
>
>
