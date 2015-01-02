Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbbABKYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 05:24:12 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:58461 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbbABKYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 05:24:08 -0500
MIME-Version: 1.0
In-Reply-To: <1413983529-21887-4-git-send-email-eddie.huang@mediatek.com>
References: <1413983529-21887-1-git-send-email-eddie.huang@mediatek.com>
	<1413983529-21887-4-git-send-email-eddie.huang@mediatek.com>
Date: Fri, 2 Jan 2015 11:24:06 +0100
Message-ID: <CABuKBeL9r6Gm19fdKwx5HUDiyJKgC1xcLp1j1B9JbOa=c+3Epg@mail.gmail.com>
Subject: Re: [PATCH 3/3] DTS: serial: Add bindings document for the Mediatek UARTs
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Eddie Huang <eddie.huang@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        =?UTF-8?B?WUggQ2hlbiAo6Zmz5pix6LGqKQ==?= <yh.chen@mediatek.com>,
        HC Yen <hc.yen@mediatek.com>, Nathan Chung <nathan.chung@mediatek.com>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-22 15:12 GMT+02:00 Eddie Huang <eddie.huang@mediatek.com>:
> This patch add s devicetree document for Mediatek UART.
>
> Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
> ---
>  Documentation/devicetree/bindings/serial/mtk-uart.txt | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/serial/mtk-uart.txt b/Documentation/devicetree/bindings/serial/mtk-uart.txt
> index 48358a3..0eebbfe 100644
> --- a/Documentation/devicetree/bindings/serial/mtk-uart.txt
> +++ b/Documentation/devicetree/bindings/serial/mtk-uart.txt
> @@ -2,6 +2,8 @@
>
>  Required properties:
>  - compatible should contain:
> +  * "mediatek,mt8135-uart" for MT8135 compatible UARTS
> +  * "mediatek,mt8127-uart" for MT8127 compatible UARTS
>    * "mediatek,mt6589-uart" for MT6589 compatible UARTS
>    * "mediatek,mt6582-uart" for MT6582 compatible UARTS
>    * "mediatek,mt6577-uart" for all compatible UARTS (MT6589, MT6582, MT6577)
> --
> 1.8.1.1.dirty
>

Applied to v3.20-next/dts, thanks.

-- 
motzblog.wordpress.com
