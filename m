Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab3L0SOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 13:14:12 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55914 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab3L0SOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 13:14:10 -0500
Date: Fri, 27 Dec 2013 18:13:49 +0000
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
Message-ID: <20131227181349.475abe88@alan.etchedpixels.co.uk>
In-Reply-To: <20131227152354.GA24152@amd.pavel.ucw.cz>
References: <1387895407-28031-1-git-send-email-lgxue@hotmail.com>
	<20131225230935.GB13593@amd.pavel.ucw.cz>
	<BLU172-W52032BFEF4512123D7516EACC20@phx.gbl>
	<20131227115746.4cbd9523@alan.etchedpixels.co.uk>
	<20131227125725.GA21506@amd.pavel.ucw.cz>
	<20131227141826.3fe406e4@alan.etchedpixels.co.uk>
	<20131227152354.GA24152@amd.pavel.ucw.cz>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, this one will be really smaller. And yes, it will make some
> memory non-swappable, but I believe with triggers and infrastructure
> for N900 (and similar) it will be worth it.

Ah yes thats such a major proportion of platforms

> Plus, it will actually save CPU cycles, and thus significant power.

All of which will be totally wiped out if you bump all the millions of
x86 server boxes in the world up by one page of kernel space and cause a
few disk I/Os

> > little driver but the rest belongs in a library and the library can use
> > accelerators (of any kind) if available, or even things like lightbulbs
> > via X10 so you can have the big red light in the control room flash if
> > the machine dies  8)
> 
> Well, I'd prefer my cellphone to signal me "you have a message" by
> flashing blue light, not by dimming lights in the control room ;-).

Where the cellphone has an offload it makes sense to use it, but in the
general case userspace is much more flexible. You may not want a flashing
big red light and a siren but if its in kernel then nobody can have it,
if it's through a library you can.

Alan
