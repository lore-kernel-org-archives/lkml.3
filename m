Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab3CREtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:49:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33352 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735Ab3CREaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:00 -0400
Message-Id: <20130318042144.234468645@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:21:44 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: [ 00/82] 3.2.41-stable review
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.41 release.
There are 82 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Mar 20 12:00:00 UTC 2013.
Anything received after that time might be too late.

A combined patch relative to 3.2.40 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Al Viro (1):
      vfs: fix pipe counter breakage
         [a930d8790552658140d7d0d2e316af4f0d76a512]

Alan Stern (2):
      NLS: improve UTF8 -> UTF16 string conversion routine
         [0720a06a7518c9d0c0125bd5d1f3b6264c55c3dd]
      USB: EHCI: don't check DMA values in QH overlays
         [feca7746d5d9e84b105a613b7f3b6ad00d327372]

Alex Deucher (1):
      drm/radeon: add primary dac adj quirk for R200 board
         [e8fc41377f5037ff7a661ea06adc05f1daec1548]

Amit Shah (1):
      virtio: rng: disallow multiple device registrations, fixes crashes
         [e84e7a56a3aa2963db506299e29a5f3f09377f9b]

Avinash Patil (1):
      mwifiex: correct sleep delay counter
         [3e7a4ff7c5b6423ddb644df9c41b8b6d2fb79d30]

Axel Lin (1):
      hwmon: (lineage-pem) Add missing terminating entry for pem_[input|fan]_attributes
         [df069079c153d22adf6c28dcc0b1cf62bba75167]

Ben Hutchings (2):
      Revert "powerpc/eeh: Fix crash when adding a device in a slot with DDW"
         [not upstream; the reverted change was correct in mainline but not
          needed in 3.2]
      dmi_scan: fix missing check for _DMI_ signature in smbios_present()
         [a40e7cf8f06b4e322ba902e4e9f6a6b0c2daa907]

Bjørn Mork (2):
      USB: option: add Huawei E5331
         [daec90e7382cbd0e73eb6861109b3da91e5ab1f3]
      USB: storage: fix Huawei mode switching regression
         [ab4b71644a26d1ab92b987b2fd30e17c25e89f85]

Christian Schmiedl (1):
      USB: added support for Cinterion's products AH6 and PLS8
         [1941138e1c024ecb5bd797d414928d3eb94d8662]

Dan Carpenter (1):
      [SCSI] dc395x: uninitialized variable in device_alloc()
         [208afec4f3be8c51ad6eebe6611dd6d2ad2fa298]

Dan Williams (1):
      qcaux: add Franklin U600
         [2d90e63603ac235aecd7d20e234616e0682c8b1f]

David Howells (1):
      keys: fix race with concurrent install_user_keyrings()
         [0da9dfdd2cd9889201bc6f6f43580c99165cd087]

Eric Sandeen (1):
      btrfs: use rcu_barrier() to wait for bdev puts at unmount
         [bc178622d40d87e75abc131007342429c9b03351]

Eric W. Biederman (1):
      decnet: Fix disappearing sysctl entries
         [not upstream; fixed by rewrite of sysctl in 3.4]

Felix Fietkau (2):
      ath9k: fix RSSI dummy marker value
         [a3d63cadbad97671d740a9698acc2c95d1ca6e79]
      ath9k_htc: fix signal strength handling issues
         [838f427955dcfd16858b0108ce29029da0d56a4e]

Fernando Luis Vázquez Cao (2):
      HID: add support for Sony RF receiver with USB product id 0x0374
         [a464918419f94a0043d2f549d6defb4c3f69f68a]
      HID: clean up quirk for Sony RF receivers
         [99d249021abd4341771523ed8dd7946276103432]

