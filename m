Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab3LNMVe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 07:21:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372Ab3LNMVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 07:21:33 -0500
Date: Sat, 14 Dec 2013 13:21:17 +0100
From: Borislav Petkov <bp@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] EDAC fix for 3.13
Message-ID: <20131214122117.GA28904@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull this annoyance fix.

Thanks.

The following changes since commit dc1ccc48159d63eca5089e507c82c7d22ef60839:

  Linux 3.13-rc2 (2013-11-29 12:57:14 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/edac_fixes_for_3.13

for you to fetch changes up to bd4b9683623d0d91e87cf22f09008c05f56d7483:

  sb_edac: Shut up compiler warning when EDAC_DEBUG is enabled (2013-11-30 12:26:36 +0100)

----------------------------------------------------------------
Silence a compiler warning in sb_edac.

----------------------------------------------------------------
Aristeu Rozanski (1):
      sb_edac: Shut up compiler warning when EDAC_DEBUG is enabled

 drivers/edac/sb_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
