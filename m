Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab3GXOHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:07:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45700 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751008Ab3GXOHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:07:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 15:02:44 +0100
Message-ID: <lsq.1374674564.753305150@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [00/85] 3.2.49-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.49 release.
There are 85 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

I have not yet looked at any commits cc'd to stable that are not in
v3.11-rc1.  Any fixes that went into v3.11-rc2 or later should appear
in the next review if they are applicable.

Responses should be made by Fri Jul 26 14:00:00 UTC 2013.
Anything received after that time might be too late.

A combined patch relative to 3.2.48 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Al Viro (1):
      ext3,ext4: don't mess with dir_file->f_pos in htree_dirblock_to_tree()
         [64cb927371cd2ec43758d8a094a003d27bc3d0dc]

Alex Williamson (1):
      iommu/amd: Only unmap large pages from the first pte
         [60d0ca3cfd199b6612bbbbf4999a3470dad38bb1]

Anderson Lizardo (1):
      Bluetooth: Fix crash in l2cap_build_cmd() with small MTU
         [300b962e5244a1ea010df7e88595faa0085b461d]

Artem Bityutskiy (2):
      UBIFS: fix a horrid bug
         [605c912bb843c024b1ed173dc427cd5c08e5d54d]
      UBIFS: prepare to fix a horrid bug
         [33f1a63ae84dfd9ad298cf275b8f1887043ced36]

Axel Lin (1):
      drivers/rtc/rtc-rv3029c2.c: fix disabling AIE irq
         [29ecd78c0fd6ee05f2c6b07b23823a6ae43c13ff]

Bart Van Assche (1):
      timer: Fix jiffies wrap behavior of round_jiffies_common()
         [9e04d3804d3ac97d8c03a41d78d0f0674b5d01e1]

Bartlomiej Zolnierkiewicz (1):
      drivers/dma/pl330.c: fix locking in pl330_free_chan_resources()
         [da331ba8e9c5de72a27e50f71105395bba6eebe0]

Ben Hutchings (3):
      [SCSI] sd: Fix parsing of 'temporary ' cache mode prefix
         [2ee3e26c673e75c05ef8b914f54fadee3d7b9c88]
      genirq: Fix can_request_irq() for IRQs without an action
         [2779db8d37d4b542d9ca2575f5f178dbeaca6c86]
      r8169: fix offloaded tx checksum for small packets.
         [not upstream; fixes effective mis-merge in 3.2]

Bjørn Mork (1):
      [SCSI] megaraid_sas: fix memory leak if SGL has zero length entries
         [7a6a731bd00ca90d0e250867c3b9c05b5ff0fa49]

Chen Gang (1):
      powerpc/smp: Section mismatch from smp_release_cpus to __initdata spinning_secondaries
         [8246aca7058f3f2c2ae503081777965cd8df7b90]

Dan Williams (1):
      USB: option,qcserial: move Novatel Gobi1K IDs to qcserial
         [a254810a86aaaac4ac6ba44fa934558b042a17a7]

Daniel Hansel (1):
      [SCSI] zfcp: fix adapter (re)open recovery while link to SAN is down
         [f76ccaac4f82c463a037aa4a1e4ccb85c7011814]

Dirk Hohndel (1):
      HID: Add support for the MacBook Pro 10,2 keyboard / touchpad
         [8d80da90f53d37cf6caefc61353e1cc3a145b9e0]

Dmitry Torokhov (2):
      HID: apple: Add support for the 2013 Macbook Air
         [9d9a04ee758b4c1fcc7586d065cdde7a7607e156]
      Input: bcm5974 - add support for the 2013 MacBook Air
         [148c1c8ad3c4170186ebe6ea5900adde27d2a0e7]

Gavin Shan (1):
      net/tg3: Avoid delay during MMIO access
         [6d446ec32f169c6a5d9bc90684a8082a6cbe90f6]

Greg KH (1):
      MAINTAINERS: Greg's suse email address is dead
         [879a5a001b62a020e074d460b3a7c0fd993f9832]

