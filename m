Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab3FMN02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:26:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37243 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab3FMN01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:26:27 -0400
Date: Thu, 13 Jun 2013 15:26:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: pali.rohar@gmail.com, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org
Subject: Re: N900 device tree conversion: how to do first step
Message-ID: <20130613132624.GA3464@amd.pavel.ucw.cz>
References: <20130609015944.GA23559@amd.pavel.ucw.cz>
 <20130609201119.GA3190@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130609201119.GA3190@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I'd like to convert Nokia N900 to device tree.
> > 
> > Unfortunately, serial port is not easily available (very special cable
> > would be needed, does someone know where to get one?) and I don't have
> > BDI (and very special cable would be needed, too).
> > 
> > So I tried doing very small first step, hoping that I get booting
> > system... obviously I did not.
> 
> The following works for me, it's enough to boot and get the USB networking
> working. After that I can connect to the device with ssh. I don't use
> serial either, I just have initramfs with busybox+dropbear with hardcoded
> interface setup.

Nice.... thanks a lot.

Did you get video to work with the device tree? That's what I'd like
to accomplish now.

If I init spi manually (and some more hacks), it works in the
qemu. But I have not tested on real hw for a while.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
