Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761269Ab3GSTRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 15:17:46 -0400
Received: from dkim2.fusionio.com ([66.114.96.54]:32803 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761186Ab3GSTRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 15:17:43 -0400
X-ASG-Debug-ID: 1374261462-0421b5021f163590001-xx1T2L
X-Barracuda-Envelope-From: JBacik@fusionio.com
Date: Fri, 19 Jul 2013 15:17:40 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] btrfs update
Message-ID: <20130719191740.GA2255@localhost.localdomain>
X-ASG-Orig-Subj: [GIT PULL] btrfs update
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas2.int.fusionio.com[10.101.1.41]
X-Barracuda-Start-Time: 1374261462
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.137243
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm playing the role of Chris Mason this week while he's on vacation.  There are
a few critical fixes for btrfs here, all regressions and have been tested well.
Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git for-linus

I've based it off a recent pull of your tree, hopefully that's the right thing.
Thanks,

Josef Bacik (3):
      Btrfs: update drop progress before stopping snapshot dropping
      Btrfs: fix lock leak when resuming snapshot deletion
      Btrfs: re-add root to dead root list if we stop dropping it

Stefan Behrens (1):
      Btrfs: fix wrong write offset when replacing a device

 fs/btrfs/extent-tree.c |   27 +++++++++++++++++++++------
 fs/btrfs/scrub.c       |    2 +-
 2 files changed, 22 insertions(+), 7 deletions(-)