Guenter Roeck (3):
      hwmon: (pmbus/ltc2978) Fix peak attribute handling
         [dbd712c2272764a536e29ad6841dba74989a39d9]
      hwmon: (pmbus/ltc2978) Fix temperature reporting
         [8c958c703ef8804093437959221951eaf0e1e664]
      hwmon: (pmbus/ltc2978) Use detected chip ID to select supported functionality
         [f366fccd0809f13ba20d64cae3c83f7338c88af7]

Guo Chao (3):
      block: use i_size_write() in bd_set_size()
         [d646a02a9d44d1421f273ae3923d97b47b918176]
      loopdev: fix a deadlock
         [5370019dc2d2c2ff90e95d181468071362934f3a]
      loopdev: remove an user triggerable oops
         [b1a6650406875b9097a032eed89af50682fe1160]

Ilya Zykov (1):
      tty: Correct tty buffer flush.
         [64325a3be08d364a62ee8f84b2cf86934bc2544a]

James Ralston (2):
      ahci: Add Device IDs for Intel Lynx Point-LP PCH
         [77b12bc9cf7b10c7c1a04ca45272fbb4287902d0]
      ahci: Add Device IDs for Intel Wellsburg PCH
         [151743fd8dfb02956c5184b5f4f0f42677eb75bc]

Jeff Layton (1):
      cifs: ensure that cifs_get_root() only traverses directories
         [ce2ac52105aa663056dfc17966ebed1bf93e6e64]

Jiang Liu (1):
      mm/hotplug: correctly add new zone to all other nodes' zone lists
         [08dff7b7d629807dbb1f398c68dd9cd58dd657a1]

Johannes Berg (1):
      iwlwifi: always copy first 16 bytes of commands
         [8a964f44e01ad3bbc208c3e80d931ba91b9ea786]

Josh Boyer (2):
      efi: be more paranoid about available space when  creating variables
         [68d929862e29a8b52a7f2f2f86a0600423b093cd]
      efivars: Disable external interrupt while holding  efivars->lock
         [81fa4e581d9283f7992a0d8c534bb141eb840a14]

K. Y. Srinivasan (1):
      [SCSI] storvsc: Initialize the sglist
         [9d2696e658ef4f209955ddaa987d43f1a1bd81a1]

Kees Cook (2):
      proc connector: reject unprivileged listener bumps
         [e70ab977991964a5a7ad1182799451d067e62669]
      signal: always clear sa_restorer on execve
         [2ca39528c01a933f6689cd6505ce65bd6d68a530]

Konrad Rzeszutek Wilk (2):
      xen/pci: We don't do multiple MSI's.
         [884ac2978a295b7df3c4a686d3bff6932bbbb460]
      xen/pciback: Don't disable a PCI device that is already disabled.
         [bdc5c1812cea6efe1aaefb3131fcba28cd0b2b68]

Konstantin Khlebnikov (1):
      e1000e: fix pci-device enable-counter balance
         [4e0855dff094b0d56d6b5b271e0ce7851cc1e063]

Lars-Peter Clausen (1):
      ext3: Fix format string issues
         [8d0c2d10dd72c5292eda7a06231056a4c972e4cc]

Laszlo Ersek (1):
      xen-netfront: delay gARP until backend switches to Connected
         [08e34eb14fe4cfd934b5c169a7682a969457c4ea]

Ley Foon Tan (1):
      tty/serial: Add support for Altera serial port
         [e06c93cacb82dd147266fd1bdb2d0a0bd45ff2c1]

Malcolm Priestley (1):
      staging: vt6656: Fix oops on resume from suspend.
         [6987a6dabfc40222ef767f67b57212fe3a0225fb]

Marcin Jurkowski (1):
      w1: fix oops when w1_search is called from netlink connector
         [9d1817cab2f030f6af360e961cc69bb1da8ad765]

Mark Brown (1):
      hwmon: (sht15) Check return value of regulator_enable()
         [3e78080f81481aa8340374d5a37ae033c1cf4272]

