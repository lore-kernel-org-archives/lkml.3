Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030306AbaDJLFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 07:05:15 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:38647 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030208AbaDJLFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 07:05:13 -0400
Date: Thu, 10 Apr 2014 12:04:35 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: shuah.kh@samsung.com
Cc: Greg KH <gregkh@linuxfoundation.org>, m.chehab@samsung.com, tj@kernel.org,
        rafael.j.wysocki@intel.com, linux@roeck-us.net, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        shuahkhan@gmail.com
Subject: Re: [RFC PATCH 0/2] managed token devres interfaces
Message-ID: <20140410120435.4c439a8b@alan.etchedpixels.co.uk>
In-Reply-To: <5345CD32.8010305@samsung.com>
References: <cover.1397050852.git.shuah.kh@samsung.com>
	<20140409191740.GA10748@kroah.com>
	<5345CD32.8010305@samsung.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>   - Construct string with (dev is struct em28xx *dev)
> >> 		format: "tuner:%s-%s-%d"
> >> 		with the following:
> >>     	            dev_name(&dev->udev->dev)
> >>                  dev->udev->bus->bus_name
> >>                  dev->tuner_addr

What guarantees this won't get confused by hot plugging and re-use of the
bus slot ?


I'm also not sure I understand why you can't have a shared parent device
and simply attach the resources to that. This sounds like a problem mfd
already solved ?

Alan
