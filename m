Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbbAHM2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 07:28:49 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:58698 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbbAHM2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:28:47 -0500
MIME-Version: 1.0
In-Reply-To: <1420698191-10878-2-git-send-email-howard.chen@linaro.org>
References: <1420698191-10878-1-git-send-email-howard.chen@linaro.org>
	<1420698191-10878-2-git-send-email-howard.chen@linaro.org>
Date: Thu, 8 Jan 2015 13:28:45 +0100
Message-ID: <CABuKBeLFD4D8MB14o206Bs2t5sqhatsLzhV26rHkFrt5dd8+Qw@mail.gmail.com>
Subject: Re: [PATCH 2/2] dt-bindings: add mt6592 compatible string for
 mediatek sysirq
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Howard Chen <howard.chen@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Jason Cooper <jason@lakedaemon.net>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC..." 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Howard,

2015-01-08 7:23 GMT+01:00 Howard Chen <howard.chen@linaro.org>:
> Signed-off-by: Howard Chen <howard.chen@linaro.org>
> ---
>  Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt | 1 +
>  1 file changed, 1 insertion(+)

This patch lacks a description of what it does. I added a description
and applied both to my tree. Please remember the next time to add a
description to all patches.

Thanks,
Matthias

>
> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
> index d680b07..4cd6f7b 100644
> --- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
> @@ -7,6 +7,7 @@ Required properties:
>  - compatible: should be one of:
>         "mediatek,mt8135-sysirq"
>         "mediatek,mt8127-sysirq"
> +       "mediatek,mt6592-sysirq"
>         "mediatek,mt6589-sysirq"
>         "mediatek,mt6582-sysirq"
>         "mediatek,mt6577-sysirq"
> --
> 1.9.1
>



-- 
motzblog.wordpress.com
