Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab3JJSpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:45:01 -0400
Received: from imap.thunk.org ([74.207.234.97]:44612 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756469Ab3JJSpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:45:00 -0400
Date: Thu, 10 Oct 2013 14:44:56 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] random changes for 3.12
Message-ID: <20131010184456.GA26866@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6e4664525b1db28f8c4e1130957f70a94c19213e:

  Linux 3.11 (2013-09-02 13:46:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random.git tags/random_for_linus

for you to fetch changes up to 61875f30daf60305712e25b209ef41ced2635bad:

  random: allow architectures to optionally define random_get_entropy() (2013-10-10 14:30:53 -0400)

----------------------------------------------------------------
These patches are designed to enable improvements to /dev/random for
non-x86 platforms, in particular MIPS and ARM.

----------------------------------------------------------------
Theodore Ts'o (2):
      random: run random_int_secret_init() run after all late_initcalls
      random: allow architectures to optionally define random_get_entropy()

 drivers/char/random.c  | 11 +++++------
 include/linux/random.h |  1 +
 include/linux/timex.h  | 14 ++++++++++++++
 init/main.c            |  2 ++
 4 files changed, 22 insertions(+), 6 deletions(-)
