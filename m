Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaGAEFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 00:05:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaGAEFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 00:05:42 -0400
Date: Mon, 30 Jun 2014 21:05:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.15.3
Message-ID: <20140701040527.GA26668@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.15.3 kernel.

All users of the 3.15 kernel series must upgrade.

The updated 3.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.15.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/vm/hwpoison.txt                    |    5=20
 Makefile                                         |    2=20
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts |    2=20
 arch/arm/kernel/stacktrace.c                     |   18 +
 arch/arm/mach-omap1/board-h2.c                   |    2=20
 arch/arm/mach-omap1/board-h3.c                   |    2=20
 arch/arm/mach-omap1/board-innovator.c            |    2=20
 arch/arm/mach-omap1/board-osk.c                  |    2=20
 arch/arm/mach-omap2/gpmc-nand.c                  |    2=20
 arch/arm/mm/hugetlbpage.c                        |    5=20
 arch/arm/mm/proc-v7-3level.S                     |   18 +
 arch/arm64/include/asm/Kbuild                    |    1=20
 arch/arm64/include/asm/dma-mapping.h             |    2=20
 arch/arm64/include/asm/pgtable.h                 |    2=20
 arch/arm64/include/uapi/asm/posix_types.h        |   10=20
 arch/arm64/kernel/ptrace.c                       |   32 ++-
 arch/arm64/mm/hugetlbpage.c                      |    5=20
 arch/ia64/hp/common/sba_iommu.c                  |   64 +++---
 arch/ia64/mm/hugetlbpage.c                       |    5=20
 arch/metag/mm/hugetlbpage.c                      |    5=20
 arch/mips/mm/hugetlbpage.c                       |    5=20
 arch/powerpc/mm/hugetlbpage.c                    |   10=20
 arch/s390/include/asm/lowcore.h                  |   11 -
 arch/s390/kernel/time.c                          |    2=20
 arch/s390/mm/hugetlbpage.c                       |    5=20
 arch/sh/mm/hugetlbpage.c                         |    5=20
 arch/sparc/mm/hugetlbpage.c                      |    5=20
 arch/tile/mm/hugetlbpage.c                       |    5=20
 arch/x86/Kconfig                                 |    4=20
 arch/x86/kernel/entry_32.S                       |   15 -
 arch/x86/mm/hugetlbpage.c                        |   10=20
 arch/x86/syscalls/syscall_64.tbl                 |    6=20
 drivers/acpi/acpica/utstring.c                   |    2=20
 drivers/acpi/bus.c                               |    7=20
 drivers/acpi/utils.c                             |   64 ++++--
 drivers/base/power/opp.c                         |    4=20
 drivers/block/virtio_blk.c                       |    9=20
 drivers/block/zram/zram_drv.c                    |    4=20
 drivers/bluetooth/hci_ldisc.c                    |   24 +-
 drivers/bluetooth/hci_uart.h                     |    1=20
 drivers/char/applicom.c                          |    1=20
 drivers/char/random.c                            |   17 -
 drivers/extcon/extcon-max14577.c                 |    9=20
 drivers/extcon/extcon-max77693.c                 |    4=20
 drivers/extcon/extcon-max8997.c                  |    2=20
 drivers/firmware/efi/efi-pstore.c                |    2=20
 drivers/gpu/drm/radeon/radeon_pm.c               |    3=20
 drivers/gpu/drm/radeon/radeon_uvd.c              |    3=20
 drivers/hid/hid-core.c                           |   12 +
 drivers/infiniband/ulp/iser/iser_initiator.c     |   34 ---
 drivers/infiniband/ulp/isert/ib_isert.c          |   70 +++---
 drivers/infiniband/ulp/isert/ib_isert.h          |    2=20
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c           |    6=20
 drivers/media/pci/saa7134/saa7134-video.c        |    9=20
 drivers/media/platform/exynos4-is/fimc-is.c      |    3=20
 drivers/media/platform/exynos4-is/media-dev.c    |    2=20
 drivers/media/platform/exynos4-is/media-dev.h    |    4=20
 drivers/media/usb/stk1160/stk1160-core.c         |   10=20
 drivers/media/usb/stk1160/stk1160.h              |    1=20
 drivers/media/usb/uvc/uvc_video.c                |   15 -
 drivers/pci/hotplug/acpiphp.h                    |   10=20
 drivers/pci/hotplug/acpiphp_glue.c               |   60 +++--
 drivers/phy/phy-exynos-mipi-video.c              |    2=20
 drivers/regulator/s2mpa01.c                      |   15 -
 drivers/regulator/s2mps11.c                      |   15 -
 drivers/scsi/libiscsi.c                          |   18 -
 drivers/staging/imx-drm/imx-hdmi.c               |    9=20
 drivers/staging/media/bcm2048/radio-bcm2048.c    |    2=20
 drivers/staging/mt29f_spinand/mt29f_spinand.c    |    1=20
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c   |    7=20
 drivers/staging/tidspbridge/core/dsp-clock.c     |    4=20
 drivers/target/iscsi/iscsi_target.c              |   17 +
 drivers/target/loopback/tcm_loop.c               |   15 +
 drivers/target/target_core_sbc.c                 |   19 +
 drivers/target/target_core_spc.c                 |    9=20
 drivers/target/target_core_transport.c           |   29 ++
 drivers/tty/serial/of_serial.c                   |    1=20
 drivers/usb/dwc3/gadget.c                        |    4=20
 drivers/usb/gadget/inode.c                       |    2=20
 drivers/usb/host/pci-quirks.c                    |   19 +
 drivers/usb/misc/usbtest.c                       |   26 ++
 drivers/usb/phy/phy-isp1301-omap.c               |    2=20
 drivers/usb/serial/bus.c                         |   14 +
 drivers/usb/serial/option.c                      |   11 -
 drivers/usb/serial/qcserial.c                    |   21 +
 drivers/usb/serial/sierra.c                      |   55 ++++-
 drivers/usb/serial/usb_wwan.c                    |  125 ++++++-----
 drivers/video/fbdev/matrox/matroxfb_base.h       |    2=20
 drivers/video/fbdev/offb.c                       |   11 -
 drivers/w1/w1.c                                  |    2=20
 drivers/w1/w1_int.c                              |    4=20
 fs/aio.c                                         |    6=20
 fs/btrfs/backref.c                               |   37 ++-
 fs/btrfs/backref.h                               |    4=20
 fs/btrfs/ctree.h                                 |    8=20
 fs/btrfs/disk-io.c                               |    5=20
 fs/btrfs/extent-tree.c                           |   39 ++-
 fs/btrfs/extent_io.c                             |    5=20
 fs/btrfs/file.c                                  |   23 +-
 fs/btrfs/free-space-cache.c                      |    4=20
 fs/btrfs/scrub.c                                 |    5=20
 fs/btrfs/send.c                                  |   67 +++---
 fs/btrfs/sysfs.c                                 |    5=20
 fs/btrfs/volumes.c                               |   44 +++-
 fs/cifs/smb2pdu.c                                |    7=20
 fs/eventpoll.c                                   |    4=20
 fs/ext4/ext4.h                                   |    3=20
 fs/ext4/extents.c                                |    7=20
 fs/ext4/inode.c                                  |    6=20
 fs/ext4/mballoc.c                                |    2=20
 fs/ext4/page-io.c                                |   32 +--
 fs/f2fs/data.c                                   |    2=20
 include/linux/acpi.h                             |   22 +-
 include/linux/hugetlb.h                          |   13 -
 include/linux/irqdesc.h                          |    4=20
 include/linux/mempolicy.h                        |    6=20
 include/linux/mmzone.h                           |    6=20
 include/linux/page-flags.h                       |   12 +
 include/linux/pageblock-flags.h                  |   37 ++-
 include/linux/ptrace.h                           |   32 +++
 include/net/bluetooth/mgmt.h                     |    3=20
 include/scsi/scsi_cmnd.h                         |   17 +
 include/target/iscsi/iscsi_transport.h           |    3=20
 include/target/target_core_backend.h             |    1=20
 kernel/fork.c                                    |   10=20
 kernel/irq/manage.c                              |    4=20
 kernel/irq/spurious.c                            |  106 +++++++++-
 kernel/kthread.c                                 |    4=20
 kernel/locking/rtmutex-debug.h                   |    5=20
 kernel/locking/rtmutex.c                         |  243 ++++++++++++++++++=