Mathias Krause (1):
      crypto: user - fix info leaks in report API
         [9a5467bf7b6e9e02ec9c3da4e23747c05faeaac6]

Mathieu Desnoyers (1):
      Fix: compat_rw_copy_check_uvector() misuse in aio, readv, writev, and security keys
         [8aec0f5d4137532de14e6554fd5dd201ff3a3c49]

Matwey V. Kornilov (1):
      usb: cp210x new Vendor/Device IDs
         [be3101c23394af59694c8a2aae6d07f5da62fea5]

Mikulas Patocka (2):
      dm snapshot: add missing module aliases
         [23cb21092eb9dcec9d3604b68d95192b79915890]
      dm: fix truncated status strings
         [fd7c092e711ebab55b2688d3859d95dfd0301f73]

NeilBrown (2):
      md: fix two bugs when attempting to resize RAID0 array.
         [a64685399181780998281fe07309a94b25dd24c3]
      md: raid0: fix error return from create_stripe_zones.
         [58ebb34c49fcfcaa029e4b1c1453d92583900f9a]

Oliver Neukum (1):
      USB: cdc-wdm: fix buffer overflow
         [c0f5ecee4e741667b2493c742b60b6218d40b3aa]

Paul Bolle (1):
      tty: serial: fix typo "ARCH_S5P6450"
         [827aa0d36d486f359808c8fb931cf7a71011a09d]

Paul Kot (1):
      batman-adv: bat_socket_read missing checks
         [c00b6856fc642b234895cfabd15b289e76726430]

Russell King (2):
      ARM: VFP: fix emulation of second VFP instruction
         [5e4ba617c1b584b2e376f31a63bd4e734109318a]
      ARM: fix scheduling while atomic warning in alignment handling code
         [b255188f90e2bade1bd11a986dd1ca4861869f4d]

Rusty Russell (1):
      hw_random: make buffer usable in scatterlist.
         [f7f154f1246ccc5a0a7e9ce50932627d60a0c878]

Sarah Sharp (4):
      USB: Don't use EHCI port sempahore for USB 3.0  hubs.
         [0fe51aa5eee51db7c7ecd201d42a977ad79c58b6]
      USB: Fix connected device switch to Inactive  state.
         [d3b9d7a9051d7024a93c76a84b2f84b3b66ad6d5]
      USB: Prepare for refactoring by adding extra udev  checks.
         [2d4fa940f99663c82ba55b2244638833b388e4e2]
      USB: Rip out recursive call on warm port reset.
         [a24a6078754f28528bc91e7e7b3e6ae86bd936d8]

Scott Ashcroft (1):
      Fix 4 port and add support for 8 port 'Unknown' PCI serial port cards
         [d13402a4a944e72612a9ec5c9190e35717c02a9d]

Sebastian Riemer (1):
      md: protect against crash upon fsync on ro array
         [bbfa57c0f2243a7c31fd248d22e9861a2802cad5]

Seiji Aguchi (1):
      efi_pstore: Check remaining space with QueryVariableInfo() before writing data
         [d80a361d779a9f19498943d1ca84243209cd5647]

Seth Heasley (2):
      ahci: AHCI-mode SATA patch for Intel Avoton DeviceIDs
         [29e674dd5c8e781589f09c3ee139c80f6da274e4]
      ahci: AHCI-mode SATA patch for Intel Lynx Point DeviceIDs
         [ea4ace66782fc35245133d2766f38d62827761cc]

Shuah Khan (1):
      iommu/amd: Initialize device table after dma_ops
         [f528d980c17b8714aedc918ba86e058af914d66b]

Steve Conklin (1):
      usb: serial: Add Rigblaster Advantage to device table
         [a57e82a18779ab8a5e5a1f5841cef937cf578913]

Steven Rostedt (1):
      ftrace: Update the kconfig for DYNAMIC_FTRACE
         [db05021d49a994ee40a9735d9c3cb0060c9babb8]

