Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934711AbaGPRml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:42:41 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:63635 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932965AbaGPRmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:42:39 -0400
Date: Wed, 16 Jul 2014 10:42:35 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: [GIT PULL] MTD fixes for 3.16-rc6
Message-ID: <20140716174235.GU7537@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.infradead.org/linux-mtd.git tags/for-linus-20140716

for you to fetch changes up to 812c5fa82bae9f377f49000d7636c19a8b61735c:

  mtd: cfi_cmdset_0001.c: add support for Sharp LH28F640BF NOR (2014-07-13 22:22:47 -0700)

----------------------------------------------------------------
MTD updates for 3.16-rc6
- Fix ELM suspend/resume
- Reduce warnings if NAND ECC is too weak
- Add CFI support for Sharp LH28F640BF NOR

The last fix is coming in because other commits in the 3.16 cycle depended on
this support.

----------------------------------------------------------------
Andrea Adami (1):
      mtd: cfi_cmdset_0001.c: add support for Sharp LH28F640BF NOR

Ted Juan (1):
      mtd: devices: elm: fix elm_context_save() and elm_context_restore() functions

Thomas Petazzoni (1):
      mtd: nand: reduce the warning noise when the ECC is too weak

 drivers/mtd/chips/cfi_cmdset_0001.c | 43 +++++++++++++++++++++++++++++++++++++
 drivers/mtd/devices/elm.c           |  2 ++
 drivers/mtd/nand/nand_base.c        |  6 ++++--
 3 files changed, 49 insertions(+), 2 deletions(-)
