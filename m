Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab3JRXY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 19:24:57 -0400
Received: from dkim2.fusionio.com ([66.114.96.54]:48771 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757406Ab3JRXYz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 19:24:55 -0400
X-ASG-Debug-ID: 1382138694-0421b56d433cb70001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <20131018232447.4917.74376@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
User-Agent: alot/0.3.4
Subject: [GIT PULL] Btrfs
Date: Fri, 18 Oct 2013 19:24:47 -0400
X-ASG-Orig-Subj: [GIT PULL] Btrfs
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: UNKNOWN[10.101.1.40]
X-Barracuda-Start-Time: 1382138694
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.141579
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

My for-linus branch has a one line fix:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Sage hit a deadlock with ceph on btrfs, and Josef tracked it down to a
regression in our initial rc1 pull.  When doing nocow writes we were
sometimes starting a transaction with locks held.

Josef Bacik (1) commits (+1/-0):
    Btrfs: release path before starting transaction in can_nocow_extent

Total: (1) commits (+1/-0)

 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)
