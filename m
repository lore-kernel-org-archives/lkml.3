Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab3BSJKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 04:10:53 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39968 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758150Ab3BSJKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 04:10:50 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: "Balbi, Felipe" <balbi@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, "Nori, Sekhar" <nsekhar@ti.com>,
        "Syed Mohammed, Khasim" <khasim@ti.com>
Subject: RE: [PATCH, RFC 7/8] ARM: dts: am4372: initial support
Thread-Topic: [PATCH, RFC 7/8] ARM: dts: am4372: initial support
Thread-Index: AQHODcyhekrN7w0cOUWaNV2FPnrjXZh/khIAgAFQ+EA=
Date: Tue, 19 Feb 2013 09:10:17 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EAA85B2@DBDE01.ent.ti.com>
References: <cover.1361186097.git.afzal@ti.com>
 <c9c131c0508b875c0893e8557504372a1564568a.1361186097.git.afzal@ti.com>
 <20130218182240.GA10755@arwen.pp.htv.fi>
In-Reply-To: <20130218182240.GA10755@arwen.pp.htv.fi>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1J9Asrs028483

Hi Felipe,

On Mon, Feb 18, 2013 at 23:52:40, Balbi, Felipe wrote:
> On Mon, Feb 18, 2013 at 05:08:16PM +0530, Afzal Mohammed wrote:

> > +		uart1: serial@44e09000 {
> > +			compatible = "ti,am4372-uart","ti,omap2-uart";
> > +			clock-frequency = <48000000>;
> > +			reg = <0x44e09000 0x2000>;
> > +			interrupts = <0 72 0x4>;
> 
> missing ti,hwmods ??

It is a deliberate omission. For minimal bootconsole booting, hwmod
help is not required. Hwmod details would be added gradually later,
current series doesn't register hwmod.

Regards
Afzal

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
