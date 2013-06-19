Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935254Ab3FSWJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 18:09:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:37507 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935070Ab3FSWJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 18:09:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,900,1363158000"; 
   d="scan'208";a="356411872"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
        "lcm@linux.vnet.ibm.com" <lcm@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Robert Richter" <rric@kernel.org>
Subject: RE: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
Thread-Topic: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
Thread-Index: AQHObRaMG8NLWdbwnkKYI9OOtTgcdZk9yhyA//+MXBCAAHyTAP//kUdQgACKGAD//4yfcAAQQVUAAA5rtID//5ZQgIAAcCMg
Date: Wed, 19 Jun 2013 22:08:53 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F2DA885A5@ORSMSX106.amr.corp.intel.com>
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
 <20130619214145.GS28300@pd.tnic>
In-Reply-To: <20130619214145.GS28300@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5JM9T54013088

> The above question about what to do *without* going to userspace and
> back is maybe more interesting and we'd need a clean design there...
> we'll see.

Yes - this case (where the BIOS did all the threshold math and made the decision)
should be one where Linux kernel could just implement the action directly.
Perhaps controlled by a knob to say whether we really trust the BIOS that much.

But we will also have cases where a smart user agent can correlate data
from multiple sources to identify the real root cause (e.g. some temperature
anomalies around the same time as some memory errors that occur at 10am
on the third Tuesday each month -> cause is air conditioner maintenance guy
that shuts down the a/c for 10 minutes to change the filter).

I'll leave writing an agent that smart as an exercise for the concerned data
center manager :-)

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
