Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab3CLWca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:32:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab3CLWc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:32:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 000/100] 3.8.3-stable review
Date: Tue, 12 Mar 2013 15:30:45 -0700
Message-Id: <20130312223122.884099393@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.8.3 release.
There are 100 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Mar 14 22:30:28 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.8.3-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.8.3-rc1

Hauke Mehrtens <hauke@hauke-m.de>
    w1-gpio: fix section mismatch

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "xen/blkback: Don't trust the handle from the frontend."

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    USB: Fix connected device switch to Inactive state.

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    USB: Rip out recursive call on warm port reset.

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    USB: Prepare for refactoring by adding extra udev checks.

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    USB: Don't use EHCI port sempahore for USB 3.0 hubs.

Matthew Garrett <matthew.garrett@nebula.com>
    efi: be more paranoid about available space when creating variables

Seiji Aguchi <seiji.aguchi@hds.com>
    efivars: Disable external interrupt while holding efivars->lock

Steven Rostedt <srostedt@redhat.com>
    ftrace: Update the kconfig for DYNAMIC_FTRACE

Michael Ellerman <michael@ellerman.id.au>
    powerpc: Apply early paca fixups to boot_paca and the boot cpu's paca

Jason Cooper <jason@lakedaemon.net>
    ARM: kirkwood: of_serial: fix clock gating by removing clock-frequency

Fabio Estevam <fabio.estevam@freescale.com>
    ARM: mxs_defconfig: Make USB host functional again

Andrew Lunn <andrew@lunn.ch>
    gpio: mvebu: Add clk support to prevent lockup

Andrew Lunn <andrew@lunn.ch>
    rtc: rtc-mv: Add support for clk to avoid lockups

Al Viro <viro@ZenIV.linux.org.uk>
    vfs: fix pipe counter breakage

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    Fix: compat_rw_copy_check_uvector() misuse in aio, readv, writev, and security keys

David Howells <dhowells@redhat.com>
    keys: fix race with concurrent install_user_keyrings()

Ming Lei <ming.lei@canonical.com>
    usbnet: smsc95xx: fix suspend failure

Lee, Chun-Yi <joeyli.kernel@gmail.com>
    acer-wmi: avoid the warning of 'devices' may be used uninitialized

Mathias Krause <minipli@googlemail.com>
    crypto: user - fix info leaks in report API

Wei WANG <wei_wang@realsil.com.cn>
    mfd: rtsx: Fix issue that booting OS with SD card inserted

Wei WANG <wei_wang@realsil.com.cn>
    mfd: rtsx: Optimize card detect flow

Peter Hurley <peter@hurleysoftware.com>
    x86/kvm: Fix pvclock vsyscall fixmap

Josef Bacik <jbacik@fusionio.com>
    Btrfs: cleanup orphan reservation if truncate fails

Josef Bacik <jbacik@fusionio.com>
    Btrfs: account for orphan inodes properly during cleanup

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: logitech-dj: do not directly call hid_output_raw_report() during probe

Marcelo Tosatti <mtosatti@redhat.com>
    x86: pvclock kvm: align allocation size to page size

Eric W. Biederman <ebiederm@xmission.com>
    userns: Stop oopsing in key_change_session_keyring

Matt Fleming <matt.fleming@intel.com>
    efivarfs: return accurate error code in efivarfs_fill_super()

Matt Fleming <matt.fleming@intel.com>
    efivars: efivarfs_valid_name() should handle pstore syntax

Nithin Sujir <nsujir@broadcom.com>
    tg3: Update link_up flag for phylib devices

Konstantin Khlebnikov <khlebnikov@openvz.org>
    e1000e: fix pci-device enable-counter balance

Ben Greear <greearb@candelatech.com>
    mac80211: Fix crash due to un-canceled work-items

Pavel Shilovsky <piastry@etersoft.ru>
    CIFS: Fix missing of oplock_read value in smb30_values structure

Hillf Danton <dhillf@gmail.com>
    mm/mempolicy.c: fix wrong sp_node insertion

