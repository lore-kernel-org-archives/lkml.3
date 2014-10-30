Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161582AbaJ3XTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 19:19:20 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:49459 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161351AbaJ3XTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 19:19:19 -0400
Date: Thu, 30 Oct 2014 23:19:04 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Bastien Nocera <hadess@hadess.net>, Pavel Machek <pavel@ucw.cz>,
        Andy Lutomirski <luto@amacapital.net>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: A desktop environment[1] kernel wishlist
Message-ID: <20141030231904.40eb7097@alan.etchedpixels.co.uk>
In-Reply-To: <20141030150501.GD31927@thunk.org>
References: <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
	<1413911644.30379.12.camel@hadess.net>
	<CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
	<1413914978.30379.14.camel@hadess.net>
	<20141027092804.GB9807@amd>
	<1414420292.30379.55.camel@hadess.net>
	<54513DDC.2020700@amacapital.net>
	<20141029202616.GC5000@thunk.org>
	<20141029211608.GA32576@amd>
	<1414680302.2406.55.camel@hadess.net>
	<20141030150501.GD31927@thunk.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It matters because for laptops, what's important is whether the lid is
> closed or not.  Whether and how the laptop was "woken" is really
> beside the point, as others have argued.  Your counter argument is
> that tablets don't have lids.  But tablets are going to be using
> schemes similar to Android, Tizen, and Maemo, and they are *not* going
> to be using the legacy suspend-to-RAM model, because it's not
> sufficiently good at power saving.

There's no longer a tablet/laptop divide in the general case. Many
tablets are convertables and many not convertables are only "non
convertable" in the sense that they are screwed together not fitted with
funky connectors.

There are also a host of reasons (tried making a high speed bus go round
a hinge ?) that this is going to become more common.
