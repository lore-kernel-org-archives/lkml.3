Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab3FQI01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:26:27 -0400
Received: from etezian.org ([198.101.225.253]:42741 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309Ab3FQI00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:26:26 -0400
Date: Mon, 17 Jun 2013 10:27:48 +0200
From: Andi Shyti <andi@etezian.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andi Shyti <andi@etezian.org>, arnd@arndb.de, rob@landley.net,
        oatilla@gmail.com, szsolt@gmail.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/2] etzkx accelerometer support
Message-ID: <20130617082748.GA8306@jack.whiskey>
References: <cover.1371418586.git.andi@etezian.org>
 <20130616215110.GA10834@kroah.com>
 <20130616222648.GE4385@jack.whiskey>
 <20130617025854.GB12522@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617025854.GB12522@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > these two patches provide the etzkx device driver which supports
> > > > the following accelerometers:
> > > > 
> > > >  - Kionix kxcnl
> > > >  - Kionix kxtnk
> > > >  - ST lisn3dsh
> > > > 
> > > > Support for ST lis3dsh accelerometer is still in progress.
> > > > 
> > > > The etzkx accelerometers are a kind of devices that are able to
> > > > do gesture recognition directly on the device. It uses two slots
> > > > of 16 steps (bytes) each for loading algorithms which perform
> > > > gesture recognition.
> > > > 
> > > > The second patch contains the documentation of the device driver.
> > > > 
> > > > On http://www.etezian.org/etzkx/etzkx/ is possible to find more
> > > > informations about the accelerometer.
> > > 
> > > Why isn't this a drivers/iio/accel/ driver instead of a misc driver?
> > > Please make this an iio driver, then you will be using the correct
> > > user/kernel api to talk to your device.
> > 
> > I was thinking it may be an issue, but it's not iio because the
> > time I developed the driver, iio was in the first staging period
> > and mainly because the on the board I'm using I cannot update the
> > Kernel to use the latest iio.
> > 
> > I guess you don't like the promise "I can do it later" once the
> > supplier sends me a development board (which is planned) :)
> 
> Sure, I'll gladly accept "I can do it later" from anyone, as long as you
> don't mind my, "I will merge it later" as well :)
> 
> Sorry, I can't accept a driver now, that is known to going to be
> changing the kernel/user api in the future.  So please, rewrite it to
> use IIO, that's what that interface / subsystem is there for.

Fair enough! Let's accept the "I'll do it later" from each other :)

Then... see you later and thanks,
Andi
