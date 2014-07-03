Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbaGCQTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:19:54 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:64687 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759498AbaGCQTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:19:51 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.59.197]
In-Reply-To: <20140703160622.GE23309@earth.universe>
References: <1404316809-20637-1-git-send-email-bigeasy@linutronix.de>
	<20140702160932.GF5541@saruman.home>
	<20140702190944.GA567@drone.musicnaut.iki.fi>
	<CAOCHtYgxMeA+Arfe40XeFDEKuCJ8qo1RqNR0hYBGr_Wp6sRfdA@mail.gmail.com>
	<20140703073411.GX28884@atomide.com>
	<20140703132509.GA5814@saruman.home>
	<CAOCHtYi0JwRO12gHa+KFGH1k7pPk4TL40igwhzRRxutw-tqf6A@mail.gmail.com>
	<20140703140736.GF5814@saruman.home>
	<20140703154425.GC23309@earth.universe>
	<20140703155240.GU5814@saruman.home>
	<20140703160622.GE23309@earth.universe>
Date: Thu, 3 Jul 2014 18:19:47 +0200
Message-ID: <CABxcv=nGPyK7SeQZ+W1ZEfBPQ-RraVTawyYuKOGz02df0g=6Qg@mail.gmail.com>
Subject: Re: [RFC PATCH] tty: serial: Add 8250-core based omap driver
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Sebastian Reichel <sre@kernel.org>
Cc: Felipe Balbi <balbi@ti.com>, Robert Nelson <robertcnelson@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2014 at 6:06 PM, Sebastian Reichel <sre@kernel.org> wrote:
> Hi,
>
> On Thu, Jul 03, 2014 at 10:52:40AM -0500, Felipe Balbi wrote:
>> > DT is supposed to contain information about the hardware, so it
>> > should stay the same? I think there is no non-hackish way to decide
>>
>> compatible would change, at a minimum.
>
> why? I would expect it to stay the same (and the current patch uses
> the same compatible strings).
>

Exactly, the new driver must support all the compatible strings
defined in Documentation/devicetree/bindings/serial/omap_serial.tx
(which already does as you pointed out).

Otherwise the current drivers/tty/serial/omap-serial.c could never be
removed since that would mean breaking DT backward compatibility.

> -- Sebastian

Best regards,
Javier
