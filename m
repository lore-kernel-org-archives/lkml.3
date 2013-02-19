Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438Ab3BSKxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:53:23 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55894 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab3BSKxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:53:21 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, "Nori, Sekhar" <nsekhar@ti.com>,
        "Syed Mohammed, Khasim" <khasim@ti.com>
Subject: RE: [PATCH, RFC 8/8] ARM: dts: am43-pre-silicon support
Thread-Topic: [PATCH, RFC 8/8] ARM: dts: am43-pre-silicon support
Thread-Index: AQHODcygtuLZa7sL9USp61P5AKr//JiAodcAgABfFQA=
Date: Tue, 19 Feb 2013 10:52:44 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EAA86DE@DBDE01.ent.ti.com>
References: <cover.1361186097.git.afzal@ti.com>
 <e344f74da47579c11db68d9f6efe25259ed7f25d.1361186097.git.afzal@ti.com>
 <5123556A.9050109@ti.com>
In-Reply-To: <5123556A.9050109@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1JArO6M028996

Hi Santosh,

On Tue, Feb 19, 2013 at 16:05:22, Shilimkar, Santosh wrote:
> On Monday 18 February 2013 05:08 PM, Afzal Mohammed wrote:

> > AM43 SoC is in pre-silicon stage, meanwhile it has been modelled in
> > a pre-silicon platform. To validate and boot Linux in pre-silicon
> > platform that emulates an AM43 SoC, add DT build support.

> > Note: This would be replaced by an original board support.

> > -	am335x-bone.dtb
> > +	am335x-bone.dtb \
> > +	am43-pre-silicon.dtb

> Well the pre-silicon platform and the SOC are very
> close and at least the support you are adding here is
> exactly same. So lets just use am437x.dtb or something
> like that.

SoC support is already added in patch 7/8. This is board (which doesn't
exist now) support, hence a pre-silicon temporary one to validate it.

Regards
Afzal

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
