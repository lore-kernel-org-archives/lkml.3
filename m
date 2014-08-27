Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965491AbaH0XnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:43:11 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:56774 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964814AbaH0XnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:43:09 -0400
Date: Thu, 28 Aug 2014 07:43:01 +0800
From: Wang YanQing <udknight@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, gregkh@linuxfoundation.org,
        jhovold@gmail.com, andi@lisas.de, dforsi@gmail.com,
        gnomes@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7] usb:serial:pl2303: add GPIOs interface on PL2303
Message-ID: <20140827234301.GB418@localhost.localdomain>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	gregkh@linuxfoundation.org, jhovold@gmail.com, andi@lisas.de,
	dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20140809052828.GA28307@udknight>
 <20140812144625.GB9799@localhost>
 <20140817020536.GA2509@localhost.localdomain>
 <20140818100720.GF31755@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140818100720.GF31755@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 12:07:20PM +0200, Johan Hovold wrote:
> On Sun, Aug 17, 2014 at 10:05:36AM +0800, Wang YanQing wrote:
> > Hi Johan Hovold.
> > 
> > Another two questions.
> > 	
> > On Tue, Aug 12, 2014 at 04:46:25PM +0200, Johan Hovold wrote:
> > > 
> > > > +	int (*gpio_startup)(struct usb_serial *serial);
> > > > +	void (*gpio_release)(struct usb_serial *serial);
> > > 
> > > This isn't the right place for this abstraction. Most of the setup code
> > > would be common for any device type with GPIOs.
> > 
> > I assume you mean any pl2303 variant, not any device type, because
> > no device in drivers/gpio has common setup code except many of them
> > use struct gpio_chip.
> 
> Yes, pl2303 type/variant. Specifically, much of the setup code will be
> identical even if say the number of gpio differ (2 or 4) depending on
> type.

Yes, indeed unless I know how to make kernel could distinguish those two
types, this patch willn't be fit for mergence.

And I don't have free time recent, I need more time to prepare this patch, or could you
figure out how to distinguish them?

Thanks.
