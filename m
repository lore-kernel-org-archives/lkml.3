Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab3HUII3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 04:08:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:61603 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab3HUII0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 04:08:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,926,1367996400"; 
   d="scan'208";a="349434623"
From: "Li, Fei" <fei.li@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "holt@sgi.com" <holt@sgi.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Fei" <fei.li@intel.com>
Subject: RE: [PATCH] reboot: perform warm/cold reset correctly for CF9 type
Thread-Topic: [PATCH] reboot: perform warm/cold reset correctly for CF9 type
Thread-Index: AQHOnkAyupFWw/TFQUeMMS/7isOBqpmevtGAgACNFwA=
Date: Wed, 21 Aug 2013 08:08:23 +0000
Message-ID: <BEC9F67575FA1E429CA7CF5AE9BE3634012ED68C@SHSMSX104.ccr.corp.intel.com>
References: <1377049949.18357.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <20130821072940.GB27495@gmail.com>
 <69b80c44-3245-4393-b6e9-4d8a7f3d3c66@email.android.com>
In-Reply-To: <69b80c44-3245-4393-b6e9-4d8a7f3d3c66@email.android.com>
Accept-Language: en-US
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7L88Yc3020851

> Careful.  This is a very different definition of warm vs cold boot used elsewhere.

We have tested both warm and cold reboot on our x86 platform, and it works well.
Besides with commit, the expected warm and reboot type can be specified through
command line.

> >Looks good, but please introduce a reboot_val intermediate
> >variable instead of duplicating that ugly line-broken
> >construct twice.

Accepted and will update it in later version. 

> >
> >Thanks,
> >
> >	Ingo
> 

Thanks,
Fei
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
