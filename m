Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab3BSKa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:30:27 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33824 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab3BSKaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:30:24 -0500
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
Subject: RE: [PATCH, RFC 4/8] ARM: am33xx: ll debug config help
Thread-Topic: [PATCH, RFC 4/8] ARM: am33xx: ll debug config help
Thread-Index: AQHODcx+kdLj0nOlYUe5tmShRfx+0JiAnziAgABc8FA=
Date: Tue, 19 Feb 2013 10:30:05 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EAA867A@DBDE01.ent.ti.com>
References: <cover.1361186097.git.afzal@ti.com>
 <bfe941adb98a5000c2817f9fd6160070e59e53c9.1361186097.git.afzal@ti.com>
 <51235337.60209@ti.com>
In-Reply-To: <51235337.60209@ti.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1JAUS9x028848

Hi Santosh,

On Tue, Feb 19, 2013 at 15:55:59, Shilimkar, Santosh wrote:

> With DT, IIRC DEBUGLL is broken. So did you hack debug-macro.S
> to get the earlyprintk working ?

No, on linux-next, ll debug works properly.

Regards
Afzal 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
