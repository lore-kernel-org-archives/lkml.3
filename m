Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab3BSMPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:15:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57723 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932704Ab3BSMPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:15:04 -0500
Date: Tue, 19 Feb 2013 13:14:59 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] AMD64_EDAC stuff for 3.9
Message-ID: <20130219121459.GC26623@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-edac <linux-edac@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following updates for (mostly) AMD's side of EDAC. It is
basically a new family enablement stuff - the rest is trivial cleanups.

Thanks.

The following changes since commit 7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619:

  Linux 3.8-rc4 (2013-01-17 19:25:45 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/edac_3.9

for you to fetch changes up to e7d2c215e56dc9fa0a01e26f2acfc3d73c889ba3:

  mpc85xx_edac: Fix typo (2013-02-10 13:28:41 +0100)

----------------------------------------------------------------
EDAC updates for 3.9

Only one: AMD F16h MCE decoding enablement from Jacob Shin.

----------------------------------------------------------------
Baruch Siach (1):
      mpc85xx_edac: Fix typo

Borislav Petkov (2):
      amd64_edac: Remove dead code
      EDAC, MCE, AMD: Remove unneeded exports

Jacob Shin (2):
      EDAC, MCE, AMD: Make MC2 decoding per-family
      EDAC, MCE, AMD: Add MCE decoding support for Family 16h

 drivers/edac/amd64_edac.c   | 105 ------------------------------------------------------------------
 drivers/edac/mce_amd.c      | 166 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------
 drivers/edac/mce_amd.h      |  13 ++++-----
 drivers/edac/mpc85xx_edac.c |   4 +--
 4 files changed, 120 insertions(+), 168 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