Theodore Ts'o <tytso@mit.edu>
    random: fix locking dependency with the tasklist_lock

Chris Metcalf <cmetcalf@tilera.com>
    tile: work around bug in the generic sys_llseek

Eric W. Biederman <ebiederm@xmission.com>
    proc: Use nd_jump_link in proc_ns_follow_link

Linus Torvalds <torvalds@linux-foundation.org>
    vfs: don't BUG_ON() if following a /proc fd pseudo-symlink results in a symlink

Takashi Iwai <tiwai@suse.de>
    ALSA: vmaster: Fix slave change notification

Sean Connor <sconnor004@allyinics.org>
    ALSA: ice1712: Initialize card->private_data properly

Ben Hutchings <ben@decadent.org.uk>
    dmi_scan: fix missing check for _DMI_ signature in smbios_present()

Peter Hurley <peter@hurleysoftware.com>
    ipc: don't allocate a copy larger than max

Peter Hurley <peter@hurleysoftware.com>
    ipc: fix potential oops when src msg > 4k w/ MSG_COPY

Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
    drm/i915: Turn off hsync and vsync on ADPA when disabling crt

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: enable irqs earlier when resuming

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: reorder setup sequence to have irqs for output setup

Kenneth Graunke <kenneth@whitecape.org>
    drm/i915: Fix Haswell/CRW PCI IDs.

Stéphane Marchesin <marcheu@chromium.org>
    drm/i915: Increase the RC6p threshold.

Will Deacon <will.deacon@arm.com>
    ARM: 7663/1: perf: fix ARMv7 EVTYPE_MASK to include NSH bit

Will Deacon <will.deacon@arm.com>
    ARM: 7659/1: mm: make mm->context.id an atomic64_t variable

Will Deacon <will.deacon@arm.com>
    ARM: 7658/1: mm: fix race updating mm->context.id on ASID rollover

Will Deacon <will.deacon@arm.com>
    ARM: 7657/1: head: fix swapper and idmap population with LPAE and big-endian

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add primary dac adj quirk for R200 board

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: don't set hpd, afmt interrupts when interrupts are disabled

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus/ltc2978) Use detected chip ID to select supported functionality

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus/ltc2978) Fix peak attribute handling

Mark Brown <broonie@opensource.wolfsonmicro.com>
    hwmon: (sht15) Check return value of regulator_enable()

NeilBrown <neilb@suse.de>
    md/raid1,raid10: fix deadlock with freeze_array()

NeilBrown <neilb@suse.de>
    md: raid0: fix error return from create_stripe_zones.

NeilBrown <neilb@suse.de>
    md: fix two bugs when attempting to resize RAID0 array.

Sebastian Riemer <sebastian.riemer@profitbricks.com>
    md: protect against crash upon fsync on ro array

Frederic Weisbecker <fweisbec@gmail.com>
    nohz: Make tick_nohz_irq_exit() irq safe

Kees Cook <keescook@chromium.org>
    proc connector: reject unprivileged listener bumps

Felix Fietkau <nbd@openwrt.org>
    ath9k_hw: improve reset reliability after errors

Felix Fietkau <nbd@openwrt.org>
    ath9k_htc: fix signal strength handling issues

Felix Fietkau <nbd@openwrt.org>
    ath9k: fix RSSI dummy marker value

Bing Zhao <bzhao@marvell.com>
    libertas: fix crash for SD8688

Avinash Patil <patila@marvell.com>
    mwifiex: correct sleep delay counter

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: always copy first 16 bytes of commands

Rusty Russell <rusty@rustcorp.com.au>
    hw_random: make buffer usable in scatterlist.

Weston Andros Adamson <dros@netapp.com>
    NFSv4.1: Hold reference to layout hdr in layoutget

Benny Halevy <bhalevy@tonian.com>
    pnfs: fix resend_to_mds for directio

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Don't start the retransmission timer when out of socket space

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFS: Don't allow NFS silly-renamed files to be deleted, no signal

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: add missing module aliases

