Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab3GFTfz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 15:35:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34155 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab3GFTfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 15:35:51 -0400
Date: Sat, 6 Jul 2013 12:36:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, arnd@arndb.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        andy.shevchenko@gmail.com, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-sunxi@googlegroups.com,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
Message-ID: <20130706193646.GB9778@kroah.com>
References: <20130617225847.GA9494@kroah.com>
 <20130624092942.GG26008@lukather>
 <20130624160440.GA15201@kroah.com>
 <51C87DC7.50005@schinagl.nl>
 <20130624181509.GA8847@kroah.com>
 <51C8B84C.3020200@schinagl.nl>
 <20130624214615.GA17604@kroah.com>
 <51CAA709.4060801@schinagl.nl>
 <20130626175144.GC2222@kroah.com>
 <51D674BF.9030207@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D674BF.9030207@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 09:24:47AM +0200, Oliver Schinagl wrote:
> The other 'broken' drivers that where linked earlier, also use the
> BINARY attributes.
> 
> So Greg, if you could be so kind and give me an example how to
> implement this properly, I am at loss and don't know :(

Ah crap, devices don't have a binary attribute group, like struct class
does.  I'll go add that on Monday and send you the patch to see if that
helps you out.  I'll also go through and fix up all of the binary
attribute drivers to keep them from doing that...

Sorry, I missed that earlier, but thanks for trying and pointing out my
mistake.

greg k-h
