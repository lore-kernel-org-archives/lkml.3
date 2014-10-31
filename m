Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184AbaJaOCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 10:02:14 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:59813 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933113AbaJaOCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 10:02:11 -0400
X-Originating-IP: 83.155.44.161
Message-ID: <1414764089.2406.74.camel@hadess.net>
Subject: Re: A desktop environment[1] kernel wishlist
From: Bastien Nocera <hadess@hadess.net>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 31 Oct 2014 15:01:29 +0100
In-Reply-To: <20141030232526.46cd545f@alan.etchedpixels.co.uk>
References: <1413881397.30379.7.camel@hadess.net>
	 <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
	 <1413911644.30379.12.camel@hadess.net>
	 <CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
	 <1413914978.30379.14.camel@hadess.net>
	 <CALAqxLX2Q-2RBF1zY6JAWrqNiqBFG3vxUwUSLVS3qXpgSOb9xA@mail.gmail.com>
	 <1414419579.30379.49.camel@hadess.net>
	 <CALAqxLXyaL55JuDuHAcWX0PEdem-jpVxK0rbJaNrBbBJ3rQY5Q@mail.gmail.com>
	 <1414679738.2406.49.camel@hadess.net>
	 <20141030232526.46cd545f@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 (3.12.7-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-30 at 23:25 +0000, One Thousand Gnomes wrote:
> O> The kernel receives an interrupt, likely on a different device. Again,
> > I'm talking about "legacy" devices, for which suspend is actually a
> > state. If the device is only in low-power mode, you'd probably get the
> > event on the input device, which is accessible from user-space.
> 
> I don't believe so - the firmware ate it.
> 
> > Knowing why the Wi-Fi card woke up is also important when there isn't a
> > full "suspend" state. As was mentioned, it's useful for power debugging,
> > but it's also useful because that tells things outside the network card
> > driver what happened.
> 
> Wifi devices that are smart generally have a fair bit of info they
> provide themselves on this. In particular if you are using a deep idle
> type behaviour they may well wake every minute or so just to poke a
> packet out to keep any NAT mapping alive.
> 
> > As I mentioned in more recent emails on this thread, maybe we don't want
> > to know what woke the system up, but knowing that a wake-up event
> > occurred on this device, at this time, would allow us to make the
> > software act accordingly. The fact that we don't know that means that we
> > cannot take appropriate action.
> 
> What woke the system up may also not be a singular item. Suppose the
> alarm goes off as the user opens the lid and the wireless gets a wakeup
> packet in the same window ?

Then each one of those devices would have their own wakeup reason set,
with a timestamp.

