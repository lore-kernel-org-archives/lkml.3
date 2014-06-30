Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaF3Lva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:51:30 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51906 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831AbaF3Lv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:51:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 000/181] 3.12.24-stable review
Date: Mon, 30 Jun 2014 13:51:22 +0200
Message-Id: <cover.1404128997.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.12.24 release.
There are 181 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Jul  2 11:49:58 2014
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	http://kernel.org/pub/linux/kernel/people/jirislaby/stable-review/patch-3.12.24-rc1.xz
and the diffstat can be found below.

thanks,
js

===============


Aaron Lu (1):
  ACPI / video: clean up DMI table for initial black screen problem

Alan Stern (2):
  USB: usbtest: add a timeout for scatter-gather tests
  USB: EHCI: avoid BIOS handover on the HASEE E200

Aleksander Morgado (2):
  usb: qcserial: add Netgear AirCard 341U
  usb: qcserial: add additional Sierra Wireless QMI devices

Anatol Pomozov (1):
  aio: block io_destroy() until all context requests are completed

Andrzej Zaborowski (1):
  efi-pstore: Fix an overflow on 32-bit builds

Andy Lutomirski (1):
  x86_32, entry: Do syscall exit work on badsys (CVE-2014-4508)

Anssi Hannula (1):
  ALSA: hda - hdmi: Use TFx channel positions instead of FxH

Anton Blanchard (1):
  KVM: PPC: Book3S HV: Fix KVM hang with CONFIG_KVM_XICS=n

Ben Hutchings (1):
  net/compat: Fix minor information leak in siocdevprivate_ioctl()

Benjamin LaHaise (3):
  aio: fix kernel memory disclosure in io_getevents() introduced in
    v3.10
  aio: fix aio request leak when events are reaped by userspace
  aio: fix kernel memory disclosure in io_getevents() introduced in
    v3.10

Benjamin Poirier (1):
  net: Do not enable tx-nocache-copy by default

Bjørn Mork (3):
  usb: qcserial: fix multiline comment coding style
  usb: qcserial: refactor device layout selection
  usb: qcserial: define and use Sierra Wireless layout

Chen Gang (1):
  arch/unicore32/mm/alignment.c: include "asm/pgtable.h" to avoid
    compiling error

Chris Mason (1):
  Btrfs: fix double free in find_lock_delalloc_range

Christian Borntraeger (1):
  s390/lowcore: reserve 96 bytes for IRB in lowcore

Dan Carpenter (3):
  iio: adc: at91: signedness bug in at91_adc_get_trigger_value_by_name()
  Staging: rtl8188eu: overflow in update_sta_support_rate()
  applicom: dereferencing NULL on error path

Dave Chinner (3):
  xfs: prevent deadlock trying to cover an active log
  xfs: prevent stack overflows from page cache allocation
  xfs: xfs_remove deadlocks due to inverted AGF vs AGI lock ordering

David Binderman (1):
  ACPICA: utstring: Check array index bound before use.

David Henningsson (1):
  ALSA: hda - Add quirk for external mic on Lifebook U904

Eric Sandeen (3):
  xfs: don't emit corruption noise on fs probes
  xfs: don't break from growfs ag update loop on error
  btrfs: fix use of uninit "ret" in end_extent_writepage()

Ezequiel Garcia (1):
  media: stk1160: Avoid stack-allocated buffer for control URBs

Fathi Boudra (1):
  builddeb: use $OBJCOPY variable instead of objcopy

Felipe Balbi (2):
  usb: dwc3: gadget: clear stall when disabling endpoint
  bluetooth: hci_ldisc: fix deadlock condition

Filipe David Borba Manana (3):
  Btrfs: fix tracking of orphan inode count
  Btrfs: fix sync fs to actually wait for all data to be persisted
  Btrfs: don't leak block group on error

Filipe Manana (1):
  Btrfs: send, don't error in the presence of subvols/snapshots

Geyslan G. Bem (1):
  xfs: fix possible NULL dereference in xlog_verify_iclog

Goldwyn Rodrigues (1):
  ocfs2: revert iput deferring code in ocfs2_drop_dentry_lock

Greg Kroah-Hartman (3):
  lzo: properly check for overruns
  lz4: ensure length does not wrap
  lz4: fix another possible overrun

Guenter Roeck (1):
  mfd: sm501: dbg_regs attribute must be read-only

H. Peter Anvin (1):
  x86-32, espfix: Remove filter for espfix32 due to race