+----
 kernel/locking/rtmutex.h                         |    5=20
 kernel/printk/printk.c                           |    1=20
 lib/idr.c                                        |    8=20
 lib/lz4/lz4_decompress.c                         |    4=20
 mm/Kconfig                                       |    3=20
 mm/memcontrol.c                                  |    3=20
 mm/memory-failure.c                              |   73 +++++-
 mm/page-writeback.c                              |   11 -
 mm/page_alloc.c                                  |   52 +++-
 mm/rmap.c                                        |    8=20
 mm/vmscan.c                                      |   46 +++-
 net/bluetooth/6lowpan.c                          |   65 +++---
 net/bluetooth/hci_event.c                        |    4=20
 net/bluetooth/l2cap_sock.c                       |    5=20
 net/bluetooth/mgmt.c                             |   25 ++
 net/bluetooth/smp.c                              |    7=20
 scripts/package/builddeb                         |    6=20
 tools/vm/page-types.c                            |   35 +++
 148 files changed, 1637 insertions(+), 691 deletions(-)

Alan Stern (2):
      USB: usbtest: add a timeout for scatter-gather tests
      USB: EHCI: avoid BIOS handover on the HASEE E200

Aleksander Morgado (2):
      usb: qcserial: add Netgear AirCard 341U
      usb: qcserial: add additional Sierra Wireless QMI devices

