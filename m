Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbbA0XwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:52:19 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:34647 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbbA0XwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:52:17 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1501261633450.5526@nanos>
References: <1421054073-43468-1-git-send-email-eddie.huang@mediatek.com>
	<CABuKBeKjGL6puqhqCb6b4=5Qb9+hcm-sGQ7vLxyb2jAFaLYGUQ@mail.gmail.com>
	<alpine.DEB.2.11.1501261633450.5526@nanos>
Date: Wed, 28 Jan 2015 00:52:15 +0100
Message-ID: <CABuKBeKWr_Jp6sdqEfq0oxAEob7VQN0B2icK2GSOH2=AtpqFCQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Add basic support for Mediatek MT8173 SoC
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Eddie Huang <eddie.huang@mediatek.com>, Rob Herring <robh+dt@kernel.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

2015-01-26 16:34 GMT+01:00 Thomas Gleixner <tglx@linutronix.de>:
> On Mon, 26 Jan 2015, Matthias Brugger wrote:
>> Applied to v3.20-next/arm64.
>> >
>> > Yingjoe Chen (1):
>> >   irqchip: mtk-sysirq: Get irq number from register resource size
>
> I just queued that irqchip patch in irq/core ....

What I wanted to express is, that I applied the rest of the series,
but not this patch, as it goes through your tree.
Sorry for the confusion.

-- 
motzblog.wordpress.com
