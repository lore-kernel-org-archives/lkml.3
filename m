Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762590Ab3ECE5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 00:57:44 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:45099 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab3ECE5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 00:57:43 -0400
Date: Thu, 2 May 2013 21:08:31 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Subject: [GIT PULL] linux-pstore.git
Message-ID: <20130503040831.GA15695@teo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull a few updates for the pstore subsystem. Here is what is in:

- A new platform data parameter to specify ECC configuration;
- Rounding fixup to not waste memory in ecc_blocks;
- Restore ECC information printouts;
- A small code cleanup: use kmemdup where appropriate.

Thank you!

The following changes since commit a937536b868b8369b98967929045f1df54234323:

  Linux 3.9-rc3 (2013-03-17 15:59:32 -0700)

are available in the git repository at:

  git://git.infradead.org/users/cbou/linux-pstore.git tags/for-v3.10

for you to fetch changes up to bd08ec33b5c23833581e5a36b2a69ccae6b39a28:

  pstore/ram: Restore ecc information block (2013-04-03 21:50:10 -0700)

----------------------------------------------------------------
Alexandru Gheorghiu (1):
      pstore: Replace calls to kmalloc and memcpy with kmemdup

Arve Hjønnevåg (3):
      pstore/ram: Include ecc_size when calculating ecc_block
      pstore/ram: Allow specifying ecc parameters in platform data
      pstore/ram: Restore ecc information block

 fs/pstore/ram.c            | 26 +++++++++++-------
 fs/pstore/ram_core.c       | 66 ++++++++++++++++++++++++++--------------------
 include/linux/pstore_ram.h | 14 +++++++---
 3 files changed, 64 insertions(+), 42 deletions(-)