Sven Eckelmann (1):
      batman-adv: Only write requested number of byte to user buffer
         [b5a1eeef04cc7859f34dec9b72ea1b28e4aba07c]

Takashi Iwai (2):
      ALSA: seq: Fix missing error handling in snd_seq_timer_open()
         [66efdc71d95887b652a742a5dae51fa834d71465]
      ALSA: vmaster: Fix slave change notification
         [2069d483b39a603a5f3428a19d3b4ac89aa97f48]

Thomas Gleixner (1):
      btrfs: Init io_lock after cloning btrfs device struct
         [1cba0cdf5e4dbcd9e5fa5b54d7a028e55e2ca057]

Trond Myklebust (2):
      NFS: Don't allow NFS silly-renamed files to be deleted, no signal
         [5a7a613a47a715711b3f2d3322a0eac21d459166]
      SUNRPC: Don't start the retransmission timer when out of socket space
         [a9a6b52ee1baa865283a91eb8d443ee91adfca56]

Ville Syrjälä (1):
      drm/i915: Don't clobber crtc->fb when queue_flip fails
         [4a35f83b2b7c6aae3fc0d1c4554fdc99dc33ad07]

Wang YanQing (1):
      serial: 8250_pci: add support for another kind of NetMos Technology PCI 9835 Multi-I/O Controller
         [8d2f8cd424ca0b99001f3ff4f5db87c4e525f366]

Will Deacon (1):
      ARM: 7663/1: perf: fix ARMv7 EVTYPE_MASK to include NSH bit
         [f2fe09b055e2549de41fb107b34c60bac4a1b0cf]

