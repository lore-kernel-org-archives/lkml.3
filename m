Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422758AbaJ3XVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 19:21:44 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:49469 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161351AbaJ3XVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 19:21:43 -0400
Date: Thu, 30 Oct 2014 23:21:25 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Bastien Nocera <hadess@hadess.net>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
        Andy Lutomirski <luto@amacapital.net>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: A desktop environment[1] kernel wishlist
Message-ID: <20141030232125.78fd1d28@alan.etchedpixels.co.uk>
In-Reply-To: <1414682115.2406.59.camel@hadess.net>
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
	<1414682115.2406.59.camel@hadess.net>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I wouldn't consider this "suspend to RAM", but that's because I expect
> the firmware to implement most of that. Anyway, that's splitting hair.

Quite the reverse in many cases. If your hardware has low power idle you
probably have almost no firmware involved (if any). It's the old world
model of S3 which is all firmware powered.

The extreme case of this is that there are processors out there where
the equivalent of a 'wait for IRQ' instruction is the entire thing.
 
Alan
