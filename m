Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab3IMMia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 08:38:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842Ab3IMMi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 08:38:26 -0400
Date: Fri, 13 Sep 2013 14:38:24 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: chauplac@gmail.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kconfig fix for v3.12-rc1
Message-ID: <20130913123824.GA8397@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

there is a fix for a regression caused by my previous pull request. A
sed command in scripts/config that used colons as separator was
accidentally changed to use slashes, which fails when you use slashes in
a value. Changing it back to colons is of course not a proper fix, but
at least it will be broken in the same way it had been for four years. A
proper fix is pending.

Michal


The following changes since commit 5b4197845ad1a33bc57da7ee5ea41de58c2f86bf:

  Merge branch 'kconfig' of git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild (2013-09-11 08:34:25 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kconfig

Clement Chauplannaz (1):
      scripts/config: fix variable substitution command

 scripts/config |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