Mike Christie <michaelc@cs.wisc.edu>
    dm: fix limits initialization when there are no data devices

Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
    dm: do not replace bioset for request based dm

Mikulas Patocka <mpatocka@redhat.com>
    dm: fix truncated status strings

Jeff Layton <jlayton@redhat.com>
    cifs: ensure that cifs_get_root() only traverses directories

Josef Bacik <jbacik@fusionio.com>
    Btrfs: delete inline extents when we find them during logging

Josef Bacik <jbacik@fusionio.com>
    Btrfs: copy everything if we've created an inline extent

Thomas Gleixner <tglx@linutronix.de>
    btrfs: Init io_lock after cloning btrfs device struct

Lukas Czerner <lczerner@redhat.com>
    ext4: convert number of blocks to clusters properly

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fix immediate queue starvation regression with DATAIN

Asias He <asias@redhat.com>
    target/pscsi: Fix page increment

K. Y. Srinivasan <kys@microsoft.com>
    SCSI: storvsc: Initialize the sglist

Dan Carpenter <dan.carpenter@oracle.com>
    SCSI: dc395x: uninitialized variable in device_alloc()

Mattia Dongili <malattia@linux.it>
    sony-laptop: fully enable SNY controlled modems

Takahisa Tanaka <mc74hc00@gmail.com>
    watchdog: sp5100_tco: Write back the original value to reserved bits, instead of zero

Takahisa Tanaka <mc74hc00@gmail.com>
    watchdog: sp5100_tco: Fix wrong indirect I/O access for getting value of reserved bits

Randy Dunlap <rdunlap@infradead.org>
    watchdog: da9055_wdt needs to select WATCHDOG_CORE

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/pci: We don't do multiple MSI's.

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/pat: Disable PAT using pat_enabled value.

Steven Noonan <steven@uplinklabs.net>
    xenbus: fix compile failure on ARM with Xen enabled

Alan Stern <stern@rowland.harvard.edu>
    USB: EHCI: revert "remove ASS/PSS polling timeout"

Catalin Marinas <catalin.marinas@arm.com>
    ARM: 7654/1: Preserve L_PTE_VALID in pte_modify()

Nicolas Pitre <nicolas.pitre@linaro.org>
    ARM: 7653/2: do not scale loops_per_jiffy when using a constant delay clock

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: fix scheduling while atomic warning in alignment handling code

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: VFP: fix emulation of second VFP instruction


-------------

