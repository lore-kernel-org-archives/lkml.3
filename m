Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbaITReq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 13:34:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35146 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464AbaITReo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 13:34:44 -0400
Date: Sat, 20 Sep 2014 10:33:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB driver fixes for 3.17-rc6
Message-ID: <20140920173354.GA29872@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9e82bf014195d6f0054982c463575cdce24292be:

  Linux 3.17-rc5 (2014-09-14 17:50:12 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.17-rc6

for you to fetch changes up to c80b4495c61636edc58fe1ce300f09f24db28e10:

  USB: storage: Add quirks for Entrega/Xircom USB to SCSI converters (2014-09-19 15:01:38 -0700)

----------------------------------------------------------------
USB fixes / quirks for 3.17-rc6

Here are some USB and PHY fixes and quirks for 3.17-rc6.  Nothing major,
just a few things that have been reported.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (1):
      USB: EHCI: unlink QHs even after the controller has stopped

Bartlomiej Zolnierkiewicz (2):
      phy: spear1310-miphy: fix driver dependencies
      phy: spear1340-miphy: fix driver dependencies

Greg Kroah-Hartman (1):
      Merge tag 'for_3.17-rc' of git://git.kernel.org/.../kishon/linux-phy into usb-linus

Lee Jones (1):
      phy: miphy365x: Fix off-by-one error

Mark (3):
      USB: storage: Add quirk for Adaptec USBConnect 2000 USB-to-SCSI Adapter
      USB: storage: Add quirk for Ariston Technologies iConnect USB to SCSI adapter
      USB: storage: Add quirks for Entrega/Xircom USB to SCSI converters

 drivers/phy/Kconfig                |  2 ++
 drivers/phy/phy-miphy365x.c        |  1 +
 drivers/usb/host/ehci-hcd.c        |  2 --
 drivers/usb/storage/unusual_devs.h | 32 ++++++++++++++++++++++++++++++++
 4 files changed, 35 insertions(+), 2 deletions(-)
