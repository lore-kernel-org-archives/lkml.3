Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbaKROId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:08:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbaKROI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:08:28 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 000/206] 3.12.33-stable review
Date: Tue, 18 Nov 2014 15:08:24 +0100
Message-Id: <cover.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.12.33 release.
There are 206 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Nov 20 15:08:12 CET 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	http://kernel.org/pub/linux/kernel/people/jirislaby/stable-review/patch-3.12.33-rc1.xz
and the diffstat can be found below.

thanks,
js

===============


Adel Gadllah (4):
  USB: quirks: enable device-qualifier quirk for another Elan
    touchscreen
  USB: quirks: enable device-qualifier quirk for yet another Elan
    touchscreen
  HID: usbhid: enable always-poll quirk for Elan Touchscreen 009b
  HID: usbhid: enable always-poll quirk for Elan Touchscreen 016f

Al Viro (3):
  missing data dependency barrier in prepend_name()
  kill wbuf_queued/wbuf_dwork_lock
  fix misuses of f_count() in ppp and netlink

Alan Stern (1):
  usb-storage: handle a skipped data phase

Alex Deucher (2):
  drm/radeon/dpm: disable ulv support on SI
  drm/radeon: remove invalid pci id

Alexander Stein (1):
  spi: fsl-dspi: Fix CTAR selection

Alexey Khoroshilov (1):
  dm log userspace: fix memory leak in dm_ulog_tfr_init failure path

Anantha Krishnan (1):
  Bluetooth: Add support for Acer [13D3:3432]

Anatol Pomozov (1):
  Bluetooth: Fix crash in the Marvell driver initialization codepath

Andy Honig (2):
  KVM: x86: Prevent host from panicking on shared MSR writes.
  KVM: x86: Improve thread safety in pit

Andy Lutomirski (3):
  x86_64, entry: Filter RFLAGS.NT on entry from userspace
  x86, apic: Handle a bad TSC more gracefully
  x86_64, entry: Fix out of bounds read on sysenter

Andy Shevchenko (2):
  Bluetooth: sort the list of IDs in the source code
  Bluetooth: append new supported device to the list [0b05:17d0]

Artem Bityutskiy (3):
  UBIFS: remove mst_mutex
  UBIFS: fix a race condition
  UBIFS: fix free log space calculation

Axel Lin (1):
  media: tda7432: Fix setting TDA7432_MUTE bit for TDA7432_RF register

Ben Hutchings (3):
  drivers/net, ipv6: Select IPv6 fragment idents for virtio UFO packets
  drivers/net: macvtap and tun depend on INET
  x86: Reject x32 executables if x32 ABI not supported

Ben Skeggs (1):
  drm/nouveau/bios: memset dcb struct to zero before parsing

Benjamin Coddington (1):
  lockd: Try to reconnect if statd has moved

Benjamin Herrenschmidt (1):
  drm/ast: Fix HW cursor image

Benjamin Valentin (1):
  Input: xpad - sync device IDs with xboxdrv

Bryan O'Donoghue (1):
  x86: Add cpu_detect_cache_sizes to init_intel() add Quark
    legacy_cache()

Canek Peláez Valdés (1):
  rt2x00: support Ralink 5362.

Cesar Eduardo Barros (1):
  crypto: more robust crypto_memneq

Chris Ball (1):
  mfd: rtsx_pcr: Fix MSI enable error handling

Chris Mason (1):
  Btrfs: fix kfree on list_head in btrfs_lookup_csums_range error
    cleanup

Cong Wang (1):
  freezer: Do not freeze tasks killed by OOM killer

Cyril Brulebois (1):
  wireless: rt2x00: add new rt2800usb device

Dan Carpenter (1):
  [media] ttusb-dec: buffer overflow in ioctl

Dan Streetman (1):
  powerpc: use device_online/offline() instead of cpu_up/down()

Dan Williams (1):
  USB: option: add Haier CE81B CDMA modem

Daniel Borkmann (1):
  random: add and use memzero_explicit() for clearing data

Daniel Mack (1):
  ASoC: soc-dapm: fix use after free

Daniele Palmas (1):
  usb: option: add support for Telit LE910

Darrick J. Wong (4):
  jbd2: free bh when descriptor block checksum fails
  ext4: check EA value offset when loading
  ext4: check s_chksum_driver when looking for bg csum presence
  ext4: enable journal checksum when metadata checksum feature enabled

