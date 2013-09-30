Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3I3RBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:01:36 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:35795 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab3I3RBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:01:34 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Cc: Robert Richter <rric@kernel.org>, linux-kernel@vger.kernel.org,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [pull request] Pull request for branch yem/kconfig-rc-fixes
Date: Mon, 30 Sep 2013 19:01:18 +0200
Message-Id: <cover.1380560241.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Michal,

Please pull these two changes for 3.12-rc:
  - a fix for "make install" on ARM, by Robert Richter, acked by Linus
    and yourself;
  - a fix for "make allmodconfig" when KCONFIG_ALLCONFIG is set, which
    already flew on the list, but with a better commit log now.

Regards,
Yann E. MORIN.


The following changes since commit 86eb781889ec31f6421b86ab252ea609d456322d:

  scripts/config: fix variable substitution command (2013-09-13 13:06:59 +0200)

are available in the git repository at:

  git://gitorious.org/linux-kconfig/linux-kconfig.git yem/kconfig-rc-fixes

for you to fetch changes up to 3b03272a6e6f0f2c8d4b7751d35baa1ce41984aa:

  arm, kbuild: make "make install" not depend on vmlinux (2013-09-30 18:48:50 +0200)

----------------------------------------------------------------
Robert Richter (1):
      arm, kbuild: make "make install" not depend on vmlinux

Yann E. MORIN (1):
      kconfig: fix allmodconfig in presence of KCONFIG_ALLCONFIG

 arch/arm/Makefile          |  9 +++++++--
 arch/arm/boot/Makefile     | 16 ++++++++--------
 arch/arm/boot/install.sh   | 14 ++++++++++++++
 scripts/kconfig/confdata.c |  6 ++++--
 4 files changed, 33 insertions(+), 12 deletions(-)

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
