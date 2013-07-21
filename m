Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab3GUCpT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 22:45:19 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39627 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab3GUCpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 22:45:18 -0400
Date: Sat, 20 Jul 2013 22:45:11 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [GIT PULL] Re: [PATCH] ext4: fix a bug when we try to open a file
 with O_TMPFILE flag
Message-ID: <20130721024511.GC21484@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Al Viro <viro@ZenIV.linux.org.uk>, Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
References: <20130717161944.GA19405@redhat.com>
 <20130719121405.GA3856@gmail.com>
 <20130719233613.GH4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719233613.GH4165@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 12:36:13AM +0100, Al Viro wrote:
> 
> Nice catch, and you have my ACK.  Which tree do you prefer that to go
> through?  vfs and ext4 are the obvious candidates...

On second thought, to avoid an "After you, Alphonse" moment, and
because it would be really good to make sure these patches make it to
Linus before -rc2, I thought get these patches set up for a pull
request.  Al, if you'd prefer that they go through the vfs tree, feel
free to NACK this, and I'll happily drop these from the ext4 tree.

Cheers,

						- Ted


The following changes since commit 36231d255b8df9cb4698e9a3902c16067d5c1398:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs (2013-07-20 10:50:01 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to dda5690defe4af62ee120f055e98e40d97e4c760:

  ext3: fix a BUG when opening a file with O_TMPFILE flag (2013-07-20 22:03:20 -0400)

----------------------------------------------------------------
Fix regression caused by commit af51a2ac36d1f which added ->tmpfile()
support (along with a similar fix for ext3)

----------------------------------------------------------------
Zheng Liu (2):
      ext4: fix a BUG when opening a file with O_TMPFILE flag
      ext3: fix a BUG when opening a file with O_TMPFILE flag

 fs/ext3/namei.c | 2 +-
 fs/ext4/namei.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

