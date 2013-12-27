Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab3L0OSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 09:18:49 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55498 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab3L0OSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 09:18:47 -0500
Date: Fri, 27 Dec 2013 14:18:26 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Joe Xue <lgxue@hotmail.com>, "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] Add the LED burst trigger
Message-ID: <20131227141826.3fe406e4@alan.etchedpixels.co.uk>
In-Reply-To: <20131227125725.GA21506@amd.pavel.ucw.cz>
References: <1387895407-28031-1-git-send-email-lgxue@hotmail.com>
	<20131225230935.GB13593@amd.pavel.ucw.cz>
	<BLU172-W52032BFEF4512123D7516EACC20@phx.gbl>
	<20131227115746.4cbd9523@alan.etchedpixels.co.uk>
	<20131227125725.GA21506@amd.pavel.ucw.cz>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> At least nokia N900 actually has "hardware acceleration" for LED
> blinking. (Tiny CPU connected over i2c, able to control 3 LEDs, turing
> complete with something like 20 _bits_ of storage and 30 program
> steps). Apparently, it makes more stable patterns (timing is very hard
> to guarantee from userspace) and better power consumption (no need to
> wake the CPU to blink the LEDs).
> 
> Now, wins from going userspace->kernel will not be too huge. But "If
> the hardware can accelerate it, kernel should offer it even on
> hardware that can not do it, for consistency".

Why ? My x86-64 box can run with 8GB processes, perhaps we should emulate
64bit on a 32bit kernel for consistency ?

It's another waste of resources - pages of memory that would cumulatively
be vastly more efficiently used by user space. Yes the N800 might want a
little driver but the rest belongs in a library and the library can use
accelerators (of any kind) if available, or even things like lightbulbs
via X10 so you can have the big red light in the control room flash if
the machine dies  8)

Alan
