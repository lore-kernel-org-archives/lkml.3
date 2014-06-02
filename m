Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbaFBJUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:20:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbaFBJUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:20:17 -0400
Date: Mon, 2 Jun 2014 11:20:04 +0200
From: Borislav Petkov <bp@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-edac <linux-edac@vger.kernel.org>
Subject: [GIT PULL] EDAC queue for 3.16
Message-ID: <20140602092004.GA15268@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

just two minor things this time. We have more in the pipe but we didn't
get ready in time so more stuff next time.

Please pull,
thanks.

---
The following changes since commit 89ca3b881987f5a4be4c5dbaa7f0df12bbdde2fd:

  Linux 3.15-rc4 (2014-05-04 18:14:42 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/edac_for_3.16

for you to fetch changes up to aa2064d7dd35ac5812645780d2f22a7899e7c6e1:

  EDAC: Fix MC scrub mode comparsion bug for correctable errors (2014-05-09 09:35:04 +0200)

----------------------------------------------------------------
Two small fixlets.

----------------------------------------------------------------
Borislav Petkov (1):
      EDAC, MCE, AMD: Remove leftover unused mask

Loc Ho (1):
      EDAC: Fix MC scrub mode comparsion bug for correctable errors

 drivers/edac/edac_mc.c | 2 +-
 drivers/edac/mce_amd.c | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
