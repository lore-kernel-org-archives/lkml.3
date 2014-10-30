Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544AbaJ3PFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:05:24 -0400
Received: from imap.thunk.org ([74.207.234.97]:53289 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760181AbaJ3PFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:05:08 -0400
Date: Thu, 30 Oct 2014 11:05:01 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Bastien Nocera <hadess@hadess.net>
Cc: Pavel Machek <pavel@ucw.cz>, Andy Lutomirski <luto@amacapital.net>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: A desktop environment[1] kernel wishlist
Message-ID: <20141030150501.GD31927@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Bastien Nocera <hadess@hadess.net>, Pavel Machek <pavel@ucw.cz>,
	Andy Lutomirski <luto@amacapital.net>,
	John Stultz <john.stultz@linaro.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414680302.2406.55.camel@hadess.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 03:45:02PM +0100, Bastien Nocera wrote:
> > Actually Maemo people (on Nokia N900 and friends) got it right: unlike
> > android devices, it does not suspend to RAM at any point, and still
> > has reasonable battery life.
> 
> Android devices don't suspend to RAM. Neither do Tizen devices AFAIK.

Actually, Android devices have historically always suspended the CPU
whenever there wasn't a wakelock keeping the device to suspend.  You
might not consider this "suspend to RAM" but in fact it uses the
identical kernel and hardware facilities as the legacy "suspend to
RAM" mechanism.

> I don't think anyone was discussing cell phones in particular in this
> thread, and knowing when user-space got woken up because of the baseband
> processor having information for us would still be useful.

It matters because for laptops, what's important is whether the lid is
closed or not.  Whether and how the laptop was "woken" is really
beside the point, as others have argued.  Your counter argument is
that tablets don't have lids.  But tablets are going to be using
schemes similar to Android, Tizen, and Maemo, and they are *not* going
to be using the legacy suspend-to-RAM model, because it's not
sufficiently good at power saving.

Cheers,

						- Ted