Greg Kroah-Hartman (2):
      MAINTAINERS: add stable_kernel_rules.txt to stable maintainer information
         [7b175c46720f8e6b92801bb634c93d1016f80c62]
      Revert "serial: 8250_pci: add support for another kind of NetMos Technology PCI 9835 Multi-I/O Controller"
         [828c6a102b1f2b8583fadc0e779c46b31d448f0b]

Hauke Mehrtens (1):
      b43: ensue that BCMA is "y" when B43 is "y"
         [693026ef2e751fd94d2e6c71028e68343cc875d5]

J. Bruce Fields (1):
      nfsd4: fix decoding of compounds across page boundaries
         [247500820ebd02ad87525db5d9b199e5b66f6636]

Jaganath Kanakkassery (1):
      Bluetooth: Fix invalid length check in l2cap_information_rsp()
         [3f6fa3d489e127ca5a5b298eabac3ff5dbe0e112]

James Bottomley (1):
      [SCSI] sd: fix array cache flushing bug causing performance problems
         [39c60a0948cc06139e2fbfe084f83cb7e7deae3b]

Jan Kara (3):
      ext4: fix data offset overflow in ext4_xattr_fiemap() on 32-bit archs
         [a60697f411eb365fb09e639e6f183fe33d1eb796]
      ext4: fix overflow when counting used blocks on 32-bit architectures
         [8af8eecc1331dbf5e8c662022272cf667e213da5]
      writeback: Fix periodic writeback after fs mount
         [a5faeaf9109578e65e1a32e2a3e76c8b47e7dcb6]

Jason Wang (1):
      drivers: hv: switch to use mb() instead of smp_mb()
         [35848f68b07df3f917cb13fc3c134718669f569b]

Jed Davis (1):
      ARM: 7765/1: perf: Record the user-mode PC in the call chain.
         [c5f927a6f62196226915f12194c9d0df4e2210d7]

Jiang Liu (5):
      zram: avoid access beyond the zram device
         [12a7ad3b810e77137d0caf97a6dd97591e075b30]
      zram: avoid invalid memory access in zram_exit()
         [6030ea9b35971a4200062f010341ab832e878ac9]
      zram: destroy all devices on error recovery path in zram_init()
         [39a9b8ac9333e4268ecff7da6c9d1ab3823ff243]
      zram: protect sysfs handler from invalid memory access
         [5863e10b441e7ea4b492f930f1be180a97d026f3]
      zram: use zram->lock to protect zram_free_page() in swap free notify path
         [57ab048532c0d975538cebd4456491b5c34248f4]

Jiri Olsa (2):
      perf: Clone child context from parent context pmu
         [734df5ab549ca44f40de0f07af1c8803856dfb18]
      perf: Remove WARN_ON_ONCE() check in __perf_event_enable() for valid scenario
         [06f417968beac6e6b614e17b37d347aa6a6b1d30]

Jonathan Salwan (1):
      drivers/cdrom/cdrom.c: use kzalloc() for failing hardware
         [542db01579fbb7ea7d1f7bb9ddcef1559df660b2]

Junxiao Bi (1):
      ocfs2: xattr: fix inlined xattr reflink
         [ef962df057aaafd714f5c22ba3de1be459571fdf]

Jörn Engel (1):
      iscsi-target: Fix tfc_tpg_nacl_auth_cit configfs length overflow
         [0fbfc46fb0b2f543a8b539e94c6c293ebc0b05a6]

Kees Cook (2):
      block: do not pass disk names as format strings
         [ffc8b30866879ed9ba62bd0a86fecdbd51cd3d19]
      crypto: sanitize argument for format string
         [1c8fca1d92e14859159a82b8a380d220139b7344]

Larry Finger (2):
      rtlwifi: rtl8192cu: Add new USB ID for TP-Link TL-WN8200ND
         [c4d827c5ccc3a49227dbf9d4b248a2e86f388023]
      rtlwifi: rtl8192cu: Fix duplicate if test
         [10d0b9030a3f86e1e26c710c7580524d7787d688]

