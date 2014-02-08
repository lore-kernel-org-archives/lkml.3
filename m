Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaBHQ7X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 11:59:23 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35429 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaBHQ7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 11:59:22 -0500
Message-ID: <52F66260.6020903@oracle.com>
Date: Sat, 08 Feb 2014 10:59:12 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        JFS Discussion <jfs-discussion@lists.sourceforge.net>
Subject: [GIT PULL] jfs for 3.14-rc2
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 41f76d8bee06be5a9b301ebf13f61a719ba548c4:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client (2014-02-07 12:35:56 -0800)

are available in the git repository at:


  git://github.com/kleikamp/linux-shaggy.git tags/jfs-3.14-rc2

for you to fetch changes up to c18f7b51200c3c8b76c63e391f9995b65ace9c83:

  jfs: fix generic posix ACL regression (2014-02-08 10:50:58 -0600)

----------------------------------------------------------------
Fix regression

----------------------------------------------------------------
Dave Kleikamp (1):
      jfs: fix generic posix ACL regression

 fs/jfs/xattr.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)
