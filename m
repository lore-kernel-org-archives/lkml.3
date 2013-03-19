Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934440Ab3CSWpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:45:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933289Ab3CSWpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:45:17 -0400
Message-ID: <1363733113.24132.480.camel@bling.home>
Subject: [GIT PULL] vfio fix for 3.9-rc4
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Date: Tue, 19 Mar 2013 16:45:13 -0600
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull for the next rc.  Thanks!

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v3.9-rc4

for you to fetch changes up to 25e9789ddd9d14a8971f4a421d04f282719ab733:

  vfio: include <linux/slab.h> for kmalloc (2013-03-15 12:58:20 -0600)

----------------------------------------------------------------
vfio fix for v3.9-rc4

----------------------------------------------------------------
Arnd Bergmann (1):
      vfio: include <linux/slab.h> for kmalloc

 drivers/vfio/pci/vfio_pci_config.c | 1 +
 drivers/vfio/pci/vfio_pci_intrs.c  | 1 +
 2 files changed, 2 insertions(+)


