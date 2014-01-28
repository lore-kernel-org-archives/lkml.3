Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbaA1OO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 09:14:56 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34575 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbaA1OOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 09:14:54 -0500
Date: Tue, 28 Jan 2014 15:14:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 01/11] resolve PXA<->8250 serial device address conflict
Message-ID: <20140128141437.GB8713@xo-6d-61-c0.localdomain>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
 <1385879185-22455-2-git-send-email-ynvich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385879185-22455-2-git-send-email-ynvich@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> PXA serial ports have "standard" UART names (ttyS[0-3]), major
> device number (4) and first minor device number (64) by default.
> 
> If the system has extra 8250 serial port hardware in addition
> to onboard PXA serial ports, default settings produce a device
> allocation conflict.
> 
> The patch provides a configuration option which can move onboard
> ports out of the way of 8250_core by assigning a different (204)
> major number and corresponding device names (ttySA[0-3]).

Yes, please. I was hitting the same issue with Sharp Zaurus and bluetooth
CF card... Bluetooth card had 8250 inside...


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
