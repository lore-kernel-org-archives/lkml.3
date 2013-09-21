Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab3IUTAs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 15:00:48 -0400
Received: from mx1.netapp.com ([216.240.18.38]:49607 "EHLO mx1.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466Ab3IUTAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 15:00:47 -0400
X-IronPort-AV: E=Sophos;i="4.90,953,1371106800"; 
   d="scan'208";a="280595364"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mailing List Linux NFS <linux-nfs@vger.kernel.org>,
        Linux linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Please pull an NFS client bugfix
Thread-Topic: [GIT PULL] Please pull an NFS client bugfix
Thread-Index: AQHOtvzgzigVJd1Xj0KeslXi4m130Q==
Date: Sat, 21 Sep 2013 19:00:45 +0000
Message-ID: <1379790026.3028.0.camel@leira.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <AEBCE4D6A23BD240B589EE44D2481B6E@hq.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8LJ0so7007681

Hi Linus,

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.12-3

for you to fetch changes up to a0f6ed8ebe4f6d494ef70f67d4c0c153cbf59577:

  RPCSEC_GSS: fix crash on destroying gss auth (2013-09-18 10:18:44 -0500)

----------------------------------------------------------------
NFS client bugfix for 3.12

- Fix a regression due to incorrect sharing of gss auth caches

----------------------------------------------------------------
J. Bruce Fields (1):
      RPCSEC_GSS: fix crash on destroying gss auth

 net/sunrpc/auth_gss/auth_gss.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
