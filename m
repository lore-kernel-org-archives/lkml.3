Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaKDFoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 00:44:30 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:37986 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751069AbaKDFo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 00:44:26 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v4 2/8] ARM: mediatek: add dts for 8127 Moose board
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
In-Reply-To: <CABuKBe+ku=vWiWbvAm8M7QgyzvVWZ5sdkRMocuUym8JTyk-okg@mail.gmail.com>
References: <1413973797-17619-1-git-send-email-yingjoe.chen@mediatek.com>
	 <1413973797-17619-3-git-send-email-yingjoe.chen@mediatek.com>
	 <CABuKBe+ku=vWiWbvAm8M7QgyzvVWZ5sdkRMocuUym8JTyk-okg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 4 Nov 2014 13:44:21 +0800
Message-ID: <1415079861.31861.0.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 18:55 +0100, Matthias Brugger wrote:
> 2014-10-22 12:29 GMT+02:00 Joe.C <yingjoe.chen@mediatek.com>:
> > From: "Joe.C" <yingjoe.chen@mediatek.com>
> >
> > Moose is a tablet evalutation board based on MT8127 SoC.
> >
> > Signed-off-by: Joe.C <yingjoe.chen@mediatek.com>
> > ---
> >  arch/arm/boot/dts/mt8127-moose.dts | 24 ++++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> >  create mode 100644 arch/arm/boot/dts/mt8127-moose.dts
> >
> > diff --git a/arch/arm/boot/dts/mt8127-moose.dts b/arch/arm/boot/dts/mt8127-moose.dts
> > new file mode 100644
> > index 0000000..602e2f0
> > --- /dev/null
> > +++ b/arch/arm/boot/dts/mt8127-moose.dts
> > @@ -0,0 +1,24 @@
> > +/*
> > + * Copyright (c) 2014 MediaTek Inc.
> > + * Author: Joe.C <yingjoe.chen@mediatek.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +/dts-v1/;
> > +#include "mt8127.dtsi"
> > +
> > +/ {
> > +       model = "mediatek,mt8127-moose", "mediatek,mt8127";
> 
> The model should be a string that identifies the board, e.g. "Moose".
> Please add the compatible property.

Thanks for catching this. I just note we have warning on this line.
Will fix in next version.

Joe.C

