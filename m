Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab3AUQYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 11:24:18 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:43685 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab3AUQYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 11:24:17 -0500
Message-ID: <50FD7950.3010209@mvista.com>
Date: Mon, 21 Jan 2013 20:22:24 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: musb: core: Add missing newline character
References: <1358779955-4916-1-git-send-email-kishon@ti.com>
In-Reply-To: <1358779955-4916-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/21/2013 05:52 PM, Kishon Vijay Abraham I wrote:

> No functional change. Just added a missing newline character.

> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/usb/musb/musb_core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

> diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
> index f1c6c54..c534131 100644
> --- a/drivers/usb/musb/musb_core.c
> +++ b/drivers/usb/musb/musb_core.c
> @@ -2301,7 +2301,7 @@ static int __init musb_init(void)
>  	pr_info("%s: version " MUSB_VERSION ", "
>  		"?dma?"
>  		", "
> -		"otg (peripheral+host)",
> +		"otg (peripheral+host)\n",
>  		musb_driver_name);
>  	return platform_driver_register(&musb_driver);
>  }

   Refresh your tree, alike patch is already upstream. :-)

WBR, Sergei

