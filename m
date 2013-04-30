Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634Ab3D3NI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 09:08:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760348Ab3D3NIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 09:08:25 -0400
Date: Tue, 30 Apr 2013 10:08:19 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux EDAC Mailing List <linux-edac@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [GIT PULL for v3.10-rc1] edac fixes
Message-ID: <20130430100819.524aeac3@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git linux_next

For two edac fixes:
	- i7300_edac currently reports a wrong number of DIMMs when
	  the memory controller is in single channel mode;

	- on some Sandy Bridge machines, the EDAC driver bails out
	  as one of the PCI IDs used by the driver is hidden by BIOS.
	  As the driver uses it only to detect the type of memory,
	  make it optional at the driver.

Regards,
Mauro

-	

The following changes since commit b0769891ba7baa53f270dc70d71934748beb4c5b:

  i5100_edac: convert to use simple_open() (2013-02-26 10:06:18 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git linux_next

for you to fetch changes up to de4772c621487fd4cadb4138f2481297c8e0cb0d:

  edac: sb_edac.c should not require prescence of IMC_DDRIO device (2013-04-29 10:32:40 -0300)

----------------------------------------------------------------
Mauro Carvalho Chehab (1):
      i7300_edac: Fix memory detection in single mode

Tony Luck (1):
      edac: sb_edac.c should not require prescence of IMC_DDRIO device

 drivers/edac/i7300_edac.c | 19 +++++++++++++++----
 drivers/edac/sb_edac.c    | 53 +++++++++++++++++++++++++++++------------------------
 2 files changed, 44 insertions(+), 28 deletions(-)

