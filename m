Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934044Ab3BTQdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 11:33:22 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34785 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933889Ab3BTQdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 11:33:20 -0500
Date: Wed, 20 Feb 2013 11:33:19 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Manjunath Goudar <manjunath.goudar@linaro.org>
cc: linux-usb@vger.kernel.org, <linux-arm-kernel@lists.infradead.org>,
        <patches@linaro.org>, <arnd@linaro.org>, <gregkh@linuxfoundation.org>,
        Greg KH <greg@kroah.com>, Wan ZongShun <mcuos.com@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [V2 7/8] USB: EHCI: make ehci-w90X900 a separate driver
In-Reply-To: <1360923853-7875-8-git-send-email-manjunath.goudar@linaro.org>
Message-ID: <Pine.LNX.4.44L0.1302201132440.1671-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2013, Manjunath Goudar wrote:

> Separate the Nuvoton On-Chip host controller driver
> from ehci-hcd host code into its own static driver module.

> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -238,7 +238,7 @@ config USB_EHCI_MV
>  	  only be EHCI host. OTG is controller that can switch to host mode.
>  
>  config USB_W90X900_EHCI
> -	bool "W90X900(W90P910) EHCI support"
> +	 tristate "W90X900(W90P910) EHCI support"

Whitespace error.  You inserted an extra space character.

Alan Stern

