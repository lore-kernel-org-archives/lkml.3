Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbbAMNMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:12:42 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:35978 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbbAMNMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:12:36 -0500
MIME-Version: 1.0
In-Reply-To: <1421054073-43468-3-git-send-email-eddie.huang@mediatek.com>
References: <1421054073-43468-1-git-send-email-eddie.huang@mediatek.com>
	<1421054073-43468-3-git-send-email-eddie.huang@mediatek.com>
Date: Tue, 13 Jan 2015 14:12:35 +0100
Message-ID: <CABuKBeKGbxR8YQcVPJyZDpnVsNUsTxQQhsisW_F2L13zfgeyjw@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] irqchip: mtk-sysirq: Get irq number from register
 resource size
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Eddie Huang <eddie.huang@mediatek.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Rob Herring <robh+dt@kernel.org>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Olof Johansson <olof@lixom.net>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Robert Richter <rrichter@cavium.com>, Mark Brown <broonie@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?B?WUggQ2hlbiAo6Zmz5pix6LGqKQ==?= <yh.chen@mediatek.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-12 10:14 GMT+01:00 Eddie Huang <eddie.huang@mediatek.com>:
> From: Yingjoe Chen <yingjoe.chen@mediatek.com>
>
> Originally mtk-sysirq hardcoded supported irq number to 224. This
> was fine since all SoCs before support the same number of irqs for
> intpol.
>
> However MT8173 intpol support 32 more irq pins, changes to get
> irq number from register resource size to suppor MT8173 properly.
>
> Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
> Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
> ---
>  drivers/irqchip/irq-mtk-sysirq.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
>

Jason, Thomas, will you take this patch through your branch?
I will take the rest of the series.

Best regards,
Matthias

-- 
motzblog.wordpress.com
