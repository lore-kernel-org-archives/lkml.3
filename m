Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbbAXR07 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 12:26:59 -0500
Received: from www.linutronix.de ([62.245.132.108]:40896 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbbAXR04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 12:26:56 -0500
Date: Sat, 24 Jan 2015 18:26:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthias Brugger <matthias.bgg@gmail.com>
cc: Eddie Huang <eddie.huang@mediatek.com>,
        Jason Cooper <jason@lakedaemon.net>, Rob Herring <robh+dt@kernel.org>,
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
        =?GB2312?Q?YH_Chen_=28=EA=90=EA=C5=BA=C0=29?= 
	<yh.chen@mediatek.com>
Subject: Re: [PATCH v4 2/4] irqchip: mtk-sysirq: Get irq number from register
 resource size
In-Reply-To: <CABuKBeKJGx8mrjd+izR1zjxQNcWF+T2uUK=MbMbHYrXdRDTOyA@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1501241825410.5526@nanos>
References: <1421054073-43468-1-git-send-email-eddie.huang@mediatek.com> <1421054073-43468-3-git-send-email-eddie.huang@mediatek.com> <CABuKBeKGbxR8YQcVPJyZDpnVsNUsTxQQhsisW_F2L13zfgeyjw@mail.gmail.com>
 <CABuKBeKJGx8mrjd+izR1zjxQNcWF+T2uUK=MbMbHYrXdRDTOyA@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Matthias Brugger wrote:
> 2015-01-13 14:12 GMT+01:00 Matthias Brugger <matthias.bgg@gmail.com>:
> > 2015-01-12 10:14 GMT+01:00 Eddie Huang <eddie.huang@mediatek.com>:
> >> From: Yingjoe Chen <yingjoe.chen@mediatek.com>
> >>
> >> Originally mtk-sysirq hardcoded supported irq number to 224. This
> >> was fine since all SoCs before support the same number of irqs for
> >> intpol.
> >>
> >> However MT8173 intpol support 32 more irq pins, changes to get
> >> irq number from register resource size to suppor MT8173 properly.
> >>
> >> Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
> >> Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
> >> ---
> >>  drivers/irqchip/irq-mtk-sysirq.c | 18 +++++++++++-------
> >>  1 file changed, 11 insertions(+), 7 deletions(-)
> >>
> >
> > Jason, Thomas, will you take this patch through your branch?
> > I will take the rest of the series.
> >
> > Best regards,
> > Matthias
> >
> > --
> > motzblog.wordpress.com
> 
> Hi Thomas, hi Jason,
> 
> do you have any comments on this patch?

Jason is swamped. I'm currently collecting stuff.

Thanks,

	tglx
