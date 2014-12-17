Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619AbaLQEsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 23:48:03 -0500
Received: from mailout.micron.com ([137.201.242.129]:29726 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaLQEsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 23:48:01 -0500
From: =?utf-8?B?QmVhbiBIdW8g6ZyN5paM5paMIChiZWFuaHVvKQ==?= 
	<beanhuo@micron.com>
To: Brian Norris <computersforpeace@gmail.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>, Marek Vasut <marex@denx.de>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [V6 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
Thread-Topic: [V6 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
Thread-Index: AQHQGarhNKtT8tX93E+HXuSYhFD1EpyTMdog
Date: Wed, 17 Dec 2014 04:47:11 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315F1993@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315EF2C5@NTXXIAMBX02.xacn.micron.com>
 <20141217032952.GV9759@ld-irv-0074>
In-Reply-To: <20141217032952.GV9759@ld-irv-0074>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
x-tm-as-product-ver: SMEX-10.0.0.4152-7.000.1014-21180.004
x-tm-as-result: No--40.948800-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBH4mA0G009390

>> +	{ "n25q032",	 INFO(0x20ba16, 0, 64 * 1024,   64, SPI_NOR_QUAD_READ) },
>> +	{ "n25q064",     INFO(0x20ba17, 0, 64 * 1024,  128, SPI_NOR_QUAD_READ) },
>> +	{ "n25q128a11",  INFO(0x20bb18, 0, 64 * 1024,  256, SPI_NOR_QUAD_READ) },
>> +	{ "n25q128a13",  INFO(0x20ba18, 0, 64 * 1024,  256, SPI_NOR_QUAD_READ) },
>> +	{ "n25q256a",    INFO(0x20ba19, 0, 64 * 1024,  512, SECT_4K | SPI_NOR_QUAD_READ) },
>> +	{ "n25q512a",    INFO(0x20bb20, 0, 64 * 1024, 1024, SECT_4K | USE_FSR | SPI_NOR_QUAD_READ) },
>> +	{ "n25q512ax3",  INFO(0x20ba20, 0, 64 * 1024, 1024, SECT_4K | USE_FSR | SPI_NOR_QUAD_READ) },
>> +	{ "n25q00",      INFO(0x20ba21, 0, 64 * 1024, 2048, SECT_4K | USE_FSR | SPI_NOR_QUAD_READ) },

>Are you sure *all* of these support quad mode? I know some manufacturers
>have been known to reuse IDs, and I wouldn't want a false positive to slip
>in here, where an old part might not support it but the new one does...

Yes,I am sure that all Micron spi nor in above table support quad mode,they are
all N25Q serial spi nor.As for our Micron spi nor without quad mode, 
I don't add them in the above table,and they have different ID with above device.


>With int vs. u8 fixed up, this looks good. Hopefully I can take v7!

Thanks ,it's very nice of you.

>Thanks,
>Brian
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
