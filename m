Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab3GZQfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 12:35:01 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.200]:47466 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756754Ab3GZQfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 12:35:00 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-131.messagelabs.com!1374856494!4583532!11
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.9.11; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "kernel@wantstofly.org" <kernel@wantstofly.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Fri, 26 Jul 2013 11:32:41 -0500
Subject: RE: [PATCH v2 0/4] usb: ohci-ep93xx: do a bit of housecleaning
Thread-Topic: [PATCH v2 0/4] usb: ohci-ep93xx: do a bit of housecleaning
Thread-Index: Ac52rbm8TK0EBcRsSsWeCbNvhOef7gTb+Dpw
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021DAC5C212C@AUSP01VMBX24.collaborationhost.net>
References: <201307011552.29868.hartleys@visionengravers.com>
In-Reply-To: <201307011552.29868.hartleys@visionengravers.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6QGZ84J013126

On Monday, July 01, 2013 3:52 PM, H Hartley Sweeten wrote:
> Tidy up this driver a bit.
>
> v2: redo patch 4 based on suggestions from Alan Stern
>
> H Hartley Sweeten (4):
>   usb: ohci-ep93xx: use devm_ioremap_resource()
>   usb: ohci-ep93xx: use platform_get_irq()
>   usb: ohci-ep93xx: use devm_clk_get()
>   usb: ohci-ep93xx: tidy up driver (*probe) and (*remove)
>
>  drivers/usb/host/ohci-ep93xx.c | 137 ++++++++++++++++-------------------------
>  1 file changed, 52 insertions(+), 85 deletions(-)

All of these have been Acked-by: Alan Stern.

Any ideas when they might be picked up and applied?

Thanks,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
