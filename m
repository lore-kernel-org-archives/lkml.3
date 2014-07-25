Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004AbaGYCaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 22:30:25 -0400
Received: from mailout.micron.com ([137.201.242.129]:51312 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965AbaGYCaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 22:30:23 -0400
From: bpqw <bpqw@micron.com>
To: Brian Norris <computersforpeace@gmail.com>, "Gupta, Pekon" <pekon@ti.com>
CC: bpqw <bpqw@micron.com>, "ron@debian.org" <ron@debian.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "b32955@freescale.com" <b32955@freescale.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: RE: Subject: [PATCH 1/1] mtd:nand:fix nand_lock/unlock() function
Thread-Topic: Subject: [PATCH 1/1] mtd:nand:fix nand_lock/unlock() function
Thread-Index: AQHPp2FUa4BrzNsr/E6cigFt5V7bQ5uwD3nA
Date: Fri, 25 Jul 2014 02:29:18 +0000
Message-ID: <CB9F11E856CFD04BB18EC1C68F2598931B11F2@NTXXIAMBX01.xacn.micron.com>
References: <CB9F11E856CFD04BB18EC1C68F2598931B1112@NTXXIAMBX01.xacn.micron.com>
 <20140724012730.GA3711@ld-irv-0074>
 <20980858CB6D3A4BAE95CA194937D5E73EB068AB@DBDE04.ent.ti.com>
 <20140724165633.GF3711@ld-irv-0074>
In-Reply-To: <20140724165633.GF3711@ld-irv-0074>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20838.003
X-TM-AS-Result: No--3.505600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>OK, I won't drop them yet.

>As you note, there's no user-space support. There's actually no one using them even in the kernel, which is why I considered dropping them.
>If you want to use them, find a proper way to use them then! (I'm not
>sure: do they match with mtd_lock() / ioctl(MEMLOCK) interface?)

How about my patch, Do you think there is any other need to change?

White
