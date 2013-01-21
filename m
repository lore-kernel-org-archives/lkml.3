Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab3AUIiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 03:38:00 -0500
Received: from mga03.intel.com ([143.182.124.21]:24729 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab3AUIh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 03:37:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,505,1355126400"; 
   d="scan'208";a="246410553"
From: "Lan, Tianyu" <tianyu.lan@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: build failure after merge of the usb tree
Thread-Topic: linux-next: build failure after merge of the usb tree
Thread-Index: AQHN947k7eA10gX81kSaQ4eu17jBO5hTdRYA
Date: Mon, 21 Jan 2013 08:37:54 +0000
Message-ID: <4CFBC02C07DA244CA19D6815A05BE6EE1B9746@SHSMSX101.ccr.corp.intel.com>
References: <20130121152132.bbcc78f7d2b20741734d0fd2@canb.auug.org.au>
In-Reply-To: <20130121152132.bbcc78f7d2b20741734d0fd2@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0L8c1mN018872

Hi Stephen£º
	Sorry for this. I have produced a fix patch which has been merged by usb-next tree.
http://git.kernel.org/?p=linux/kernel/git/gregkh/usb.git;a=commit;h=9f7344fbaf191de63df315c7e0fa4c976e2ea419

Best Regards 
Tianyu Lan 

-----Original Message-----
From: Stephen Rothwell [mailto:sfr@canb.auug.org.au] 
Sent: Monday, January 21, 2013 12:22 PM
To: Greg KH
Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Lan, Tianyu
Subject: linux-next: build failure after merge of the usb tree

Hi Greg,

After merging the usb tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/usb/core/port.c: In function 'usb_port_device_release':
drivers/usb/core/port.c:25:2: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]
drivers/usb/core/port.c: In function 'usb_hub_create_port_device':
drivers/usb/core/port.c:38:2: error: implicit declaration of function 'kzalloc' [-Werror=implicit-function-declaration]
drivers/usb/core/port.c:38:11: warning: assignment makes pointer from integer without a cast [enabled by default]

Caused by commit 6e30d7cba992 ("usb: Add driver/usb/core/(port.c,hub.h) files").  See Rule 1 in Documentation/SubmitChecklist.

I have used the usb tree from next-20130118 for today.
--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
