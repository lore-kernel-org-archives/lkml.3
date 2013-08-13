Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020Ab3HMSFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:05:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:24393 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757259Ab3HMSFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:05:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,871,1367996400"; 
   d="scan'208";a="362112671"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
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
Thread-Index: AQHOlGVcQB6qi1wV3Ei8qYoYEneewpmMKjwAgAMKHwCAArfagIAAEviAgAADVICAAXiUgIAAFsAAgABQygCAAAdFgP//i8Nw
Date: Tue, 13 Aug 2013 18:05:02 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31CB8F53@ORSMSX106.amr.corp.intel.com>
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <20130808163822.67e0828a@samsung.com> <20130810180322.GC4155@pd.tnic>
 <20130812083355.47c1bae8@samsung.com> <5208D80D.5030206@linux.vnet.ibm.com>
 <20130812125343.GE18018@pd.tnic> <520A16BD.30201@linux.vnet.ibm.com>
 <20130813124258.GC4077@pd.tnic> <520A6D98.9060204@linux.vnet.ibm.com>
 <20130813175809.GE4077@pd.tnic>
In-Reply-To: <20130813175809.GE4077@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7DI5FdQ001160

> Why would you need dmesg if you get your hw errors over the tracepoint?

Redundancy is a good thing when talking about mission critical systems.  dmesg
may be feeding to a serial console to be logged and analysed on another system.

The tracepoint data goes to a process on the system experiencing the errors. If the
errors are serious (or a precursor to something serious) that process may never get
the chance to save the log.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
