Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbaLBGD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 01:03:28 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:29209 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbaLBGD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 01:03:26 -0500
Message-ID: <547D560E.4080906@huawei.com>
Date: Tue, 2 Dec 2014 14:02:54 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: <lwn@lwn.net>
Subject: Linux 3.4.105
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 3.4.105 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
    http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary 

----------------------------------------------------------------

Al Viro (2):
      get rid of propagate_umount() mistakenly treating slaves as busy.
      don't bugger nd->seq on set_root_rcu() from follow_dotdot_rcu()

Alban Crequy (1):
      cgroup: reject cgroup names with ' '

Alex Deucher (1):
      drm/radeon: add connector quirk for fujitsu board

Andreas Rohner (1):
      nilfs2: fix data loss with mmap()

Andrew Hunter (1):
      jiffies: Fix timeval conversion to jiffies

Anton Altaparmakov (1):
      Fix nasty 32-bit overflow bug in buffer i/o code.

Aurelien Jarno (1):
      MIPS: ZBOOT: add missing <linux/string.h> include

Ben Hutchings (1):
      rtl8192ce: Fix null dereference in watchdog

Benjamin Poirier (1):
      net: Do not enable tx-nocache-copy by default

Bjørn Mork (2):
      USB: sierra: avoid CDC class functions on "68A3" devices
      USB: sierra: add 1199:68AA device ID

Charles Keepax (1):
      ASoC: samsung-i2s: Check secondary DAI exists before referencing

Christian Borntraeger (1):
      KVM: s390: Fix user triggerable bug in dead code

Clemens Ladisch (1):
      ALSA: pcm: fix fifo_size frame calculation

Cong Wang (1):
      perf: Fix a race condition in perf_remove_from_context()

David Dueck (1):
      can: at91_can: add missing prepare and unprepare of the clock

David Jander (2):
      can: flexcan: correctly initialize mailboxes
      can: flexcan: implement workaround for errata ERR005829

Dmitry Torokhov (1):
      Input: synaptics - add support for ForcePads

Eliad Peller (1):
      regulatory: add NUL to alpha2

Eric W. Biederman (1):
      mnt: Only change user settable mount flags in remount

Felipe Balbi (3):
      usb: dwc3: core: fix order of PM runtime calls
      usb: host: xhci: fix compliance mode workaround
      bluetooth: hci_ldisc: fix deadlock condition

Guillaume Nault (1):
      l2tp: fix race while getting PMTU on PPP pseudo-wire

Hannes Frederic Sowa (1):
      ipv6: reuse ip6_frag_id from ip6_ufo_append_data

Hans de Goede (3):
      Input: elantech - fix detection of touchpad on ASUS s301l
      Input: i8042 - add Fujitsu U574 to no_timeout dmi table
      Input: i8042 - add nomux quirk for Avatar AVIU-145A6

Honggang Li (1):
      percpu: free percpu allocation info for uniprocessor system

Ilya Dryomov (2):
      libceph: add process_one_ticket() helper
      libceph: do not hard code max auth ticket len

James Bottomley (1):
      Fix spurious request sense in error handling

James Ralston (2):
      ahci: Add Device IDs for Intel 9 Series PCH
      ata_piix: Add Device IDs for Intel 9 Series PCH

Jens Axboe (1):
      genhd: fix leftover might_sleep() in blk_free_devt()

Jiri Kosina (1):
      ACPI / cpuidle: fix deadlock between cpuidle_lock and cpu_hotplug.lock

Joe Lawrence (1):
      usb: hub: take hub->hdev reference when processing from eventlist

Joern Engel (1):
      iscsi-target: avoid NULL pointer in iscsi_copy_param_list failure

Johan Hovold (1):
      USB: ftdi_sio: add support for NOVITUS Bono E thermal printer

Johannes Berg (1):
      nl80211: clear skb cb before passing to netlink

John David Anglin (1):
      parisc: Only use -mfast-indirect-calls option for 32-bit kernel builds

John Sung (1):
      Input: serport - add compat handling for SPIOCSTYPE ioctl

Joseph Qi (1):
      ocfs2/dlm: do not get resource spinlock if lockres is new

Josh Triplett (1):
      init/Kconfig: Hide printk log config if CONFIG_PRINTK=n

Keith Busch (1):
      block: Fix dev_t minor allocation lifetime

Larry Finger (1):
      rtlwifi: rtl8192cu: Add new ID