Xiaobing Tu (1):
      Fix memory leak in cpufreq stats.
         [e37736777254ce1abc85493a5cacbefe5983b896]

 .../devicetree/bindings/tty/serial/of-serial.txt   |    3 +
 Makefile                                           |    4 +-
 arch/arm/kernel/perf_event_v7.c                    |    2 +-
 arch/arm/mm/alignment.c                            |   11 +-
 arch/arm/vfp/vfpmodule.c                           |    2 +-
 arch/powerpc/include/asm/eeh.h                     |    3 -
 arch/powerpc/kernel/of_platform.c                  |    3 -
 arch/powerpc/kernel/pci-common.c                   |    7 +-
 arch/powerpc/platforms/pseries/eeh.c               |   24 +-
 arch/x86/pci/xen.c                                 |    9 +
 crypto/ablkcipher.c                                |   12 +-
 crypto/aead.c                                      |    9 +-
 crypto/ahash.c                                     |    2 +-
 crypto/blkcipher.c                                 |    6 +-
 crypto/crypto_user.c                               |   22 +-
 crypto/pcompress.c                                 |    3 +-
 crypto/rng.c                                       |    2 +-
 crypto/shash.c                                     |    3 +-
 drivers/ata/ahci.c                                 |   40 +++
 drivers/block/loop.c                               |   24 +-
 drivers/char/hw_random/core.c                      |   19 +-
 drivers/char/hw_random/virtio-rng.c                |   13 +-
 drivers/connector/cn_proc.c                        |    8 +
 drivers/cpufreq/cpufreq_stats.c                    |    1 +
 drivers/firmware/dmi_scan.c                        |    5 +-
 drivers/firmware/efivars.c                         |  136 ++++++--
 drivers/gpu/drm/i915/intel_display.c               |   11 +-
 drivers/gpu/drm/radeon/radeon_combios.c            |    9 +
 drivers/hid/hid-core.c                             |    1 +
 drivers/hid/hid-ids.h                              |    1 +
 drivers/hid/hid-sony.c                             |   18 +-
 drivers/hv/hv_kvp.c                                |   10 +-
 drivers/hwmon/lineage-pem.c                        |    2 +
 drivers/hwmon/pmbus/ltc2978.c                      |   40 +--
 drivers/hwmon/sht15.c                              |    8 +-
 drivers/iommu/amd_iommu_init.c                     |   10 +-
 drivers/md/dm-crypt.c                              |   39 +--
 drivers/md/dm-delay.c                              |    8 +-
 drivers/md/dm-flakey.c                             |    7 +-
 drivers/md/dm-ioctl.c                              |   14 +-
 drivers/md/dm-linear.c                             |    7 +-
 drivers/md/dm-mpath.c                              |    8 +-
 drivers/md/dm-raid.c                               |    8 +-
 drivers/md/dm-raid1.c                              |    8 +-
 drivers/md/dm-snap.c                               |   18 +-
 drivers/md/dm-stripe.c                             |    7 +-
 drivers/md/dm-thin.c                               |   78 +++--
 drivers/md/md.c                                    |    7 +
 drivers/md/raid0.c                                 |    5 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |    2 +-
 drivers/net/wireless/ath/ath9k/common.h            |    2 +-
 drivers/net/wireless/ath/ath9k/htc.h               |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   18 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h  |    9 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c   |   72 ++++-
 drivers/net/wireless/mwifiex/pcie.c                |    2 +-
 drivers/net/xen-netfront.c                         |    4 +-
 drivers/scsi/dc395x.c                              |    2 +-
 drivers/staging/hv/storvsc_drv.c                   |    1 +
 drivers/staging/vt6656/main_usb.c                  |    4 -
 drivers/tty/serial/8250.c                          |   21 ++
 drivers/tty/serial/8250_pci.c                      |   21 +-
 drivers/tty/serial/Kconfig                         |    2 +-
 drivers/tty/serial/of_serial.c                     |    6 +
 drivers/tty/tty_buffer.c                           |   11 +-
 drivers/usb/class/cdc-wdm.c                        |   23 +-
 drivers/usb/core/hub.c                             |  178 ++++++-----
 drivers/usb/host/ehci-q.c                          |   18 +-
 drivers/usb/serial/cp210x.c                        |   20 ++
 drivers/usb/serial/option.c                        |    5 +
 drivers/usb/serial/qcaux.c                         |    1 +
 drivers/usb/storage/initializers.c                 |   76 +----
 drivers/usb/storage/initializers.h                 |    4 +-
 drivers/usb/storage/unusual_devs.h                 |  329 +++++++++++++++++++-
 drivers/w1/w1.c                                    |    3 +-
 drivers/xen/xen-pciback/pciback_ops.c              |    3 +-
 fs/block_dev.c                                     |    4 +-
 fs/btrfs/volumes.c                                 |    7 +
 fs/cifs/cifsfs.c                                   |    5 +
 fs/compat.c                                        |   15 +-
 fs/ext3/super.c                                    |    4 +-
 fs/fat/namei_vfat.c                                |    3 +-
 fs/nfs/unlink.c                                    |   20 +-
 fs/nls/nls_base.c                                  |   43 ++-
 fs/pipe.c                                          |    3 +
 include/linux/device-mapper.h                      |    4 +-
 include/linux/efi.h                                |    6 +
 include/linux/nls.h                                |    5 +-
 include/linux/serial_core.h                        |    5 +-
 kernel/signal.c                                    |    3 +
 kernel/trace/Kconfig                               |   24 +-
 mm/memory_hotplug.c                                |   15 +-
 mm/process_vm_access.c                             |    8 -
 net/batman-adv/icmp_socket.c                       |    5 +-
 net/decnet/af_decnet.c                             |    4 +
 net/decnet/sysctl_net_decnet.c                     |   28 ++
 net/sunrpc/xprt.c                                  |    6 +-
 security/keys/compat.c                             |    4 +-
 security/keys/process_keys.c                       |    2 +-
 sound/core/seq/seq_timer.c                         |    8 +-
 sound/core/vmaster.c                               |    5 +-
 101 files changed, 1221 insertions(+), 550 deletions(-)

-- 
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity.

