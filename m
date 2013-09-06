Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab3IFUXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 16:23:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab3IFUXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 16:23:30 -0400
Date: Fri, 6 Sep 2013 22:23:28 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: artagnon@gmail.com, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild updates for v3.12-rc1
Message-ID: <20130906202328.GA11154@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

only these two commits are in the kbuild branch this time:
- Using filechk for include/config/kernel.release
- Cleanup in scripts/sortextable.c


Thanks,
Michal

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kbuild

Michal Marek (1):
      kbuild: Do not overwrite include/config/kernel.release needlessly

Ramkumar Ramachandra (1):
      scripts: remove unused function in sortextable.c

 Makefile              |    7 +++++--
 scripts/sortextable.c |    8 --------
 2 files changed, 5 insertions(+), 10 deletions(-)
