Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab3ECPhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:37:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33457 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759559Ab3ECPhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:37:39 -0400
Message-ID: <5183D9B5.2060109@oracle.com>
Date: Fri, 03 May 2013 10:37:25 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130403 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, jfs-discussion@lists.sourceforge.net
Subject: [GIT PULL] jfs for 3.10
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5f243b9b46a22e5790dbbc36f574c2417af49a41:

  Merge tag 'arm64-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64 (2013-01-04 10:41:54 -0800)

are available in the git repository at:


  git://github.com/kleikamp/linux-shaggy.git tags/jfs-3.10

for you to fetch changes up to 73aaa22d5ffb2630456bac2f9a4ed9b81d0d7271:

  jfs: fix a couple races (2013-05-01 11:16:59 -0500)

----------------------------------------------------------------
Dave Kleikamp (1):
      jfs: fix a couple races

Nickolai Zeldovich (1):
      jfs: avoid undefined behavior from left-shifting by 32 bits

 fs/jfs/inode.c      | 2 +-
 fs/jfs/jfs_imap.c   | 2 +-
 fs/jfs/jfs_logmgr.c | 3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)
