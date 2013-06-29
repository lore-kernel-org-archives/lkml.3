Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab3F2OVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 10:21:30 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:32811 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab3F2OV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 10:21:27 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Kees Cook <keescook@chromium.org>
Subject: [pull request] Pull request for branch yem-kconfig-for-next
Date: Sat, 29 Jun 2013 16:21:11 +0200
Message-Id: <cover.1372515621.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Hello Michal, All,

Please pull this kconfig fix from Kees that enables 64-bit-wide
(ie. signed long) [int,hex] ranges.

Regards,
Yann E. MORIN.


The following changes since commit 490f16171119a16e05d670306c105f3b45c38837:

  Revert "kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG" (2013-06-26 15:49:00 +0200)

are available in the git repository at:

  git://gitorious.org/linux-kconfig/linux-kconfig.git yem-kconfig-for-next

for you to fetch changes up to b57caaaed2bd127fe656e6c145970ed6a05c0125:

  kconfig: allow "hex" and "range" to support longs (2013-06-29 15:30:17 +0200)

----------------------------------------------------------------
Kees Cook (1):
      kconfig: allow "hex" and "range" to support longs

 scripts/kconfig/symbol.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
