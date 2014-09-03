Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700AbaICKJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:09:12 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57385 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756284AbaICJ46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:56:58 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 00/56] 3.12.28-stable review
Date: Wed,  3 Sep 2014 11:26:54 +0200
Message-Id: <cover.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.12.28 release.
There are 56 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Sep  5 11:17:45 CEST 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	http://kernel.org/pub/linux/kernel/people/jirislaby/stable-review/patch-3.12.28-rc1.xz
and the diffstat can be found below.

thanks,
js

===============


Alan Stern (2):
  USB: OHCI: fix bugs in debug routines
  USB: OHCI: don't lose track of EDs when a controller dies

Alex Deucher (3):
  drm/radeon: add new KV pci id
  drm/radeon: add new bonaire pci ids
  drm/radeon: add additional SI pci ids

Alexander Usyskin (1):
  mei: start disconnect request timer consistently

Andy Lutomirski (1):
  x86_64/vsyscall: Fix warn_bad_vsyscall log output

Arnd Bergmann (1):
  crypto: ux500 - make interrupt mode plausible

Axel Lin (6):
  hwmon: (sis5595) Prevent overflow problem when writing large limits
  hwmon: (amc6821) Fix possible race condition bug
  hwmon: (gpio-fan) Prevent overflow problem when writing large limits
  hwmon: (ads1015) Fix off-by-one for valid channel index checking
  hwmon: (ads1015) Fix out-of-bounds array access
  hwmon: (dme1737) Prevent overflow problem when writing large limits

Bjorn Helgaas (1):
  PCI: Add pci_upstream_bridge()

Bryan O'Donoghue (1):
  USB: ehci-pci: USB host controller support for Intel Quark X1000

Christoph Schulz (1):
  x86: don't exclude low BIOS area when allocating address space for
    non-PCI cards

Clemens Ladisch (2):
  ALSA: virtuoso: add Xonar Essence STX II support
  ALSA: usb-audio: fix BOSS ME-25 MIDI regression

Daniel Mack (1):
  usb: musb: cppi41: fire hrtimer according to programmed channel length

David Vrabel (1):
  x86/xen: resume timer irqs early

Gu Zheng (1):
  bio-integrity: add "bip_max_vcnt" into struct bio_integrity_payload

Guenter Roeck (2):
  hwmon: (lm78) Fix overflow problems seen when writing large
    temperature limits
  hwmon: (lm85) Fix various errors on attribute writes

Hui Wang (2):
  ALSA: hda - fix an external mic jack problem on a HP machine
  ALSA: hda - restore the gpio led after resume

James P Michels III (1):
  usb-core bInterval quirk

Jan Kara (1):
  isofs: Fix unbounded recursion when processing relocated directories

Jason Gunthorpe (1):
  tpm: Add missing tpm_do_selftest to ST33 I2C driver

Jeremy Vial (1):
  ARM: OMAP3: Fix choice of omap3_restore_es function in OMAP34XX
    rev3.1.2 case.

Jiang Liu (1):
  USB: core: hcd-pci: free IRQ before disabling PCI device when shutting
    down

Jiri Kosina (2):
  HID: logitech: perform bounds checking on device_id early enough
  HID: fix a couple of off-by-ones

Joonyoung Shim (1):
  USB: add reset resume quirk for usb3503

Kent Overstreet (1):
  bcache: Minor journal fix

Lee, Chun-Yi (1):
  PM / hibernate: avoid unsafe pages in e820 reserved regions

Matt Fleming (1):
  x86/efi: Enforce CONFIG_RELOCATABLE for EFI boot stub

Michael S. Tsirkin (1):
  kvm: iommu: fix the third parameter of kvm_iommu_put_pages
    (CVE-2014-3601)

Nadav Amit (1):
  KVM: x86: Inter-privilege level ret emulation is not implemeneted

Oliver Neukum (1):
  USB: devio: fix issue with log flooding

Paolo Bonzini (2):
  KVM: x86: always exit on EOIs for interrupts listed in the IOAPIC
    redir table
  Revert "KVM: x86: Increase the number of fixed MTRR regs to 10"

Patrick Riphagen (2):
  USB: serial: ftdi_sio: Annotate the current Xsens PID assignments
  USB: serial: ftdi_sio: Add support for new Xsens devices

Peter Hurley (1):
  serial: core: Preserve termios c_cflag for console resume

Pratyush Anand (1):
  USB: Fix persist resume of some SS USB devices

Preston Fick (1):
  USB: serial: cp210x: Removing unncessary `usb_reset_device` on startup

Russell King (1):
  drm: omapdrm: fix compiler errors

Stephen M. Cameron (1):
  hpsa: fix bad -ENOMEM return value in hpsa_big_passthru_ioctl

Steven Rostedt (1):
  debugfs: Fix corrupted loop in debugfs_remove_recursive

Takashi Iwai (2):
  ALSA: hda/ca0132 - Don't try loading firmware at resume when already
    failed
  ALSA: hda/realtek - Avoid setting wrong COEF on ALC269 & co

Theodore Ts'o (1):
  ext4: fix ext4_discard_allocated_blocks() if we can't allocate the pa
    struct