Huang Rui (1):
  usb: usbtest: fix unlink write error with pattern 1

Hugh Dickins (1):
  mm: fix sleeping function warning from __put_anon_vma

J. Bruce Fields (2):
  GFS2: revert "GFS2: d_splice_alias() can't return error"
  nfsd4: fix FREE_STATEID lockowner leak

James Hogan (2):
  serial: 8250_dw: Fix LCR workaround regression
  MIPS: KVM: Allocate at least 16KB for exception handlers

Jan Kara (5):
  ocfs2: move dquot_initialize() in ocfs2_delete_inode() somewhat later
  quota: provide function to grab quota structure reference
  ocfs2: implement delayed dropping of last dquot reference
  ocfs2: avoid blocking in ocfs2_mark_lockres_freeing() in downconvert
    thread
  ext4: fix zeroing of page during writeback

Jeff Layton (2):
  nfsd: don't try to reuse an expired DRC entry off the list
  nfsd: don't halt scanning the DRC LRU list when there's an RC_INPROG
    entry

Jiang Liu (1):
  intel_idle: close avn_cstates array with correct marker

Jianguo Wu (1):
  ARM: 8037/1: mm: support big-endian page tables

Jie Liu (3):
  xfs: fix the wrong new_size/rnew_size at xfs_iext_realloc_direct()
  xfs: fix the extent count when allocating an new indirection array
    entry
  xfs: don't perform discard if the given range length is less than
    block size

Jiri Slaby (1):
  Revert "bio-integrity: Fix bio_integrity_verify segment start bug"

Johan Hedberg (2):
  Bluetooth: Fix redundant encryption request for reauthentication
  Bluetooth: Fix check for connection encryption

Johan Hovold (20):
  USB: cdc-acm: fix write and suspend race
  USB: cdc-acm: fix write and resume race
  USB: cdc-acm: fix broken runtime suspend
  USB: cdc-acm: fix runtime PM for control messages
  USB: cdc-acm: fix shutdown and suspend race
  USB: cdc-acm: fix potential urb leak and PM imbalance in write
  USB: cdc-acm: fix I/O after failed open
  USB: cdc-acm: fix runtime PM imbalance at shutdown
  net: cpsw: fix null dereference at probe
  USB: option: fix runtime PM handling
  USB: usb_wwan: fix write and suspend race
  USB: usb_wwan: fix urb leak at shutdown
  USB: usb_wwan: fix potential NULL-deref at resume
  USB: usb_wwan: fix potential blocked I/O after resume
  USB: sierra: fix AA deadlock in open error path
  USB: sierra: fix use after free at suspend/resume
  USB: sierra: fix urb and memory leak in resume error path
  USB: sierra: fix urb and memory leak on disconnect
  USB: sierra: fix remote wakeup
  USB: serial: fix potential runtime pm imbalance at device remove

Johannes Weiner (1):
  mm: vmscan: clear kswapd's special reclaim powers before exiting

Josef Bacik (4):
  Btrfs: do not release metadata for space cache inodes
  Btrfs: cleanup transaction on abort
  Btrfs: don't delete ordered roots from list during cleanup
  Btrfs: fix two use-after-free bugs with transaction cleanup

Jukka Taimisto (1):
  Bluetooth: Fix L2CAP deadlock

K. Y. Srinivasan (1):
  Drivers: hv: balloon: Ensure pressure reports are posted regularly

Kailang Yang (1):
  ALSA: hda/realtek - Add support of ALC891 codec

Kees Cook (1):
  HID: core: fix validation of report id 0

Konstantin Khlebnikov (1):
  epoll: fix use-after-free in eventpoll_release_file

Krzysztof Kozlowski (2):
  extcon: max8997: Fix NULL pointer exception on missing pdata
  extcon: max77693: Fix two NULL pointer exceptions on missing pdata

Lai Jiangshan (1):
  idr: fix overflow bug during maximum ID calculation at maximum height

Lars-Peter Clausen (5):
  ALSA: control: Protect user controls against concurrent access
  ALSA: control: Fix replacing user controls
  ALSA: control: Don't access controls outside of protected regions
  ALSA: control: Handle numid overflow
  ALSA: control: Make sure that id->index does not overflow

Li Zhong (1):
  powerpc: Fix Oops in rtas_stop_self()

Liam Girdwood (1):
  ASoC: max98090: Fix reset at resume time

Lidong Zhong (1):
  dlm: keep listening connection alive with sctp mode