David Cohen (1):
  mmc: sdhci-pci: add Intel Merrifield support

David Daney (1):
  MIPS: tlbex: Properly fix HUGE TLB Refill exception handler

Derek Browne (1):
  mmc: sdhci-pci: SDIO host controller support for Intel Quark X1000

Dexuan Cui (1):
  x86, pageattr: Prevent overflow in slow_virt_to_phys() for X86_PAE

Dirk Brandewie (1):
  cpufreq: expose scaling_cur_freq sysfs file for set_policy() drivers

Dmitry Eremin-Solenikov (1):
  spi: pxa2xx: toggle clocks on suspend if not disabled by runtime PM

Dmitry Kasatkin (1):
  evm: check xattr value length and type in evm_inode_setxattr()

Dmitry Monakhov (2):
  ext4: grab missed write_count for EXT4_IOC_SWAP_BOOT
  ext4: Replace open coded mdata csum feature to helper function

Eric Dumazet (1):
  tcp: md5: do not use alloc_percpu()

Eric Ernst (1):
  mmc: sdhci-pci: Add SDIO/MMC device ID support for Intel Clovertrail

Eric Rannaud (1):
  fs: allow open(dir, O_TMPFILE|..., 0) with mode 0

Eric Sandeen (2):
  ext4: fix reservation overflow in ext4_da_write_begin
  xfs: avoid false quotacheck after unclean shutdown

Eric W. Biederman (1):
  mnt: Prevent pivot_root from creating a loop in the mount tree

Felipe Balbi (3):
  usb: dwc3: gadget: fix set_halt() bug with pending transfers
  usb: gadget: function: acm: make f_acm pass USB20CV Chapter9
  usb: gadget: udc: core: fix kernel oops with soft-connect

Frank Razenberg (1):
  Input: xpad - add VID/PID for Razer Sabertooth

Frank Schaefer (1):
  media: em28xx-v4l: give back all active video buffers to the vb2 core
    properly on streaming stop

Frans Klaver (1):
  usb: serial: ftdi_sio: add Awinda Station and Dongle products

Grant Likely (1):
  of: Fix overflow bug in string property parsing functions

Guenter Roeck (1):
  Revert "percpu: free percpu allocation info for uniprocessor system"

Hans de Goede (4):
  Input: i8042 - add noloop quirk for Asus X750LN
  Input: i8042 - quirks for Fujitsu Lifebook A544 and Lifebook AH544
  usb: Do not allow usb_alloc_streams on unconfigured devices
  acer-wmi: Add acpi_backlight=video quirk for the Acer KAV80

Ian Morgan (1):
  ax88179_178a: fix bonding failure

Imre Deak (1):
  PM / Sleep: fix recovery during resuming from hibernation

J. Bruce Fields (1):
  nfsd4: fix crash on unknown operation number

Jack Pham (1):
  usb: dwc3: gadget: Properly initialize LINK TRB

Jan Kara (11):
  vfs: fix data corruption when blocksize < pagesize for mmaped data
  ext4: don't check quota format when there are no quota files
  ext4: fix mmap data corruption when blocksize < pagesize
  ext4: fix overflow when updating superblock backups after resize
  ext4: fix oops when loading block bitmap failed
  lib/bitmap.c: fix undefined shift in __bitmap_shift_{left|right}()
  scsi: Fix error handling in SCSI_IOCTL_SEND_COMMAND
  ext3: Don't check quota format when there are no quota files
  quota: Properly return errors from dquot_writeback_dquots()
  mm: Remove false WARN_ON from pagecache_isize_extended()
  rbd: Fix error recovery in rbd_obj_read_sync()

Jani Nikula (1):
  drm/i915: provide interface for audio driver to query cdclk

Jason Baron (4):
  i82860_edac: Report CE events properly
  i3200_edac: Report CE events properly
  e7xxx_edac: Report CE events properly
  cpc925_edac: Report UE events properly

Jiri Kosina (1):
  HID: usbhid: enable NO_INIT_REPORTS quirk for Semico USB Keykoard

Jiri Pirko (1):
  ipv4: fix nexthop attlen check in fib_nh_match

Joe Thornber (1):
  dm bufio: update last_accessed when relinking a buffer

Joern Engel (1):
  qla_target: don't delete changed nacls

