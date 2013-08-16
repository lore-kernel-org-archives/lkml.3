Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab3HTPvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:51:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41201 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751329Ab3HTPvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:51:49 -0400
Date: Fri, 16 Aug 2013 16:39:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Brown <broonie@kernel.org>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Non-enumerable devices on USB and other enumerable buses
In-Reply-To: <20130816200009.GU30073@sirena.org.uk>
Message-ID: <Pine.LNX.4.44L0.1308161625520.1532-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Aug 2013, Mark Brown wrote:

> On Fri, Aug 16, 2013 at 03:27:58PM -0400, Alan Stern wrote:
> > On Fri, 16 Aug 2013, Mark Brown wrote:
> 
> > >  or those for getting platform data to a device when it
> > > does enumerate.
> 
> > ?  I can't make any sense out of that comment.  For one thing, why do
> > you need to send platform data to a device?  (It's obvious that a
> > _driver_ would need to use platform data; it's not so clear that a
> > _device_ would.)
> 
> The device in this context is a running instance of the driver.

It's kind of difficult to understand what you're saying.  Obviously the
literal meaning is not what you had in mind, because a device can't be
a driver (or even a running instance of a driver).  Maybe you meant
that the word "device" above should have been the word "driver".

So you seem to be saying that significant modifications would be needed 
to get platform information to the driver.  I don't see why.  Lots and 
lots of drivers use platform information right now.

Besides, you need to get the platform information to the driver in any 
case, no matter how you decide to solve the chicken-and-egg problem.  
It shouldn't be a factor in deciding which solution to use.

Alan Stern

