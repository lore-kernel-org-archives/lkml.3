Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbaIRNJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:09:23 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62566 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaIRNJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:09:21 -0400
Message-ID: <541AD97D.2090304@gmail.com>
Date: Thu, 18 Sep 2014 15:09:17 +0200
From: Matthias Brugger <matthias.bgg@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: "Joe.C" <srv_yingjoe.chen@mediatek.com>, Rob Herring <robh+dt@kernel.org>,
        arm@kernel.org
CC: linux-arm-kernel@lists.infradead.org, srv_heupstream@mediatek.com,
        yingjoe.chen@gmail.com, yingjoe.chen@mediatek.com, hc.yen@mediatek.com,
        eddie.huang@mediatek.com, nathan.chung@mediatek.com,
        yh.chen@mediatek.com, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Anders Berg <anders.berg@lsi.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/7] dt-bindings: add more chips in documentation for
 Mediatek SoC
References: <1410963854-17154-1-git-send-email-srv_yingjoe.chen@mediatek.com> <1410963854-17154-6-git-send-email-srv_yingjoe.chen@mediatek.com>
In-Reply-To: <1410963854-17154-6-git-send-email-srv_yingjoe.chen@mediatek.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I just saw some more issues:

On 17/09/14 16:24, Joe.C wrote:
> From: "Joe.C" <yingjoe.chen@mediatek.com>
> 
> Add MT8127 & MT8135 from Mediatek.
> 
> Signed-off-by: Joe.C <yingjoe.chen@mediatek.com>
> ---
>  Documentation/devicetree/bindings/arm/mediatek.txt | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/mediatek.txt b/Documentation/devicetree/bindings/arm/mediatek.txt
> index fa25226..40a9745 100644
> --- a/Documentation/devicetree/bindings/arm/mediatek.txt
> +++ b/Documentation/devicetree/bindings/arm/mediatek.txt
> @@ -1,10 +1,13 @@
> -Mediatek MT6589 Platforms Device Tree Bindings
> +Mediatek Platforms Device Tree Bindings
>  
> -Boards with a SoC of the Mediatek MT6589 shall have the following property:
> +Boards with a SoC of the Mediatek shall have the following property:
>  
>  Required root node property:
>  
> -compatible: must contain "mediatek,mt6589"
> +compatible: Must contain one of
> +   "mediatek,mt6589"
> +   "mediatek,mt8127"
> +   "mediatek,mt8135"
>  
>  
>  Supported boards:

Please document the supported boards and add a compatible string in the
dts files for moose and evbp1 boards.

Thanks,
Matthias

> 
