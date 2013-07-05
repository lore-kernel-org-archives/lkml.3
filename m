Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847Ab3GEOwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:52:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:9687 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757399Ab3GEOwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:52:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1002,1363158000"; 
   d="scan'208";a="365308467"
From: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] UBI changes for 3.11-rc1
Thread-Topic: [GIT PULL] UBI changes for 3.11-rc1
Thread-Index: AQHOeY8wKfPqYAL2PkCZxyxyUDAwZw==
Date: Fri, 5 Jul 2013 14:51:53 +0000
Message-ID: <1373036154.2711.61.camel@sauron.fi.intel.com>
Reply-To: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.72]
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B7ED4D71042C548AAFDF9756A8BB374@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r65EqGwn027458

Hellow Linus!

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-ubi.git tags/upstream-3.11-rc1

for you to fetch changes up to 83ff59a066637a6c28844bbf43009459408240f4:

  UBI: support ubi_num on mtd.ubi command line (2013-07-01 08:32:57 +0300)

----------------------------------------------------------------
A couple of fixes and clean-ups, allow for assigning user-defined
UBI device numbers when attaching MTD devices by using the "mtd="
module parameter.

----------------------------------------------------------------
Brian Pomerantz (1):
      UBI: fastmap break out of used PEB search

Mike Frysinger (4):
      UBI: drop redundant "UBI error" string
      UBI: do not abort init when ubi.mtd devices cannot be found
      UBI: document UBI_IOCVOLUP better in user header
      UBI: support ubi_num on mtd.ubi command line

 drivers/mtd/ubi/build.c     | 59 ++++++++++++++++++++++++++++++++++++++++-------------------
 drivers/mtd/ubi/fastmap.c   |  4 +++-
 include/uapi/mtd/ubi-user.h |  5 ++++-

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
