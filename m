Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933958Ab3GPUkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:40:19 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:45790 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406Ab3GPUkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:40:17 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Jean Delvare <jdelvare@suse.de>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [pull request] Pull request for branch yem-kconfig-rc-fixes
Date: Tue, 16 Jul 2013 22:39:56 +0200
Message-Id: <cover.1374006854.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Hello Michal,

Please pull these post-rc1 kconfig cleanups, all after
review and comments by Jean:
  - simplify and cleanup the symbol-search code
  - better documentation about the symbols ordering in search results
  - eye-candy in the title of the search-box in [mn]conf

Regards,
Yann E. MORIN.


The following changes since commit b57caaaed2bd127fe656e6c145970ed6a05c0125:

  kconfig: allow "hex" and "range" to support longs (2013-06-29 15:30:17 +0200)

are available in the git repository at:

  git://gitorious.org/linux-kconfig/linux-kconfig.git yem-kconfig-rc-fixes

for you to fetch changes up to 508382a0428f2b2f49da0e0e89c921f07c9306aa:

  kconfig: simplify symbol-search code (2013-07-16 20:39:42 +0200)

----------------------------------------------------------------
Yann E. MORIN (6):
      Documentation/kconfig: more concise and straightforward search explanation
      kconfig: avoid multiple calls to strlen
      kconfig/[mn]conf: shorten title in search-box
      kconfig: minor style fixes in symbol-search code
      kconfig: don't allocate n+1 elements in temporary array
      kconfig: simplify symbol-search code

 Documentation/kbuild/kconfig.txt |  8 +++----
 scripts/kconfig/mconf.c          |  4 ++--
 scripts/kconfig/nconf.c          |  4 ++--
 scripts/kconfig/symbol.c         | 49 ++++++++++++++++------------------------
 4 files changed, 27 insertions(+), 38 deletions(-)

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
