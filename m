Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab3G2QoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:44:05 -0400
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:39352 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab3G2QoB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:44:01 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH] bluetooth: remove wrong dependency for BT_ATH3K
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1375114325-25498-1-git-send-email-hector.palacios@digi.com>
Date: Mon, 29 Jul 2013 09:43:53 -0700
Cc: <linux-bluetooth@vger.kernel.org>, <gustavo@padovan.org>,
        <johan.hedberg@gmail.com>, <linux-kernel@vger.kernel.org>,
        <vikram.kandukuri@atheros.com>, <suraj@atheros.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <5438CD3C-E28C-485C-94B8-F743E8B13D4A@holtmann.org>
References: <1375114325-25498-1-git-send-email-hector.palacios@digi.com>
To: Hector Palacios <hector.palacios@digi.com>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hector,

> The Atheros firmware download driver is not dependent on HCI
> USB driver. This driver is needed to complement any Atheros
> driver like BT_HCIUART_ATH3K.
> 
> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
> CC: Suraj Sumangala <suraj@atheros.com>
> CC: Vikram Kandukuri <vikram.kandukuri@atheros.com>
> ---
> drivers/bluetooth/Kconfig | 1 -
> 1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
> index 11a6104..a1d482b 100644
> --- a/drivers/bluetooth/Kconfig
> +++ b/drivers/bluetooth/Kconfig
> @@ -222,7 +222,6 @@ config BT_MRVL_SDIO
> 
> config BT_ATH3K
> 	tristate "Atheros firmware download driver"
> -	depends on BT_HCIBTUSB
> 	select FW_LOADER
> 	help
> 	  Bluetooth firmware download driver.
> 

I am confused now. How can an USB driver work with an UART driver? If you do not want to depend on BT_HCIBTUSB then that is fine, but at least you need to depend on USB.

Regards

Marcel

