Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaAIBf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 20:35:59 -0500
Received: from mailout.micron.com ([137.201.242.129]:50747 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaAIBf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 20:35:57 -0500
From: =?utf-8?B?UWkgV2FuZyDnjovotbcgKHFpd2FuZyk=?= <qiwang@micron.com>
To: "dedekind1@gmail.com" <dedekind1@gmail.com>
CC: Adrian Hunter <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        =?utf-8?B?UWkgV2FuZyDnjovotbcgKHFpd2FuZyk=?= <qiwang@micron.com>
Subject: RE: [PATCH 1/1]  MTD: UBI:  avoid program operation on  NOR flash
 after erasure interrupted
Thread-Topic: [PATCH 1/1]  MTD: UBI:  avoid program operation on  NOR flash
 after erasure interrupted
Thread-Index: AQHPBvI9R7Ql4kYjCUG7syxWj0KNGppxBa8AgAADUQCAAT0XoP//tW6AgAUSXCCABJnCkA==
Date: Thu, 9 Jan 2014 01:35:24 +0000
Message-ID: <71CF8D7F32C5C24C9CD1D0E02D52498A770C7770@NTXXIAMBX02.xacn.micron.com>
References: <71CF8D7F32C5C24C9CD1D0E02D52498A770B54B1@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B68A8@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B6F77@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B79C8@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B8611@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770BA389@NTXXIAMBX02.xacn.micron.com>
	 <1388675460.25123.90.camel@sauron.fi.intel.com>
	 <1388676172.25123.93.camel@sauron.fi.intel.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770BA889@NTXXIAMBX02.xacn.micron.com>
 <1388728253.25123.98.camel@sauron.fi.intel.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20418.003
X-TM-AS-Result: No-1.210900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s091a9rq030920

Hi Artem:
Do you have any suggestion for my modification?
Other code I think it is ok.
Thanks


-----Original Message-----
From: Qi Wang ç‹èµ· (qiwang) 
Sent: Monday, January 06, 2014 1:11 PM
To: 'dedekind1@gmail.com'
Cc: Adrian Hunter; linux-kernel@vger.kernel.org; linux-mtd@lists.infradead.org
Subject: RE: [PATCH 1/1] MTD: UBI: avoid program operation on NOR flash after erasure interrupted

>Please, remember that I pushed your patch to a temporary branch, only
>for you to be able to easily pick it. I do not send it upstream.

>As I said, I need to you look at it and confirm that it is all-right.
>And if it is not all-right, correct it.

>This is because I modified it myself.

>So waiting for your response on this.
I checked the code you modified, compile, and run on our platform, it is ok.

+	ubi_err("cannot invalidate PEB %d, write returned %d write returned %d",
+		pnum, err, err); 

But I think above code print "write err" twice. so I suggest to change to below:

+	ubi_err("cannot invalidate PEB %d, write returned %d", pnum, err);
 
I will send you the patch in another email convenient for you to apply patch.
Thanks
--
qiwang 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
