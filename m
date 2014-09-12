Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaILSV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:21:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaILSV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:21:26 -0400
Date: Fri, 12 Sep 2014 11:21:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fixes for 3.17-rc5
Message-ID: <20140912182125.GA2099@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 69e273c0b0a3c337a521d083374c918dc52c666f:

  Linux 3.17-rc3 (2014-08-31 18:23:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.17-rc5

for you to fetch changes up to 3ea411c56ef58a1827cf06fdcdeb14fa9265be09:

  android: fix reference leak in sync_fence_create (2014-09-08 13:42:00 -0700)

----------------------------------------------------------------
Staging driver fixes for 3.17-rc5

Here are 3 tiny staging driver fixes for 3.17-rc5.  Two are fixes for
the imx-drm driver, resolving issues that have been reported.  The other
is a memory leak fix for the Android sync driver, due to changes that
went into 3.17-rc1.

All have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Maarten Lankhorst (1):
      android: fix reference leak in sync_fence_create

Russell King (2):
      imx-drm: ipuv3-plane: fix ipu_plane_dpms()
      imx-drm: imx-ldb: fix NULL pointer in imx_ldb_unbind()

 drivers/staging/android/sync.c        | 1 -
 drivers/staging/imx-drm/imx-ldb.c     | 3 +++
 drivers/staging/imx-drm/ipuv3-plane.c | 3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)
