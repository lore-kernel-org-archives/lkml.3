Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab3GAJPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:15:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33438 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab3GAJPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:15:09 -0400
Date: Mon, 1 Jul 2013 11:15:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] AMD64_EDAC queue for 3.11
Message-ID: <20130701091502.GB23515@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

just an addition of MCE signatures for new F15h models and a small
cleanup.

Please pull,
thanks.

The following changes since commit d683b96b072dc4680fc74964eca77e6a23d1fa6e:

  Linux 3.10-rc4 (2013-06-02 17:11:17 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/edac_for_3.11

for you to fetch changes up to aad19e51769d761ffc0608b381313e18f0bd82b3:

  EDAC, MCE, AMD: Add an MCE signature for new Fam15h models (2013-06-08 10:17:03 +0200)

----------------------------------------------------------------
Add MCE signatures for family 0x15, models 30-3f.

----------------------------------------------------------------
Aravind Gopalakrishnan (1):
      EDAC, MCE, AMD: Add an MCE signature for new Fam15h models

Jingoo Han (1):
      EDAC: Replace strict_strtoul() with kstrtoul()

 drivers/edac/amd64_edac_inj.c | 10 +++++-----
 drivers/edac/edac_mc_sysfs.c  |  2 +-
 drivers/edac/i7core_edac.c    | 10 +++++-----
 drivers/edac/mce_amd.c        |  5 +++--
 drivers/edac/mce_amd_inj.c    |  4 ++--
 5 files changed, 16 insertions(+), 15 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
