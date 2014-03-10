Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbaCJOUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:20:53 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58338 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbaCJOUu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:20:50 -0400
Date: Mon, 10 Mar 2014 14:20:32 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Jon Ringle <jon@ringle.org>
Cc: Alexander Shiyan <shc_work@mail.ru>, gregkh@linuxfoundation.org,
        jslaby@suse.cz, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Jon Ringle <jringle@gridpoint.com>
Subject: Re: [PATCH] RFC: WIP: sc16is7xx [v0.4]
Message-ID: <20140310142032.47e680b5@alan.etchedpixels.co.uk>
In-Reply-To: <alpine.DEB.2.02.1403100744230.23103@jringle-ubuntu>
References: <1394432777-13005-1-git-send-email-jon@ringle.org>
	<1394434945.519725450@f256.i.mail.ru>
	<alpine.DEB.2.02.1403100744230.23103@jringle-ubuntu>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014 07:50:12 -0400 (EDT)
Jon Ringle <jon@ringle.org> wrote:

> 
> On Mon, 10 Mar 2014, Alexander Shiyan wrote:
> 
> > Понедельник, 10 марта 2014, 2:26 -04:00 от jon@ringle.org:
> > > From: Jon Ringle <jringle@gridpoint.com>
> > ...
> > > +config SERIAL_SC16IS7XX
> > > +	tristate "SC16IS7xx RS485 serial support"
> > > +	  select SERIAL_CORE
> > > +	  default n
> > > +	  help
> > > +	  This selects support for SC16IS7xx for use as a RS485 serial port
> > 
> > Documentation says:
> > The SC16IS740/750/760 is a slave I²C-bus/SPI interface to a single-channel
> > high performance UART.
> > ...
> > The SC16IS740/750/760 also provides additional advanced features such
> > as auto hardware and software flow control, automatic RS-485 support...
> > 
> > So why do you position this chip as RS485 only? Automatic direction for
> > RS485 is just a feature as an addition for standart UART.
> 
> You're right. This is just how we are using the chip in our board. Would a 
> configuration flag in platform_data make sense to use the auto rs485 
> direction?

We have interfaces for RS485 runtime configuration so it could be
extended to set a lot of parameters that way, but I think for now it
might not be a bad idea to support rs485 auto direction in/out/off in the
platform data.

Alan
