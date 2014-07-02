Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaGBHEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 03:04:24 -0400
Received: from canardo.mork.no ([148.122.252.1]:35085 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaGBHEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 03:04:22 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Bernd Wachter <bernd.wachter@jolla.com>
Cc: netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: qmi_wwan: Add ID for Telewell TW-LTE 4G v2
Organization: m
References: <87vbrgewei.fsf@bwachter.lart.info>
Date: Wed, 02 Jul 2014 09:04:10 +0200
In-Reply-To: <87vbrgewei.fsf@bwachter.lart.info> (Bernd Wachter's message of
	"Tue, 01 Jul 2014 22:01:09 +0300")
Message-ID: <87wqbw1bth.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Wachter <bernd.wachter@jolla.com> writes:

> There's a new version of the Telewell 4G modem working with, but not
> recognized by this driver. 
>
> Signed-off-by: Bernd Wachter <bernd.wachter@jolla.com>
> ---
> --- linux-3.15.3/drivers/net/usb/qmi_wwan.c.orig	2014-07-01 21:31:07.000000000 +0300
> +++ linux-3.15.3/drivers/net/usb/qmi_wwan.c	2014-07-01 20:39:30.000000000 +0300
> @@ -741,6 +741,7 @@ static const struct usb_device_id produc
>  	{QMI_FIXED_INTF(0x19d2, 0x1424, 2)},
>  	{QMI_FIXED_INTF(0x19d2, 0x1425, 2)},
>  	{QMI_FIXED_INTF(0x19d2, 0x1426, 2)},	/* ZTE MF91 */
> +	{QMI_FIXED_INTF(0x19d2, 0x1428, 2)},	/* Telewell TW-LTE 4G v2 */
>  	{QMI_FIXED_INTF(0x19d2, 0x2002, 4)},	/* ZTE (Vodafone) K3765-Z */
>  	{QMI_FIXED_INTF(0x0f3d, 0x68a2, 8)},    /* Sierra Wireless MC7700 */
>  	{QMI_FIXED_INTF(0x114f, 0x68a2, 8)},    /* Sierra Wireless MC7750 */

Acked-by: Bjørn Mork <bjorn@mork.no>

Please queue this for stable as well.  Thanks.


Bjørn
