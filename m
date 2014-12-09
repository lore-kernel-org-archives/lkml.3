Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbaLIQbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:31:55 -0500
Received: from lists.s-osg.org ([54.187.51.154]:50336 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbaLIQbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:31:53 -0500
Date: Tue, 9 Dec 2014 14:31:33 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        EDAC Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.19-rc1] edac updates
Message-ID: <20141209143133.3f652950@recife.lan>
Organization: Samsung
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac tags/edac/v3.19-rc1

For:
  - Broadwell-DE support on sb-edac driver;
  - Some fixes at sb-edac driver.

Thanks!
Mauro

-

The following changes since commit 009d0431c3914de64666bec0d350e54fdd59df6a:

  Linux 3.18-rc7 (2014-11-30 16:42:27 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac tags/edac/v3.19-rc1

for you to fetch changes up to fec53af531dd040e41fe358abe00b33747af2688:

  sb_edac: Fix typo computing number of banks (2014-12-02 16:46:33 -0200)

----------------------------------------------------------------
edac updates for v3.19-rc1

----------------------------------------------------------------
Jim Snow (2):
      sb_edac: Fix off-by-one error in number of channels
      sb_edac: Fix erroneous bytes->gigabytes conversion

Tony Luck (3):
      sb_edac: Fix discovery of top-of-low-memory for Haswell
      sb_edac: Add support for Broadwell-DE processor
      sb_edac: Fix typo computing number of banks

 drivers/edac/edac_mc_sysfs.c |   2 +-
 drivers/edac/sb_edac.c       | 208 +++++++++++++++++++++++++++++++++++++------
 2 files changed, 182 insertions(+), 28 deletions(-)

