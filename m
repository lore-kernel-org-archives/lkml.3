Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3EMSSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 14:18:20 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:45151 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab3EMSSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 14:18:17 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Paul Bolle <pebolle@tiscali.nl>, Kishon Vijay Abraham I <kishon@ti.com>,
        Felipe Balbi <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb: phy: remove CONFIG_USB_OTG_UTILS once more
Thread-Topic: [PATCH] usb: phy: remove CONFIG_USB_OTG_UTILS once more
Thread-Index: AQHOT7Xyfbl51L5IRECROHhHC2ycfZkDbIBg
Date: Mon, 13 May 2013 18:18:14 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458DC5CF1@US01WEMBX2.internal.synopsys.com>
References: <1368434606.1350.31.camel@x61.thuisdomein>
In-Reply-To: <1368434606.1350.31.camel@x61.thuisdomein>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4DIIUB4002659

> From: Paul Bolle [mailto:pebolle@tiscali.nl]
> Sent: Monday, May 13, 2013 1:43 AM
> 
> The Kconfig symbol USB_OTG_UTILS was removed in the v3.10 merge window,
> in commit fd89149875 ("usb: phy: remove CONFIG_USB_OTG_UTILS"). But that
> symbol popped up again in a few places. Remove it there too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
> 
>  drivers/staging/dwc2/Kconfig | 1 -
>  drivers/usb/gadget/Kconfig   | 1 -
>  drivers/usb/phy/Kconfig      | 1 -
>  3 files changed, 3 deletions(-)

For dwc2:
Acked-by: Paul Zimmerman <paulz@synopsys.com>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
