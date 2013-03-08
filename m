Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896Ab3CHBNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 20:13:08 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:51896 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804Ab3CHBNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 20:13:07 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] random updates for 3.9
cc: linux-kernel@vger.kernel.org
Date: Thu, 07 Mar 2013 20:13:04 -0500
Message-ID: <nsxvc92d78f.fsf@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following changes since commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200:

  Linux 3.8 (2013-02-18 15:58:34 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random.git tags/random_for_linus

for you to fetch changes up to b980955236922ae6106774511c5c05003d3ad225:

  random: fix locking dependency with the tasklist_lock (2013-03-04 12:05:15 -0500)

----------------------------------------------------------------
Fix a circular locking dependency in random's collection of cputime
used by a thread when it exits.

----------------------------------------------------------------
Theodore Ts'o (1):
      random: fix locking dependency with the tasklist_lock

 drivers/char/random.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)
