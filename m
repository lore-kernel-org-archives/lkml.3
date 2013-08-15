Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab3HOTOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 15:14:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:28649 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab3HOTOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 15:14:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,887,1367996400"; 
   d="scan'208";a="363251193"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "lance.ortiz@hp.com" <lance.ortiz@hp.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Thread-Topic: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Thread-Index: AQHOlGVcQB6qi1wV3Ei8qYoYEneewpmMKjwAgAMKHwCAArfagIAAEviAgAADVICAAXiUgIAAFsAAgABQygCAAAdFgP//i8NwgAB3kgD//6n/UIABF7UAgABZNMCAAYTkAIAAIHwg
Date: Thu, 15 Aug 2013 19:14:34 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31CBD158@ORSMSX106.amr.corp.intel.com>
References: <20130812125343.GE18018@pd.tnic>
 <520A16BD.30201@linux.vnet.ibm.com> <20130813124258.GC4077@pd.tnic>
 <520A6D98.9060204@linux.vnet.ibm.com> <20130813175809.GE4077@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31CB8F53@ORSMSX106.amr.corp.intel.com>
 <20130813181004.GF4077@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31CB9150@ORSMSX106.amr.corp.intel.com>
 <20130814054322.GA9158@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31CBAAFA@ORSMSX106.amr.corp.intel.com>
 <20130815101432.GE27616@pd.tnic>
In-Reply-To: <20130815101432.GE27616@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7FJF2Yf017811

> Well, if I have serial connected to the box, it will contain basically
> everything the machine said, no?

Yes - but the serial port is too slow to log everything that you might
conceivably need to debug your problem.  Imagine trying to log every
interrupt and every pagefault on every processor down a single 115200
baud connection.  Thus my earlier comments about guessing what to
log.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
