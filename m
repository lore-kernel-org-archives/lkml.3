Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbaLCC0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:26:34 -0500
Received: from mga14.intel.com ([192.55.52.115]:44672 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbaLCC0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:26:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,505,1413270000"; 
   d="scan'208";a="631751771"
From: "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "GPIO Subsystem Mailing List" <linux-gpio@vger.kernel.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        Denis Turischev <denis.turischev@compulab.co.il>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: RE: [PATCHv4 3/3] gpio: sch: Enable IRQ support for Quark X1000
Thread-Topic: [PATCHv4 3/3] gpio: sch: Enable IRQ support for Quark X1000
Thread-Index: AQHQCxP5rTKB8exs7kmvwaSE8Boaypx9KkKQ
Date: Wed, 3 Dec 2014 02:26:20 +0000
Message-ID: <50B33AC5ED75F74F991980326F1C438D0FC6DDED@PGSMSX108.gar.corp.intel.com>
References: <1416977280-27319-1-git-send-email-rebecca.swee.fun.chang@intel.com>
	<1416977280-27319-4-git-send-email-rebecca.swee.fun.chang@intel.com>
 <CACRpkdba0XparJCKrV9XrU3dxTnuWhEYGQQMKzi+SDEiOAsapQ@mail.gmail.com>
In-Reply-To: <CACRpkdba0XparJCKrV9XrU3dxTnuWhEYGQQMKzi+SDEiOAsapQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB32QfaD021997

Hi Linus,
Noted, while I continue to work on this IRQ feature, can I resend patch 1 and patch 2 (rebase to devel branch) in v5 thread so that you can pull them in first? 

Regards,
Rebecca

> -----Original Message-----
> From: Linus Walleij [mailto:linus.walleij@linaro.org]
> Sent: 28 November, 2014 10:03 PM
> To: Chang, Rebecca Swee Fun
> Cc: Linux Kernel Mailing List; GPIO Subsystem Mailing List; Westerberg, Mika;
> Denis Turischev; Alexandre Courbot
> Subject: Re: [PATCHv4 3/3] gpio: sch: Enable IRQ support for Quark X1000
> 
> On Wed, Nov 26, 2014 at 5:48 AM, Chang Rebecca Swee Fun
> <rebecca.swee.fun.chang@intel.com> wrote:
> 
> > ntel Quark X1000 GPIO controller supports interrupt handling for both
> > core power well and resume power well. This patch is to enable the IRQ
> > support and provide IRQ handling for Intel Quark X1000 GPIO-SCH device
> > driver.
> >
> > This piece of work is derived from Dan O'Donovan's initial work for
> > Quark X1000 enabling.
> >
> > Signed-off-by: Chang Rebecca Swee Fun
> > <rebecca.swee.fun.chang@intel.com>
> 
> This is just adding handling of cascading interrupts from a GPIO chip as far as I
> can tell. We don't do that with local per-driver hacks anymore if there is no
> special reason, we have helpers on gpiolib to handle this.
> 
> Make your Kconfig select GPIOLIB_IRQCHIP and take it from there, look at how
> other drivers using GPIOLIB_IRQCHIP are done. Read the documentation for
> chained irqchips in Documentation/gpio/driver.txt
> 
> Yours,
> Linus Walleij
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
