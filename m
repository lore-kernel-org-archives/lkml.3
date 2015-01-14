Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbbANCdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 21:33:07 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:55264 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751388AbbANCdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 21:33:05 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v4 1/5] ARM: mediatek: Add config options for mediatek
 SoCs.
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: Hongzhou Yang <hongzhou.yang@mediatek.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <linux@arm.linux.org.uk>, <srv_heupstream@mediatek.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <alan.cheng@mediatek.com>, <maoguang.meng@mediatek.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, <toby.liu@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, <dandan.he@mediatek.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <CACRpkda2pHpjMAsEeuEebShQnbqf5knfNbEGtSHLN=o18HC5nQ@mail.gmail.com>
References: <1418772873-19747-1-git-send-email-hongzhou.yang@mediatek.com>
	 <1418772873-19747-2-git-send-email-hongzhou.yang@mediatek.com>
	 <CACRpkda2pHpjMAsEeuEebShQnbqf5knfNbEGtSHLN=o18HC5nQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Jan 2015 10:33:01 +0800
Message-ID: <1421202781.27675.149.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-13 at 10:43 +0100, Linus Walleij wrote:
> On Wed, Dec 17, 2014 at 12:34 AM, Hongzhou Yang
> <hongzhou.yang@mediatek.com> wrote:
> 
> > From: Yingjoe Chen <yingjoe.chen@mediatek.com>
> >
> > The upcoming MTK pinctrl driver have a big pin table for each SoC
> > and we don't want to bloat the kernel binary if we don't need it.
> > Add config options so we can build for one SoC only.
> >
> > Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
> > Signed-off-by: Hongzhou Yang <hongzhou.yang@mediatek.com>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> I guess this goes directly to the ARM SoC tree. As it is only
> Kconfig symbols it should be OK to merge out-of-order.
> 

Hi Matthias,

Since this one is in arch/arm/mach-mediatek, can you take it?

Links for original post in case you can't find it.
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/311181.html

Joe.C



