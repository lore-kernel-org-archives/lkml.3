Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab3DZWSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 18:18:35 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43738 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab3DZWSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 18:18:33 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Michal Marek <mmarek@suse.cz>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [pull request] Pull request for branch yem-kconfig-for-next
Date: Sat, 27 Apr 2013 00:17:59 +0200
Message-Id: <cover.1367014328.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Michal,

Please pull this to revert:
    422c809: fix randomising choice entries in presence of KCONFIG_ALLCONFIG

It causes more harm that it fixes issues, and I couldn't find a proper
fix for now. To avoid breakage so close to the opening of the merge
window, it makes more sense to revert it than to wait for a fix.

As I already said earlier, I'll be on vacation the next two weeks, so
I should find some time to look back at this again, hopefully before
-rc1 is out (but any sane person that value his/her life should not hold
his/her breath...)


The following changes since commit e43956e607692f9b1c710311e4a6591ffba1edf0:

  kconfig: implement KCONFIG_PROBABILITY for randconfig (2013-04-25 00:16:30 +0200)

are available in the git repository at:

  git://gitorious.org/linux-kconfig/linux-kconfig.git yem-kconfig-for-next

for you to fetch changes up to 23a5dfdad22a574d19d7cc19b391f9ce0d3c2f21:

  Revert "kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG" (2013-04-26 23:21:59 +0200)

----------------------------------------------------------------
Yann E. MORIN (1):
      Revert "kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG"

 scripts/kconfig/confdata.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Regards,
Yann E. MORIN

.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
