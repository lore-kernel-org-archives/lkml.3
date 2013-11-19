Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab3KSKcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 05:32:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab3KSKcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 05:32:31 -0500
Date: Tue, 19 Nov 2013 11:32:27 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Adam Cozzette <acozzette@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usbkbd.c: trivial typo ('released' -> 'pressed')
In-Reply-To: <1384725083-3963-1-git-send-email-acozzette@gmail.com>
Message-ID: <alpine.LNX.2.00.1311191132200.6657@pobox.suse.cz>
References: <1384725083-3963-1-git-send-email-acozzette@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Nov 2013, Adam Cozzette wrote:

> It looks like this typo was introduced by a mistake in a copy-and-paste in
> commit ddbe32491951.
> 
> Signed-off-by: Adam Cozzette <acozzette@gmail.com>
> ---
>  drivers/hid/usbhid/usbkbd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/usbhid/usbkbd.c b/drivers/hid/usbhid/usbkbd.c
> index 7960869..9a332e6 100644
> --- a/drivers/hid/usbhid/usbkbd.c
> +++ b/drivers/hid/usbhid/usbkbd.c
> @@ -146,7 +146,7 @@ static void usb_kbd_irq(struct urb *urb)
>  				input_report_key(kbd->dev, usb_kbd_keycode[kbd->new[i]], 1);
>  			else
>  				hid_info(urb->dev,
> -					 "Unknown key (scancode %#x) released.\n",
> +					 "Unknown key (scancode %#x) pressed.\n",
>  					 kbd->new[i]);
>  		}
>  	}

Applied to hid.git, thanks.

-- 
Jiri Kosina
SUSE Labs
