Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbaJIO6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:58:19 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64639 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754391AbaJIO6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:58:11 -0400
Date: Thu, 9 Oct 2014 15:57:18 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "Joe.C" <yingjoe.chen@mediatek.com>
Cc: "arm@kernel.org" <arm@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        "yingjoe.chen@gmail.com" <yingjoe.chen@gmail.com>,
        "hc.yen@mediatek.com" <hc.yen@mediatek.com>,
        "eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
        "nathan.chung@mediatek.com" <nathan.chung@mediatek.com>,
        "yh.chen@mediatek.com" <yh.chen@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <Pawel.Moll@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Matt Porter <mporter@linaro.org>, Marc Carino <marc.ceeeee@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sricharan R <r.sricharan@ti.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 6/7] dt-bindings: add irq domain parent binding
Message-ID: <20141009145718.GB18384@leverpostej>
References: <1412864980-20273-1-git-send-email-yingjoe.chen@mediatek.com>
 <1412864980-20273-7-git-send-email-yingjoe.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412864980-20273-7-git-send-email-yingjoe.chen@mediatek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 09, 2014 at 03:29:39PM +0100, Joe.C wrote:
> From: "Joe.C" <yingjoe.chen@mediatek.com>
> 
> Add "arm,irq-domain-hierarchy" optional property.
> 
> Signed-off-by: Joe.C <yingjoe.chen@mediatek.com>
> ---
>  Documentation/devicetree/bindings/arm/gic.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
> index c7d2fa1..f0bb759 100644
> --- a/Documentation/devicetree/bindings/arm/gic.txt
> +++ b/Documentation/devicetree/bindings/arm/gic.txt
> @@ -68,6 +68,8 @@ Example:
>  		      <0xfff10100 0x100>;
>  	};
>  
> +- arm,irq-domain-hierarchy : When this property exists, gic will be used as
> +  parent for hierarchy irq domain.

IRQ domains are a Linux internal detail, and their description doesn't
belong in the DT. So this property does not look like it should be
described in the DT.

I don't see a description of any relationship between devices here, so
it's not clear to me what this property is intended to imply.

Why do you think you need this?

Thanks,
Mark.
