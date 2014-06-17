Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958AbaFQSCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 14:02:17 -0400
Received: from imap.thunk.org ([74.207.234.97]:43696 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135AbaFQSCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 14:02:16 -0400
Date: Tue, 17 Jun 2014 14:02:11 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] random bug fix
Message-ID: <20140617180211.GA31374@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1860e379875dfe7271c649058aeddffe5afd9d0d:

  Linux 3.15 (2014-06-08 11:19:54 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random.git tags/random_for_linus

for you to fetch changes up to e33ba5fa7afce1a9f159704121d4e4d110df8185:

  random: fix nasty entropy accounting bug (2014-06-15 21:04:32 -0400)

----------------------------------------------------------------
random: fix entropy accounting bug introduced in v3.15

----------------------------------------------------------------
Theodore Ts'o (1):
      random: fix nasty entropy accounting bug

 drivers/char/random.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)
