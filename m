Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968278Ab3DSLAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 07:00:52 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34987 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968122Ab3DSLAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 07:00:50 -0400
Date: Fri, 19 Apr 2013 13:00:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: X86 ML <x86@kernel.org>, linux-edac <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [GIT PULL] amd64_edac: Add Family 16h support
Message-ID: <20130419110042.GC21981@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Mailer: git-send-email 1.8.2.135.g7b592fa
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

please pull the below tag to receive AMD F16h support for amd64_edac.

Thanks.

The following changes since commit 41ef2d5678d83af030125550329b6ae8b74618fa:

  Linux 3.9-rc7 (2013-04-14 17:45:16 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/edac_amd_f16h

for you to fetch changes up to 94c1acf2c85b03a59a42d931a94a13a76c123a62:

  amd64_edac: Add Family 16h support (2013-04-19 12:46:50 +0200)

----------------------------------------------------------------
Add required support for AMD F16h to amd64_edac.

----------------------------------------------------------------
Aravind Gopalakrishnan (1):
      amd64_edac: Add Family 16h support

 arch/x86/kernel/amd_nb.c  |  3 ++-
 drivers/edac/amd64_edac.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/edac/amd64_edac.h |  4 +++-
 include/linux/pci_ids.h   |  2 ++
 4 files changed, 71 insertions(+), 3 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