Liu Bo (4):
  Btrfs: fix NULL pointer crash of deleting a seed device
  Btrfs: mark mapping with error flag to report errors to userspace
  Btrfs: use right type to get real comparison
  Btrfs: fix scrub_print_warning to handle skinny metadata extents

Lv Zheng (1):
  ACPI: Fix conflict between customized DSDT and DSDT local copy

Mario Schuknecht (1):
  staging: iio: tsl2x7x_core: fix proximity treshold

Mathias Krause (1):
  netfilter: ipt_ULOG: fix info leaks

Matthew Dempsky (1):
  ptrace: fix fork event messages across pid namespaces

Maurizio Lombardi (1):
  ext4: fix wrong assert in ext4_mb_normalize_request()

Mel Gorman (2):
  mm: vmscan: do not throttle based on pfmemalloc reserves if node has
    no ZONE_NORMAL
  mm: page_alloc: use word-based accesses for get/set pageblock bitmaps

Miao Xie (2):
  Btrfs: fix BUG_ON() casued by the reserved space migration
  Btrfs: output warning instead of error when loading free space cache
    failed

Michal Kubecek (1):
  xfrm: fix race between netns cleanup and state expire notification

Michal Kubeček (1):
  vlan: more careful checksum features handling

Mike Frysinger (1):
  x86, x32: Use compat shims for io_{setup,submit}

Mike Qiu (1):
  powerpc/mm: fix ".__node_distance" undefined

Mikulas Patocka (1):
  matroxfb: perform a dummy read of M_STATUS

Namjae Jeon (1):
  ext4: fix data integrity sync in ordered mode

Naoya Horiguchi (3):
  mm: add !pte_present() check on existing hugetlb_entry callbacks
  hugetlb: restrict hugepage_migration_support() to x86_64
  mm/memory-failure.c: support use of a dedicated thread to handle
    SIGBUS(BUS_MCEERR_AO)

Nicholas A. Bellinger (1):
  target: Explicitly clear ramdisk_mcp backend pages

Nicholas Bellinger (3):
  target: Set CMD_T_ACTIVE bit for Task Management Requests
  target: Use complete_all for se_cmd->t_transport_stop_comp
  iscsi-target: Fix ABORT_TASK + connection reset iscsi_queue_req memory
    leak

Olivier Langlois (1):
  media: uvcvideo: Fix clock param realtime setting

Paolo Bonzini (1):
  KVM: lapic: sync highest ISR to hardware apic on EOI

Paul Bolle (3):
  staging: tidspbridge: check for CONFIG_SND_OMAP_SOC_MCBSP
  usb: gadget: rename CONFIG_USB_GADGET_PXA25X
  ARM: OMAP: replace checks for CONFIG_USB_GADGET_OMAP

Pavel Shilovsky (1):
  CIFS: Fix memory leaks in SMB2_open

Peter Meerwald (1):
  iio: Fix endianness issue in ak8975_read_axis()

Peter Ujfalusi (1):
  ASoC: tlv320aci3x: Fix custom snd_soc_dapm_put_volsw_aic3x() function

Peter Zijlstra (1):
  sched: Make scale_rt_power() deal with backward clocks

Petr Mladek (1):
  ftrace/x86: Call text_ip_addr() instead of the duplicated code

Prarit Bhargava (1):
  ACPI / memhotplug: add parameter to disable memory hotplug

Qu Wenruo (1):
  btrfs: Add ctime/mtime update for btrfs device add/remove.

Quentin Casasnovas (1):
  drm/radeon: memory leak on bo reservation failure. v2

Rickard Strandqvist (1):
  fs: btrfs: volumes.c: Fix for possible null pointer dereference

Roger Quadros (1):
  usb: usbtest: Add timetout to simple_io()

Roland Dreier (1):
  target: Report correct response length for some commands

Russell King (1):
  ARM: stacktrace: avoid listing stacktrace functions in stacktrace

Sachin Prabhu (1):
  cifs: Set client guid on per connection basis

Sagi Grimberg (5):
  Target/iser: Bail from accept_np if np_thread is trying to close
  Target/iser: Fix hangs in connection teardown
  Target/iser: Improve cm events handling
  Target/iser: Wait for proper cleanup before unloading
  Target/iscsi: Fix sendtargets response pdu for iser transport

Stephane Grosjean (1):
  can: peak_pci: prevent use after free at netdev removal

Steve French (2):
  Check SMB3 dialects against downgrade attacks
  Do not send ClientGUID on SMB2.02 dialect

