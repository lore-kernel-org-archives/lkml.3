Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab3BSLEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 06:04:09 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56464 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339Ab3BSLEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 06:04:07 -0500
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
Thread-Index: AQHODcygtuLZa7sL9USp61P5AKr//JiAodcAgABfFQD//6fcgIAAXD9Q
Date: Tue, 19 Feb 2013 11:03:28 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EAA8731@DBDE01.ent.ti.com>
References: <cover.1361186097.git.afzal@ti.com>
 <e344f74da47579c11db68d9f6efe25259ed7f25d.1361186097.git.afzal@ti.com>
 <5123556A.9050109@ti.com>
 <C8443D0743D26F4388EA172BF4E2A7A93EAA86DE@DBDE01.ent.ti.com>
 <51235B3D.5000907@ti.com>
In-Reply-To: <51235B3D.5000907@ti.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1JB4BAA029097

Hi Santosh,

On Tue, Feb 19, 2013 at 16:30:13, Shilimkar, Santosh wrote:
> On Tuesday 19 February 2013 04:22 PM, Mohammed, Afzal wrote:

> > SoC support is already added in patch 7/8. This is board (which doesn't
> > exist now) support, hence a pre-silicon temporary one to validate it.
> >
> I mean we can call it am437x-xyxboard.dtb already considering the data
> here can be re-used. Boot-args can be used from default kernel config
> with CONFIG_CMDLINE_FORCE.
> 
> No strong opinion if you still insist to have a pre-silicon dtb.

This patch would be replaced by original board, once it is known.
This was included to make a working complete series and if someone
wants (internally) to test the series as is.

Regards
Afzal

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
