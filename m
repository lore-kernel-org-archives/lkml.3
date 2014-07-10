Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaGJVpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:45:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbaGJVnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:43:50 -0400
Date: Thu, 10 Jul 2014 23:43:47 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild fixed for v3.16-rc5
Message-ID: <20140710214347.GA21256@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

there are three more fixes for the relative build dir feature:

- Shut up make -s again
- Fix for rpm/deb/tar-pkg with O=<subdir>
- Fix for CONFIG_EXTRA_FIRMWARE

I hope that's it for 3.16.

Michal

The following changes since commit c2e28dc975ea87feed84415006ae143424912ac7:

  kbuild: Print the name of the build directory (2014-07-03 15:25:11 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git rc-fixes

for you to fetch changes up to dd5a6752ae7df4e0ba6ce3bcd0c3b4489bb3537f:

  firmware: Create directories for external firmware (2014-07-09 15:16:35 +0200)

----------------------------------------------------------------
Michal Marek (3):
      kbuild: Do not print the build directory with make -s
      kbuild: Fix packaging targets with relative $(srctree)
      firmware: Create directories for external firmware

 Makefile          | 99 ++++++++++++++++++++++++++++---------------------------
 firmware/Makefile |  6 ++++
 2 files changed, 57 insertions(+), 48 deletions(-)
