Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbaESNA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:00:29 -0400
Received: from imap.thunk.org ([74.207.234.97]:48982 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301AbaESNA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:00:28 -0400
Date: Mon, 19 May 2014 09:00:26 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] /dev/random updates for 3.15-rc6
Message-ID: <20140519130026.GA13093@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
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

The following changes since commit d6d211db37e75de2ddc3a4f979038c40df7cc79c:

  Linux 3.15-rc5 (2014-05-09 13:10:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random.git tags/random_for_linus

for you to fetch changes up to f9c6d4987b23e0a514464bae6771933a48e4cd01:

  random: fix BUG_ON caused by accounting simplification (2014-05-16 22:18:22 -0400)

----------------------------------------------------------------
This fixes a BUG_ON-causing regression that was introduced during the
last merge window.

----------------------------------------------------------------
Theodore Ts'o (1):
      random: fix BUG_ON caused by accounting simplification

 drivers/char/random.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)