Marc Kleine-Budde (2):
      can: flexcan: mark TX mailbox as TX_INACTIVE
      can: flexcan: put TX mailbox into TX_INACTIVE mode after tx-complete

Marcelo Ricardo Leitner (3):
      ipv4: move route garbage collector to work queue
      ipv4: avoid parallel route cache gc executions
      ipv4: disable bh while doing route gc

Mark (4):
      storage: Add single-LUN quirk for Jaz USB Adapter
      USB: storage: Add quirk for Adaptec USBConnect 2000 USB-to-SCSI Adapter
      USB: storage: Add quirk for Ariston Technologies iConnect USB to SCSI adapter
      USB: storage: Add quirks for Entrega/Xircom USB to SCSI converters

Mark Brown (1):
      regmap: Fix handling of volatile registers for format_write() chips

Markos Chandras (1):
      MIPS: mcount: Adjust stack pointer for static trace in MIPS32

Mathias Krause (1):
      drm/i915: Remove bogus __init annotation from DMI callbacks

Mathias Nyman (1):
      xhci: Fix null pointer dereference if xhci initialization fails

Mel Gorman (1):
      mm: migrate: Close race between migration completion and mprotect

Mike Christie (1):
      libiscsi: fix potential buffer overrun in __iscsi_conn_send_pdu

Miklos Szeredi (1):
      shmem: fix nlink for rename overwrite directory

Mikulas Patocka (1):
      dm crypt: fix access beyond the end of allocated space

Murali Karicheri (1):
      ahci: add pcid for Marvel 0x9182 controller

Narendra K (1):
      ixgbevf: Prevent RX/TX statistics getting reset to zero

Nicholas Bellinger (1):
      iscsi-target: Fix memory corruption in iscsit_logout_post_handler_diffcid

Pawel Moll (1):
      perf: Handle compat ioctl

Peter Zijlstra (1):
      perf: fix perf bug in fork()

Richard Larocque (3):
      alarmtimer: Return relative times in timer_gettime
      alarmtimer: Do not signal SIGEV_NONE timers
      alarmtimer: Lock k_itimer during timer callback

Robin Murphy (1):
      ARM: 8165/1: alignment: don't break misaligned NEON load/store

Ross Lagerwall (1):
      xen/manage: Always freeze/thaw processes when suspend/resuming

Sage Weil (1):
      libceph: gracefully handle large reply messages from the mon

Sergio Gelato (1):
      NFS: fix stable regression

Takashi Iwai (1):
      ALSA: hda - Fix COEF setups for ALC1150 codec

Taylor Braun-Jones (1):
      USB: ftdi_sio: Add support for GE Healthcare Nemo Tracker device

Tejun Heo (2):
      percpu: fix pcpu_alloc_pages() failure path
      percpu: perform tlb flush after pcpu_map_pages() failure

Theodore Ts'o (2):
      ext4: propagate errors up to ext4_find_entry()'s callers
      ext4: avoid trying to kfree an ERR_PTR pointer

Thomas Gleixner (1):
      futex: Unlock hb->lock in futex_wait_requeue_pi() error path

Thomas Hellstrom (1):
      drm/vmwgfx: Fix a potential infinite spin waiting for fifo idle

Thomas Pugliese (1):
      uwb: init beacon cache entry before registering uwb device

Trond Myklebust (1):
      NFSv4: Fix another bug in the close/open_downgrade code

Wanpeng Li (1):
      sched: Fix unreleased llc_shared_mask bit during CPU hotplug

Xiubo Li (1):
      ASoC: core: fix possible ZERO_SIZE_PTR pointer dereferencing error.

