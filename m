Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966798Ab3HHWZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 18:25:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965419Ab3HHWZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 18:25:25 -0400
Date: Thu, 8 Aug 2013 15:25:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andi Shyti <andi@etezian.org>
Cc: oatilla@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] etzkx accelerometer support
Message-ID: <20130808222524.GB30060@kroah.com>
References: <cover.1371418586.git.andi@etezian.org>
 <20130616215110.GA10834@kroah.com>
 <20130616222648.GE4385@jack.whiskey>
 <20130617025854.GB12522@kroah.com>
 <20130808222108.GC11387@jack.whiskey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130808222108.GC11387@jack.whiskey>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 12:21:08AM +0200, Andi Shyti wrote:
> Hi Greg,
> 
> > > > > these two patches provide the etzkx device driver which supports
> > > > > the following accelerometers:
> > > > 
> > > > Why isn't this a drivers/iio/accel/ driver instead of a misc driver?
> > > > Please make this an iio driver, then you will be using the correct
> > > > user/kernel api to talk to your device.
> > > 
> > > I was thinking it may be an issue, but it's not iio because the
> > > time I developed the driver, iio was in the first staging period
> > > and mainly because the on the board I'm using I cannot update the
> > > Kernel to use the latest iio.
> > > 
> > > I guess you don't like the promise "I can do it later" once the
> > > supplier sends me a development board (which is planned) :)
> > 
> > Sure, I'll gladly accept "I can do it later" from anyone, as long as you
> > don't mind my, "I will merge it later" as well :)
> > 
> > Sorry, I can't accept a driver now, that is known to going to be
> > changing the kernel/user api in the future.  So please, rewrite it to
> > use IIO, that's what that interface / subsystem is there for.
> 
> What about submitting this accelerometer driver under staging
> even if it's still not iio and slowly put it in shape?

There are a number of staging iio drivers already, why not put it there?

I don't want to accept a driver with a user/kernel interface that we
know is wrong, into staging.  What is wrong with taking a few days to
fix this up now?  If you aren't willing to do it now, why would I
believe that you will be willing to do it in the future once it is in
staging?  :)

thanks,

greg k-h
