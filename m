Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbaIIKp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:45:59 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:55226 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493AbaIIKp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:45:57 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 9 Sep 2014 12:43:56 +0200
From: Johan Hovold <johan@kernel.org>
To: Wang YanQing <udknight@gmail.com>
Cc: Johan Hovold <johan@kernel.org>, Benjamin Henrion <zoobab@gmail.com>,
        gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        jhovold@gmail.com, andi@lisas.de, dforsi@gmail.com,
        gnomes@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8] usb:serial:pl2303: add GPIOs interface on PL2303
Message-ID: <20140909104356.GA7939@localhost>
References: <20140831153201.GA25632@udknight>
 <CANjd3neT+NrsptLw3s7Bm76xv6LQMqm-BieN-0xLFuTx4apXxw@mail.gmail.com>
 <CANjd3ndGiTujCORwZOXfWfHL2_YocK5ZUpxQJPLq+qTmkV0xnA@mail.gmail.com>
 <20140905013011.GA2133@udknight>
 <20140909100856.GC2974@localhost>
 <20140909102131.GA1354@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909102131.GA1354@udknight>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 06:21:31PM +0800, Wang YanQing wrote:
> On Tue, Sep 09, 2014 at 12:08:56PM +0200, Johan Hovold wrote:
> > On Fri, Sep 05, 2014 at 09:30:11AM +0800, Wang YanQing wrote:
> > > On Thu, Sep 04, 2014 at 06:44:31PM +0200, Benjamin Henrion wrote:
> > > > On Thu, Sep 4, 2014 at 6:14 PM, Benjamin Henrion <zoobab@gmail.com> wrote:
> > > > > I have subscribed to the lkml.
> > > > >
> > > > > Can you make me a favour, send me your email as you posted on the LKML
> > > > > in mbox format attached to an email?
> > > > >
> > > > > I am trying to reply to it, but I cannot find an mbox archive, outside
> > > > > of gmane which rewrites all the email addresses.
> > > > >
> > > > > Otherwise, I made a page here:
> > > > >
> > > > > http://www.zoobab.com/pl2303hxd-gpio
> > > > >
> > > > > I will also try with other adapters to see if the 2 GPIOs show up.
> > > > >
> > > > > Any idea how to test the GPIO sysfs speed?
> > > > 
> > > > Also tested with an HXA laying around, I could export the 2 GPIOS in
> > > > /sys/class/gpio, but I could not change the status of the pins via
> > > > echo.
> > > > 
> > > > Any idea why?
> > > 
> > > It is strange, I have tested again with my two HXA adapters, they work well.
> > > How do you test? check cat value or check voltage change? I check cat value,
> > > and they work good.
> > 
> > So you haven't verified that the voltage actually changes?
> > 
> > Johan
> 
> I have verified the voltage actually changes in previous patch version,
> but I haven't verified that with v8.

Ok, good. I'll get back to you with some comments on v8 shortly.

Thanks,
Johan
