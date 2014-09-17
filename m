Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaIQHkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 03:40:41 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:57005 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaIQHkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 03:40:35 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 17 Sep 2014 09:38:25 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, wsa@the-dreams.de,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Johan Hovold <johan@kernel.org>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v4 1/3] mfd: add support for Diolan DLN-2 devices
Message-ID: <20140917073825.GE20727@localhost>
References: <1410290686-6680-1-git-send-email-octavian.purdila@intel.com>
 <1410290686-6680-2-git-send-email-octavian.purdila@intel.com>
 <20140916232149.GB30918@lee--X1>
 <CAE1zotJWUnduPUd9C8EgSHHSo-OCgdj7c-sKaT5M2Ajj2CmNWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE1zotJWUnduPUd9C8EgSHHSo-OCgdj7c-sKaT5M2Ajj2CmNWw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 10:25:18AM +0300, Octavian Purdila wrote:
> On Wed, Sep 17, 2014 at 2:21 AM, Lee Jones <lee.jones@linaro.org> wrote:
> >
> > On Tue, 09 Sep 2014, Octavian Purdila wrote:
> >
> > > This patch implements the USB part of the Diolan USB-I2C/SPI/GPIO
> > > Master Adapter DLN-2. Details about the device can be found here:
> > >
> > > https://www.diolan.com/i2c/i2c_interface.html.
> > >
> > > Information about the USB protocol can be found in the Programmer's
> > > Reference Manual [1], see section 1.7.
> >
> > This driver really needs a USB Ack before I can accept it.
> >
> 
> Greg, Johan, is the driver acceptable now?

I started looking through v4 yesterday and found a few more things. Will
send you some you comments shortly.

Johan
