Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab3BDVDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 16:03:13 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:33072 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754431Ab3BDVDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 16:03:12 -0500
Date: Mon, 4 Feb 2013 16:03:10 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: tony@atomide.com, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 31/31] USB: ehci-omap: Select NOP USB transceiver driver
In-Reply-To: <1359989205-12879-1-git-send-email-rogerq@ti.com>
Message-ID: <Pine.LNX.4.44L0.1302041602350.1756-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2013, Roger Quadros wrote:

> In PHY mode we need to have the nop-usb-xceiv transceiver
> driver to operate, so select it in Kconfig.
> 
> CC: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/usb/host/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 11e102e..2d2975d 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -157,6 +157,7 @@ config USB_EHCI_MXC
>  config USB_EHCI_HCD_OMAP
>  	tristate "EHCI support for OMAP3 and later chips"
>  	depends on USB_EHCI_HCD && ARCH_OMAP
> +	select NOP_USB_XCEIV
>  	default y
>  	---help---
>  	  Enables support for the on-chip EHCI controller on

Acked-by: Alan Stern <stern@rowland.harvard.edu>

