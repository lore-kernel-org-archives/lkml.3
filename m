Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934868AbaH0OEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:04:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:33359 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933802AbaH0OEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:04:33 -0400
Date: Wed, 27 Aug 2014 16:03:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Zyngier <marc.zyngier@arm.com>
cc: =?ISO-8859-15?Q?Jan_L=FCbbe?= <jlu@pengutronix.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "Joe.C" <srv_yingjoe.chen@mediatek.com>,
        "yh.chen@mediatek.com" <yh.chen@mediatek.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "nathan.chung@mediatek.com" <nathan.chung@mediatek.com>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        "yingjoe.chen@gmail.com" <yingjoe.chen@gmail.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        "hc.yen@mediatek.com" <hc.yen@mediatek.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [RESEND PATCH v2 1/4] irqchip: gic: Change irq type check when
 extension is present
In-Reply-To: <87ppfmoxxz.fsf@approximate.cambridge.arm.com>
Message-ID: <alpine.DEB.2.10.1408271556350.3323@nanos>
References: <1407895884-18131-1-git-send-email-srv_yingjoe.chen@mediatek.com> <1407895884-18131-2-git-send-email-srv_yingjoe.chen@mediatek.com> <53F724F5.3040004@arm.com> <1409133344.25382.37.camel@coredoba.hi.pengutronix.de> <53FDB4B3.6000400@arm.com>
 <alpine.DEB.2.10.1408271347210.3323@nanos> <87ppfmoxxz.fsf@approximate.cambridge.arm.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Marc Zyngier wrote:
> I very much like that kind of approach. Stacking domains seems to solve
> a number of issues at once:
> 
> - NVIDIA's gic extension
> - TI's crossbar
> - ARM's GICv2m
> - Mediatek's glorified line inverter
> - ... and probably the next madness that's going to land tomorrow

Its probably already there you just don't know about it yet :)
 
> I haven't completly groked the way we're going to allocate domains and
> irq_data structures, but this is definitely something worth

All we have for now is a rough idea and some pseudo code in my lengthy
reply to Jiang, but it shouldn't be hard to implement something
useful.

Thanks,

	tglx
