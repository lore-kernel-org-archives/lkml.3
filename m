Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbaFWQiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:38:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656AbaFWQiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:38:12 -0400
Date: Mon, 23 Jun 2014 12:38:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Scott Alfter <scott@alfter.us>
Cc: Arnd Bergmann <arnd@arndb.de>, Evgeniy Polyakov <zbr@ioremap.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: select crc16 library for ds2406
Message-ID: <20140623163800.GA21280@kroah.com>
References: <12173493.Olv1pKMOGK@wuerfel>
 <89597b8dd96b8e07df45b2b4a7fb0d9b.squirrel@webmail.alfter.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89597b8dd96b8e07df45b2b4a7fb0d9b.squirrel@webmail.alfter.us>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 04:19:58PM -0000, Scott Alfter wrote:
> On Mon, June 23, 2014 14:31, Arnd Bergmann wrote:
> > commit 94859308a21b "w1: new w1_ds2406 driver" added a new driver
> > that uses the crc16 library, but didn't ensure that the core is
> > there. This adds the necessary Kconfig statements, just like we
> > have it for other w1 drivers.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Scott Alfter <scott@alfter.us>
> > Cc: Evgeniy Polyakov <zbr@ioremap.net>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Sounds OK to me...was an oversight on my part. Do I need to put together
> another patchfile, or can this one be combined with the one I've already
> sent in? As an alternative, it's in my kernel tree at
> https://github.com/salfter/adafruit-raspberrypi-linux.

I'll take it as-is, I can't do anything with some random github tree :)

thanks,

greg k-h
