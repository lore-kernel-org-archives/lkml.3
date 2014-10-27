Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaJ0Oco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:32:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53448 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbaJ0Ocm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:32:42 -0400
Date: Mon, 27 Oct 2014 15:32:37 +0100
From: Borislav Petkov <bp@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jason Baron <jbaron@akamai.com>, linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] EDAC fixes for 3.18
Message-ID: <20141027143236.GA4741@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull a bunch of fixes from Jason.

Thanks.

---
The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/edac_fixes_for_3.18

for you to fetch changes up to 8030122a9ccf939186f8db96c318dbb99b5463f6:

  e7xxx_edac: Report CE events properly (2014-10-22 22:59:00 +0200)

----------------------------------------------------------------
Correct severity of reported errors in several EDAC drivers. From Jason
Baron.

----------------------------------------------------------------
Jason Baron (4):
      i3200_edac: Report CE events properly
      i82860_edac: Report CE events properly
      cpc925_edac: Report UE events properly
      e7xxx_edac: Report CE events properly

 drivers/edac/cpc925_edac.c | 2 +-
 drivers/edac/e7xxx_edac.c  | 2 +-
 drivers/edac/i3200_edac.c  | 4 ++--
 drivers/edac/i82860_edac.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
