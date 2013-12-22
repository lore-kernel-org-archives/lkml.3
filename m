Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab3LVNQi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 08:16:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43239 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290Ab3LVNQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 08:16:37 -0500
Date: Sun, 22 Dec 2013 14:16:29 +0100
From: Borislav Petkov <bp@suse.de>
To: x86-ml <x86@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] RAS for 3.14, p2
Message-ID: <20131222131629.GA32701@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

this is a second set of smallish stuff for 3.14.

Please pull.

Thanks.

--
The following changes since commit 42139eb356e3384759ca143ae04d82376346eb4c:

  ACPI, eMCA: Combine eMCA/EDAC event reporting priority (2013-12-11 19:04:37 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/ras_for_3.14_p2

for you to fetch changes up to ca104edc17841da87850b20ab77e57fe0a99ead6:

  ACPI, APEI, GHES: Cleanup ghes memory error handling (2013-12-21 13:35:59 +0100)

----------------------------------------------------------------
SCI reporting for other error types not only correctable ones
+ APEI GHES cleanups

----------------------------------------------------------------
Chen, Gong (3):
      ACPI, APEI, GHES: Do not report only correctable errors with SCI
      ACPI, APEI: Cleanup alignment-aware accesses
      ACPI, APEI, GHES: Cleanup ghes memory error handling

 arch/x86/kernel/cpu/mcheck/mce-apei.c | 14 ++++++++++----
 drivers/acpi/apei/apei-base.c         |  4 ++--
 drivers/acpi/apei/einj.c              | 19 +++++++++----------
 drivers/acpi/apei/erst.c              |  2 +-
 drivers/acpi/apei/ghes.c              | 39 +++++++++++++++++++++------------------
 5 files changed, 43 insertions(+), 35 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
