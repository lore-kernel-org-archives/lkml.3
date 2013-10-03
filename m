Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab3JCEVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:21:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab3JCEUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:20:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/57] 3.11.4-stable review
Date: Wed,  2 Oct 2013 21:08:26 -0700
Message-Id: <20131003040636.600441214@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.11.4 release.
There are 57 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Oct  5 04:06:23 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.4-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.11.4-rc1

Ben Hutchings <ben@decadent.org.uk>
    irq: Always define devm_{request_threaded,free}_irq()

Liam Girdwood <liam.r.girdwood@linux.intel.com>
    ALSA: compress: Fix compress device unregister.

Henrik Rydberg <rydberg@euromail.se>
    hwmon: (applesmc) Check key count before proceeding

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix hdmi audio on DCE3.0/3.1 asics

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add missing hdmi callbacks for rv6xx

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: disable tests/benchmarks if accel is disabled

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: don't set default clocks for SI when DPM is disabled

Alex Ivanov <gnidorah@p0n4ik.tk>
    drm/radeon: Make r100_cp_ring_info() and radeon_ring_gfx() safe (v2)

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: avoid UVD corruption on AGP cards using GPU gart

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/cik: fix overflow in vram fetch

Michel Dänzer <michel.daenzer@amd.com>
    drm/radeon/cik: Fix encoding of number of banks in tiling configuration info

Michel Dänzer <michel.daenzer@amd.com>
    drm/radeon/cik: Fix printing of client name on VM protection fault

Jani Nikula <jani.nikula@intel.com>
    drm/i915/dp: increase i2c-over-aux retry interval on AUX DEFER

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: preserve pipe A quirk in i9xx_set_pipeconf

Mike Snitzer <snitzer@redhat.com>
    dm mpath: disable WRITE SAME if it fails

Mikulas Patocka <mpatocka@redhat.com>
    dm-snapshot: fix performance degradation due to small hash size

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: workaround for a false positive lockdep warning

Benson Leung <bleung@chromium.org>
    driver core : Fix use after free of dev->parent in device_shutdown

Kurt Garloff <kurt@garloff.de>
    usb/core/devio.c: Don't reject control message to endpoint with wrong direction bit

David Cohen <david.a.cohen@linux.intel.com>
    usb: dwc3: add support for Merrifield

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add support for BayTrail

Ramneek Mehresh <ramneek.mehresh@freescale.com>
    fsl/usb: Resolve PHY_CLK_VLD instability issue for ULPI phy

Al Viro <viro@ZenIV.linux.org.uk>
    USB: Fix breakage in ffs_fs_mount()

Alan Stern <stern@rowland.harvard.edu>
    USB: UHCI: accept very late isochronous URBs

Alan Stern <stern@rowland.harvard.edu>
    USB: OHCI: accept very late isochronous URBs

Florian Wolter <wolly84@web.de>
    xhci: Fix race between ep halt and URB cancellation

Alan Stern <stern@rowland.harvard.edu>
    USB: fix PM config symbol in uhci-hcd, ehci-hcd, and xhci-hcd

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix oops happening after address device timeout

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Ensure a command structure points to the correct trb on the command ring

Solomon Peachy <pizza@shaftnet.org>
    cw1200: Use a threaded oneshot irq handler for cw1200_spi

Solomon Peachy <pizza@shaftnet.org>
    Revert "cw1200: Don't perform SPI transfers in interrupt context"

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915/tv: clear adjusted_mode.flags

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: [BUG] iwctl_siwencodeext return if device not open

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: [BUG] main_usb.c oops on device_close move flag earlier.

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    ARM: 7837/3: fix Thumb-2 bug in AES assembler code

Johan Hovold <jhovold@gmail.com>
    serial: pch_uart: fix tty-kref leak in dma-rx path

Johan Hovold <jhovold@gmail.com>
    serial: pch_uart: fix tty-kref leak in rx-error path

Johan Hovold <jhovold@gmail.com>
    serial: tegra: fix tty-kref leak

Peter Hurley <peter@hurleysoftware.com>
    tty: Fix SIGTTOU not sent with tcflush()

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: cancel stall timers in mei_reset

Tomas Winkler <tomas.winkler@intel.com>
    mei: bus: stop wait for read during cl state transition

Tomas Winkler <tomas.winkler@intel.com>
    mei: make me client counters less error prone

Josh Boyer <jwboyer@redhat.com>
    x86, efi: Don't map Boot Services on i386

Vinson Lee <vlee@twitter.com>
    tools lib lk: Uninclude linux/magic.h in debugfs.c

Masoud Sharbiani <msharbiani@twitter.com>
    x86/reboot: Add quirk to make Dell C6100 use reboot=pci automatically

Chuansheng Liu <chuansheng.liu@intel.com>
    kernel/reboot.c: re-enable the function of variable reboot_default

Kent Overstreet <kmo@daterainc.com>
    bcache: Fix flushes in writeback mode

Kent Overstreet <kmo@daterainc.com>
    bcache: Fix for handling overlapping extents when reading in a btree node

Kent Overstreet <kmo@daterainc.com>
    bcache: Fix a shrinker deadlock

Kent Overstreet <kmo@daterainc.com>
    bcache: Fix a dumb CPU spinning bug in writeback

Kent Overstreet <kmo@daterainc.com>
    bcache: Fix a flush/fua performance bug

