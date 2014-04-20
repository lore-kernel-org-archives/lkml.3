Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbaDTV0b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 17:26:31 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751039AbaDTV01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 17:26:27 -0400
Message-ID: <53543B76.2080405@nod.at>
Date: Sun, 20 Apr 2014 23:26:14 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tristan Schmelcher <tschmelcher@google.com>,
        "Anton Ivanov (antivano)" <antivano@cisco.com>,
        user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] UML fixes
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit a798c10faf62a505d24e5f6213fbaf904a39623f:

  Linux 3.15-rc2 (2014-04-20 11:08:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git for-linus

for you to fetch changes up to a8c60be4f1bb3a4eead20e3fa19ce645f818014a:

  um: Memory corruption on startup (2014-04-20 23:13:36 +0200)

----------------------------------------------------------------
Assorted fixes for UML.
----------------------------------------------------------------
Anton Ivanov (2):
      um: Missing pipe handling
      um: Memory corruption on startup

Tristan Schmelcher (1):
      uml: Simplify tempdir logic.

 arch/um/include/shared/os.h |   1 +
 arch/um/kernel/physmem.c    |   1 +
 arch/um/os-Linux/file.c     |   6 +
 arch/um/os-Linux/main.c     |   1 +
 arch/um/os-Linux/mem.c      | 372 +++++++++-----------------------------------
 5 files changed, 84 insertions(+), 297 deletions(-)

Thanks,
//richard
