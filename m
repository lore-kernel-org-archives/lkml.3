Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab3I3WCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 18:02:09 -0400
Received: from mx12.netapp.com ([216.240.18.77]:49596 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211Ab3I3WCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 18:02:07 -0400
X-IronPort-AV: E=Sophos;i="4.90,1010,1371106800"; 
   d="scan'208";a="95121816"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux NFS mailing list <linux-nfs@vger.kernel.org>,
        "Linux Kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Please pull NFS client bugfixes
Thread-Topic: [GIT PULL] Please pull NFS client bugfixes
Thread-Index: AQHOviix7dRxSVVieUizkgacIevd7w==
Date: Mon, 30 Sep 2013 22:02:03 +0000
Message-ID: <1380578523.15488.0.camel@leira.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7EB533CA8712FA42BCD9BB8FF6444FD3@hq.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8UM2HHC013041


Hi Linus,

The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:

  Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)

are available in the git repository at:

  git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.12-4

for you to fetch changes up to 367156d9a87b21b5232dd93107c5fc61b09ba2ef:

  NFS: Give "flavor" an initial value to fix a compile warning (2013-09-29 16:03:34 -0400)

----------------------------------------------------------------
NFS client bugfixes for 3.12

- Stable fix for Oopses in the pNFS files layout driver
- Fix a regression when doing a non-exclusive file create on NFSv4.x
- NFSv4.1 security negotiation fixes when looking up the root filesystem
- Fix a memory ordering issue in the pNFS files layout driver

----------------------------------------------------------------
Anna Schumaker (1):
      NFS: Give "flavor" an initial value to fix a compile warning

Trond Myklebust (3):
      NFSv4: Honour the 'opened' parameter in the atomic_open() filesystem method
      NFSv4.1: nfs4_fl_prepare_ds - fix bugs when the connect attempt fails
      NFSv4.1: Ensure memory ordering between nfs4_ds_connect and nfs4_fl_prepare_ds

Weston Andros Adamson (1):
      NFSv4.1: try SECINFO_NO_NAME flavs until one works

 fs/nfs/dir.c               |  2 +-
 fs/nfs/nfs4file.c          |  3 ++-
 fs/nfs/nfs4filelayoutdev.c | 20 +++++++++-------
 fs/nfs/nfs4proc.c          | 58 +++++++++++++++++++++++++++++++++++++---------
 include/linux/nfs_xdr.h    |  3 ++-
 5 files changed, 63 insertions(+), 23 deletions(-)

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
