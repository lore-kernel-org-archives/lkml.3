Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120AbaGWLkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:40:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38060 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883AbaGWLkN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:40:13 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Brian Norris <computersforpeace@gmail.com>, Bean Huo <beanhuo@outlook.com>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "christian.riesch@omicron.at" <christian.riesch@omicron.at>,
        Huang Shijie <b32955@freescale.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: RE: [PATCH v6] mtd:nor:timeout:fix do_write_buffer() timeout error
Thread-Topic: [PATCH v6] mtd:nor:timeout:fix do_write_buffer() timeout error
Thread-Index: AQHPoRAYwudgCzYyPUygtO/zHQcG4ZuiomuAgAByhoCAAAZ2AIAKdq+A
Date: Wed, 23 Jul 2014 11:39:24 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EB06218@DBDE04.ent.ti.com>
References: <BLU436-SMTP223B6F83933407357F0FF3BA6F70@phx.gbl>
 <20140716180423.GV7537@ld-irv-0074>
 <BLU185-W53748517956B27745D7033A6F40@phx.gbl>
 <20140717011724.GW7537@ld-irv-0074>
In-Reply-To: <20140717011724.GW7537@ld-irv-0074>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Brian Norris
>>On Thu, Jul 17, 2014 at 12:54:17AM +0000, Bean Huo wrote:
>> > I have just fixed up your patch myself, to use max() and to improve some
>> > of the language. Let me know if the below works for you.
>>
>> hi,Brian
>>  Thanks once again.I test and it works Ok.It can be accepted now?
>
>Yes. Pushed to l2-mtd.git.
>
This works well with Spansion NOR device (S29GL512S10) present on
J6-EVM, using http://patchwork.ozlabs.org/patch/372866/.

Though it's already accepted in l2-mtd.git, but just for record.
Tested-by: Pekon Gupta <pekon@ti.com>


with regards, pekon
