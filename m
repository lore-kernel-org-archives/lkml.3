Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaGLUnd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 16:43:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaGLUna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 16:43:30 -0400
Date: Sat, 12 Jul 2014 13:48:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB driver fixes for 3.16-rc5
Message-ID: <20140712204800.GA27384@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cd3de83f147601356395b57a8673e9c5ff1e59d1:

  Linux 3.16-rc4 (2014-07-06 12:37:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.16-rc5

for you to fetch changes up to eb82a3d846fab00c4b9ad6bbe5ade4fa5febc0af:

  phy: omap-usb2: Balance pm_runtime_enable() on probe failure and remove (2014-07-11 18:23:50 -0700)

----------------------------------------------------------------
USB fixes for 3.16-rc5

Here are some small USB fixes, PHY driver fixes (they ended up in this
tree for lack of somewhere else to put them), and some new USB device
ids.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Andras Kovacs (1):
      USB: cp210x: add support for Corsair usb dongle

Bernd Wachter (1):
      usb: option: Add ID for Telewell TW-LTE 4G v2

Bert Vermeulen (1):
      USB: ftdi_sio: Add extra PID.

Greg Kroah-Hartman (1):
      Merge tag 'usb-serial-3.16-rc5' of git://git.kernel.org/.../johan/usb-serial into usb-linus

Himangi Saraogi (1):
      phy: omap-usb2: fix devm_ioremap_resource error detection code

Maxime Ripard (1):
      phy: sun4i: depend on RESET_CONTROLLER

Michal Sojka (1):
      USB: serial: ftdi_sio: Add Infineon Triboard

Roger Quadros (2):
      phy: core: Fix error path in phy_create()
      phy: omap-usb2: Balance pm_runtime_enable() on probe failure and remove

Sjoerd Simons (1):
      drivers: phy: phy-samsung-usb2.c: Add missing MODULE_DEVICE_TABLE

 drivers/phy/Kconfig               |  1 +
 drivers/phy/phy-core.c            |  7 ++++---
 drivers/phy/phy-omap-usb2.c       | 11 +++++++----
 drivers/phy/phy-samsung-usb2.c    |  1 +
 drivers/usb/serial/cp210x.c       |  1 +
 drivers/usb/serial/ftdi_sio.c     |  5 ++++-
 drivers/usb/serial/ftdi_sio_ids.h |  9 ++++++++-
 drivers/usb/serial/option.c       |  2 ++
 8 files changed, 28 insertions(+), 9 deletions(-)
