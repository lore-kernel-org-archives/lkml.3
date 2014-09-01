Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbaIANW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:22:58 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:62351 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbaIANW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:22:56 -0400
Message-ID: <5404732F.4000203@cogentembedded.com>
Date: Mon, 01 Sep 2014 17:22:55 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-usb@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: renesas_usbhs: fix driver dependencies
References: <8246169.KgpDT6Hn5J@amdc1032>
In-Reply-To: <8246169.KgpDT6Hn5J@amdc1032>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 9/1/2014 5:14 PM, Bartlomiej Zolnierkiewicz wrote:

> Renesas USBHS controller support should be available only on
> Renesas ARM SoCs and SuperH architecture.

> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Magnus Damm <magnus.damm@gmail.com>
> ---
>   drivers/usb/renesas_usbhs/Kconfig |    1 +
>   1 file changed, 1 insertion(+)

> Index: b/drivers/usb/renesas_usbhs/Kconfig
> ===================================================================
> --- a/drivers/usb/renesas_usbhs/Kconfig	2014-07-30 14:31:51.883523522 +0200
> +++ b/drivers/usb/renesas_usbhs/Kconfig	2014-09-01 14:25:42.028512490 +0200
> @@ -5,6 +5,7 @@
>   config USB_RENESAS_USBHS
>   	tristate 'Renesas USBHS controller'
>   	depends on USB_GADGET
> +	depends on ARCH_SHMOBILE || ARCH_SH || COMPILE_TEST

    Again, I think you meant SUPERH here, not ARCH_SH.

WBR, Sergei

