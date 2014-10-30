Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422780AbaJ3XZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 19:25:42 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:49475 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422660AbaJ3XZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 19:25:40 -0400
Date: Thu, 30 Oct 2014 23:25:26 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Bastien Nocera <hadess@hadess.net>
Cc: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: A desktop environment[1] kernel wishlist
Message-ID: <20141030232526.46cd545f@alan.etchedpixels.co.uk>
In-Reply-To: <1414679738.2406.49.camel@hadess.net>
References: <1413881397.30379.7.camel@hadess.net>
	<CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
	<1413911644.30379.12.camel@hadess.net>
	<CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
	<1413914978.30379.14.camel@hadess.net>
	<CALAqxLX2Q-2RBF1zY6JAWrqNiqBFG3vxUwUSLVS3qXpgSOb9xA@mail.gmail.com>
	<1414419579.30379.49.camel@hadess.net>
	<CALAqxLXyaL55JuDuHAcWX0PEdem-jpVxK0rbJaNrBbBJ3rQY5Q@mail.gmail.com>
	<1414679738.2406.49.camel@hadess.net>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> The kernel receives an interrupt, likely on a different device. Again,
> I'm talking about "legacy" devices, for which suspend is actually a
> state. If the device is only in low-power mode, you'd probably get the
> event on the input device, which is accessible from user-space.

I don't believe so - the firmware ate it.

> Knowing why the Wi-Fi card woke up is also important when there isn't a
> full "suspend" state. As was mentioned, it's useful for power debugging,
> but it's also useful because that tells things outside the network card
> driver what happened.

Wifi devices that are smart generally have a fair bit of info they
provide themselves on this. In particular if you are using a deep idle
type behaviour they may well wake every minute or so just to poke a
packet out to keep any NAT mapping alive.

> As I mentioned in more recent emails on this thread, maybe we don't want
> to know what woke the system up, but knowing that a wake-up event
> occurred on this device, at this time, would allow us to make the
> software act accordingly. The fact that we don't know that means that we
> cannot take appropriate action.

What woke the system up may also not be a singular item. Suppose the
alarm goes off as the user opens the lid and the wireless gets a wakeup
packet in the same window ?

Alan
