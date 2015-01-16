Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbbAPSd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 13:33:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbbAPSd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 13:33:56 -0500
Date: Fri, 16 Jan 2015 10:33:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB driver fixes for 3.19-rc5
Message-ID: <20150116183355.GA28250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b7392d2247cfe6771f95d256374f1a8e6a6f48d6:

  Linux 3.19-rc2 (2014-12-28 16:49:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.19-rc5

for you to fetch changes up to f8359dae68bd29ed7b3f91971e361801442c7b9b:

  Merge tag 'fixes-for-v3.19-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-linus (2015-01-14 16:27:23 -0800)

----------------------------------------------------------------
USB fixes for 3.19-rc5

Here is a bunch of USB fixes for 3.19-rc5.

Most of these are gadget driver fixes, along with the xhci driver fix
that we both reported having problems with, as well as some new device
ids and other tiny fixes.

All have been in linux-next with no problems.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (2):
      USB: EHCI: fix initialization bug in iso_stream_schedule()
      USB: EHCI: adjust error return code

Amit Virdi (2):
      usb: dwc3: gadget: Fix TRB preparation during SG
      usb: dwc3: gadget: Stop TRB preparation after limit is reached

Arnd Bergmann (1):
      usb: phy: mv-usb: fix usb_phy build errors

Arseny Solokha (1):
      OHCI: add a quirk for ULi M5237 blocking on reset

Bo Shen (2):
      usb: gadget: udc: atmel: change setting for DMA
      usb: gadget: udc: atmel: fix possible IN hang issue

Dan Carpenter (2):
      phy: miphy28lp: unlock on error in miphy28lp_init()
      usb: gadget: gadgetfs: fix an oops in ep_write()

Darrick J. Wong (1):
      uas: disable UAS on Apricorn SATA dongles

David Peterson (1):
      USB: cp210x: add IDs for CEL USB sticks and MeshWorks devices

Felipe Balbi (2):
      usb: musb: debugfs: cope with blackfin's oddities
      usb: musb: blackfin: fix build break

Greg Kroah-Hartman (5):
      Merge tag 'fixes-for-v3.19-rc2' of git://git.kernel.org/.../balbi/usb into usb-linus
      Merge tag 'for-3.19-rc' of git://git.kernel.org/.../kishon/linux-phy into usb-linus
      Merge tag 'fixes-for-v3.19-rc5' of git://git.kernel.org/.../balbi/usb into usb-linus
      Merge tag 'usb-serial-3.19-rc5' of git://git.kernel.org/.../johan/usb-serial into usb-linus
      Merge tag 'fixes-for-v3.19-rc6' of git://git.kernel.org/.../balbi/usb into usb-linus

Hans de Goede (6):
      phy-sun4i-usb: Change disconnect threshold value for sun6i
      xhci: Add broken-streams quirk for Fresco Logic FL1000G xhci controllers
      uas: Add US_FL_NO_ATA_1X for Seagate devices with usb-id 0bc2:a013
      uas: Add US_FL_NO_REPORT_OPCODES for JMicron JMS566 with usb-id 0bc2:a013
      uas: Do not blacklist ASM1153 disk enclosures
      uas: Add US_FL_NO_ATA_1X for 2 more Seagate disk enclosures

Heikki Krogerus (1):
      usb: dwc3: pci: add support for Intel Sunrise Point PCH

Jeremiah Mahler (2):
      usb: serial: silence all non-critical read errors
      usb: serial: handle -ENODEV quietly in generic_submit_read_urb

Johan Hovold (3):
      USB: keyspan: fix null-deref at probe
      USB: console: fix uninitialised ldisc semaphore
      USB: console: fix potential use after free

John W. Linville (1):
      usb: gadget: udc: avoid dereference before NULL check in ep_queue

Julia Lawall (1):
      usb: gadget: fix misspelling of current function in string

Mario Schuknecht (1):
      usb: gadget: gadgetfs: Free memory allocated by memdup_user()

Mathias Nyman (1):
      xhci: Check if slot is already in default state before moving it there

Maxime Ripard (1):
      usb: phy: Fix deferred probing

Peter Chen (2):
      usb: gadget: f_uac1: access freed memory at f_audio_free_inst
      Revert "usb: chipidea: remove duplicate dev_set_drvdata for host_start"

Preston Fick (1):
      USB: cp210x: fix ID for production CEL MeshConnect USB Stick

Rasmus Villemoes (1):
      usb: musb: Fix a few off-by-one lengths

Reinhard Speyerer (1):
      USB: qcserial/option: make AT URCs work for Sierra Wireless MC73xx

Robert Baldyga (1):
      usb: dwc2: gadget: kill requests with 'force' in s3c_hsotg_udc_stop()

Sebastian Andrzej Siewior (1):
      usb: musb: stuff leak of struct usb_hcd

Songjun Wu (1):
      usb: gadget: udc: atmel: fix possible oops when unloading module

Thierry Reding (1):
      usb: phy: Restore deferred probing path

Tony Lindgren (1):
      usb: musb: Fix randconfig build issues for Kconfig options

Vignesh R (1):
      phy: phy-ti-pipe3: fix inconsistent enumeration of PCIe gen2 cards

Vince Hsu (1):
      usb: host: ehci-tegra: request deferred probe when failing to get phy

 drivers/phy/phy-miphy28lp.c             |  3 ++-
 drivers/phy/phy-omap-control.c          |  7 +++--
 drivers/phy/phy-sun4i-usb.c             |  3 ++-
 drivers/phy/phy-ti-pipe3.c              | 10 ++++---
 drivers/usb/chipidea/core.c             |  2 +-
 drivers/usb/chipidea/host.c             |  1 +
 drivers/usb/dwc2/gadget.c               | 10 ++++---
 drivers/usb/dwc3/dwc3-pci.c             |  4 +++
 drivers/usb/dwc3/gadget.c               |  6 +++--
 drivers/usb/gadget/function/f_hid.c     |  5 ++--
 drivers/usb/gadget/function/f_midi.c    |  2 +-
 drivers/usb/gadget/function/f_uac1.c    |  2 +-
 drivers/usb/gadget/legacy/inode.c       |  2 ++
 drivers/usb/gadget/udc/atmel_usba_udc.c | 19 ++++++++++----
 drivers/usb/gadget/udc/bdc/bdc_ep.c     |  3 ++-
 drivers/usb/host/ehci-sched.c           | 14 +++++-----
 drivers/usb/host/ehci-tegra.c           |  2 +-
 drivers/usb/host/pci-quirks.c           | 18 ++++++++++---
 drivers/usb/host/xhci-pci.c             |  2 ++
 drivers/usb/host/xhci.c                 |  9 +++++++
 drivers/usb/musb/Kconfig                |  4 +++
 drivers/usb/musb/blackfin.c             |  2 +-
 drivers/usb/musb/musb_cppi41.c          |  4 +--
 drivers/usb/musb/musb_debugfs.c         | 34 ++++++++++++------------
 drivers/usb/musb/musb_host.c            |  1 -
 drivers/usb/phy/phy-mv-usb.c            |  5 ++--
 drivers/usb/phy/phy.c                   | 16 ++++++++----
 drivers/usb/serial/console.c            | 16 ++++++++----
 drivers/usb/serial/cp210x.c             |  4 ++-
 drivers/usb/serial/generic.c            |  4 +--
 drivers/usb/serial/keyspan.c            | 20 ++++++++++----
 drivers/usb/serial/option.c             | 11 +++++++-
 drivers/usb/serial/qcserial.c           |  1 -
 drivers/usb/storage/uas-detect.h        | 33 +++++++++++++++++++----
 drivers/usb/storage/unusual_uas.h       | 46 +++++++++++++++++++++++++++------
 include/linux/phy/omap_control_phy.h    |  6 ++---
 36 files changed, 235 insertions(+), 96 deletions(-)
