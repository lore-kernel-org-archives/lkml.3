Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab3ARD40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:56:26 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33191 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482Ab3ARD4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:56:24 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "zonque@gmail.com" <zonque@gmail.com>,
        "Mohammed, Afzal" <afzal@ti.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "ivan.djelic@parrot.com" <ivan.djelic@parrot.com>
Subject: RE: [PATCH v4 0/3] mtd: nand: OMAP: ELM error correction support
 for BCH ecc
Thread-Topic: [PATCH v4 0/3] mtd: nand: OMAP: ELM error correction support
 for BCH ecc
Thread-Index: AQHN6lD+BmDHyeS2akuomL8BE4yar5hL8bdQgAEzjICAAWMKsA==
Date: Fri, 18 Jan 2013 03:54:51 +0000
Deferred-Delivery: Fri, 18 Jan 2013 03:54:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA5F353@DBDE01.ent.ti.com>
References: <1357286211-5012-1-git-send-email-avinashphilip@ti.com>
	 <518397C60809E147AF5323E0420B992E3EA5DFA9@DBDE01.ent.ti.com>
 <1358424375.2731.234.camel@sauron.fi.intel.com>
In-Reply-To: <1358424375.2731.234.camel@sauron.fi.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0I3uPDg001819

On Thu, Jan 17, 2013 at 17:36:15, Artem Bityutskiy wrote:
> On Wed, 2013-01-16 at 12:22 +0000, Philip, Avinash wrote:
> > > This series is based on linux 3.8-rc2 and tested with [1].
> > > Also this patch series depend on [1] for NAND flash device
> > > tree data and gpmc nand device tree binding documentation updates.
> > > 
> > > 1. [PATCH v7 0/5] OMAP GPMC DT bindings
> > > http://www.spinics.net/lists/linux-omap/msg83505.html
> > > 
> > > Tested on am335x-evm for BCH 4 and 8 bit error correction.
> > 
> > Can you apply this patch series on l2-mtd tree as it will help RBL compatibility
> > ecc layout for NAND flash in am335x-platforms and hardware based BCH error
> > correction.
> 
> OK, I've applied them. I dropped the part that updates the
> documentation. Please, handle it separately when Daniel's patches are
> in.
> 
> Pushed to l2-mtd.git, thanks!

Thanks for applying this patch series.
I will update gpmc-nand documentation part in a separate patch.

Thanks,
Avinash

> 
> -- 
> Best Regards,
> Artem Bityutskiy
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
