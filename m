Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab3AUXph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 18:45:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab3AUXpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 18:45:34 -0500
Message-ID: <1358811932.11144.109.camel@bling.home>
Subject: [GIT PULL] VFIO fix for v3.8-rc5
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Date: Mon, 21 Jan 2013 16:45:32 -0700
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 406089d01562f1e2bf9f089fd7637009ebaad589:

  Merge tag 'trace-3.8-rc3-regression-fix' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace (2013-01-14 20:22:16 -0800)

are available in the git repository at:


  git://github.com/awilliam/linux-vfio.git tags/vfio-for-v3.8-rc5

for you to fetch changes up to ec1287e511320a2c9a02640b7ac02d5d79f56f08:

  vfio-pci: Fix buffer overfill (2013-01-15 10:45:26 -0700)

----------------------------------------------------------------
vfio fixes for v3.8-rc5

----------------------------------------------------------------
Alex Williamson (1):
      vfio-pci: Fix buffer overfill

 drivers/vfio/pci/vfio_pci_rdwr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


