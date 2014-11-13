Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334AbaKMQVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 11:21:48 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:51714 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327AbaKMQVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 11:21:46 -0500
MIME-Version: 1.0
In-Reply-To: <1415808457-4030-4-git-send-email-ibanezchen@gmail.com>
References: <1415808457-4030-1-git-send-email-ibanezchen@gmail.com>
	<1415808457-4030-4-git-send-email-ibanezchen@gmail.com>
Date: Thu, 13 Nov 2014 17:21:44 +0100
Message-ID: <CABuKBeJXwrEQgttj=wVYJz5E_pdn-2D4DP2=iqtPAuMcFWM5GQ@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] DTS: serial: Add bindings documention for the
 Mediatek UARTs
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Howard Chen <ibanezchen@gmail.com>
Cc: arm@kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-12 17:07 GMT+01:00 Howard Chen <ibanezchen@gmail.com>:
> This patch add s devicetree document for Mediatek UART.
>
> Signed-off-by: Howard Chen <ibanezchen@gmail.com>
> ---
>  Documentation/devicetree/bindings/serial/mtk-uart.txt | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/serial/mtk-uart.txt b/Documentation/devicetree/bindings/serial/mtk-uart.txt
> index 48358a3..e2864b7 100644
> --- a/Documentation/devicetree/bindings/serial/mtk-uart.txt
> +++ b/Documentation/devicetree/bindings/serial/mtk-uart.txt
> @@ -2,9 +2,10 @@
>
>  Required properties:
>  - compatible should contain:
> +  * "mediatek,mt6592-uart" for MT6592 compatible UARTS
>    * "mediatek,mt6589-uart" for MT6589 compatible UARTS
>    * "mediatek,mt6582-uart" for MT6582 compatible UARTS
> -  * "mediatek,mt6577-uart" for all compatible UARTS (MT6589, MT6582, MT6577)
> +  * "mediatek,mt6577-uart" for all compatible UARTS on MT65xx

This patch should be send when we can add the uart driver to the SoC.
Sorry I didn't realize in my last review.

>
>  - reg: The base address of the UART register bank.
>
> --
> 1.9.1
>



-- 
motzblog.wordpress.com
