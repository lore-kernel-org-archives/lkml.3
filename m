Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbaKLLnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:43:20 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:35101 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbaKLLnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:43:15 -0500
MIME-Version: 1.0
In-Reply-To: <1415678111-29914-3-git-send-email-ibanezchen@gmail.com>
References: <1415678111-29914-1-git-send-email-ibanezchen@gmail.com>
	<1415678111-29914-3-git-send-email-ibanezchen@gmail.com>
Date: Wed, 12 Nov 2014 12:43:13 +0100
Message-ID: <CABuKBeJRW9aKdbmK5Yum6dM99m3AihA9t-1U3+3H9XjtfUHvmw@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] dt-bindings: add documentation for Mediatek SoC
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

2014-11-11 4:55 GMT+01:00 Howard Chen <ibanezchen@gmail.com>:
> This adds a DT binding documentation for the MT6592 SoC from Mediatek.
>
> Signed-off-by: Howard Chen <ibanezchen@gmail.com>
> ---
>  Documentation/devicetree/bindings/arm/mediatek.txt    | 7 +++++--
>  Documentation/devicetree/bindings/serial/mtk-uart.txt | 3 ++-
>  2 files changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/arm/mediatek.txt b/Documentation/devicetree/bindings/arm/mediatek.txt
> index fa25226..1d2d151 100644
> --- a/Documentation/devicetree/bindings/arm/mediatek.txt
> +++ b/Documentation/devicetree/bindings/arm/mediatek.txt
> @@ -1,10 +1,10 @@
>  Mediatek MT6589 Platforms Device Tree Bindings
>
> -Boards with a SoC of the Mediatek MT6589 shall have the following property:
> +Boards with a SoC from Mediatek shall have the following property:
>
>  Required root node property:
>
> -compatible: must contain "mediatek,mt6589"
> +compatible: must contain one of "mediatek,mt6589", "mediatek,mt6592"
>
>
>  Supported boards:
> @@ -12,3 +12,6 @@ Supported boards:
>  - bq Aquaris5 smart phone:
>      Required root node properties:
>        - compatible = "mundoreader,bq-aquaris5", "mediatek,mt6589";
> +
> +- Evaluation board for MT6592:
> +      - compatible = "mediatek,mt6592-evb", "mediatek,mt6592";
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

This should be two seperate patches, one for the SoC documentation and
one for the UART documentation.

>
>  - reg: The base address of the UART register bank.
>
> --
> 1.9.1
>



-- 
motzblog.wordpress.com
