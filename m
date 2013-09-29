Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab3I2UCH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 16:02:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab3I2UCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 16:02:03 -0400
Date: Sun, 29 Sep 2013 13:02:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] Staging driver fixes for 3.12-rc3
Message-ID: <20130929200204.GA31117@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:

  Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.12-rc3

for you to fetch changes up to df3f4edc6ca6e7768376d05eb99536bcf92362f0:

  staging: r8188eu: Add new device ID (2013-09-26 16:44:45 -0700)

----------------------------------------------------------------
Staging fixes for 3.12-rc3

Here are some staging driver fixes, MAINTAINER updates, and a new device
id.  All of these have been in the linux-next tree, and are pretty
simple patches.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Fabio Estevam (1):
      staging: imx-drm: Fix probe failure

Iker Pedrosa (1):
      Staging: rtl8192u: r819xU_cmdpkt: checking NULL value after doing dev_alloc_skb

Larry Finger (1):
      staging: r8188eu: Add new device ID

Lidza Louina (1):
      MAINTAINERS: staging: dgnc and dgap drivers: add maintainer

Malcolm Priestley (3):
      staging: vt6656: rxtx.c [BUG] s_vGetFreeContext dead lock on null apTD.
      staging: vt6656: [BUG] main_usb.c oops on device_close move flag earlier.
      staging: vt6656: [BUG] iwctl_siwencodeext return if device not open

Thomas Meyer (5):
      staging: lustre: Cocci spatch "noderef"
      staging: r8188eu: Add files for new drive: Cocci spatch "noderef"
      staging: octeon-usb: Cocci spatch "noderef"
      staging: r8188eu: Cocci spatch "noderef"
      staging: r8188eu: Add files for new drive: Cocci spatch "noderef"

Tobias Polzer (1):
      staging: usbip: Orphan usbip

 MAINTAINERS                                         | 15 +++++++++++++--
 drivers/staging/imx-drm/imx-drm-core.c              | 11 +++--------
 drivers/staging/lustre/lustre/obdecho/echo_client.c |  2 +-
 drivers/staging/octeon-usb/cvmx-usb.c               |  2 +-
 drivers/staging/rtl8188eu/core/rtw_mp.c             |  2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_dm.c         |  2 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c      |  2 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c         |  1 +
 drivers/staging/rtl8192u/r819xU_cmdpkt.c            |  2 ++
 drivers/staging/vt6656/iwctl.c                      |  3 +++
 drivers/staging/vt6656/main_usb.c                   |  3 ++-
 drivers/staging/vt6656/rxtx.c                       |  2 ++
 12 files changed, 31 insertions(+), 16 deletions(-)
