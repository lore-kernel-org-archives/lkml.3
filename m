Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaJVOTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:19:41 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:41345 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751511AbaJVOTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:19:39 -0400
X-Listener-Flag: 11101
Subject: Re: [PATCH v4 8/8] ARM: mediatek: Add config option for mediatek
 SoCs.
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, <arm@kernel.org>,
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
In-Reply-To: <CABuKBeLJuaDnCYuvvS6csNzvbTeEdgEUdZ4tBQeVPuw37JK11Q@mail.gmail.com>
References: <1413973797-17619-1-git-send-email-yingjoe.chen@mediatek.com>
	 <1413973797-17619-9-git-send-email-yingjoe.chen@mediatek.com>
	 <CABuKBe+Ew6R2Kb90-gDHBQ4HuydfFxJdYmr+v9-KNC-b0K4Tkw@mail.gmail.com>
	 <1413984696.19686.72.camel@mtksdaap41>
	 <CABuKBeLJuaDnCYuvvS6csNzvbTeEdgEUdZ4tBQeVPuw37JK11Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Oct 2014 22:19:33 +0800
Message-ID: <1413987573.19686.138.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-22 at 15:53 +0200, Matthias Brugger wrote:
> Hi Joe,
> 
> 2014-10-22 15:31 GMT+02:00 Yingjoe Chen <yingjoe.chen@mediatek.com>:
> >
> > Hi Matthias,
> >
> > On Wed, 2014-10-22 at 15:18 +0200, Matthias Brugger wrote:
> >> 2014-10-22 12:29 GMT+02:00 Joe.C <yingjoe.chen@mediatek.com>:
> >> > +
> >> > +if ARCH_MEDIATEK
> >> > +
> >> > +config MACH_MT6589
> >> > +       bool "MediaTek MT6589 SoCs support"
> >> > +       default ARCH_MEDIATEK
> >> > +
> >> > +config MACH_MT8127
> >> > +       bool "MediaTek MT8127 SoCs support"
> >> > +       default ARCH_MEDIATEK
> >> > +
> >> > +config MACH_MT8135
> >> > +       bool "MediaTek MT8135 SoCs support"
> >> > +       default ARCH_MEDIATEK
> >> > +
> >> > +endif
> >>
> >> MACH_MTxxxx are not used nowhere, please remove them.
> >
> > Yes, they are not used in this series yet.
> >
> > MACH_MT8135 was used in mt8135 pinctrl driver [1] and will be used in
> > mt8135 clk driver we are about to send. I don't want to create false
> > dependency between these 2 series so I put it here.
> > Do you prefer add them when they are first used?
> 
> Yes please add them, when they are first used.
> Today I had a look on the pinctrl patches you mentioned. It looks to
> me as if the config is not needed in the series.

OK, I'll remove these in next version.

Joe.C

> 
> Thanks,
> Matthias
> 
> [0] http://thread.gmane.org/gmane.linux.ports.arm.kernel/358505
> 
> >
> > Joe.C
> >
> > [1]
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2014-September/289288.html
> >
> >
> 
> 
> 


