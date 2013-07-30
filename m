Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab3G3SzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:55:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756758Ab3G3SzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:55:04 -0400
Message-ID: <1375210502.31262.45.camel@ul30vt.home>
Subject: [GIT PULL] VFIO fixes for v3.11-rc4
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Date: Tue, 30 Jul 2013 12:55:02 -0600
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:

  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)

are available in the git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v3.11-rc4

for you to fetch changes up to d24cdbfd28b7e0ffecb1e281d73e73c03a57f734:

  vfio-pci: Avoid deadlock on remove (2013-07-24 16:36:41 -0600)

----------------------------------------------------------------
vfio: misc fixes around overreacting to bus notifier events and
      a locking fix for a corner case blocked remove.

----------------------------------------------------------------
Alex Williamson (3):
      vfio: Don't overreact to DEL_DEVICE
      vfio: Ignore sprurious notifies
      vfio-pci: Avoid deadlock on remove

 drivers/vfio/pci/vfio_pci.c | 23 +++++++++++++++++++++--
 drivers/vfio/vfio.c         | 37 ++++++++++---------------------------
 2 files changed, 31 insertions(+), 29 deletions(-)

