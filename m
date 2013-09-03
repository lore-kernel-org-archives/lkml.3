Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760143Ab3ICOMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:12:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3ICOMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:12:20 -0400
Date: Tue, 3 Sep 2013 07:14:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: oliver+list@schinagl.nl
Cc: arnd@arndb.de, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        tomasz.figa@gmail.com, maxime.ripard@free-electrons.com,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCHv7 0/2] ARM: sunxi: Driver for Allwinner sunxi Security ID
Message-ID: <20130903141456.GA28888@kroah.com>
References: <1378204408-1415-1-git-send-email-oliver+list@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378204408-1415-1-git-send-email-oliver+list@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 12:33:26PM +0200, oliver+list@schinagl.nl wrote:
> From: Oliver Schinagl <oliver+list@schinagl.nl>
> 
> I don't know if I know how to polish it anymore without rubbing off the varnish.

Heh, looks good :)

I'll queue it up once 3.12-rc1 is released.  As it's a new driver, it
should be ok to add to 3.12.

thanks,

greg k-h
