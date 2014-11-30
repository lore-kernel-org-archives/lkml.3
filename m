Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaK3QL4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 11:11:56 -0500
Received: from mailout.micron.com ([137.201.242.129]:44163 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbaK3QLz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 11:11:55 -0500
From: =?iso-2022-jp?B?QmVhbiBIdW8gGyRCcDlJTElMGyhCIChiZWFuaHVvKQ==?= 
	<beanhuo@micron.com>
To: Brian Norris <computersforpeace@gmail.com>
CC: Marek Vasut <marex@denx.de>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [V5 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
Thread-Topic: [V5 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
Thread-Index: AQHP+W8IEF9rxWxnKkG/zeWVIWCG6Zxz/eYA///KamCAAP9ZAIAEsfZg
Date: Sun, 30 Nov 2014 16:11:06 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315EE639@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315DCC46@NTXXIAMBX02.xacn.micron.com>
 <201409251211.57183.marex@denx.de>
 <A765B125120D1346A63912DDE6D8B6315DCDF1@NTXXIAMBX02.xacn.micron.com>
 <201409261046.07132.marex@denx.de>
 <A765B125120D1346A63912DDE6D8B6315EA24E@NTXXIAMBX02.xacn.micron.com>
 <20141126211240.GD21347@ld-irv-0074>
 <A765B125120D1346A63912DDE6D8B6315EE059@NTXXIAMBX02.xacn.micron.com>
 <20141127091448.GU3212@norris-Latitude-E6410>
In-Reply-To: <20141127091448.GU3212@norris-Latitude-E6410>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-21140.007
X-TM-AS-Result: No--9.506200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>Also, which SPI NOR is this enabled for? I don't see any Micron entries in spi_nor_ids[] which contain the SPI_NOR_QUAD_READ flag.
>> 
>> Yes, we now don't see any Micron entries in spi_nor_ids[] which 
>> contain the SPI_NOR_QUAD_READ flag. But Micron spi nor in 
>> spi_nor_ids[] all support Quad I/O mode.

>Then add them! At least, for flash that support them (for all packages that might share the same ID).

Ok,I will add them for our Micron spi nor.

>> This patch is just for wanting to enable Micron Quad I/O mode.

>That's fine. But I'd welcome any follow-up patch to add the QUAD flag to the right Micron table entries. Otherwise, this patch doesn't actually help anyone.

>BTW, given that you aren't changing any entries to spi_nor_ids[] yet, have you actually tested this patch? Or are you only working off the specifications / datasheets?

Yes, I have tested my patch based on latest linux kernel ,the spi nor  are just our Micron spi nor,
such as 45nm MT25QL256Mb and Mt25TL245Mb.Before submitting a patch, our team will review and test it.
only past testing and confirm OK,this patch can be submitted. 

>Thanks,
>Brian

Hi, Brian

Thanks again for your warming response. I rebase a new version patch based on latest l2-mtd.
Besides, we will submit patch by our personal email.

