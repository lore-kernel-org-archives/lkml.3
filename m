Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab3JLAIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 20:08:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab3JLAIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 20:08:10 -0400
Date: Fri, 11 Oct 2013 17:08:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthias Beyer <mail@beyermatthias.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] drivers: usb: core: devio.c: Braces around switch
Message-ID: <20131012000809.GA8772@kroah.com>
References: <1381441292-6145-1-git-send-email-mail@beyermatthias.de>
 <1381441292-6145-6-git-send-email-mail@beyermatthias.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381441292-6145-6-git-send-email-mail@beyermatthias.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 11:41:31PM +0200, Matthias Beyer wrote:
> Added braces around switch statement as the styleguide tells us.
> Indented the switch-block for it and split a function call
> (driver->unlocked_ioctl() on line 1876) arguments to several lines to
> fit the 80-column convention.
> 
> Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
> ---
>  drivers/usb/core/devio.c | 60 ++++++++++++++++++++++++++----------------------

This patch has fuzz, due to me not applying your previous one, so I
can't apply it.

Can you fix it up, and resend the remaining patches that I didn't apply
in this series?

thanks,

greg k-h
