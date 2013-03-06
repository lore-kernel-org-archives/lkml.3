Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab3CFNOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:14:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39525 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042Ab3CFNOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:14:20 -0500
Date: Wed, 6 Mar 2013 14:14:18 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild fix for v3.9-rc2
Message-ID: <20130306131417.GA12905@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

there is one for for make headers_install/headers_check to not require
make 3.81. The requirement has been accidentally introduced in 3.7.

Thanks,
Michal

The following changes since commit 0ca7ffb356063c5ece847687da457dfe748612a2:

  Merge branch 'kbuild' of git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild (2013-02-27 12:25:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kbuild

Sam Ravnborg (1):
      kbuild: fix make headers_check with make 3.80

 scripts/Makefile.headersinst |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)
