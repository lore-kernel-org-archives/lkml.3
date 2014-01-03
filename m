Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaACCbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 21:31:41 -0500
Received: from mailout.micron.com ([137.201.242.129]:29519 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbaACCbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 21:31:40 -0500
From: =?utf-8?B?UWkgV2FuZyDnjovotbcgKHFpd2FuZyk=?= <qiwang@micron.com>
To: "dedekind1@gmail.com" <dedekind1@gmail.com>
CC: Adrian Hunter <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: RE: [PATCH 1/1]  MTD: UBI:  avoid program operation on  NOR flash
 after erasure interrupted
Thread-Topic: [PATCH 1/1]  MTD: UBI:  avoid program operation on  NOR flash
 after erasure interrupted
Thread-Index: AQHPBvI9R7Ql4kYjCUG7syxWj0KNGppxBa8AgAADUQCAAT0XoA==
Date: Fri, 3 Jan 2014 02:31:12 +0000
Message-ID: <71CF8D7F32C5C24C9CD1D0E02D52498A770BA889@NTXXIAMBX02.xacn.micron.com>
References: <71CF8D7F32C5C24C9CD1D0E02D52498A770B54B1@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B68A8@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B6F77@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B79C8@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B8611@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770BA389@NTXXIAMBX02.xacn.micron.com>
	 <1388675460.25123.90.camel@sauron.fi.intel.com>
 <1388676172.25123.93.camel@sauron.fi.intel.com>
In-Reply-To: <1388676172.25123.93.camel@sauron.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20402.003
X-TM-AS-Result: No--20.695800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s032ViEr020665

OK, thank you Artem.

I will change to git send-mail next time. And I will be very careful to push patch to you next time.
Sorry to bring so much trouble to you as I am first time to push patch to Linux main trunk.(Maybe it also is Micron Technology company first time to push patch to Linux main trunk, I am being Micron China Shanghai team volunteer to contact Linux committee to push patch). 
Anyway, Thanks for your patience to give me a good starting. 
And if you have anything need my or my team help, Please kindly let me know. Our team is glad to contribute to Linux community.
Wish you have a wonderful 2014.
Thank you


-----Original Message-----
From: Artem Bityutskiy [mailto:dedekind1@gmail.com] 
Sent: Thursday, January 02, 2014 11:23 PM
To: Qi Wang ç‹èµ· (qiwang)
Cc: Adrian Hunter; linux-kernel@vger.kernel.org; linux-mtd@lists.infradead.org
Subject: Re: [PATCH 1/1] MTD: UBI: avoid program operation on NOR flash after erasure interrupted

On Thu, 2014-01-02 at 17:11 +0200, Artem Bityutskiy wrote:
> Anyway, I did not respond for long time, so I decided to do all these
> modifications myself. Could you please review and test the below patch,
> which is also attached. I did not compile it even. If there are issues,
> just fix-it up and send the the fix or the fixed version. If it is OK,
> give me your "Tested-by:" please. Thanks!

Actually, for convenience, I've pushed this patch to the 'qi' branch of
the 'linux-ubifs' git tree:

git://git.infradead.org/ubifs-2.6.git

-- 
Best Regards,
Artem Bityutskiy

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
