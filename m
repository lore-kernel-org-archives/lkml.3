Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563Ab3FCRHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 13:07:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758786Ab3FCRHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 13:07:31 -0400
Date: Mon, 3 Jun 2013 10:07:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sourav Poddar <sourav.poddar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] serial: omap: repair building without PM_SLEEP
Message-ID: <20130603170730.GA30767@kroah.com>
References: <1844339.mxci2DdvBF@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1844339.mxci2DdvBF@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 01, 2013 at 11:18:13AM +0200, Arnd Bergmann wrote:
> A recent bug fix in 3.10, ddd85e225c "serial: omap: prevent runtime PM for
> "no_console_suspend"", introduced a regression from an obvious typo:

I don't see that commit id, or commit, in Linus's tree at all.  Where do
you see it?

> drivers/tty/serial/omap-serial.c:1677:14: error: 'serial_omap_complete' 
> 	undeclared here (not in a function)
> 
> This changes the incorrectly added macro to the one that we need instead.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Please apply for 3.10-rc

Really?  It doesn't apply to 3.10-rc3 or -rc4 from what I can tell.

confused,

greg k-h
