Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbaEEN5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:57:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37837 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932395AbaEEN5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:57:04 -0400
Date: Mon, 5 May 2014 15:57:02 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mark Brown <broonie@kernel.org>, linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] spi: Force the registration of the spidev devices
Message-ID: <20140505135701.GA21940@piout.net>
References: <1398705774-12361-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140429183758.GH15125@sirena.org.uk>
 <20140430180609.GC3000@lukather>
 <20140501011811.GF3245@sirena.org.uk>
 <20140501223629.GJ3000@lukather>
 <CAMuHMdUWa1_n94sDvv=L_goc+SOnD9CAKi5DzifrY7GWYRdQmw@mail.gmail.com>
 <20140505041721.GD11606@lukather>
 <CAMuHMdWZ1rvC+tkT=CbfMwZtppyJ_KpzT7JrLd5k5P2oxzA+8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWZ1rvC+tkT=CbfMwZtppyJ_KpzT7JrLd5k5P2oxzA+8g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 at 09:10:43 +0200, Geert Uytterhoeven wrote :
> Hi Maxime,
> 
> On Mon, May 5, 2014 at 6:17 AM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > On Fri, May 02, 2014 at 01:28:26AM +0200, Geert Uytterhoeven wrote:
> >> On Fri, May 2, 2014 at 12:36 AM, Maxime Ripard
> >> <maxime.ripard@free-electrons.com> wrote:
> >> > But it actually doesn't work in a case where you can't really predict
> >> > what is on the other side of the bus. Either because, on the board
> >> > you're using the pins are exposed and it's pretty much up to the user
> >> > to know what to put on it. That could be handled by DT overlays
> >> > though.
> >> >
> >> > What never works is where the device on the other side is so generic
> >> > that you really can't tell what it does. Think of a microcontroller
> >> > that would behave as a SPI slave. It's behaviour and what it does is
> >> > pretty much dependant of what we flashed on it, and suddenly the
> >> > compatible string is not the proper reprensentation anymore.
> >>
> >> So you will (hopefully soon) use overlay DT to change the DTS to match what's
> >> connected?
> >
> > Not really, because you can't declare a spidev device in the DT.
> 
> Yes you can. I've done it before.
> 
> See also "git grep -w spidev -- arch/arm/*/dts/".
> 

I'm pretty sure that doesn't work as there is no compatible matching
"spidev"

My guess would be that you added it in spidev.c

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