Kent Overstreet <kmo@daterainc.com>
    bcache: Fix a writeback performance regression

Kent Overstreet <kmo@daterainc.com>
    bcache: Fix for when no journal entries are found

Gabriel de Perthuis <g2p.code@gmail.com>
    bcache: Strip endline when writing the label through sysfs

Kent Overstreet <kmo@daterainc.com>
    bcache: Fix a dumb journal discard bug

Lubomir Rintel <lkundrak@v3.sk>
    sysv: Add forgotten superblock lock init for v7 fs

Kent Overstreet <kmo@daterainc.com>
    block: Fix bio_copy_data()


-------------

Diffstat:

 Makefile                                 |  4 +--
 arch/arm/crypto/aes-armv4.S              |  6 ++--
 arch/x86/kernel/reboot.c                 | 16 +++++++++
 arch/x86/platform/efi/efi.c              | 11 +++---
 drivers/base/core.c                      | 14 ++++----
 drivers/gpu/drm/i915/intel_display.c     |  4 +++
 drivers/gpu/drm/i915/intel_dp.c          | 13 ++++++-
 drivers/gpu/drm/i915/intel_tv.c          |  8 +++++
 drivers/gpu/drm/radeon/cik.c             | 17 +++++----
 drivers/gpu/drm/radeon/r100.c            |  8 +++--
 drivers/gpu/drm/radeon/r600_hdmi.c       | 20 ++++++++---
 drivers/gpu/drm/radeon/radeon_asic.c     |  2 ++
 drivers/gpu/drm/radeon/radeon_cs.c       |  2 +-
 drivers/gpu/drm/radeon/radeon_device.c   | 15 ++++++--
 drivers/gpu/drm/radeon/radeon_pm.c       |  8 ++---
 drivers/gpu/drm/radeon/radeon_ring.c     |  8 +++--
 drivers/hwmon/applesmc.c                 | 11 +++++-
 drivers/md/bcache/bcache.h               |  7 ++--
 drivers/md/bcache/bset.c                 | 39 +++++++++++++++------
 drivers/md/bcache/btree.c                |  2 +-
 drivers/md/bcache/journal.c              | 33 +++++++++++-------
 drivers/md/bcache/request.c              | 15 ++++----
 drivers/md/bcache/sysfs.c                |  9 +++--
 drivers/md/bcache/util.c                 | 11 +++++-
 drivers/md/bcache/util.h                 | 12 +++++--
 drivers/md/bcache/writeback.c            | 42 +++++++++++-----------
 drivers/md/dm-mpath.c                    | 11 +++++-
 drivers/md/dm-snap-persistent.c          |  2 +-
 drivers/md/dm-snap.c                     |  5 ++-
 drivers/md/dm.c                          | 11 ++++++
 drivers/misc/mei/amthif.c                |  1 +
 drivers/misc/mei/bus.c                   |  5 ++-
 drivers/misc/mei/client.h                |  6 ++++
 drivers/misc/mei/hbm.c                   | 10 +++---
 drivers/misc/mei/init.c                  |  3 ++
 drivers/misc/mei/main.c                  | 11 +++---
 drivers/misc/mei/mei_dev.h               |  6 ++--
 drivers/net/wireless/cw1200/cw1200_spi.c | 26 ++++----------
 drivers/net/wireless/cw1200/fwio.c       |  2 +-
 drivers/net/wireless/cw1200/hwbus.h      |  1 -
 drivers/net/wireless/cw1200/hwio.c       | 15 --------
 drivers/staging/vt6656/iwctl.c           |  3 ++
 drivers/staging/vt6656/main_usb.c        |  3 +-
 drivers/tty/serial/pch_uart.c            |  5 ++-
 drivers/tty/serial/serial-tegra.c        |  4 ++-
 drivers/tty/tty_ioctl.c                  |  3 ++
 drivers/usb/core/devio.c                 | 16 +++++++++
 drivers/usb/dwc3/dwc3-pci.c              |  4 +++
 drivers/usb/gadget/f_fs.c                | 60 ++++++++++++++------------------
 drivers/usb/host/ehci-fsl.c              | 12 ++-----
 drivers/usb/host/ehci-pci.c              |  2 +-
 drivers/usb/host/ohci-hcd.c              | 22 ++++++------
 drivers/usb/host/ohci-q.c                | 26 +++++++++++---
 drivers/usb/host/uhci-pci.c              |  2 +-
 drivers/usb/host/uhci-q.c                | 12 ++++---
 drivers/usb/host/xhci-hub.c              |  2 +-
 drivers/usb/host/xhci-pci.c              |  2 +-
 drivers/usb/host/xhci-ring.c             | 24 +++++++++++--
 drivers/usb/host/xhci.c                  | 25 +++----------
 drivers/usb/host/xhci.h                  |  1 +
 fs/bio.c                                 |  4 +--
 fs/sysv/super.c                          |  1 +
 include/linux/device-mapper.h            |  3 +-
 kernel/Makefile                          |  2 +-
 kernel/irq/Makefile                      |  6 ++--
 kernel/reboot.c                          |  9 ++++-
 sound/core/compress_offload.c            |  3 +-
 tools/lib/lk/debugfs.c                   |  1 -
 68 files changed, 445 insertions(+), 264 deletions(-)


