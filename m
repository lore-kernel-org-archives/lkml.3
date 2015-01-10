Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbbAJBml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 20:42:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39743 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbbAJBmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 20:42:40 -0500
Date: Fri, 9 Jan 2015 17:42:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Olli Lehtinen <olli.lehtinen@iki.fi>
Cc: jkc@redhat.com, sparmaintainer@unisys.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: unisys: Removed a prohibited space in a
 function parameter
Message-ID: <20150110014239.GA31366@kroah.com>
References: <d63fd4753ad47af98d2b26198dcf8db7@kapsi.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d63fd4753ad47af98d2b26198dcf8db7@kapsi.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 12:51:55PM +0200, Olli Lehtinen wrote:
> Fixes the checkpatch.pl error:
> ERROR: space prohibited before that ',' (ctx:WxW)" in virthba.c.
> 
> Signed-off-by: Olli Lehtinen <olli.lehtinen@iki.fi>
> ---
>  drivers/staging/unisys/virthba/virthba.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/unisys/virthba/virthba.c
> b/drivers/staging/unisys/virthba/virthba.c
> index d7a629b..82fcb3b 100644
> --- a/drivers/staging/unisys/virthba/virthba.c
> +++ b/drivers/staging/unisys/virthba/virthba.c
> @@ -1438,7 +1438,7 @@ static ssize_t enable_ints_write(struct file *file,
> 		return -EFAULT;
> 	}
> 
> -	i = kstrtoint(buf, 10 , &new_value);
> +	i = kstrtoint(buf, 10, &new_value);
> 
> 	if (i != 0) {
> 		LOGERR("Failed to scan value for enable_ints, buf<<%.*s>>",
> -- 
> 1.7.10.4

This patch fails to apply for some reason :(

Please fix it up and resend.

greg k-h
