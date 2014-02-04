Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaBDSdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:33:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:59486 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbaBDSdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:33:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,781,1384329600"; 
   d="scan'208";a="475935941"
From: "Luck, Tony" <tony.luck@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 00/17] x86, ia64 NUMA cleanup
Thread-Topic: [PATCH 00/17] x86, ia64 NUMA cleanup
Thread-Index: AQHPIRWTjJg2qrtgg0K7AMHpcFn9R5qlbDCg
Date: Tue, 4 Feb 2014 18:32:23 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31DC030A@ORSMSX106.amr.corp.intel.com>
References: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <CAErSpo5whsUH0aM8iocKdn4FOQLEjCQoM+ShjVjzWDxSWTzQnA@mail.gmail.com>
In-Reply-To: <CAErSpo5whsUH0aM8iocKdn4FOQLEjCQoM+ShjVjzWDxSWTzQnA@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s14IXIht021017

> I added this series to my "next" branch for v3.14.  Tony, let me know
> if you see any ia64 issues.

It showed up in next-20140204 - and doesn't seem to have caused any build or boot
problems on my test machines.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
