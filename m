Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab3GAKGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:06:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44237 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3GAKG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:06:26 -0400
Date: Mon, 1 Jul 2013 12:06:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Adding support for ARINC429 into the Linux kernel
Message-ID: <20130701100624.GB19798@amd.pavel.ucw.cz>
References: <20130619202954.GA5594@roeck-us.net>
 <201306192345.31106.arnd@arndb.de>
 <20130620041001.GA1099@roeck-us.net>
 <201306201052.53898.arnd@arndb.de>
 <20130628215344.GA9437@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628215344.GA9437@roeck-us.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > My vote would be for a new socket family for the low-level protocol,
> > with room for extension later to support the advanced features.
> > 
> > This should be one of the simplest socket implementations possible, if
> > you just need to send and receive 32 bit words, and can bind to a
> > a set of labels for rx as you described above.
> > 
> > The only possible concern I see with that interface is slightly higher
> > latency than what you would be able to get with a straight read/write
> > based character device.
> > 
> Any further feedback on this ?
> 
> Key question: Would a new address family have a chance of being accepted ?

Yes... that seems like cleanest way to implement it.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
