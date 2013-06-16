Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab3FPWZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:25:27 -0400
Received: from etezian.org ([198.101.225.253]:40941 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621Ab3FPWZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:25:25 -0400
Date: Mon, 17 Jun 2013 00:26:48 +0200
From: Andi Shyti <andi@etezian.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andi Shyti <andi@etezian.org>, arnd@arndb.de, rob@landley.net,
        oatilla@gmail.com, szsolt@gmail.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/2] etzkx accelerometer support
Message-ID: <20130616222648.GE4385@jack.whiskey>
References: <cover.1371418586.git.andi@etezian.org>
 <20130616215110.GA10834@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130616215110.GA10834@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > these two patches provide the etzkx device driver which supports
> > the following accelerometers:
> > 
> >  - Kionix kxcnl
> >  - Kionix kxtnk
> >  - ST lisn3dsh
> > 
> > Support for ST lis3dsh accelerometer is still in progress.
> > 
> > The etzkx accelerometers are a kind of devices that are able to
> > do gesture recognition directly on the device. It uses two slots
> > of 16 steps (bytes) each for loading algorithms which perform
> > gesture recognition.
> > 
> > The second patch contains the documentation of the device driver.
> > 
> > On http://www.etezian.org/etzkx/etzkx/ is possible to find more
> > informations about the accelerometer.
> 
> Why isn't this a drivers/iio/accel/ driver instead of a misc driver?
> Please make this an iio driver, then you will be using the correct
> user/kernel api to talk to your device.

I was thinking it may be an issue, but it's not iio because the
time I developed the driver, iio was in the first staging period
and mainly because the on the board I'm using I cannot update the
Kernel to use the latest iio.

I guess you don't like the promise "I can do it later" once the
supplier sends me a development board (which is planned) :)

Andi
