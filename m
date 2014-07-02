Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaGBFTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 01:19:55 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:56128 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaGBFTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 01:19:53 -0400
Message-ID: <53B39672.7050301@gmail.com>
Date: Wed, 02 Jul 2014 12:19:46 +0700
From: Lars Melin <larsm17@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Bernd Wachter <bernd.wachter@jolla.com>, netdev@vger.kernel.org
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: qmi_wwan: Add ID for Telewell TW-LTE 4G v2
References: <87vbrgewei.fsf@bwachter.lart.info>
In-Reply-To: <87vbrgewei.fsf@bwachter.lart.info>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-02 02:01, Bernd Wachter wrote:
> There's a new version of the Telewell 4G modem working with, but not
> recognized by this driver.
>
> Signed-off-by: Bernd Wachter <bernd.wachter@jolla.com>
> ---
> --- linux-3.15.3/drivers/net/usb/qmi_wwan.c.orig	2014-07-01 21:31:07.000000000 +0300
> +++ linux-3.15.3/drivers/net/usb/qmi_wwan.c	2014-07-01 20:39:30.000000000 +0300
> @@ -741,6 +741,7 @@ static const struct usb_device_id produc
>   	{QMI_FIXED_INTF(0x19d2, 0x1424, 2)},
>   	{QMI_FIXED_INTF(0x19d2, 0x1425, 2)},
>   	{QMI_FIXED_INTF(0x19d2, 0x1426, 2)},	/* ZTE MF91 */
> +	{QMI_FIXED_INTF(0x19d2, 0x1428, 2)},	/* Telewell TW-LTE 4G v2 */
>   	{QMI_FIXED_INTF(0x19d2, 0x2002, 4)},	/* ZTE (Vodafone) K3765-Z */
>   	{QMI_FIXED_INTF(0x0f3d, 0x68a2, 8)},    /* Sierra Wireless MC7700 */
>   	{QMI_FIXED_INTF(0x114f, 0x68a2, 8)},    /* Sierra Wireless MC7750 */
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
For completeness (full device support) please create a patch for the 
serial interfaces in the option driver, see the entry for ZTE pid 1426 
in option.c as example.
