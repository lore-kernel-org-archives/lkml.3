Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762409Ab3IDK71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 06:59:27 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:61341 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996Ab3IDK7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 06:59:25 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [pull request] Pull request for branch yem/kconfig-for-next
Date: Wed,  4 Sep 2013 12:59:14 +0200
Message-Id: <cover.1378292314.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Hello All!

Michal, please pull for 3.12 this series that removes special-casing of
the 'MODULES' symbol, as previously discussed with Sam and you.

Regards,
Yann E. MORIN.


The following changes since commit b020bae0467b490797d61e6a658fb7df4568c074:

  Merge branch 'kbuild/kconfig' into kbuild/for-next (2013-09-01 21:25:45 +0200)

are available in the git repository at:


  git://gitorious.org/linux-kconfig/linux-kconfig.git yem/kconfig-for-next

for you to fetch changes up to 2c15d81f712791d3eae9a15414c83780a8dd6ac1:

  kconfig: do not allow more than one symbol to have 'option modules' (2013-09-04 12:57:48 +0200)

----------------------------------------------------------------
Yann E. MORIN (3):
      kconfig: do not special-case 'MODULES' symbol
      kconfig: regenerate bison parser
      kconfig: do not allow more than one symbol to have 'option modules'

 Documentation/kbuild/kconfig-language.txt |   1 +
 scripts/kconfig/menu.c                    |  11 +-
 scripts/kconfig/zconf.tab.c_shipped       | 562 ++++++++++++++++--------------
 scripts/kconfig/zconf.y                   |  11 +-
 4 files changed, 308 insertions(+), 277 deletions(-)

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
