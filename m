Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaKCR6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:58:55 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:43759 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbaKCR6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:58:48 -0500
MIME-Version: 1.0
In-Reply-To: <1413973797-17619-5-git-send-email-yingjoe.chen@mediatek.com>
References: <1413973797-17619-1-git-send-email-yingjoe.chen@mediatek.com>
	<1413973797-17619-5-git-send-email-yingjoe.chen@mediatek.com>
Date: Mon, 3 Nov 2014 18:58:46 +0100
Message-ID: <CABuKBeJR+iCw_gZeq_SbZB2CtESJ5FX3jOZ1OwzELRcBH+jn9A@mail.gmail.com>
Subject: Re: [PATCH v4 4/8] ARM: mediatek: add dts for MT8135 evaluation board.
From: Matthias Brugger <matthias.bgg@gmail.com>
To: "Joe.C" <yingjoe.chen@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>, arm@kernel.org,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@gmail.com>,
        Hsien-Chun Yen <hc.yen@mediatek.com>,
        huang eddie <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        Yuhau Chen <yh.chen@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-22 12:29 GMT+02:00 Joe.C <yingjoe.chen@mediatek.com>:
> From: "Joe.C" <yingjoe.chen@mediatek.com>
>
> Evbp1 is a tablet evaluation board based on MT8135 SoC.
>
> Signed-off-by: Joe.C <yingjoe.chen@mediatek.com>
> ---
>  arch/arm/boot/dts/mt8135-evbp1.dts | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>  create mode 100644 arch/arm/boot/dts/mt8135-evbp1.dts
>
> diff --git a/arch/arm/boot/dts/mt8135-evbp1.dts b/arch/arm/boot/dts/mt8135-evbp1.dts
> new file mode 100644
> index 0000000..cba80b8
> --- /dev/null
> +++ b/arch/arm/boot/dts/mt8135-evbp1.dts
> @@ -0,0 +1,24 @@
> +/*
> + * Copyright (c) 2014 MediaTek Inc.
> + * Author: Joe.C <yingjoe.chen@mediatek.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +/dts-v1/;
> +#include "mt8135.dtsi"
> +
> +/ {
> +       model = "mediatek,mt8135-evbp1", "mediatek,mt8135";

Same here, you switched model and compatible property. Please provide
both of them.

> +
> +       memory {
> +               reg = <0 0x80000000 0 0x40000000>;
> +       };
> +};
> --
> 1.8.1.1.dirty
>



-- 
motzblog.wordpress.com