Zefan Li (3):
      sched: add macros to define bitops for task atomic flags
      cpuset: PF_SPREAD_PAGE and PF_SPREAD_SLAB should be atomic flags
      Linux 3.4.105

 Documentation/cgroups/cpusets.txt                 |   6 +-
 Makefile                                          |   2 +-
 arch/arm/mm/alignment.c                           |   3 +
 arch/mips/boot/compressed/decompress.c            |   1 +
 arch/mips/kernel/mcount.S                         |  12 +
 arch/parisc/Makefile                              |   7 +-
 arch/s390/kvm/kvm-s390.c                          |  11 -
 arch/x86/kernel/smpboot.c                         |   3 +
 block/genhd.c                                     |  20 +-
 block/partition-generic.c                         |   2 +-
 drivers/acpi/processor_idle.c                     |   4 +-
 drivers/ata/ahci.c                                |  10 +
 drivers/ata/ata_piix.c                            |   8 +
 drivers/base/regmap/regmap.c                      |   2 +-
 drivers/bluetooth/hci_ldisc.c                     |  25 ++-
 drivers/bluetooth/hci_uart.h                      |   2 +
 drivers/gpu/drm/i915/intel_bios.c                 |   2 +-
 drivers/gpu/drm/i915/intel_crt.c                  |   2 +-
 drivers/gpu/drm/i915/intel_lvds.c                 |   2 +-
 drivers/gpu/drm/radeon/radeon_atombios.c          |   7 +
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c              |   3 +-
 drivers/input/mouse/elantech.c                    |   7 +
 drivers/input/mouse/synaptics.c                   |  68 ++++--
 drivers/input/mouse/synaptics.h                   |  11 +
 drivers/input/serio/i8042-x86ia64io.h             |  15 ++
 drivers/input/serio/serport.c                     |  45 +++-
 drivers/md/dm-crypt.c                             |  20 +-
 drivers/net/can/at91_can.c                        |   8 +-
 drivers/net/can/flexcan.c                         |  41 +++-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |  12 -
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c |   3 +
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c       |   1 +
 drivers/scsi/libiscsi.c                           |  10 +
 drivers/scsi/scsi_error.c                         |   9 +
 drivers/target/iscsi/iscsi_target.c               |   4 +-
 drivers/target/iscsi/iscsi_target_parameters.c    |   2 +-
 drivers/usb/core/hub.c                            |   4 +-
 drivers/usb/dwc3/core.c                           |   6 +-
 drivers/usb/host/xhci-hub.c                       |   8 +-
 drivers/usb/host/xhci-mem.c                       |   2 +-
 drivers/usb/serial/ftdi_sio.c                     |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                 |  12 +
 drivers/usb/serial/sierra.c                       |   9 +-
 drivers/usb/storage/unusual_devs.h                |  38 ++++
 drivers/uwb/lc-dev.c                              |  13 +-
 drivers/xen/manage.c                              |   7 -
 fs/buffer.c                                       |   6 +-
 fs/ext4/ext4.h                                    |   2 +-
 fs/ext4/namei.c                                   |  32 ++-
 fs/ext4/resize.c                                  |   2 +
 fs/namei.c                                        |  30 +--
 fs/namespace.c                                    |   6 +-
 fs/nfs/nfs4proc.c                                 |  30 +--
 fs/nfsd/vfs.c                                     |   3 +
 fs/nilfs2/inode.c                                 |   7 +-
 fs/ocfs2/dlm/dlmmaster.c                          |  18 +-
 fs/pnode.c                                        |   4 +-
 include/linux/cpuset.h                            |   4 +-
 include/linux/jiffies.h                           |  12 -
 include/linux/mount.h                             |   4 +-
 include/linux/sched.h                             |  25 ++-
 include/net/regulatory.h                          |   2 +-
 init/Kconfig                                      |   1 +
 kernel/cgroup.c                                   |   5 +
 kernel/cpuset.c                                   |   9 +-
 kernel/events/core.c                              |  36 ++-
 kernel/fork.c                                     |   5 +-
 kernel/futex.c                                    |   1 +
 kernel/time.c                                     |  54 +++--
 kernel/time/alarmtimer.c                          |  40 +++-
 mm/migrate.c                                      |   5 +-
 mm/percpu-vm.c                                    |  22 +-
 mm/percpu.c                                       |   2 +
 mm/shmem.c                                        |   4 +-
 mm/slab.c                                         |   4 +-
 net/ceph/auth_x.c                                 | 256 ++++++++++++----------
 net/ceph/mon_client.c                             |   8 +
 net/core/dev.c                                    |   5 -
 net/ipv4/route.c                                  |  58 +++--
 net/ipv6/udp.c                                    |   2 +-
 net/l2tp/l2tp_ppp.c                               |   3 +-
 net/wireless/nl80211.c                            |   6 +
 scripts/tags.sh                                   |  10 +-
 sound/core/pcm_lib.c                              |   8 +-
 sound/pci/hda/patch_realtek.c                     |   2 +
 sound/soc/samsung/i2s.c                           |   2 +-
 sound/soc/soc-core.c                              |   2 +-
 87 files changed, 851 insertions(+), 378 deletions(-) 