Takashi Iwai (1):
  media: ivtv: Fix Oops when no firmware is loaded

Thomas Gleixner (1):
  genirq: Sanitize spurious interrupt detection of threaded irqs

Tim Kryger (1):
  serial: 8250_dw: Improve unwritable LCR workaround

Tom Gundersen (1):
  module: allow multiple calls to MODULE_DEVICE_TABLE() per module

Tomas Winkler (2):
  mei: me: read H_CSR after asserting reset
  mei: me: fix hw ready reset flow

Tony Luck (2):
  mm/memory-failure.c-failure: send right signal code to correct thread
  mm/memory-failure.c: don't let collect_procs() skip over processes for
    MF_ACTION_REQUIRED

Ursula Braun (1):
  af_iucv: wrong mapping of sent and confirmed skbs

Vincent Guittot (1):
  Revert "sched: Fix sleep time double accounting in enqueue entity"

Viresh Kumar (1):
  tick-sched: Check tick_nohz_enabled in tick_nohz_switch_to_nohz()

Wang Shilong (2):
  Btrfs: make sure there are not any read requests before stopping
    workers
  Btrfs: set right total device count for seeding support

Wang, Xiaoming (1):
  ALSA: compress: Cancel the optimization of compiler and fix the size
    of struct for all platform.

Wendy Xiong (1):
  [SCSI] ipr: Add new CCIN definition for Grand Canyon support

Will Deacon (1):
  arm64: ptrace: change fs when passing kernel pointer to regset code

Ying Xue (1):
  tipc: fix memory leak of publications

Zhichuang SUN (1):
  drivers/video/fbdev/fb-puv3.c: Add header files for function
    unifb_mmap

