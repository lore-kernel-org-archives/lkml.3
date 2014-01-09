Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbaAIQdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 11:33:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:47845 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbaAIQdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 11:33:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,631,1384329600"; 
   d="scan'208";a="436407759"
From: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: please, remove UBI tree from linux-next
Thread-Topic: please, remove UBI tree from linux-next
Thread-Index: AQHPDViCj1bq3Cn7A0WnwukFXIBvkQ==
Date: Thu, 9 Jan 2014 16:33:21 +0000
Message-ID: <1389285200.2259.147.camel@sauron.fi.intel.com>
Reply-To: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.82]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6467E125B81E6444A79156692EC53191@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s09GXjd3003428

Hi Stephen,

could you please remove the UBI git tree from linux-next?

git://git.infradead.org/linux-ubi

I will use the UBIFS git tree for both UBI and UBIFS patches from now
on. The traffic became so low that it does not make sense to keep 2
separate trees for these very related subsystems.

The UBIFS git tree is also in linux-next, so both UBI and UBIFS will be
covered through the UBIFS git tree.

Thanks!

-- 
Best Regards,
Artem Bityutskiy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
