Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935868Ab3DITGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:06:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935760Ab3DITF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:05:58 -0400
Message-ID: <1365534355.16420.160.camel@bling.home>
Subject: [GIT PULL] vfio fix for 3.9-rc7
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 09 Apr 2013 13:05:55 -0600
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's one small fix for vfio that I'd like to get in for 3.9;
tightening the range checking around a vfio ioctl.  Thanks!

Alex

The following changes since commit 25e9789ddd9d14a8971f4a421d04f282719ab733:

  vfio: include <linux/slab.h> for kmalloc (2013-03-15 12:58:20 -0600)

are available in the git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v3.9-rc7

for you to fetch changes up to 904c680c7bf016a8619a045850937427f8d7368c:

  vfio-pci: Fix possible integer overflow (2013-03-26 11:33:16 -0600)

----------------------------------------------------------------
vfio overflow fix for v3.9-rc7

----------------------------------------------------------------
Alex Williamson (1):
      vfio-pci: Fix possible integer overflow

 drivers/vfio/pci/vfio_pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


