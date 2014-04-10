Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030382AbaDJLri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 07:47:38 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:38716 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030235AbaDJLrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 07:47:36 -0400
Date: Thu, 10 Apr 2014 12:46:53 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: shuah.kh@samsung.com, Greg KH <gregkh@linuxfoundation.org>, tj@kernel.org,
        rafael.j.wysocki@intel.com, linux@roeck-us.net, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        shuahkhan@gmail.com
Subject: Re: [RFC PATCH 0/2] managed token devres interfaces
Message-ID: <20140410124653.64aeb06d@alan.etchedpixels.co.uk>
In-Reply-To: <20140410083841.488f9c43@samsung.com>
References: <cover.1397050852.git.shuah.kh@samsung.com>
	<20140409191740.GA10748@kroah.com>
	<5345CD32.8010305@samsung.com>
	<20140410120435.4c439a8b@alan.etchedpixels.co.uk>
	<20140410083841.488f9c43@samsung.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For example, some devices provide standard USB Audio Class, handled by
> snd-usb-audio for the audio stream, while the video stream is handled
> via a separate driver, like some em28xx devices.

Which is what mfd is designed to handle.

> There are even more complex devices that provide 3G modem, storage
> and digital TV, whose USB ID changes when either the 3G modem starts
> or when the digital TV firmware is loaded.

But presumably you only have one driver at a time then ?

> So, we need to find a way to lock some hardware resources among
> different subsystems that don't share anything in common. Not sure if
> mfd has the same type of problem of a non-mfd driver using another
> function of the same device

The MFD device provides subdevices for all the functions. That is the
whole underlying concept.

