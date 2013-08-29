Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab3H2Nam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 09:30:42 -0400
Received: from mx12.netapp.com ([216.240.18.77]:29549 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786Ab3H2Nak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 09:30:40 -0400
X-IronPort-AV: E=Sophos;i="4.89,983,1367996400"; 
   d="scan'208";a="84994121"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux NFS mailing list <linux-nfs@vger.kernel.org>,
        Linux linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Please pull one NFS client bugfix
Thread-Topic: [GIT PULL] Please pull one NFS client bugfix
Thread-Index: AQHOpLvxWgAlMHkhR0yEUAgTpXGqww==
Date: Thu, 29 Aug 2013 13:30:35 +0000
Message-ID: <1377783035.3202.1.camel@leira.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <485CCB43495E7945840AA9D928CB3B14@hq.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7TDUucF014835

Hi Linus,

The following changes since commit fa8218def1b1a16f0a410e2c1c767b4738cc81fa:

  Merge tag 'regmap-v3.11-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap (2013-08-27 10:10:30 -0700)

are available in the git repository at:


  git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.11-5

for you to fetch changes up to 347e2233b7667e336d9f671f1a52dfa3f0416e2c:

  SUNRPC: Fix memory corruption issue on 32-bit highmem systems (2013-08-28 15:43:43 -0400)

----------------------------------------------------------------
NFS client bugfix for 3.11

- Stable patch to fix a highmem-related data corruption issue on 32-bit
  ARM platforms

----------------------------------------------------------------
Trond Myklebust (1):
      SUNRPC: Fix memory corruption issue on 32-bit highmem systems

 net/sunrpc/xdr.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
