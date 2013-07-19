Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751189Ab3GST1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 15:27:15 -0400
Received: from mx2.netapp.com ([216.240.18.37]:47980 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab3GST1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 15:27:11 -0400
X-IronPort-AV: E=Sophos;i="4.89,704,1367996400"; 
   d="scan'208";a="34699829"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux NFS mailing list <linux-nfs@vger.kernel.org>,
        Linux linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Please pull NFS client fixes
Thread-Topic: [GIT PULL] Please pull NFS client fixes
Thread-Index: AQHOhLX2R7Sty/km+02lQfEaZm603Q==
Date: Fri, 19 Jul 2013 19:27:09 +0000
Message-ID: <1374262028.27573.63.camel@leira.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <77408FF662836C4CACFF87DD51231B94@hq.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6JJRVu0014566

Hi Linus,

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.11-3

for you to fetch changes up to b4a2cf76ab7c08628c62b2062dacefa496b59dfd:

  NFSv4: Fix a regression against the FreeBSD server (2013-07-17 16:54:46 -0400)

----------------------------------------------------------------
NFS client bugfixes for 3.11

- Fix a regression against NFSv4 FreeBSD servers when creating a new file
- Fix another regression in rpc_client_register()

----------------------------------------------------------------
Trond Myklebust (2):
      SUNRPC: Fix another issue with rpc_client_register()
      NFSv4: Fix a regression against the FreeBSD server

 fs/nfs/nfs4xdr.c  | 21 ++++++++++++++-------
 net/sunrpc/clnt.c |  1 +
 2 files changed, 15 insertions(+), 7 deletions(-)

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
