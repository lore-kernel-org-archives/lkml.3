Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab3FWUBA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 16:01:00 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:40621 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3FWUA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 16:00:59 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Joseph CHANG <josright123@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, joseph_chang@davicom.com.tw,
        josright@hotmail.com
Subject: Re: [PATCH 1/1] net: add dm9620 net usb driver
References: <1371730801-2288-1-git-send-email-josright123@gmail.com>
Date: Sun, 23 Jun 2013 22:00:52 +0200
In-Reply-To: <1371730801-2288-1-git-send-email-josright123@gmail.com> (Joseph
	CHANG's message of "Thu, 20 Jun 2013 20:20:01 +0800")
Message-ID: <87mwqglhqj.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Joseph" == Joseph CHANG <josright123@gmail.com> writes:

 Joseph> DM9620 is an USB2.0 network adapter rather than DM9601 USB1.1. This
 Joseph> driver processed the RX data 4 bytes header, TX data 2 bytes header,
 Joseph> make the control bit exactly right in PHY write function, and optional
 Joseph> IFF_ALLMUTLI bit for RX control.

But dm9601.c already supports the dm9620 based devices. Why another
driver for the same hardware?

Please CC me on dm9601 related patches.

 Joseph> Tested good for many platforms, include X86 desktop and ARM embedded.

 Joseph> +static struct usb_driver dm9620_driver = {
 Joseph> +	.name = "dm9620",
 Joseph> +	.id_table = products,
 Joseph> +	.probe = usbnet_probe,
 Joseph> +	.disconnect = usbnet_disconnect,
 Joseph> +	.suspend = usbnet_suspend,
 Joseph> +	.resume = usbnet_resume,
 Joseph> +	.disable_hub_initiated_lpm = 1,
 Joseph> +};
 Joseph> +
 Joseph> +module_usb_driver(dm9620_driver);
 Joseph> +
 Joseph> +MODULE_AUTHOR("Peter Korsgaard <jacmet@sunsite.dk>");

I'm not the author of this file.


-- 
Bye, Peter Korsgaard