Laszlo Ersek (1):
      xen/time: remove blocked time accounting from xen "clockchip"
         [0b0c002c340e78173789f8afaa508070d838cf3d]

Liang Li (1):
      pch_uart: fix a deadlock when pch_uart as console
         [384e301e3519599b000c1a2ecd938b533fc15d85]

Marcelo Tosatti (1):
      vgacon.c: add cond reschedule points in vgacon_do_font_op
         [7e6d72c15ff4cc0c27573901bb05f9eddbd71ed4]

Mathias Nyman (1):
      xhci: check for failed dma pool allocation
         [025f880cb2e4d7218d0422d4b07bea1a68959c38]

Mikulas Patocka (1):
      hpfs: better test for errors
         [3ebacb05044f82c5f0bb456a894eb9dc57d0ed90]

Nicolin Chen (1):
      ASoC: wm8962: Remove remaining direct register cache accesses
         [2e7ee15ced914e109a1a5b6dfcd463d846a13bd5]

Oleg Nesterov (1):
      hw_breakpoint: Use cpu_possible_mask in {reserve,release}_bp_slot()
         [c790b0ad23f427c7522ffed264706238c57c007e]

Paul Clements (1):
      nbd: correct disconnect behavior
         [c378f70adbc1bbecd9e6db145019f14b2f688c7c]

Peter Zijlstra (3):
      perf: Fix mmap() accounting hole
         [9bb5d40cd93c9dd4be74834b1dcb1ba03629716b]
      perf: Fix perf mmap bugs
         [26cb63ad11e04047a64309362674bcbbd6a6f246]
      perf: Fix perf_lock_task_context() vs RCU
         [058ebd0eba3aff16b144eabf4510ed9510e1416e]

Rajkumar Manoharan (1):
      ath9k: fill channel mode in caldata
         [77d848372875d2e4cbdbf07030f0e08cab5e7f4d]

Sage Weil (1):
      ceph: fix statvfs fr_size
         [92a49fb0f79f3300e6e50ddf56238e70678e4202]

Seth Heasley (2):
      ahci: AHCI-mode SATA patch for Intel Coleto Creek DeviceIDs
         [1cfc7df3de10c40ed459e13cce6de616023bf41c]
      ata_piix: IDE-mode SATA patch for Intel Coleto Creek DeviceIDs
         [c7e8695bfa0611b39493a9dfe8bab9f63f9809bd]

Shane Huang (3):
      ahci: Add AMD CZ SATA device ID
         [fafe5c3d82a470d73de53e6b08eb4e28d974d895]
      ahci: remove pmp link online check in FBS EH
         [912b9ac683b112615d5605686f1dc086402ce9f7]
      i2c-piix4: Add AMD CZ SMBus device ID
         [b996ac90f595dda271cbd858b136b45557fc1a57]

Soeren Moch (1):
      [media] media: dmxdev: remove dvb_ringbuffer_flush() on writer side
         [414abbd2cd4c2618895f02ed3a76ec6647281436]

Sreekanth Reddy (3):
      [SCSI] mpt2sas: Fix for device scan following host reset could get stuck in a infinite loop
         [6241f22ca12a26ee149cbe31b27bac97dbdc8bc4]
      [SCSI] mpt2sas: Fix for issue Missing delay not getting set during system bootup
         [b0df96a0068daee4f9c2189c29b9053eb6e46b17]
      [SCSI] mpt2sas: fix firmware failure with wrong task attribute
         [48ba2efc382f94fae16ca8ca011e5961a81ad1ea]

Steffen Maier (2):
      [SCSI] zfcp: block queue limits with data router
         [5fea4291deacd80188b996d2f555fc6a1940e5d4]
      [SCSI] zfcp: status read buffers on first adapter open with link down
         [9edf7d75ee5f21663a0183d21f702682d0ef132f]

