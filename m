Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935310Ab3E2WZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:25:14 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:36498 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935270Ab3E2WZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:25:04 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Dirk Gouders <dirk@gouders.net>,
        Clement Chauplannaz <chauplac@gmail.com>
Subject: [pull request v2] Pull request for branch yem-kconfig-rc-fixes
Date: Thu, 30 May 2013 00:24:52 +0200
Message-Id: <cover.1369866004.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Hello Michal, All,

Please pull these three rc-fixes:
  - fix key handling in empty menus in mconf
  - fix reference to eliminated duplicate expression in kconfig
  - fix scripts/config wrt short --*-after options

Changes v1 -> v2:
  - add fix for eliminated dups in menu.c
  - fix >80 chars in key handling fix

Regards,
Yann E. MORIN


The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://gitorious.org/linux-kconfig/linux-kconfig.git yem-kconfig-rc-fixes

for you to fetch changes up to e983b7b17ad1a978e954e6aaa62cf12bfc747883:

  kconfig/menu.c: fix multiple references to expressions in menu_add_prop() (2013-05-30 00:14:01 +0200)

----------------------------------------------------------------
Clement Chauplannaz (1):
      scripts/config: fix assignment of parameters for short version of --*-after options

Dirk Gouders (2):
      mconf: handle keys in empty dialogs
      kconfig/menu.c: fix multiple references to expressions in menu_add_prop()

 scripts/config                     |  2 +-
 scripts/kconfig/lxdialog/menubox.c |  9 +++++----
 scripts/kconfig/mconf.c            | 11 ++++++-----
 scripts/kconfig/menu.c             | 15 ++++++++++++++-
 4 files changed, 26 insertions(+), 11 deletions(-)

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
