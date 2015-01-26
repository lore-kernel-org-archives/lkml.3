Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbbAZPfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:35:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:47770 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbbAZPfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:35:17 -0500
Date: Mon, 26 Jan 2015 16:34:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthias Brugger <matthias.bgg@gmail.com>
cc: Eddie Huang <eddie.huang@mediatek.com>, Rob Herring <robh+dt@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
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
        Yu-hau Chen <yh.chen@mediatek.com>
Subject: Re: [PATCH v4 0/4] Add basic support for Mediatek MT8173 SoC
In-Reply-To: <CABuKBeKjGL6puqhqCb6b4=5Qb9+hcm-sGQ7vLxyb2jAFaLYGUQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1501261633450.5526@nanos>
References: <1421054073-43468-1-git-send-email-eddie.huang@mediatek.com> <CABuKBeKjGL6puqhqCb6b4=5Qb9+hcm-sGQ7vLxyb2jAFaLYGUQ@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015, Matthias Brugger wrote:
> Applied to v3.20-next/arm64.
> >
> > Yingjoe Chen (1):
> >   irqchip: mtk-sysirq: Get irq number from register resource size

I just queued that irqchip patch in irq/core ....