Stephane Eranian (1):
      perf: Disable monitoring on setuid processes for regular users
         [2976b10f05bd7f6dab9f9e7524451ddfed656a89]

Steve French (1):
      Handle big endianness in NTLM (ntlmv2) authentication
         [fdf96a907c1fbb93c633e2b7ede3b8df26d6a4c0]

Sujith Manoharan (3):
      ath9k: Do not assign noise for NULL caldata
         [d3bcb7b24bbf09fde8405770e676fe0c11c79662]
      ath9k: Fix noisefloor calibration
         [696df78509d1f81b651dd98ecdc1aecab616db6b]
      ath9k_hw: Assign default xlna config for AR9485
         [30d5b709da23f4ab9836c7f66d2d2e780a69cf12]

Takashi Iwai (1):
      ALSA: hda - Cache the MUX selection for generic HDMI
         [bddee96b5d0db869f47b195fe48c614ca824203c]

Tejun Heo (2):
      cgroup: fix RCU accesses to task->cgroups
         [14611e51a57df10240817d8ada510842faf0ec51]
      libata: skip SRST for all SIMG [34]7x port-multipliers
         [7a87718d92760fc688628ad6a430643dafa16f1f]

Theodore Ts'o (1):
      jbd2: fix theoretical race in jbd2__journal_restart
         [39c04153fda8c32e85b51c96eb5511a326ad7609]

Tyler Hicks (1):
      libceph: Fix NULL pointer dereference in auth client code
         [2cb33cac622afde897aa02d3dcd9fbba8bae839e]

UCHINO Satoshi (1):
      usb: gadget: f_mass_storage: add missing memory barrier for thread_wakeup_needed
         [d68c277b501889b3a50c179d1c3d704db7947b83]

Yitian Bu (1):
      printk: Fix rq->lock vs logbuf_lock unlock lock inversion
         [dbda92d16f8655044e082930e4e9d244b87fde77]

Zefan Li (2):
      dlci: acquire rtnl_lock before calling __dev_get_by_name()
         [11eb2645cbf38a08ae491bf6c602eea900ec0bb5]
      dlci: validate the net device in dlci_del()
         [578a1310f2592ba90c5674bca21c1dbd1adf3f0a]

Zhang Yi (1):
      futex: Take hugepages into account when generating futex_key
         [13d60f4b6ab5b702dc8d2ee20999f98a93728aec]

