Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab3FHI3G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 04:29:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55566 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab3FHI3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 04:29:04 -0400
Date: Sat, 8 Jun 2013 10:28:44 +0200
From: Borislav Petkov <bp@alien8.de>
To: x86-ml <x86@kernel.org>
Cc: Mathias Krause <minipli@googlemail.com>, Tony Luck <tony.luck@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] RAS: Fix typos
Message-ID: <20130608082844.GB13596@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

please pull.

Thanks.

The following changes since commit d683b96b072dc4680fc74964eca77e6a23d1fa6e:

  Linux 3.10-rc4 (2013-06-02 17:11:17 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/ras_fixlet_for_3.11

for you to fetch changes up to a90936845da138209aa5dda0c84269f7482aa3cf:

  x86, mce: Fix "braodcast" typo (2013-06-05 11:59:17 +0200)

----------------------------------------------------------------
Fix typo in define

----------------------------------------------------------------
Mathias Krause (1):
      x86, mce: Fix "braodcast" typo

 arch/x86/include/asm/mce.h              | 2 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
