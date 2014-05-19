Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbaESTay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:30:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42814 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751473AbaESTav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:30:51 -0400
Date: Mon, 19 May 2014 15:30:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
cc: balbi@ti.com, <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <joe@perches.com>,
        <auttamchandani@logicube.com>
Subject: Re: [PATCH 2/5] usb: gadget: net2280: Use S_I macros
In-Reply-To: <1400526693-29776-3-git-send-email-ricardo.ribalda@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1405191527520.1538-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014, Ricardo Ribalda Delgado wrote:

> Instead of octal notation, to be consistent around the file.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/usb/gadget/net2280.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
> index c3205ec..5b2ab68 100644
> --- a/drivers/usb/gadget/net2280.c
> +++ b/drivers/usb/gadget/net2280.c
> @@ -111,7 +111,7 @@ module_param(use_msi, bool, S_IRUGO);
>  static ushort fifo_mode = 0;
>  
>  /* "modprobe net2280 fifo_mode=1" etc */
> -module_param (fifo_mode, ushort, 0644);
> +module_param(fifo_mode, ushort, S_IRUGO | S_IWUSR);

I don't think this is necessary, in and of itself.  In my opinion, the 
macros are a lot harder to figure out than the octal values.

Don't bother making this change.  It's useless churn.

Alan Stern

