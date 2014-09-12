Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaILSUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:20:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaILSUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:20:32 -0400
Date: Fri, 12 Sep 2014 11:20:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB driver fixes for 3.17-rc5
Message-ID: <20140912182031.GA1770@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 69e273c0b0a3c337a521d083374c918dc52c666f:

  Linux 3.17-rc3 (2014-08-31 18:23:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.17-rc5

for you to fetch changes up to e2c60989dc7e9c6fd28d234f70501a8c93c726aa:

  Merge tag 'fixes-for-v3.17-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-linus (2014-09-11 15:08:14 -0700)

----------------------------------------------------------------
USB fixes for 3.17-rc5

Here are some USB and PHY fixes for 3.17-rc5.

Nothing major here, just a number of tiny fixes for reported issues, and
some new device ids as well.

All have been tested in linux-next.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Al Cooper (1):
      usb: xhci: Fix OOPS in xhci error handling code

Alan Stern (1):
      USB: document the 'u' flag for usb-storage quirks parameter

Bin Liu (1):
      usb: musb: cppi41: fix not transmitting zero length packet issue

Bjørn Mork (2):
      USB: sierra: avoid CDC class functions on "68A3" devices
      USB: sierra: add 1199:68AA device ID

Felipe Balbi (5):
      usb: dwc3: core: fix order of PM runtime calls
      usb: dwc3: core: fix ordering for PHY suspend
      usb: dwc3: omap: fix ordering for runtime pm calls
      usb: dwc3: fix TRB completion when multiple TRBs are started
      usb: host: xhci: fix compliance mode workaround

Greg Kroah-Hartman (4):
      Merge tag 'for-3.17-rc' of git://git.kernel.org/.../kishon/linux-phy into usb-linus
      Merge tag 'fixes-for-v3.17-rc3' of git://git.kernel.org/.../balbi/usb into usb-linus
      Merge tag 'usb-serial-3.17-rc4' of git://git.kernel.org/.../johan/usb-serial into usb-linus
      Merge tag 'fixes-for-v3.17-rc4' of git://git.kernel.org/.../balbi/usb into usb-linus

Hans de Goede (2):
      uas: Disable uas on ASM1051 devices
      uas: Add missing le16_to_cpu calls to asm1051 / asm1053 usb-id check

Ivan T. Ivanov (2):
      usb: chipidea: msm: Use USB PHY API to control PHY state
      usb: chipidea: msm: Initialize PHY on reset event

Joe Lawrence (1):
      usb: hub: take hub->hdev reference when processing from eventlist

Johan Hovold (3):
      USB: zte_ev: fix removed PIDs
      USB: ftdi_sio: add support for NOVITUS Bono E thermal printer
      USB: zte_ev: fix removed PIDs

Kamil Debski (3):
      MAINTAINERS: add entry for the Samsung USB2 PHY driver
      usb: dwc2/gadget: fix phy disable sequence
      usb: dwc2/gadget: fix phy initialization sequence

Lee Jones (1):
      phy: miphy365x: Select GENERIC_PHY instead of depending on it

Marek Szyprowski (3):
      usb: dwc2/gadget: break infinite loop in endpoint disable code
      usb: dwc2/gadget: do not call disconnect method in pullup
      usb: dwc2/gadget: delay enabling irq once hardware is configured properly

Mark (1):
      storage: Add single-LUN quirk for Jaz USB Adapter

Mathias Nyman (2):
      xhci: Fix null pointer dereference if xhci initialization fails
      xhci: fix oops when xhci resumes from hibernate with hw lpm capable devices

Peter Chen (2):
      usb: phy: mxs: add imx6sx support
      doc: dt: mxs-phy: add compatible string for imx6sx-usbphy

Piotr Król (1):
      usb: usbip: fix usbip.h path in userspace tool

Rasmus Villemoes (1):
      usb: gadget: fusb300_udc.h: Fix typo in include guard

Ricardo Ribalda Delgado (1):
      usb: gadget: net2280: Fix invalid handling of Reset irq

Robert Baldyga (2):
      usb: gadget: f_fs: fix the redundant ep files problem
      usb: dwc2/gadget: avoid disabling ep0

Sjoerd Simons (1):
      phy: exynos5-usbdrd: Add MODULE_DEVICE_TABLE entry

Taylor Braun-Jones (1):
      USB: ftdi_sio: Add support for GE Healthcare Nemo Tracker device

Thierry Reding (1):
      usb: phy: tegra: Avoid use of sizeof(void)

Thomas Pugliese (1):
      uwb: init beacon cache entry before registering uwb device

Tony Lindgren (2):
      usb: phy: twl4030-usb: Fix regressions to runtime PM on omaps
      usb: phy: twl4030-usb: Fix lost interrupts after ID pin goes down

Yoshihiro Shimoda (4):
      usb: renesas_usbhs: fix the behavior of some usbhs_pkt_handle
      usb: renesas_usbhs: protect mod->irq_{bemp,brdy}sts by spin lock
      usb: renesas_usbhs: fix the condition of is_done in usbhsf_dma_push_done
      usb: renesas_usbhs: fix the usb_pkt_pop()

Zhuang Jin Can (1):
      usb: dwc3: gadget: Fix desc NULL pointer in dwc3_gadget_ep_queue()

 Documentation/devicetree/bindings/usb/mxs-phy.txt |   1 +
 Documentation/kernel-parameters.txt               |   1 +
 MAINTAINERS                                       |  13 +++
 drivers/phy/Kconfig                               |   2 +-
 drivers/phy/phy-exynos5-usbdrd.c                  |   1 +
 drivers/phy/phy-twl4030-usb.c                     | 121 +++++++++++++---------
 drivers/usb/chipidea/ci_hdrc_msm.c                |   7 +-
 drivers/usb/core/hub.c                            |   4 +-
 drivers/usb/dwc2/gadget.c                         |  52 +++++-----
 drivers/usb/dwc3/core.c                           |  13 +--
 drivers/usb/dwc3/dwc3-omap.c                      |   2 +-
 drivers/usb/dwc3/gadget.c                         |  11 +-
 drivers/usb/gadget/function/f_fs.c                |  66 ++++++++++--
 drivers/usb/gadget/function/u_fs.h                |   2 +
 drivers/usb/gadget/udc/fusb300_udc.h              |   2 +-
 drivers/usb/gadget/udc/net2280.c                  |   2 +-
 drivers/usb/host/xhci-hub.c                       |   8 +-
 drivers/usb/host/xhci-mem.c                       |   3 +-
 drivers/usb/host/xhci.c                           |  12 ++-
 drivers/usb/musb/musb_cppi41.c                    |  17 ++-
 drivers/usb/phy/phy-mxs-usb.c                     |   8 +-
 drivers/usb/phy/phy-tegra-usb.c                   |   4 +-
 drivers/usb/renesas_usbhs/fifo.c                  |  72 +++++++++++--
 drivers/usb/renesas_usbhs/mod.c                   |   5 +
 drivers/usb/renesas_usbhs/pipe.c                  |  13 +++
 drivers/usb/renesas_usbhs/pipe.h                  |   4 +
 drivers/usb/serial/ftdi_sio.c                     |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                 |  12 +++
 drivers/usb/serial/sierra.c                       |   9 +-
 drivers/usb/serial/zte_ev.c                       |   8 ++
 drivers/usb/storage/uas-detect.h                  |  27 ++++-
 drivers/usb/storage/unusual_devs.h                |   6 ++
 drivers/uwb/lc-dev.c                              |  13 ++-
 include/uapi/linux/Kbuild                         |   1 +
 tools/usb/usbip/libsrc/usbip_common.h             |   2 +-
 35 files changed, 389 insertions(+), 138 deletions(-)
