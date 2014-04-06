Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbaDFS0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 14:26:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56732 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbaDFS02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 14:26:28 -0400
Date: Sun, 6 Apr 2014 11:28:56 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joel Pelaez Jorge <joelpelaez@gmail.com>
Cc: Silvan Jegen <s.jegen@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8192e: Fix sparse warning
Message-ID: <20140406182856.GA24982@kroah.com>
References: <53419B93.8060806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53419B93.8060806@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2014 at 01:23:15PM -0500, Joel Pelaez Jorge wrote:
> drivers/staging/rtl8192e/rtl8192e/rtl_wx.c:1323:24: warning:
> symbol 'r8192_wx_handlers_def' was not declared. Should it be static
> 
> Signed-off-by: Joel Pelaez Jorge <joelpelaez@gmail.com>
> ---
>   drivers/staging/rtl8192e/rtl8192e/rtl_wx.c |    2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c 
> b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
> index 498995d..5baa699 100644
> --- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
> +++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
> @@ -20,6 +20,8 @@
>   #include <linux/string.h>
>   #include "rtl_core.h"
> 
> +extern struct iw_handler_def r8192_wx_handlers_def;

Don't put "extern" in a .c file, that's never the correct solution.

thanks,

greg k-h
