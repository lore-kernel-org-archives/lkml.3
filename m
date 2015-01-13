Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbbAMMIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:08:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbbAMMIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:08:19 -0500
Date: Tue, 13 Jan 2015 13:07:13 +0100
From: Borislav Petkov <bp@suse.de>
To: x86-ml <x86@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] RAS update for 3.20
Message-ID: <20150113120713.GA5784@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

please queue this for 3.20.

Thanks.

---
The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/ras_for_3.20

for you to fetch changes up to 83737691e586cd2767fa4fc87cd41251d1a49e9e:

  x86, mce: Fix sparse errors (2014-12-22 21:04:31 +0100)

----------------------------------------------------------------
Nothing special this time, just an error messages improvement from Andy
and a cleanup from me.

----------------------------------------------------------------
Andy Lutomirski (1):
      x86, mce: Improve timeout error messages

Borislav Petkov (1):
      x86, mce: Fix sparse errors

 arch/x86/kernel/cpu/mcheck/mce.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
