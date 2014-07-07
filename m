Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbaGGIeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:34:03 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:57513 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaGGId6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:33:58 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 7 Jul 2014 10:33:22 +0200
From: Johan Hovold <johan@kernel.org>
To: Bernd Wachter <bernd.wachter@jolla.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: option: Add ID for Telewell TW-LTE 4G v2
Message-ID: <20140707083322.GC29098@localhost>
References: <87ha30yudr.fsf@bwachter.lart.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ha30yudr.fsf@bwachter.lart.info>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 12:36:48PM +0300, Bernd Wachter wrote:
> 
> Add ID of the Telewell 4G v2 hardware to option driver to get legacy
> serial interface working
> 
> 
> Signed-off-by: Bernd Wachter <bernd.wachter@jolla.com>

Applied, thanks.

Johan

> ---
> --- linux-3.15.3/drivers/usb/serial/option.c.orig	2014-07-02 12:23:28.000000000 +0300
> +++ linux-3.15.3/drivers/usb/serial/option.c	2014-07-02 12:25:16.000000000 +0300
> @@ -1480,6 +1480,8 @@ static const struct usb_device_id option
>  		.driver_info = (kernel_ulong_t)&net_intf2_blacklist },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1426, 0xff, 0xff, 0xff),  /* ZTE MF91 */
>  		.driver_info = (kernel_ulong_t)&net_intf2_blacklist },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1428, 0xff, 0xff, 0xff),  /* Telewell TW-LTE 4G v2 */
> +		.driver_info = (kernel_ulong_t)&net_intf2_blacklist },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1533, 0xff, 0xff, 0xff) },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1534, 0xff, 0xff, 0xff) },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1535, 0xff, 0xff, 0xff) },
