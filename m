Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab3HOVRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 17:17:45 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:40542 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab3HOVRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 17:17:40 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [pull request] Pull request for branch yem/kconfig-for-next
Date: Thu, 15 Aug 2013 23:17:29 +0200
Message-Id: <cover.1376600922.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Hello Michal,

Please pull a few more changes queued for 3.12 since your last pull:

  - POSIX compliance when using sed in scripts/config    (CLément)
  - use 'long long' to represent hex and ranges, so their width
    is not dependent on the architecture (32/64 bits)    (Kees)
  - remove the warning when parsing auto.conf, that frigthened
    Linus when he merged the ext4 tree
  - explicit use CONFIG_MODULES to enable tristates

Regards,
Yann E. MORIN.

PS. I've indeed changed the naming scheme of my branches, don't worry. ;-)


The following changes since commit c3286ee337b0586a8ae2b4f13c33e3de5d71139e:

  Merge branch 'yem-kconfig-rc-fixes' of git://gitorious.org/linux-kconfig/linux-kconfig into kbuild/kconfig (2013-07-23 15:57:17 +0200)

are available in the git repository at:


  git://gitorious.org/linux-kconfig/linux-kconfig.git yem/kconfig-for-next

for you to fetch changes up to 11097a0367e48954ecf616f9b0df48d86835dd0d:

  modules: do not depend on kconfig to set 'modules' option to symbol MODULES (2013-08-15 22:56:08 +0200)

----------------------------------------------------------------
Clement Chauplannaz (1):
      scripts/config: use sed's POSIX interface

Kees Cook (1):
      kconfig: switch to "long long" for sanity

Yann E. MORIN (2):
      kconfig: silence warning when parsing auto.conf when a symbol has changed type
      modules: do not depend on kconfig to set 'modules' option to symbol MODULES

 init/Kconfig               |  1 +
 scripts/config             | 44 +++++++++++++++++++++++++++++++++++++++++---
 scripts/kconfig/confdata.c | 11 ++++++++---
 scripts/kconfig/symbol.c   | 19 ++++++++++---------
 4 files changed, 60 insertions(+), 15 deletions(-)

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
