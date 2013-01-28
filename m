Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab3A1Q7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:59:37 -0500
Received: from canardo.mork.no ([148.122.252.1]:52961 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900Ab3A1Q7d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:59:33 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Daniele Palmas <dnlplm@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] NET: qmi_wwan: add Telit LE920 support
Organization: m
References: <1359387918-2791-1-git-send-email-dnlplm@gmail.com>
Date: Mon, 28 Jan 2013 17:59:20 +0100
In-Reply-To: <1359387918-2791-1-git-send-email-dnlplm@gmail.com> (Daniele
	Palmas's message of "Mon, 28 Jan 2013 16:45:18 +0100")
Message-ID: <87k3qxnt07.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniele Palmas <dnlplm@gmail.com> writes:

> Add VID, PID and fixed interface for Telit LE920
>
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
> ---
>  drivers/net/usb/qmi_wwan.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 6a1ca50..e32f9a1 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -459,6 +459,7 @@ static const struct usb_device_id products[] = {
>  	{QMI_FIXED_INTF(0x1199, 0x68a2, 19)},	/* Sierra Wireless MC7710 in QMI mode */
>  	{QMI_FIXED_INTF(0x1199, 0x901c, 8)},    /* Sierra Wireless EM7700 */
>  	{QMI_FIXED_INTF(0x1bbb, 0x011e, 4)},	/* Telekom Speedstick LTE II (Alcatel One Touch L100V LTE) */
> +	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
>  
>  	/* 4. Gobi 1000 devices */
>  	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */

Thanks for adding this device. But the patch doesn't apply to the
current "net" tree.  Care to rebase it?


Thanks,
Bjørn
