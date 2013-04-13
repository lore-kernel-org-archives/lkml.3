Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3DMOSq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 10:18:46 -0400
Received: from dkim2.fusionio.com ([66.114.96.54]:53460 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3DMOSo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 10:18:44 -0400
X-ASG-Debug-ID: 1365862723-03d6a52ac02855a0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
Message-ID: <20130413141841.12886.91603@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
User-Agent: alot/0.3.4
Subject: [GIT PULL] One more btrfs
Date: Sat, 13 Apr 2013 10:18:41 -0400
X-ASG-Orig-Subj: [GIT PULL] One more btrfs
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1365862723
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.128005
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

My for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Has a recent fix from Josef for our tree log replay code.  It fixes
problems where the inode counter for the number of bytes in the file
wasn't getting updated properly during fsync replay.

The commit did get rebased this morning, but it was only to clean up the
subject line.  The code hasn't changed.

Josef Bacik (1) commits (+42/-6):
    Btrfs: make sure nbytes are right after log replay

Total: (1) commits (+42/-6)

 fs/btrfs/tree-log.c | 48 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 6 deletions(-)
