Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457Ab3FTWLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 18:11:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:4857 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758431Ab3FTWLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 18:11:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,907,1363158000"; 
   d="scan'208";a="257969870"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
CC: Borislav Petkov <bp@alien8.de>, "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
        "lcm@linux.vnet.ibm.com" <lcm@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Robert Richter <rric@kernel.org>
Subject: RE: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
Thread-Topic: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
Thread-Index: AQHObRaMG8NLWdbwnkKYI9OOtTgcdZk9yhyA//+MXBCAAHyTAP//kUdQgACKGAD//4yfcAAQQVUAAA5rtIAAJF5OgAANAjzQ
Date: Thu, 20 Jun 2013 22:11:27 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F2DA8993C@ORSMSX106.amr.corp.intel.com>
References: <20130619175438.2852.93449.stgit@localhost.localdomain>
 <20130619175728.2852.73156.stgit@localhost.localdomain>
 <20130619180441.GK28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA88106@ORSMSX106.amr.corp.intel.com>
 <20130619183640.GL28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA881C2@ORSMSX106.amr.corp.intel.com>
 <20130619201438.GM28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA8838B@ORSMSX106.amr.corp.intel.com>
 <20130619210706.GP28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA884F0@ORSMSX106.amr.corp.intel.com>
 <51C37251.4000008@linux.vnet.ibm.com>
In-Reply-To: <51C37251.4000008@linux.vnet.ibm.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5KMBehb004741

> - Two, the Generic Error Data Entry (aka UEFI Section Descriptor) has a 
> flag which indicates 'Error Threshold Exceeded'. From the UEFI spec, it 
> looks like we could consider this as an indication to offline the page; 
> though I am not sure if/how this relates to the threshold value above.

This one sounds to make sense ... the flag description sounds exactly what
we want - I won't feel embarrassed explaining to people why Linux takes
action when it sees a record like this.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
