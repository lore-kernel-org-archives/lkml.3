Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934205Ab3BSVjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 16:39:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:42966 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933761Ab3BSVjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 16:39:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,697,1355126400"; 
   d="scan'208";a="289248368"
From: "Luck, Tony" <tony.luck@intel.com>
To: Xishi Qiu <qiuxishi@huawei.com>
CC: "Fleming, Matt" <matt.fleming@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, Liujiang <jiang.liu@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Hanjun Guo <guohanjun@huawei.com>, WuJianguo <wujianguo@huawei.com>
Subject: RE: [PATCH V3] ia64/mm: fix a bad_page bug when crash kernel booting
Thread-Topic: [PATCH V3] ia64/mm: fix a bad_page bug when crash kernel
 booting
Thread-Index: AQHOBPnODCGg30S+yEmlbZnCpqVtiJiBxyIg
Date: Tue, 19 Feb 2013 21:38:52 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1E06A8F1@ORSMSX108.amr.corp.intel.com>
References: <51074786.5030007@huawei.com>
 <1359995565.7515.178.camel@mfleming-mobl1.ger.corp.intel.com>
 <51131248.3080203@huawei.com> <5113450C.1080109@huawei.com>
In-Reply-To: <5113450C.1080109@huawei.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1JLdHK3032650

> In efi_init() memory aligns in IA64_GRANULE_SIZE(16M). If set "crashkernel=1024M-:600M"

Is this where the real problem begins?  Should we insist that users provide crashkernel
parameters rounded to GRANULE boundaries?

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
