Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab3HZWRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 18:17:52 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:45102 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab3HZWRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 18:17:51 -0400
Message-ID: <521BD403.9080905@oracle.com>
Date: Mon, 26 Aug 2013 17:17:39 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        JFS discussion <jfs-discussion@lists.sourceforge.net>
Subject: [GIT PULL] jfs for 3.11-rc8
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f1d6e17f540af37bb1891480143669ba7636c4cf:

  Merge branch 'akpm' (patches from Andrew Morton) (2013-08-14 10:04:43 -0700)

are available in the git repository at:


  git://github.com/kleikamp/linux-shaggy.git tags/jfs-3.11-rc8

for you to fetch changes up to 44512449c0ab368889dd13ae0031fba74ee7e1d2:

  jfs: fix readdir cookie incompatibility with NFSv4 (2013-08-15 17:22:29 -0500)

----------------------------------------------------------------
One JFS patch to fix an incompatibility with NFSv4 resulting in the nfs
client reporting a readdir loop.

----------------------------------------------------------------
Dave Kleikamp (1):
      jfs: fix readdir cookie incompatibility with NFSv4

 fs/jfs/jfs_dtree.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)
