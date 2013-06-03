Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861Ab3FCPtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:49:06 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51371 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3FCPtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:49:03 -0400
Message-ID: <51ACBAE4.7060100@oracle.com>
Date: Mon, 03 Jun 2013 10:48:52 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "jfs-discussion@lists.sourceforge.net" 
	<jfs-discussion@lists.sourceforge.net>
Subject: [GIT PULL] jfs for 3.10-rc5
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 514e250f67d2b2a8ab08dc9c3650af19a411c926:

  Merge tag 'gpio-fixes-v3.10-1' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio (2013-05-23 18:24:10 -0700)

are available in the git repository at:


  git://github.com/kleikamp/linux-shaggy.git tags/jfs-3.10-rc5

for you to fetch changes up to 95bbb82f60c80808e5a49d8233c2de8451901531:

  fs/jfs: Add check if journaling to disk has been disabled in lbmRead() (2013-05-24 16:03:47 -0500)

----------------------------------------------------------------
A couple jfs bug fixes for 3.10-rc5

----------------------------------------------------------------
Gu Zheng (1):
      fs/jfs: Add check if journaling to disk has been disabled in lbmRead()

Vahram Martirosyan (1):
      jfs: Several bugs in jfs_freeze() and jfs_unfreeze()

 fs/jfs/jfs_logmgr.c |  8 +++++++-
 fs/jfs/super.c      | 38 ++++++++++++++++++++++++++++++--------
 2 files changed, 37 insertions(+), 9 deletions(-)