Vidya Sagar (1):
  PCI: Configure ASPM when enabling device

Wangzhao Cai (1):
  HID: add quirk for 0x04d9:0xa096 device

Wolfram Sang (1):
  drivers/i2c/busses: use correct type for dma_map/unmap

 Documentation/sound/alsa/ALSA-Configuration.txt |  4 +--
 arch/arm/mach-omap2/control.c                   |  3 +-
 arch/x86/Kconfig                                |  1 +
 arch/x86/include/asm/kvm_host.h                 |  2 +-
 arch/x86/kernel/resource.c                      |  8 +++--
 arch/x86/kernel/vsyscall_64.c                   |  8 ++---
 arch/x86/kvm/emulate.c                          |  4 +++
 arch/x86/pci/i386.c                             |  4 +++
 arch/x86/xen/time.c                             |  2 +-
 drivers/char/tpm/tpm_i2c_stm_st33.c             |  1 +
 drivers/crypto/ux500/cryp/cryp_core.c           | 25 +++++++-------
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c        |  6 ++--
 drivers/gpu/drm/omapdrm/omap_gem.c              | 10 +++---
 drivers/gpu/drm/omapdrm/omap_plane.c            |  4 +--
 drivers/gpu/drm/radeon/cik.c                    |  1 +
 drivers/hid/hid-cherry.c                        |  2 +-
 drivers/hid/hid-ids.h                           |  1 +
 drivers/hid/hid-kye.c                           |  2 +-
 drivers/hid/hid-lg.c                            |  4 +--
 drivers/hid/hid-logitech-dj.c                   | 13 ++++---
 drivers/hid/hid-monterey.c                      |  2 +-
 drivers/hid/hid-petalynx.c                      |  2 +-
 drivers/hid/hid-sunplus.c                       |  2 +-
 drivers/hid/usbhid/hid-quirks.c                 |  1 +
 drivers/hwmon/ads1015.c                         |  4 ++-
 drivers/hwmon/amc6821.c                         | 17 +++++----
 drivers/hwmon/dme1737.c                         | 33 ++++++++++--------
 drivers/hwmon/gpio-fan.c                        |  2 +-
 drivers/hwmon/lm78.c                            |  2 +-
 drivers/hwmon/lm85.c                            |  9 +++--
 drivers/hwmon/sis5595.c                         |  2 +-
 drivers/i2c/busses/i2c-at91.c                   |  4 +--
 drivers/md/bcache/journal.c                     | 19 +++++++---
 drivers/misc/mei/client.c                       |  1 +
 drivers/pci/pci.c                               | 12 +++----
 drivers/scsi/hpsa.c                             |  2 +-
 drivers/tty/serial/serial_core.c                |  3 ++
 drivers/usb/core/config.c                       | 11 ++++++
 drivers/usb/core/devio.c                        |  2 +-
 drivers/usb/core/hcd-pci.c                      |  2 ++
 drivers/usb/core/hub.c                          | 41 ++++++++++++++++++++++
 drivers/usb/core/quirks.c                       |  7 ++++
 drivers/usb/host/ehci-pci.c                     | 25 ++++++++++++++
 drivers/usb/host/ohci-dbg.c                     |  9 ++---
 drivers/usb/host/ohci-hcd.c                     | 10 +++---
 drivers/usb/host/ohci-q.c                       | 46 ++++++++++++++++---------
 drivers/usb/musb/musb_cppi41.c                  |  6 ++--
 drivers/usb/serial/cp210x.c                     |  3 --
 drivers/usb/serial/ftdi_sio.c                   |  2 ++
 drivers/usb/serial/ftdi_sio_ids.h               | 13 ++++---
 fs/bio-integrity.c                              | 12 ++-----
 fs/debugfs/inode.c                              | 34 +++++++++++++-----
 fs/ext4/mballoc.c                               | 21 ++++++++++-
 fs/isofs/inode.c                                | 15 ++++----
 fs/isofs/isofs.h                                | 23 ++++++++++---
 fs/isofs/rock.c                                 | 39 +++++++++++++++------
 include/drm/drm_pciids.h                        |  7 ++++
 include/linux/bio.h                             |  1 +
 include/linux/pci.h                             |  9 +++++
 include/linux/usb/quirks.h                      | 11 ++++++
 kernel/power/snapshot.c                         | 21 ++++++++++-
 sound/pci/Kconfig                               |  4 +--
 sound/pci/hda/patch_ca0132.c                    |  7 +++-
 sound/pci/hda/patch_realtek.c                   | 26 +++++++++++---
 sound/pci/hda/patch_sigmatel.c                  | 12 +++++++
 sound/pci/oxygen/virtuoso.c                     |  1 +
 sound/pci/oxygen/xonar_pcm179x.c                | 12 +++++--
 sound/usb/quirks-table.h                        | 29 ++++++++++++++++
 virt/kvm/ioapic.c                               |  7 ++--
 virt/kvm/iommu.c                                | 19 +++++-----
 70 files changed, 518 insertions(+), 191 deletions(-)

-- 
2.1.0

