Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab3EUNTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 09:19:53 -0400
Received: from canardo.mork.no ([148.122.252.1]:44897 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab3EUNTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 09:19:51 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Schmiedl Christian <Christian.Schmiedl@gemalto.com>
Cc: "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Schemmel Hans-Christoph <Hans-Christoph.Schemmel@gemalto.com>
Subject: Re: [PATCH] qmi_wwan: Added support for Cinterion's PLxx WWAN Interface
Organization: m
References: <376FB829F3ECB542B825EAF4D8CA8A97013E8459E48B@CROEXCFWP03.gemalto.com>
Date: Tue, 21 May 2013 15:19:43 +0200
In-Reply-To: <376FB829F3ECB542B825EAF4D8CA8A97013E8459E48B@CROEXCFWP03.gemalto.com>
	(Schmiedl Christian's message of "Tue, 21 May 2013 14:07:17 +0200")
Message-ID: <877gislbbk.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Schmiedl Christian <Christian.Schmiedl@gemalto.com> writes:

> From: Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>
>
> Added support for Cinterion's PLxx WWAN Interface by adding QMI_FIXED_INTF with
> Cinterion's Vendor ID as well as Product ID and WWAN Interface Number.
>
> Signed-off-by: Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>
> Signed-off-by: Christian Schmiedl <christian.schmiedl@gemalto.com>
> ---
> patch is against linux-3.9
> --- linux-3.9/drivers/net/usb/qmi_wwan.c.orig	2013-05-06 08:10:11.170034451 +0200
> +++ linux-3.9/drivers/net/usb/qmi_wwan.c	2013-05-06 08:58:00.800264179 +0200
> @@ -569,6 +569,7 @@ static const struct usb_device_id produc
>  	{QMI_FIXED_INTF(0x1bbb, 0x011e, 4)},	/* Telekom Speedstick LTE II (Alcatel One Touch L100V LTE) */
>  	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
>  	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
> +	{QMI_FIXED_INTF(0x1e2d, 0x12d1, 4)},	/* Cinterion PLxx */
>
>  	/* 4. Gobi 1000 devices */
>  	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */

Acked-by: Bjørn Mork <bjorn@mork.no>
