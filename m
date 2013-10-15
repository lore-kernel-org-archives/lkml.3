Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839Ab3JOOok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:44:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758875Ab3JOOoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:44:38 -0400
Message-ID: <1381848597.25397.4.camel@dcbw.foobar.com>
Subject: Re: [PATCH] net: qmi_wwan: Olivetti Olicard 200 support
From: Dan Williams <dcbw@redhat.com>
To: Enrico Mioso <mrkiko.rs@gmail.com>
Cc: gregkh@linuxfoundation.org, davem@davemloft.net, bjorn@mork.no,
        christian.schmiedl@gemalto.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antonella Pellizzari <anto.pellizzari83@gmail.com>
Date: Tue, 15 Oct 2013 09:49:57 -0500
In-Reply-To: <1381842408-10800-2-git-send-email-mrkiko.rs@gmail.com>
References: <1381842408-10800-1-git-send-email-mrkiko.rs@gmail.com>
	 <1381842408-10800-2-git-send-email-mrkiko.rs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 15:06 +0200, Enrico Mioso wrote:
> This is a QMI device, manufactured by TCT Mobile Phones.
> A companion patch blacklisting this device's QMI interface in the option.c
> driver has been sent.
> 
> Signed-off-by: Enrico Mioso <mrkiko.rs@gmail.com>
> Signed-off-by: Antonella Pellizzari <anto.pellizzari83@gmail.com>

Good find.  For the record, mine has:

PX1522E16X  1  [Oct 15 2010 02:00:00]

	ctl (1.4)
	wds (1.8)
	dms (1.3)
	nas (1.2)
	qos (1.2)
	wms (1.1)
	pds (1.4)
	auth (1.0)
	voice (1.0)
	cat2 (1.1)

Tested-by: Dan Williams <dcbw@redhat.com>

> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 3d6aaf7..818ce90 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -714,6 +714,7 @@ static const struct usb_device_id products[] = {
>  	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
>  	{QMI_FIXED_INTF(0x2357, 0x9000, 4)},	/* TP-LINK MA260 */
>  	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
> +	{QMI_FIXED_INTF(0x0b3c, 0xc005, 6)},    /* Olivetti Olicard 200 */
>  	{QMI_FIXED_INTF(0x1e2d, 0x0060, 4)},	/* Cinterion PLxx */
>  
>  	/* 4. Gobi 1000 devices */