Johan Hovold (8):
  USB: cdc-acm: add device id for GW Instek AFG-2225
  USB: cdc-acm: only raise DTR on transitions from B0
  USB: core: add device-qualifier quirk
  USB: quirks: enable device-qualifier quirk for Elan Touchscreen
  HID: usbhid: add always-poll quirk
  HID: usbhid: enable always-poll quirk for Elan Touchscreen
  USB: opticon: fix non-atomic allocation in write path
  USB: kobil_sct: fix non-atomic allocation in write path

Johannes Weiner (1):
  mm: page_alloc: fix zone allocation fairness on UP

John Sung (1):
  HID: usbhid: quirk for PM1610 and PM1640 Touchscreen.

Jurgen Kramer (1):
  Bluetooth: btusb: Add IMC Networks (Broadcom based)

Karl Beldan (1):
  mac80211: fix typo in starting baserate for rts_cts_rate_idx

Krzysztof Kozlowski (1):
  regulator: max77693: Fix use of uninitialized regulator config

Lai Jiangshan (1):
  drbd: compute the end before rb_insert_augmented()

Lars-Peter Clausen (5):
  staging:iio:ad5933: Fix NULL pointer deref when enabling buffer
  staging:iio:ad5933: Drop "raw" from channel names
  staging:iio:ade7758: Fix NULL pointer deref when enabling buffer
  staging:iio:ade7758: Fix check if channels are enabled in prenable
  staging:iio:ade7758: Remove "raw" from channel name

Li RongQing (4):
  vxlan: fix a use after free in vxlan_encap_bypass
  vxlan: using pskb_may_pull as early as possible
  vxlan: fix a free after use
  ipv4: fix a potential use after free in ip_tunnel_core.c

Libin Yang (2):
  ALSA: hda - add PCI IDs for Intel Braswell
  ALSA: hda - add codec ID for Braswell display audio codec

Lv Zheng (2):
  ACPI / EC: Add support to disallow QR_EC to be issued when SCI_EVT
    isn't set
  ACPI / EC: Fix regression due to conflicting firmware behavior between
    Samsung and Acer.

Maciej Matraszek (1):
  media: v4l2-common: fix overflow in v4l_bound_align_image()

Marc-André Lureau (1):
  qxl: don't create too large primary surface

Marcel Holtmann (5):
  Bluetooth: Add support for Intel bootloader devices
  Bluetooth: Handle Intel USB bootloader with buggy interrupt
  Bluetooth: Ignore isochronous endpoints for Intel USB bootloader
  Bluetooth: Fix endian and alignment issue with ath3k version handling
  Bluetooth: Add support for Broadcom device of Asus Z97-DELUXE
    motherboard

Marco Piazza (1):
  Bluetooth: Add support for Toshiba Bluetooth device [0930:0220]

Markos Chandras (1):
  MIPS: ftrace: Fix a microMIPS build problem

Mathias Krause (1):
  posix-timers: Fix stack info leak in timer_create()

Mengdong Lin (1):
  ALSA: hda - restore BCLK M/N value as per CDCLK for HSW/BDW display
    HDA controller

Michael S. Tsirkin (2):
  virtio_pci: fix virtio spec compliance on restore
  kvm: x86: don't kill guest on unknown exit reason

Michal Hocko (1):
  OOM, PM: OOM killed task shouldn't escape PM suspend

Mike Snitzer (1):
  block: fix alignment_offset math that assumes io_min is a power-of-2

Mikulas Patocka (3):
  fs: make cont_expand_zero interruptible
  dm bufio: when done scanning return from __scan immediately
  framebuffer: fix border color

Nadav Amit (3):
  KVM: x86: Check non-canonical addresses upon WRMSR
  KVM: x86: Fix wrong masking on relative jump/call
  KVM: x86: Emulator fixes for eip canonical checks on near branches

Nathaniel Ting (1):
  USB: serial: cp210x: add Silicon Labs 358x VID and PID

Nicholas Bellinger (1):
  target: Fix APTPL metadata handling for dynamic MappedLUNs

Olaf Hering (1):
  drm/cirrus: bind also to qemu-xen-traditional

Oleg Nesterov (2):
  x86, fpu: __restore_xstate_sig()->math_state_restore() needs
    preempt_disable()
  x86, fpu: shift drop_init_fpu() from save_xstate_sig() to
    handle_signal()

