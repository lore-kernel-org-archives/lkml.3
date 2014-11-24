Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbaKXTGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:06:31 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49578 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaKXTGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:06:30 -0500
Date: Mon, 24 Nov 2014 20:06:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: sre@debian.org, sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg
Subject: Re: v3.18-rc1: n900 battery discharged down to 2.97V
Message-ID: <20141124190627.GA7816@amd>
References: <20141124183130.GA2927@amd>
 <201411241958.34578@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201411241958.34578@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-11-24 19:58:34, Pali Rohár wrote:
> On Monday 24 November 2014 19:31:30 Pavel Machek wrote:
> > Hi!
> > 
> > I left the machine on usb-networking for extended period of
> > time. Unfortunately, Xfce screensaver kept screen busy, and
> > kernel failed to kill the machine.
> > 
> > At the end, hardware protections worked (I guess), but result
> > is battery discharged down to 2.97V.
> 
> So you need some program which will monitor battery status and 
> when battery status is empty it should turn of device.

And that program should be part of the kernel, because kernel should
protect hardware from damage. (And it should be perfectly ok to boot
into init=/bin/bash...)

Anyway, this was just friendly warning, so that you don't
unneccessarily damage your battery...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
