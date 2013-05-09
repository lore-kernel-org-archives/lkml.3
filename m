Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab3EIKs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 06:48:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39955 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468Ab3EIKsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 06:48:25 -0400
Date: Thu, 9 May 2013 12:51:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Two small EDAC fixes
Message-ID: <20130509105123.GC27333@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull.

Thanks.

The following changes since commit 8bb9660418e05bb1845ac1a2428444d78e322cc7:

  Linux 3.9-rc4 (2013-03-23 16:52:44 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/edac_fixes_for_3.10

for you to fetch changes up to c8c64d165ccfd2274058ac84e0c680f9b48c4ec1:

  EDAC: Don't give write permission to read-only files (2013-05-09 12:40:45 +0200)

----------------------------------------------------------------
Two small EDAC fixes.

----------------------------------------------------------------
Borislav Petkov (1):
      EDAC, mc_sysfs.c: Fix string array pointer types

Srivatsa S. Bhat (1):
      EDAC: Don't give write permission to read-only files

 drivers/edac/edac_mc_sysfs.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
