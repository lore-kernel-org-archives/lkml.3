Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab3D2R7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:59:11 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:34732 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715Ab3D2R7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:59:09 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, Michal Marek <mmarek@suse.cz>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [pull request] Pull request for branch yem-kconfig-for-next
Date: Mon, 29 Apr 2013 19:59:01 +0200
Message-Id: <cover.1367258255.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Michal,

Please pull this fix to restore compilation of the qconf frontend.

Regards,
Yann E. MORIN.


The following changes since commit 23a5dfdad22a574d19d7cc19b391f9ce0d3c2f21:

  Revert "kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG" (2013-04-26 23:21:59 +0200)

are available in the git repository at:

  git://gitorious.org/linux-kconfig/linux-kconfig.git yem-kconfig-for-next

for you to fetch changes up to 21ca352b71ca252e1933b1538fe89da8a04395c3:

  kconfig: fix lists definition for C++ (2013-04-29 19:55:56 +0200)

----------------------------------------------------------------
Yann E. MORIN (1):
      kconfig: fix lists definition for C++

 scripts/kconfig/list.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