Alex Deucher (1):
      Revert "drm/radeon: use variable UVD clocks"

Alexey Khoroshilov (1):
      w1: do not unlock unheld list_mutex in __w1_remove_master_device()

Andrzej Zaborowski (1):
      efi-pstore: Fix an overflow on 32-bit builds

Andy Lutomirski (1):
      x86_32, entry: Do syscall exit work on badsys (CVE-2014-4508)

Antoine T=E9nart (1):
      phy: exynos-mipi-video: fix check on array index

Benjamin Herrenschmidt (1):
      Revert "offb: Add palette hack for little endian"

Benjamin LaHaise (2):
      aio: fix aio request leak when events are reaped by userspace
      aio: fix kernel memory disclosure in io_getevents() introduced in v3.=
10

Bj=F8rn Mork (1):
      ACPI: add dynamic_debug support

Chander Kashyap (1):
      PM / OPP: fix incorrect OPP count handling in of_init_opp_table

Chris Mason (1):
      Btrfs: fix double free in find_lock_delalloc_range

Christian Borntraeger (1):
      s390/lowcore: reserve 96 bytes for IRB in lowcore

Dan Carpenter (2):
      Staging: rtl8188eu: overflow in update_sta_support_rate()
      applicom: dereferencing NULL on error path

David Binderman (1):
      ACPICA: utstring: Check array index bound before use.

Eric Sandeen (1):
      btrfs: fix use of uninit "ret" in end_extent_writepage()

Ezequiel Garcia (1):
      media: stk1160: Avoid stack-allocated buffer for control URBs

Fathi Boudra (1):
      builddeb: use $OBJCOPY variable instead of objcopy

Felipe Balbi (2):
      usb: dwc3: gadget: clear stall when disabling endpoint
      bluetooth: hci_ldisc: fix deadlock condition

Filipe Manana (5):
      Btrfs: fix leaf corruption caused by ENOSPC while hole punching
      Btrfs: read inode size after acquiring the mutex when punching a hole
      Btrfs: send, account for orphan directories when building path strings
      Btrfs: send, don't error in the presence of subvols/snapshots
      Btrfs: send, use the right limits for xattr names and values

Greg Kroah-Hartman (2):
      lz4: fix another possible overrun
      Linux 3.15.3

H. Peter Anvin (1):
      x86-32, espfix: Remove filter for espfix32 due to race

Hans Verkuil (1):
      media: saa7134: fix regression with tvtime

Huang Rui (1):
      usb: usbtest: fix unlink write error with pattern 1

Hugh Dickins (1):
      mm: fix sleeping function warning from __put_anon_vma

Jaegeuk Kim (1):
      f2fs: submit bio at the reclaim path

Jan Kara (1):
      ext4: fix zeroing of page during writeback

Jason Cooper (1):
      ARM: mvebu: DT: fix OpenBlocks AX3-4 RAM size

Jeff Mahoney (1):
      btrfs: allocate raid type kobjects dynamically

Jianguo Wu (1):
      ARM: 8037/1: mm: support big-endian page tables

Johan Hedberg (5):
      Bluetooth: Fix authentication check for FIPS security level
      Bluetooth: Fix requiring SMP MITM for outgoing connections
      Bluetooth: Fix missing check for FIPS security level
      Bluetooth: Clearly distinguish mgmt LTK type from authenticated prope=
rty
      Bluetooth: Fix properly ignoring LTKs of unknown types

