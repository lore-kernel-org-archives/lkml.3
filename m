Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbbADQEF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 11:04:05 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbbADQED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 11:04:03 -0500
Message-ID: <54A96470.1000208@nod.at>
Date: Sun, 04 Jan 2015 17:04:00 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [GIT PULL] UML fixes for v3.19-rc3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit d753856c9f9ae33a980192aa7b81d8b97d79dec2:

  Merge tag 'scsi-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi (2015-01-02 13:24:41 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git for-linus

for you to fetch changes up to b485342bd79af363c77ef1a421c4a0aef2de9812:

  x86, um: actually mark system call tables readonly (2015-01-04 14:21:25 +0100)

----------------------------------------------------------------
Two fixes for UML regressions. Nothing exciting.
----------------------------------------------------------------
Daniel Borkmann (1):
      x86, um: actually mark system call tables readonly

Richard Weinberger (1):
      um: Skip futex_atomic_cmpxchg_inatomic() test

 arch/um/Kconfig.common          | 1 +
 arch/x86/um/sys_call_table_32.c | 2 +-
 arch/x86/um/sys_call_table_64.c | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

Thanks,
//richard
