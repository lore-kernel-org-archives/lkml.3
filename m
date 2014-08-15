Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbaHOV5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 17:57:12 -0400
Received: from mail-yk0-f174.google.com ([209.85.160.174]:57474 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaHOV5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 17:57:10 -0400
MIME-Version: 1.0
Date: Fri, 15 Aug 2014 17:57:09 -0400
X-Google-Sender-Auth: 4PAYRPYUm7e9gDkO1Ow9gv-Pat8
Message-ID: <CAJvTdKmLR5NjnN7+KhUpw=dSrghyUtLDmmeosvFyGHpDtRsjWA@mail.gmail.com>
Subject: GIT Pull: idle patches for Linux-3.17 merge
From: Len Brown <lenb@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these idle power patches.

two Intel-platform-specific updates to intel_idle,
and a cosmetic tweak to the turbostat utility.

thanks!
Len Brown, Intel Open Source Technology Center

The following changes since commit 19583ca584d6f574384e17fe7613dfaeadcdc4a6:

  Linux 3.16 (2014-08-03 15:25:02 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git release

for you to fetch changes up to e7c95ff32d0075736cbdd8d38d954fb4ed6ced9b:

  tools/power turbostat: tweak whitespace in output format (2014-08-15
17:34:44 -0400)

----------------------------------------------------------------
Len Brown (3):
      intel_idle: Disable Baytrail Core and Module C6 auto-demotion
      intel_idle: Broadwell support
      tools/power turbostat: tweak whitespace in output format

 arch/x86/include/uapi/asm/msr-index.h |  3 ++
 drivers/idle/intel_idle.c             | 77 ++++++++++++++++++++++++++++++++-
 tools/power/x86/turbostat/turbostat.c | 80 +++++++++++++++++------------------
 3 files changed, 119 insertions(+), 41 deletions(-)
