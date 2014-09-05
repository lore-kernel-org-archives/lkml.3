Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbaIEBal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 21:30:41 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:56013 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaIEBaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 21:30:39 -0400
Date: Fri, 5 Sep 2014 09:30:11 +0800
From: Wang YanQing <udknight@gmail.com>
To: Benjamin Henrion <zoobab@gmail.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, jhovold@gmail.com,
        andi@lisas.de, dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8] usb:serial:pl2303: add GPIOs interface on PL2303
Message-ID: <20140905013011.GA2133@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Benjamin Henrion <zoobab@gmail.com>, gregkh@linuxfoundation.org,
	linus.walleij@linaro.org, jhovold@gmail.com, andi@lisas.de,
	dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20140831153201.GA25632@udknight>
 <CANjd3neT+NrsptLw3s7Bm76xv6LQMqm-BieN-0xLFuTx4apXxw@mail.gmail.com>
 <CANjd3ndGiTujCORwZOXfWfHL2_YocK5ZUpxQJPLq+qTmkV0xnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANjd3ndGiTujCORwZOXfWfHL2_YocK5ZUpxQJPLq+qTmkV0xnA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 06:44:31PM +0200, Benjamin Henrion wrote:
> On Thu, Sep 4, 2014 at 6:14 PM, Benjamin Henrion <zoobab@gmail.com> wrote:
> > I have subscribed to the lkml.
> >
> > Can you make me a favour, send me your email as you posted on the LKML
> > in mbox format attached to an email?
> >
> > I am trying to reply to it, but I cannot find an mbox archive, outside
> > of gmane which rewrites all the email addresses.
> >
> > Otherwise, I made a page here:
> >
> > http://www.zoobab.com/pl2303hxd-gpio
> >
> > I will also try with other adapters to see if the 2 GPIOs show up.
> >
> > Any idea how to test the GPIO sysfs speed?
> 
> Also tested with an HXA laying around, I could export the 2 GPIOS in
> /sys/class/gpio, but I could not change the status of the pins via
> echo.
> 
> Any idea why?

It is strange, I have tested again with my two HXA adapters, they work well.
How do you test? check cat value or check voltage change? I check cat value,
and they work good.


> 
> -- 
> Benjamin Henrion <bhenrion at ffii.org>
> FFII Brussels - +32-484-566109 - +32-2-4148403
> "In July 2005, after several failed attempts to legalise software
> patents in Europe, the patent establishment changed its strategy.
> Instead of explicitly seeking to sanction the patentability of
> software, they are now seeking to create a central European patent
> court, which would establish and enforce patentability rules in their
> favor, without any possibility of correction by competing courts or
> democratically elected legislators."
