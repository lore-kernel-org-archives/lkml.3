Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab3DZWSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 18:18:22 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:43197 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab3DZWSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 18:18:20 -0400
Date: Fri, 26 Apr 2013 15:18:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        rmk+kernel@arm.linux.org.uk, linux-serial@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [PATCHv5 1/2] driver: tty: serial: Move "uart_console" def to
 core header file.
Message-ID: <20130426221817.GA28377@kroah.com>
References: <1367006686-3720-1-git-send-email-sourav.poddar@ti.com>
 <1367006686-3720-2-git-send-email-sourav.poddar@ti.com>
 <87vc79uezo.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vc79uezo.fsf@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 03:03:07PM -0700, Kevin Hilman wrote:
> Hi Greg,
> 
> Sourav Poddar <sourav.poddar@ti.com> writes:
> 
> > Move "uart_console" definition to serial core header file, so that it can be
> > used by serial drivers.
> > Get rid of the uart_console defintion from mpc52xx_uart driver.
> >
> > Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > Cc: Felipe Balbi <balbi@ti.com>
> > Cc: Rajendra nayak <rnayak@ti.com>
> > Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> > Reviewed-by: Felipe Balbi <balbi@ti.com>
> 
> Can you queue up this patch (and 2/2)?  Once these are in, I will queue
> up the corresponding arch/arm changes which can go independently.
> 
> And feel free to add
> 
> Reviewed-by: Kevin Hilman <khilman@linaro.org>
> Tested-by: Kevin Hilman <khilman@linaro.org>

I will do so after 3.10-rc1 is out, it is _way_ too late in the
development cycle for me to add these to my trees right now, considering
they are pretty much closed at the moment.

thanks,

greg k-h
