Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab3KOQSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 11:18:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48955 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab3KOQSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 11:18:07 -0500
Date: Fri, 15 Nov 2013 17:18:01 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: michael.opdenacker@free-electrons.com, mpagano@gentoo.org,
        rdunlap@infradead.org, tkhai@yandex.ru, wsa@the-dreams.de,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild misc changes for v3.13-rc1
Message-ID: <20131115161801.GA20232@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these script updates for v3.13-rc1:
- make tags fixes again
- scripts/show_delta fix for newer python
- scripts/kernel-doc does not fail on unknown function prototype
- One less coccinelle check this time

Thanks,
Michal

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git misc

for you to fetch changes up to 6cf3a6eff77273a55b996a5a43f342b150cfba09:

  scripts/tags.sh: remove obsolete __devinit[const|data] (2013-11-08 10:57:20 +0100)

----------------------------------------------------------------
Kirill Tkhai (1):
      scripts/tags.sh: Increase identifier list

Michael Opdenacker (1):
      scripts/tags.sh: remove obsolete __devinit[const|data]

Mike Pagano (1):
      show_delta: Update script to support python versions 2.5 through 3.3

Randy Dunlap (1):
      scripts/kernel-doc: make unknown function prototype a Warning instead of an Error

Wolfram Sang (1):
      scripts/coccinelle/api: remove devm_request_and_ioremap.cocci

 .../coccinelle/api/devm_request_and_ioremap.cocci  | 105 ---------------------
 scripts/kernel-doc                                 |   3 +-
 scripts/show_delta                                 |  12 +--
 scripts/tags.sh                                    |   9 +-
 4 files changed, 12 insertions(+), 117 deletions(-)
 delete mode 100644 scripts/coccinelle/api/devm_request_and_ioremap.cocci
