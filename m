Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486Ab3FNB35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 21:29:57 -0400
Received: from dkim2.fusionio.com ([66.114.96.54]:43036 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759267Ab3FNB3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 21:29:55 -0400
X-ASG-Debug-ID: 1371173394-0421b5021f13b20001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: <torvalds@linux-foundation.org>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Message-ID: <20130614012953.4914.58775@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
User-Agent: alot/0.3.4
Subject: [GIT PULL] Btrfs
Date: Thu, 13 Jun 2013 21:29:53 -0400
X-ASG-Orig-Subj: [GIT PULL] Btrfs
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1371173394
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.133840
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This is an assortment of crash fixes:

Josef Bacik (3) commits (+9/-8):
    Btrfs: don't delete fs_roots until after we cleanup the transaction (+1/-1)
    Btrfs: init relocate extent_io_tree with a mapping (+5/-4)
    Btrfs: stop all workers before cleaning up roots (+3/-3)

Liu Bo (1) commits (+2/-2):
    Btrfs: fix use-after-free bug during umount

Naohiro Aota (1) commits (+3/-0):
    btrfs: Drop inode if inode root is NULL

Total: (5) commits (+14/-10)

 fs/btrfs/disk-io.c    | 10 +++++-----
 fs/btrfs/inode.c      |  3 +++
 fs/btrfs/relocation.c |  9 +++++----
 3 files changed, 13 insertions(+), 9 deletions(-)