Johan Hovold (11):
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

Josef Bacik (1):
      Btrfs: don't check nodes for extent items

Jukka Rissanen (1):
      Bluetooth: 6LoWPAN: Fix MAC address universal/local bit handling

Jukka Taimisto (1):
      Bluetooth: Fix L2CAP deadlock

Kees Cook (1):
      HID: core: fix validation of report id 0

Konstantin Khlebnikov (2):
      tools/vm/page-types.c: catch sigbus if raced with truncate
      epoll: fix use-after-free in eventpoll_release_file

Krzysztof Kozlowski (7):
      extcon: max8997: Fix NULL pointer exception on missing pdata
      extcon: max77693: Fix two NULL pointer exceptions on missing pdata
      extcon: max14577: Fix probe failure on successful work queue
      extcon: max14577: Properly handle regmap_irq_get_virq error
      regulator: s2mpa01: Use correct register for buck1 ramp delay
      regulator: s2mps11: Fix accidental enable of buck6 ramp delay
      regulator: s2mpa01: Fix accidental enable of buck4 ramp delay

Lai Jiangshan (1):
      idr: fix overflow bug during maximum ID calculation at maximum height

Liu Bo (4):
      Btrfs: fix NULL pointer crash of deleting a seed device
      Btrfs: mark mapping with error flag to report errors to userspace
      Btrfs: use right type to get real comparison
      Btrfs: fix scrub_print_warning to handle skinny metadata extents

Lv Zheng (1):
      ACPI: Fix conflict between customized DSDT and DSDT local copy

Martin Schwidefsky (1):
      s390/time: cast tv_nsec to u64 prior to shift in update_vsyscall

Matthew Dempsky (1):
      ptrace: fix fork event messages across pid namespaces

Maurizio Lombardi (1):
      ext4: fix wrong assert in ext4_mb_normalize_request()

Mel Gorman (2):
      mm: vmscan: do not throttle based on pfmemalloc reserves if node has =
no ZONE_NORMAL
      mm: page_alloc: use word-based accesses for get/set pageblock bitmaps

Miao Xie (1):
      Btrfs: output warning instead of error when loading free space cache =
failed

Michal Hocko (1):
      memcg: do not hang on OOM when killed by userspace OOM access to memo=
ry reserves

Mike Frysinger (1):
      x86, x32: Use compat shims for io_{setup,submit}

Mikulas Patocka (1):
      matroxfb: perform a dummy read of M_STATUS

Ming Lei (1):
      block: virtio_blk: don't hold spin lock during world switch

Namjae Jeon (2):
      ext4: fix data integrity sync in ordered mode
      ext4: fix ZERO_RANGE test failure in data journalling

Naoya Horiguchi (2):
      hugetlb: restrict hugepage_migration_support() to x86_64
      mm/memory-failure.c: support use of a dedicated thread to handle SIGB=
US(BUS_MCEERR_AO)

Nicholas Bellinger (3):
      target: Set CMD_T_ACTIVE bit for Task Management Requests
      target: Use complete_all for se_cmd->t_transport_stop_comp
      iscsi-target: Fix ABORT_TASK + connection reset iscsi_queue_req memor=
y leak

Olivier Langlois (1):
      media: uvcvideo: Fix clock param realtime setting

Pali Roh=E1r (1):
      media: radio-bcm2048: fix wrong overflow check

Paul Bolle (3):
      staging: tidspbridge: check for CONFIG_SND_OMAP_SOC_MCBSP
      usb: gadget: rename CONFIG_USB_GADGET_PXA25X
      ARM: OMAP: replace checks for CONFIG_USB_GADGET_OMAP

Pavel Shilovsky (1):
      CIFS: Fix memory leaks in SMB2_open

Pekon Gupta (1):
      ARM: OMAP2+: gpmc: enable BCH_HW ecc-scheme for AM43xx platforms

Qu Wenruo (1):
      btrfs: Add ctime/mtime update for btrfs device add/remove.

Rafael J. Wysocki (2):
      ACPI / hotplug / PCI: Add hotplug contexts to PCI host bridges
      ACPI / ia64 / sba_iommu: Restore the working initialization ordering

Rickard Strandqvist (1):
      fs: btrfs: volumes.c: Fix for possible null pointer dereference

Roland Dreier (1):
      target: Report correct response length for some commands

Russell King (2):
      imx-drm: fix hdmi hotplug detection initial state
      ARM: stacktrace: avoid listing stacktrace functions in stacktrace

