Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab3ETEpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 00:45:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59701 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab3ETEp2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 00:45:28 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Philip, Avinash" <avinashphilip@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "zonque@gmail.com" <zonque@gmail.com>,
        "jacmet@sunsite.dk" <jacmet@sunsite.dk>,
        "Nori, Sekhar" <nsekhar@ti.com>
Subject: RE: [v2, 3/3] ARM: dts: AM33XX: Add NAND flash device tree data to
 am335x-evm
Thread-Topic: [v2, 3/3] ARM: dts: AM33XX: Add NAND flash device tree data to
 am335x-evm
Thread-Index: AQHORK8kYV+CfdNudU6r5StSMMOqvpjtsT8AgA3N7ACAAM1UcIARUSiw
Date: Mon, 20 May 2013 04:44:31 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73E9C5629@DBDE04.ent.ti.com>
References: <ebfab3e9123b3e50b9a9678c1480191addd86d59.1359007746.git.avinashphilip@ti.com>
 <517F5126.5000509@ti.com> <20130508235404.GX32546@atomide.com>
 <20980858CB6D3A4BAE95CA194937D5E73E9C320D@DBDE04.ent.ti.com>
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73E9C320D@DBDE04.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > > >
> > > >  	am33xx_pinmux: pinmux@44e10800 {
> > > >  		pinctrl-names = "default";
> > > > -		pinctrl-0 = <&matrix_keypad_s0 &volume_keys_s0>;
> > > > +		pinctrl-0 = <&matrix_keypad_s0 &volume_keys_s0
> > > > +			&nandflash_pins_s0>;
> > >
> > > Why add this to the board level fallback (called pinctrl hogs, I think)?
> > > This can be part of nand node you added below so that the pinctrl will
> > > take effect when nand gets probed instead of all the time.
> >
> > Yes we should have all the pinctrl entries under the related drivers.
> > This makes it easy remux pins during runtime if needed, and also
> > allows unloading pinctrl-single.ko for development.
> >
> Yes, accepted. This has been already fixed in v3 of this patch set.
> If all fine, then please pull this for next merge..
> 
> http://lists.infradead.org/pipermail/linux-mtd/2013-May/046712.html
> 
> http://lists.infradead.org/pipermail/linux-mtd/2013-May/046814.html
> 
> http://lists.infradead.org/pipermail/linux-mtd/2013-May/046710.html
> 
> 
> with regards, pekon

Request you to please accept | provide feedbacks on this patch series.
These are waiting acceptance since Jan-2013, and are necessary for 
DT based configs for board having NAND support.

with regards, pekon
