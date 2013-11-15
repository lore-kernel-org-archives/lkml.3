Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab3KOPUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 10:20:10 -0500
Received: from dkim2.fusionio.com ([66.114.96.54]:49795 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab3KOPUF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 10:20:05 -0500
X-ASG-Debug-ID: 1384528804-03d6a54d191f8630001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Message-ID: <20131115151958.3802.1019@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
User-Agent: alot/0.3.4
Subject: [GIT PULL] Btrfs
Date: Fri, 15 Nov 2013 10:19:58 -0500
X-ASG-Orig-Subj: [GIT PULL] Btrfs
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas2.int.fusionio.com[10.101.1.41]
X-Barracuda-Start-Time: 1384528804
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0003 1.0000 -2.0190
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.142326
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This pull fixes the empty_zero_page bug that Heiko reported, and
includes one more cleanup from Al Viro.   Please grab my for-linus:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Chris Mason (1) commits (+7/-2):
    btrfs: fix empty_zero_page misusage

Al Viro (1) commits (+4/-9):
    btrfs: get rid of fdentry()

Total: (2) commits (+11/-11)

 fs/btrfs/ctree.h |  5 -----
 fs/btrfs/ioctl.c | 17 +++++++++++------
 2 files changed, 11 insertions(+), 11 deletions(-)