Oliver Neukum (2):
  Bluetooth: Enable Atheros 0cf3:311e for firmware upload
  Bluetooth: Add firmware update for Atheros 0cf3:311f

Ondrej Kozina (1):
  crypto: algif - avoid excessive use of socket buffer in skcipher

Ondrej Zary (1):
  libata-sff: Fix controllers with no ctl port

Pali Rohár (1):
  cpufreq: intel_pstate: Fix setting max_perf_pct in performance policy

Paul Fertser (1):
  media: usb: uvc: add a quirk for Dell XPS M1330 webcam

Peng Chen (1):
  Bluetooth: Fix endianess issue in the ath3k driver

Perry Hung (1):
  usb: serial: ftdi_sio: add "bricked" FTDI device PID

Peter Hurley (2):
  serial: Fix divide-by-zero fault in uart_get_divisor()
  tty: Fix high cpu load if tty is unreleaseable

Petr Matousek (1):
  kvm: vmx: handle invvpid vm exit gracefully

Petr Sebor (1):
  Input: xpad - add new USB IDs for Logitech F310 and F710

Prarit Bhargava (1):
  modules, lock around setting of MODULE_STATE_UNFORMED

Quentin Casasnovas (2):
  regmap: fix kernel hang on regmap_bulk_write with zero val_count.
  kvm: fix excessive pages un-pinning in kvm_iommu_map error path.

Quinn Tran (1):
  target: Fix queue full status NULL pointer for
    SCF_TRANSPORT_TASK_SENSE

Rabin Vincent (1):
  tracing/syscalls: Ignore numbers outside NR_syscalls' range

Ray Jui (1):
  spi: pl022: Fix incorrect dma_unmap_sg

Reyad Attiyat (1):
  HID: usbhid: Use flag HID_DISCONNECTED when a usb device is removed

Richard Genoud (1):
  UBI: add missing kmem_cache_free() in process_pool_aeb error path

Richard Leitner (1):
  Input: serio - avoid negative serio device numbers

Robin van der Gracht (1):
  iio: st_sensors: Fix buffer copy

Roger Pau Monné (1):
  xen-blkback: fix leak on grant map error path

Roger Tseng (1):
  mmc: rtsx_pci_sdmmc: fix incorrect last byte in R2 response

Roman Dubtsov (1):
  rt2x00: rt2800usb: mark D-Link DWA-137 as supported

Scott Carter (1):
  pata_serverworks: disable 64-KB DMA transfers on Broadcom OSB4 IDE
    Controller

Sergio Gelato (1):
  nfsd: fix NFS regression

Sinclair Yeh (1):
  When screen objects are enabled, the bpp is assumed to be 32,
    otherwise it is set to 16.

Stephen Smalley (1):
  selinux: fix inode security list corruption

Sujith Manoharan (2):
  Bluetooth: ath3k: Add support for another AR3012 card
  Bluetooth: ath3k: Add support for a new AR3012 device

Takashi Iwai (3):
  drm/i915, HD-audio: Don't continue probing when nomodeset is given
  ALSA: pcm: Zero-clear reserved fields of PCM status ioctl in compat
    mode
  ALSA: usb-audio: Fix device_del() sysfs warnings at disconnect

Tetsuo Handa (1):
  fs: Fix theoretical division by 0 in super_cache_scan().

Theodore Ts'o (1):
  ext4: add ext4_iget_normal() which is to be used for dir tree lookups

Thomas Gleixner (1):
  usb: musb: cppi41: restart hrtimer only if not yet done

Thomaz de Oliveira dos Reis (1):
  Input: xpad - change D-PAD mapping on Razer devices

Thorsten Knabe (1):
  um: ubd: Fix for processes stuck in D state forever

Tommi Rantala (1):
  Input: xpad - add USB ID for Thrustmaster Ferrari 458 Racing Wheel

Ulrich Eckhardt (1):
  media: ds3000: fix LNB supply voltage on Tevii S480 on initialization

Valdis Kletnieks (1):
  pstore: Fix duplicate {console,ftrace}-efi entries

Vasily Averin (1):
  ipv4: dst_entry leak in ip_send_unicast_reply()

Vincent Zwanenburg (1):
  Add a new PID/VID 0227/0930 for AR3012.

Vineet Gupta (2):
  ARC: [SMP] General Fixes
  ARC: Disable caches in early boot if so configured