Sagi Grimberg (10):
      Target/iser: Bail from accept_np if np_thread is trying to close
      Target/iser: Fix hangs in connection teardown
      Target/iser: Improve cm events handling
      Target/iser: Wait for proper cleanup before unloading
      Target/iser: Gracefully reject T10-PI enabled connect request if not =
supported
      Target/iser: Fix a wrong dereference in case discovery session is ove=
r iser
      Target/iscsi: Fix sendtargets response pdu for iser transport
      scsi_cmnd: Introduce scsi_transfer_length helper
      libiscsi, iser: Adjust data_length to include protection information
      TARGET/sbc,loopback: Adjust command data length in case pi exists on =
the wire

Stephen Boyd (1):
      staging/mt29f_spinand: Terminate of match table

Stephen Chivers (1):
      printk/of_serial: fix serial console cessation part way through boot.

Suravee Suthikulpanit (1):
      arm64/dma: Removing ARCH_HAS_DMA_GET_REQUIRED_MASK macro

Sylwester Nawrocki (2):
      media: exynos4-is: Free FIMC-IS CPU memory only when allocated
      media: exynos4-is: Fix compilation for !CONFIG_COMMON_CLK

Takashi Iwai (1):
      media: ivtv: Fix Oops when no firmware is loaded

Tetsuo Handa (1):
      kthread: fix return value of kthread_create() upon SIGKILL.

Theodore Ts'o (1):
      random: fix nasty entropy accounting bug

Thomas Gleixner (4):
      rtmutex: Detect changes in the pi lock chain
      rtmutex: Handle deadlock detection smarter
      rtmutex: Plug slow unlock race
      genirq: Sanitize spurious interrupt detection of threaded irqs

Tony Luck (2):
      mm/memory-failure.c-failure: send right signal code to correct thread
      mm/memory-failure.c: don't let collect_procs() skip over processes fo=
r MF_ACTION_REQUIRED

Victor Kamensky (1):
      arm64: ptrace: fix empty registers set in prstatus of aarch32 process=
 core

Wang Shilong (2):
      Btrfs: make sure there are not any read requests before stopping work=
ers
      Btrfs: set right total device count for seeding support

Weijie Yang (1):
      zram: correct offset usage in zram_bio_discard

Will Deacon (3):
      arm64: ptrace: change fs when passing kernel pointer to regset code
      arm64: uid16: fix __kernel_old_{gid,uid}_t definitions
      arm64: mm: remove broken &=3D operator from pmd_mknotpresent

xiao jin (2):
      USB: usb_wwan: fix urb leak in write error path
      USB: usb_wwan: fix race between write and resume


--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTsjOHAAoJEDjbvchgkmk+CTQQALzJUEH4r4FqUXLqVcnTElZI
v4F/5TBWMwpoxPdvjjHnMH9y+axu7RLVAavA57G3SyZB3RTVvTvgl0dnQZZUAyPy
5kXv8APjp86FhzQ8qHXNIk4sTifAdA4ZIrTwYjIKMAEDcrukWNf/CSDzM1Ax0lSm
enBMci0O67AWuwYJ3JHso3Nskzj58qmzpC2JIbEzsmRYsOHKf/R08pkWy5CBxcAu
JVWEYy1Mi3IyZVFlFNKRZVUGDqFCKyrFrvzfD7wRdAlfuWzGkhp3ZtmKHGBnhaeb
zjS5XNqNtYQNmBRWLCjHeT7SQTeBxC7N99aAN43cQtCdduZTkDC4phVvyh9KJ4Nh
A6s2ron30bNT8Cry6NJIhyh5xC5xjwo/B7/dga7ISqghaNm5ISJZK+VmdO3B/iNU
CuZGoguuTUYZeaoKlckTVNnijFA0PQBXPN2/XvCQ6FMK2DWm0oWIKw9wQF1BtUf9
KzmdeNz6E9MUsptLrhnm+GEFdqOBDnniIYVJH1b5/1Uzn5Q07o0rlcOusISN+Q8q
bGTBIhWizyIwzeCMos7705B1k1Kd5dKqrQ/fBkxvmtrGo8oYCr9GUhHdf1/f71LR
GScSPE12vAl36K5wClRaitEtvTz5tKkpWuvBCQ6Rcfwvddc6gePGTkcQ2AItapoq
sZDzDaOVAMcdSs446v5h
=mfQV
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
