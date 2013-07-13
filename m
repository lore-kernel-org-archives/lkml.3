Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab3GMXQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 19:16:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3GMXQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 19:16:55 -0400
Date: Sat, 13 Jul 2013 16:17:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] misc: add driver for Renesas R-Car Gyro-ADC/speed-pulse
 interfaces
Message-ID: <20130713231752.GA8408@kroah.com>
References: <201307130351.42967.sergei.shtylyov@cogentembedded.com>
 <20130713005702.GA14788@kroah.com>
 <51E0AA24.6070203@cogentembedded.com>
 <201307130958.16533.arnd@arndb.de>
 <51E1D406.9090702@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E1D406.9090702@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 14, 2013 at 02:26:14AM +0400, Sergei Shtylyov wrote:
>    The other trouble is that I'll have to backport this driver to
> 3.4 which doesn't contain the IIO infrastructure at all. :-(

That doesn't matter to us, we can't accept a driver that should be using
the iio subsystem, but isn't.  So please port it to use that.

thanks,

greg k-h
