Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbaGBTZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:25:59 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:41938 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbaGBTZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:25:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140702190944.GA567@drone.musicnaut.iki.fi>
References: <1404316809-20637-1-git-send-email-bigeasy@linutronix.de>
	<20140702160932.GF5541@saruman.home>
	<20140702190944.GA567@drone.musicnaut.iki.fi>
Date: Wed, 2 Jul 2014 14:25:56 -0500
Message-ID: <CAOCHtYgxMeA+Arfe40XeFDEKuCJ8qo1RqNR0hYBGr_Wp6sRfdA@mail.gmail.com>
Subject: Re: [RFC PATCH] tty: serial: Add 8250-core based omap driver
From: Robert Nelson <robertcnelson@gmail.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
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

On Wed, Jul 2, 2014 at 2:09 PM, Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
> Hi,
>
> On Wed, Jul 02, 2014 at 11:09:32AM -0500, Felipe Balbi wrote:
>> > It has been only tested as console UART.
>> > The tty name is ttyS based instead of ttyO. How big is the pain here,
>> > what could be the easiest way to provide compatibility?
>>
>> have been considering that myself for months. You could pass an optional
>> argument to serial8250_register_8250_port() but that only solves part of
>> the problem :-(
>
> When ttyS -> ttyO change was done on OMAP, compatibility was not an issue.
> Why should we care about it now?

It would be a good opportunity to force everyone to update their bootloader. ;)

Besides the BeagleBoard forum is quiet now, no one is complaining
about that old (ttyS -> ttyO) transition anymore..

I'll just end up carrying a patch like, to support bb.org users over
the transition..

https://github.com/RobertCNelson/stable-kernel/blob/v3.7.x/patches/omap_beagle/0004-zeroMAP-Open-your-eyes.patch

Regards,

-- 
Robert Nelson
http://www.rcn-ee.com/
