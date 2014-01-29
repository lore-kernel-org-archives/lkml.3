Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaA2SDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:03:50 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54733 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbaA2SDs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:03:48 -0500
From: "Gupta, Pekon" <pekon@ti.com>
To: Rob Herring <robherring2@gmail.com>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>,
        "Ezequiel Garcia (ezequiel.garcia@free-electrons.com)" 
	<ezequiel.garcia@free-electrons.com>,
        Brian Norris <computersforpeace@gmail.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "dev@linux-sunxi.org" <dev@linux-sunxi.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC PATCH v2 09/14] mtd: nand: add sunxi NFC dt bindings doc
Thread-Topic: [RFC PATCH v2 09/14] mtd: nand: add sunxi NFC dt bindings doc
Thread-Index: AQHPHQDG7gDqSNJGr0CJa2YBBD67QpqbajQAgACR39A=
Date: Wed, 29 Jan 2014 18:02:33 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EA6C01D@DBDE04.ent.ti.com>
References: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
 <1391006064-28890-10-git-send-email-b.brezillon.dev@gmail.com>
 <CAL_JsqLVr1gSLArqtfOiHce+u6ZK8FiKMX0o9bvMrMoGGhATvg@mail.gmail.com>
In-Reply-To: <CAL_JsqLVr1gSLArqtfOiHce+u6ZK8FiKMX0o9bvMrMoGGhATvg@mail.gmail.com>
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

Dear Rob, and other DT maintainers,

>From: Rob Herring
[...]
>> +- onfi,nand-timing-mode : mandatory if the chip does not support the ONFI
>> +  standard.
>
>Add to generic nand binding.
>
>> +- allwinner,rb : shall contain the native Ready/Busy ids.
>> + or
>> +- rb-gpios : shall contain the gpios used as R/B pins.
>
>Isn't allwinner,rb implied by a lack of rb-gpios property. Or no R/B
>pin is an option? If so, don't you need some fixed time delay
>properties like max erase time?
>
>rb-gpios could be added to the generic nand binding as well.
>
I do think this should go into generic nand binding, as this is controller specific.
Some controllers have dedicated R/B pin (Ready/Busy) while others may use
GPIO instead. It's the way a hardware controller is designed.

Request you to please consider Ack from MTD Maintainers 'at-least' for
generic NAND DT bindings. There is already a discussion going in
a separate thread for which is still not awaiting replies [1].

[1] http://lists.infradead.org/pipermail/linux-mtd/2014-January/051625.html


with regards, pekon