Wang Nan (1):
  cgroup/kmemleak: add kmemleak_free() for cgroup deallocations.

Wen-chien Jesse Sung (1):
  HID: use multi input quirk for 22b9:2968

Wolfram Sang (1):
  i2c: at91: don't account as iowait

Xose Vazquez Perez (2):
  wireless: rt2x00: rt2800usb: add new devices
  wireless: rt2x00: add new rt2800usb devices

Yijing Wang (1):
  sysfs: driver core: Fix glue dir race condition by gdp_mutex

Yu Zhao (1):
  mm: free compound page with correct order

 arch/arc/include/asm/cache.h                      |  27 +++++
 arch/arc/kernel/head.S                            |  45 +++++++--
 arch/arc/mm/cache_arc700.c                        | 109 +++++---------------
 arch/mips/include/asm/ftrace.h                    |   4 +-
 arch/mips/mm/tlbex.c                              |   6 +-
 arch/powerpc/platforms/pseries/dlpar.c            |   4 +-
 arch/um/drivers/ubd_kern.c                        |   5 +-
 arch/x86/ia32/ia32entry.S                         |  18 +++-
 arch/x86/include/asm/elf.h                        |   5 +-
 arch/x86/include/asm/kvm_host.h                   |  16 ++-
 arch/x86/include/uapi/asm/vmx.h                   |   2 +
 arch/x86/kernel/apic/apic.c                       |   4 +-
 arch/x86/kernel/cpu/common.c                      |   2 +-
 arch/x86/kernel/cpu/intel.c                       |  17 +++-
 arch/x86/kernel/signal.c                          |   5 +
 arch/x86/kernel/tsc.c                             |   5 +-
 arch/x86/kernel/xsave.c                           |   7 +-
 arch/x86/kvm/emulate.c                            |  99 +++++++++++++-----
 arch/x86/kvm/i8254.c                              |   2 +
 arch/x86/kvm/svm.c                                |   8 +-
 arch/x86/kvm/vmx.c                                |  24 +++--
 arch/x86/kvm/x86.c                                |  38 ++++++-
 arch/x86/mm/pageattr.c                            |   2 +-
 block/blk-settings.c                              |   4 +-
 block/scsi_ioctl.c                                |   3 +-
 crypto/algif_skcipher.c                           |   2 +-
 drivers/acpi/ec.c                                 |  28 +++++-
 drivers/ata/libata-sff.c                          |  20 ++--
 drivers/ata/pata_serverworks.c                    |  13 ++-
 drivers/base/core.c                               |   4 +-
 drivers/base/regmap/regmap.c                      |   6 +-
 drivers/block/drbd/drbd_interval.c                |   4 +
 drivers/block/rbd.c                               |   2 +-
 drivers/block/xen-blkback/blkback.c               |   1 +
 drivers/bluetooth/ath3k.c                         | 117 +++++++++++++---------
 drivers/bluetooth/btmrvl_main.c                   |   5 +
 drivers/bluetooth/btusb.c                         |  82 ++++++++++-----
 drivers/char/random.c                             |  10 +-
 drivers/cpufreq/cpufreq.c                         |  23 +++--
 drivers/cpufreq/intel_pstate.c                    |   1 +
 drivers/edac/cpc925_edac.c                        |   2 +-
 drivers/edac/e7xxx_edac.c                         |   2 +-
 drivers/edac/i3200_edac.c                         |   4 +-
 drivers/edac/i82860_edac.c                        |   2 +-
 drivers/gpu/drm/ast/ast_mode.c                    |   4 +-
 drivers/gpu/drm/cirrus/cirrus_drv.c               |   2 +
 drivers/gpu/drm/i915/intel_pm.c                   |  35 +++++--
 drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c    |   1 +
 drivers/gpu/drm/qxl/qxl_display.c                 |  16 +--
 drivers/gpu/drm/radeon/si_dpm.c                   |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c               |  16 ++-
 drivers/hid/hid-ids.h                             |  11 ++
 drivers/hid/usbhid/hid-core.c                     |  32 +++++-
 drivers/hid/usbhid/hid-quirks.c                   |   7 ++
 drivers/i2c/busses/i2c-at91.c                     |   2 +-
 drivers/iio/common/st_sensors/st_sensors_buffer.c |   2 +-
 drivers/input/joystick/xpad.c                     |  41 +++++++-
 drivers/input/serio/i8042-x86ia64io.h             |  22 ++++
 drivers/input/serio/serio.c                       |   4 +-
 drivers/md/dm-bufio.c                             |   5 +-
 drivers/md/dm-log-userspace-transfer.c            |   2 +-
 drivers/media/dvb-frontends/ds3000.c              |   7 ++
 drivers/media/i2c/tda7432.c                       |   2 +-
 drivers/media/usb/em28xx/em28xx-video.c           |  10 +-
 drivers/media/usb/ttusb-dec/ttusbdecfe.c          |   3 +
 drivers/media/usb/uvc/uvc_driver.c                |   9 ++
 drivers/media/v4l2-core/v4l2-common.c             |   9 +-
 drivers/mfd/rtsx_pcr.c                            |   2 +-
 drivers/mmc/host/rtsx_pci_sdmmc.c                 |   7 ++
 drivers/mmc/host/sdhci-pci.c                      |  89 ++++++++++++++++
 drivers/mtd/ubi/fastmap.c                         |   1 +
 drivers/net/Kconfig                               |   2 +
 drivers/net/macvtap.c                             |   3 +
 drivers/net/ppp/ppp_generic.c                     |   2 +-
 drivers/net/tun.c                                 |   6 +-
 drivers/net/usb/ax88179_178a.c                    |   7 +-
 drivers/net/vxlan.c                               |  15 +--
 drivers/net/wireless/rt2x00/rt2800.h              |   4 +-
 drivers/net/wireless/rt2x00/rt2800lib.c           |   6 ++
 drivers/net/wireless/rt2x00/rt2800usb.c           |  23 ++++-
 drivers/of/base.c                                 |  88 ++++------------
 drivers/of/selftest.c                             |  66 ++++++++++--
 drivers/platform/x86/acer-wmi.c                   |  11 ++
 drivers/regulator/max77693.c                      |   2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                |  11 +-
 drivers/spi/spi-fsl-dspi.c                        |   4 +-
 drivers/spi/spi-pl022.c                           |   2 +-
 drivers/spi/spi-pxa2xx.c                          |   7 +-
 drivers/staging/iio/impedance-analyzer/ad5933.c   |  15 ++-
 drivers/staging/iio/meter/ade7758.h               |   1 -
 drivers/staging/iio/meter/ade7758_core.c          |  57 ++---------
 drivers/staging/iio/meter/ade7758_ring.c          |   5 +-
 drivers/target/target_core_device.c               |   3 +-
 drivers/target/target_core_pr.c                   |   6 +-
 drivers/target/target_core_pr.h                   |   2 +-
 drivers/target/target_core_tpg.c                  |   8 ++
 drivers/target/target_core_transport.c            |   3 +-
 drivers/tty/serial/serial_core.c                  |   2 +-
 drivers/tty/tty_io.c                              |   7 +-
 drivers/usb/class/cdc-acm.c                       |   6 +-
 drivers/usb/core/hcd.c                            |   2 +
 drivers/usb/core/hub.c                            |   3 +
 drivers/usb/core/quirks.c                         |  10 ++
 drivers/usb/dwc3/ep0.c                            |   4 +-
 drivers/usb/dwc3/gadget.c                         |  19 ++--
 drivers/usb/dwc3/gadget.h                         |   2 +-
 drivers/usb/gadget/f_acm.c                        |   7 +-
 drivers/usb/gadget/udc-core.c                     |   5 +
 drivers/usb/musb/musb_cppi41.c                    |   3 +-
 drivers/usb/serial/cp210x.c                       |   1 +
 drivers/usb/serial/ftdi_sio.c                     |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                 |  12 ++-
 drivers/usb/serial/kobil_sct.c                    |   5 +-
 drivers/usb/serial/opticon.c                      |   2 +-
 drivers/usb/serial/option.c                       |  10 ++
 drivers/usb/storage/transport.c                   |  26 +++++
 drivers/video/console/bitblit.c                   |   3 +-
 drivers/video/console/fbcon_ccw.c                 |   3 +-
 drivers/video/console/fbcon_cw.c                  |   3 +-
 drivers/video/console/fbcon_ud.c                  |   3 +-
 drivers/virtio/virtio_pci.c                       |  33 +++++-
 fs/btrfs/file-item.c                              |   2 +-
 fs/buffer.c                                       |   8 ++
 fs/dcache.c                                       |   5 +
 fs/ext3/super.c                                   |   7 --
 fs/ext4/bitmap.c                                  |  12 +--
 fs/ext4/ext4.h                                    |  13 ++-
 fs/ext4/extents.c                                 |   6 +-
 fs/ext4/ialloc.c                                  |   7 +-
 fs/ext4/inline.c                                  |   3 +-
 fs/ext4/inode.c                                   |  39 ++++++--
 fs/ext4/ioctl.c                                   |  13 ++-
 fs/ext4/mmp.c                                     |   6 +-
 fs/ext4/namei.c                                   |  43 +++-----
 fs/ext4/resize.c                                  |   5 +-
 fs/ext4/super.c                                   |  32 +++---
 fs/ext4/xattr.c                                   |  38 ++++---
 fs/jbd2/recovery.c                                |   1 +
 fs/jffs2/jffs2_fs_sb.h                            |   2 -
 fs/jffs2/wbuf.c                                   |  17 +---
 fs/lockd/mon.c                                    |   6 ++
 fs/namei.c                                        |   3 +-
 fs/namespace.c                                    |   3 +
 fs/nfsd/nfs4proc.c                                |   3 +-
 fs/nfsd/vfs.c                                     |   3 +
 fs/pstore/inode.c                                 |   4 +-
 fs/quota/dquot.c                                  |   2 +-
 fs/super.c                                        |   2 +
 fs/ubifs/commit.c                                 |  10 +-
 fs/ubifs/log.c                                    |  19 +++-
 fs/ubifs/master.c                                 |   7 +-
 fs/ubifs/super.c                                  |   1 -
 fs/ubifs/ubifs.h                                  |   2 -
 fs/xfs/xfs_mount.c                                |   1 -
 fs/xfs/xfs_sb.c                                   |  24 ++++-
 include/drm/drm_pciids.h                          |   1 -
 include/drm/i915_powerwell.h                      |   5 +-
 include/linux/blkdev.h                            |   5 +-
 include/linux/compiler-gcc.h                      |   3 +
 include/linux/compiler-intel.h                    |   7 ++
 include/linux/compiler.h                          |   4 +
 include/linux/hid.h                               |   1 +
 include/linux/mm.h                                |   1 +
 include/linux/of.h                                |  84 +++++++++++++---
 include/linux/oom.h                               |   3 +
 include/linux/string.h                            |   5 +-
 include/linux/usb/quirks.h                        |   3 +
 include/net/ipv6.h                                |   2 +
 kernel/freezer.c                                  |   3 +
 kernel/module.c                                   |   2 +
 kernel/posix-timers.c                             |   1 +
 kernel/power/hibernate.c                          |   8 +-
 kernel/power/process.c                            |  40 +++++++-
 kernel/trace/trace_syscalls.c                     |   8 +-
 lib/bitmap.c                                      |   8 +-
 lib/string.c                                      |  16 +++
 mm/huge_memory.c                                  |   4 +-
 mm/oom_kill.c                                     |  17 ++++
 mm/page_alloc.c                                   |  15 ++-
 mm/page_cgroup.c                                  |   1 +
 mm/percpu.c                                       |   2 -
 mm/truncate.c                                     |  56 +++++++++++
 net/ipv4/fib_semantics.c                          |   2 +-
 net/ipv4/ip_output.c                              |  12 ++-
 net/ipv4/ip_tunnel_core.c                         |   3 +-
 net/ipv4/tcp.c                                    |  59 ++++-------
 net/ipv6/output_core.c                            |  38 +++++++
 net/mac80211/rate.c                               |   2 +-
 net/netlink/af_netlink.c                          |   2 +-
 security/integrity/evm/evm_main.c                 |   9 +-
 security/selinux/hooks.c                          |   2 +-
 sound/core/pcm_compat.c                           |   2 +
 sound/pci/hda/hda_i915.c                          |  28 ++++--
 sound/pci/hda/hda_i915.h                          |   6 +-
 sound/pci/hda/hda_intel.c                         |  69 ++++++++++++-
 sound/pci/hda/patch_hdmi.c                        |   2 +
 sound/soc/soc-dapm.c                              |  25 +++--
 sound/usb/card.c                                  |   9 +-
 virt/kvm/iommu.c                                  |   8 +-
 199 files changed, 1839 insertions(+), 758 deletions(-)

-- 
2.1.3

