Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966628Ab3E2OGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:06:44 -0400
Received: from antcom.de ([188.40.178.216]:57014 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966252Ab3E2OGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 10:06:42 -0400
Message-ID: <51A60B6D.3060402@antcom.de>
Date: Wed, 29 May 2013 16:06:37 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: gregkh@linuxfoundation.org, balbi@ti.com, stern@rowland.harvard.edu,
        kishon@ti.com, arnd@arndb.de, adrienverge@gmail.com,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] USB: lpc32xx: USB_LPC32XX need not depend on USB_PHY
References: <1369827811-534-1-git-send-email-rogerq@ti.com> <1369827811-534-5-git-send-email-rogerq@ti.com>
In-Reply-To: <1369827811-534-5-git-send-email-rogerq@ti.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 01:43 PM, Roger Quadros wrote:
> As the USB PHY drivers no longer depend on USB_PHY but
> select it if needed, the controller drivers need not
> depend on USB_PHY. They can safely select the necessary
> PHY driver i.e. USB_ISP1301 in this case.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Roland Stigge <stigge@antcom.de>
Tested-by: Roland Stigge <stigge@antcom.de>

Thanks!

> CC: Roland Stigge <stigge@antcom.de>
> ---
>  drivers/usb/gadget/Kconfig |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index f41aa0d..2b98bce 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -144,7 +144,6 @@ config USB_AT91
>  config USB_LPC32XX
>  	tristate "LPC32XX USB Peripheral Controller"
>  	depends on ARCH_LPC32XX
> -	depends on USB_PHY
>  	select USB_ISP1301
>  	help
>  	   This option selects the USB device controller in the LPC32xx SoC.