Zhangwei (1):
      tracing: Fix irqs-off tag display in syscall tracing
         [11034ae9c20f4057a6127fc965906417978e69b2]

 Documentation/i2c/busses/i2c-piix4             |   2 +-
 MAINTAINERS                                    |  30 +--
 Makefile                                       |   4 +-
 arch/arm/kernel/perf_event.c                   |   1 +
 arch/powerpc/kernel/setup_64.c                 |   2 +-
 arch/x86/xen/time.c                            |  17 +-
 block/genhd.c                                  |   2 +-
 crypto/algapi.c                                |   3 +-
 drivers/ata/ahci.c                             |   2 +
 drivers/ata/ata_piix.c                         |   2 +
 drivers/ata/libahci.c                          |   3 +-
 drivers/ata/libata-pmp.c                       |  33 ++--
 drivers/block/nbd.c                            |  10 +-
 drivers/cdrom/cdrom.c                          |   2 +-
 drivers/dma/pl330.c                            |   4 +-
 drivers/hid/hid-apple.c                        |  12 ++
 drivers/hid/hid-core.c                         |  12 ++
 drivers/hid/hid-ids.h                          |   6 +
 drivers/hv/ring_buffer.c                       |   2 +-
 drivers/hv/vmbus_drv.c                         |   2 +-
 drivers/i2c/busses/Kconfig                     |   1 +
 drivers/i2c/busses/i2c-piix4.c                 |   3 +-
 drivers/input/mouse/bcm5974.c                  |  55 +++++-
 drivers/iommu/amd_iommu.c                      |   6 +-
 drivers/media/dvb/dvb-core/dmxdev.c            |   8 +-
 drivers/net/ethernet/broadcom/tg3.c            |  38 ++++
 drivers/net/ethernet/realtek/r8169.c           |   8 -
 drivers/net/wan/dlci.c                         |  26 ++-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   8 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |   2 +
 drivers/net/wireless/ath/ath9k/calib.c         |   2 +-
 drivers/net/wireless/ath/ath9k/hw.c            |   3 +-
 drivers/net/wireless/ath/ath9k/hw.h            |   1 +
 drivers/net/wireless/ath/ath9k/main.c          |   7 -
 drivers/net/wireless/b43/Kconfig               |   4 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c    |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c    |   1 +
 drivers/pci/quirks.c                           |   2 +
 drivers/rtc/rtc-rv3029c2.c                     |   2 +-
 drivers/s390/scsi/zfcp_aux.c                   |   5 +-
 drivers/s390/scsi/zfcp_fsf.c                   |  25 ++-
 drivers/s390/scsi/zfcp_scsi.c                  |  10 +-
 drivers/scsi/megaraid/megaraid_sas_base.c      |  10 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c            |  13 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h            |   3 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c           | 132 ++++++++++++-
 drivers/scsi/osd/osd_uld.c                     |   2 +-
 drivers/scsi/sd.c                              |  20 ++
 drivers/scsi/sd.h                              |   1 +
 drivers/staging/zram/zram_drv.c                |  36 ++--
 drivers/staging/zram/zram_drv.h                |   5 +-
 drivers/staging/zram/zram_sysfs.c              |   2 +
 drivers/target/iscsi/iscsi_target_configfs.c   |   2 +-
 drivers/tty/serial/8250_pci.c                  |   4 -
 drivers/tty/serial/pch_uart.c                  |  29 ++-
 drivers/usb/gadget/f_mass_storage.c            |   2 +
 drivers/usb/host/xhci-mem.c                    |   4 +
 drivers/usb/serial/option.c                    |   4 -
 drivers/usb/serial/qcserial.c                  |   8 +-
 drivers/video/console/vgacon.c                 |  17 +-
 fs/block_dev.c                                 |   9 +-
 fs/ceph/super.c                                |   7 +-
 fs/ceph/super.h                                |   2 +-
 fs/cifs/cifs_unicode.h                         |   8 +-
 fs/cifs/cifsencrypt.c                          |   6 +-
 fs/exec.c                                      |  16 +-
 fs/ext3/namei.c                                |   7 +-
 fs/ext4/extents.c                              |   4 +-
 fs/ext4/inode.c                                |   4 +-
 fs/ext4/namei.c                                |   7 +-
 fs/hpfs/map.c                                  |   3 +-
 fs/hpfs/super.c                                |   8 +-
 fs/jbd2/transaction.c                          |   2 +-
 fs/nfsd/nfs4xdr.c                              |   2 +-
 fs/ocfs2/xattr.c                               |  10 +
 fs/ubifs/dir.c                                 |  54 ++++--
 include/linux/cgroup.h                         |  52 ++++-
 include/linux/hugetlb.h                        |  16 ++
 include/linux/nbd.h                            |   1 +
 include/linux/perf_event.h                     |   3 +-
 kernel/events/core.c                           | 258 ++++++++++++++++++-------
 kernel/events/hw_breakpoint.c                  |   4 +-
 kernel/events/internal.h                       |   4 +
 kernel/futex.c                                 |   3 +-
 kernel/irq/manage.c                            |   6 +-
 kernel/printk.c                                |   2 +-
 kernel/timer.c                                 |   8 +-
 kernel/trace/trace_syscalls.c                  |  21 +-
 mm/hugetlb.c                                   |  17 ++
 net/bluetooth/l2cap_core.c                     |   5 +-
 net/ceph/auth_none.c                           |   6 +
 sound/pci/hda/patch_hdmi.c                     |   2 +-
 sound/soc/codecs/wm8962.c                      |  24 +--
 93 files changed, 918 insertions(+), 327 deletions(-)

-- 
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

