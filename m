Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934758AbaJ3Peo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:34:44 -0400
Received: from imap.thunk.org ([74.207.234.97]:53385 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932860AbaJ3Pem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:34:42 -0400
Date: Thu, 30 Oct 2014 11:34:35 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Bastien Nocera <hadess@hadess.net>
Cc: Pavel Machek <pavel@ucw.cz>, Andy Lutomirski <luto@amacapital.net>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: A desktop environment[1] kernel wishlist
Message-ID: <20141030153435.GE31927@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Bastien Nocera <hadess@hadess.net>, Pavel Machek <pavel@ucw.cz>,
	Andy Lutomirski <luto@amacapital.net>,
	John Stultz <john.stultz@linaro.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
 <1413914978.30379.14.camel@hadess.net>
 <20141027092804.GB9807@amd>
 <1414420292.30379.55.camel@hadess.net>
 <54513DDC.2020700@amacapital.net>
 <20141029202616.GC5000@thunk.org>
 <20141029211608.GA32576@amd>
 <1414680302.2406.55.camel@hadess.net>
 <20141030150501.GD31927@thunk.org>
 <1414682115.2406.59.camel@hadess.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414682115.2406.59.camel@hadess.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 04:15:15PM +0100, Bastien Nocera wrote:
> 
> There are plenty of tablets around that aren't Android devices. There
> are plenty of laptops that can be switched to a tablet mode for which
> this wouldn't apply either.

These "tablets" will either have enough battery that they will be a
commercial failure because your arm will fall off trying to use it as
a "tablet".  Or it won't have a laptop sized battery, in which case it
will be using a more advanced power management scheme than "suspend to
ram" --- or it will be a commercial failure because no one likes using
a tablet with a miniscule battery life.

Cheers,

						- Ted
