Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaCJLuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 07:50:32 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:47235 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbaCJLu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 07:50:29 -0400
Date: Mon, 10 Mar 2014 07:50:12 -0400 (EDT)
From: Jon Ringle <jon@ringle.org>
X-X-Sender: jringle@jringle-ubuntu
To: Alexander Shiyan <shc_work@mail.ru>
cc: jon@ringle.org, gregkh@linuxfoundation.org, jslaby@suse.cz,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jon Ringle <jringle@gridpoint.com>
Subject: Re: [PATCH] RFC: WIP: sc16is7xx [v0.4]
In-Reply-To: <1394434945.519725450@f256.i.mail.ru>
Message-ID: <alpine.DEB.2.02.1403100744230.23103@jringle-ubuntu>
References: <1394432777-13005-1-git-send-email-jon@ringle.org> <1394434945.519725450@f256.i.mail.ru>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1889733774-1394452227=:23103"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1889733774-1394452227=:23103
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT


On Mon, 10 Mar 2014, Alexander Shiyan wrote:

> Понедельник, 10 марта 2014, 2:26 -04:00 от jon@ringle.org:
> > From: Jon Ringle <jringle@gridpoint.com>
> ...
> > +config SERIAL_SC16IS7XX
> > +	tristate "SC16IS7xx RS485 serial support"
> > +	  select SERIAL_CORE
> > +	  default n
> > +	  help
> > +	  This selects support for SC16IS7xx for use as a RS485 serial port
> 
> Documentation says:
> The SC16IS740/750/760 is a slave I²C-bus/SPI interface to a single-channel
> high performance UART.
> ...
> The SC16IS740/750/760 also provides additional advanced features such
> as auto hardware and software flow control, automatic RS-485 support...
> 
> So why do you position this chip as RS485 only? Automatic direction for
> RS485 is just a feature as an addition for standart UART.

You're right. This is just how we are using the chip in our board. Would a 
configuration flag in platform_data make sense to use the auto rs485 
direction?

Any thoughts as to the latency issue I report?

Thanks.

Regards,
Jon
--8323329-1889733774-1394452227=:23103--
