Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab3JHUYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:24:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47126 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab3JHUYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:24:24 -0400
Date: Tue, 8 Oct 2013 22:24:22 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: rric@kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild fix for 3.12
Message-ID: <20131008202422.GA14089@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is an ARM Makefile fix that you even acked. After nobody wanted to
take it, it ended up in the kbuild tree.

Michal

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git rc-fixes

Robert Richter (1):
      arm, kbuild: make "make install" not depend on vmlinux

 arch/arm/Makefile        |    9 +++++++--
 arch/arm/boot/Makefile   |   16 ++++++++--------
 arch/arm/boot/install.sh |   14 ++++++++++++++
 3 files changed, 29 insertions(+), 10 deletions(-)