xiao jin (2):
  USB: usb_wwan: fix urb leak in write error path
  USB: usb_wwan: fix race between write and resume

 Documentation/kernel-parameters.txt            |   3 +
 Documentation/vm/hwpoison.txt                  |   5 +
 arch/arm/kernel/stacktrace.c                   |  18 +++-
 arch/arm/mach-omap1/board-h2.c                 |   2 +-
 arch/arm/mach-omap1/board-h3.c                 |   2 +-
 arch/arm/mach-omap1/board-innovator.c          |   2 +-
 arch/arm/mach-omap1/board-osk.c                |   2 +-
 arch/arm/mm/hugetlbpage.c                      |   5 -
 arch/arm/mm/proc-v7-3level.S                   |  18 +++-
 arch/arm64/kernel/ptrace.c                     |   4 +
 arch/arm64/mm/hugetlbpage.c                    |   5 -
 arch/ia64/mm/hugetlbpage.c                     |   5 -
 arch/metag/mm/hugetlbpage.c                    |   5 -
 arch/mips/kvm/kvm_mips.c                       |   2 +-
 arch/mips/mm/hugetlbpage.c                     |   5 -
 arch/powerpc/kvm/book3s_hv.c                   |   4 +-
 arch/powerpc/mm/hugetlbpage.c                  |  10 --
 arch/powerpc/mm/numa.c                         |   1 +
 arch/powerpc/platforms/pseries/hotplug-cpu.c   |   5 +-
 arch/s390/include/asm/lowcore.h                |  11 +-
 arch/s390/mm/hugetlbpage.c                     |   5 -
 arch/sh/mm/hugetlbpage.c                       |   5 -
 arch/sparc/mm/hugetlbpage.c                    |   5 -
 arch/tile/mm/hugetlbpage.c                     |   5 -
 arch/unicore32/mm/alignment.c                  |   1 +
 arch/x86/Kconfig                               |   4 +
 arch/x86/kernel/entry_32.S                     |  15 +--
 arch/x86/kernel/ftrace.c                       |  11 +-
 arch/x86/kvm/lapic.c                           |  62 +++++++----
 arch/x86/mm/hugetlbpage.c                      |  10 --
 arch/x86/syscalls/syscall_64.tbl               |   6 +-
 drivers/acpi/acpi_memhotplug.c                 |  12 +++
 drivers/acpi/acpica/utstring.c                 |   2 +-
 drivers/acpi/bus.c                             |   7 ++
 drivers/acpi/video.c                           |  87 +++-------------
 drivers/bluetooth/hci_ldisc.c                  |  24 ++++-
 drivers/bluetooth/hci_uart.h                   |   1 +
 drivers/char/applicom.c                        |   1 -
 drivers/extcon/extcon-max77693.c               |   4 +-
 drivers/extcon/extcon-max8997.c                |   2 +-
 drivers/firmware/efi/efi-pstore.c              |   2 +-
 drivers/gpu/drm/radeon/radeon_kms.c            |   5 +-
 drivers/hid/hid-core.c                         |  12 ++-
 drivers/hv/hv_balloon.c                        |  29 +++++-
 drivers/idle/intel_idle.c                      |   4 +-
 drivers/iio/adc/at91_adc.c                     |  16 +--
 drivers/iio/magnetometer/ak8975.c              |   9 +-
 drivers/infiniband/ulp/isert/ib_isert.c        |  61 ++++++-----
 drivers/infiniband/ulp/isert/ib_isert.h        |   2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c         |   6 ++
 drivers/media/usb/stk1160/stk1160-core.c       |  10 +-
 drivers/media/usb/stk1160/stk1160.h            |   1 -
 drivers/media/usb/uvc/uvc_video.c              |  15 ++-
 drivers/mfd/sm501.c                            |   2 +-
 drivers/misc/mei/hw-me.c                       |  28 +++--
 drivers/net/can/sja1000/peak_pci.c             |  14 ++-
 drivers/net/ethernet/ti/cpsw.c                 |   4 +
 drivers/scsi/ipr.c                             |   6 ++
 drivers/scsi/ipr.h                             |   3 +
 drivers/staging/iio/light/tsl2x7x_core.c       |   8 +-
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c |   7 +-
 drivers/staging/tidspbridge/core/dsp-clock.c   |   4 +-
 drivers/target/iscsi/iscsi_target.c            |  17 ++--
 drivers/target/target_core_rd.c                |   2 +-
 drivers/target/target_core_sbc.c               |   4 +-
 drivers/target/target_core_spc.c               |   9 +-
 drivers/target/target_core_transport.c         |  29 +++++-
 drivers/tty/serial/8250/8250_dw.c              |  43 ++++++--
 drivers/usb/class/cdc-acm.c                    | 104 +++++++++++--------
 drivers/usb/class/cdc-acm.h                    |   2 +-
 drivers/usb/dwc3/gadget.c                      |   4 +
 drivers/usb/gadget/inode.c                     |   2 +-
 drivers/usb/host/pci-quirks.c                  |  19 +++-
 drivers/usb/misc/usbtest.c                     |  40 +++++++-
 drivers/usb/phy/phy-isp1301-omap.c             |   2 +-
 drivers/usb/serial/bus.c                       |  14 ++-
 drivers/usb/serial/option.c                    |  11 +-
 drivers/usb/serial/qcserial.c                  | 136 +++++++++++++++----------
 drivers/usb/serial/sierra.c                    |  55 +++++++---
 drivers/usb/serial/usb_wwan.c                  | 125 ++++++++++++-----------
 drivers/video/fb-puv3.c                        |   2 +
 drivers/video/matrox/matroxfb_base.h           |   2 +-
 fs/aio.c                                       |  45 ++++++--
 fs/bio-integrity.c                             |   2 +-
 fs/btrfs/backref.c                             |  32 +++---
 fs/btrfs/backref.h                             |   4 +-
 fs/btrfs/disk-io.c                             | 122 +++++++++-------------
 fs/btrfs/extent-tree.c                         |   3 +-
 fs/btrfs/extent_io.c                           |   5 +-
 fs/btrfs/free-space-cache.c                    |   4 +-
 fs/btrfs/inode.c                               |  21 ++--
 fs/btrfs/ioctl.c                               |  12 ++-
 fs/btrfs/relocation.c                          |   6 +-
 fs/btrfs/scrub.c                               |   5 +-
 fs/btrfs/send.c                                |   4 +
 fs/btrfs/transaction.c                         |  50 ++++++---
 fs/btrfs/transaction.h                         |   2 +
 fs/btrfs/volumes.c                             |  44 ++++++--
 fs/cifs/cifsfs.c                               |   8 --
 fs/cifs/cifsglob.h                             |   2 +
 fs/cifs/connect.c                              |   3 +
 fs/cifs/smb2ops.c                              |   1 +
 fs/cifs/smb2pdu.c                              |  92 ++++++++++++++++-
 fs/cifs/smb2pdu.h                              |  14 ++-
 fs/cifs/smb2proto.h                            |   1 +
 fs/cifs/smbfsctl.h                             |   2 +-
 fs/dlm/lowcomms.c                              |   5 +
 fs/eventpoll.c                                 |   4 +-
 fs/ext4/ext4.h                                 |   3 +-
 fs/ext4/inode.c                                |   6 +-
 fs/ext4/mballoc.c                              |   2 +-
 fs/ext4/page-io.c                              |  32 +++---
 fs/gfs2/inode.c                                |   8 ++
 fs/nfsd/nfs4state.c                            |   2 +-
 fs/nfsd/nfscache.c                             |  53 +++-------
 fs/ocfs2/dcache.c                              |  61 +----------
 fs/ocfs2/dcache.h                              |  12 +--
 fs/ocfs2/dlmglue.c                             |  44 +++++++-
 fs/ocfs2/dlmglue.h                             |   3 +-
 fs/ocfs2/inode.c                               |  23 +++--
 fs/ocfs2/ocfs2.h                               |  31 ++----
 fs/ocfs2/quota.h                               |   2 +
 fs/ocfs2/quota_global.c                        |  35 +++++++
 fs/ocfs2/super.c                               |  36 ++-----
 fs/proc/task_mmu.c                             |   2 +-
 fs/quota/dquot.c                               |   4 +-
 fs/xfs/xfs_aops.c                              |   3 +-
 fs/xfs/xfs_discard.c                           |   5 +-
 fs/xfs/xfs_fsops.c                             |  22 ++--
 fs/xfs/xfs_inode.c                             |  72 ++++++++-----
 fs/xfs/xfs_inode_fork.c                        |  18 ++--
 fs/xfs/xfs_iops.c                              |   9 ++
 fs/xfs/xfs_log.c                               |  56 +++++-----
 fs/xfs/xfs_log_cil.c                           |  14 +++
 fs/xfs/xfs_log_priv.h                          |  10 +-
 fs/xfs/xfs_sb.c                                |   5 +-
 include/linux/hugetlb.h                        |  13 +--
 include/linux/irqdesc.h                        |   4 +
 include/linux/mempolicy.h                      |   6 ++
 include/linux/mmzone.h                         |   6 +-
 include/linux/module.h                         |   2 +-
 include/linux/netdevice.h                      |  14 +++
 include/linux/page-flags.h                     |  12 ++-
 include/linux/pageblock-flags.h                |  37 +++++--
 include/linux/ptrace.h                         |  32 ++++++
 include/linux/quotaops.h                       |   8 ++
 include/sound/core.h                           |   2 +
 include/target/iscsi/iscsi_transport.h         |   3 +-
 include/target/target_core_backend.h           |   1 +
 include/uapi/sound/compress_offload.h          |   2 +-
 kernel/fork.c                                  |  10 +-
 kernel/irq/manage.c                            |   4 +-
 kernel/irq/spurious.c                          | 106 ++++++++++++++++++-
 kernel/sched/fair.c                            |  15 ++-
 kernel/time/tick-sched.c                       |   2 +-
 lib/idr.c                                      |   8 +-
 lib/lz4/lz4_decompress.c                       |   6 +-
 lib/lzo/lzo1x_decompress_safe.c                |  62 +++++++----
 mm/Kconfig                                     |   3 +
 mm/memory-failure.c                            |  73 +++++++++----
 mm/mempolicy.c                                 |   6 +-
 mm/page-writeback.c                            |  11 +-
 mm/page_alloc.c                                |  52 ++++++----
 mm/rmap.c                                      |   8 +-
 mm/vmscan.c                                    |  46 +++++++--
 net/8021q/vlan_dev.c                           |   4 +-
 net/bluetooth/hci_conn.c                       |  11 +-
 net/bluetooth/l2cap_sock.c                     |   5 +-
 net/core/dev.c                                 |   5 -
 net/ipv4/netfilter/ipt_ULOG.c                  |   7 +-
 net/iucv/af_iucv.c                             |   2 +-
 net/socket.c                                   |   7 +-
 net/tipc/name_table.c                          |   2 +-
 net/xfrm/xfrm_user.c                           |  36 +++++--
 scripts/mod/file2alias.c                       |  14 ++-
 scripts/package/builddeb                       |   6 +-
 sound/core/control.c                           |  78 +++++++++-----
 sound/core/init.c                              |   1 +
 sound/pci/hda/patch_hdmi.c                     |   6 +-
 sound/pci/hda/patch_realtek.c                  |  10 ++
 sound/soc/codecs/max98090.c                    |   3 +
 sound/soc/codecs/tlv320aic3x.c                 |   2 +-
 182 files changed, 1946 insertions(+), 1126 deletions(-)

-- 
2.0.0

