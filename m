Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaLSUxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 15:53:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbaLSUxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 15:53:19 -0500
Date: Fri, 19 Dec 2014 21:53:16 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: boaz@plexistor.com, jglisse@redhat.com, mchehab@osg.samsung.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] kbuild misc changes for v3.19-rc1
Message-ID: <20141219205316.GA4385@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

there are only a few things in the misc branch:

* Fix for bugon.cocci semantic patch
* Kdevelop4 files are .gitignored
* Put make binrpm-pkg on diet

Michal

The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git misc

for you to fetch changes up to b9a544240d265ec83241dcfaf0da0d6adead599b:

  scripts/package: binrpm-pkg do not create source and devel package (2014-12-08 13:11:22 +0100)

----------------------------------------------------------------
Boaz Harrosh (1):
      .gitignore: Add Kdevelop4 project files

Jérôme Glisse (1):
      scripts/package: binrpm-pkg do not create source and devel package

Mauro Carvalho Chehab (1):
      bugon.cocci: fix Options at the macro

 .gitignore                          | 3 +++
 scripts/coccinelle/misc/bugon.cocci | 2 +-
 scripts/package/mkspec              | 4 ++++
 3 files changed, 8 insertions(+), 1 deletion(-)
