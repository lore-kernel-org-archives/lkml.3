Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbaEPXGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 19:06:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446AbaEPXGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 19:06:08 -0400
Date: Fri, 16 May 2014 16:09:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: dgap: implement error handling in
 dgap_tty_register()
Message-ID: <20140516230928.GA31392@kroah.com>
References: <20140425070459.GA9155@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425070459.GA9155@devel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 04:04:59PM +0900, Daeseok Youn wrote:
> - alloc_tty_driver() is deprecated so it is changed to
> tty_alloc_driver()
> - Pointers which are allocated by alloc_tty_driver() and kzalloc()
> can be NULL so it need to check NULL for them.
> - If one of those is failed, it need to add proper handler for
> avoiding memory leak.
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  drivers/staging/dgap/dgap.c |   49 +++++++++++++++++++++++++++++++++++--------
>  1 files changed, 40 insertions(+), 9 deletions(-)

This doesn't apply at all to my tree anymore, please refresh it and
resend.

thanks,

greg k-h