Diffstat:

 Makefile                                      |   4 +-
 arch/arm/boot/dts/kirkwood-dns320.dts         |   2 -
 arch/arm/boot/dts/kirkwood-dns325.dts         |   1 -
 arch/arm/boot/dts/kirkwood-dockstar.dts       |   1 -
 arch/arm/boot/dts/kirkwood-dreamplug.dts      |   1 -
 arch/arm/boot/dts/kirkwood-goflexnet.dts      |   1 -
 arch/arm/boot/dts/kirkwood-ib62x0.dts         |   1 -
 arch/arm/boot/dts/kirkwood-iconnect.dts       |   1 -
 arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts |   1 -
 arch/arm/boot/dts/kirkwood-km_kirkwood.dts    |   1 -
 arch/arm/boot/dts/kirkwood-lschlv2.dts        |   1 -
 arch/arm/boot/dts/kirkwood-lsxhl.dts          |   1 -
 arch/arm/boot/dts/kirkwood-mplcec4.dts        |   1 -
 arch/arm/boot/dts/kirkwood-ns2-common.dtsi    |   1 -
 arch/arm/boot/dts/kirkwood-nsa310.dts         |   1 -
 arch/arm/boot/dts/kirkwood-openblocks_a6.dts  |   2 -
 arch/arm/boot/dts/kirkwood-topkick.dts        |   1 -
 arch/arm/boot/dts/kirkwood.dtsi               |   5 +-
 arch/arm/configs/mxs_defconfig                |   1 +
 arch/arm/include/asm/delay.h                  |   1 +
 arch/arm/include/asm/mmu.h                    |   8 ++--
 arch/arm/include/asm/mmu_context.h            |   2 +-
 arch/arm/include/asm/pgtable.h                |   3 +-
 arch/arm/kernel/asm-offsets.c                 |   2 +-
 arch/arm/kernel/head.S                        |  26 +++++++++--
 arch/arm/kernel/perf_event_v7.c               |   2 +-
 arch/arm/kernel/smp.c                         |   3 ++
 arch/arm/lib/delay.c                          |   1 +
 arch/arm/mm/alignment.c                       |  11 ++---
 arch/arm/mm/context.c                         |  25 ++++++----
 arch/arm/vfp/vfpmodule.c                      |   2 +-
 arch/powerpc/kernel/setup_64.c                |  16 +++++--
 arch/tile/include/asm/compat.h                |   3 ++
 arch/tile/kernel/compat.c                     |  13 ++++++
 arch/x86/kernel/kvmclock.c                    |  11 +++--
 arch/x86/kernel/pvclock.c                     |   2 +-
 arch/x86/pci/xen.c                            |   9 ++++
 arch/x86/xen/enlighten.c                      |  10 +++-
 crypto/ablkcipher.c                           |  12 ++---
 crypto/aead.c                                 |   9 ++--
 crypto/ahash.c                                |   2 +-
 crypto/blkcipher.c                            |   6 +--
 crypto/crypto_user.c                          |  22 ++++-----
 crypto/pcompress.c                            |   3 +-
 crypto/rng.c                                  |   2 +-
 crypto/shash.c                                |   3 +-
 drivers/block/xen-blkback/blkback.c           |   1 +
 drivers/char/hw_random/core.c                 |  19 ++++++--
 drivers/char/random.c                         |  12 +++--
 drivers/connector/cn_proc.c                   |   8 ++++
 drivers/firmware/dmi_scan.c                   |   5 +-
 drivers/firmware/efivars.c                    | 210 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------
 drivers/gpio/gpio-mvebu.c                     |   7 +++
 drivers/gpu/drm/i915/i915_dma.c               |  23 +++++----
 drivers/gpu/drm/i915/i915_drv.c               |  25 +++++++---
 drivers/gpu/drm/i915/i915_drv.h               |   1 +
 drivers/gpu/drm/i915/i915_irq.c               |   4 ++
 drivers/gpu/drm/i915/intel_crt.c              |   2 +-
 drivers/gpu/drm/i915/intel_pm.c               |   2 +-
 drivers/gpu/drm/radeon/radeon_combios.c       |   9 ++++
 drivers/gpu/drm/radeon/radeon_irq_kms.c       |  12 +++++
 drivers/hid/hid-logitech-dj.c                 |  22 +++++----
 drivers/hwmon/pmbus/ltc2978.c                 |  30 ++++++------
 drivers/hwmon/sht15.c                         |   8 +++-
 drivers/md/dm-crypt.c                         |  39 ++++------------
 drivers/md/dm-delay.c                         |   8 ++--
 drivers/md/dm-flakey.c                        |   7 ++-
 drivers/md/dm-ioctl.c                         |  14 ++++--
 drivers/md/dm-linear.c                        |   7 ++-
 drivers/md/dm-mpath.c                         |   8 ++--
 drivers/md/dm-raid.c                          |   8 ++--
 drivers/md/dm-raid1.c                         |   8 ++--
 drivers/md/dm-snap.c                          |  18 ++++---
 drivers/md/dm-stripe.c                        |   7 ++-
 drivers/md/dm-thin.c                          |  80 +++++++++++++++++++------------
 drivers/md/dm-verity.c                        |   8 ++--
 drivers/md/dm.c                               |  42 +++++++++++------
 drivers/md/md.c                               |   7 +++
 drivers/md/raid0.c                            |   5 +-
 drivers/md/raid1.c                            |   1 +
 drivers/md/raid10.c                           |   1 +
 drivers/memstick/host/rtsx_pci_ms.c           |   7 +++
 drivers/mfd/rtsx_pcr.c                        |  61 +++++++++++++++++++-----
 drivers/mmc/host/rtsx_pci_sdmmc.c             |  18 +++++++
 drivers/net/ethernet/broadcom/tg3.c           |  14 ++----
 drivers/net/ethernet/intel/e1000e/netdev.c    |   2 +-
 drivers/net/usb/smsc95xx.c                    |   6 +++
 drivers/net/wireless/ath/ath9k/common.h       |   2 +-
 drivers/net/wireless/ath/ath9k/htc.h          |   1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |  18 ++++---
 drivers/net/wireless/ath/ath9k/hw.c           |   4 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h   |  10 ++--
 drivers/net/wireless/iwlwifi/pcie/internal.h  |   9 ++++
 drivers/net/wireless/iwlwifi/pcie/tx.c        |  75 ++++++++++++++++++++++-------
 drivers/net/wireless/libertas/if_sdio.c       |   6 ++-
 drivers/net/wireless/mwifiex/pcie.c           |   2 +-
 drivers/platform/x86/acer-wmi.c               |   3 ++
 drivers/platform/x86/sony-laptop.c            |   2 +-
 drivers/rtc/rtc-mv.c                          |  28 +++++++++--
 drivers/scsi/dc395x.c                         |   2 +-
 drivers/scsi/storvsc_drv.c                    |   1 +
 drivers/target/iscsi/iscsi_target.c           |  11 ++++-
 drivers/target/target_core_pscsi.c            |   1 -
 drivers/usb/core/hub.c                        | 178 ++++++++++++++++++++++++++++++++++++---------------------------------
 drivers/usb/host/ehci-timer.c                 |  29 ++++++------
 drivers/w1/masters/w1-gpio.c                  |   2 +-
 drivers/watchdog/Kconfig                      |   1 +
 drivers/watchdog/sp5100_tco.c                 |  27 ++++-------
 drivers/xen/xenbus/xenbus_client.c            |   1 +
 fs/btrfs/inode.c                              |   4 ++
 fs/btrfs/tree-log.c                           |  18 +++++++
 fs/btrfs/volumes.c                            |   1 +
 fs/cifs/cifsfs.c                              |   5 ++
 fs/cifs/smb2ops.c                             |   1 +
 fs/compat.c                                   |  15 +++---
 fs/ext4/balloc.c                              |   2 +-
 fs/ext4/mballoc.c                             |   8 ++--
 fs/ext4/resize.c                              |   6 +--
 fs/ext4/super.c                               |   2 +-
 fs/namei.c                                    |   2 -
 fs/nfs/nfs4filelayout.c                       |   6 ++-
 fs/nfs/nfs4proc.c                             |  11 ++++-
 fs/nfs/pnfs.c                                 |  14 ++++--
 fs/nfs/pnfs.h                                 |   6 ++-
 fs/nfs/unlink.c                               |  20 +++++---
 fs/pipe.c                                     |   3 ++
 fs/proc/namespaces.c                          |  12 ++---
 include/linux/device-mapper.h                 |   4 +-
 include/linux/mfd/rtsx_pci.h                  |   2 +
 ipc/msg.c                                     |   6 ++-
 ipc/msgutil.c                                 |   3 --
 kernel/time/tick-sched.c                      |   7 ++-
 kernel/trace/Kconfig                          |  24 ++++++----
 mm/mempolicy.c                                |   2 +-
 mm/process_vm_access.c                        |   8 ----
 net/mac80211/mlme.c                           |  11 +++++
 net/sunrpc/xprt.c                             |   6 ++-
 security/keys/compat.c                        |   4 +-
 security/keys/process_keys.c                  |   4 +-
 sound/core/vmaster.c                          |   5 +-
 sound/pci/ice1712/ice1712.c                   |   2 +
 141 files changed, 1044 insertions(+), 606 deletions(-)


