Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbaJAOZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:25:30 -0400
Received: from mailout.micron.com ([137.201.242.129]:37222 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaJAOZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:25:28 -0400
From: =?utf-8?B?QmVhbiBIdW8g6ZyN5paM5paMIChiZWFuaHVvKQ==?= 
	<beanhuo@micron.com>
To: Marek Vasut <marex@denx.de>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1 v3] driver:mtd:spi-nor: Add Micron quad I/O support
Thread-Topic: [PATCH 1/1 v3] driver:mtd:spi-nor: Add Micron quad I/O support
Thread-Index: AQHP3LUw1IjYD2GBJkeXO7FbBzOymJwbScBQ
Date: Wed, 1 Oct 2014 14:24:41 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315E3D3F@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315DCC46@NTXXIAMBX02.xacn.micron.com>
 <201409261046.07132.marex@denx.de>
 <A765B125120D1346A63912DDE6D8B6315E3C79@NTXXIAMBX02.xacn.micron.com>
 <201409301538.40466.marex@denx.de>
In-Reply-To: <201409301538.40466.marex@denx.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
x-tm-as-product-ver: SMEX-10.0.0.4152-7.000.1014-20988.004
x-tm-as-result: No--34.313800-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s91EPYr6031033

>> For Micron spi norflash,enables or disables quad I/O protocol ,which 
>> controled by EVCR(Enhanced Volatile Configuration Register) Quad I/O 
>> protocol bit 7.When EVCR bit 7 is reset to 0, the spi norflash will 
>> operate in quad I/O following the next WRITE ENHANCED VOLATILE 
>> CONFIGURATION command.

>You only do one WRITE ENHANCED VOLATILE CONFIGURATION command in the patch, so this text doesn't add up.

>Try something like this:
>-->8--
>This patch adds code which enables Quad I/O mode on Micron SPI NOR flashes.

>For Micron SPI NOR flash, enabling or disabling quad I/O protocol is controled by EVCR (Enhanced Volatile Configuration Register), Quad I/O protocol bit 7. When EVCR bit 7 is reset to 0, the SPI NOR flash will operate in quad I/O mode.
>--8<--

>What do you think ?
Perfect,I will modify my commit message and sumbit it again.thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
