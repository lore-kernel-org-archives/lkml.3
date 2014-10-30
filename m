Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227AbaJ3Oeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:34:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33278 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaJ3Oeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:34:36 -0400
Date: Thu, 30 Oct 2014 07:33:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anton Staaf <robotboy@chromium.org>
Cc: Johan Hovold <jhovold@gmail.com>, Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: simple: add Google simple serial SubClass support
Message-ID: <20141030143324.GA19307@kroah.com>
References: <1414617716-39377-1-git-send-email-robotboy@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414617716-39377-1-git-send-email-robotboy@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 02:21:56PM -0700, Anton Staaf wrote:
> Add support for Google devices that export simple serial
> interfaces using the vendor specific SubClass/Protocol pair
> 0x50/0x01.
> 
> Signed-off-by: Anton Staaf <robotboy@chromium.org>
> 
> ---
>  drivers/usb/serial/usb-serial-simple.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/usb/serial/usb-serial-simple.c b/drivers/usb/serial/usb-serial-simple.c
> index fb79775..85bb973 100644
> --- a/drivers/usb/serial/usb-serial-simple.c
> +++ b/drivers/usb/serial/usb-serial-simple.c
> @@ -8,6 +8,7 @@
>   * Copyright (C) 2010 Zilogic Systems <code@zilogic.com>
>   * Copyright (C) 2013 Wei Shuai <cpuwolf@gmail.com>
>   * Copyright (C) 2013 Linux Foundation
> + * Copyright (C) 2014 Google, Inc.
>   *
>   *	This program is free software; you can redistribute it and/or
>   *	modify it under the terms of the GNU General Public License version

Based on advice from my lawyer, a change this size does not warrent a
copyright notice at the top of a file.  If your lawyers feel otherwise,
please let me know and I will be glad to discuss it with them.

So, care to resend this without this change to the file?

thanks,

greg k-h
