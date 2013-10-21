Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab3JURBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 13:01:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28842 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab3JURBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 13:01:37 -0400
Message-ID: <52655DE3.8080205@oracle.com>
Date: Mon, 21 Oct 2013 12:01:23 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        "jfs-discussion@lists.sourceforge.net" 
	<jfs-discussion@lists.sourceforge.net>
Subject: [GIT PULL] jfs fix for 3.12
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just one small fix that I probably should have pushed weeks ago.

Thanks, Shaggy

The following changes since commit 44598f98b98e54beca34dc836b38eaea40be1abf:

  Merge tag 'boards-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc (2013-09-06 13:34:43 -0700)

are available in the git repository at:


  git://github.com/kleikamp/linux-shaggy.git tags/jfs-3.12

for you to fetch changes up to 8660998608cfa1077e560034db81885af8e1e885:

  jfs: fix error path in ialloc (2013-09-17 10:05:19 -0500)

----------------------------------------------------------------
Just a patch to fix an oops in an error path.

----------------------------------------------------------------
Dave Kleikamp (1):
      jfs: fix error path in ialloc

 fs/jfs/jfs_inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)
