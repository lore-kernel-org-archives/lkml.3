Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3LFB0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 20:26:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:6744 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab3LFB0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 20:26:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,837,1378882800"; 
   d="scan'208";a="439449891"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] SFI: fix compilation warnings
Thread-Topic: [PATCH] SFI: fix compilation warnings
Thread-Index: AQHO8d8+yYF2tylyh0GJxpNBoquqVZpFqw+AgACvotD//3+RgIAAhdgw
Date: Fri, 6 Dec 2013 01:26:07 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E8802494B65@SHSMSX101.ccr.corp.intel.com>
References: <1386264397-27319-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <4771886.zcelg2hCiB@vostro.rjw.lan>
 <1AE640813FDE7649BE1B193DEA596E8802494B32@SHSMSX101.ccr.corp.intel.com>
 <1419818.3DzaCCe02K@vostro.rjw.lan>
In-Reply-To: <1419818.3DzaCCe02K@vostro.rjw.lan>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB61QKVs013879

> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Friday, December 06, 2013 9:26 AM
> 
> On Friday, December 06, 2013 01:08:45 AM Zheng, Lv wrote:
> > > From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> > > Sent: Friday, December 06, 2013 6:37 AM
> > >
> > > On Thursday, December 05, 2013 07:26:37 PM Andy Shevchenko wrote:
> > > > When build kernel with make W=1 we get the following compiler error.
> > > >
> > > > In file included from drivers/sfi/sfi_acpi.c:66:0:
> > > > include/linux/sfi_acpi.h: In function â€˜acpi_sfi_table_parseâ€™:
> > > > include/linux/sfi_acpi.h:72:2: error: implicit declaration of function â€˜acpi_table_parseâ€™ [-Werror=implicit-function-declaration]
> > > >   if (!acpi_table_parse(signature, handler))
> > > >   ^
> > > >   cc1: some warnings being treated as errors
> > > >
> > > > The patch changes acpi/acpi.h inclusion to linux/acpi.h.
> > > >
> > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > >
> > > OK
> > >
> > > Lv, I'm dropping your patch cleaning up the inclusions, please sort that thing
> > > out entirely for the next cycle.
> >
> > No, I think Andy's patch is wrong.
> 
> His patch may be wrong, but the warning in his changelog surely is real. :-)
> 
> > This warning is existing before merging my fixes.
> >
> > Either we fix this warning or leave it as is.
> >
> > To fix it, you need to add 1 line in sfi_acpi.h rather than change the line.
> > Let me post a fix for this.
> 
> Please do.  And I'm putting all ACPI header cleanups on hold until all warnings
> of this kind have been fixed by them.  Otherwise doing those cleanups makes a
> little sense in my opinion.

OK, not only this warning, there is another warning in sfi_acpi.c.
I doubt whether they are strictly tested before upstreamed...
They are all existing warnings.
You can apply my new patch before the cleanup series.

Thanks
-Lv

> 
> Thanks,
> Rafael

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
