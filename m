Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaGLOLY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 10:11:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38422 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285AbaGLOLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 10:11:13 -0400
Message-ID: <1405174246.2453.11.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.61
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Sat, 12 Jul 2014 15:10:46 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-XU+FYWrOtEvgcaQX2Rx3"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XU+FYWrOtEvgcaQX2Rx3
Content-Type: multipart/mixed; boundary="=-lQrz8J8T+J+UpSfnFIFj"


--=-lQrz8J8T+J+UpSfnFIFj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.61 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.2.60 is attached to this message.

Ben.

------------

 Documentation/ja_JP/HOWTO                     |   2 +-
 Documentation/ja_JP/stable_kernel_rules.txt   |   6 +-
 Documentation/zh_CN/HOWTO                     |   2 +-
 Documentation/zh_CN/stable_kernel_rules.txt   |   2 +-
 Makefile                                      |   2 +-
 arch/arm/include/asm/uaccess.h                |   3 +-
 arch/arm/kernel/crash_dump.c                  |   2 +-
 arch/arm/plat-mxc/devices/platform-ipu-core.c |   2 +-
 arch/mips/include/asm/thread_info.h           |   2 +
 arch/mips/kernel/irq-msc01.c                  |   2 +-
 arch/mips/kernel/scall32-o32.S                |   2 +-
 arch/mips/kernel/scall64-64.S                 |   2 +-
 arch/mips/kernel/scall64-n32.S                |   2 +-
 arch/mips/kernel/scall64-o32.S                |   2 +-
 arch/powerpc/Makefile                         |   4 +-
 arch/powerpc/include/asm/ppc_asm.h            |   7 +-
 arch/powerpc/kernel/legacy_serial.c           |  15 +-
 arch/powerpc/kernel/setup-common.c            |   2 +-
 arch/s390/include/asm/lowcore.h               |  11 +-
 arch/x86/include/asm/ptrace.h                 |  16 ++
 arch/x86/kernel/entry_32.S                    |  10 +-
 drivers/acpi/bus.c                            |   7 +
 drivers/ata/ahci.c                            |   4 +
 drivers/bluetooth/hci_ldisc.c                 |  25 +-
 drivers/bluetooth/hci_uart.h                  |   2 +
 drivers/gpu/drm/drm_drv.c                     |   3 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c    | 102 ++++----
 drivers/gpu/drm/radeon/atombios_crtc.c        |  48 ++--
 drivers/gpu/drm/radeon/atombios_encoders.c    |   5 +-
 drivers/gpu/drm/radeon/radeon_connectors.c    |   2 +-
 drivers/gpu/drm/radeon/rs600.c                |   7 +-
 drivers/hid/hid-core.c                        |  12 +-
 drivers/infiniband/core/user_mad.c            |  49 ++--
 drivers/infiniband/hw/cxgb4/cq.c              |   3 +-
 drivers/infiniband/hw/cxgb4/user.h            |   1 +
 drivers/infiniband/hw/ipath/ipath_diag.c      |   4 +
 drivers/infiniband/hw/qib/qib_mad.c           |   2 +-
 drivers/infiniband/ulp/srp/ib_srp.c           |   6 +
 drivers/input/mouse/elantech.c                |  27 ++-
 drivers/input/mouse/synaptics.c               |  26 +-
 drivers/iommu/intel-iommu.c                   |  18 +-
 drivers/md/md.c                               |   4 +-
 drivers/net/ethernet/mellanox/mlx4/main.c     | 120 +++++----
 drivers/net/ethernet/mellanox/mlx4/mlx4.h     |   3 +
 drivers/net/wireless/b43/xmit.c               |  10 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c       |   2 +
 drivers/rtc/rtc-at91rm9200.c                  |  16 +-
 drivers/scsi/megaraid/megaraid_sas.h          |   1 -
 drivers/scsi/megaraid/megaraid_sas_base.c     |   5 +-
 drivers/scsi/scsi_error.c                     |   9 +
 drivers/scsi/scsi_lib.c                       |   7 +-
 drivers/scsi/scsi_scan.c                      | 112 +++++----
 drivers/scsi/scsi_sysfs.c                     |  31 ++-
 drivers/target/iscsi/iscsi_target_auth.c      |  10 +
 drivers/target/target_core_device.c           |   1 +
 drivers/target/target_core_rd.c               |   2 +-
 drivers/usb/class/cdc-acm.c                   |  96 +++++---
 drivers/usb/class/cdc-acm.h                   |   2 +-
 drivers/usb/core/driver.c                     |   9 +-
 drivers/usb/core/hub.c                        |  16 +-
 drivers/usb/host/pci-quirks.c                 |  19 +-
 drivers/usb/host/xhci-mem.c                   |  20 +-
 drivers/usb/misc/usbtest.c                    |  10 +
 drivers/usb/serial/ftdi_sio.c                 |   2 +
 drivers/usb/serial/ftdi_sio_ids.h             |   5 +
 drivers/usb/serial/io_ti.c                    |   2 +-
 drivers/usb/serial/io_usbvend.h               |   2 +-
 drivers/usb/serial/option.c                   |  14 +-
 drivers/usb/serial/sierra.c                   |  48 +++-
 drivers/usb/serial/usb_wwan.c                 |  85 ++++---
 drivers/video/matrox/matroxfb_base.h          |   2 +-
 drivers/watchdog/ath79_wdt.c                  |  10 +
 fs/btrfs/extent_io.c                          |   1 +
 fs/ext4/mballoc.c                             |   2 +-
 fs/ext4/page-io.c                             |  24 +-
 fs/nfsd/nfs4state.c                           |  22 +-
 fs/nfsd/nfs4xdr.c                             |   4 +-
 fs/reiserfs/file.c                            |   3 +-
 fs/reiserfs/inode.c                           |  21 +-
 fs/ubifs/file.c                               |   3 +-
 fs/ubifs/shrinker.c                           |   1 -
 include/linux/irqdesc.h                       |   4 +
 include/linux/lzo.h                           |  15 +-
 include/linux/ptrace.h                        |  35 +++
 include/linux/reiserfs_fs.h                   |   1 +
 include/linux/skbuff.h                        |  16 ++
 include/net/inetpeer.h                        |   9 +-
 include/scsi/scsi_device.h                    |   3 +-
 include/sound/core.h                          |   2 +
 include/trace/syscall.h                       |  15 ++
 kernel/auditsc.c                              |  25 +-
 kernel/events/core.c                          |  45 ++--
 kernel/fork.c                                 |  12 +-
 kernel/irq/manage.c                           |   4 +-
 kernel/irq/spurious.c                         | 106 +++++++-
 kernel/rtmutex-debug.h                        |   5 +
 kernel/rtmutex.c                              | 268 ++++++++++++++++++---
 kernel/rtmutex.h                              |   5 +
 lib/decompress_unlzo.c                        |   2 +-
 lib/idr.c                                     |   8 +-
 lib/lzo/Makefile                              |   2 +-
 lib/lzo/lzo1x_compress.c                      | 335 +++++++++++++++-------=
----
 lib/lzo/lzo1x_decompress.c                    | 255 --------------------
 lib/lzo/lzo1x_decompress_safe.c               | 257 ++++++++++++++++++++
 lib/lzo/lzodefs.h                             |  38 ++-
 lib/nlattr.c                                  |   6 +-
 mm/highmem.c                                  |   2 +-
 mm/hugetlb.c                                  |  71 +++---
 mm/mempolicy.c                                |  57 +++--
 mm/rmap.c                                     |  11 +-
 mm/vmscan.c                                   |   3 +
 net/bluetooth/hci_conn.c                      |   2 +-
 net/bluetooth/hci_event.c                     |   7 +-
 net/core/skbuff.c                             |   5 +-
 net/ipv4/ipip.c                               |   1 +
 net/ipv6/ip6_output.c                         |  11 +-
 net/ipv6/ip6_tunnel.c                         |   1 +
 net/ipv6/sit.c                                |   1 +
 net/mac80211/debugfs_netdev.c                 |   6 +-
 net/mac80211/ibss.c                           |   1 +
 net/sctp/associola.c                          |   2 +-
 scripts/recordmcount.h                        |   4 +-
 security/integrity/evm/evm_main.c             |  12 +-
 sound/core/control.c                          |  78 +++---
 sound/core/init.c                             |   1 +
 sound/pci/hda/patch_realtek.c                 |  10 +
 126 files changed, 1953 insertions(+), 1013 deletions(-)

Alan Stern (2):
      USB: Avoid runtime suspend loops for HCDs that can't handle suspend/r=
esume
      USB: EHCI: avoid BIOS handover on the HASEE E200

Alex Deucher (3):
      drm/radeon: fix typo in radeon_connector_is_dp12_capable()
      drm/radeon/atom: fix dithering on certain panels
      drm/radeon: only apply hdmi bpc pll flags when encoder mode is hdmi

Alex Smith (1):
      recordmcount/MIPS: Fix possible incorrect mcount_loc table entries in=
 modules

Alexej Starschenko (1):
      USB: serial: option: add support for Novatel E371 PCIe card

Andreas Schr=C3=A4gle (1):
      ahci: add PCI ID for Marvell 88SE91A0 SATA Controller

Andrey Ryabinin (2):
      ARM: 8051/1: put_user: fix possible data corruption in put_user
      mm: rmap: fix use-after-free in __put_anon_vma

Andy Lutomirski (2):
      auditsc: audit_krule mask accesses need bounds checking
      x86_32, entry: Do syscall exit work on badsys (CVE-2014-4508)

Arik Nemtsov (1):
      mac80211: don't check netdev state for debugfs read/write

Bart Van Assche (3):
      IB/srp: Fix a sporadic crash triggered by cable pulling
      IB/umad: Fix error handling
      Stop accepting SCSI requests before removing a device

Ben Collins (1):
      megaraid: Use resource_size_t for PCI resources, not long

Ben Hutchings (1):
      Linux 3.2.61

Benjamin Herrenschmidt (1):
      powerpc/serial: Use saner flags when creating legacy ports

Benjamin Tissoires (1):
      Input: synaptics - fix resolution for manually provided min/max

Benny Halevy (1):
      nfsd4: use recall_lock for delegation hashing

Boris BREZILLON (1):
      rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq

Chris Mason (1):
      Btrfs: fix double free in find_lock_delalloc_range

Chris Wilson (1):
      drm/i915: Only copy back the modified fields to userspace from execbu=
ffer

Christian Borntraeger (1):
      s390/lowcore: reserve 96 bytes for IRB in lowcore

Christian K=C3=B6nig (1):
      drm/radeon: stop poisoning the GART TLB

Christoph Hellwig (1):
      nfsd: getattr for FATTR4_WORD0_FILES_AVAIL needs the statfs buffer

Dan Carpenter (1):
      RDMA/cxgb4: Fix four byte info leak in c4iw_create_cq()

Daniel Vetter (1):
      drm/i915: s/DRM_ERROR/DRM_DEBUG in i915_gem_execbuffer.c

David Henningsson (1):
      ALSA: hda - Add quirk for external mic on Lifebook U904

David Woodhouse (1):
      iommu/vt-d: Fix missing IOTLB flush in intel_iommu_unmap()

Dennis Dalessandro (1):
      IB/ipath: Translate legacy diagpkt into newer extended diagpkt

Emil Goode (1):
      ARM: imx: fix error handling in ipu device registration

Eric Dumazet (1):
      net: fix inet_getid() and ipv6_select_ident() bugs

Felipe Balbi (1):
      bluetooth: hci_ldisc: fix deadlock condition

Gabor Juhos (1):
      watchdog: ath79_wdt: avoid spurious restarts on AR934x

Geert Uytterhoeven (1):
      Documentation: Update stable address in Chinese and Japanese translat=
ions

George McCollister (1):
      USB: ftdi_sio: add NovaTech OrionLXm product ID

Greg Kroah-Hartman (1):
      lzo: properly check for overruns

Guenter Roeck (1):
      powerpc: Fix 64 bit builds with binutils 2.24

Hans de Goede (4):
      Input: synaptics - add min/max quirk for the ThinkPad W540
      Input: synaptics - T540p - unify with other LEN0034 models
      Input: elantech - deal with clickpads reporting right button events
      Input: elantech - don't set bit 1 of reg_10 when the no_hw_res quirk =
is set

Huang Rui (1):
      usb: usbtest: fix unlink write error with pattern 1

Hugh Dickins (2):
      mm: fix sleeping function warning from __put_anon_vma
      mm: fix crashes from mbind() merging vmas

J. Bruce Fields (1):
      nfsd4: fix FREE_STATEID lockowner leak

James Bottomley (3):
      fix our current target reap infrastructure
      dual scan thread bug fix
      Fix spurious request sense in error handling

Jan Kara (1):
      ext4: fix zeroing of page during writeback

Jeff Mahoney (1):
      reiserfs: call truncate_setsize under tailpack mutex

Johan Hedberg (2):
      Bluetooth: Fix check for connection encryption
      Bluetooth: Fix SSP acceptor just-works confirmation without MITM

Johan Hovold (14):
      USB: sierra: fix AA deadlock in open error path
      USB: sierra: fix urb and memory leak in resume error path
      USB: sierra: fix urb and memory leak on disconnect
      USB: sierra: fix remote wakeup
      USB: option: fix runtime PM handling
      USB: usb_wwan: fix write and suspend race
      USB: usb_wwan: fix urb leak at shutdown
      USB: usb_wwan: fix potential blocked I/O after resume
      USB: cdc-acm: fix write and suspend race
      USB: cdc-acm: fix write and resume race
      USB: cdc-acm: fix broken runtime suspend
      USB: cdc-acm: fix runtime PM for control messages
      USB: cdc-acm: fix potential urb leak and PM imbalance in write
      USB: io_ti: fix firmware download on big-endian machines (part 2)

Johannes Weiner (1):
      mm: vmscan: clear kswapd's special reclaim powers before exiting

J=C3=A9r=C3=B4me Carretero (1):
      ahci: Add Device ID for HighPoint RocketRaid 642L

Kailang Yang (1):
      ALSA: hda/realtek - Add support of ALC891 codec

Kees Cook (1):
      HID: core: fix validation of report id 0

Krzysztof Ha=C5=82asa (1):
      mac80211: fix IBSS join by initializing last_scan_completed

Lai Jiangshan (1):
      idr: fix overflow bug during maximum ID calculation at maximum height

Lars-Peter Clausen (5):
      ALSA: control: Protect user controls against concurrent access
      ALSA: control: Fix replacing user controls
      ALSA: control: Don't access controls outside of protected regions
      ALSA: control: Handle numid overflow
      ALSA: control: Make sure that id->index does not overflow

Liu Hua (1):
      ARM: 8012/1: kdump: Avoid overflow when converting pfn to physaddr

Lv Zheng (1):
      ACPI: Fix conflict between customized DSDT and DSDT local copy

Marco Stornelli (1):
      reiserfs: drop vmtruncate

Markos Chandras (2):
      MIPS: MSC: Prevent out-of-bounds writes to MIPS SC ioremap'd region
      MIPS: asm: thread_info: Add _TIF_SECCOMP flag

Markus F.X.J. Oberhumer (2):
      lib/lzo: Rename lzo1x_decompress.c to lzo1x_decompress_safe.c
      lib/lzo: Update LZO compression to current upstream version

Mathias Nyman (1):
      xhci: delete endpoints from bandwidth list before freeing whole devic=
e

Matthew Dempsky (1):
      ptrace: fix fork event messages across pid namespaces

Maurizio Lombardi (1):
      ext4: fix wrong assert in ext4_mb_normalize_request()

Michael Neuling (1):
      powerpc: Don't setup CPUs with bad status

Michael S. Tsirkin (3):
      skbuff: add an api to orphan frags
      skbuff: export skb_copy_ubufs
      skbuff: skb_segment: orphan frags before copying

Michal Schmidt (1):
      netlink: rate-limit leftover bytes warning and print process name

Mike Marciniszyn (1):
      IB/qib: Fix port in pkey change event

Mikulas Patocka (1):
      matroxfb: perform a dummy read of M_STATUS

Mimi Zohar (1):
      evm: prohibit userspace writing 'security.evm' HMAC value

Minchan Kim (1):
      mm: revert 0def08e3 ("mm/mempolicy.c: check return code of check_rang=
e")

Naoya Horiguchi (1):
      hugetlb: fix copy_hugetlb_page_range() to handle migration/hwpoisoned=
 entry

NeilBrown (1):
      md: always set MD_RECOVERY_INTR when aborting a reshape or other "res=
ync".

Nicholas Bellinger (3):
      iscsi-target: Reject mutual authentication with reflected CHAP_C
      target: Fix left-over se_lun->lun_sep pointer OOPs
      target: Explicitly clear ramdisk_mcp backend pages

Oleg Nesterov (1):
      tracing: Fix syscall_*regfunc() vs copy_process() race

Peter Zijlstra (1):
      perf: Fix race in removing an event

Rafa=C5=82 Mi=C5=82ecki (1):
      b43: fix frequency reported on G-PHY with /new/ firmware

Ralf Baechle (1):
      MIPS: Cleanup flags in syscall flags handlers.

Stanislaw Gruszka (1):
      rt2x00: disable TKIP on USB

Tejun Heo (1):
      ptrace,x86: force IRET path after a ptrace_stop()

Thomas Gleixner (5):
      genirq: Sanitize spurious interrupt detection of threaded irqs
      rtmutex: Fix deadlock detector for real
      rtmutex: Handle deadlock detection smarter
      rtmutex: Detect changes in the pi lock chain
      rtmutex: Plug slow unlock race

Tom Gundersen (1):
      net: tunnels - enable module autoloading

Wei Yang (2):
      mlx4_core: Stash PCI ID driver_data in mlx4_priv structure
      net/mlx4_core: Preserve pci_dev_data after __mlx4_remove_one()

Will Deacon (1):
      mm: highmem: don't treat PKMAP_ADDR(LAST_PKMAP) as a highmem address

Xufeng Zhang (1):
      sctp: Fix sk_ack_backlog wrap-around problem

Yann Droneaud (1):
      RDMA/cxgb4: Add missing padding at end of struct c4iw_create_cq_resp

Zhaowei Yuan (1):
      drm: fix NULL pointer access by wrong ioctl

hujianyang (2):
      UBIFS: fix an mmap and fsync race condition
      UBIFS: Remove incorrect assertion in shrink_tnc()

xiao jin (2):
      USB: usb_wwan: fix urb leak in write error path
      USB: usb_wwan: fix race between write and resume


--=20
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camu=
s

--=-lQrz8J8T+J+UpSfnFIFj
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.2.61.patch"
Content-Disposition: attachment; filename="linux-3.2.61.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vamFfSlAvSE9XVE8gYi9Eb2N1bWVudGF0aW9uL2ph
X0pQL0hPV1RPDQppbmRleCAwNTBkMzdmLi40NmVkNzM1IDEwMDY0NA0KLS0tIGEvRG9jdW1lbnRh
dGlvbi9qYV9KUC9IT1dUTw0KKysrIGIvRG9jdW1lbnRhdGlvbi9qYV9KUC9IT1dUTw0KQEAgLTMx
NSw3ICszMTUsNyBAQCBBbmRyZXcgTW9ydG9uIOOBjCBMaW51eC1rZXJuZWwg44Oh44O844Oq44Oz
44Kw44Oq44K544OI44Gr44Kr44O844ON44Or44Oq44Oq44O8DQog44KC44GX44CBMi42LngueSDj
gqvjg7zjg43jg6vjgYzlrZjlnKjjgZfjgarjgYTloLTlkIjjgavjga/jgIHnlarlj7fjgYzkuIDn
larlpKfjgY3jgYQgMi42Lngg44GMDQog5pyA5paw44Gu5a6J5a6a54mI44Kr44O844ON44Or44Gn
44GZ44CCDQogDQotMi42LngueSDjga8gInN0YWJsZSIg44OB44O844OgIDxzdGFibGVAa2VybmVs
Lm9yZz4g44Gn44Oh44Oz44OG44GV44KM44Gm44GK44KK44CB5b+FDQorMi42LngueSDjga8gInN0
YWJsZSIg44OB44O844OgIDxzdGFibGVAdmdlci5rZXJuZWwub3JnPiDjgafjg6Hjg7Pjg4bjgZXj
gozjgabjgYrjgorjgIHlv4UNCiDopoHjgavlv5zjgZjjgabjg6rjg6rjg7zjgrnjgZXjgozjgb7j
gZnjgILpgJrluLjjga7jg6rjg6rjg7zjgrnmnJ/plpPjga8gMumAsemWk+avjuOBp+OBmeOBjOOA
geW3ruOBl+i/q+OBow0KIOOBn+WVj+mhjOOBjOOBquOBkeOCjOOBsOOCguOBhuWwkeOBl+mVt+OB
j+OBquOCi+OBk+OBqOOCguOBguOCiuOBvuOBmeOAguOCu+OCreODpeODquODhuOCo+mWoumAo+OB
ruWVj+mhjA0KIOOBruWgtOWQiOOBr+OBk+OCjOOBq+WvvuOBl+OBpuOBoOOBhOOBn+OBhOOBruWg
tOWQiOOAgeOBmeOBkOOBq+ODquODquODvOOCueOBjOOBleOCjOOBvuOBmeOAgg0KZGlmZiAtLWdp
dCBhL0RvY3VtZW50YXRpb24vamFfSlAvc3RhYmxlX2tlcm5lbF9ydWxlcy50eHQgYi9Eb2N1bWVu
dGF0aW9uL2phX0pQL3N0YWJsZV9rZXJuZWxfcnVsZXMudHh0DQppbmRleCAxNDI2NTgzLi45ZGJk
YTliIDEwMDY0NA0KLS0tIGEvRG9jdW1lbnRhdGlvbi9qYV9KUC9zdGFibGVfa2VybmVsX3J1bGVz
LnR4dA0KKysrIGIvRG9jdW1lbnRhdGlvbi9qYV9KUC9zdGFibGVfa2VybmVsX3J1bGVzLnR4dA0K
QEAgLTUwLDE2ICs1MCwxNiBAQCBsaW51eC0yLjYuMjkvRG9jdW1lbnRhdGlvbi9zdGFibGVfa2Vy
bmVsX3J1bGVzLnR4dA0KIA0KIC1zdGFibGUg44OE44Oq44O844Gr44OR44OD44OB44KS6YCB5LuY
44GZ44KL5omL57aa44GNLQ0KIA0KLSAtIOS4iuiomOOBruimj+WJh+OBq+W+k+OBo+OBpuOBhOOC
i+OBi+OCkueiuuiqjeOBl+OBn+W+jOOBq+OAgXN0YWJsZUBrZXJuZWwub3JnIOOBq+ODkeODg+OD
gQ0KKyAtIOS4iuiomOOBruimj+WJh+OBq+W+k+OBo+OBpuOBhOOCi+OBi+OCkueiuuiqjeOBl+OB
n+W+jOOBq+OAgXN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcg44Gr44OR44OD44OBDQogICAg44KS6YCB
44KL44CCDQogIC0g6YCB5L+h6ICF44Gv44OR44OD44OB44GM44Kt44Ol44O844Gr5Y+X44GR5LuY
44GR44KJ44KM44Gf6Zqb44Gr44GvIEFDSyDjgpLjgIHljbTkuIvjgZXjgozjgZ/loLTlkIgNCiAg
ICDjgavjga8gTkFLIOOCkuWPl+OBkeWPluOCi+OAguOBk+OBruWPjeW/nOOBr+mWi+eZuuiAheOB
n+OBoeOBruOCueOCseOCuOODpeODvOODq+OBq+OCiOOBo+OBpuOAgeaVsA0KICAgIOaXpeOBi+OB
i+OCi+WgtOWQiOOBjOOBguOCi+OAgg0KICAtIOOCguOBl+WPl+OBkeWPluOCieOCjOOBn+OCieOA
geODkeODg+ODgeOBr+S7luOBrumWi+eZuuiAheOBn+OBoeOBqOmWoumAo+OBmeOCi+OCteODluOC
t+OCueODhuODoOOBrg0KICAgIOODoeODs+ODhuODiuODvOOBq+OCiOOCi+ODrOODk+ODpeODvOOB
ruOBn+OCgeOBqyAtc3RhYmxlIOOCreODpeODvOOBq+i/veWKoOOBleOCjOOCi+OAgg0KLSAtIOOD
keODg+ODgeOBqyBzdGFibGVAa2VybmVsLm9yZyDjga7jgqLjg4njg6zjgrnjgYzku5jliqDjgZXj
gozjgabjgYTjgovjgajjgY3jgavjga/jgIHjgZ3jgowNCisgLSDjg5Hjg4Pjg4Hjgasgc3RhYmxl
QHZnZXIua2VybmVsLm9yZyDjga7jgqLjg4njg6zjgrnjgYzku5jliqDjgZXjgozjgabjgYTjgovj
gajjgY3jgavjga/jgIHjgZ3jgowNCiAgICDjgYwgTGludXMg44Gu44OE44Oq44O844Gr5YWl44KL
5pmC44Gr6Ieq5YuV55qE44GrIHN0YWJsZSDjg4Hjg7zjg6DjgasgZW1haWwg44GV44KM44KL44CC
DQotIC0g44K744Kt44Ol44Oq44OG44Kj44OR44OD44OB44Gv44GT44Gu44Ko44Kk44Oq44Ki44K5
IChzdGFibGVAa2VybmVsLm9yZykg44Gr6YCB44KJ44KM44KL44G5DQorIC0g44K744Kt44Ol44Oq
44OG44Kj44OR44OD44OB44Gv44GT44Gu44Ko44Kk44Oq44Ki44K5IChzdGFibGVAdmdlci5rZXJu
ZWwub3JnKSDjgavpgIHjgonjgozjgovjgbkNCiAgICDjgY3jgafjga/jgarjgY/jgIHku6Pjgo/j
gorjgasgc2VjdXJpdHlAa2VybmVsLm9yZyDjga7jgqLjg4njg6zjgrnjgavpgIHjgonjgozjgovj
gIINCiANCiDjg6zjg5Pjg6Xjg7zjgrXjgqTjgq/jg6stDQpkaWZmIC0tZ2l0IGEvRG9jdW1lbnRh
dGlvbi96aF9DTi9IT1dUTyBiL0RvY3VtZW50YXRpb24vemhfQ04vSE9XVE8NCmluZGV4IGZhZjk3
NmMuLjU2Y2ViMDUgMTAwNjQ0DQotLS0gYS9Eb2N1bWVudGF0aW9uL3poX0NOL0hPV1RPDQorKysg
Yi9Eb2N1bWVudGF0aW9uL3poX0NOL0hPV1RPDQpAQCAtMjM3LDcgKzIzNyw3IEBAIGtlcm5lbC5v
cmfnvZHnq5nnmoRwdWIvbGludXgva2VybmVsL3YyLjYv55uu5b2V5LiL5om+5Yiw5a6D44CC5a6D
55qE5byA5Y+R6YG15b6qDQog5aaC5p6c5rKh5pyJMi42LngueeeJiOacrOWGheaguOWtmOWcqO+8
jOmCo+S5iOacgOaWsOeahDIuNi5454mI5pys5YaF5qC45bCx55u45b2T5LqO5piv5b2T5YmN55qE
56iz5a6aDQog54mI5YaF5qC444CCDQogDQotMi42LngueeeJiOacrOeUseKAnOeos+WumueJiOKA
neWwj+e7hO+8iOmCruS7tuWcsOWdgDxzdGFibGVAa2VybmVsLm9yZz7vvInnu7TmiqTvvIzkuIDo
iKzpmpTlkajlj5ENCisyLjYueC5554mI5pys55Sx4oCc56iz5a6a54mI4oCd5bCP57uE77yI6YKu
5Lu25Zyw5Z2APHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+77yJ57u05oqk77yM5LiA6Iis6ZqU5ZGo
5Y+RDQog5biD5paw54mI5pys44CCDQogDQog5YaF5qC45rqQ56CB5Lit55qERG9jdW1lbnRhdGlv
bi9zdGFibGVfa2VybmVsX3J1bGVzLnR4dOaWh+S7tuWFt+S9k+aPj+i/sOS6huWPr+iiq+eos+Wu
mg0KZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vemhfQ04vc3RhYmxlX2tlcm5lbF9ydWxlcy50
eHQgYi9Eb2N1bWVudGF0aW9uL3poX0NOL3N0YWJsZV9rZXJuZWxfcnVsZXMudHh0DQppbmRleCBi
NWI5YjBhLi4yNmVhNWVkIDEwMDY0NA0KLS0tIGEvRG9jdW1lbnRhdGlvbi96aF9DTi9zdGFibGVf
a2VybmVsX3J1bGVzLnR4dA0KKysrIGIvRG9jdW1lbnRhdGlvbi96aF9DTi9zdGFibGVfa2VybmVs
X3J1bGVzLnR4dA0KQEAgLTQyLDcgKzQyLDcgQEAgRG9jdW1lbnRhdGlvbi9zdGFibGVfa2VybmVs
X3J1bGVzLnR4dCDnmoTkuK3mlofnv7vor5ENCiANCiDlkJHnqLPlrprniYjku6PnoIHmoJHmj5Dk
uqTooaXkuIHnmoTov4fnqIvvvJoNCiANCi0gIC0g5Zyo56Gu6K6k5LqG6KGl5LiB56ym5ZCI5Lul
5LiK55qE6KeE5YiZ5ZCO77yM5bCG6KGl5LiB5Y+R6YCB5Yiwc3RhYmxlQGtlcm5lbC5vcmfjgIIN
CisgIC0g5Zyo56Gu6K6k5LqG6KGl5LiB56ym5ZCI5Lul5LiK55qE6KeE5YiZ5ZCO77yM5bCG6KGl
5LiB5Y+R6YCB5Yiwc3RhYmxlQHZnZXIua2VybmVsLm9yZ+OAgg0KICAgLSDlpoLmnpzooaXkuIHo
oqvmjqXlj5fliLDpmJ/liJfph4zvvIzlj5HpgIHogIXkvJrmlLbliLDkuIDkuKpBQ0vlm57lpI3v
vIzlpoLmnpzmsqHmnInooqvmjqXlj5fvvIzmlLYNCiAgICAg5Yiw55qE5pivTkFL5Zue5aSN44CC
5Zue5aSN6ZyA6KaB5Yeg5aSp55qE5pe26Ze077yM6L+Z5Y+W5Yaz5LqO5byA5Y+R6ICF55qE5pe2
6Ze05a6J5o6S44CCDQogICAtIOiiq+aOpeWPl+eahOihpeS4geS8muiiq+WKoOWIsOeos+WumueJ
iOacrOmYn+WIl+mHjO+8jOetieW+heWFtuS7luW8gOWPkeiAheeahOWuoeafpeOAgg0KZGlmZiAt
LWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUNCmluZGV4IDMxN2Q1ZWEuLmY4YjY0MmQgMTAwNjQ0
DQotLS0gYS9NYWtlZmlsZQ0KKysrIGIvTWFrZWZpbGUNCkBAIC0xLDYgKzEsNiBAQA0KIFZFUlNJ
T04gPSAzDQogUEFUQ0hMRVZFTCA9IDINCi1TVUJMRVZFTCA9IDYwDQorU1VCTEVWRUwgPSA2MQ0K
IEVYVFJBVkVSU0lPTiA9DQogTkFNRSA9IFNhYmVyLXRvb3RoZWQgU3F1aXJyZWwNCiANCmRpZmYg
LS1naXQgYS9hcmNoL2FybS9pbmNsdWRlL2FzbS91YWNjZXNzLmggYi9hcmNoL2FybS9pbmNsdWRl
L2FzbS91YWNjZXNzLmgNCmluZGV4IDI5MmMzZjguLjE4YTI4NTggMTAwNjQ0DQotLS0gYS9hcmNo
L2FybS9pbmNsdWRlL2FzbS91YWNjZXNzLmgNCisrKyBiL2FyY2gvYXJtL2luY2x1ZGUvYXNtL3Vh
Y2Nlc3MuaA0KQEAgLTE1OCw4ICsxNTgsOSBAQCBleHRlcm4gaW50IF9fcHV0X3VzZXJfOCh2b2lk
ICosIHVuc2lnbmVkIGxvbmcgbG9uZyk7DQogI2RlZmluZSBwdXRfdXNlcih4LHApCQkJCQkJCVwN
CiAJKHsJCQkJCQkJCVwNCiAJCXVuc2lnbmVkIGxvbmcgX19saW1pdCA9IGN1cnJlbnRfdGhyZWFk
X2luZm8oKS0+YWRkcl9saW1pdCAtIDE7IFwNCisJCWNvbnN0IHR5cGVvZigqKHApKSBfX3VzZXIg
Kl9fdG1wX3AgPSAocCk7CQlcDQogCQlyZWdpc3RlciBjb25zdCB0eXBlb2YoKihwKSkgX19yMiBh
c20oInIyIikgPSAoeCk7CVwNCi0JCXJlZ2lzdGVyIGNvbnN0IHR5cGVvZigqKHApKSBfX3VzZXIg
Kl9fcCBhc20oInIwIikgPSAocCk7XA0KKwkJcmVnaXN0ZXIgY29uc3QgdHlwZW9mKCoocCkpIF9f
dXNlciAqX19wIGFzbSgicjAiKSA9IF9fdG1wX3A7IFwNCiAJCXJlZ2lzdGVyIHVuc2lnbmVkIGxv
bmcgX19sIGFzbSgicjEiKSA9IF9fbGltaXQ7CQlcDQogCQlyZWdpc3RlciBpbnQgX19lIGFzbSgi
cjAiKTsJCQkJXA0KIAkJc3dpdGNoIChzaXplb2YoKihfX3ApKSkgewkJCQlcDQpkaWZmIC0tZ2l0
IGEvYXJjaC9hcm0va2VybmVsL2NyYXNoX2R1bXAuYyBiL2FyY2gvYXJtL2tlcm5lbC9jcmFzaF9k
dW1wLmMNCmluZGV4IDkwYzUwZDQuLjVkMTI4NmQgMTAwNjQ0DQotLS0gYS9hcmNoL2FybS9rZXJu
ZWwvY3Jhc2hfZHVtcC5jDQorKysgYi9hcmNoL2FybS9rZXJuZWwvY3Jhc2hfZHVtcC5jDQpAQCAt
MzksNyArMzksNyBAQCBzc2l6ZV90IGNvcHlfb2xkbWVtX3BhZ2UodW5zaWduZWQgbG9uZyBwZm4s
IGNoYXIgKmJ1ZiwNCiAJaWYgKCFjc2l6ZSkNCiAJCXJldHVybiAwOw0KIA0KLQl2YWRkciA9IGlv
cmVtYXAocGZuIDw8IFBBR0VfU0hJRlQsIFBBR0VfU0laRSk7DQorCXZhZGRyID0gaW9yZW1hcChf
X3Bmbl90b19waHlzKHBmbiksIFBBR0VfU0laRSk7DQogCWlmICghdmFkZHIpDQogCQlyZXR1cm4g
LUVOT01FTTsNCiANCmRpZmYgLS1naXQgYS9hcmNoL2FybS9wbGF0LW14Yy9kZXZpY2VzL3BsYXRm
b3JtLWlwdS1jb3JlLmMgYi9hcmNoL2FybS9wbGF0LW14Yy9kZXZpY2VzL3BsYXRmb3JtLWlwdS1j
b3JlLmMNCmluZGV4IDc5ZDM0MGEuLjE1ZjM0MjEgMTAwNjQ0DQotLS0gYS9hcmNoL2FybS9wbGF0
LW14Yy9kZXZpY2VzL3BsYXRmb3JtLWlwdS1jb3JlLmMNCisrKyBiL2FyY2gvYXJtL3BsYXQtbXhj
L2RldmljZXMvcGxhdGZvcm0taXB1LWNvcmUuYw0KQEAgLTc3LDcgKzc3LDcgQEAgc3RydWN0IHBs
YXRmb3JtX2RldmljZSAqX19pbml0IGlteF9hbGxvY19teDNfY2FtZXJhKA0KIA0KIAlwZGV2ID0g
cGxhdGZvcm1fZGV2aWNlX2FsbG9jKCJteDMtY2FtZXJhIiwgMCk7DQogCWlmICghcGRldikNCi0J
CWdvdG8gZXJyOw0KKwkJcmV0dXJuIEVSUl9QVFIoLUVOT01FTSk7DQogDQogCXBkZXYtPmRldi5k
bWFfbWFzayA9IGttYWxsb2Moc2l6ZW9mKCpwZGV2LT5kZXYuZG1hX21hc2spLCBHRlBfS0VSTkVM
KTsNCiAJaWYgKCFwZGV2LT5kZXYuZG1hX21hc2spDQpkaWZmIC0tZ2l0IGEvYXJjaC9taXBzL2lu
Y2x1ZGUvYXNtL3RocmVhZF9pbmZvLmggYi9hcmNoL21pcHMvaW5jbHVkZS9hc20vdGhyZWFkX2lu
Zm8uaA0KaW5kZXggYWRkYTAzNi4uMzVkMWI0NyAxMDA2NDQNCi0tLSBhL2FyY2gvbWlwcy9pbmNs
dWRlL2FzbS90aHJlYWRfaW5mby5oDQorKysgYi9hcmNoL21pcHMvaW5jbHVkZS9hc20vdGhyZWFk
X2luZm8uaA0KQEAgLTE0OSw2ICsxNDksOCBAQCByZWdpc3RlciBzdHJ1Y3QgdGhyZWFkX2luZm8g
Kl9fY3VycmVudF90aHJlYWRfaW5mbyBfX2FzbV9fKCIkMjgiKTsNCiAjZGVmaW5lIF9USUZfRlBV
Qk9VTkQJCSgxPDxUSUZfRlBVQk9VTkQpDQogI2RlZmluZSBfVElGX0xPQURfV0FUQ0gJCSgxPDxU
SUZfTE9BRF9XQVRDSCkNCiANCisjZGVmaW5lIF9USUZfV09SS19TWVNDQUxMX0VOVFJZCShfVElG
X1NZU0NBTExfVFJBQ0UgfCBfVElGX1NZU0NBTExfQVVESVQgfCBfVElGX1NFQ0NPTVApDQorDQog
Lyogd29yayB0byBkbyBpbiBzeXNjYWxsX3RyYWNlX2xlYXZlKCkgKi8NCiAjZGVmaW5lIF9USUZf
V09SS19TWVNDQUxMX0VYSVQJKF9USUZfU1lTQ0FMTF9UUkFDRSB8IF9USUZfU1lTQ0FMTF9BVURJ
VCkNCiANCmRpZmYgLS1naXQgYS9hcmNoL21pcHMva2VybmVsL2lycS1tc2MwMS5jIGIvYXJjaC9t
aXBzL2tlcm5lbC9pcnEtbXNjMDEuYw0KaW5kZXggMTRhYzUyYy4uODg0ZGUzNCAxMDA2NDQNCi0t
LSBhL2FyY2gvbWlwcy9rZXJuZWwvaXJxLW1zYzAxLmMNCisrKyBiL2FyY2gvbWlwcy9rZXJuZWwv
aXJxLW1zYzAxLmMNCkBAIC0xMzEsNyArMTMxLDcgQEAgdm9pZCBfX2luaXQgaW5pdF9tc2NfaXJx
cyh1bnNpZ25lZCBsb25nIGljdWJhc2UsIHVuc2lnbmVkIGludCBpcnFiYXNlLCBtc2NfaXJxbWEN
CiANCiAJYm9hcmRfYmluZF9laWNfaW50ZXJydXB0ID0gJm1zY19iaW5kX2VpY19pbnRlcnJ1cHQ7
DQogDQotCWZvciAoOyBuaXJxID49IDA7IG5pcnEtLSwgaW1wKyspIHsNCisJZm9yICg7IG5pcnEg
PiAwOyBuaXJxLS0sIGltcCsrKSB7DQogCQlpbnQgbiA9IGltcC0+aW1faXJxOw0KIA0KIAkJc3dp
dGNoIChpbXAtPmltX3R5cGUpIHsNCmRpZmYgLS1naXQgYS9hcmNoL21pcHMva2VybmVsL3NjYWxs
MzItbzMyLlMgYi9hcmNoL21pcHMva2VybmVsL3NjYWxsMzItbzMyLlMNCmluZGV4IGE2MzJiYzEu
LjFkMzliZWEgMTAwNjQ0DQotLS0gYS9hcmNoL21pcHMva2VybmVsL3NjYWxsMzItbzMyLlMNCisr
KyBiL2FyY2gvbWlwcy9rZXJuZWwvc2NhbGwzMi1vMzIuUw0KQEAgLTUyLDcgKzUyLDcgQEAgTkVT
VEVEKGhhbmRsZV9zeXMsIFBUX1NJWkUsIHNwKQ0KIA0KIHN0YWNrX2RvbmU6DQogCWx3CXQwLCBU
SV9GTEFHUygkMjgpCSMgc3lzY2FsbCB0cmFjaW5nIGVuYWJsZWQ/DQotCWxpCXQxLCBfVElGX1NZ
U0NBTExfVFJBQ0UgfCBfVElGX1NZU0NBTExfQVVESVQNCisJbGkJdDEsIF9USUZfV09SS19TWVND
QUxMX0VOVFJZDQogCWFuZAl0MCwgdDENCiAJYm5legl0MCwgc3lzY2FsbF90cmFjZV9lbnRyeQkj
IC0+IHllcw0KIA0KZGlmZiAtLWdpdCBhL2FyY2gvbWlwcy9rZXJuZWwvc2NhbGw2NC02NC5TIGIv
YXJjaC9taXBzL2tlcm5lbC9zY2FsbDY0LTY0LlMNCmluZGV4IDNiNWE1ZTkuLjUzZTY1ZmYgMTAw
NjQ0DQotLS0gYS9hcmNoL21pcHMva2VybmVsL3NjYWxsNjQtNjQuUw0KKysrIGIvYXJjaC9taXBz
L2tlcm5lbC9zY2FsbDY0LTY0LlMNCkBAIC01NCw3ICs1NCw3IEBAIE5FU1RFRChoYW5kbGVfc3lz
NjQsIFBUX1NJWkUsIHNwKQ0KIA0KIAlzZAlhMywgUFRfUjI2KHNwKQkJIyBzYXZlIGEzIGZvciBz
eXNjYWxsIHJlc3RhcnRpbmcNCiANCi0JbGkJdDEsIF9USUZfU1lTQ0FMTF9UUkFDRSB8IF9USUZf
U1lTQ0FMTF9BVURJVA0KKwlsaQl0MSwgX1RJRl9XT1JLX1NZU0NBTExfRU5UUlkNCiAJTE9OR19M
CXQwLCBUSV9GTEFHUygkMjgpCSMgc3lzY2FsbCB0cmFjaW5nIGVuYWJsZWQ/DQogCWFuZAl0MCwg
dDEsIHQwDQogCWJuZXoJdDAsIHN5c2NhbGxfdHJhY2VfZW50cnkNCmRpZmYgLS1naXQgYS9hcmNo
L21pcHMva2VybmVsL3NjYWxsNjQtbjMyLlMgYi9hcmNoL21pcHMva2VybmVsL3NjYWxsNjQtbjMy
LlMNCmluZGV4IDZiZTZmNzAuLjU0NzZjZTQgMTAwNjQ0DQotLS0gYS9hcmNoL21pcHMva2VybmVs
L3NjYWxsNjQtbjMyLlMNCisrKyBiL2FyY2gvbWlwcy9rZXJuZWwvc2NhbGw2NC1uMzIuUw0KQEAg
LTUzLDcgKzUzLDcgQEAgTkVTVEVEKGhhbmRsZV9zeXNuMzIsIFBUX1NJWkUsIHNwKQ0KIA0KIAlz
ZAlhMywgUFRfUjI2KHNwKQkJIyBzYXZlIGEzIGZvciBzeXNjYWxsIHJlc3RhcnRpbmcNCiANCi0J
bGkJdDEsIF9USUZfU1lTQ0FMTF9UUkFDRSB8IF9USUZfU1lTQ0FMTF9BVURJVA0KKwlsaQl0MSwg
X1RJRl9XT1JLX1NZU0NBTExfRU5UUlkNCiAJTE9OR19MCXQwLCBUSV9GTEFHUygkMjgpCSMgc3lz
Y2FsbCB0cmFjaW5nIGVuYWJsZWQ/DQogCWFuZAl0MCwgdDEsIHQwDQogCWJuZXoJdDAsIG4zMl9z
eXNjYWxsX3RyYWNlX2VudHJ5DQpkaWZmIC0tZ2l0IGEvYXJjaC9taXBzL2tlcm5lbC9zY2FsbDY0
LW8zMi5TIGIvYXJjaC9taXBzL2tlcm5lbC9zY2FsbDY0LW8zMi5TDQppbmRleCA1NDIyODU1Li5h
NTYxNzViIDEwMDY0NA0KLS0tIGEvYXJjaC9taXBzL2tlcm5lbC9zY2FsbDY0LW8zMi5TDQorKysg
Yi9hcmNoL21pcHMva2VybmVsL3NjYWxsNjQtbzMyLlMNCkBAIC04MSw3ICs4MSw3IEBAIE5FU1RF
RChoYW5kbGVfc3lzLCBQVF9TSVpFLCBzcCkNCiAJUFRSCTRiLCBiYWRfc3RhY2sNCiAJLnByZXZp
b3VzDQogDQotCWxpCXQxLCBfVElGX1NZU0NBTExfVFJBQ0UgfCBfVElGX1NZU0NBTExfQVVESVQN
CisJbGkJdDEsIF9USUZfV09SS19TWVNDQUxMX0VOVFJZDQogCUxPTkdfTAl0MCwgVElfRkxBR1Mo
JDI4KQkjIHN5c2NhbGwgdHJhY2luZyBlbmFibGVkPw0KIAlhbmQJdDAsIHQxLCB0MA0KIAlibmV6
CXQwLCB0cmFjZV9hX3N5c2NhbGwNCmRpZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMvTWFrZWZpbGUg
Yi9hcmNoL3Bvd2VycGMvTWFrZWZpbGUNCmluZGV4IDcwYmEwYzAuLjlhOTgwYjMgMTAwNjQ0DQot
LS0gYS9hcmNoL3Bvd2VycGMvTWFrZWZpbGUNCisrKyBiL2FyY2gvcG93ZXJwYy9NYWtlZmlsZQ0K
QEAgLTY5LDcgKzY5LDkgQEAgTERGTEFHU192bWxpbnV4CTo9ICQoTERGTEFHU192bWxpbnV4LXl5
KQ0KIA0KIENGTEFHUy0kKENPTkZJR19QUEM2NCkJOj0gLW1taW5pbWFsLXRvYyAtbXRyYWNlYmFj
az1ubyAtbWNhbGwtYWl4ZGVzYw0KIENGTEFHUy0kKENPTkZJR19QUEMzMikJOj0gLWZmaXhlZC1y
MiAtbW11bHRpcGxlDQotS0JVSUxEX0NQUEZMQUdTCSs9IC1JYXJjaC8kKEFSQ0gpDQorYXNpbnN0
ciA6PSAkKGNhbGwgYXMtaW5zdHIsbGlzIDkkKGNvbW1hKWZvb0BoaWdoLC1ESEFWRV9BU19BVEhJ
R0g9MSkNCisNCitLQlVJTERfQ1BQRkxBR1MJKz0gLUlhcmNoLyQoQVJDSCkgJChhc2luc3RyKQ0K
IEtCVUlMRF9BRkxBR1MJKz0gLUlhcmNoLyQoQVJDSCkNCiBLQlVJTERfQ0ZMQUdTCSs9IC1tc29m
dC1mbG9hdCAtcGlwZSAtSWFyY2gvJChBUkNIKSAkKENGTEFHUy15KQ0KIENQUAkJPSAkKENDKSAt
RSAkKEtCVUlMRF9DRkxBR1MpDQpkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNt
L3BwY19hc20uaCBiL2FyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9wcGNfYXNtLmgNCmluZGV4IDM2
OGY3MmYuLjBmM2E3NDAgMTAwNjQ0DQotLS0gYS9hcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vcHBj
X2FzbS5oDQorKysgYi9hcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vcHBjX2FzbS5oDQpAQCAtMjky
LDExICsyOTIsMTYgQEAgbjoNCiAgKiAgICAgIGxkCXJZLEFERFJPRkYobmFtZSkoclgpDQogICov
DQogI2lmZGVmIF9fcG93ZXJwYzY0X18NCisjaWZkZWYgSEFWRV9BU19BVEhJR0gNCisjZGVmaW5l
IF9fQVNfQVRISUdIIGhpZ2gNCisjZWxzZQ0KKyNkZWZpbmUgX19BU19BVEhJR0ggaA0KKyNlbmRp
Zg0KICNkZWZpbmUgTE9BRF9SRUdfSU1NRURJQVRFKHJlZyxleHByKQkJXA0KIAlsaXMgICAgIChy
ZWcpLChleHByKUBoaWdoZXN0OwkJXA0KIAlvcmkgICAgIChyZWcpLChyZWcpLChleHByKUBoaWdo
ZXI7CVwNCiAJcmxkaWNyICAocmVnKSwocmVnKSwzMiwzMTsJCVwNCi0Jb3JpcyAgICAocmVnKSwo
cmVnKSwoZXhwcilAaDsJCVwNCisJb3JpcyAgICByZWcscmVnLChleHByKUBfX0FTX0FUSElHSDsJ
XA0KIAlvcmkgICAgIChyZWcpLChyZWcpLChleHByKUBsOw0KIA0KICNkZWZpbmUgTE9BRF9SRUdf
QUREUihyZWcsbmFtZSkJCQlcDQpkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL2tlcm5lbC9sZWdh
Y3lfc2VyaWFsLmMgYi9hcmNoL3Bvd2VycGMva2VybmVsL2xlZ2FjeV9zZXJpYWwuYw0KaW5kZXgg
YzdiNWFmZS4uYzc3MTU5ZCAxMDA2NDQNCi0tLSBhL2FyY2gvcG93ZXJwYy9rZXJuZWwvbGVnYWN5
X3NlcmlhbC5jDQorKysgYi9hcmNoL3Bvd2VycGMva2VybmVsL2xlZ2FjeV9zZXJpYWwuYw0KQEAg
LTQ4LDYgKzQ4LDkgQEAgc3RhdGljIHN0cnVjdCBfX2luaXRkYXRhIG9mX2RldmljZV9pZCBsZWdh
Y3lfc2VyaWFsX3BhcmVudHNbXSA9IHsNCiBzdGF0aWMgdW5zaWduZWQgaW50IGxlZ2FjeV9zZXJp
YWxfY291bnQ7DQogc3RhdGljIGludCBsZWdhY3lfc2VyaWFsX2NvbnNvbGUgPSAtMTsNCiANCitz
dGF0aWMgY29uc3QgdXBmX3QgbGVnYWN5X3BvcnRfZmxhZ3MgPSBVUEZfQk9PVF9BVVRPQ09ORiB8
IFVQRl9TS0lQX1RFU1QgfA0KKwlVUEZfU0hBUkVfSVJRIHwgVVBGX0ZJWEVEX1BPUlQ7DQorDQog
c3RhdGljIHVuc2lnbmVkIGludCB0c2lfc2VyaWFsX2luKHN0cnVjdCB1YXJ0X3BvcnQgKnAsIGlu
dCBvZmZzZXQpDQogew0KIAl1bnNpZ25lZCBpbnQgdG1wOw0KQEAgLTE1Myw4ICsxNTYsNiBAQCBz
dGF0aWMgaW50IF9faW5pdCBhZGRfbGVnYWN5X3NvY19wb3J0KHN0cnVjdCBkZXZpY2Vfbm9kZSAq
bnAsDQogew0KIAl1NjQgYWRkcjsNCiAJY29uc3QgdTMyICphZGRycDsNCi0JdXBmX3QgZmxhZ3Mg
PSBVUEZfQk9PVF9BVVRPQ09ORiB8IFVQRl9TS0lQX1RFU1QgfCBVUEZfU0hBUkVfSVJRDQotCQl8
IFVQRl9GSVhFRF9QT1JUOw0KIAlzdHJ1Y3QgZGV2aWNlX25vZGUgKnRzaSA9IG9mX2dldF9wYXJl
bnQobnApOw0KIA0KIAkvKiBXZSBvbmx5IHN1cHBvcnQgcG9ydHMgdGhhdCBoYXZlIGEgY2xvY2sg
ZnJlcXVlbmN5IHByb3Blcmx5DQpAQCAtMTg1LDkgKzE4NiwxMSBAQCBzdGF0aWMgaW50IF9faW5p
dCBhZGRfbGVnYWN5X3NvY19wb3J0KHN0cnVjdCBkZXZpY2Vfbm9kZSAqbnAsDQogCSAqIElPIHBv
cnQgdmFsdWUuIEl0IHdpbGwgYmUgZml4ZWQgdXAgbGF0ZXIgYWxvbmcgd2l0aCB0aGUgaXJxDQog
CSAqLw0KIAlpZiAodHNpICYmICFzdHJjbXAodHNpLT50eXBlLCAidHNpLWJyaWRnZSIpKQ0KLQkJ
cmV0dXJuIGFkZF9sZWdhY3lfcG9ydChucCwgLTEsIFVQSU9fVFNJLCBhZGRyLCBhZGRyLCBOT19J
UlEsIGZsYWdzLCAwKTsNCisJCXJldHVybiBhZGRfbGVnYWN5X3BvcnQobnAsIC0xLCBVUElPX1RT
SSwgYWRkciwgYWRkciwNCisJCQkJICAgICAgIE5PX0lSUSwgbGVnYWN5X3BvcnRfZmxhZ3MsIDAp
Ow0KIAllbHNlDQotCQlyZXR1cm4gYWRkX2xlZ2FjeV9wb3J0KG5wLCAtMSwgVVBJT19NRU0sIGFk
ZHIsIGFkZHIsIE5PX0lSUSwgZmxhZ3MsIDApOw0KKwkJcmV0dXJuIGFkZF9sZWdhY3lfcG9ydChu
cCwgLTEsIFVQSU9fTUVNLCBhZGRyLCBhZGRyLA0KKwkJCQkgICAgICAgTk9fSVJRLCBsZWdhY3lf
cG9ydF9mbGFncywgMCk7DQogfQ0KIA0KIHN0YXRpYyBpbnQgX19pbml0IGFkZF9sZWdhY3lfaXNh
X3BvcnQoc3RydWN0IGRldmljZV9ub2RlICpucCwNCkBAIC0yMjgsNyArMjMxLDcgQEAgc3RhdGlj
IGludCBfX2luaXQgYWRkX2xlZ2FjeV9pc2FfcG9ydChzdHJ1Y3QgZGV2aWNlX25vZGUgKm5wLA0K
IA0KIAkvKiBBZGQgcG9ydCwgaXJxIHdpbGwgYmUgZGVhbHQgd2l0aCBsYXRlciAqLw0KIAlyZXR1
cm4gYWRkX2xlZ2FjeV9wb3J0KG5wLCBpbmRleCwgVVBJT19QT1JULCBiZTMyX3RvX2NwdShyZWdb
MV0pLCB0YWRkciwNCi0JCQkgICAgICAgTk9fSVJRLCBVUEZfQk9PVF9BVVRPQ09ORiwgMCk7DQor
CQkJICAgICAgIE5PX0lSUSwgbGVnYWN5X3BvcnRfZmxhZ3MsIDApOw0KIA0KIH0NCiANCkBAIC0z
MDEsNyArMzA0LDcgQEAgc3RhdGljIGludCBfX2luaXQgYWRkX2xlZ2FjeV9wY2lfcG9ydChzdHJ1
Y3QgZGV2aWNlX25vZGUgKm5wLA0KIAkgKiBJTyBwb3J0IHZhbHVlLiBJdCB3aWxsIGJlIGZpeGVk
IHVwIGxhdGVyIGFsb25nIHdpdGggdGhlIGlycQ0KIAkgKi8NCiAJcmV0dXJuIGFkZF9sZWdhY3lf
cG9ydChucCwgaW5kZXgsIGlvdHlwZSwgYmFzZSwgYWRkciwgTk9fSVJRLA0KLQkJCSAgICAgICBV
UEZfQk9PVF9BVVRPQ09ORiwgbnAgIT0gcGNpX2Rldik7DQorCQkJICAgICAgIGxlZ2FjeV9wb3J0
X2ZsYWdzLCBucCAhPSBwY2lfZGV2KTsNCiB9DQogI2VuZGlmDQogDQpkaWZmIC0tZ2l0IGEvYXJj
aC9wb3dlcnBjL2tlcm5lbC9zZXR1cC1jb21tb24uYyBiL2FyY2gvcG93ZXJwYy9rZXJuZWwvc2V0
dXAtY29tbW9uLmMNCmluZGV4IDc3YmI3N2QuLjgyMjg4ZTkgMTAwNjQ0DQotLS0gYS9hcmNoL3Bv
d2VycGMva2VybmVsL3NldHVwLWNvbW1vbi5jDQorKysgYi9hcmNoL3Bvd2VycGMva2VybmVsL3Nl
dHVwLWNvbW1vbi5jDQpAQCAtNDQ5LDcgKzQ0OSw3IEBAIHZvaWQgX19pbml0IHNtcF9zZXR1cF9j
cHVfbWFwcyh2b2lkKQ0KIAkJZm9yIChqID0gMDsgaiA8IG50aHJlYWRzICYmIGNwdSA8IG5yX2Nw
dV9pZHM7IGorKykgew0KIAkJCURCRygiICAgIHRocmVhZCAlZCAtPiBjcHUgJWQgKGhhcmQgaWQg
JWQpXG4iLA0KIAkJCSAgICBqLCBjcHUsIGludHNlcnZbal0pOw0KLQkJCXNldF9jcHVfcHJlc2Vu
dChjcHUsIHRydWUpOw0KKwkJCXNldF9jcHVfcHJlc2VudChjcHUsIG9mX2RldmljZV9pc19hdmFp
bGFibGUoZG4pKTsNCiAJCQlzZXRfaGFyZF9zbXBfcHJvY2Vzc29yX2lkKGNwdSwgaW50c2Vydltq
XSk7DQogCQkJc2V0X2NwdV9wb3NzaWJsZShjcHUsIHRydWUpOw0KIAkJCWNwdSsrOw0KZGlmZiAt
LWdpdCBhL2FyY2gvczM5MC9pbmNsdWRlL2FzbS9sb3djb3JlLmggYi9hcmNoL3MzOTAvaW5jbHVk
ZS9hc20vbG93Y29yZS5oDQppbmRleCA5ZTEzYzdkLi40NTQ1NjRiIDEwMDY0NA0KLS0tIGEvYXJj
aC9zMzkwL2luY2x1ZGUvYXNtL2xvd2NvcmUuaA0KKysrIGIvYXJjaC9zMzkwL2luY2x1ZGUvYXNt
L2xvd2NvcmUuaA0KQEAgLTE0MCw5ICsxNDAsOSBAQCBzdHJ1Y3QgX2xvd2NvcmUgew0KIAlfX3U4
CXBhZF8weDAyZThbMHgwMzAwLTB4MDJlOF07CS8qIDB4MDJlOCAqLw0KIA0KIAkvKiBJbnRlcnJ1
cHQgcmVzcG9uc2UgYmxvY2sgKi8NCi0JX191OAlpcmJbNjRdOwkJCS8qIDB4MDMwMCAqLw0KKwlf
X3U4CWlyYls5Nl07CQkJLyogMHgwMzAwICovDQogDQotCV9fdTgJcGFkXzB4MDM0MFsweDBlMDAt
MHgwMzQwXTsJLyogMHgwMzQwICovDQorCV9fdTgJcGFkXzB4MDM2MFsweDBlMDAtMHgwMzYwXTsJ
LyogMHgwMzYwICovDQogDQogCS8qDQogCSAqIDB4ZTAwIGNvbnRhaW5zIHRoZSBhZGRyZXNzIG9m
IHRoZSBJUEwgUGFyYW1ldGVyIEluZm9ybWF0aW9uDQpAQCAtMjc0LDEyICsyNzQsMTMgQEAgc3Ry
dWN0IF9sb3djb3JlIHsNCiAJX191NjQJY21mX2hwcDsJCQkvKiAweDAzNzggKi8NCiANCiAJLyog
SW50ZXJydXB0IHJlc3BvbnNlIGJsb2NrLiAqLw0KLQlfX3U4CWlyYls2NF07CQkJLyogMHgwMzgw
ICovDQorCV9fdTgJaXJiWzk2XTsJCQkvKiAweDAzODAgKi8NCisJX191OAlwYWRfMHgwM2UwWzB4
MDQwMC0weDAzZTBdOwkvKiAweDAzZTAgKi8NCiANCiAJLyogUGVyIGNwdSBwcmltYXJ5IHNwYWNl
IGFjY2VzcyBsaXN0ICovDQotCV9fdTMyCXBhc3RlWzE2XTsJCQkvKiAweDAzYzAgKi8NCisJX191
MzIJcGFzdGVbMTZdOwkJCS8qIDB4MDQwMCAqLw0KIA0KLQlfX3U4CXBhZF8weDA0MDBbMHgwZTAw
LTB4MDQwMF07CS8qIDB4MDQwMCAqLw0KKwlfX3U4CXBhZF8weDA0NDBbMHgwZTAwLTB4MDQ0MF07
CS8qIDB4MDQ0MCAqLw0KIA0KIAkvKg0KIAkgKiAweGUwMCBjb250YWlucyB0aGUgYWRkcmVzcyBv
ZiB0aGUgSVBMIFBhcmFtZXRlciBJbmZvcm1hdGlvbg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2lu
Y2x1ZGUvYXNtL3B0cmFjZS5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vcHRyYWNlLmgNCmluZGV4
IDNiOTZmZDQuLjA1ODFhODUgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9wdHJh
Y2UuaA0KKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vcHRyYWNlLmgNCkBAIC0yODcsNiArMjg3
LDIyIEBAIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZyByZWdzX2dldF9rZXJuZWxfc3RhY2tf
bnRoKHN0cnVjdCBwdF9yZWdzICpyZWdzLA0KIA0KICNkZWZpbmUgQVJDSF9IQVNfVVNFUl9TSU5H
TEVfU1RFUF9JTkZPDQogDQorLyoNCisgKiBXaGVuIGhpdHRpbmcgcHRyYWNlX3N0b3AoKSwgd2Ug
Y2Fubm90IHJldHVybiB1c2luZyBTWVNSRVQgYmVjYXVzZQ0KKyAqIHRoYXQgZG9lcyBub3QgcmVz
dG9yZSB0aGUgZnVsbCBDUFUgc3RhdGUsIG9ubHkgYSBtaW5pbWFsIHNldC4gIFRoZQ0KKyAqIHB0
cmFjZXIgY2FuIGNoYW5nZSBhcmJpdHJhcnkgcmVnaXN0ZXIgdmFsdWVzLCB3aGljaCBpcyB1c3Vh
bGx5IG9rYXkNCisgKiBiZWNhdXNlIHRoZSB1c3VhbCBwdHJhY2Ugc3RvcHMgcnVuIG9mZiB0aGUg
c2lnbmFsIGRlbGl2ZXJ5IHBhdGggd2hpY2gNCisgKiBmb3JjZXMgSVJFVDsgaG93ZXZlciwgcHRy
YWNlX2V2ZW50KCkgc3RvcHMgaGFwcGVuIGluIGFyYml0cmFyeSBwbGFjZXMNCisgKiBpbiB0aGUg
a2VybmVsIGFuZCBkb24ndCBmb3JjZSBJUkVUIHBhdGguDQorICoNCisgKiBTbyBmb3JjZSBJUkVU
IHBhdGggYWZ0ZXIgYSBwdHJhY2Ugc3RvcC4NCisgKi8NCisjZGVmaW5lIGFyY2hfcHRyYWNlX3N0
b3BfbmVlZGVkKGNvZGUsIGluZm8pCQkJCVwNCisoewkJCQkJCQkJCVwNCisJc2V0X3RocmVhZF9m
bGFnKFRJRl9OT1RJRllfUkVTVU1FKTsJCQkJXA0KKwlmYWxzZTsJCQkJCQkJCVwNCit9KQ0KKw0K
IHN0cnVjdCB1c2VyX2Rlc2M7DQogZXh0ZXJuIGludCBkb19nZXRfdGhyZWFkX2FyZWEoc3RydWN0
IHRhc2tfc3RydWN0ICpwLCBpbnQgaWR4LA0KIAkJCSAgICAgIHN0cnVjdCB1c2VyX2Rlc2MgX191
c2VyICppbmZvKTsNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvZW50cnlfMzIuUyBiL2Fy
Y2gveDg2L2tlcm5lbC9lbnRyeV8zMi5TDQppbmRleCBkMmQ0ODhiOC4uZGIwOTBmNiAxMDA2NDQN
Ci0tLSBhL2FyY2gveDg2L2tlcm5lbC9lbnRyeV8zMi5TDQorKysgYi9hcmNoL3g4Ni9rZXJuZWwv
ZW50cnlfMzIuUw0KQEAgLTQyNyw5ICs0MjcsMTAgQEAgc3lzZW50ZXJfcGFzdF9lc3A6DQogCWpu
eiBzeXNlbnRlcl9hdWRpdA0KIHN5c2VudGVyX2RvX2NhbGw6DQogCWNtcGwgJChucl9zeXNjYWxs
cyksICVlYXgNCi0JamFlIHN5c2NhbGxfYmFkc3lzDQorCWphZSBzeXNlbnRlcl9iYWRzeXMNCiAJ
Y2FsbCAqc3lzX2NhbGxfdGFibGUoLCVlYXgsNCkNCiAJbW92bCAlZWF4LFBUX0VBWCglZXNwKQ0K
K3N5c2VudGVyX2FmdGVyX2NhbGw6DQogCUxPQ0tERVBfU1lTX0VYSVQNCiAJRElTQUJMRV9JTlRF
UlJVUFRTKENMQlJfQU5ZKQ0KIAlUUkFDRV9JUlFTX09GRg0KQEAgLTY4MSw3ICs2ODIsMTIgQEAg
RU5EKHN5c2NhbGxfZmF1bHQpDQogDQogc3lzY2FsbF9iYWRzeXM6DQogCW1vdmwgJC1FTk9TWVMs
UFRfRUFYKCVlc3ApDQotCWptcCByZXN1bWVfdXNlcnNwYWNlDQorCWptcCBzeXNjYWxsX2V4aXQN
CitFTkQoc3lzY2FsbF9iYWRzeXMpDQorDQorc3lzZW50ZXJfYmFkc3lzOg0KKwltb3ZsICQtRU5P
U1lTLFBUX0VBWCglZXNwKQ0KKwlqbXAgc3lzZW50ZXJfYWZ0ZXJfY2FsbA0KIEVORChzeXNjYWxs
X2JhZHN5cykNCiAJQ0ZJX0VORFBST0MNCiAvKg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvYWNwaS9i
dXMuYyBiL2RyaXZlcnMvYWNwaS9idXMuYw0KaW5kZXggZjMyNDQyOS4uM2EwZTkyYSAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvYWNwaS9idXMuYw0KKysrIGIvZHJpdmVycy9hY3BpL2J1cy5jDQpAQCAt
NTcsNiArNTcsMTIgQEAgRVhQT1JUX1NZTUJPTChhY3BpX3Jvb3RfZGlyKTsNCiANCiANCiAjaWZk
ZWYgQ09ORklHX1g4Ng0KKyNpZmRlZiBDT05GSUdfQUNQSV9DVVNUT01fRFNEVA0KK3N0YXRpYyBp
bmxpbmUgaW50IHNldF9jb3B5X2RzZHQoY29uc3Qgc3RydWN0IGRtaV9zeXN0ZW1faWQgKmlkKQ0K
K3sNCisJcmV0dXJuIDA7DQorfQ0KKyNlbHNlDQogc3RhdGljIGludCBzZXRfY29weV9kc2R0KGNv
bnN0IHN0cnVjdCBkbWlfc3lzdGVtX2lkICppZCkNCiB7DQogCXByaW50ayhLRVJOX05PVElDRSAi
JXMgZGV0ZWN0ZWQgLSAiDQpAQCAtNjQsNiArNzAsNyBAQCBzdGF0aWMgaW50IHNldF9jb3B5X2Rz
ZHQoY29uc3Qgc3RydWN0IGRtaV9zeXN0ZW1faWQgKmlkKQ0KIAlhY3BpX2dibF9jb3B5X2RzZHRf
bG9jYWxseSA9IDE7DQogCXJldHVybiAwOw0KIH0NCisjZW5kaWYNCiANCiBzdGF0aWMgc3RydWN0
IGRtaV9zeXN0ZW1faWQgZHNkdF9kbWlfdGFibGVbXSBfX2luaXRkYXRhID0gew0KIAkvKg0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvYXRhL2FoY2kuYyBiL2RyaXZlcnMvYXRhL2FoY2kuYw0KaW5kZXgg
MGZlZmZjMy4uNDRhNDQzNCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvYXRhL2FoY2kuYw0KKysrIGIv
ZHJpdmVycy9hdGEvYWhjaS5jDQpAQCAtNDUyLDEwICs0NTIsMTQgQEAgc3RhdGljIGNvbnN0IHN0
cnVjdCBwY2lfZGV2aWNlX2lkIGFoY2lfcGNpX3RibFtdID0gew0KIAkgIC5kcml2ZXJfZGF0YSA9
IGJvYXJkX2FoY2lfeWVzX2ZicyB9LAkJCS8qIDg4c2U5MTcyICovDQogCXsgUENJX0RFVklDRShQ
Q0lfVkVORE9SX0lEX01BUlZFTExfRVhULCAweDkxOTIpLA0KIAkgIC5kcml2ZXJfZGF0YSA9IGJv
YXJkX2FoY2lfeWVzX2ZicyB9LAkJCS8qIDg4c2U5MTcyIG9uIHNvbWUgR2lnYWJ5dGUgKi8NCisJ
eyBQQ0lfREVWSUNFKFBDSV9WRU5ET1JfSURfTUFSVkVMTF9FWFQsIDB4OTFhMCksDQorCSAgLmRy
aXZlcl9kYXRhID0gYm9hcmRfYWhjaV95ZXNfZmJzIH0sDQogCXsgUENJX0RFVklDRShQQ0lfVkVO
RE9SX0lEX01BUlZFTExfRVhULCAweDkxYTMpLA0KIAkgIC5kcml2ZXJfZGF0YSA9IGJvYXJkX2Fo
Y2lfeWVzX2ZicyB9LA0KIAl7IFBDSV9ERVZJQ0UoUENJX1ZFTkRPUl9JRF9NQVJWRUxMX0VYVCwg
MHg5MjMwKSwNCiAJICAuZHJpdmVyX2RhdGEgPSBib2FyZF9haGNpX3llc19mYnMgfSwNCisJeyBQ
Q0lfREVWSUNFKFBDSV9WRU5ET1JfSURfVFRJLCAweDA2NDIpLA0KKwkgIC5kcml2ZXJfZGF0YSA9
IGJvYXJkX2FoY2lfeWVzX2ZicyB9LA0KIA0KIAkvKiBQcm9taXNlICovDQogCXsgUENJX1ZERVZJ
Q0UoUFJPTUlTRSwgMHgzZjIwKSwgYm9hcmRfYWhjaSB9LAkvKiBQREM0MjgxOSAqLw0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvYmx1ZXRvb3RoL2hjaV9sZGlzYy5jIGIvZHJpdmVycy9ibHVldG9vdGgv
aGNpX2xkaXNjLmMNCmluZGV4IDhmM2Q2ZGIuLjA4YmJjNDggMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L2JsdWV0b290aC9oY2lfbGRpc2MuYw0KKysrIGIvZHJpdmVycy9ibHVldG9vdGgvaGNpX2xkaXNj
LmMNCkBAIC0xMjAsMTAgKzEyMCw2IEBAIHN0YXRpYyBpbmxpbmUgc3RydWN0IHNrX2J1ZmYgKmhj
aV91YXJ0X2RlcXVldWUoc3RydWN0IGhjaV91YXJ0ICpodSkNCiANCiBpbnQgaGNpX3VhcnRfdHhf
d2FrZXVwKHN0cnVjdCBoY2lfdWFydCAqaHUpDQogew0KLQlzdHJ1Y3QgdHR5X3N0cnVjdCAqdHR5
ID0gaHUtPnR0eTsNCi0Jc3RydWN0IGhjaV9kZXYgKmhkZXYgPSBodS0+aGRldjsNCi0Jc3RydWN0
IHNrX2J1ZmYgKnNrYjsNCi0NCiAJaWYgKHRlc3RfYW5kX3NldF9iaXQoSENJX1VBUlRfU0VORElO
RywgJmh1LT50eF9zdGF0ZSkpIHsNCiAJCXNldF9iaXQoSENJX1VBUlRfVFhfV0FLRVVQLCAmaHUt
PnR4X3N0YXRlKTsNCiAJCXJldHVybiAwOw0KQEAgLTEzMSw2ICsxMjcsMjIgQEAgaW50IGhjaV91
YXJ0X3R4X3dha2V1cChzdHJ1Y3QgaGNpX3VhcnQgKmh1KQ0KIA0KIAlCVF9EQkcoIiIpOw0KIA0K
KwlzY2hlZHVsZV93b3JrKCZodS0+d3JpdGVfd29yayk7DQorDQorCXJldHVybiAwOw0KK30NCisN
CitzdGF0aWMgdm9pZCBoY2lfdWFydF93cml0ZV93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29y
aykNCit7DQorCXN0cnVjdCBoY2lfdWFydCAqaHUgPSBjb250YWluZXJfb2Yod29yaywgc3RydWN0
IGhjaV91YXJ0LCB3cml0ZV93b3JrKTsNCisJc3RydWN0IHR0eV9zdHJ1Y3QgKnR0eSA9IGh1LT50
dHk7DQorCXN0cnVjdCBoY2lfZGV2ICpoZGV2ID0gaHUtPmhkZXY7DQorCXN0cnVjdCBza19idWZm
ICpza2I7DQorDQorCS8qIFJFVklTSVQ6IHNob3VsZCB3ZSBjb3BlIHdpdGggYmFkIHNrYnMgb3Ig
LT53cml0ZSgpIHJldHVybmluZw0KKwkgKiBhbmQgZXJyb3IgdmFsdWUgPw0KKwkgKi8NCisNCiBy
ZXN0YXJ0Og0KIAljbGVhcl9iaXQoSENJX1VBUlRfVFhfV0FLRVVQLCAmaHUtPnR4X3N0YXRlKTsN
CiANCkBAIC0xNTUsNyArMTY3LDYgQEAgcmVzdGFydDoNCiAJCWdvdG8gcmVzdGFydDsNCiANCiAJ
Y2xlYXJfYml0KEhDSV9VQVJUX1NFTkRJTkcsICZodS0+dHhfc3RhdGUpOw0KLQlyZXR1cm4gMDsN
CiB9DQogDQogLyogLS0tLS0tLSBJbnRlcmZhY2UgdG8gSENJIGxheWVyIC0tLS0tLSAqLw0KQEAg
LTI3NCw2ICsyODUsOCBAQCBzdGF0aWMgaW50IGhjaV91YXJ0X3R0eV9vcGVuKHN0cnVjdCB0dHlf
c3RydWN0ICp0dHkpDQogCWh1LT50dHkgPSB0dHk7DQogCXR0eS0+cmVjZWl2ZV9yb29tID0gNjU1
MzY7DQogDQorCUlOSVRfV09SSygmaHUtPndyaXRlX3dvcmssIGhjaV91YXJ0X3dyaXRlX3dvcmsp
Ow0KKw0KIAlzcGluX2xvY2tfaW5pdCgmaHUtPnJ4X2xvY2spOw0KIA0KIAkvKiBGbHVzaCBhbnkg
cGVuZGluZyBjaGFyYWN0ZXJzIGluIHRoZSBkcml2ZXIgYW5kIGxpbmUgZGlzY2lwbGluZS4gKi8N
CkBAIC0zMDgsNiArMzIxLDggQEAgc3RhdGljIHZvaWQgaGNpX3VhcnRfdHR5X2Nsb3NlKHN0cnVj
dCB0dHlfc3RydWN0ICp0dHkpDQogCQlpZiAoaGRldikNCiAJCQloY2lfdWFydF9jbG9zZShoZGV2
KTsNCiANCisJCWNhbmNlbF93b3JrX3N5bmMoJmh1LT53cml0ZV93b3JrKTsNCisNCiAJCWlmICh0
ZXN0X2FuZF9jbGVhcl9iaXQoSENJX1VBUlRfUFJPVE9fU0VULCAmaHUtPmZsYWdzKSkgew0KIAkJ
CWlmIChoZGV2KSB7DQogCQkJCWhjaV91bnJlZ2lzdGVyX2RldihoZGV2KTsNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL2JsdWV0b290aC9oY2lfdWFydC5oIGIvZHJpdmVycy9ibHVldG9vdGgvaGNpX3Vh
cnQuaA0KaW5kZXggOTlmYjM1Mi4uZmY0MDQwMCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvYmx1ZXRv
b3RoL2hjaV91YXJ0LmgNCisrKyBiL2RyaXZlcnMvYmx1ZXRvb3RoL2hjaV91YXJ0LmgNCkBAIC02
NCw2ICs2NCw4IEBAIHN0cnVjdCBoY2lfdWFydCB7DQogCXVuc2lnbmVkIGxvbmcJCWZsYWdzOw0K
IAl1bnNpZ25lZCBsb25nCQloZGV2X2ZsYWdzOw0KIA0KKwlzdHJ1Y3Qgd29ya19zdHJ1Y3QJd3Jp
dGVfd29yazsNCisNCiAJc3RydWN0IGhjaV91YXJ0X3Byb3RvCSpwcm90bzsNCiAJdm9pZAkJCSpw
cml2Ow0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9kcm1fZHJ2LmMgYi9kcml2ZXJz
L2dwdS9kcm0vZHJtX2Rydi5jDQppbmRleCBhY2ZlNTY3Li4wNzMxZDQzIDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9ncHUvZHJtL2RybV9kcnYuYw0KKysrIGIvZHJpdmVycy9ncHUvZHJtL2RybV9kcnYu
Yw0KQEAgLTQ1Niw4ICs0NTYsOSBAQCBsb25nIGRybV9pb2N0bChzdHJ1Y3QgZmlsZSAqZmlscCwN
CiAJCQkJcmV0Y29kZSA9IC1FRkFVTFQ7DQogCQkJCWdvdG8gZXJyX2kxOw0KIAkJCX0NCi0JCX0g
ZWxzZQ0KKwkJfSBlbHNlIGlmIChjbWQgJiBJT0NfT1VUKSB7DQogCQkJbWVtc2V0KGtkYXRhLCAw
LCB1c2l6ZSk7DQorCQl9DQogDQogCQlpZiAoaW9jdGwtPmZsYWdzICYgRFJNX1VOTE9DS0VEKQ0K
IAkJCXJldGNvZGUgPSBmdW5jKGRldiwga2RhdGEsIGZpbGVfcHJpdik7DQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9nZW1fZXhlY2J1ZmZlci5jIGIvZHJpdmVycy9ncHUv
ZHJtL2k5MTUvaTkxNV9nZW1fZXhlY2J1ZmZlci5jDQppbmRleCBiMWJiNzM0Li5hMGI2OWFlIDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9nZW1fZXhlY2J1ZmZlci5jDQor
KysgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X2dlbV9leGVjYnVmZmVyLmMNCkBAIC0yODcs
MTQgKzI4NywxNCBAQCBpOTE1X2dlbV9leGVjYnVmZmVyX3JlbG9jYXRlX2VudHJ5KHN0cnVjdCBk
cm1faTkxNV9nZW1fb2JqZWN0ICpvYmosDQogCSAqIGV4ZWNfb2JqZWN0IGxpc3QsIHNvIGl0IHNo
b3VsZCBoYXZlIGEgR1RUIHNwYWNlIGJvdW5kIGJ5IG5vdy4NCiAJICovDQogCWlmICh1bmxpa2Vs
eSh0YXJnZXRfb2Zmc2V0ID09IDApKSB7DQotCQlEUk1fRVJST1IoIk5vIEdUVCBzcGFjZSBmb3Vu
ZCBmb3Igb2JqZWN0ICVkXG4iLA0KKwkJRFJNX0RFQlVHKCJObyBHVFQgc3BhY2UgZm91bmQgZm9y
IG9iamVjdCAlZFxuIiwNCiAJCQkgIHJlbG9jLT50YXJnZXRfaGFuZGxlKTsNCiAJCXJldHVybiBy
ZXQ7DQogCX0NCiANCiAJLyogVmFsaWRhdGUgdGhhdCB0aGUgdGFyZ2V0IGlzIGluIGEgdmFsaWQg
ci93IEdQVSBkb21haW4gKi8NCiAJaWYgKHVubGlrZWx5KHJlbG9jLT53cml0ZV9kb21haW4gJiAo
cmVsb2MtPndyaXRlX2RvbWFpbiAtIDEpKSkgew0KLQkJRFJNX0VSUk9SKCJyZWxvYyB3aXRoIG11
bHRpcGxlIHdyaXRlIGRvbWFpbnM6ICINCisJCURSTV9ERUJVRygicmVsb2Mgd2l0aCBtdWx0aXBs
ZSB3cml0ZSBkb21haW5zOiAiDQogCQkJICAib2JqICVwIHRhcmdldCAlZCBvZmZzZXQgJWQgIg0K
IAkJCSAgInJlYWQgJTA4eCB3cml0ZSAlMDh4IiwNCiAJCQkgIG9iaiwgcmVsb2MtPnRhcmdldF9o
YW5kbGUsDQpAQCAtMzA0LDcgKzMwNCw3IEBAIGk5MTVfZ2VtX2V4ZWNidWZmZXJfcmVsb2NhdGVf
ZW50cnkoc3RydWN0IGRybV9pOTE1X2dlbV9vYmplY3QgKm9iaiwNCiAJCXJldHVybiByZXQ7DQog
CX0NCiAJaWYgKHVubGlrZWx5KChyZWxvYy0+d3JpdGVfZG9tYWluIHwgcmVsb2MtPnJlYWRfZG9t
YWlucykgJiBJOTE1X0dFTV9ET01BSU5fQ1BVKSkgew0KLQkJRFJNX0VSUk9SKCJyZWxvYyB3aXRo
IHJlYWQvd3JpdGUgQ1BVIGRvbWFpbnM6ICINCisJCURSTV9ERUJVRygicmVsb2Mgd2l0aCByZWFk
L3dyaXRlIENQVSBkb21haW5zOiAiDQogCQkJICAib2JqICVwIHRhcmdldCAlZCBvZmZzZXQgJWQg
Ig0KIAkJCSAgInJlYWQgJTA4eCB3cml0ZSAlMDh4IiwNCiAJCQkgIG9iaiwgcmVsb2MtPnRhcmdl
dF9oYW5kbGUsDQpAQCAtMzE1LDcgKzMxNSw3IEBAIGk5MTVfZ2VtX2V4ZWNidWZmZXJfcmVsb2Nh
dGVfZW50cnkoc3RydWN0IGRybV9pOTE1X2dlbV9vYmplY3QgKm9iaiwNCiAJfQ0KIAlpZiAodW5s
aWtlbHkocmVsb2MtPndyaXRlX2RvbWFpbiAmJiB0YXJnZXRfb2JqLT5wZW5kaW5nX3dyaXRlX2Rv
bWFpbiAmJg0KIAkJICAgICByZWxvYy0+d3JpdGVfZG9tYWluICE9IHRhcmdldF9vYmotPnBlbmRp
bmdfd3JpdGVfZG9tYWluKSkgew0KLQkJRFJNX0VSUk9SKCJXcml0ZSBkb21haW4gY29uZmxpY3Q6
ICINCisJCURSTV9ERUJVRygiV3JpdGUgZG9tYWluIGNvbmZsaWN0OiAiDQogCQkJICAib2JqICVw
IHRhcmdldCAlZCBvZmZzZXQgJWQgIg0KIAkJCSAgIm5ldyAlMDh4IG9sZCAlMDh4XG4iLA0KIAkJ
CSAgb2JqLCByZWxvYy0+dGFyZ2V0X2hhbmRsZSwNCkBAIC0zMzYsNyArMzM2LDcgQEAgaTkxNV9n
ZW1fZXhlY2J1ZmZlcl9yZWxvY2F0ZV9lbnRyeShzdHJ1Y3QgZHJtX2k5MTVfZ2VtX29iamVjdCAq
b2JqLA0KIA0KIAkvKiBDaGVjayB0aGF0IHRoZSByZWxvY2F0aW9uIGFkZHJlc3MgaXMgdmFsaWQu
Li4gKi8NCiAJaWYgKHVubGlrZWx5KHJlbG9jLT5vZmZzZXQgPiBvYmotPmJhc2Uuc2l6ZSAtIDQp
KSB7DQotCQlEUk1fRVJST1IoIlJlbG9jYXRpb24gYmV5b25kIG9iamVjdCBib3VuZHM6ICINCisJ
CURSTV9ERUJVRygiUmVsb2NhdGlvbiBiZXlvbmQgb2JqZWN0IGJvdW5kczogIg0KIAkJCSAgIm9i
aiAlcCB0YXJnZXQgJWQgb2Zmc2V0ICVkIHNpemUgJWQuXG4iLA0KIAkJCSAgb2JqLCByZWxvYy0+
dGFyZ2V0X2hhbmRsZSwNCiAJCQkgIChpbnQpIHJlbG9jLT5vZmZzZXQsDQpAQCAtMzQ0LDcgKzM0
NCw3IEBAIGk5MTVfZ2VtX2V4ZWNidWZmZXJfcmVsb2NhdGVfZW50cnkoc3RydWN0IGRybV9pOTE1
X2dlbV9vYmplY3QgKm9iaiwNCiAJCXJldHVybiByZXQ7DQogCX0NCiAJaWYgKHVubGlrZWx5KHJl
bG9jLT5vZmZzZXQgJiAzKSkgew0KLQkJRFJNX0VSUk9SKCJSZWxvY2F0aW9uIG5vdCA0LWJ5dGUg
YWxpZ25lZDogIg0KKwkJRFJNX0RFQlVHKCJSZWxvY2F0aW9uIG5vdCA0LWJ5dGUgYWxpZ25lZDog
Ig0KIAkJCSAgIm9iaiAlcCB0YXJnZXQgJWQgb2Zmc2V0ICVkLlxuIiwNCiAJCQkgIG9iaiwgcmVs
b2MtPnRhcmdldF9oYW5kbGUsDQogCQkJICAoaW50KSByZWxvYy0+b2Zmc2V0KTsNCkBAIC02Nzks
OSArNjc5LDkgQEAgaTkxNV9nZW1fZXhlY2J1ZmZlcl9yZWxvY2F0ZV9zbG93KHN0cnVjdCBkcm1f
ZGV2aWNlICpkZXYsDQogCQkgKiByZWxvY2F0aW9ucyB3ZXJlIHZhbGlkLg0KIAkJICovDQogCQlm
b3IgKGogPSAwOyBqIDwgZXhlY1tpXS5yZWxvY2F0aW9uX2NvdW50OyBqKyspIHsNCi0JCQlpZiAo
Y29weV90b191c2VyKCZ1c2VyX3JlbG9jc1tqXS5wcmVzdW1lZF9vZmZzZXQsDQotCQkJCQkgJmlu
dmFsaWRfb2Zmc2V0LA0KLQkJCQkJIHNpemVvZihpbnZhbGlkX29mZnNldCkpKSB7DQorCQkJaWYg
KF9fY29weV90b191c2VyKCZ1c2VyX3JlbG9jc1tqXS5wcmVzdW1lZF9vZmZzZXQsDQorCQkJCQkg
ICAmaW52YWxpZF9vZmZzZXQsDQorCQkJCQkgICBzaXplb2YoaW52YWxpZF9vZmZzZXQpKSkgew0K
IAkJCQlyZXQgPSAtRUZBVUxUOw0KIAkJCQltdXRleF9sb2NrKCZkZXYtPnN0cnVjdF9tdXRleCk7
DQogCQkJCWdvdG8gZXJyOw0KQEAgLTcwNCw3ICs3MDQsNyBAQCBpOTE1X2dlbV9leGVjYnVmZmVy
X3JlbG9jYXRlX3Nsb3coc3RydWN0IGRybV9kZXZpY2UgKmRldiwNCiAJCW9iaiA9IHRvX2ludGVs
X2JvKGRybV9nZW1fb2JqZWN0X2xvb2t1cChkZXYsIGZpbGUsDQogCQkJCQkJCWV4ZWNbaV0uaGFu
ZGxlKSk7DQogCQlpZiAoJm9iai0+YmFzZSA9PSBOVUxMKSB7DQotCQkJRFJNX0VSUk9SKCJJbnZh
bGlkIG9iamVjdCBoYW5kbGUgJWQgYXQgaW5kZXggJWRcbiIsDQorCQkJRFJNX0RFQlVHKCJJbnZh
bGlkIG9iamVjdCBoYW5kbGUgJWQgYXQgaW5kZXggJWRcbiIsDQogCQkJCSAgIGV4ZWNbaV0uaGFu
ZGxlLCBpKTsNCiAJCQlyZXQgPSAtRU5PRU5UOw0KIAkJCWdvdG8gZXJyOw0KQEAgLTEwMTUsNyAr
MTAxNSw3IEBAIGk5MTVfZ2VtX2RvX2V4ZWNidWZmZXIoc3RydWN0IGRybV9kZXZpY2UgKmRldiwg
dm9pZCAqZGF0YSwNCiAJaW50IHJldCwgbW9kZSwgaTsNCiANCiAJaWYgKCFpOTE1X2dlbV9jaGVj
a19leGVjYnVmZmVyKGFyZ3MpKSB7DQotCQlEUk1fRVJST1IoImV4ZWNidWYgd2l0aCBpbnZhbGlk
IG9mZnNldC9sZW5ndGhcbiIpOw0KKwkJRFJNX0RFQlVHKCJleGVjYnVmIHdpdGggaW52YWxpZCBv
ZmZzZXQvbGVuZ3RoXG4iKTsNCiAJCXJldHVybiAtRUlOVkFMOw0KIAl9DQogDQpAQCAtMTAzMCwy
MCArMTAzMCwyMCBAQCBpOTE1X2dlbV9kb19leGVjYnVmZmVyKHN0cnVjdCBkcm1fZGV2aWNlICpk
ZXYsIHZvaWQgKmRhdGEsDQogCQlicmVhazsNCiAJY2FzZSBJOTE1X0VYRUNfQlNEOg0KIAkJaWYg
KCFIQVNfQlNEKGRldikpIHsNCi0JCQlEUk1fRVJST1IoImV4ZWNidWYgd2l0aCBpbnZhbGlkIHJp
bmcgKEJTRClcbiIpOw0KKwkJCURSTV9ERUJVRygiZXhlY2J1ZiB3aXRoIGludmFsaWQgcmluZyAo
QlNEKVxuIik7DQogCQkJcmV0dXJuIC1FSU5WQUw7DQogCQl9DQogCQlyaW5nID0gJmRldl9wcml2
LT5yaW5nW1ZDU107DQogCQlicmVhazsNCiAJY2FzZSBJOTE1X0VYRUNfQkxUOg0KIAkJaWYgKCFI
QVNfQkxUKGRldikpIHsNCi0JCQlEUk1fRVJST1IoImV4ZWNidWYgd2l0aCBpbnZhbGlkIHJpbmcg
KEJMVClcbiIpOw0KKwkJCURSTV9ERUJVRygiZXhlY2J1ZiB3aXRoIGludmFsaWQgcmluZyAoQkxU
KVxuIik7DQogCQkJcmV0dXJuIC1FSU5WQUw7DQogCQl9DQogCQlyaW5nID0gJmRldl9wcml2LT5y
aW5nW0JDU107DQogCQlicmVhazsNCiAJZGVmYXVsdDoNCi0JCURSTV9FUlJPUigiZXhlY2J1ZiB3
aXRoIHVua25vd24gcmluZzogJWRcbiIsDQorCQlEUk1fREVCVUcoImV4ZWNidWYgd2l0aCB1bmtu
b3duIHJpbmc6ICVkXG4iLA0KIAkJCSAgKGludCkoYXJncy0+ZmxhZ3MgJiBJOTE1X0VYRUNfUklO
R19NQVNLKSk7DQogCQlyZXR1cm4gLUVJTlZBTDsNCiAJfQ0KQEAgLTEwNjksMTggKzEwNjksMTgg
QEAgaTkxNV9nZW1fZG9fZXhlY2J1ZmZlcihzdHJ1Y3QgZHJtX2RldmljZSAqZGV2LCB2b2lkICpk
YXRhLA0KIAkJfQ0KIAkJYnJlYWs7DQogCWRlZmF1bHQ6DQotCQlEUk1fRVJST1IoImV4ZWNidWYg
d2l0aCB1bmtub3duIGNvbnN0YW50czogJWRcbiIsIG1vZGUpOw0KKwkJRFJNX0RFQlVHKCJleGVj
YnVmIHdpdGggdW5rbm93biBjb25zdGFudHM6ICVkXG4iLCBtb2RlKTsNCiAJCXJldHVybiAtRUlO
VkFMOw0KIAl9DQogDQogCWlmIChhcmdzLT5idWZmZXJfY291bnQgPCAxKSB7DQotCQlEUk1fRVJS
T1IoImV4ZWNidWYgd2l0aCAlZCBidWZmZXJzXG4iLCBhcmdzLT5idWZmZXJfY291bnQpOw0KKwkJ
RFJNX0RFQlVHKCJleGVjYnVmIHdpdGggJWQgYnVmZmVyc1xuIiwgYXJncy0+YnVmZmVyX2NvdW50
KTsNCiAJCXJldHVybiAtRUlOVkFMOw0KIAl9DQogDQogCWlmIChhcmdzLT5udW1fY2xpcHJlY3Rz
ICE9IDApIHsNCiAJCWlmIChyaW5nICE9ICZkZXZfcHJpdi0+cmluZ1tSQ1NdKSB7DQotCQkJRFJN
X0VSUk9SKCJjbGlwIHJlY3RhbmdsZXMgYXJlIG9ubHkgdmFsaWQgd2l0aCB0aGUgcmVuZGVyIHJp
bmdcbiIpOw0KKwkJCURSTV9ERUJVRygiY2xpcCByZWN0YW5nbGVzIGFyZSBvbmx5IHZhbGlkIHdp
dGggdGhlIHJlbmRlciByaW5nXG4iKTsNCiAJCQlyZXR1cm4gLUVJTlZBTDsNCiAJCX0NCiANCkBA
IC0xMTMwLDcgKzExMzAsNyBAQCBpOTE1X2dlbV9kb19leGVjYnVmZmVyKHN0cnVjdCBkcm1fZGV2
aWNlICpkZXYsIHZvaWQgKmRhdGEsDQogCQlvYmogPSB0b19pbnRlbF9ibyhkcm1fZ2VtX29iamVj
dF9sb29rdXAoZGV2LCBmaWxlLA0KIAkJCQkJCQlleGVjW2ldLmhhbmRsZSkpOw0KIAkJaWYgKCZv
YmotPmJhc2UgPT0gTlVMTCkgew0KLQkJCURSTV9FUlJPUigiSW52YWxpZCBvYmplY3QgaGFuZGxl
ICVkIGF0IGluZGV4ICVkXG4iLA0KKwkJCURSTV9ERUJVRygiSW52YWxpZCBvYmplY3QgaGFuZGxl
ICVkIGF0IGluZGV4ICVkXG4iLA0KIAkJCQkgICBleGVjW2ldLmhhbmRsZSwgaSk7DQogCQkJLyog
cHJldmVudCBlcnJvciBwYXRoIGZyb20gcmVhZGluZyB1bmluaXRpYWxpemVkIGRhdGEgKi8NCiAJ
CQlyZXQgPSAtRU5PRU5UOw0KQEAgLTExMzgsNyArMTEzOCw3IEBAIGk5MTVfZ2VtX2RvX2V4ZWNi
dWZmZXIoc3RydWN0IGRybV9kZXZpY2UgKmRldiwgdm9pZCAqZGF0YSwNCiAJCX0NCiANCiAJCWlm
ICghbGlzdF9lbXB0eSgmb2JqLT5leGVjX2xpc3QpKSB7DQotCQkJRFJNX0VSUk9SKCJPYmplY3Qg
JXAgW2hhbmRsZSAlZCwgaW5kZXggJWRdIGFwcGVhcnMgbW9yZSB0aGFuIG9uY2UgaW4gb2JqZWN0
IGxpc3RcbiIsDQorCQkJRFJNX0RFQlVHKCJPYmplY3QgJXAgW2hhbmRsZSAlZCwgaW5kZXggJWRd
IGFwcGVhcnMgbW9yZSB0aGFuIG9uY2UgaW4gb2JqZWN0IGxpc3RcbiIsDQogCQkJCSAgIG9iaiwg
ZXhlY1tpXS5oYW5kbGUsIGkpOw0KIAkJCXJldCA9IC1FSU5WQUw7DQogCQkJZ290byBlcnI7DQpA
QCAtMTE3Niw3ICsxMTc2LDcgQEAgaTkxNV9nZW1fZG9fZXhlY2J1ZmZlcihzdHJ1Y3QgZHJtX2Rl
dmljZSAqZGV2LCB2b2lkICpkYXRhLA0KIA0KIAkvKiBTZXQgdGhlIHBlbmRpbmcgcmVhZCBkb21h
aW5zIGZvciB0aGUgYmF0Y2ggYnVmZmVyIHRvIENPTU1BTkQgKi8NCiAJaWYgKGJhdGNoX29iai0+
YmFzZS5wZW5kaW5nX3dyaXRlX2RvbWFpbikgew0KLQkJRFJNX0VSUk9SKCJBdHRlbXB0aW5nIHRv
IHVzZSBzZWxmLW1vZGlmeWluZyBiYXRjaCBidWZmZXJcbiIpOw0KKwkJRFJNX0RFQlVHKCJBdHRl
bXB0aW5nIHRvIHVzZSBzZWxmLW1vZGlmeWluZyBiYXRjaCBidWZmZXJcbiIpOw0KIAkJcmV0ID0g
LUVJTlZBTDsNCiAJCWdvdG8gZXJyOw0KIAl9DQpAQCAtMTI3NSw3ICsxMjc1LDcgQEAgaTkxNV9n
ZW1fZXhlY2J1ZmZlcihzdHJ1Y3QgZHJtX2RldmljZSAqZGV2LCB2b2lkICpkYXRhLA0KIAlpbnQg
cmV0LCBpOw0KIA0KIAlpZiAoYXJncy0+YnVmZmVyX2NvdW50IDwgMSkgew0KLQkJRFJNX0VSUk9S
KCJleGVjYnVmIHdpdGggJWQgYnVmZmVyc1xuIiwgYXJncy0+YnVmZmVyX2NvdW50KTsNCisJCURS
TV9ERUJVRygiZXhlY2J1ZiB3aXRoICVkIGJ1ZmZlcnNcbiIsIGFyZ3MtPmJ1ZmZlcl9jb3VudCk7
DQogCQlyZXR1cm4gLUVJTlZBTDsNCiAJfQ0KIA0KQEAgLTEyODMsNyArMTI4Myw3IEBAIGk5MTVf
Z2VtX2V4ZWNidWZmZXIoc3RydWN0IGRybV9kZXZpY2UgKmRldiwgdm9pZCAqZGF0YSwNCiAJZXhl
Y19saXN0ID0gZHJtX21hbGxvY19hYihzaXplb2YoKmV4ZWNfbGlzdCksIGFyZ3MtPmJ1ZmZlcl9j
b3VudCk7DQogCWV4ZWMyX2xpc3QgPSBkcm1fbWFsbG9jX2FiKHNpemVvZigqZXhlYzJfbGlzdCks
IGFyZ3MtPmJ1ZmZlcl9jb3VudCk7DQogCWlmIChleGVjX2xpc3QgPT0gTlVMTCB8fCBleGVjMl9s
aXN0ID09IE5VTEwpIHsNCi0JCURSTV9FUlJPUigiRmFpbGVkIHRvIGFsbG9jYXRlIGV4ZWMgbGlz
dCBmb3IgJWQgYnVmZmVyc1xuIiwNCisJCURSTV9ERUJVRygiRmFpbGVkIHRvIGFsbG9jYXRlIGV4
ZWMgbGlzdCBmb3IgJWQgYnVmZmVyc1xuIiwNCiAJCQkgIGFyZ3MtPmJ1ZmZlcl9jb3VudCk7DQog
CQlkcm1fZnJlZV9sYXJnZShleGVjX2xpc3QpOw0KIAkJZHJtX2ZyZWVfbGFyZ2UoZXhlYzJfbGlz
dCk7DQpAQCAtMTI5NCw3ICsxMjk0LDcgQEAgaTkxNV9nZW1fZXhlY2J1ZmZlcihzdHJ1Y3QgZHJt
X2RldmljZSAqZGV2LCB2b2lkICpkYXRhLA0KIAkJCSAgICAgKHVpbnRwdHJfdCkgYXJncy0+YnVm
ZmVyc19wdHIsDQogCQkJICAgICBzaXplb2YoKmV4ZWNfbGlzdCkgKiBhcmdzLT5idWZmZXJfY291
bnQpOw0KIAlpZiAocmV0ICE9IDApIHsNCi0JCURSTV9FUlJPUigiY29weSAlZCBleGVjIGVudHJp
ZXMgZmFpbGVkICVkXG4iLA0KKwkJRFJNX0RFQlVHKCJjb3B5ICVkIGV4ZWMgZW50cmllcyBmYWls
ZWQgJWRcbiIsDQogCQkJICBhcmdzLT5idWZmZXJfY291bnQsIHJldCk7DQogCQlkcm1fZnJlZV9s
YXJnZShleGVjX2xpc3QpOw0KIAkJZHJtX2ZyZWVfbGFyZ2UoZXhlYzJfbGlzdCk7DQpAQCAtMTMy
NSwxOSArMTMyNSwyMSBAQCBpOTE1X2dlbV9leGVjYnVmZmVyKHN0cnVjdCBkcm1fZGV2aWNlICpk
ZXYsIHZvaWQgKmRhdGEsDQogDQogCXJldCA9IGk5MTVfZ2VtX2RvX2V4ZWNidWZmZXIoZGV2LCBk
YXRhLCBmaWxlLCAmZXhlYzIsIGV4ZWMyX2xpc3QpOw0KIAlpZiAoIXJldCkgew0KKwkJc3RydWN0
IGRybV9pOTE1X2dlbV9leGVjX29iamVjdCBfX3VzZXIgKnVzZXJfZXhlY19saXN0ID0NCisJCQko
dm9pZCBfX3VzZXIgKikodWludHB0cl90KWFyZ3MtPmJ1ZmZlcnNfcHRyOw0KKw0KIAkJLyogQ29w
eSB0aGUgbmV3IGJ1ZmZlciBvZmZzZXRzIGJhY2sgdG8gdGhlIHVzZXIncyBleGVjIGxpc3QuICov
DQotCQlmb3IgKGkgPSAwOyBpIDwgYXJncy0+YnVmZmVyX2NvdW50OyBpKyspDQotCQkJZXhlY19s
aXN0W2ldLm9mZnNldCA9IGV4ZWMyX2xpc3RbaV0ub2Zmc2V0Ow0KLQkJLyogLi4uIGFuZCBiYWNr
IG91dCB0byB1c2Vyc3BhY2UgKi8NCi0JCXJldCA9IGNvcHlfdG9fdXNlcigoc3RydWN0IGRybV9p
OTE1X3JlbG9jYXRpb25fZW50cnkgX191c2VyICopDQotCQkJCSAgICh1aW50cHRyX3QpIGFyZ3Mt
PmJ1ZmZlcnNfcHRyLA0KLQkJCQkgICBleGVjX2xpc3QsDQotCQkJCSAgIHNpemVvZigqZXhlY19s
aXN0KSAqIGFyZ3MtPmJ1ZmZlcl9jb3VudCk7DQotCQlpZiAocmV0KSB7DQotCQkJcmV0ID0gLUVG
QVVMVDsNCi0JCQlEUk1fRVJST1IoImZhaWxlZCB0byBjb3B5ICVkIGV4ZWMgZW50cmllcyAiDQot
CQkJCSAgImJhY2sgdG8gdXNlciAoJWQpXG4iLA0KLQkJCQkgIGFyZ3MtPmJ1ZmZlcl9jb3VudCwg
cmV0KTsNCisJCWZvciAoaSA9IDA7IGkgPCBhcmdzLT5idWZmZXJfY291bnQ7IGkrKykgew0KKwkJ
CXJldCA9IF9fY29weV90b191c2VyKCZ1c2VyX2V4ZWNfbGlzdFtpXS5vZmZzZXQsDQorCQkJCQkg
ICAgICZleGVjMl9saXN0W2ldLm9mZnNldCwNCisJCQkJCSAgICAgc2l6ZW9mKHVzZXJfZXhlY19s
aXN0W2ldLm9mZnNldCkpOw0KKwkJCWlmIChyZXQpIHsNCisJCQkJcmV0ID0gLUVGQVVMVDsNCisJ
CQkJRFJNX0RFQlVHKCJmYWlsZWQgdG8gY29weSAlZCBleGVjIGVudHJpZXMgIg0KKwkJCQkJICAi
YmFjayB0byB1c2VyICglZClcbiIsDQorCQkJCQkgIGFyZ3MtPmJ1ZmZlcl9jb3VudCwgcmV0KTsN
CisJCQkJYnJlYWs7DQorCQkJfQ0KIAkJfQ0KIAl9DQogDQpAQCAtMTM1Niw3ICsxMzU4LDcgQEAg
aTkxNV9nZW1fZXhlY2J1ZmZlcjIoc3RydWN0IGRybV9kZXZpY2UgKmRldiwgdm9pZCAqZGF0YSwN
CiANCiAJaWYgKGFyZ3MtPmJ1ZmZlcl9jb3VudCA8IDEgfHwNCiAJICAgIGFyZ3MtPmJ1ZmZlcl9j
b3VudCA+IFVJTlRfTUFYIC8gc2l6ZW9mKCpleGVjMl9saXN0KSkgew0KLQkJRFJNX0VSUk9SKCJl
eGVjYnVmMiB3aXRoICVkIGJ1ZmZlcnNcbiIsIGFyZ3MtPmJ1ZmZlcl9jb3VudCk7DQorCQlEUk1f
REVCVUcoImV4ZWNidWYyIHdpdGggJWQgYnVmZmVyc1xuIiwgYXJncy0+YnVmZmVyX2NvdW50KTsN
CiAJCXJldHVybiAtRUlOVkFMOw0KIAl9DQogDQpAQCAtMTM2Niw3ICsxMzY4LDcgQEAgaTkxNV9n
ZW1fZXhlY2J1ZmZlcjIoc3RydWN0IGRybV9kZXZpY2UgKmRldiwgdm9pZCAqZGF0YSwNCiAJCWV4
ZWMyX2xpc3QgPSBkcm1fbWFsbG9jX2FiKHNpemVvZigqZXhlYzJfbGlzdCksDQogCQkJCQkgICBh
cmdzLT5idWZmZXJfY291bnQpOw0KIAlpZiAoZXhlYzJfbGlzdCA9PSBOVUxMKSB7DQotCQlEUk1f
RVJST1IoIkZhaWxlZCB0byBhbGxvY2F0ZSBleGVjIGxpc3QgZm9yICVkIGJ1ZmZlcnNcbiIsDQor
CQlEUk1fREVCVUcoIkZhaWxlZCB0byBhbGxvY2F0ZSBleGVjIGxpc3QgZm9yICVkIGJ1ZmZlcnNc
biIsDQogCQkJICBhcmdzLT5idWZmZXJfY291bnQpOw0KIAkJcmV0dXJuIC1FTk9NRU07DQogCX0N
CkBAIC0xMzc1LDcgKzEzNzcsNyBAQCBpOTE1X2dlbV9leGVjYnVmZmVyMihzdHJ1Y3QgZHJtX2Rl
dmljZSAqZGV2LCB2b2lkICpkYXRhLA0KIAkJCSAgICAgKHVpbnRwdHJfdCkgYXJncy0+YnVmZmVy
c19wdHIsDQogCQkJICAgICBzaXplb2YoKmV4ZWMyX2xpc3QpICogYXJncy0+YnVmZmVyX2NvdW50
KTsNCiAJaWYgKHJldCAhPSAwKSB7DQotCQlEUk1fRVJST1IoImNvcHkgJWQgZXhlYyBlbnRyaWVz
IGZhaWxlZCAlZFxuIiwNCisJCURSTV9ERUJVRygiY29weSAlZCBleGVjIGVudHJpZXMgZmFpbGVk
ICVkXG4iLA0KIAkJCSAgYXJncy0+YnVmZmVyX2NvdW50LCByZXQpOw0KIAkJZHJtX2ZyZWVfbGFy
Z2UoZXhlYzJfbGlzdCk7DQogCQlyZXR1cm4gLUVGQVVMVDsNCkBAIC0xMzg0LDE1ICsxMzg2LDIx
IEBAIGk5MTVfZ2VtX2V4ZWNidWZmZXIyKHN0cnVjdCBkcm1fZGV2aWNlICpkZXYsIHZvaWQgKmRh
dGEsDQogCXJldCA9IGk5MTVfZ2VtX2RvX2V4ZWNidWZmZXIoZGV2LCBkYXRhLCBmaWxlLCBhcmdz
LCBleGVjMl9saXN0KTsNCiAJaWYgKCFyZXQpIHsNCiAJCS8qIENvcHkgdGhlIG5ldyBidWZmZXIg
b2Zmc2V0cyBiYWNrIHRvIHRoZSB1c2VyJ3MgZXhlYyBsaXN0LiAqLw0KLQkJcmV0ID0gY29weV90
b191c2VyKChzdHJ1Y3QgZHJtX2k5MTVfcmVsb2NhdGlvbl9lbnRyeSBfX3VzZXIgKikNCi0JCQkJ
ICAgKHVpbnRwdHJfdCkgYXJncy0+YnVmZmVyc19wdHIsDQotCQkJCSAgIGV4ZWMyX2xpc3QsDQot
CQkJCSAgIHNpemVvZigqZXhlYzJfbGlzdCkgKiBhcmdzLT5idWZmZXJfY291bnQpOw0KLQkJaWYg
KHJldCkgew0KLQkJCXJldCA9IC1FRkFVTFQ7DQotCQkJRFJNX0VSUk9SKCJmYWlsZWQgdG8gY29w
eSAlZCBleGVjIGVudHJpZXMgIg0KLQkJCQkgICJiYWNrIHRvIHVzZXIgKCVkKVxuIiwNCi0JCQkJ
ICBhcmdzLT5idWZmZXJfY291bnQsIHJldCk7DQorCQlzdHJ1Y3QgZHJtX2k5MTVfZ2VtX2V4ZWNf
b2JqZWN0MiBfX3VzZXIgKnVzZXJfZXhlY19saXN0ID0NCisJCQkodm9pZCBfX3VzZXIgKikodWlu
dHB0cl90KWFyZ3MtPmJ1ZmZlcnNfcHRyOw0KKwkJaW50IGk7DQorDQorCQlmb3IgKGkgPSAwOyBp
IDwgYXJncy0+YnVmZmVyX2NvdW50OyBpKyspIHsNCisJCQlyZXQgPSBfX2NvcHlfdG9fdXNlcigm
dXNlcl9leGVjX2xpc3RbaV0ub2Zmc2V0LA0KKwkJCQkJICAgICAmZXhlYzJfbGlzdFtpXS5vZmZz
ZXQsDQorCQkJCQkgICAgIHNpemVvZih1c2VyX2V4ZWNfbGlzdFtpXS5vZmZzZXQpKTsNCisJCQlp
ZiAocmV0KSB7DQorCQkJCXJldCA9IC1FRkFVTFQ7DQorCQkJCURSTV9ERUJVRygiZmFpbGVkIHRv
IGNvcHkgJWQgZXhlYyBlbnRyaWVzICINCisJCQkJCSAgImJhY2sgdG8gdXNlclxuIiwNCisJCQkJ
CSAgYXJncy0+YnVmZmVyX2NvdW50KTsNCisJCQkJYnJlYWs7DQorCQkJfQ0KIAkJfQ0KIAl9DQog
DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19jcnRjLmMgYi9k
cml2ZXJzL2dwdS9kcm0vcmFkZW9uL2F0b21iaW9zX2NydGMuYw0KaW5kZXggY2Q5OGMwNi4uOTI3
ZDE3MCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfY3J0Yy5j
DQorKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2F0b21iaW9zX2NydGMuYw0KQEAgLTgzMCwx
NCArODMwLDE2IEBAIHN0YXRpYyB2b2lkIGF0b21iaW9zX2NydGNfcHJvZ3JhbV9wbGwoc3RydWN0
IGRybV9jcnRjICpjcnRjLA0KIAkJCWFyZ3MudjUudWNNaXNjSW5mbyA9IDA7IC8qIEhETUkgZGVw
dGgsIGV0Yy4gKi8NCiAJCQlpZiAoc3NfZW5hYmxlZCAmJiAoc3MtPnR5cGUgJiBBVE9NX0VYVEVS
TkFMX1NTX01BU0spKQ0KIAkJCQlhcmdzLnY1LnVjTWlzY0luZm8gfD0gUElYRUxfQ0xPQ0tfVjVf
TUlTQ19SRUZfRElWX1NSQzsNCi0JCQlzd2l0Y2ggKGJwYykgew0KLQkJCWNhc2UgODoNCi0JCQlk
ZWZhdWx0Og0KLQkJCQlhcmdzLnY1LnVjTWlzY0luZm8gfD0gUElYRUxfQ0xPQ0tfVjVfTUlTQ19I
RE1JXzI0QlBQOw0KLQkJCQlicmVhazsNCi0JCQljYXNlIDEwOg0KLQkJCQlhcmdzLnY1LnVjTWlz
Y0luZm8gfD0gUElYRUxfQ0xPQ0tfVjVfTUlTQ19IRE1JXzMwQlBQOw0KLQkJCQlicmVhazsNCisJ
CQlpZiAoZW5jb2Rlcl9tb2RlID09IEFUT01fRU5DT0RFUl9NT0RFX0hETUkpIHsNCisJCQkJc3dp
dGNoIChicGMpIHsNCisJCQkJY2FzZSA4Og0KKwkJCQlkZWZhdWx0Og0KKwkJCQkJYXJncy52NS51
Y01pc2NJbmZvIHw9IFBJWEVMX0NMT0NLX1Y1X01JU0NfSERNSV8yNEJQUDsNCisJCQkJCWJyZWFr
Ow0KKwkJCQljYXNlIDEwOg0KKwkJCQkJYXJncy52NS51Y01pc2NJbmZvIHw9IFBJWEVMX0NMT0NL
X1Y1X01JU0NfSERNSV8zMEJQUDsNCisJCQkJCWJyZWFrOw0KKwkJCQl9DQogCQkJfQ0KIAkJCWFy
Z3MudjUudWNUcmFuc21pdHRlcklEID0gZW5jb2Rlcl9pZDsNCiAJCQlhcmdzLnY1LnVjRW5jb2Rl
ck1vZGUgPSBlbmNvZGVyX21vZGU7DQpAQCAtODUyLDIwICs4NTQsMjIgQEAgc3RhdGljIHZvaWQg
YXRvbWJpb3NfY3J0Y19wcm9ncmFtX3BsbChzdHJ1Y3QgZHJtX2NydGMgKmNydGMsDQogCQkJYXJn
cy52Ni51Y01pc2NJbmZvID0gMDsgLyogSERNSSBkZXB0aCwgZXRjLiAqLw0KIAkJCWlmIChzc19l
bmFibGVkICYmIChzcy0+dHlwZSAmIEFUT01fRVhURVJOQUxfU1NfTUFTSykpDQogCQkJCWFyZ3Mu
djYudWNNaXNjSW5mbyB8PSBQSVhFTF9DTE9DS19WNl9NSVNDX1JFRl9ESVZfU1JDOw0KLQkJCXN3
aXRjaCAoYnBjKSB7DQotCQkJY2FzZSA4Og0KLQkJCWRlZmF1bHQ6DQotCQkJCWFyZ3MudjYudWNN
aXNjSW5mbyB8PSBQSVhFTF9DTE9DS19WNl9NSVNDX0hETUlfMjRCUFA7DQotCQkJCWJyZWFrOw0K
LQkJCWNhc2UgMTA6DQotCQkJCWFyZ3MudjYudWNNaXNjSW5mbyB8PSBQSVhFTF9DTE9DS19WNl9N
SVNDX0hETUlfMzBCUFA7DQotCQkJCWJyZWFrOw0KLQkJCWNhc2UgMTI6DQotCQkJCWFyZ3MudjYu
dWNNaXNjSW5mbyB8PSBQSVhFTF9DTE9DS19WNl9NSVNDX0hETUlfMzZCUFA7DQotCQkJCWJyZWFr
Ow0KLQkJCWNhc2UgMTY6DQotCQkJCWFyZ3MudjYudWNNaXNjSW5mbyB8PSBQSVhFTF9DTE9DS19W
Nl9NSVNDX0hETUlfNDhCUFA7DQotCQkJCWJyZWFrOw0KKwkJCWlmIChlbmNvZGVyX21vZGUgPT0g
QVRPTV9FTkNPREVSX01PREVfSERNSSkgew0KKwkJCQlzd2l0Y2ggKGJwYykgew0KKwkJCQljYXNl
IDg6DQorCQkJCWRlZmF1bHQ6DQorCQkJCQlhcmdzLnY2LnVjTWlzY0luZm8gfD0gUElYRUxfQ0xP
Q0tfVjZfTUlTQ19IRE1JXzI0QlBQOw0KKwkJCQkJYnJlYWs7DQorCQkJCWNhc2UgMTA6DQorCQkJ
CQlhcmdzLnY2LnVjTWlzY0luZm8gfD0gUElYRUxfQ0xPQ0tfVjZfTUlTQ19IRE1JXzMwQlBQOw0K
KwkJCQkJYnJlYWs7DQorCQkJCWNhc2UgMTI6DQorCQkJCQlhcmdzLnY2LnVjTWlzY0luZm8gfD0g
UElYRUxfQ0xPQ0tfVjZfTUlTQ19IRE1JXzM2QlBQOw0KKwkJCQkJYnJlYWs7DQorCQkJCWNhc2Ug
MTY6DQorCQkJCQlhcmdzLnY2LnVjTWlzY0luZm8gfD0gUElYRUxfQ0xPQ0tfVjZfTUlTQ19IRE1J
XzQ4QlBQOw0KKwkJCQkJYnJlYWs7DQorCQkJCX0NCiAJCQl9DQogCQkJYXJncy52Ni51Y1RyYW5z
bWl0dGVySUQgPSBlbmNvZGVyX2lkOw0KIAkJCWFyZ3MudjYudWNFbmNvZGVyTW9kZSA9IGVuY29k
ZXJfbW9kZTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2F0b21iaW9zX2Vu
Y29kZXJzLmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2F0b21iaW9zX2VuY29kZXJzLmMNCmlu
ZGV4IDQ3NWEyNzUuLjI4NmYxZmEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9u
L2F0b21iaW9zX2VuY29kZXJzLmMNCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJp
b3NfZW5jb2RlcnMuYw0KQEAgLTE2MjYsOCArMTYyNiwxMSBAQCBhdG9tYmlvc19zZXRfZW5jb2Rl
cl9jcnRjX3NvdXJjZShzdHJ1Y3QgZHJtX2VuY29kZXIgKmVuY29kZXIpDQogCQkJCQlhcmdzLnYy
LnVjRW5jb2RlTW9kZSA9IEFUT01fRU5DT0RFUl9NT0RFX0NSVDsNCiAJCQkJZWxzZQ0KIAkJCQkJ
YXJncy52Mi51Y0VuY29kZU1vZGUgPSBhdG9tYmlvc19nZXRfZW5jb2Rlcl9tb2RlKGVuY29kZXIp
Ow0KLQkJCX0gZWxzZQ0KKwkJCX0gZWxzZSBpZiAocmFkZW9uX2VuY29kZXItPmRldmljZXMgJiAo
QVRPTV9ERVZJQ0VfTENEX1NVUFBPUlQpKSB7DQorCQkJCWFyZ3MudjIudWNFbmNvZGVNb2RlID0g
QVRPTV9FTkNPREVSX01PREVfTFZEUzsNCisJCQl9IGVsc2Ugew0KIAkJCQlhcmdzLnYyLnVjRW5j
b2RlTW9kZSA9IGF0b21iaW9zX2dldF9lbmNvZGVyX21vZGUoZW5jb2Rlcik7DQorCQkJfQ0KIAkJ
CXN3aXRjaCAocmFkZW9uX2VuY29kZXItPmVuY29kZXJfaWQpIHsNCiAJCQljYXNlIEVOQ09ERVJf
T0JKRUNUX0lEX0lOVEVSTkFMX1VOSVBIWToNCiAJCQljYXNlIEVOQ09ERVJfT0JKRUNUX0lEX0lO
VEVSTkFMX1VOSVBIWTE6DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRl
b25fY29ubmVjdG9ycy5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fY29ubmVjdG9y
cy5jDQppbmRleCBiMTAxODQzLi42ODNjZWRlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJt
L3JhZGVvbi9yYWRlb25fY29ubmVjdG9ycy5jDQorKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9u
L3JhZGVvbl9jb25uZWN0b3JzLmMNCkBAIC0xMjQ2LDcgKzEyNDYsNyBAQCBib29sIHJhZGVvbl9j
b25uZWN0b3JfaXNfZHAxMl9jYXBhYmxlKHN0cnVjdCBkcm1fY29ubmVjdG9yICpjb25uZWN0b3Ip
DQogCXN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2ID0gZGV2LT5kZXZfcHJpdmF0ZTsNCiANCiAJ
aWYgKEFTSUNfSVNfRENFNShyZGV2KSAmJg0KLQkgICAgKHJkZXYtPmNsb2NrLmRwX2V4dGNsayA+
PSA1MzkwMCkgJiYNCisJICAgIChyZGV2LT5jbG9jay5kZWZhdWx0X2Rpc3BjbGsgPj0gNTM5MDAp
ICYmDQogCSAgICByYWRlb25fY29ubmVjdG9yX2VuY29kZXJfaXNfaGJyMihjb25uZWN0b3IpKSB7
DQogCQlyZXR1cm4gdHJ1ZTsNCiAJfQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRl
b24vcnM2MDAuYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcnM2MDAuYw0KaW5kZXggY2VhNDgy
YS4uZGMwMDE1NSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcnM2MDAuYw0K
KysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yczYwMC5jDQpAQCAtNTI5LDggKzUyOSwxMSBA
QCBpbnQgcnM2MDBfZ2FydF9zZXRfcGFnZShzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldiwgaW50
IGksIHVpbnQ2NF90IGFkZHIpDQogCQlyZXR1cm4gLUVJTlZBTDsNCiAJfQ0KIAlhZGRyID0gYWRk
ciAmIDB4RkZGRkZGRkZGRkZGRjAwMFVMTDsNCi0JYWRkciB8PSBSNjAwX1BURV9WQUxJRCB8IFI2
MDBfUFRFX1NZU1RFTSB8IFI2MDBfUFRFX1NOT09QRUQ7DQotCWFkZHIgfD0gUjYwMF9QVEVfUkVB
REFCTEUgfCBSNjAwX1BURV9XUklURUFCTEU7DQorCWlmIChhZGRyID09IHJkZXYtPmR1bW15X3Bh
Z2UuYWRkcikNCisJCWFkZHIgfD0gUjYwMF9QVEVfU1lTVEVNIHwgUjYwMF9QVEVfU05PT1BFRDsN
CisJZWxzZQ0KKwkJYWRkciB8PSAoUjYwMF9QVEVfVkFMSUQgfCBSNjAwX1BURV9TWVNURU0gfCBS
NjAwX1BURV9TTk9PUEVEIHwNCisJCQkgUjYwMF9QVEVfUkVBREFCTEUgfCBSNjAwX1BURV9XUklU
RUFCTEUpOw0KIAl3cml0ZXEoYWRkciwgcHRyICsgKGkgKiA4KSk7DQogCXJldHVybiAwOw0KIH0N
CmRpZmYgLS1naXQgYS9kcml2ZXJzL2hpZC9oaWQtY29yZS5jIGIvZHJpdmVycy9oaWQvaGlkLWNv
cmUuYw0KaW5kZXggOWFjNDM4OS4uNjRkNzlkMiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaGlkL2hp
ZC1jb3JlLmMNCisrKyBiL2RyaXZlcnMvaGlkL2hpZC1jb3JlLmMNCkBAIC03NTQsNyArNzU0LDE3
IEBAIHN0cnVjdCBoaWRfcmVwb3J0ICpoaWRfdmFsaWRhdGVfdmFsdWVzKHN0cnVjdCBoaWRfZGV2
aWNlICpoaWQsDQogCSAqIC0+bnVtYmVyZWQgYmVpbmcgY2hlY2tlZCwgd2hpY2ggbWF5IG5vdCBh
bHdheXMgYmUgdGhlIGNhc2Ugd2hlbg0KIAkgKiBkcml2ZXJzIGdvIHRvIGFjY2VzcyByZXBvcnQg
dmFsdWVzLg0KIAkgKi8NCi0JcmVwb3J0ID0gaGlkLT5yZXBvcnRfZW51bVt0eXBlXS5yZXBvcnRf
aWRfaGFzaFtpZF07DQorCWlmIChpZCA9PSAwKSB7DQorCQkvKg0KKwkJICogVmFsaWRhdGluZyBv
biBpZCAwIG1lYW5zIHdlIHNob3VsZCBleGFtaW5lIHRoZSBmaXJzdA0KKwkJICogcmVwb3J0IGlu
IHRoZSBsaXN0Lg0KKwkJICovDQorCQlyZXBvcnQgPSBsaXN0X2VudHJ5KA0KKwkJCQloaWQtPnJl
cG9ydF9lbnVtW3R5cGVdLnJlcG9ydF9saXN0Lm5leHQsDQorCQkJCXN0cnVjdCBoaWRfcmVwb3J0
LCBsaXN0KTsNCisJfSBlbHNlIHsNCisJCXJlcG9ydCA9IGhpZC0+cmVwb3J0X2VudW1bdHlwZV0u
cmVwb3J0X2lkX2hhc2hbaWRdOw0KKwl9DQogCWlmICghcmVwb3J0KSB7DQogCQloaWRfZXJyKGhp
ZCwgIm1pc3NpbmcgJXMgJXVcbiIsIGhpZF9yZXBvcnRfbmFtZXNbdHlwZV0sIGlkKTsNCiAJCXJl
dHVybiBOVUxMOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL3VzZXJfbWFk
LmMgYi9kcml2ZXJzL2luZmluaWJhbmQvY29yZS91c2VyX21hZC5jDQppbmRleCAwN2RiMjI5Li5j
Njg1ODgxIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvdXNlcl9tYWQuYw0K
KysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvdXNlcl9tYWQuYw0KQEAgLTc4MCwyNyArNzgw
LDE5IEBAIHN0YXRpYyBpbnQgaWJfdW1hZF9vcGVuKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVj
dCBmaWxlICpmaWxwKQ0KIHsNCiAJc3RydWN0IGliX3VtYWRfcG9ydCAqcG9ydDsNCiAJc3RydWN0
IGliX3VtYWRfZmlsZSAqZmlsZTsNCi0JaW50IHJldDsNCisJaW50IHJldCA9IC1FTlhJTzsNCiAN
CiAJcG9ydCA9IGNvbnRhaW5lcl9vZihpbm9kZS0+aV9jZGV2LCBzdHJ1Y3QgaWJfdW1hZF9wb3J0
LCBjZGV2KTsNCi0JaWYgKHBvcnQpDQotCQlrcmVmX2dldCgmcG9ydC0+dW1hZF9kZXYtPnJlZik7
DQotCWVsc2UNCi0JCXJldHVybiAtRU5YSU87DQogDQogCW11dGV4X2xvY2soJnBvcnQtPmZpbGVf
bXV0ZXgpOw0KIA0KLQlpZiAoIXBvcnQtPmliX2Rldikgew0KLQkJcmV0ID0gLUVOWElPOw0KKwlp
ZiAoIXBvcnQtPmliX2RldikNCiAJCWdvdG8gb3V0Ow0KLQl9DQogDQorCXJldCA9IC1FTk9NRU07
DQogCWZpbGUgPSBremFsbG9jKHNpemVvZiAqZmlsZSwgR0ZQX0tFUk5FTCk7DQotCWlmICghZmls
ZSkgew0KLQkJa3JlZl9wdXQoJnBvcnQtPnVtYWRfZGV2LT5yZWYsIGliX3VtYWRfcmVsZWFzZV9k
ZXYpOw0KLQkJcmV0ID0gLUVOT01FTTsNCisJaWYgKCFmaWxlKQ0KIAkJZ290byBvdXQ7DQotCX0N
CiANCiAJbXV0ZXhfaW5pdCgmZmlsZS0+bXV0ZXgpOw0KIAlzcGluX2xvY2tfaW5pdCgmZmlsZS0+
c2VuZF9sb2NrKTsNCkBAIC04MTQsNiArODA2LDEzIEBAIHN0YXRpYyBpbnQgaWJfdW1hZF9vcGVu
KHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxwKQ0KIAlsaXN0X2FkZF90YWls
KCZmaWxlLT5wb3J0X2xpc3QsICZwb3J0LT5maWxlX2xpc3QpOw0KIA0KIAlyZXQgPSBub25zZWVr
YWJsZV9vcGVuKGlub2RlLCBmaWxwKTsNCisJaWYgKHJldCkgew0KKwkJbGlzdF9kZWwoJmZpbGUt
PnBvcnRfbGlzdCk7DQorCQlrZnJlZShmaWxlKTsNCisJCWdvdG8gb3V0Ow0KKwl9DQorDQorCWty
ZWZfZ2V0KCZwb3J0LT51bWFkX2Rldi0+cmVmKTsNCiANCiBvdXQ6DQogCW11dGV4X3VubG9jaygm
cG9ydC0+ZmlsZV9tdXRleCk7DQpAQCAtODgwLDEwICs4NzksNiBAQCBzdGF0aWMgaW50IGliX3Vt
YWRfc21fb3BlbihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlscCkNCiAJaW50
IHJldDsNCiANCiAJcG9ydCA9IGNvbnRhaW5lcl9vZihpbm9kZS0+aV9jZGV2LCBzdHJ1Y3QgaWJf
dW1hZF9wb3J0LCBzbV9jZGV2KTsNCi0JaWYgKHBvcnQpDQotCQlrcmVmX2dldCgmcG9ydC0+dW1h
ZF9kZXYtPnJlZik7DQotCWVsc2UNCi0JCXJldHVybiAtRU5YSU87DQogDQogCWlmIChmaWxwLT5m
X2ZsYWdzICYgT19OT05CTE9DSykgew0KIAkJaWYgKGRvd25fdHJ5bG9jaygmcG9ydC0+c21fc2Vt
KSkgew0KQEAgLTg5OCwxNyArODkzLDI3IEBAIHN0YXRpYyBpbnQgaWJfdW1hZF9zbV9vcGVuKHN0
cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxwKQ0KIAl9DQogDQogCXJldCA9IGli
X21vZGlmeV9wb3J0KHBvcnQtPmliX2RldiwgcG9ydC0+cG9ydF9udW0sIDAsICZwcm9wcyk7DQot
CWlmIChyZXQpIHsNCi0JCXVwKCZwb3J0LT5zbV9zZW0pOw0KLQkJZ290byBmYWlsOw0KLQl9DQor
CWlmIChyZXQpDQorCQlnb3RvIGVycl91cF9zZW07DQogDQogCWZpbHAtPnByaXZhdGVfZGF0YSA9
IHBvcnQ7DQogDQotCXJldHVybiBub25zZWVrYWJsZV9vcGVuKGlub2RlLCBmaWxwKTsNCisJcmV0
ID0gbm9uc2Vla2FibGVfb3Blbihpbm9kZSwgZmlscCk7DQorCWlmIChyZXQpDQorCQlnb3RvIGVy
cl9jbHJfc21fY2FwOw0KKw0KKwlrcmVmX2dldCgmcG9ydC0+dW1hZF9kZXYtPnJlZik7DQorDQor
CXJldHVybiAwOw0KKw0KK2Vycl9jbHJfc21fY2FwOg0KKwlzd2FwKHByb3BzLnNldF9wb3J0X2Nh
cF9tYXNrLCBwcm9wcy5jbHJfcG9ydF9jYXBfbWFzayk7DQorCWliX21vZGlmeV9wb3J0KHBvcnQt
PmliX2RldiwgcG9ydC0+cG9ydF9udW0sIDAsICZwcm9wcyk7DQorDQorZXJyX3VwX3NlbToNCisJ
dXAoJnBvcnQtPnNtX3NlbSk7DQogDQogZmFpbDoNCi0Ja3JlZl9wdXQoJnBvcnQtPnVtYWRfZGV2
LT5yZWYsIGliX3VtYWRfcmVsZWFzZV9kZXYpOw0KIAlyZXR1cm4gcmV0Ow0KIH0NCiANCmRpZmYg
LS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvY3hnYjQvY3EuYyBiL2RyaXZlcnMvaW5maW5p
YmFuZC9ody9jeGdiNC9jcS5jDQppbmRleCAwZjE2MDdjLi4zYmQ2YjY5IDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9pbmZpbmliYW5kL2h3L2N4Z2I0L2NxLmMNCisrKyBiL2RyaXZlcnMvaW5maW5pYmFu
ZC9ody9jeGdiNC9jcS5jDQpAQCAtODQzLDcgKzg0Myw4IEBAIHN0cnVjdCBpYl9jcSAqYzRpd19j
cmVhdGVfY3Eoc3RydWN0IGliX2RldmljZSAqaWJkZXYsIGludCBlbnRyaWVzLA0KIAkJdXJlc3Au
Z3RzX2tleSA9IHVjb250ZXh0LT5rZXk7DQogCQl1Y29udGV4dC0+a2V5ICs9IFBBR0VfU0laRTsN
CiAJCXNwaW5fdW5sb2NrKCZ1Y29udGV4dC0+bW1hcF9sb2NrKTsNCi0JCXJldCA9IGliX2NvcHlf
dG9fdWRhdGEodWRhdGEsICZ1cmVzcCwgc2l6ZW9mIHVyZXNwKTsNCisJCXJldCA9IGliX2NvcHlf
dG9fdWRhdGEodWRhdGEsICZ1cmVzcCwNCisJCQkJICAgICAgIHNpemVvZih1cmVzcCkgLSBzaXpl
b2YodXJlc3AucmVzZXJ2ZWQpKTsNCiAJCWlmIChyZXQpDQogCQkJZ290byBlcnI1Ow0KIA0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9jeGdiNC91c2VyLmggYi9kcml2ZXJzL2lu
ZmluaWJhbmQvaHcvY3hnYjQvdXNlci5oDQppbmRleCBlNjY2OWQ1Li4wNmU4OTM4IDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L2N4Z2I0L3VzZXIuaA0KKysrIGIvZHJpdmVycy9p
bmZpbmliYW5kL2h3L2N4Z2I0L3VzZXIuaA0KQEAgLTQ4LDYgKzQ4LDcgQEAgc3RydWN0IGM0aXdf
Y3JlYXRlX2NxX3Jlc3Agew0KIAlfX3UzMiBjcWlkOw0KIAlfX3UzMiBzaXplOw0KIAlfX3UzMiBx
aWRfbWFzazsNCisJX191MzIgcmVzZXJ2ZWQ7IC8qIGV4cGxpY2l0IHBhZGRpbmcgKG9wdGlvbmFs
IGZvciBpMzg2KSAqLw0KIH07DQogDQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5k
L2h3L2lwYXRoL2lwYXRoX2RpYWcuYyBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9pcGF0aC9pcGF0
aF9kaWFnLmMNCmluZGV4IGUyZjlhNTEuLjQ1ODAyZTkgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2lu
ZmluaWJhbmQvaHcvaXBhdGgvaXBhdGhfZGlhZy5jDQorKysgYi9kcml2ZXJzL2luZmluaWJhbmQv
aHcvaXBhdGgvaXBhdGhfZGlhZy5jDQpAQCAtMzQ2LDYgKzM0NiwxMCBAQCBzdGF0aWMgc3NpemVf
dCBpcGF0aF9kaWFncGt0X3dyaXRlKHN0cnVjdCBmaWxlICpmcCwNCiAJCQlyZXQgPSAtRUZBVUxU
Ow0KIAkJCWdvdG8gYmFpbDsNCiAJCX0NCisJCWRwLmxlbiA9IG9kcC5sZW47DQorCQlkcC51bml0
ID0gb2RwLnVuaXQ7DQorCQlkcC5kYXRhID0gb2RwLmRhdGE7DQorCQlkcC5wYmNfd2QgPSAwOw0K
IAl9IGVsc2Ugew0KIAkJcmV0ID0gLUVJTlZBTDsNCiAJCWdvdG8gYmFpbDsNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL2luZmluaWJhbmQvaHcvcWliL3FpYl9tYWQuYyBiL2RyaXZlcnMvaW5maW5pYmFu
ZC9ody9xaWIvcWliX21hZC5jDQppbmRleCAzYjM3NDVmLi5kZDJhZDZkMyAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvaW5maW5pYmFuZC9ody9xaWIvcWliX21hZC5jDQorKysgYi9kcml2ZXJzL2luZmlu
aWJhbmQvaHcvcWliL3FpYl9tYWQuYw0KQEAgLTEwMDcsNyArMTAwNyw3IEBAIHN0YXRpYyBpbnQg
c2V0X3BrZXlzKHN0cnVjdCBxaWJfZGV2ZGF0YSAqZGQsIHU4IHBvcnQsIHUxNiAqcGtleXMpDQog
DQogCQlldmVudC5ldmVudCA9IElCX0VWRU5UX1BLRVlfQ0hBTkdFOw0KIAkJZXZlbnQuZGV2aWNl
ID0gJmRkLT52ZXJic19kZXYuaWJkZXY7DQotCQlldmVudC5lbGVtZW50LnBvcnRfbnVtID0gMTsN
CisJCWV2ZW50LmVsZW1lbnQucG9ydF9udW0gPSBwb3J0Ow0KIAkJaWJfZGlzcGF0Y2hfZXZlbnQo
JmV2ZW50KTsNCiAJfQ0KIAlyZXR1cm4gMDsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2luZmluaWJh
bmQvdWxwL3NycC9pYl9zcnAuYyBiL2RyaXZlcnMvaW5maW5pYmFuZC91bHAvc3JwL2liX3NycC5j
DQppbmRleCA0ZWMwNDlkLi44NzcwZDQ0IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9pbmZpbmliYW5k
L3VscC9zcnAvaWJfc3JwLmMNCisrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC91bHAvc3JwL2liX3Ny
cC5jDQpAQCAtMTM1Myw2ICsxMzUzLDEyIEBAIGVycl91bm1hcDoNCiBlcnJfaXU6DQogCXNycF9w
dXRfdHhfaXUodGFyZ2V0LCBpdSwgU1JQX0lVX0NNRCk7DQogDQorCS8qDQorCSAqIEF2b2lkIHRo
YXQgdGhlIGxvb3BzIHRoYXQgaXRlcmF0ZSBvdmVyIHRoZSByZXF1ZXN0IHJpbmcgY2FuDQorCSAq
IGVuY291bnRlciBhIGRhbmdsaW5nIFNDU0kgY29tbWFuZCBwb2ludGVyLg0KKwkgKi8NCisJcmVx
LT5zY21uZCA9IE5VTEw7DQorDQogCXNwaW5fbG9ja19pcnFzYXZlKCZ0YXJnZXQtPmxvY2ssIGZs
YWdzKTsNCiAJbGlzdF9hZGQoJnJlcS0+bGlzdCwgJnRhcmdldC0+ZnJlZV9yZXFzKTsNCiANCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL2lucHV0L21vdXNlL2VsYW50ZWNoLmMgYi9kcml2ZXJzL2lucHV0
L21vdXNlL2VsYW50ZWNoLmMNCmluZGV4IDM0MmEwNTkuLjcwNDIzZGMgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL2lucHV0L21vdXNlL2VsYW50ZWNoLmMNCisrKyBiL2RyaXZlcnMvaW5wdXQvbW91c2Uv
ZWxhbnRlY2guYw0KQEAgLTQ1NSw4ICs0NTUsMTUgQEAgc3RhdGljIHZvaWQgZWxhbnRlY2hfcmVw
b3J0X2Fic29sdXRlX3YzKHN0cnVjdCBwc21vdXNlICpwc21vdXNlLA0KIAlpbnB1dF9yZXBvcnRf
a2V5KGRldiwgQlROX1RPT0xfRklOR0VSLCBmaW5nZXJzID09IDEpOw0KIAlpbnB1dF9yZXBvcnRf
a2V5KGRldiwgQlROX1RPT0xfRE9VQkxFVEFQLCBmaW5nZXJzID09IDIpOw0KIAlpbnB1dF9yZXBv
cnRfa2V5KGRldiwgQlROX1RPT0xfVFJJUExFVEFQLCBmaW5nZXJzID09IDMpOw0KLQlpbnB1dF9y
ZXBvcnRfa2V5KGRldiwgQlROX0xFRlQsIHBhY2tldFswXSAmIDB4MDEpOw0KLQlpbnB1dF9yZXBv
cnRfa2V5KGRldiwgQlROX1JJR0hULCBwYWNrZXRbMF0gJiAweDAyKTsNCisNCisJLyogRm9yIGNs
aWNrcGFkcyBtYXAgYm90aCBidXR0b25zIHRvIEJUTl9MRUZUICovDQorCWlmIChldGQtPmZ3X3Zl
cnNpb24gJiAweDAwMTAwMCkgew0KKwkJaW5wdXRfcmVwb3J0X2tleShkZXYsIEJUTl9MRUZULCBw
YWNrZXRbMF0gJiAweDAzKTsNCisJfSBlbHNlIHsNCisJCWlucHV0X3JlcG9ydF9rZXkoZGV2LCBC
VE5fTEVGVCwgcGFja2V0WzBdICYgMHgwMSk7DQorCQlpbnB1dF9yZXBvcnRfa2V5KGRldiwgQlRO
X1JJR0hULCBwYWNrZXRbMF0gJiAweDAyKTsNCisJfQ0KKw0KIAlpbnB1dF9yZXBvcnRfYWJzKGRl
diwgQUJTX1BSRVNTVVJFLCBwcmVzKTsNCiAJaW5wdXRfcmVwb3J0X2FicyhkZXYsIEFCU19UT09M
X1dJRFRILCB3aWR0aCk7DQogDQpAQCAtNDY2LDEwICs0NzMsMTcgQEAgc3RhdGljIHZvaWQgZWxh
bnRlY2hfcmVwb3J0X2Fic29sdXRlX3YzKHN0cnVjdCBwc21vdXNlICpwc21vdXNlLA0KIHN0YXRp
YyB2b2lkIGVsYW50ZWNoX2lucHV0X3N5bmNfdjQoc3RydWN0IHBzbW91c2UgKnBzbW91c2UpDQog
ew0KIAlzdHJ1Y3QgaW5wdXRfZGV2ICpkZXYgPSBwc21vdXNlLT5kZXY7DQorCXN0cnVjdCBlbGFu
dGVjaF9kYXRhICpldGQgPSBwc21vdXNlLT5wcml2YXRlOw0KIAl1bnNpZ25lZCBjaGFyICpwYWNr
ZXQgPSBwc21vdXNlLT5wYWNrZXQ7DQogDQotCWlucHV0X3JlcG9ydF9rZXkoZGV2LCBCVE5fTEVG
VCwgcGFja2V0WzBdICYgMHgwMSk7DQotCWlucHV0X3JlcG9ydF9rZXkoZGV2LCBCVE5fUklHSFQs
IHBhY2tldFswXSAmIDB4MDIpOw0KKwkvKiBGb3IgY2xpY2twYWRzIG1hcCBib3RoIGJ1dHRvbnMg
dG8gQlROX0xFRlQgKi8NCisJaWYgKGV0ZC0+ZndfdmVyc2lvbiAmIDB4MDAxMDAwKSB7DQorCQlp
bnB1dF9yZXBvcnRfa2V5KGRldiwgQlROX0xFRlQsIHBhY2tldFswXSAmIDB4MDMpOw0KKwl9IGVs
c2Ugew0KKwkJaW5wdXRfcmVwb3J0X2tleShkZXYsIEJUTl9MRUZULCBwYWNrZXRbMF0gJiAweDAx
KTsNCisJCWlucHV0X3JlcG9ydF9rZXkoZGV2LCBCVE5fUklHSFQsIHBhY2tldFswXSAmIDB4MDIp
Ow0KKwl9DQorDQogCWlucHV0X210X3JlcG9ydF9wb2ludGVyX2VtdWxhdGlvbihkZXYsIHRydWUp
Ow0KIAlpbnB1dF9zeW5jKGRldik7DQogfQ0KQEAgLTc4Nyw3ICs4MDEsNyBAQCBzdGF0aWMgaW50
IGVsYW50ZWNoX3NldF9hYnNvbHV0ZV9tb2RlKHN0cnVjdCBwc21vdXNlICpwc21vdXNlKQ0KIAkJ
aWYgKGV0ZC0+c2V0X2h3X3Jlc29sdXRpb24pDQogCQkJZXRkLT5yZWdfMTAgPSAweDBiOw0KIAkJ
ZWxzZQ0KLQkJCWV0ZC0+cmVnXzEwID0gMHgwMzsNCisJCQlldGQtPnJlZ18xMCA9IDB4MDE7DQog
DQogCQlpZiAoZWxhbnRlY2hfd3JpdGVfcmVnKHBzbW91c2UsIDB4MTAsIGV0ZC0+cmVnXzEwKSkN
CiAJCQlyYyA9IC0xOw0KQEAgLTEyMTEsNyArMTIyNSw4IEBAIHN0YXRpYyBpbnQgZWxhbnRlY2hf
cmVjb25uZWN0KHN0cnVjdCBwc21vdXNlICpwc21vdXNlKQ0KIH0NCiANCiAvKg0KLSAqIFNvbWUg
aHdfdmVyc2lvbiAzIG1vZGVscyBnbyBpbnRvIGVycm9yIHN0YXRlIHdoZW4gd2UgdHJ5IHRvIHNl
dCBiaXQgMyBvZiByMTANCisgKiBTb21lIGh3X3ZlcnNpb24gMyBtb2RlbHMgZ28gaW50byBlcnJv
ciBzdGF0ZSB3aGVuIHdlIHRyeSB0byBzZXQNCisgKiBiaXQgMyBhbmQvb3IgYml0IDEgb2YgcjEw
Lg0KICAqLw0KIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZG1pX3N5c3RlbV9pZCBub19od19yZXNfZG1p
X3RhYmxlW10gPSB7DQogI2lmIGRlZmluZWQoQ09ORklHX0RNSSkgJiYgZGVmaW5lZChDT05GSUdf
WDg2KQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5wdXQvbW91c2Uvc3luYXB0aWNzLmMgYi9kcml2
ZXJzL2lucHV0L21vdXNlL3N5bmFwdGljcy5jDQppbmRleCA4YTM5ODA3Li5kZjhiNzJiIDEwMDY0
NA0KLS0tIGEvZHJpdmVycy9pbnB1dC9tb3VzZS9zeW5hcHRpY3MuYw0KKysrIGIvZHJpdmVycy9p
bnB1dC9tb3VzZS9zeW5hcHRpY3MuYw0KQEAgLTI0NSwxNCArMjQ1LDYgQEAgc3RhdGljIGludCBz
eW5hcHRpY3NfcmVzb2x1dGlvbihzdHJ1Y3QgcHNtb3VzZSAqcHNtb3VzZSkNCiAJc3RydWN0IHN5
bmFwdGljc19kYXRhICpwcml2ID0gcHNtb3VzZS0+cHJpdmF0ZTsNCiAJdW5zaWduZWQgY2hhciBy
ZXNwWzNdOw0KIA0KLQlpZiAocXVpcmtfbWluX21heCkgew0KLQkJcHJpdi0+eF9taW4gPSBxdWly
a19taW5fbWF4WzBdOw0KLQkJcHJpdi0+eF9tYXggPSBxdWlya19taW5fbWF4WzFdOw0KLQkJcHJp
di0+eV9taW4gPSBxdWlya19taW5fbWF4WzJdOw0KLQkJcHJpdi0+eV9tYXggPSBxdWlya19taW5f
bWF4WzNdOw0KLQkJcmV0dXJuIDA7DQotCX0NCi0NCiAJaWYgKFNZTl9JRF9NQUpPUihwcml2LT5p
ZGVudGl0eSkgPCA0KQ0KIAkJcmV0dXJuIDA7DQogDQpAQCAtMjYzLDYgKzI1NSwxNCBAQCBzdGF0
aWMgaW50IHN5bmFwdGljc19yZXNvbHV0aW9uKHN0cnVjdCBwc21vdXNlICpwc21vdXNlKQ0KIAkJ
fQ0KIAl9DQogDQorCWlmIChxdWlya19taW5fbWF4KSB7DQorCQlwcml2LT54X21pbiA9IHF1aXJr
X21pbl9tYXhbMF07DQorCQlwcml2LT54X21heCA9IHF1aXJrX21pbl9tYXhbMV07DQorCQlwcml2
LT55X21pbiA9IHF1aXJrX21pbl9tYXhbMl07DQorCQlwcml2LT55X21heCA9IHF1aXJrX21pbl9t
YXhbM107DQorCQlyZXR1cm4gMDsNCisJfQ0KKw0KIAlpZiAoU1lOX0VYVF9DQVBfUkVRVUVTVFMo
cHJpdi0+Y2FwYWJpbGl0aWVzKSA+PSA1ICYmDQogCSAgICBTWU5fQ0FQX01BWF9ESU1FTlNJT05T
KHByaXYtPmV4dF9jYXBfMGMpKSB7DQogCQlpZiAoc3luYXB0aWNzX3NlbmRfY21kKHBzbW91c2Us
IFNZTl9RVUVfRVhUX01BWF9DT09SRFMsIHJlc3ApKSB7DQpAQCAtMTQzMSw3ICsxNDMxLDcgQEAg
c3RhdGljIGNvbnN0IHN0cnVjdCBkbWlfc3lzdGVtX2lkIG1pbl9tYXhfZG1pX3RhYmxlW10gX19p
bml0Y29uc3QgPSB7DQogCQkJRE1JX01BVENIKERNSV9TWVNfVkVORE9SLCAiTEVOT1ZPIiksDQog
CQkJRE1JX01BVENIKERNSV9QUk9EVUNUX1ZFUlNJT04sICJUaGlua1BhZCBUNTQwIiksDQogCQl9
LA0KLQkJLmRyaXZlcl9kYXRhID0gKGludCBbXSl7MTAyNCwgNTA1NiwgMjA1OCwgNDgzMn0sDQor
CQkuZHJpdmVyX2RhdGEgPSAoaW50IFtdKXsxMDI0LCA1MTEyLCAyMDI0LCA0ODMyfSwNCiAJfSwN
CiAJew0KIAkJLyogTGVub3ZvIFRoaW5rUGFkIEw1NDAgKi8NCkBAIC0xNDQyLDYgKzE0NDIsMTQg
QEAgc3RhdGljIGNvbnN0IHN0cnVjdCBkbWlfc3lzdGVtX2lkIG1pbl9tYXhfZG1pX3RhYmxlW10g
X19pbml0Y29uc3QgPSB7DQogCQkuZHJpdmVyX2RhdGEgPSAoaW50IFtdKXsxMDI0LCA1MTEyLCAy
MDI0LCA0ODMyfSwNCiAJfSwNCiAJew0KKwkJLyogTGVub3ZvIFRoaW5rUGFkIFc1NDAgKi8NCisJ
CS5tYXRjaGVzID0gew0KKwkJCURNSV9NQVRDSChETUlfU1lTX1ZFTkRPUiwgIkxFTk9WTyIpLA0K
KwkJCURNSV9NQVRDSChETUlfUFJPRFVDVF9WRVJTSU9OLCAiVGhpbmtQYWQgVzU0MCIpLA0KKwkJ
fSwNCisJCS5kcml2ZXJfZGF0YSA9IChpbnQgW10pezEwMjQsIDUxMTIsIDIwMjQsIDQ4MzJ9LA0K
Kwl9LA0KKwl7DQogCQkvKiBMZW5vdm8gWW9nYSBTMSAqLw0KIAkJLm1hdGNoZXMgPSB7DQogCQkJ
RE1JX01BVENIKERNSV9TWVNfVkVORE9SLCAiTEVOT1ZPIiksDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9pb21tdS9pbnRlbC1pb21tdS5jIGIvZHJpdmVycy9pb21tdS9pbnRlbC1pb21tdS5jDQppbmRl
eCAxYTUxYjNkLi5iYjFlNTc5IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9pb21tdS9pbnRlbC1pb21t
dS5jDQorKysgYi9kcml2ZXJzL2lvbW11L2ludGVsLWlvbW11LmMNCkBAIC00MDcwLDcgKzQwNzAs
NyBAQCBzdGF0aWMgaW50IGludGVsX2lvbW11X3VubWFwKHN0cnVjdCBpb21tdV9kb21haW4gKmRv
bWFpbiwNCiB7DQogCXN0cnVjdCBkbWFyX2RvbWFpbiAqZG1hcl9kb21haW4gPSBkb21haW4tPnBy
aXY7DQogCXNpemVfdCBzaXplID0gUEFHRV9TSVpFIDw8IGdmcF9vcmRlcjsNCi0JaW50IG9yZGVy
Ow0KKwlpbnQgb3JkZXIsIGlvbW11X2lkOw0KIA0KIAlvcmRlciA9IGRtYV9wdGVfY2xlYXJfcmFu
Z2UoZG1hcl9kb21haW4sIGlvdmEgPj4gVlREX1BBR0VfU0hJRlQsDQogCQkJICAgIChpb3ZhICsg
c2l6ZSAtIDEpID4+IFZURF9QQUdFX1NISUZUKTsNCkBAIC00MDc4LDYgKzQwNzgsMjIgQEAgc3Rh
dGljIGludCBpbnRlbF9pb21tdV91bm1hcChzdHJ1Y3QgaW9tbXVfZG9tYWluICpkb21haW4sDQog
CWlmIChkbWFyX2RvbWFpbi0+bWF4X2FkZHIgPT0gaW92YSArIHNpemUpDQogCQlkbWFyX2RvbWFp
bi0+bWF4X2FkZHIgPSBpb3ZhOw0KIA0KKwlmb3JfZWFjaF9zZXRfYml0KGlvbW11X2lkLCAmZG1h
cl9kb21haW4tPmlvbW11X2JtcCwgZ19udW1fb2ZfaW9tbXVzKSB7DQorCQlzdHJ1Y3QgaW50ZWxf
aW9tbXUgKmlvbW11ID0gZ19pb21tdXNbaW9tbXVfaWRdOw0KKwkJaW50IG51bSwgbmRvbWFpbnM7
DQorDQorCQkvKg0KKwkJICogZmluZCBiaXQgcG9zaXRpb24gb2YgZG1hcl9kb21haW4NCisJCSAq
Lw0KKwkJbmRvbWFpbnMgPSBjYXBfbmRvbXMoaW9tbXUtPmNhcCk7DQorCQlmb3JfZWFjaF9zZXRf
Yml0KG51bSwgaW9tbXUtPmRvbWFpbl9pZHMsIG5kb21haW5zKSB7DQorCQkJaWYgKGlvbW11LT5k
b21haW5zW251bV0gPT0gZG1hcl9kb21haW4pDQorCQkJCWlvbW11X2ZsdXNoX2lvdGxiX3BzaShp
b21tdSwgbnVtLA0KKwkJCQkJCSAgICAgIGlvdmEgPj4gVlREX1BBR0VfU0hJRlQsDQorCQkJCQkJ
ICAgICAgMSA8PCBvcmRlciwgMCk7DQorCQl9DQorCX0NCisNCiAJcmV0dXJuIG9yZGVyOw0KIH0N
CiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL21kLmMgYi9kcml2ZXJzL21kL21kLmMNCmluZGV4
IGRiNGI0YTguLjMwYTdiNTIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL21kL21kLmMNCisrKyBiL2Ry
aXZlcnMvbWQvbWQuYw0KQEAgLTcwMzUsOCArNzAzNSwxMCBAQCB2b2lkIG1kX2RvX3N5bmMoc3Ry
dWN0IG1kZGV2ICptZGRldikNCiAJLyoganVzdCBpbmNhc2UgdGhyZWFkIHJlc3RhcnRzLi4uICov
DQogCWlmICh0ZXN0X2JpdChNRF9SRUNPVkVSWV9ET05FLCAmbWRkZXYtPnJlY292ZXJ5KSkNCiAJ
CXJldHVybjsNCi0JaWYgKG1kZGV2LT5ybykgLyogbmV2ZXIgdHJ5IHRvIHN5bmMgYSByZWFkLW9u
bHkgYXJyYXkgKi8NCisJaWYgKG1kZGV2LT5ybykgey8qIG5ldmVyIHRyeSB0byBzeW5jIGEgcmVh
ZC1vbmx5IGFycmF5ICovDQorCQlzZXRfYml0KE1EX1JFQ09WRVJZX0lOVFIsICZtZGRldi0+cmVj
b3ZlcnkpOw0KIAkJcmV0dXJuOw0KKwl9DQogDQogCWlmICh0ZXN0X2JpdChNRF9SRUNPVkVSWV9T
WU5DLCAmbWRkZXYtPnJlY292ZXJ5KSkgew0KIAkJaWYgKHRlc3RfYml0KE1EX1JFQ09WRVJZX0NI
RUNLLCAmbWRkZXYtPnJlY292ZXJ5KSkNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg0L21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDQvbWFpbi5jDQppbmRleCA5NGJiYzg1Li5iMDJhZGJjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NC9tYWluLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDQvbWFpbi5jDQpAQCAtMTIyMCw3ICsxMjIwLDcgQEAgc3RhdGljIHZv
aWQgbWx4NF9jbGVhcl9zdGVlcmluZyhzdHJ1Y3QgbWx4NF9kZXYgKmRldikNCiAJa2ZyZWUocHJp
di0+c3RlZXIpOw0KIH0NCiANCi1zdGF0aWMgaW50IF9fbWx4NF9pbml0X29uZShzdHJ1Y3QgcGNp
X2RldiAqcGRldiwgY29uc3Qgc3RydWN0IHBjaV9kZXZpY2VfaWQgKmlkKQ0KK3N0YXRpYyBpbnQg
X19tbHg0X2luaXRfb25lKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBpbnQgcGNpX2Rldl9kYXRhKQ0K
IHsNCiAJc3RydWN0IG1seDRfcHJpdiAqcHJpdjsNCiAJc3RydWN0IG1seDRfZGV2ICpkZXY7DQpA
QCAtMTI4MywxNSArMTI4Myw4IEBAIHN0YXRpYyBpbnQgX19tbHg0X2luaXRfb25lKHN0cnVjdCBw
Y2lfZGV2ICpwZGV2LCBjb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCAqaWQpDQogCS8qIEFsbG93
IGxhcmdlIERNQSBzZWdtZW50cywgdXAgdG8gdGhlIGZpcm13YXJlIGxpbWl0IG9mIDEgR0IgKi8N
CiAJZG1hX3NldF9tYXhfc2VnX3NpemUoJnBkZXYtPmRldiwgMTAyNCAqIDEwMjQgKiAxMDI0KTsN
CiANCi0JcHJpdiA9IGt6YWxsb2Moc2l6ZW9mICpwcml2LCBHRlBfS0VSTkVMKTsNCi0JaWYgKCFw
cml2KSB7DQotCQlkZXZfZXJyKCZwZGV2LT5kZXYsICJEZXZpY2Ugc3RydWN0IGFsbG9jIGZhaWxl
ZCwgIg0KLQkJCSJhYm9ydGluZy5cbiIpOw0KLQkJZXJyID0gLUVOT01FTTsNCi0JCWdvdG8gZXJy
X3JlbGVhc2VfcmVnaW9uczsNCi0JfQ0KLQ0KLQlkZXYgICAgICAgPSAmcHJpdi0+ZGV2Ow0KKwlk
ZXYgICAgICAgPSBwY2lfZ2V0X2RydmRhdGEocGRldik7DQorCXByaXYgICAgICA9IG1seDRfcHJp
dihkZXYpOw0KIAlkZXYtPnBkZXYgPSBwZGV2Ow0KIAlJTklUX0xJU1RfSEVBRCgmcHJpdi0+Y3R4
X2xpc3QpOw0KIAlzcGluX2xvY2tfaW5pdCgmcHJpdi0+Y3R4X2xvY2spOw0KQEAgLTEzNjIsNyAr
MTM1NSw3IEBAIHN0YXRpYyBpbnQgX19tbHg0X2luaXRfb25lKHN0cnVjdCBwY2lfZGV2ICpwZGV2
LCBjb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCAqaWQpDQogCW1seDRfc2Vuc2VfaW5pdChkZXYp
Ow0KIAltbHg0X3N0YXJ0X3NlbnNlKGRldik7DQogDQotCXBjaV9zZXRfZHJ2ZGF0YShwZGV2LCBk
ZXYpOw0KKwlwcml2LT5yZW1vdmVkID0gMDsNCiANCiAJcmV0dXJuIDA7DQogDQpAQCAtMTQxMiw1
OSArMTQwNSw5MCBAQCBlcnJfZGlzYWJsZV9wZGV2Og0KIHN0YXRpYyBpbnQgX19kZXZpbml0IG1s
eDRfaW5pdF9vbmUoc3RydWN0IHBjaV9kZXYgKnBkZXYsDQogCQkJCSAgIGNvbnN0IHN0cnVjdCBw
Y2lfZGV2aWNlX2lkICppZCkNCiB7DQorCXN0cnVjdCBtbHg0X3ByaXYgKnByaXY7DQorCXN0cnVj
dCBtbHg0X2RldiAqZGV2Ow0KKw0KIAlwcmludGtfb25jZShLRVJOX0lORk8gIiVzIiwgbWx4NF92
ZXJzaW9uKTsNCiANCi0JcmV0dXJuIF9fbWx4NF9pbml0X29uZShwZGV2LCBpZCk7DQorCXByaXYg
PSBremFsbG9jKHNpemVvZigqcHJpdiksIEdGUF9LRVJORUwpOw0KKwlpZiAoIXByaXYpDQorCQly
ZXR1cm4gLUVOT01FTTsNCisNCisJZGV2ICAgICAgID0gJnByaXYtPmRldjsNCisJcGNpX3NldF9k
cnZkYXRhKHBkZXYsIGRldik7DQorCXByaXYtPnBjaV9kZXZfZGF0YSA9IGlkLT5kcml2ZXJfZGF0
YTsNCisNCisJcmV0dXJuIF9fbWx4NF9pbml0X29uZShwZGV2LCBpZC0+ZHJpdmVyX2RhdGEpOw0K
IH0NCiANCi1zdGF0aWMgdm9pZCBtbHg0X3JlbW92ZV9vbmUoc3RydWN0IHBjaV9kZXYgKnBkZXYp
DQorc3RhdGljIHZvaWQgX19tbHg0X3JlbW92ZV9vbmUoc3RydWN0IHBjaV9kZXYgKnBkZXYpDQog
ew0KIAlzdHJ1Y3QgbWx4NF9kZXYgICpkZXYgID0gcGNpX2dldF9kcnZkYXRhKHBkZXYpOw0KIAlz
dHJ1Y3QgbWx4NF9wcml2ICpwcml2ID0gbWx4NF9wcml2KGRldik7DQorCWludCAgICAgICAgICAg
ICAgIHBjaV9kZXZfZGF0YTsNCiAJaW50IHA7DQogDQotCWlmIChkZXYpIHsNCi0JCW1seDRfc3Rv
cF9zZW5zZShkZXYpOw0KLQkJbWx4NF91bnJlZ2lzdGVyX2RldmljZShkZXYpOw0KKwlpZiAocHJp
di0+cmVtb3ZlZCkNCisJCXJldHVybjsNCiANCi0JCWZvciAocCA9IDE7IHAgPD0gZGV2LT5jYXBz
Lm51bV9wb3J0czsgcCsrKSB7DQotCQkJbWx4NF9jbGVhbnVwX3BvcnRfaW5mbygmcHJpdi0+cG9y
dFtwXSk7DQotCQkJbWx4NF9DTE9TRV9QT1JUKGRldiwgcCk7DQotCQl9DQorCXBjaV9kZXZfZGF0
YSA9IHByaXYtPnBjaV9kZXZfZGF0YTsNCiANCi0JCW1seDRfY2xlYW51cF9jb3VudGVyc190YWJs
ZShkZXYpOw0KLQkJbWx4NF9jbGVhbnVwX21jZ190YWJsZShkZXYpOw0KLQkJbWx4NF9jbGVhbnVw
X3FwX3RhYmxlKGRldik7DQotCQltbHg0X2NsZWFudXBfc3JxX3RhYmxlKGRldik7DQotCQltbHg0
X2NsZWFudXBfY3FfdGFibGUoZGV2KTsNCi0JCW1seDRfY21kX3VzZV9wb2xsaW5nKGRldik7DQot
CQltbHg0X2NsZWFudXBfZXFfdGFibGUoZGV2KTsNCi0JCW1seDRfY2xlYW51cF9tcl90YWJsZShk
ZXYpOw0KLQkJbWx4NF9jbGVhbnVwX3hyY2RfdGFibGUoZGV2KTsNCi0JCW1seDRfY2xlYW51cF9w
ZF90YWJsZShkZXYpOw0KLQ0KLQkJaW91bm1hcChwcml2LT5rYXIpOw0KLQkJbWx4NF91YXJfZnJl
ZShkZXYsICZwcml2LT5kcml2ZXJfdWFyKTsNCi0JCW1seDRfY2xlYW51cF91YXJfdGFibGUoZGV2
KTsNCi0JCW1seDRfY2xlYXJfc3RlZXJpbmcoZGV2KTsNCi0JCW1seDRfZnJlZV9lcV90YWJsZShk
ZXYpOw0KLQkJbWx4NF9jbG9zZV9oY2EoZGV2KTsNCi0JCW1seDRfY21kX2NsZWFudXAoZGV2KTsN
Ci0NCi0JCWlmIChkZXYtPmZsYWdzICYgTUxYNF9GTEFHX01TSV9YKQ0KLQkJCXBjaV9kaXNhYmxl
X21zaXgocGRldik7DQotDQotCQlrZnJlZShwcml2KTsNCi0JCXBjaV9yZWxlYXNlX3JlZ2lvbnMo
cGRldik7DQotCQlwY2lfZGlzYWJsZV9kZXZpY2UocGRldik7DQotCQlwY2lfc2V0X2RydmRhdGEo
cGRldiwgTlVMTCk7DQorCW1seDRfc3RvcF9zZW5zZShkZXYpOw0KKwltbHg0X3VucmVnaXN0ZXJf
ZGV2aWNlKGRldik7DQorDQorCWZvciAocCA9IDE7IHAgPD0gZGV2LT5jYXBzLm51bV9wb3J0czsg
cCsrKSB7DQorCQltbHg0X2NsZWFudXBfcG9ydF9pbmZvKCZwcml2LT5wb3J0W3BdKTsNCisJCW1s
eDRfQ0xPU0VfUE9SVChkZXYsIHApOw0KIAl9DQorDQorCW1seDRfY2xlYW51cF9jb3VudGVyc190
YWJsZShkZXYpOw0KKwltbHg0X2NsZWFudXBfbWNnX3RhYmxlKGRldik7DQorCW1seDRfY2xlYW51
cF9xcF90YWJsZShkZXYpOw0KKwltbHg0X2NsZWFudXBfc3JxX3RhYmxlKGRldik7DQorCW1seDRf
Y2xlYW51cF9jcV90YWJsZShkZXYpOw0KKwltbHg0X2NtZF91c2VfcG9sbGluZyhkZXYpOw0KKwlt
bHg0X2NsZWFudXBfZXFfdGFibGUoZGV2KTsNCisJbWx4NF9jbGVhbnVwX21yX3RhYmxlKGRldik7
DQorCW1seDRfY2xlYW51cF94cmNkX3RhYmxlKGRldik7DQorCW1seDRfY2xlYW51cF9wZF90YWJs
ZShkZXYpOw0KKw0KKwlpb3VubWFwKHByaXYtPmthcik7DQorCW1seDRfdWFyX2ZyZWUoZGV2LCAm
cHJpdi0+ZHJpdmVyX3Vhcik7DQorCW1seDRfY2xlYW51cF91YXJfdGFibGUoZGV2KTsNCisJbWx4
NF9jbGVhcl9zdGVlcmluZyhkZXYpOw0KKwltbHg0X2ZyZWVfZXFfdGFibGUoZGV2KTsNCisJbWx4
NF9jbG9zZV9oY2EoZGV2KTsNCisJbWx4NF9jbWRfY2xlYW51cChkZXYpOw0KKw0KKwlpZiAoZGV2
LT5mbGFncyAmIE1MWDRfRkxBR19NU0lfWCkNCisJCXBjaV9kaXNhYmxlX21zaXgocGRldik7DQor
DQorCXBjaV9yZWxlYXNlX3JlZ2lvbnMocGRldik7DQorCXBjaV9kaXNhYmxlX2RldmljZShwZGV2
KTsNCisJbWVtc2V0KHByaXYsIDAsIHNpemVvZigqcHJpdikpOw0KKwlwcml2LT5wY2lfZGV2X2Rh
dGEgPSBwY2lfZGV2X2RhdGE7DQorCXByaXYtPnJlbW92ZWQgPSAxOw0KK30NCisNCitzdGF0aWMg
dm9pZCBtbHg0X3JlbW92ZV9vbmUoc3RydWN0IHBjaV9kZXYgKnBkZXYpDQorew0KKwlzdHJ1Y3Qg
bWx4NF9kZXYgICpkZXYgID0gcGNpX2dldF9kcnZkYXRhKHBkZXYpOw0KKwlzdHJ1Y3QgbWx4NF9w
cml2ICpwcml2ID0gbWx4NF9wcml2KGRldik7DQorDQorCV9fbWx4NF9yZW1vdmVfb25lKHBkZXYp
Ow0KKwlrZnJlZShwcml2KTsNCisJcGNpX3NldF9kcnZkYXRhKHBkZXYsIE5VTEwpOw0KIH0NCiAN
CiBpbnQgbWx4NF9yZXN0YXJ0X29uZShzdHJ1Y3QgcGNpX2RldiAqcGRldikNCiB7DQotCW1seDRf
cmVtb3ZlX29uZShwZGV2KTsNCi0JcmV0dXJuIF9fbWx4NF9pbml0X29uZShwZGV2LCBOVUxMKTsN
CisJc3RydWN0IG1seDRfZGV2ICAqZGV2ICA9IHBjaV9nZXRfZHJ2ZGF0YShwZGV2KTsNCisJc3Ry
dWN0IG1seDRfcHJpdiAqcHJpdiA9IG1seDRfcHJpdihkZXYpOw0KKwlpbnQgICAgICAgICAgICAg
ICBwY2lfZGV2X2RhdGE7DQorDQorCXBjaV9kZXZfZGF0YSA9IHByaXYtPnBjaV9kZXZfZGF0YTsN
CisJX19tbHg0X3JlbW92ZV9vbmUocGRldik7DQorCXJldHVybiBfX21seDRfaW5pdF9vbmUocGRl
diwgcGNpX2Rldl9kYXRhKTsNCiB9DQogDQogc3RhdGljIERFRklORV9QQ0lfREVWSUNFX1RBQkxF
KG1seDRfcGNpX3RhYmxlKSA9IHsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg0L21seDQuaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDQv
bWx4NC5oDQppbmRleCA1ZGZhNjhmLi4xNjk4NTNkIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NC9tbHg0LmgNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDQvbWx4NC5oDQpAQCAtMzI4LDYgKzMyOCw5IEBAIHN0cnVjdCBtbHg0X3By
aXYgew0KIAlzdHJ1Y3QgbGlzdF9oZWFkCWN0eF9saXN0Ow0KIAlzcGlubG9ja190CQljdHhfbG9j
azsNCiANCisJaW50ICAgICAgICAgICAgICAgICAgICAgcGNpX2Rldl9kYXRhOw0KKwlpbnQgICAg
ICAgICAgICAgICAgICAgICByZW1vdmVkOw0KKw0KIAlzdHJ1Y3QgbGlzdF9oZWFkICAgICAgICBw
Z2Rpcl9saXN0Ow0KIAlzdHJ1Y3QgbXV0ZXggICAgICAgICAgICBwZ2Rpcl9tdXRleDsNCiANCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9iNDMveG1pdC5jIGIvZHJpdmVycy9uZXQv
d2lyZWxlc3MvYjQzL3htaXQuYw0KaW5kZXggYzZjMzRiZi4uZThhZmQzNSAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My94bWl0LmMNCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL2I0My94bWl0LmMNCkBAIC04MDgsOSArODA4LDEzIEBAIHZvaWQgYjQzX3J4KHN0cnVjdCBi
NDNfd2xkZXYgKmRldiwgc3RydWN0IHNrX2J1ZmYgKnNrYiwgY29uc3Qgdm9pZCAqX3J4aGRyKQ0K
IAkJYnJlYWs7DQogCWNhc2UgQjQzX1BIWVRZUEVfRzoNCiAJCXN0YXR1cy5iYW5kID0gSUVFRTgw
MjExX0JBTkRfMkdIWjsNCi0JCS8qIGNoYW5pZCBpcyB0aGUgcmFkaW8gY2hhbm5lbCBjb29raWUg
dmFsdWUgYXMgdXNlZA0KLQkJICogdG8gdHVuZSB0aGUgcmFkaW8uICovDQotCQlzdGF0dXMuZnJl
cSA9IGNoYW5pZCArIDI0MDA7DQorCQkvKiBTb21ld2hlcmUgYmV0d2VlbiA0NzguMTA0IGFuZCA1
MDguMTA4NCBmaXJtd2FyZSBmb3IgRy1QSFkNCisJCSAqIGhhcyBiZWVuIG1vZGlmaWVkIHRvIGJl
IGNvbXBhdGlibGUgd2l0aCBOLVBIWSBhbmQgb3RoZXJzLg0KKwkJICovDQorCQlpZiAoZGV2LT5m
dy5yZXYgPj0gNTA4KQ0KKwkJCXN0YXR1cy5mcmVxID0gaWVlZTgwMjExX2NoYW5uZWxfdG9fZnJl
cXVlbmN5KGNoYW5pZCwgc3RhdHVzLmJhbmQpOw0KKwkJZWxzZQ0KKwkJCXN0YXR1cy5mcmVxID0g
Y2hhbmlkICsgMjQwMDsNCiAJCWJyZWFrOw0KIAljYXNlIEI0M19QSFlUWVBFX046DQogCWNhc2Ug
QjQzX1BIWVRZUEVfTFA6DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnQyeDAw
L3J0MngwMG1hYy5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnQyeDAwL3J0MngwMG1hYy5jDQpp
bmRleCAxZDRjNTc5Li5hYjE5OTQ5IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
cnQyeDAwL3J0MngwMG1hYy5jDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9ydDJ4MDAvcnQy
eDAwbWFjLmMNCkBAIC01MTcsNiArNTE3LDggQEAgaW50IHJ0MngwMG1hY19zZXRfa2V5KHN0cnVj
dCBpZWVlODAyMTFfaHcgKmh3LCBlbnVtIHNldF9rZXlfY21kIGNtZCwNCiAJY3J5cHRvLmNpcGhl
ciA9IHJ0MngwMGNyeXB0b19rZXlfdG9fY2lwaGVyKGtleSk7DQogCWlmIChjcnlwdG8uY2lwaGVy
ID09IENJUEhFUl9OT05FKQ0KIAkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KKwlpZiAoY3J5cHRvLmNp
cGhlciA9PSBDSVBIRVJfVEtJUCAmJiBydDJ4MDBfaXNfdXNiKHJ0MngwMGRldikpDQorCQlyZXR1
cm4gLUVPUE5PVFNVUFA7DQogDQogCWNyeXB0by5jbWQgPSBjbWQ7DQogDQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9ydGMvcnRjLWF0OTFybTkyMDAuYyBiL2RyaXZlcnMvcnRjL3J0Yy1hdDkxcm05MjAw
LmMNCmluZGV4IDE1NDA2ZDUuLmZlYWI2OTcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3J0Yy9ydGMt
YXQ5MXJtOTIwMC5jDQorKysgYi9kcml2ZXJzL3J0Yy9ydGMtYXQ5MXJtOTIwMC5jDQpAQCAtMzYs
NiArMzYsNyBAQA0KICNkZWZpbmUgQVQ5MV9SVENfRVBPQ0gJCTE5MDBVTAkvKiBqdXN0IGxpa2Ug
YXJjaC9hcm0vY29tbW9uL3J0Y3RpbWUuYyAqLw0KIA0KIHN0YXRpYyBERUNMQVJFX0NPTVBMRVRJ
T04oYXQ5MV9ydGNfdXBkYXRlZCk7DQorc3RhdGljIERFQ0xBUkVfQ09NUExFVElPTihhdDkxX3J0
Y191cGRfcmR5KTsNCiBzdGF0aWMgdW5zaWduZWQgaW50IGF0OTFfYWxhcm1feWVhciA9IEFUOTFf
UlRDX0VQT0NIOw0KIA0KIC8qDQpAQCAtOTcsNiArOTgsOCBAQCBzdGF0aWMgaW50IGF0OTFfcnRj
X3NldHRpbWUoc3RydWN0IGRldmljZSAqZGV2LCBzdHJ1Y3QgcnRjX3RpbWUgKnRtKQ0KIAkJMTkw
MCArIHRtLT50bV95ZWFyLCB0bS0+dG1fbW9uLCB0bS0+dG1fbWRheSwNCiAJCXRtLT50bV9ob3Vy
LCB0bS0+dG1fbWluLCB0bS0+dG1fc2VjKTsNCiANCisJd2FpdF9mb3JfY29tcGxldGlvbigmYXQ5
MV9ydGNfdXBkX3JkeSk7DQorDQogCS8qIFN0b3AgVGltZS9DYWxlbmRhciBmcm9tIGNvdW50aW5n
ICovDQogCWNyID0gYXQ5MV9zeXNfcmVhZChBVDkxX1JUQ19DUik7DQogCWF0OTFfc3lzX3dyaXRl
KEFUOTFfUlRDX0NSLCBjciB8IEFUOTFfUlRDX1VQRENBTCB8IEFUOTFfUlRDX1VQRFRJTSk7DQpA
QCAtMTE5LDcgKzEyMiw5IEBAIHN0YXRpYyBpbnQgYXQ5MV9ydGNfc2V0dGltZShzdHJ1Y3QgZGV2
aWNlICpkZXYsIHN0cnVjdCBydGNfdGltZSAqdG0pDQogDQogCS8qIFJlc3RhcnQgVGltZS9DYWxl
bmRhciAqLw0KIAljciA9IGF0OTFfc3lzX3JlYWQoQVQ5MV9SVENfQ1IpOw0KKwlhdDkxX3N5c193
cml0ZShBVDkxX1JUQ19TQ0NSLCBBVDkxX1JUQ19TRUNFVik7DQogCWF0OTFfc3lzX3dyaXRlKEFU
OTFfUlRDX0NSLCBjciAmIH4oQVQ5MV9SVENfVVBEQ0FMIHwgQVQ5MV9SVENfVVBEVElNKSk7DQor
CWF0OTFfc3lzX3dyaXRlKEFUOTFfUlRDX0lFUiwgQVQ5MV9SVENfU0VDRVYpOw0KIA0KIAlyZXR1
cm4gMDsNCiB9DQpAQCAtMjI2LDggKzIzMSwxMCBAQCBzdGF0aWMgaXJxcmV0dXJuX3QgYXQ5MV9y
dGNfaW50ZXJydXB0KGludCBpcnEsIHZvaWQgKmRldl9pZCkNCiAJaWYgKHJ0c3IpIHsJCS8qIHRo
aXMgaW50ZXJydXB0IGlzIHNoYXJlZCEgIElzIGl0IG91cnM/ICovDQogCQlpZiAocnRzciAmIEFU
OTFfUlRDX0FMQVJNKQ0KIAkJCWV2ZW50cyB8PSAoUlRDX0FGIHwgUlRDX0lSUUYpOw0KLQkJaWYg
KHJ0c3IgJiBBVDkxX1JUQ19TRUNFVikNCi0JCQlldmVudHMgfD0gKFJUQ19VRiB8IFJUQ19JUlFG
KTsNCisJCWlmIChydHNyICYgQVQ5MV9SVENfU0VDRVYpIHsNCisJCQljb21wbGV0ZSgmYXQ5MV9y
dGNfdXBkX3JkeSk7DQorCQkJYXQ5MV9zeXNfd3JpdGUoQVQ5MV9SVENfSURSLCBBVDkxX1JUQ19T
RUNFVik7DQorCQl9DQogCQlpZiAocnRzciAmIEFUOTFfUlRDX0FDS1VQRCkNCiAJCQljb21wbGV0
ZSgmYXQ5MV9ydGNfdXBkYXRlZCk7DQogDQpAQCAtMjkxLDYgKzI5OCwxMSBAQCBzdGF0aWMgaW50
IF9faW5pdCBhdDkxX3J0Y19wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KIAl9
DQogCXBsYXRmb3JtX3NldF9kcnZkYXRhKHBkZXYsIHJ0Yyk7DQogDQorCS8qIGVuYWJsZSBTRUNF
ViBpbnRlcnJ1cHQgaW4gb3JkZXIgdG8gaW5pdGlhbGl6ZSBhdDkxX3J0Y191cGRfcmR5DQorCSAq
IGNvbXBsZXRpb24uDQorCSAqLw0KKwlhdDkxX3N5c193cml0ZShBVDkxX1JUQ19JRVIsIEFUOTFf
UlRDX1NFQ0VWKTsNCisNCiAJcHJpbnRrKEtFUk5fSU5GTyAiQVQ5MSBSZWFsIFRpbWUgQ2xvY2sg
ZHJpdmVyLlxuIik7DQogCXJldHVybiAwOw0KIH0NCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kv
bWVnYXJhaWQvbWVnYXJhaWRfc2FzLmggYi9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRf
c2FzLmgNCmluZGV4IGRkOTRjN2QuLjA0OWMyMmYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kv
bWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgNCisrKyBiL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXMuaA0KQEAgLTEyOTUsNyArMTI5NSw2IEBAIHN0cnVjdCBtZWdhc2FzX2luc3RhbmNl
IHsNCiAJdTMyICpyZXBseV9xdWV1ZTsNCiAJZG1hX2FkZHJfdCByZXBseV9xdWV1ZV9oOw0KIA0K
LQl1bnNpZ25lZCBsb25nIGJhc2VfYWRkcjsNCiAJc3RydWN0IG1lZ2FzYXNfcmVnaXN0ZXJfc2V0
IF9faW9tZW0gKnJlZ19zZXQ7DQogDQogCXN0cnVjdCBtZWdhc2FzX3BkX2xpc3QgICAgICAgICAg
cGRfbGlzdFtNRUdBU0FTX01BWF9QRF07DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL21lZ2Fy
YWlkL21lZ2FyYWlkX3Nhc19iYXNlLmMgYi9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRf
c2FzX2Jhc2UuYw0KaW5kZXggYjAxODk5Ny4uZTQ1Yzg2NSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
c2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jDQorKysgYi9kcml2ZXJzL3Njc2kvbWVn
YXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2UuYw0KQEAgLTM0OTksNiArMzQ5OSw3IEBAIHN0YXRpYyBp
bnQgbWVnYXNhc19pbml0X2Z3KHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkNCiAJ
dTMyIG1heF9zZWN0b3JzXzE7DQogCXUzMiBtYXhfc2VjdG9yc18yOw0KIAl1MzIgdG1wX3NlY3Rv
cnMsIG1zaXhfZW5hYmxlOw0KKwlyZXNvdXJjZV9zaXplX3QgYmFzZV9hZGRyOw0KIAlzdHJ1Y3Qg
bWVnYXNhc19yZWdpc3Rlcl9zZXQgX19pb21lbSAqcmVnX3NldDsNCiAJc3RydWN0IG1lZ2FzYXNf
Y3RybF9pbmZvICpjdHJsX2luZm87DQogCXVuc2lnbmVkIGxvbmcgYmFyX2xpc3Q7DQpAQCAtMzUw
NywxNCArMzUwOCwxNCBAQCBzdGF0aWMgaW50IG1lZ2FzYXNfaW5pdF9mdyhzdHJ1Y3QgbWVnYXNh
c19pbnN0YW5jZSAqaW5zdGFuY2UpDQogCS8qIEZpbmQgZmlyc3QgbWVtb3J5IGJhciAqLw0KIAli
YXJfbGlzdCA9IHBjaV9zZWxlY3RfYmFycyhpbnN0YW5jZS0+cGRldiwgSU9SRVNPVVJDRV9NRU0p
Ow0KIAlpbnN0YW5jZS0+YmFyID0gZmluZF9maXJzdF9iaXQoJmJhcl9saXN0LCBzaXplb2YodW5z
aWduZWQgbG9uZykpOw0KLQlpbnN0YW5jZS0+YmFzZV9hZGRyID0gcGNpX3Jlc291cmNlX3N0YXJ0
KGluc3RhbmNlLT5wZGV2LCBpbnN0YW5jZS0+YmFyKTsNCiAJaWYgKHBjaV9yZXF1ZXN0X3NlbGVj
dGVkX3JlZ2lvbnMoaW5zdGFuY2UtPnBkZXYsIGluc3RhbmNlLT5iYXIsDQogCQkJCQkgIm1lZ2Fz
YXM6IExTSSIpKSB7DQogCQlwcmludGsoS0VSTl9ERUJVRyAibWVnYXNhczogSU8gbWVtb3J5IHJl
Z2lvbiBidXN5IVxuIik7DQogCQlyZXR1cm4gLUVCVVNZOw0KIAl9DQogDQotCWluc3RhbmNlLT5y
ZWdfc2V0ID0gaW9yZW1hcF9ub2NhY2hlKGluc3RhbmNlLT5iYXNlX2FkZHIsIDgxOTIpOw0KKwli
YXNlX2FkZHIgPSBwY2lfcmVzb3VyY2Vfc3RhcnQoaW5zdGFuY2UtPnBkZXYsIGluc3RhbmNlLT5i
YXIpOw0KKwlpbnN0YW5jZS0+cmVnX3NldCA9IGlvcmVtYXBfbm9jYWNoZShiYXNlX2FkZHIsIDgx
OTIpOw0KIA0KIAlpZiAoIWluc3RhbmNlLT5yZWdfc2V0KSB7DQogCQlwcmludGsoS0VSTl9ERUJV
RyAibWVnYXNhczogRmFpbGVkIHRvIG1hcCBJTyBtZW1cbiIpOw0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc2NzaS9zY3NpX2Vycm9yLmMgYi9kcml2ZXJzL3Njc2kvc2NzaV9lcnJvci5jDQppbmRleCBj
ODM1NzFlLi5kMmY4MDYxIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Njc2lfZXJyb3IuYw0K
KysrIGIvZHJpdmVycy9zY3NpL3Njc2lfZXJyb3IuYw0KQEAgLTkwMiw2ICs5MDIsMTUgQEAgaW50
IHNjc2lfZWhfZ2V0X3NlbnNlKHN0cnVjdCBsaXN0X2hlYWQgKndvcmtfcSwNCiAJCSAgICBTQ1NJ
X1NFTlNFX1ZBTElEKHNjbWQpKQ0KIAkJCWNvbnRpbnVlOw0KIA0KKwkJaWYgKHN0YXR1c19ieXRl
KHNjbWQtPnJlc3VsdCkgIT0gQ0hFQ0tfQ09ORElUSU9OKQ0KKwkJCS8qDQorCQkJICogZG9uJ3Qg
cmVxdWVzdCBzZW5zZSBpZiB0aGVyZSdzIG5vIGNoZWNrIGNvbmRpdGlvbg0KKwkJCSAqIHN0YXR1
cyBiZWNhdXNlIHRoZSBlcnJvciB3ZSdyZSBwcm9jZXNzaW5nIGlzbid0IG9uZQ0KKwkJCSAqIHRo
YXQgaGFzIGEgc2Vuc2UgY29kZSAoYW5kIHNvbWUgZGV2aWNlcyBnZXQNCisJCQkgKiBjb25mdXNl
ZCBieSBzZW5zZSByZXF1ZXN0cyBvdXQgb2YgdGhlIGJsdWUpDQorCQkJICovDQorCQkJY29udGlu
dWU7DQorDQogCQlTQ1NJX0xPR19FUlJPUl9SRUNPVkVSWSgyLCBzY21kX3ByaW50ayhLRVJOX0lO
Rk8sIHNjbWQsDQogCQkJCQkJICAiJXM6IHJlcXVlc3Rpbmcgc2Vuc2VcbiIsDQogCQkJCQkJICBj
dXJyZW50LT5jb21tKSk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Njc2lfbGliLmMgYi9k
cml2ZXJzL3Njc2kvc2NzaV9saWIuYw0KaW5kZXggNmM0YjYyMC4uY2Q0YWMzOCAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvc2NzaS9zY3NpX2xpYi5jDQorKysgYi9kcml2ZXJzL3Njc2kvc2NzaV9saWIu
Yw0KQEAgLTE1NSwxMyArMTU1LDE0IEBAIHN0YXRpYyBpbnQgX19zY3NpX3F1ZXVlX2luc2VydChz
dHJ1Y3Qgc2NzaV9jbW5kICpjbWQsIGludCByZWFzb24sIGludCB1bmJ1c3kpDQogDQogCS8qDQog
CSAqIFJlcXVldWUgdGhpcyBjb21tYW5kLiAgSXQgd2lsbCBnbyBiZWZvcmUgYWxsIG90aGVyIGNv
bW1hbmRzDQotCSAqIHRoYXQgYXJlIGFscmVhZHkgaW4gdGhlIHF1ZXVlLg0KKwkgKiB0aGF0IGFy
ZSBhbHJlYWR5IGluIHRoZSBxdWV1ZS4gU2NoZWR1bGUgcmVxdWV1ZSB3b3JrIHVuZGVyDQorCSAq
IGxvY2sgc3VjaCB0aGF0IHRoZSBrYmxvY2tkX3NjaGVkdWxlX3dvcmsoKSBjYWxsIGhhcHBlbnMN
CisJICogYmVmb3JlIGJsa19jbGVhbnVwX3F1ZXVlKCkgZmluaXNoZXMuDQogCSAqLw0KIAlzcGlu
X2xvY2tfaXJxc2F2ZShxLT5xdWV1ZV9sb2NrLCBmbGFncyk7DQogCWJsa19yZXF1ZXVlX3JlcXVl
c3QocSwgY21kLT5yZXF1ZXN0KTsNCi0Jc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShxLT5xdWV1ZV9s
b2NrLCBmbGFncyk7DQotDQogCWtibG9ja2Rfc2NoZWR1bGVfd29yayhxLCAmZGV2aWNlLT5yZXF1
ZXVlX3dvcmspOw0KKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKHEtPnF1ZXVlX2xvY2ssIGZsYWdz
KTsNCiANCiAJcmV0dXJuIDA7DQogfQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3NpX3Nj
YW4uYyBiL2RyaXZlcnMvc2NzaS9zY3NpX3NjYW4uYw0KaW5kZXggYzZjODBjOS4uMjlmNTc1MSAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS9zY3NpX3NjYW4uYw0KKysrIGIvZHJpdmVycy9zY3Np
L3Njc2lfc2Nhbi5jDQpAQCAtMzMyLDYgKzMzMiw3IEBAIHN0YXRpYyB2b2lkIHNjc2lfdGFyZ2V0
X2Rlc3Ryb3koc3RydWN0IHNjc2lfdGFyZ2V0ICpzdGFyZ2V0KQ0KIAlzdHJ1Y3QgU2NzaV9Ib3N0
ICpzaG9zdCA9IGRldl90b19zaG9zdChkZXYtPnBhcmVudCk7DQogCXVuc2lnbmVkIGxvbmcgZmxh
Z3M7DQogDQorCXN0YXJnZXQtPnN0YXRlID0gU1RBUkdFVF9ERUw7DQogCXRyYW5zcG9ydF9kZXN0
cm95X2RldmljZShkZXYpOw0KIAlzcGluX2xvY2tfaXJxc2F2ZShzaG9zdC0+aG9zdF9sb2NrLCBm
bGFncyk7DQogCWlmIChzaG9zdC0+aG9zdHQtPnRhcmdldF9kZXN0cm95KQ0KQEAgLTM4Myw2ICsz
ODQsMzcgQEAgc3RhdGljIHN0cnVjdCBzY3NpX3RhcmdldCAqX19zY3NpX2ZpbmRfdGFyZ2V0KHN0
cnVjdCBkZXZpY2UgKnBhcmVudCwNCiB9DQogDQogLyoqDQorICogc2NzaV90YXJnZXRfcmVhcF9y
ZWZfcmVsZWFzZSAtIHJlbW92ZSB0YXJnZXQgZnJvbSB2aXNpYmlsaXR5DQorICogQGtyZWY6IHRo
ZSByZWFwX3JlZiBpbiB0aGUgdGFyZ2V0IGJlaW5nIHJlbGVhc2VkDQorICoNCisgKiBDYWxsZWQg
b24gbGFzdCBwdXQgb2YgcmVhcF9yZWYsIHdoaWNoIGlzIHRoZSBpbmRpY2F0aW9uIHRoYXQgbm8g
ZGV2aWNlDQorICogdW5kZXIgdGhpcyB0YXJnZXQgaXMgdmlzaWJsZSBhbnltb3JlLCBzbyByZW5k
ZXIgdGhlIHRhcmdldCBpbnZpc2libGUgaW4NCisgKiBzeXNmcy4gIE5vdGU6IHdlIGhhdmUgdG8g
YmUgaW4gdXNlciBjb250ZXh0IGhlcmUgYmVjYXVzZSB0aGUgdGFyZ2V0IHJlYXBzDQorICogc2hv
dWxkIGJlIGRvbmUgaW4gcGxhY2VzIHdoZXJlIHRoZSBzY3NpIGRldmljZSB2aXNpYmlsaXR5IGlz
IGJlaW5nIHJlbW92ZWQuDQorICovDQorc3RhdGljIHZvaWQgc2NzaV90YXJnZXRfcmVhcF9yZWZf
cmVsZWFzZShzdHJ1Y3Qga3JlZiAqa3JlZikNCit7DQorCXN0cnVjdCBzY3NpX3RhcmdldCAqc3Rh
cmdldA0KKwkJPSBjb250YWluZXJfb2Yoa3JlZiwgc3RydWN0IHNjc2lfdGFyZ2V0LCByZWFwX3Jl
Zik7DQorDQorCS8qDQorCSAqIGlmIHdlIGdldCBoZXJlIGFuZCB0aGUgdGFyZ2V0IGlzIHN0aWxs
IGluIHRoZSBDUkVBVEVEIHN0YXRlIHRoYXQNCisJICogbWVhbnMgaXQgd2FzIGFsbG9jYXRlZCBi
dXQgbmV2ZXIgbWFkZSB2aXNpYmxlIChiZWNhdXNlIGEgc2Nhbg0KKwkgKiB0dXJuZWQgdXAgbm8g
TFVOcyksIHNvIGRvbid0IGNhbGwgZGV2aWNlX2RlbCgpIG9uIGl0Lg0KKwkgKi8NCisJaWYgKHN0
YXJnZXQtPnN0YXRlICE9IFNUQVJHRVRfQ1JFQVRFRCkgew0KKwkJdHJhbnNwb3J0X3JlbW92ZV9k
ZXZpY2UoJnN0YXJnZXQtPmRldik7DQorCQlkZXZpY2VfZGVsKCZzdGFyZ2V0LT5kZXYpOw0KKwl9
DQorCXNjc2lfdGFyZ2V0X2Rlc3Ryb3koc3RhcmdldCk7DQorfQ0KKw0KK3N0YXRpYyB2b2lkIHNj
c2lfdGFyZ2V0X3JlYXBfcmVmX3B1dChzdHJ1Y3Qgc2NzaV90YXJnZXQgKnN0YXJnZXQpDQorew0K
KwlrcmVmX3B1dCgmc3RhcmdldC0+cmVhcF9yZWYsIHNjc2lfdGFyZ2V0X3JlYXBfcmVmX3JlbGVh
c2UpOw0KK30NCisNCisvKioNCiAgKiBzY3NpX2FsbG9jX3RhcmdldCAtIGFsbG9jYXRlIGEgbmV3
IG9yIGZpbmQgYW4gZXhpc3RpbmcgdGFyZ2V0DQogICogQHBhcmVudDoJcGFyZW50IG9mIHRoZSB0
YXJnZXQgKG5lZWQgbm90IGJlIGEgc2NzaSBob3N0KQ0KICAqIEBjaGFubmVsOgl0YXJnZXQgY2hh
bm5lbCBudW1iZXIgKHplcm8gaWYgbm8gY2hhbm5lbHMpDQpAQCAtNDA0LDcgKzQzNiw3IEBAIHN0
YXRpYyBzdHJ1Y3Qgc2NzaV90YXJnZXQgKnNjc2lfYWxsb2NfdGFyZ2V0KHN0cnVjdCBkZXZpY2Ug
KnBhcmVudCwNCiAJCSsgc2hvc3QtPnRyYW5zcG9ydHQtPnRhcmdldF9zaXplOw0KIAlzdHJ1Y3Qg
c2NzaV90YXJnZXQgKnN0YXJnZXQ7DQogCXN0cnVjdCBzY3NpX3RhcmdldCAqZm91bmRfdGFyZ2V0
Ow0KLQlpbnQgZXJyb3I7DQorCWludCBlcnJvciwgcmVmX2dvdDsNCiANCiAJc3RhcmdldCA9IGt6
YWxsb2Moc2l6ZSwgR0ZQX0tFUk5FTCk7DQogCWlmICghc3RhcmdldCkgew0KQEAgLTQxMyw3ICs0
NDUsNyBAQCBzdGF0aWMgc3RydWN0IHNjc2lfdGFyZ2V0ICpzY3NpX2FsbG9jX3RhcmdldChzdHJ1
Y3QgZGV2aWNlICpwYXJlbnQsDQogCX0NCiAJZGV2ID0gJnN0YXJnZXQtPmRldjsNCiAJZGV2aWNl
X2luaXRpYWxpemUoZGV2KTsNCi0Jc3RhcmdldC0+cmVhcF9yZWYgPSAxOw0KKwlrcmVmX2luaXQo
JnN0YXJnZXQtPnJlYXBfcmVmKTsNCiAJZGV2LT5wYXJlbnQgPSBnZXRfZGV2aWNlKHBhcmVudCk7
DQogCWRldl9zZXRfbmFtZShkZXYsICJ0YXJnZXQlZDolZDolZCIsIHNob3N0LT5ob3N0X25vLCBj
aGFubmVsLCBpZCk7DQogCWRldi0+YnVzID0gJnNjc2lfYnVzX3R5cGU7DQpAQCAtNDUzLDI5ICs0
ODUsMzYgQEAgc3RhdGljIHN0cnVjdCBzY3NpX3RhcmdldCAqc2NzaV9hbGxvY190YXJnZXQoc3Ry
dWN0IGRldmljZSAqcGFyZW50LA0KIAlyZXR1cm4gc3RhcmdldDsNCiANCiAgZm91bmQ6DQotCWZv
dW5kX3RhcmdldC0+cmVhcF9yZWYrKzsNCisJLyoNCisJICogcmVsZWFzZSByb3V0aW5lIGFscmVh
ZHkgZmlyZWQgaWYga3JlZiBpcyB6ZXJvLCBzbyBpZiB3ZSBjYW4gc3RpbGwNCisJICogdGFrZSB0
aGUgcmVmZXJlbmNlLCB0aGUgdGFyZ2V0IG11c3QgYmUgYWxpdmUuICBJZiB3ZSBjYW4ndCwgaXQg
bXVzdA0KKwkgKiBiZSBkeWluZyBhbmQgd2UgbmVlZCB0byB3YWl0IGZvciBhIG5ldyB0YXJnZXQN
CisJICovDQorCXJlZl9nb3QgPSBrcmVmX2dldF91bmxlc3NfemVybygmZm91bmRfdGFyZ2V0LT5y
ZWFwX3JlZik7DQorDQogCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoc2hvc3QtPmhvc3RfbG9jaywg
ZmxhZ3MpOw0KLQlpZiAoZm91bmRfdGFyZ2V0LT5zdGF0ZSAhPSBTVEFSR0VUX0RFTCkgew0KKwlp
ZiAocmVmX2dvdCkgew0KIAkJcHV0X2RldmljZShkZXYpOw0KIAkJcmV0dXJuIGZvdW5kX3Rhcmdl
dDsNCiAJfQ0KLQkvKiBVbmZvcnR1bmF0ZWx5LCB3ZSBmb3VuZCBhIGR5aW5nIHRhcmdldDsgbmVl
ZCB0bw0KLQkgKiB3YWl0IHVudGlsIGl0J3MgZGVhZCBiZWZvcmUgd2UgY2FuIGdldCBhIG5ldyBv
bmUgKi8NCisJLyoNCisJICogVW5mb3J0dW5hdGVseSwgd2UgZm91bmQgYSBkeWluZyB0YXJnZXQ7
IG5lZWQgdG8gd2FpdCB1bnRpbCBpdCdzDQorCSAqIGRlYWQgYmVmb3JlIHdlIGNhbiBnZXQgYSBu
ZXcgb25lLiAgVGhlcmUgaXMgYW4gYW5vbWFseSBoZXJlLiAgV2UNCisJICogKnNob3VsZCogY2Fs
bCBzY3NpX3RhcmdldF9yZWFwKCkgdG8gYmFsYW5jZSB0aGUga3JlZl9nZXQoKSBvZiB0aGUNCisJ
ICogcmVhcF9yZWYgYWJvdmUuICBIb3dldmVyLCBzaW5jZSB0aGUgdGFyZ2V0IGJlaW5nIHJlbGVh
c2VkLCBpdCdzDQorCSAqIGFscmVhZHkgaW52aXNpYmxlIGFuZCB0aGUgcmVhcF9yZWYgaXMgaXJy
ZWxldmFudC4gIElmIHdlIGNhbGwNCisJICogc2NzaV90YXJnZXRfcmVhcCgpIHdlIG1pZ2h0IHNw
dXJpb3VzbHkgZG8gYW5vdGhlciBkZXZpY2VfZGVsKCkgb24NCisJICogYW4gYWxyZWFkeSBpbnZp
c2libGUgdGFyZ2V0Lg0KKwkgKi8NCiAJcHV0X2RldmljZSgmZm91bmRfdGFyZ2V0LT5kZXYpOw0K
LQlmbHVzaF9zY2hlZHVsZWRfd29yaygpOw0KKwkvKg0KKwkgKiBsZW5ndGggb2YgdGltZSBpcyBp
cnJlbGV2YW50IGhlcmUsIHdlIGp1c3Qgd2FudCB0byB5aWVsZCB0aGUgQ1BVDQorCSAqIGZvciBh
IHRpY2sgdG8gYXZvaWQgYnVzeSB3YWl0aW5nIGZvciB0aGUgdGFyZ2V0IHRvIGRpZS4NCisJICov
DQorCW1zbGVlcCgxKTsNCiAJZ290byByZXRyeTsNCiB9DQogDQotc3RhdGljIHZvaWQgc2NzaV90
YXJnZXRfcmVhcF91c2VyY29udGV4dChzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQotew0KLQlz
dHJ1Y3Qgc2NzaV90YXJnZXQgKnN0YXJnZXQgPQ0KLQkJY29udGFpbmVyX29mKHdvcmssIHN0cnVj
dCBzY3NpX3RhcmdldCwgZXcud29yayk7DQotDQotCXRyYW5zcG9ydF9yZW1vdmVfZGV2aWNlKCZz
dGFyZ2V0LT5kZXYpOw0KLQlkZXZpY2VfZGVsKCZzdGFyZ2V0LT5kZXYpOw0KLQlzY3NpX3Rhcmdl
dF9kZXN0cm95KHN0YXJnZXQpOw0KLX0NCi0NCiAvKioNCiAgKiBzY3NpX3RhcmdldF9yZWFwIC0g
Y2hlY2sgdG8gc2VlIGlmIHRhcmdldCBpcyBpbiB1c2UgYW5kIGRlc3Ryb3kgaWYgbm90DQogICog
QHN0YXJnZXQ6IHRhcmdldCB0byBiZSBjaGVja2VkDQpAQCAtNDg2LDI4ICs1MjUsMTMgQEAgc3Rh
dGljIHZvaWQgc2NzaV90YXJnZXRfcmVhcF91c2VyY29udGV4dChzdHJ1Y3Qgd29ya19zdHJ1Y3Qg
KndvcmspDQogICovDQogdm9pZCBzY3NpX3RhcmdldF9yZWFwKHN0cnVjdCBzY3NpX3RhcmdldCAq
c3RhcmdldCkNCiB7DQotCXN0cnVjdCBTY3NpX0hvc3QgKnNob3N0ID0gZGV2X3RvX3Nob3N0KHN0
YXJnZXQtPmRldi5wYXJlbnQpOw0KLQl1bnNpZ25lZCBsb25nIGZsYWdzOw0KLQllbnVtIHNjc2lf
dGFyZ2V0X3N0YXRlIHN0YXRlOw0KLQlpbnQgZW1wdHkgPSAwOw0KLQ0KLQlzcGluX2xvY2tfaXJx
c2F2ZShzaG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQotCXN0YXRlID0gc3RhcmdldC0+c3RhdGU7
DQotCWlmICgtLXN0YXJnZXQtPnJlYXBfcmVmID09IDAgJiYgbGlzdF9lbXB0eSgmc3RhcmdldC0+
ZGV2aWNlcykpIHsNCi0JCWVtcHR5ID0gMTsNCi0JCXN0YXJnZXQtPnN0YXRlID0gU1RBUkdFVF9E
RUw7DQotCX0NCi0Jc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShzaG9zdC0+aG9zdF9sb2NrLCBmbGFn
cyk7DQotDQotCWlmICghZW1wdHkpDQotCQlyZXR1cm47DQotDQotCUJVR19PTihzdGF0ZSA9PSBT
VEFSR0VUX0RFTCk7DQotCWlmIChzdGF0ZSA9PSBTVEFSR0VUX0NSRUFURUQpDQotCQlzY3NpX3Rh
cmdldF9kZXN0cm95KHN0YXJnZXQpOw0KLQllbHNlDQotCQlleGVjdXRlX2luX3Byb2Nlc3NfY29u
dGV4dChzY3NpX3RhcmdldF9yZWFwX3VzZXJjb250ZXh0LA0KLQkJCQkJICAgJnN0YXJnZXQtPmV3
KTsNCisJLyoNCisJICogc2VyaW91cyBwcm9ibGVtIGlmIHRoaXMgdHJpZ2dlcnM6IFNUQVJHRVRf
REVMIGlzIG9ubHkgc2V0IGluIHRoZSBpZg0KKwkgKiB0aGUgcmVhcF9yZWYgZHJvcHMgdG8gemVy
bywgc28gd2UncmUgdHJ5aW5nIHRvIGRvIGFub3RoZXIgZmluYWwgcHV0DQorCSAqIG9uIGFuIGFs
cmVhZHkgcmVsZWFzZWQga3JlZg0KKwkgKi8NCisJQlVHX09OKHN0YXJnZXQtPnN0YXRlID09IFNU
QVJHRVRfREVMKTsNCisJc2NzaV90YXJnZXRfcmVhcF9yZWZfcHV0KHN0YXJnZXQpOw0KIH0NCiAN
CiAvKioNCkBAIC0xNTMyLDYgKzE1NTYsMTAgQEAgc3RydWN0IHNjc2lfZGV2aWNlICpfX3Njc2lf
YWRkX2RldmljZShzdHJ1Y3QgU2NzaV9Ib3N0ICpzaG9zdCwgdWludCBjaGFubmVsLA0KIAl9DQog
CW11dGV4X3VubG9jaygmc2hvc3QtPnNjYW5fbXV0ZXgpOw0KIAlzY3NpX2F1dG9wbV9wdXRfdGFy
Z2V0KHN0YXJnZXQpOw0KKwkvKg0KKwkgKiBwYWlyZWQgd2l0aCBzY3NpX2FsbG9jX3RhcmdldCgp
LiAgVGFyZ2V0IHdpbGwgYmUgZGVzdHJveWVkIHVubGVzcw0KKwkgKiBzY3NpX3Byb2JlX2FuZF9h
ZGRfbHVuIG1hZGUgYW4gdW5kZXJseWluZyBkZXZpY2UgdmlzaWJsZQ0KKwkgKi8NCiAJc2NzaV90
YXJnZXRfcmVhcChzdGFyZ2V0KTsNCiAJcHV0X2RldmljZSgmc3RhcmdldC0+ZGV2KTsNCiANCkBA
IC0xNjEyLDggKzE2NDAsMTAgQEAgc3RhdGljIHZvaWQgX19zY3NpX3NjYW5fdGFyZ2V0KHN0cnVj
dCBkZXZpY2UgKnBhcmVudCwgdW5zaWduZWQgaW50IGNoYW5uZWwsDQogDQogIG91dF9yZWFwOg0K
IAlzY3NpX2F1dG9wbV9wdXRfdGFyZ2V0KHN0YXJnZXQpOw0KLQkvKiBub3cgZGV0ZXJtaW5lIGlm
IHRoZSB0YXJnZXQgaGFzIGFueSBjaGlsZHJlbiBhdCBhbGwNCi0JICogYW5kIGlmIG5vdCwgbnVr
ZSBpdCAqLw0KKwkvKg0KKwkgKiBwYWlyZWQgd2l0aCBzY3NpX2FsbG9jX3RhcmdldCgpOiBkZXRl
cm1pbmUgaWYgdGhlIHRhcmdldCBoYXMNCisJICogYW55IGNoaWxkcmVuIGF0IGFsbCBhbmQgaWYg
bm90LCBudWtlIGl0DQorCSAqLw0KIAlzY3NpX3RhcmdldF9yZWFwKHN0YXJnZXQpOw0KIA0KIAlw
dXRfZGV2aWNlKCZzdGFyZ2V0LT5kZXYpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3Np
X3N5c2ZzLmMgYi9kcml2ZXJzL3Njc2kvc2NzaV9zeXNmcy5jDQppbmRleCA3MmNhNTE1Li44OGJj
ODJlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Njc2lfc3lzZnMuYw0KKysrIGIvZHJpdmVy
cy9zY3NpL3Njc2lfc3lzZnMuYw0KQEAgLTMzMSwxNyArMzMxLDE0IEBAIHN0YXRpYyB2b2lkIHNj
c2lfZGV2aWNlX2Rldl9yZWxlYXNlX3VzZXJjb250ZXh0KHN0cnVjdCB3b3JrX3N0cnVjdCAqd29y
aykNCiB7DQogCXN0cnVjdCBzY3NpX2RldmljZSAqc2RldjsNCiAJc3RydWN0IGRldmljZSAqcGFy
ZW50Ow0KLQlzdHJ1Y3Qgc2NzaV90YXJnZXQgKnN0YXJnZXQ7DQogCXN0cnVjdCBsaXN0X2hlYWQg
KnRoaXMsICp0bXA7DQogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQogDQogCXNkZXYgPSBjb250YWlu
ZXJfb2Yod29yaywgc3RydWN0IHNjc2lfZGV2aWNlLCBldy53b3JrKTsNCiANCiAJcGFyZW50ID0g
c2Rldi0+c2Rldl9nZW5kZXYucGFyZW50Ow0KLQlzdGFyZ2V0ID0gdG9fc2NzaV90YXJnZXQocGFy
ZW50KTsNCiANCiAJc3Bpbl9sb2NrX2lycXNhdmUoc2Rldi0+aG9zdC0+aG9zdF9sb2NrLCBmbGFn
cyk7DQotCXN0YXJnZXQtPnJlYXBfcmVmKys7DQogCWxpc3RfZGVsKCZzZGV2LT5zaWJsaW5ncyk7
DQogCWxpc3RfZGVsKCZzZGV2LT5zYW1lX3RhcmdldF9zaWJsaW5ncyk7DQogCWxpc3RfZGVsKCZz
ZGV2LT5zdGFydmVkX2VudHJ5KTsNCkBAIC0zNjEsOCArMzU4LDYgQEAgc3RhdGljIHZvaWQgc2Nz
aV9kZXZpY2VfZGV2X3JlbGVhc2VfdXNlcmNvbnRleHQoc3RydWN0IHdvcmtfc3RydWN0ICp3b3Jr
KQ0KIAkvKiBOVUxMIHF1ZXVlIG1lYW5zIHRoZSBkZXZpY2UgY2FuJ3QgYmUgdXNlZCAqLw0KIAlz
ZGV2LT5yZXF1ZXN0X3F1ZXVlID0gTlVMTDsNCiANCi0Jc2NzaV90YXJnZXRfcmVhcChzY3NpX3Rh
cmdldChzZGV2KSk7DQotDQogCWtmcmVlKHNkZXYtPmlucXVpcnkpOw0KIAlrZnJlZShzZGV2KTsN
CiANCkBAIC05NjMsMTMgKzk1OCwyNyBAQCB2b2lkIF9fc2NzaV9yZW1vdmVfZGV2aWNlKHN0cnVj
dCBzY3NpX2RldmljZSAqc2RldikNCiAJCWRldmljZV9kZWwoZGV2KTsNCiAJfSBlbHNlDQogCQlw
dXRfZGV2aWNlKCZzZGV2LT5zZGV2X2Rldik7DQorDQorCS8qDQorCSAqIFN0b3AgYWNjZXB0aW5n
IG5ldyByZXF1ZXN0cyBhbmQgd2FpdCB1bnRpbCBhbGwgcXVldWVjb21tYW5kKCkgYW5kDQorCSAq
IHNjc2lfcnVuX3F1ZXVlKCkgaW52b2NhdGlvbnMgaGF2ZSBmaW5pc2hlZCBiZWZvcmUgdGVhcmlu
ZyBkb3duIHRoZQ0KKwkgKiBkZXZpY2UuDQorCSAqLw0KIAlzY3NpX2RldmljZV9zZXRfc3RhdGUo
c2RldiwgU0RFVl9ERUwpOw0KKwlibGtfY2xlYW51cF9xdWV1ZShzZGV2LT5yZXF1ZXN0X3F1ZXVl
KTsNCisJY2FuY2VsX3dvcmtfc3luYygmc2Rldi0+cmVxdWV1ZV93b3JrKTsNCisNCiAJaWYgKHNk
ZXYtPmhvc3QtPmhvc3R0LT5zbGF2ZV9kZXN0cm95KQ0KIAkJc2Rldi0+aG9zdC0+aG9zdHQtPnNs
YXZlX2Rlc3Ryb3koc2Rldik7DQogCXRyYW5zcG9ydF9kZXN0cm95X2RldmljZShkZXYpOw0KIA0K
LQkvKiBGcmVlaW5nIHRoZSBxdWV1ZSBzaWduYWxzIHRvIGJsb2NrIHRoYXQgd2UncmUgZG9uZSAq
Lw0KLQlibGtfY2xlYW51cF9xdWV1ZShzZGV2LT5yZXF1ZXN0X3F1ZXVlKTsNCisJLyoNCisJICog
UGFpcmVkIHdpdGggdGhlIGtyZWZfZ2V0KCkgaW4gc2NzaV9zeXNmc19pbml0aWFsaXplKCkuICBX
ZSBoYXZlDQorCSAqIHJlbW9lZCBzeXNmcyB2aXNpYmlsaXR5IGZyb20gdGhlIGRldmljZSwgc28g
bWFrZSB0aGUgdGFyZ2V0DQorCSAqIGludmlzaWJsZSBpZiB0aGlzIHdhcyB0aGUgbGFzdCBkZXZp
Y2UgdW5kZXJuZWF0aCBpdC4NCisJICovDQorCXNjc2lfdGFyZ2V0X3JlYXAoc2NzaV90YXJnZXQo
c2RldikpOw0KKw0KIAlwdXRfZGV2aWNlKGRldik7DQogfQ0KIA0KQEAgLTEwMzIsNyArMTA0MSw3
IEBAIHZvaWQgc2NzaV9yZW1vdmVfdGFyZ2V0KHN0cnVjdCBkZXZpY2UgKmRldikNCiAJCQljb250
aW51ZTsNCiAJCWlmIChzdGFyZ2V0LT5kZXYucGFyZW50ID09IGRldiB8fCAmc3RhcmdldC0+ZGV2
ID09IGRldikgew0KIAkJCS8qIGFzc3VtaW5nIG5ldyB0YXJnZXRzIGFycml2ZSBhdCB0aGUgZW5k
ICovDQotCQkJc3RhcmdldC0+cmVhcF9yZWYrKzsNCisJCQlrcmVmX2dldCgmc3RhcmdldC0+cmVh
cF9yZWYpOw0KIAkJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoc2hvc3QtPmhvc3RfbG9jaywgZmxh
Z3MpOw0KIAkJCWlmIChsYXN0KQ0KIAkJCQlzY3NpX3RhcmdldF9yZWFwKGxhc3QpOw0KQEAgLTEx
MTYsNiArMTEyNSwxMiBAQCB2b2lkIHNjc2lfc3lzZnNfZGV2aWNlX2luaXRpYWxpemUoc3RydWN0
IHNjc2lfZGV2aWNlICpzZGV2KQ0KIAlsaXN0X2FkZF90YWlsKCZzZGV2LT5zYW1lX3RhcmdldF9z
aWJsaW5ncywgJnN0YXJnZXQtPmRldmljZXMpOw0KIAlsaXN0X2FkZF90YWlsKCZzZGV2LT5zaWJs
aW5ncywgJnNob3N0LT5fX2RldmljZXMpOw0KIAlzcGluX3VubG9ja19pcnFyZXN0b3JlKHNob3N0
LT5ob3N0X2xvY2ssIGZsYWdzKTsNCisJLyoNCisJICogZGV2aWNlIGNhbiBub3cgb25seSBiZSBy
ZW1vdmVkIHZpYSBfX3Njc2lfcmVtb3ZlX2RldmljZSgpIHNvIGhvbGQNCisJICogdGhlIHRhcmdl
dC4gIFRhcmdldCB3aWxsIGJlIGhlbGQgaW4gQ1JFQVRFRCBzdGF0ZSB1bnRpbCBzb21ldGhpbmcN
CisJICogYmVuZWF0aCBpdCBiZWNvbWVzIHZpc2libGUgKGluIHdoaWNoIGNhc2UgaXQgbW92ZXMg
dG8gUlVOTklORykNCisJICovDQorCWtyZWZfZ2V0KCZzdGFyZ2V0LT5yZWFwX3JlZik7DQogfQ0K
IA0KIGludCBzY3NpX2lzX3NkZXZfZGV2aWNlKGNvbnN0IHN0cnVjdCBkZXZpY2UgKmRldikNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3RhcmdldC9pc2NzaS9pc2NzaV90YXJnZXRfYXV0aC5jIGIvZHJp
dmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0X2F1dGguYw0KaW5kZXggNTllNzM3OC4uMzJl
YjZiNCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdGFyZ2V0L2lzY3NpL2lzY3NpX3RhcmdldF9hdXRo
LmMNCisrKyBiL2RyaXZlcnMvdGFyZ2V0L2lzY3NpL2lzY3NpX3RhcmdldF9hdXRoLmMNCkBAIC0z
MzcsNiArMzM3LDE2IEBAIHN0YXRpYyBpbnQgY2hhcF9zZXJ2ZXJfY29tcHV0ZV9tZDUoDQogCQln
b3RvIG91dDsNCiAJfQ0KIAkvKg0KKwkgKiBEdXJpbmcgbXV0dWFsIGF1dGhlbnRpY2F0aW9uLCB0
aGUgQ0hBUF9DIGdlbmVyYXRlZCBieSB0aGUNCisJICogaW5pdGlhdG9yIG11c3Qgbm90IG1hdGNo
IHRoZSBvcmlnaW5hbCBDSEFQX0MgZ2VuZXJhdGVkIGJ5DQorCSAqIHRoZSB0YXJnZXQuDQorCSAq
Lw0KKwlpZiAoIW1lbWNtcChjaGFsbGVuZ2VfYmluaGV4LCBjaGFwLT5jaGFsbGVuZ2UsIENIQVBf
Q0hBTExFTkdFX0xFTkdUSCkpIHsNCisJCXByX2VycigiaW5pdGlhdG9yIENIQVBfQyBtYXRjaGVz
IHRhcmdldCBDSEFQX0MsIGZhaWxpbmciDQorCQkgICAgICAgIiBsb2dpbiBhdHRlbXB0XG4iKTsN
CisJCWdvdG8gb3V0Ow0KKwl9DQorCS8qDQogCSAqIEdlbmVyYXRlIENIQVBfTiBhbmQgQ0hBUF9S
IGZvciBtdXR1YWwgYXV0aGVudGljYXRpb24uDQogCSAqLw0KIAl0Zm0gPSBjcnlwdG9fYWxsb2Nf
aGFzaCgibWQ1IiwgMCwgQ1JZUFRPX0FMR19BU1lOQyk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy90
YXJnZXQvdGFyZ2V0X2NvcmVfZGV2aWNlLmMgYi9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV9k
ZXZpY2UuYw0KaW5kZXggNWRlZjM1OS4uNjk5Mzk2MSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdGFy
Z2V0L3RhcmdldF9jb3JlX2RldmljZS5jDQorKysgYi9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29y
ZV9kZXZpY2UuYw0KQEAgLTY0Niw2ICs2NDYsNyBAQCB2b2lkIGNvcmVfZGV2X3VuZXhwb3J0KA0K
IAlzcGluX3VubG9jaygmZGV2LT5zZV9wb3J0X2xvY2spOw0KIA0KIAlzZV9kZXZfc3RvcChkZXYp
Ow0KKwlsdW4tPmx1bl9zZXAgPSBOVUxMOw0KIAlsdW4tPmx1bl9zZV9kZXYgPSBOVUxMOw0KIH0N
CiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV9yZC5jIGIvZHJpdmVy
cy90YXJnZXQvdGFyZ2V0X2NvcmVfcmQuYw0KaW5kZXggMDJlNTFmYS4uNmM3ODg2YiAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3JkLmMNCisrKyBiL2RyaXZlcnMvdGFy
Z2V0L3RhcmdldF9jb3JlX3JkLmMNCkBAIC0xNzksNyArMTc5LDcgQEAgc3RhdGljIGludCByZF9i
dWlsZF9kZXZpY2Vfc3BhY2Uoc3RydWN0IHJkX2RldiAqcmRfZGV2KQ0KIAkJCQkJCS0gMTsNCiAN
CiAJCWZvciAoaiA9IDA7IGogPCBzZ19wZXJfdGFibGU7IGorKykgew0KLQkJCXBnID0gYWxsb2Nf
cGFnZXMoR0ZQX0tFUk5FTCwgMCk7DQorCQkJcGcgPSBhbGxvY19wYWdlcyhHRlBfS0VSTkVMIHwg
X19HRlBfWkVSTywgMCk7DQogCQkJaWYgKCFwZykgew0KIAkJCQlwcl9lcnIoIlVuYWJsZSB0byBh
bGxvY2F0ZSBzY2F0dGVybGlzdCINCiAJCQkJCSIgcGFnZXMgZm9yIHN0cnVjdCByZF9kZXZfc2df
dGFibGVcbiIpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2NsYXNzL2NkYy1hY20uYyBiL2Ry
aXZlcnMvdXNiL2NsYXNzL2NkYy1hY20uYw0KaW5kZXggMzIwZGIyYS4uMjllNzZiZSAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvdXNiL2NsYXNzL2NkYy1hY20uYw0KKysrIGIvZHJpdmVycy91c2IvY2xh
c3MvY2RjLWFjbS5jDQpAQCAtNzIsMTMgKzcyLDIzIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdHR5
X3BvcnRfb3BlcmF0aW9ucyBhY21fcG9ydF9vcHMgPSB7DQogc3RhdGljIGludCBhY21fY3RybF9t
c2coc3RydWN0IGFjbSAqYWNtLCBpbnQgcmVxdWVzdCwgaW50IHZhbHVlLA0KIAkJCQkJCQl2b2lk
ICpidWYsIGludCBsZW4pDQogew0KLQlpbnQgcmV0dmFsID0gdXNiX2NvbnRyb2xfbXNnKGFjbS0+
ZGV2LCB1c2Jfc25kY3RybHBpcGUoYWNtLT5kZXYsIDApLA0KKwlpbnQgcmV0dmFsOw0KKw0KKwly
ZXR2YWwgPSB1c2JfYXV0b3BtX2dldF9pbnRlcmZhY2UoYWNtLT5jb250cm9sKTsNCisJaWYgKHJl
dHZhbCkNCisJCXJldHVybiByZXR2YWw7DQorDQorCXJldHZhbCA9IHVzYl9jb250cm9sX21zZyhh
Y20tPmRldiwgdXNiX3NuZGN0cmxwaXBlKGFjbS0+ZGV2LCAwKSwNCiAJCXJlcXVlc3QsIFVTQl9S
VF9BQ00sIHZhbHVlLA0KIAkJYWNtLT5jb250cm9sLT5hbHRzZXR0aW5nWzBdLmRlc2MuYkludGVy
ZmFjZU51bWJlciwNCiAJCWJ1ZiwgbGVuLCA1MDAwKTsNCisNCiAJZGV2X2RiZygmYWNtLT5jb250
cm9sLT5kZXYsDQogCQkJIiVzIC0gcnEgMHglMDJ4LCB2YWwgJSN4LCBsZW4gJSN4LCByZXN1bHQg
JWRcbiIsDQogCQkJX19mdW5jX18sIHJlcXVlc3QsIHZhbHVlLCBsZW4sIHJldHZhbCk7DQorDQor
CXVzYl9hdXRvcG1fcHV0X2ludGVyZmFjZShhY20tPmNvbnRyb2wpOw0KKw0KIAlyZXR1cm4gcmV0
dmFsIDwgMCA/IHJldHZhbCA6IDA7DQogfQ0KIA0KQEAgLTE4MSwxNCArMTkxLDE3IEBAIHN0YXRp
YyBpbnQgYWNtX3dyaXRlX3N0YXJ0KHN0cnVjdCBhY20gKmFjbSwgaW50IHdibikNCiANCiAJZGV2
X3ZkYmcoJmFjbS0+ZGF0YS0+ZGV2LCAiJXMgLSBzdXNwX2NvdW50ICVkXG4iLCBfX2Z1bmNfXywN
CiAJCQkJCQkJYWNtLT5zdXNwX2NvdW50KTsNCi0JdXNiX2F1dG9wbV9nZXRfaW50ZXJmYWNlX2Fz
eW5jKGFjbS0+Y29udHJvbCk7DQorCXJjID0gdXNiX2F1dG9wbV9nZXRfaW50ZXJmYWNlX2FzeW5j
KGFjbS0+Y29udHJvbCk7DQorCWlmIChyYykgew0KKwkJd2ItPnVzZSA9IDA7DQorCQlzcGluX3Vu
bG9ja19pcnFyZXN0b3JlKCZhY20tPndyaXRlX2xvY2ssIGZsYWdzKTsNCisJCXJldHVybiByYzsN
CisJfQ0KKw0KIAlpZiAoYWNtLT5zdXNwX2NvdW50KSB7DQotCQlpZiAoIWFjbS0+ZGVsYXllZF93
YikNCi0JCQlhY20tPmRlbGF5ZWRfd2IgPSB3YjsNCi0JCWVsc2UNCi0JCQl1c2JfYXV0b3BtX3B1
dF9pbnRlcmZhY2VfYXN5bmMoYWNtLT5jb250cm9sKTsNCisJCXVzYl9hbmNob3JfdXJiKHdiLT51
cmIsICZhY20tPmRlbGF5ZWQpOw0KIAkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmYWNtLT53cml0
ZV9sb2NrLCBmbGFncyk7DQotCQlyZXR1cm4gMDsJLyogQSB3aGl0ZSBsaWUgKi8NCisJCXJldHVy
biAwOw0KIAl9DQogCXVzYl9tYXJrX2xhc3RfYnVzeShhY20tPmRldik7DQogDQpAQCAtNTQ1LDEx
ICs1NTgsMjMgQEAgc3RhdGljIHZvaWQgYWNtX3R0eV91bnJlZ2lzdGVyKHN0cnVjdCBhY20gKmFj
bSkNCiANCiBzdGF0aWMgdm9pZCBhY21fcG9ydF9kb3duKHN0cnVjdCBhY20gKmFjbSkNCiB7DQor
CXN0cnVjdCB1cmIgKnVyYjsNCisJc3RydWN0IGFjbV93YiAqd2I7DQogCWludCBpOw0KIA0KIAlp
ZiAoYWNtLT5kZXYpIHsNCiAJCXVzYl9hdXRvcG1fZ2V0X2ludGVyZmFjZShhY20tPmNvbnRyb2wp
Ow0KIAkJYWNtX3NldF9jb250cm9sKGFjbSwgYWNtLT5jdHJsb3V0ID0gMCk7DQorDQorCQlmb3Ig
KDs7KSB7DQorCQkJdXJiID0gdXNiX2dldF9mcm9tX2FuY2hvcigmYWNtLT5kZWxheWVkKTsNCisJ
CQlpZiAoIXVyYikNCisJCQkJYnJlYWs7DQorCQkJd2IgPSB1cmItPmNvbnRleHQ7DQorCQkJd2It
PnVzZSA9IDA7DQorCQkJdXNiX2F1dG9wbV9wdXRfaW50ZXJmYWNlX2FzeW5jKGFjbS0+Y29udHJv
bCk7DQorCQl9DQorDQogCQl1c2Jfa2lsbF91cmIoYWNtLT5jdHJsdXJiKTsNCiAJCWZvciAoaSA9
IDA7IGkgPCBBQ01fTlc7IGkrKykNCiAJCQl1c2Jfa2lsbF91cmIoYWNtLT53YltpXS51cmIpOw0K
QEAgLTExMTIsNiArMTEzNyw3IEBAIG1hZGVfY29tcHJlc3NlZF9wcm9iZToNCiAJCWFjbS0+Yklu
dGVydmFsID0gZXByZWFkLT5iSW50ZXJ2YWw7DQogCXR0eV9wb3J0X2luaXQoJmFjbS0+cG9ydCk7
DQogCWFjbS0+cG9ydC5vcHMgPSAmYWNtX3BvcnRfb3BzOw0KKwlpbml0X3VzYl9hbmNob3IoJmFj
bS0+ZGVsYXllZCk7DQogDQogCWJ1ZiA9IHVzYl9hbGxvY19jb2hlcmVudCh1c2JfZGV2LCBjdHJs
c2l6ZSwgR0ZQX0tFUk5FTCwgJmFjbS0+Y3RybF9kbWEpOw0KIAlpZiAoIWJ1Zikgew0KQEAgLTEz
MzgsMTggKzEzNjQsMTUgQEAgc3RhdGljIGludCBhY21fc3VzcGVuZChzdHJ1Y3QgdXNiX2ludGVy
ZmFjZSAqaW50ZiwgcG1fbWVzc2FnZV90IG1lc3NhZ2UpDQogCXN0cnVjdCBhY20gKmFjbSA9IHVz
Yl9nZXRfaW50ZmRhdGEoaW50Zik7DQogCWludCBjbnQ7DQogDQorCXNwaW5fbG9ja19pcnEoJmFj
bS0+cmVhZF9sb2NrKTsNCisJc3Bpbl9sb2NrKCZhY20tPndyaXRlX2xvY2spOw0KIAlpZiAoUE1T
R19JU19BVVRPKG1lc3NhZ2UpKSB7DQotCQlpbnQgYjsNCi0NCi0JCXNwaW5fbG9ja19pcnEoJmFj
bS0+d3JpdGVfbG9jayk7DQotCQliID0gYWNtLT50cmFuc21pdHRpbmc7DQotCQlzcGluX3VubG9j
a19pcnEoJmFjbS0+d3JpdGVfbG9jayk7DQotCQlpZiAoYikNCisJCWlmIChhY20tPnRyYW5zbWl0
dGluZykgew0KKwkJCXNwaW5fdW5sb2NrKCZhY20tPndyaXRlX2xvY2spOw0KKwkJCXNwaW5fdW5s
b2NrX2lycSgmYWNtLT5yZWFkX2xvY2spOw0KIAkJCXJldHVybiAtRUJVU1k7DQorCQl9DQogCX0N
Ci0NCi0Jc3Bpbl9sb2NrX2lycSgmYWNtLT5yZWFkX2xvY2spOw0KLQlzcGluX2xvY2soJmFjbS0+
d3JpdGVfbG9jayk7DQogCWNudCA9IGFjbS0+c3VzcF9jb3VudCsrOw0KIAlzcGluX3VubG9jaygm
YWNtLT53cml0ZV9sb2NrKTsNCiAJc3Bpbl91bmxvY2tfaXJxKCZhY20tPnJlYWRfbG9jayk7DQpA
QCAtMTM3MiwzMCArMTM5NSwyNSBAQCBzdGF0aWMgaW50IGFjbV9zdXNwZW5kKHN0cnVjdCB1c2Jf
aW50ZXJmYWNlICppbnRmLCBwbV9tZXNzYWdlX3QgbWVzc2FnZSkNCiBzdGF0aWMgaW50IGFjbV9y
ZXN1bWUoc3RydWN0IHVzYl9pbnRlcmZhY2UgKmludGYpDQogew0KIAlzdHJ1Y3QgYWNtICphY20g
PSB1c2JfZ2V0X2ludGZkYXRhKGludGYpOw0KLQlzdHJ1Y3QgYWNtX3diICp3YjsNCisJc3RydWN0
IHVyYiAqdXJiOw0KIAlpbnQgcnYgPSAwOw0KLQlpbnQgY250Ow0KIA0KKwltdXRleF9sb2NrKCZh
Y20tPm11dGV4KTsNCiAJc3Bpbl9sb2NrX2lycSgmYWNtLT5yZWFkX2xvY2spOw0KLQlhY20tPnN1
c3BfY291bnQgLT0gMTsNCi0JY250ID0gYWNtLT5zdXNwX2NvdW50Ow0KLQlzcGluX3VubG9ja19p
cnEoJmFjbS0+cmVhZF9sb2NrKTsNCisJc3Bpbl9sb2NrKCZhY20tPndyaXRlX2xvY2spOw0KIA0K
LQlpZiAoY250KQ0KLQkJcmV0dXJuIDA7DQorCWlmICgtLWFjbS0+c3VzcF9jb3VudCkNCisJCWdv
dG8gb3V0Ow0KIA0KLQltdXRleF9sb2NrKCZhY20tPm11dGV4KTsNCiAJaWYgKGFjbS0+cG9ydC5j
b3VudCkgew0KLQkJcnYgPSB1c2Jfc3VibWl0X3VyYihhY20tPmN0cmx1cmIsIEdGUF9OT0lPKTsN
Ci0NCi0JCXNwaW5fbG9ja19pcnEoJmFjbS0+d3JpdGVfbG9jayk7DQotCQlpZiAoYWNtLT5kZWxh
eWVkX3diKSB7DQotCQkJd2IgPSBhY20tPmRlbGF5ZWRfd2I7DQotCQkJYWNtLT5kZWxheWVkX3di
ID0gTlVMTDsNCi0JCQlzcGluX3VubG9ja19pcnEoJmFjbS0+d3JpdGVfbG9jayk7DQotCQkJYWNt
X3N0YXJ0X3diKGFjbSwgd2IpOw0KLQkJfSBlbHNlIHsNCi0JCQlzcGluX3VubG9ja19pcnEoJmFj
bS0+d3JpdGVfbG9jayk7DQorCQlydiA9IHVzYl9zdWJtaXRfdXJiKGFjbS0+Y3RybHVyYiwgR0ZQ
X0FUT01JQyk7DQorDQorCQlmb3IgKDs7KSB7DQorCQkJdXJiID0gdXNiX2dldF9mcm9tX2FuY2hv
cigmYWNtLT5kZWxheWVkKTsNCisJCQlpZiAoIXVyYikNCisJCQkJYnJlYWs7DQorDQorCQkJYWNt
X3N0YXJ0X3diKGFjbSwgdXJiLT5jb250ZXh0KTsNCiAJCX0NCiANCiAJCS8qDQpAQCAtMTQwMywx
MyArMTQyMSwxNSBAQCBzdGF0aWMgaW50IGFjbV9yZXN1bWUoc3RydWN0IHVzYl9pbnRlcmZhY2Ug
KmludGYpDQogCQkgKiBkbyB0aGUgd3JpdGUgcGF0aCBhdCBhbGwgY29zdA0KIAkJICovDQogCQlp
ZiAocnYgPCAwKQ0KLQkJCWdvdG8gZXJyX291dDsNCisJCQlnb3RvIG91dDsNCiANCi0JCXJ2ID0g
YWNtX3N1Ym1pdF9yZWFkX3VyYnMoYWNtLCBHRlBfTk9JTyk7DQorCQlydiA9IGFjbV9zdWJtaXRf
cmVhZF91cmJzKGFjbSwgR0ZQX0FUT01JQyk7DQogCX0NCi0NCi1lcnJfb3V0Og0KK291dDoNCisJ
c3Bpbl91bmxvY2soJmFjbS0+d3JpdGVfbG9jayk7DQorCXNwaW5fdW5sb2NrX2lycSgmYWNtLT5y
ZWFkX2xvY2spOw0KIAltdXRleF91bmxvY2soJmFjbS0+bXV0ZXgpOw0KKw0KIAlyZXR1cm4gcnY7
DQogfQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2NsYXNzL2NkYy1hY20uaCBiL2RyaXZl
cnMvdXNiL2NsYXNzL2NkYy1hY20uaA0KaW5kZXggY2E3OTM3Zi4uYzNmMWIzNiAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvdXNiL2NsYXNzL2NkYy1hY20uaA0KKysrIGIvZHJpdmVycy91c2IvY2xhc3Mv
Y2RjLWFjbS5oDQpAQCAtMTE2LDcgKzExNiw3IEBAIHN0cnVjdCBhY20gew0KIAl1bnNpZ25lZCBp
bnQgdGhyb3R0bGVkOjE7CQkJLyogYWN0dWFsbHkgdGhyb3R0bGVkICovDQogCXVuc2lnbmVkIGlu
dCB0aHJvdHRsZV9yZXE6MTsJCQkvKiB0aHJvdHRsZSByZXF1ZXN0ZWQgKi8NCiAJdTggYkludGVy
dmFsOw0KLQlzdHJ1Y3QgYWNtX3diICpkZWxheWVkX3diOwkJCS8qIHdyaXRlIHF1ZXVlZCBmb3Ig
YSBkZXZpY2UgYWJvdXQgdG8gYmUgd29rZW4gKi8NCisJc3RydWN0IHVzYl9hbmNob3IgZGVsYXll
ZDsJCQkvKiB3cml0ZXMgcXVldWVkIGZvciBhIGRldmljZSBhYm91dCB0byBiZSB3b2tlbiAqLw0K
IH07DQogDQogI2RlZmluZSBDRENfREFUQV9JTlRFUkZBQ0VfVFlQRQkweDBhDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy91c2IvY29yZS9kcml2ZXIuYyBiL2RyaXZlcnMvdXNiL2NvcmUvZHJpdmVyLmMN
CmluZGV4IDlmMzAwM2UuLmNjMTNhYmYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9jb3JlL2Ry
aXZlci5jDQorKysgYi9kcml2ZXJzL3VzYi9jb3JlL2RyaXZlci5jDQpAQCAtMTY4NiwxMCArMTY4
NiwxMyBAQCBpbnQgdXNiX3J1bnRpbWVfc3VzcGVuZChzdHJ1Y3QgZGV2aWNlICpkZXYpDQogCWlm
IChzdGF0dXMgPT0gLUVBR0FJTiB8fCBzdGF0dXMgPT0gLUVCVVNZKQ0KIAkJdXNiX21hcmtfbGFz
dF9idXN5KHVkZXYpOw0KIA0KLQkvKiBUaGUgUE0gY29yZSByZWFjdHMgYmFkbHkgdW5sZXNzIHRo
ZSByZXR1cm4gY29kZSBpcyAwLA0KLQkgKiAtRUFHQUlOLCBvciAtRUJVU1ksIHNvIGFsd2F5cyBy
ZXR1cm4gLUVCVVNZIG9uIGFuIGVycm9yLg0KKwkvKg0KKwkgKiBUaGUgUE0gY29yZSByZWFjdHMg
YmFkbHkgdW5sZXNzIHRoZSByZXR1cm4gY29kZSBpcyAwLA0KKwkgKiAtRUFHQUlOLCBvciAtRUJV
U1ksIHNvIGFsd2F5cyByZXR1cm4gLUVCVVNZIG9uIGFuIGVycm9yDQorCSAqIChleGNlcHQgZm9y
IHJvb3QgaHVicywgYmVjYXVzZSB0aGV5IGRvbid0IHN1c3BlbmQgdGhyb3VnaA0KKwkgKiBhbiB1
cHN0cmVhbSBwb3J0IGxpa2Ugb3RoZXIgVVNCIGRldmljZXMpLg0KIAkgKi8NCi0JaWYgKHN0YXR1
cyAhPSAwKQ0KKwlpZiAoc3RhdHVzICE9IDAgJiYgdWRldi0+cGFyZW50KQ0KIAkJcmV0dXJuIC1F
QlVTWTsNCiAJcmV0dXJuIHN0YXR1czsNCiB9DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvY29y
ZS9odWIuYyBiL2RyaXZlcnMvdXNiL2NvcmUvaHViLmMNCmluZGV4IDcwMTMxNjUuLjEyZjNhMzcg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9jb3JlL2h1Yi5jDQorKysgYi9kcml2ZXJzL3VzYi9j
b3JlL2h1Yi5jDQpAQCAtMTM3MCwxNCArMTM3MCwyNCBAQCBzdGF0aWMgaW50IGh1Yl9wcm9iZShz
dHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZiwgY29uc3Qgc3RydWN0IHVzYl9kZXZpY2VfaWQgKmlk
KQ0KIAlkZXNjID0gaW50Zi0+Y3VyX2FsdHNldHRpbmc7DQogCWhkZXYgPSBpbnRlcmZhY2VfdG9f
dXNiZGV2KGludGYpOw0KIA0KLQkvKiBIdWJzIGhhdmUgcHJvcGVyIHN1c3BlbmQvcmVzdW1lIHN1
cHBvcnQuICBVU0IgMy4wIGRldmljZSBzdXNwZW5kIGlzDQorCS8qDQorCSAqIEh1YnMgaGF2ZSBw
cm9wZXIgc3VzcGVuZC9yZXN1bWUgc3VwcG9ydCwgZXhjZXB0IGZvciByb290IGh1YnMNCisJICog
d2hlcmUgdGhlIGNvbnRyb2xsZXIgZHJpdmVyIGRvZXNuJ3QgaGF2ZSBidXNfc3VzcGVuZCBhbmQN
CisJICogYnVzX3Jlc3VtZSBtZXRob2RzLiAgQWxzbywgVVNCIDMuMCBkZXZpY2Ugc3VzcGVuZCBp
cw0KIAkgKiBkaWZmZXJlbnQgZnJvbSBVU0IgMi4wLzEuMSBkZXZpY2Ugc3VzcGVuZCwgYW5kIHVu
Zm9ydHVuYXRlbHkgd2UNCiAJICogZG9uJ3Qgc3VwcG9ydCBpdCB5ZXQuICBTbyBsZWF2ZSBhdXRv
c3VzcGVuZCBkaXNhYmxlZCBmb3IgVVNCIDMuMA0KIAkgKiBleHRlcm5hbCBodWJzIGZvciBub3cu
ICBFbmFibGUgYXV0b3N1c3BlbmQgZm9yIFVTQiAzLjAgcm9vdGh1YnMsDQogCSAqIHNpbmNlIHRo
YXQgaXNuJ3QgYSAicmVhbCIgaHViLg0KIAkgKi8NCi0JaWYgKCFodWJfaXNfc3VwZXJzcGVlZCho
ZGV2KSB8fCAhaGRldi0+cGFyZW50KQ0KLQkJdXNiX2VuYWJsZV9hdXRvc3VzcGVuZChoZGV2KTsN
CisJaWYgKGhkZXYtPnBhcmVudCkgewkJLyogbm9ybWFsIGRldmljZSAqLw0KKwkJaWYgKCFodWJf
aXNfc3VwZXJzcGVlZChoZGV2KSkNCisJCQl1c2JfZW5hYmxlX2F1dG9zdXNwZW5kKGhkZXYpOw0K
Kwl9IGVsc2UgewkJCS8qIHJvb3QgaHViICovDQorCQljb25zdCBzdHJ1Y3QgaGNfZHJpdmVyICpk
cnYgPSBidXNfdG9faGNkKGhkZXYtPmJ1cyktPmRyaXZlcjsNCisNCisJCWlmIChkcnYtPmJ1c19z
dXNwZW5kICYmIGRydi0+YnVzX3Jlc3VtZSkNCisJCQl1c2JfZW5hYmxlX2F1dG9zdXNwZW5kKGhk
ZXYpOw0KKwl9DQogDQogCWlmIChoZGV2LT5sZXZlbCA9PSBNQVhfVE9QT19MRVZFTCkgew0KIAkJ
ZGV2X2VycigmaW50Zi0+ZGV2LA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2hvc3QvcGNpLXF1
aXJrcy5jIGIvZHJpdmVycy91c2IvaG9zdC9wY2ktcXVpcmtzLmMNCmluZGV4IGM3Y2ZiY2UuLmVh
ZTM1YzEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9ob3N0L3BjaS1xdWlya3MuYw0KKysrIGIv
ZHJpdmVycy91c2IvaG9zdC9wY2ktcXVpcmtzLmMNCkBAIC01NTUsNiArNTU1LDE0IEBAIHN0YXRp
YyBjb25zdCBzdHJ1Y3QgZG1pX3N5c3RlbV9pZCBfX2RldmluaXRjb25zdCBlaGNpX2RtaV9ub2hh
bmRvZmZfdGFibGVbXSA9IHsNCiAJCQlETUlfTUFUQ0goRE1JX0JJT1NfVkVSU0lPTiwgIkx1Y2lk
LSIpLA0KIAkJfSwNCiAJfSwNCisJew0KKwkJLyogSEFTRUUgRTIwMCAqLw0KKwkJLm1hdGNoZXMg
PSB7DQorCQkJRE1JX01BVENIKERNSV9CT0FSRF9WRU5ET1IsICJIQVNFRSIpLA0KKwkJCURNSV9N
QVRDSChETUlfQk9BUkRfTkFNRSwgIkUyMTAiKSwNCisJCQlETUlfTUFUQ0goRE1JX0JJT1NfVkVS
U0lPTiwgIjYuMDAiKSwNCisJCX0sDQorCX0sDQogCXsgfQ0KIH07DQogDQpAQCAtNTY0LDkgKzU3
MiwxNCBAQCBzdGF0aWMgdm9pZCBfX2RldmluaXQgZWhjaV9iaW9zX2hhbmRvZmYoc3RydWN0IHBj
aV9kZXYgKnBkZXYsDQogew0KIAlpbnQgdHJ5X2hhbmRvZmYgPSAxLCB0cmllZF9oYW5kb2ZmID0g
MDsNCiANCi0JLyogVGhlIFBlZ2F0cm9uIEx1Y2lkIHRhYmxldCBzcG9yYWRpY2FsbHkgd2FpdHMg
Zm9yIDk4IHNlY29uZHMgdHJ5aW5nDQotCSAqIHRoZSBoYW5kb2ZmIG9uIGl0cyB1bnVzZWQgY29u
dHJvbGxlci4gIFNraXAgaXQuICovDQotCWlmIChwZGV2LT52ZW5kb3IgPT0gMHg4MDg2ICYmIHBk
ZXYtPmRldmljZSA9PSAweDI4M2EpIHsNCisJLyoNCisJICogVGhlIFBlZ2F0cm9uIEx1Y2lkIHRh
YmxldCBzcG9yYWRpY2FsbHkgd2FpdHMgZm9yIDk4IHNlY29uZHMgdHJ5aW5nDQorCSAqIHRoZSBo
YW5kb2ZmIG9uIGl0cyB1bnVzZWQgY29udHJvbGxlci4gIFNraXAgaXQuDQorCSAqDQorCSAqIFRo
ZSBIQVNFRSBFMjAwIGhhbmdzIHdoZW4gdGhlIHNlbWFwaG9yZSBpcyBzZXQgKGJ1Z3ppbGxhICM3
NzAyMSkuDQorCSAqLw0KKwlpZiAocGRldi0+dmVuZG9yID09IDB4ODA4NiAmJiAocGRldi0+ZGV2
aWNlID09IDB4MjgzYSB8fA0KKwkJCXBkZXYtPmRldmljZSA9PSAweDI3Y2MpKSB7DQogCQlpZiAo
ZG1pX2NoZWNrX3N5c3RlbShlaGNpX2RtaV9ub2hhbmRvZmZfdGFibGUpKQ0KIAkJCXRyeV9oYW5k
b2ZmID0gMDsNCiAJfQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2hvc3QveGhjaS1tZW0uYyBi
L2RyaXZlcnMvdXNiL2hvc3QveGhjaS1tZW0uYw0KaW5kZXggZWM3MzU0MS4uNzQ5MjJiOSAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvdXNiL2hvc3QveGhjaS1tZW0uYw0KKysrIGIvZHJpdmVycy91c2Iv
aG9zdC94aGNpLW1lbS5jDQpAQCAtMTcyMiw2ICsxNzIyLDE2IEBAIHZvaWQgeGhjaV9tZW1fY2xl
YW51cChzdHJ1Y3QgeGhjaV9oY2QgKnhoY2kpDQogCQlrZnJlZShjdXJfY2QpOw0KIAl9DQogDQor
CW51bV9wb3J0cyA9IEhDU19NQVhfUE9SVFMoeGhjaS0+aGNzX3BhcmFtczEpOw0KKwlmb3IgKGkg
PSAwOyBpIDwgbnVtX3BvcnRzOyBpKyspIHsNCisJCXN0cnVjdCB4aGNpX2ludGVydmFsX2J3X3Rh
YmxlICpid3QgPSAmeGhjaS0+cmhfYndbaV0uYndfdGFibGU7DQorCQlmb3IgKGogPSAwOyBqIDwg
WEhDSV9NQVhfSU5URVJWQUw7IGorKykgew0KKwkJCXN0cnVjdCBsaXN0X2hlYWQgKmVwID0gJmJ3
dC0+aW50ZXJ2YWxfYndbal0uZW5kcG9pbnRzOw0KKwkJCXdoaWxlICghbGlzdF9lbXB0eShlcCkp
DQorCQkJCWxpc3RfZGVsX2luaXQoZXAtPm5leHQpOw0KKwkJfQ0KKwl9DQorDQogCWZvciAoaSA9
IDE7IGkgPCBNQVhfSENfU0xPVFM7ICsraSkNCiAJCXhoY2lfZnJlZV92aXJ0X2RldmljZSh4aGNp
LCBpKTsNCiANCkBAIC0xNzYyLDE2ICsxNzcyLDYgQEAgdm9pZCB4aGNpX21lbV9jbGVhbnVwKHN0
cnVjdCB4aGNpX2hjZCAqeGhjaSkNCiAJaWYgKCF4aGNpLT5yaF9idykNCiAJCWdvdG8gbm9fYnc7
DQogDQotCW51bV9wb3J0cyA9IEhDU19NQVhfUE9SVFMoeGhjaS0+aGNzX3BhcmFtczEpOw0KLQlm
b3IgKGkgPSAwOyBpIDwgbnVtX3BvcnRzOyBpKyspIHsNCi0JCXN0cnVjdCB4aGNpX2ludGVydmFs
X2J3X3RhYmxlICpid3QgPSAmeGhjaS0+cmhfYndbaV0uYndfdGFibGU7DQotCQlmb3IgKGogPSAw
OyBqIDwgWEhDSV9NQVhfSU5URVJWQUw7IGorKykgew0KLQkJCXN0cnVjdCBsaXN0X2hlYWQgKmVw
ID0gJmJ3dC0+aW50ZXJ2YWxfYndbal0uZW5kcG9pbnRzOw0KLQkJCXdoaWxlICghbGlzdF9lbXB0
eShlcCkpDQotCQkJCWxpc3RfZGVsX2luaXQoZXAtPm5leHQpOw0KLQkJfQ0KLQl9DQotDQogCWZv
ciAoaSA9IDA7IGkgPCBudW1fcG9ydHM7IGkrKykgew0KIAkJc3RydWN0IHhoY2lfdHRfYndfaW5m
byAqdHQsICpuOw0KIAkJbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKHR0LCBuLCAmeGhjaS0+cmhf
YndbaV0udHRzLCB0dF9saXN0KSB7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvbWlzYy91c2J0
ZXN0LmMgYi9kcml2ZXJzL3VzYi9taXNjL3VzYnRlc3QuYw0KaW5kZXggYjlhYzlhMy4uMmEzOGEx
NyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL21pc2MvdXNidGVzdC5jDQorKysgYi9kcml2ZXJz
L3VzYi9taXNjL3VzYnRlc3QuYw0KQEAgLTExMzIsNiArMTEzMiwxMSBAQCBzdGF0aWMgaW50IHVu
bGluazEoc3RydWN0IHVzYnRlc3RfZGV2ICpkZXYsIGludCBwaXBlLCBpbnQgc2l6ZSwgaW50IGFz
eW5jKQ0KIAl1cmItPmNvbnRleHQgPSAmY29tcGxldGlvbjsNCiAJdXJiLT5jb21wbGV0ZSA9IHVu
bGluazFfY2FsbGJhY2s7DQogDQorCWlmICh1c2JfcGlwZW91dCh1cmItPnBpcGUpKSB7DQorCQlz
aW1wbGVfZmlsbF9idWYodXJiKTsNCisJCXVyYi0+dHJhbnNmZXJfZmxhZ3MgfD0gVVJCX1pFUk9f
UEFDS0VUOw0KKwl9DQorDQogCS8qIGtlZXAgdGhlIGVuZHBvaW50IGJ1c3kuICB0aGVyZSBhcmUg
bG90cyBvZiBoYy9oY2QtaW50ZXJuYWwNCiAJICogc3RhdGVzLCBhbmQgdGVzdGluZyBzaG91bGQg
Z2V0IHRvIGFsbCBvZiB0aGVtIG92ZXIgdGltZS4NCiAJICoNCkBAIC0xMjYyLDYgKzEyNjcsMTEg
QEAgc3RhdGljIGludCB1bmxpbmtfcXVldWVkKHN0cnVjdCB1c2J0ZXN0X2RldiAqZGV2LCBpbnQg
cGlwZSwgdW5zaWduZWQgbnVtLA0KIAkJCQl1bmxpbmtfcXVldWVkX2NhbGxiYWNrLCAmY3R4KTsN
CiAJCWN0eC51cmJzW2ldLT50cmFuc2Zlcl9kbWEgPSBidWZfZG1hOw0KIAkJY3R4LnVyYnNbaV0t
PnRyYW5zZmVyX2ZsYWdzID0gVVJCX05PX1RSQU5TRkVSX0RNQV9NQVA7DQorDQorCQlpZiAodXNi
X3BpcGVvdXQoY3R4LnVyYnNbaV0tPnBpcGUpKSB7DQorCQkJc2ltcGxlX2ZpbGxfYnVmKGN0eC51
cmJzW2ldKTsNCisJCQljdHgudXJic1tpXS0+dHJhbnNmZXJfZmxhZ3MgfD0gVVJCX1pFUk9fUEFD
S0VUOw0KKwkJfQ0KIAl9DQogDQogCS8qIFN1Ym1pdCBhbGwgdGhlIFVSQnMgYW5kIHRoZW4gdW5s
aW5rIFVSQnMgbnVtIC0gNCBhbmQgbnVtIC0gMi4gKi8NCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Vz
Yi9zZXJpYWwvZnRkaV9zaW8uYyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9mdGRpX3Npby5jDQppbmRl
eCAzMzJmMDRkLi42ZTA4NjM5IDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2Ivc2VyaWFsL2Z0ZGlf
c2lvLmMNCisrKyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9mdGRpX3Npby5jDQpAQCAtNTkxLDYgKzU5
MSw4IEBAIHN0YXRpYyBzdHJ1Y3QgdXNiX2RldmljZV9pZCBpZF90YWJsZV9jb21iaW5lZCBbXSA9
IHsNCiAJeyBVU0JfREVWSUNFKEZURElfVklELCBGVERJX1RBVklSX1NUSzUwMF9QSUQpIH0sDQog
CXsgVVNCX0RFVklDRShGVERJX1ZJRCwgRlRESV9USUFPX1VNUEFfUElEKSwNCiAJCS5kcml2ZXJf
aW5mbyA9IChrZXJuZWxfdWxvbmdfdCkmZnRkaV9qdGFnX3F1aXJrIH0sDQorCXsgVVNCX0RFVklD
RShGVERJX1ZJRCwgRlRESV9OVF9PUklPTkxYTV9QSUQpLA0KKwkJLmRyaXZlcl9pbmZvID0gKGtl
cm5lbF91bG9uZ190KSZmdGRpX2p0YWdfcXVpcmsgfSwNCiAJLyoNCiAJICogRUxWIGRldmljZXM6
DQogCSAqLw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9mdGRpX3Npb19pZHMuaCBi
L2RyaXZlcnMvdXNiL3NlcmlhbC9mdGRpX3Npb19pZHMuaA0KaW5kZXggODNhNDQwZi4uNjc3Y2Y0
OSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL3NlcmlhbC9mdGRpX3Npb19pZHMuaA0KKysrIGIv
ZHJpdmVycy91c2Ivc2VyaWFsL2Z0ZGlfc2lvX2lkcy5oDQpAQCAtNTM4LDYgKzUzOCwxMSBAQA0K
ICAqLw0KICNkZWZpbmUgRlRESV9USUFPX1VNUEFfUElECTB4OGE5OAkvKiBUSUFPL0RJWUdBREdF
VCBVU0IgTXVsdGktUHJvdG9jb2wgQWRhcHRlciAqLw0KIA0KKy8qDQorICogTm92YVRlY2ggcHJv
ZHVjdCBpZHMgKEZURElfVklEKQ0KKyAqLw0KKyNkZWZpbmUgRlRESV9OVF9PUklPTkxYTV9QSUQJ
MHg3YzkwCS8qIE9yaW9uTFhtIFN1YnN0YXRpb24gQXV0b21hdGlvbiBQbGF0Zm9ybSAqLw0KKw0K
IA0KIC8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi8NCiAvKiogdGhpcmQtcGFydHkg
VklEL1BJRCBjb21ib3MgKiovDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Ivc2VyaWFsL2lvX3Rp
LmMgYi9kcml2ZXJzL3VzYi9zZXJpYWwvaW9fdGkuYw0KaW5kZXggYzU3NWUwYS4uNDM4MTM4ZiAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL3NlcmlhbC9pb190aS5jDQorKysgYi9kcml2ZXJzL3Vz
Yi9zZXJpYWwvaW9fdGkuYw0KQEAgLTkyMyw3ICs5MjMsNyBAQCBzdGF0aWMgaW50IGJ1aWxkX2ky
Y19md19oZHIoX191OCAqaGVhZGVyLCBzdHJ1Y3QgZGV2aWNlICpkZXYpDQogCWZpcm13YXJlX3Jl
YyA9ICAoc3RydWN0IHRpX2kyY19maXJtd2FyZV9yZWMqKWkyY19oZWFkZXItPkRhdGE7DQogDQog
CWkyY19oZWFkZXItPlR5cGUJPSBJMkNfREVTQ19UWVBFX0ZJUk1XQVJFX0JMQU5LOw0KLQlpMmNf
aGVhZGVyLT5TaXplCT0gKF9fdTE2KWJ1ZmZlcl9zaXplOw0KKwlpMmNfaGVhZGVyLT5TaXplCT0g
Y3B1X3RvX2xlMTYoYnVmZmVyX3NpemUpOw0KIAlpMmNfaGVhZGVyLT5DaGVja1N1bQk9IGNzOw0K
IAlmaXJtd2FyZV9yZWMtPlZlcl9NYWpvcgk9IE9wZXJhdGlvbmFsTWFqb3JWZXJzaW9uOw0KIAlm
aXJtd2FyZV9yZWMtPlZlcl9NaW5vcgk9IE9wZXJhdGlvbmFsTWlub3JWZXJzaW9uOw0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9pb191c2J2ZW5kLmggYi9kcml2ZXJzL3VzYi9zZXJp
YWwvaW9fdXNidmVuZC5oDQppbmRleCA1MWY4M2ZiLi42ZjZhODU2IDEwMDY0NA0KLS0tIGEvZHJp
dmVycy91c2Ivc2VyaWFsL2lvX3VzYnZlbmQuaA0KKysrIGIvZHJpdmVycy91c2Ivc2VyaWFsL2lv
X3VzYnZlbmQuaA0KQEAgLTU5NCw3ICs1OTQsNyBAQCBzdHJ1Y3QgZWRnZV9ib290X2Rlc2NyaXB0
b3Igew0KIA0KIHN0cnVjdCB0aV9pMmNfZGVzYyB7DQogCV9fdTgJVHlwZTsJCQkvLyBUeXBlIG9m
IGRlc2NyaXB0b3INCi0JX191MTYJU2l6ZTsJCQkvLyBTaXplIG9mIGRhdGEgb25seSBub3QgaW5j
bHVkaW5nIGhlYWRlcg0KKwlfX2xlMTYJU2l6ZTsJCQkvLyBTaXplIG9mIGRhdGEgb25seSBub3Qg
aW5jbHVkaW5nIGhlYWRlcg0KIAlfX3U4CUNoZWNrU3VtOwkJLy8gQ2hlY2tzdW0gKDggYml0IHN1
bSBvZiBkYXRhIG9ubHkpDQogCV9fdTgJRGF0YVswXTsJCS8vIERhdGEgc3RhcnRzIGhlcmUNCiB9
IF9fYXR0cmlidXRlX18oKHBhY2tlZCkpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3Nlcmlh
bC9vcHRpb24uYyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9vcHRpb24uYw0KaW5kZXggOTgyM2U3OS4u
YTBmNDdkNSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL3NlcmlhbC9vcHRpb24uYw0KKysrIGIv
ZHJpdmVycy91c2Ivc2VyaWFsL29wdGlvbi5jDQpAQCAtMTYxLDYgKzE2MSw3IEBAIHN0YXRpYyB2
b2lkIG9wdGlvbl9pbnN0YXRfY2FsbGJhY2soc3RydWN0IHVyYiAqdXJiKTsNCiAjZGVmaW5lIE5P
VkFURUxXSVJFTEVTU19QUk9EVUNUX0hTUEFfRU1CRURERURfRlVMTFNQRUVECTB4OTAwMA0KICNk
ZWZpbmUgTk9WQVRFTFdJUkVMRVNTX1BST0RVQ1RfSFNQQV9FTUJFRERFRF9ISUdIU1BFRUQJMHg5
MDAxDQogI2RlZmluZSBOT1ZBVEVMV0lSRUxFU1NfUFJPRFVDVF9FMzYyCQkweDkwMTANCisjZGVm
aW5lIE5PVkFURUxXSVJFTEVTU19QUk9EVUNUX0UzNzEJCTB4OTAxMQ0KICNkZWZpbmUgTk9WQVRF
TFdJUkVMRVNTX1BST0RVQ1RfRzIJCTB4QTAxMA0KICNkZWZpbmUgTk9WQVRFTFdJUkVMRVNTX1BS
T0RVQ1RfTUM1NTEJCTB4QjAwMQ0KIA0KQEAgLTEwMjUsNiArMTAyNiw3IEBAIHN0YXRpYyBjb25z
dCBzdHJ1Y3QgdXNiX2RldmljZV9pZCBvcHRpb25faWRzW10gPSB7DQogCS8qIE5vdmF0ZWwgT3Zh
dGlvbiBNQzU1MSBhLmsuYS4gVmVyaXpvbiBVU0I1NTFMICovDQogCXsgVVNCX0RFVklDRV9BTkRf
SU5URVJGQUNFX0lORk8oTk9WQVRFTFdJUkVMRVNTX1ZFTkRPUl9JRCwgTk9WQVRFTFdJUkVMRVNT
X1BST0RVQ1RfTUM1NTEsIDB4ZmYsIDB4ZmYsIDB4ZmYpIH0sDQogCXsgVVNCX0RFVklDRV9BTkRf
SU5URVJGQUNFX0lORk8oTk9WQVRFTFdJUkVMRVNTX1ZFTkRPUl9JRCwgTk9WQVRFTFdJUkVMRVNT
X1BST0RVQ1RfRTM2MiwgMHhmZiwgMHhmZiwgMHhmZikgfSwNCisJeyBVU0JfREVWSUNFX0FORF9J
TlRFUkZBQ0VfSU5GTyhOT1ZBVEVMV0lSRUxFU1NfVkVORE9SX0lELCBOT1ZBVEVMV0lSRUxFU1Nf
UFJPRFVDVF9FMzcxLCAweGZmLCAweGZmLCAweGZmKSB9LA0KIA0KIAl7IFVTQl9ERVZJQ0UoQU1P
SV9WRU5ET1JfSUQsIEFNT0lfUFJPRFVDVF9IMDEpIH0sDQogCXsgVVNCX0RFVklDRShBTU9JX1ZF
TkRPUl9JRCwgQU1PSV9QUk9EVUNUX0gwMUEpIH0sDQpAQCAtMTk1NSw2ICsxOTU3LDcgQEAgc3Rh
dGljIGludCBvcHRpb25fc2VuZF9zZXR1cChzdHJ1Y3QgdXNiX3NlcmlhbF9wb3J0ICpwb3J0KQ0K
IAlzdHJ1Y3QgdXNiX3d3YW5fcG9ydF9wcml2YXRlICpwb3J0ZGF0YTsNCiAJaW50IGlmTnVtID0g
c2VyaWFsLT5pbnRlcmZhY2UtPmN1cl9hbHRzZXR0aW5nLT5kZXNjLmJJbnRlcmZhY2VOdW1iZXI7
DQogCWludCB2YWwgPSAwOw0KKwlpbnQgcmVzOw0KIAlkYmcoIiVzIiwgX19mdW5jX18pOw0KIA0K
IAlpZiAoaXNfYmxhY2tsaXN0ZWQoaWZOdW0sIE9QVElPTl9CTEFDS0xJU1RfU0VORFNFVFVQLA0K
QEAgLTE5NzAsOSArMTk3MywxNiBAQCBzdGF0aWMgaW50IG9wdGlvbl9zZW5kX3NldHVwKHN0cnVj
dCB1c2Jfc2VyaWFsX3BvcnQgKnBvcnQpDQogCWlmIChwb3J0ZGF0YS0+cnRzX3N0YXRlKQ0KIAkJ
dmFsIHw9IDB4MDI7DQogDQotCXJldHVybiB1c2JfY29udHJvbF9tc2coc2VyaWFsLT5kZXYsDQot
CQl1c2JfcmN2Y3RybHBpcGUoc2VyaWFsLT5kZXYsIDApLA0KKwlyZXMgPSB1c2JfYXV0b3BtX2dl
dF9pbnRlcmZhY2Uoc2VyaWFsLT5pbnRlcmZhY2UpOw0KKwlpZiAocmVzKQ0KKwkJcmV0dXJuIHJl
czsNCisNCisJcmVzID0gdXNiX2NvbnRyb2xfbXNnKHNlcmlhbC0+ZGV2LCB1c2JfcmN2Y3RybHBp
cGUoc2VyaWFsLT5kZXYsIDApLA0KIAkJMHgyMiwgMHgyMSwgdmFsLCBpZk51bSwgTlVMTCwgMCwg
VVNCX0NUUkxfU0VUX1RJTUVPVVQpOw0KKw0KKwl1c2JfYXV0b3BtX3B1dF9pbnRlcmZhY2Uoc2Vy
aWFsLT5pbnRlcmZhY2UpOw0KKw0KKwlyZXR1cm4gcmVzOw0KIH0NCiANCiBNT0RVTEVfQVVUSE9S
KERSSVZFUl9BVVRIT1IpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9zaWVycmEu
YyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9zaWVycmEuYw0KaW5kZXggZGJkZmViNC4uMGQyNmFiNiAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL3NlcmlhbC9zaWVycmEuYw0KKysrIGIvZHJpdmVycy91
c2Ivc2VyaWFsL3NpZXJyYS5jDQpAQCAtNTksNiArNTksNyBAQCBzdHJ1Y3Qgc2llcnJhX2ludGZf
cHJpdmF0ZSB7DQogCXNwaW5sb2NrX3Qgc3VzcF9sb2NrOw0KIAl1bnNpZ25lZCBpbnQgc3VzcGVu
ZGVkOjE7DQogCWludCBpbl9mbGlnaHQ7DQorCXVuc2lnbmVkIGludCBvcGVuX3BvcnRzOw0KIH07
DQogDQogc3RhdGljIGludCBzaWVycmFfc2V0X3Bvd2VyX3N0YXRlKHN0cnVjdCB1c2JfZGV2aWNl
ICp1ZGV2LCBfX3UxNiBzd2lTdGF0ZSkNCkBAIC04MDIsNiArODAzLDcgQEAgc3RhdGljIHZvaWQg
c2llcnJhX2Nsb3NlKHN0cnVjdCB1c2Jfc2VyaWFsX3BvcnQgKnBvcnQpDQogCXN0cnVjdCB1c2Jf
c2VyaWFsICpzZXJpYWwgPSBwb3J0LT5zZXJpYWw7DQogCXN0cnVjdCBzaWVycmFfcG9ydF9wcml2
YXRlICpwb3J0ZGF0YTsNCiAJc3RydWN0IHNpZXJyYV9pbnRmX3ByaXZhdGUgKmludGZkYXRhID0g
cG9ydC0+c2VyaWFsLT5wcml2YXRlOw0KKwlzdHJ1Y3QgdXJiICp1cmI7DQogDQogDQogCWRldl9k
YmcoJnBvcnQtPmRldiwgIiVzXG4iLCBfX2Z1bmNfXyk7DQpAQCAtODEzLDcgKzgxNSw2IEBAIHN0
YXRpYyB2b2lkIHNpZXJyYV9jbG9zZShzdHJ1Y3QgdXNiX3NlcmlhbF9wb3J0ICpwb3J0KQ0KIAlp
ZiAoc2VyaWFsLT5kZXYpIHsNCiAJCW11dGV4X2xvY2soJnNlcmlhbC0+ZGlzY19tdXRleCk7DQog
CQlpZiAoIXNlcmlhbC0+ZGlzY29ubmVjdGVkKSB7DQotCQkJc2VyaWFsLT5pbnRlcmZhY2UtPm5l
ZWRzX3JlbW90ZV93YWtldXAgPSAwOw0KIAkJCS8qIG9kZCBlcnJvciBoYW5kbGluZyBkdWUgdG8g
cG0gY291bnRlcnMgKi8NCiAJCQlpZiAoIXVzYl9hdXRvcG1fZ2V0X2ludGVyZmFjZShzZXJpYWwt
PmludGVyZmFjZSkpDQogCQkJCXNpZXJyYV9zZW5kX3NldHVwKHBvcnQpOw0KQEAgLTgyNCw4ICs4
MjUsMjEgQEAgc3RhdGljIHZvaWQgc2llcnJhX2Nsb3NlKHN0cnVjdCB1c2Jfc2VyaWFsX3BvcnQg
KnBvcnQpDQogCQltdXRleF91bmxvY2soJnNlcmlhbC0+ZGlzY19tdXRleCk7DQogCQlzcGluX2xv
Y2tfaXJxKCZpbnRmZGF0YS0+c3VzcF9sb2NrKTsNCiAJCXBvcnRkYXRhLT5vcGVuZWQgPSAwOw0K
KwkJaWYgKC0taW50ZmRhdGEtPm9wZW5fcG9ydHMgPT0gMCkNCisJCQlzZXJpYWwtPmludGVyZmFj
ZS0+bmVlZHNfcmVtb3RlX3dha2V1cCA9IDA7DQogCQlzcGluX3VubG9ja19pcnEoJmludGZkYXRh
LT5zdXNwX2xvY2spOw0KIA0KKwkJZm9yICg7Oykgew0KKwkJCXVyYiA9IHVzYl9nZXRfZnJvbV9h
bmNob3IoJnBvcnRkYXRhLT5kZWxheWVkKTsNCisJCQlpZiAoIXVyYikNCisJCQkJYnJlYWs7DQor
CQkJa2ZyZWUodXJiLT50cmFuc2Zlcl9idWZmZXIpOw0KKwkJCXVzYl9mcmVlX3VyYih1cmIpOw0K
KwkJCXVzYl9hdXRvcG1fcHV0X2ludGVyZmFjZV9hc3luYyhzZXJpYWwtPmludGVyZmFjZSk7DQor
CQkJc3Bpbl9sb2NrKCZwb3J0ZGF0YS0+bG9jayk7DQorCQkJcG9ydGRhdGEtPm91dHN0YW5kaW5n
X3VyYnMtLTsNCisJCQlzcGluX3VubG9jaygmcG9ydGRhdGEtPmxvY2spOw0KKwkJfQ0KIA0KIAkJ
LyogU3RvcCByZWFkaW5nIHVyYnMgKi8NCiAJCXNpZXJyYV9zdG9wX3J4X3VyYnMocG9ydCk7DQpA
QCAtODY4LDIzICs4ODIsMjkgQEAgc3RhdGljIGludCBzaWVycmFfb3BlbihzdHJ1Y3QgdHR5X3N0
cnVjdCAqdHR5LCBzdHJ1Y3QgdXNiX3NlcmlhbF9wb3J0ICpwb3J0KQ0KIAkJCXVzYl9zbmRidWxr
cGlwZShzZXJpYWwtPmRldiwgZW5kcG9pbnQpIHwgVVNCX0RJUl9JTik7DQogDQogCWVyciA9IHNp
ZXJyYV9zdWJtaXRfcnhfdXJicyhwb3J0LCBHRlBfS0VSTkVMKTsNCi0JaWYgKGVycikgew0KLQkJ
LyogZ2V0IHJpZCBvZiBldmVyeXRoaW5nIGFzIGluIGNsb3NlICovDQotCQlzaWVycmFfY2xvc2Uo
cG9ydCk7DQotCQkvKiByZXN0b3JlIGJhbGFuY2UgZm9yIGF1dG9wbSAqLw0KLQkJaWYgKCFzZXJp
YWwtPmRpc2Nvbm5lY3RlZCkNCi0JCQl1c2JfYXV0b3BtX3B1dF9pbnRlcmZhY2Uoc2VyaWFsLT5p
bnRlcmZhY2UpOw0KLQkJcmV0dXJuIGVycjsNCi0JfQ0KKwlpZiAoZXJyKQ0KKwkJZ290byBlcnJf
c3VibWl0Ow0KKw0KIAlzaWVycmFfc2VuZF9zZXR1cChwb3J0KTsNCiANCi0Jc2VyaWFsLT5pbnRl
cmZhY2UtPm5lZWRzX3JlbW90ZV93YWtldXAgPSAxOw0KIAlzcGluX2xvY2tfaXJxKCZpbnRmZGF0
YS0+c3VzcF9sb2NrKTsNCiAJcG9ydGRhdGEtPm9wZW5lZCA9IDE7DQorCWlmICgrK2ludGZkYXRh
LT5vcGVuX3BvcnRzID09IDEpDQorCQlzZXJpYWwtPmludGVyZmFjZS0+bmVlZHNfcmVtb3RlX3dh
a2V1cCA9IDE7DQogCXNwaW5fdW5sb2NrX2lycSgmaW50ZmRhdGEtPnN1c3BfbG9jayk7DQogCXVz
Yl9hdXRvcG1fcHV0X2ludGVyZmFjZShzZXJpYWwtPmludGVyZmFjZSk7DQogDQogCXJldHVybiAw
Ow0KKw0KK2Vycl9zdWJtaXQ6DQorCXNpZXJyYV9zdG9wX3J4X3VyYnMocG9ydCk7DQorDQorCWZv
ciAoaSA9IDA7IGkgPCBwb3J0ZGF0YS0+bnVtX2luX3VyYnM7IGkrKykgew0KKwkJc2llcnJhX3Jl
bGVhc2VfdXJiKHBvcnRkYXRhLT5pbl91cmJzW2ldKTsNCisJCXBvcnRkYXRhLT5pbl91cmJzW2ld
ID0gTlVMTDsNCisJfQ0KKw0KKwlyZXR1cm4gZXJyOw0KIH0NCiANCiANCkBAIC0xMDYwLDggKzEw
ODAsMTIgQEAgc3RhdGljIGludCBzaWVycmFfcmVzdW1lKHN0cnVjdCB1c2Jfc2VyaWFsICpzZXJp
YWwpDQogCQkJaWYgKGVyciA8IDApIHsNCiAJCQkJaW50ZmRhdGEtPmluX2ZsaWdodC0tOw0KIAkJ
CQl1c2JfdW5hbmNob3JfdXJiKHVyYik7DQotCQkJCXVzYl9zY3V0dGxlX2FuY2hvcmVkX3VyYnMo
JnBvcnRkYXRhLT5kZWxheWVkKTsNCi0JCQkJYnJlYWs7DQorCQkJCWtmcmVlKHVyYi0+dHJhbnNm
ZXJfYnVmZmVyKTsNCisJCQkJdXNiX2ZyZWVfdXJiKHVyYik7DQorCQkJCXNwaW5fbG9jaygmcG9y
dGRhdGEtPmxvY2spOw0KKwkJCQlwb3J0ZGF0YS0+b3V0c3RhbmRpbmdfdXJicy0tOw0KKwkJCQlz
cGluX3VubG9jaygmcG9ydGRhdGEtPmxvY2spOw0KKwkJCQljb250aW51ZTsNCiAJCQl9DQogCQl9
DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Ivc2VyaWFsL3VzYl93d2FuLmMgYi9kcml2ZXJz
L3VzYi9zZXJpYWwvdXNiX3d3YW4uYw0KaW5kZXggNmM5MjMwMS4uYjM4OTk0ZSAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvdXNiL3NlcmlhbC91c2Jfd3dhbi5jDQorKysgYi9kcml2ZXJzL3VzYi9zZXJp
YWwvdXNiX3d3YW4uYw0KQEAgLTIzNiw4ICsyMzYsMTAgQEAgaW50IHVzYl93d2FuX3dyaXRlKHN0
cnVjdCB0dHlfc3RydWN0ICp0dHksIHN0cnVjdCB1c2Jfc2VyaWFsX3BvcnQgKnBvcnQsDQogCQkg
ICAgdXNiX3BpcGVlbmRwb2ludCh0aGlzX3VyYi0+cGlwZSksIGkpOw0KIA0KIAkJZXJyID0gdXNi
X2F1dG9wbV9nZXRfaW50ZXJmYWNlX2FzeW5jKHBvcnQtPnNlcmlhbC0+aW50ZXJmYWNlKTsNCi0J
CWlmIChlcnIgPCAwKQ0KKwkJaWYgKGVyciA8IDApIHsNCisJCQljbGVhcl9iaXQoaSwgJnBvcnRk
YXRhLT5vdXRfYnVzeSk7DQogCQkJYnJlYWs7DQorCQl9DQogDQogCQkvKiBzZW5kIHRoZSBkYXRh
ICovDQogCQltZW1jcHkodGhpc191cmItPnRyYW5zZmVyX2J1ZmZlciwgYnVmLCB0b2RvKTsNCkBA
IC00MzIsMTIgKzQzNCwyNiBAQCBpbnQgdXNiX3d3YW5fb3BlbihzdHJ1Y3QgdHR5X3N0cnVjdCAq
dHR5LCBzdHJ1Y3QgdXNiX3NlcmlhbF9wb3J0ICpwb3J0KQ0KIH0NCiBFWFBPUlRfU1lNQk9MKHVz
Yl93d2FuX29wZW4pOw0KIA0KK3N0YXRpYyB2b2lkIHVuYnVzeV9xdWV1ZWRfdXJiKHN0cnVjdCB1
cmIgKnVyYiwNCisJCQkJCXN0cnVjdCB1c2Jfd3dhbl9wb3J0X3ByaXZhdGUgKnBvcnRkYXRhKQ0K
K3sNCisJaW50IGk7DQorDQorCWZvciAoaSA9IDA7IGkgPCBOX09VVF9VUkI7IGkrKykgew0KKwkJ
aWYgKHVyYiA9PSBwb3J0ZGF0YS0+b3V0X3VyYnNbaV0pIHsNCisJCQljbGVhcl9iaXQoaSwgJnBv
cnRkYXRhLT5vdXRfYnVzeSk7DQorCQkJYnJlYWs7DQorCQl9DQorCX0NCit9DQorDQogdm9pZCB1
c2Jfd3dhbl9jbG9zZShzdHJ1Y3QgdXNiX3NlcmlhbF9wb3J0ICpwb3J0KQ0KIHsNCiAJaW50IGk7
DQogCXN0cnVjdCB1c2Jfc2VyaWFsICpzZXJpYWwgPSBwb3J0LT5zZXJpYWw7DQogCXN0cnVjdCB1
c2Jfd3dhbl9wb3J0X3ByaXZhdGUgKnBvcnRkYXRhOw0KIAlzdHJ1Y3QgdXNiX3d3YW5faW50Zl9w
cml2YXRlICppbnRmZGF0YSA9IHBvcnQtPnNlcmlhbC0+cHJpdmF0ZTsNCisJc3RydWN0IHVyYiAq
dXJiOw0KIA0KIAlkYmcoIiVzIiwgX19mdW5jX18pOw0KIAlwb3J0ZGF0YSA9IHVzYl9nZXRfc2Vy
aWFsX3BvcnRfZGF0YShwb3J0KTsNCkBAIC00NDgsNiArNDY0LDE0IEBAIHZvaWQgdXNiX3d3YW5f
Y2xvc2Uoc3RydWN0IHVzYl9zZXJpYWxfcG9ydCAqcG9ydCkNCiAJCXBvcnRkYXRhLT5vcGVuZWQg
PSAwOw0KIAkJc3Bpbl91bmxvY2tfaXJxKCZpbnRmZGF0YS0+c3VzcF9sb2NrKTsNCiANCisJCWZv
ciAoOzspIHsNCisJCQl1cmIgPSB1c2JfZ2V0X2Zyb21fYW5jaG9yKCZwb3J0ZGF0YS0+ZGVsYXll
ZCk7DQorCQkJaWYgKCF1cmIpDQorCQkJCWJyZWFrOw0KKwkJCXVuYnVzeV9xdWV1ZWRfdXJiKHVy
YiwgcG9ydGRhdGEpOw0KKwkJCXVzYl9hdXRvcG1fcHV0X2ludGVyZmFjZV9hc3luYyhzZXJpYWwt
PmludGVyZmFjZSk7DQorCQl9DQorDQogCQlmb3IgKGkgPSAwOyBpIDwgTl9JTl9VUkI7IGkrKykN
CiAJCQl1c2Jfa2lsbF91cmIocG9ydGRhdGEtPmluX3VyYnNbaV0pOw0KIAkJZm9yIChpID0gMDsg
aSA8IE5fT1VUX1VSQjsgaSsrKQ0KQEAgLTY0NSw0NiArNjY5LDMxIEBAIEVYUE9SVF9TWU1CT0wo
dXNiX3d3YW5fcmVsZWFzZSk7DQogaW50IHVzYl93d2FuX3N1c3BlbmQoc3RydWN0IHVzYl9zZXJp
YWwgKnNlcmlhbCwgcG1fbWVzc2FnZV90IG1lc3NhZ2UpDQogew0KIAlzdHJ1Y3QgdXNiX3d3YW5f
aW50Zl9wcml2YXRlICppbnRmZGF0YSA9IHNlcmlhbC0+cHJpdmF0ZTsNCi0JaW50IGI7DQogDQog
CWRiZygiJXMgZW50ZXJlZCIsIF9fZnVuY19fKTsNCiANCisJc3Bpbl9sb2NrX2lycSgmaW50ZmRh
dGEtPnN1c3BfbG9jayk7DQogCWlmIChQTVNHX0lTX0FVVE8obWVzc2FnZSkpIHsNCi0JCXNwaW5f
bG9ja19pcnEoJmludGZkYXRhLT5zdXNwX2xvY2spOw0KLQkJYiA9IGludGZkYXRhLT5pbl9mbGln
aHQ7DQotCQlzcGluX3VubG9ja19pcnEoJmludGZkYXRhLT5zdXNwX2xvY2spOw0KLQ0KLQkJaWYg
KGIpDQorCQlpZiAoaW50ZmRhdGEtPmluX2ZsaWdodCkgew0KKwkJCXNwaW5fdW5sb2NrX2lycSgm
aW50ZmRhdGEtPnN1c3BfbG9jayk7DQogCQkJcmV0dXJuIC1FQlVTWTsNCisJCX0NCiAJfQ0KLQ0K
LQlzcGluX2xvY2tfaXJxKCZpbnRmZGF0YS0+c3VzcF9sb2NrKTsNCiAJaW50ZmRhdGEtPnN1c3Bl
bmRlZCA9IDE7DQogCXNwaW5fdW5sb2NrX2lycSgmaW50ZmRhdGEtPnN1c3BfbG9jayk7DQorDQog
CXN0b3BfcmVhZF93cml0ZV91cmJzKHNlcmlhbCk7DQogDQogCXJldHVybiAwOw0KIH0NCiBFWFBP
UlRfU1lNQk9MKHVzYl93d2FuX3N1c3BlbmQpOw0KIA0KLXN0YXRpYyB2b2lkIHVuYnVzeV9xdWV1
ZWRfdXJiKHN0cnVjdCB1cmIgKnVyYiwgc3RydWN0IHVzYl93d2FuX3BvcnRfcHJpdmF0ZSAqcG9y
dGRhdGEpDQotew0KLQlpbnQgaTsNCi0NCi0JZm9yIChpID0gMDsgaSA8IE5fT1VUX1VSQjsgaSsr
KSB7DQotCQlpZiAodXJiID09IHBvcnRkYXRhLT5vdXRfdXJic1tpXSkgew0KLQkJCWNsZWFyX2Jp
dChpLCAmcG9ydGRhdGEtPm91dF9idXN5KTsNCi0JCQlicmVhazsNCi0JCX0NCi0JfQ0KLX0NCi0N
Ci1zdGF0aWMgdm9pZCBwbGF5X2RlbGF5ZWQoc3RydWN0IHVzYl9zZXJpYWxfcG9ydCAqcG9ydCkN
CitzdGF0aWMgaW50IHBsYXlfZGVsYXllZChzdHJ1Y3QgdXNiX3NlcmlhbF9wb3J0ICpwb3J0KQ0K
IHsNCiAJc3RydWN0IHVzYl93d2FuX2ludGZfcHJpdmF0ZSAqZGF0YTsNCiAJc3RydWN0IHVzYl93
d2FuX3BvcnRfcHJpdmF0ZSAqcG9ydGRhdGE7DQogCXN0cnVjdCB1cmIgKnVyYjsNCi0JaW50IGVy
cjsNCisJaW50IGVyciA9IDA7DQogDQogCXBvcnRkYXRhID0gdXNiX2dldF9zZXJpYWxfcG9ydF9k
YXRhKHBvcnQpOw0KIAlkYXRhID0gcG9ydC0+c2VyaWFsLT5wcml2YXRlOw0KQEAgLTcwMSw2ICs3
MTAsOCBAQCBzdGF0aWMgdm9pZCBwbGF5X2RlbGF5ZWQoc3RydWN0IHVzYl9zZXJpYWxfcG9ydCAq
cG9ydCkNCiAJCQlicmVhazsNCiAJCX0NCiAJfQ0KKw0KKwlyZXR1cm4gZXJyOw0KIH0NCiANCiBp
bnQgdXNiX3d3YW5fcmVzdW1lKHN0cnVjdCB1c2Jfc2VyaWFsICpzZXJpYWwpDQpAQCAtNzEwLDcg
KzcyMSw4IEBAIGludCB1c2Jfd3dhbl9yZXN1bWUoc3RydWN0IHVzYl9zZXJpYWwgKnNlcmlhbCkN
CiAJc3RydWN0IHVzYl93d2FuX2ludGZfcHJpdmF0ZSAqaW50ZmRhdGEgPSBzZXJpYWwtPnByaXZh
dGU7DQogCXN0cnVjdCB1c2Jfd3dhbl9wb3J0X3ByaXZhdGUgKnBvcnRkYXRhOw0KIAlzdHJ1Y3Qg
dXJiICp1cmI7DQotCWludCBlcnIgPSAwOw0KKwlpbnQgZXJyOw0KKwlpbnQgZXJyX2NvdW50ID0g
MDsNCiANCiAJZGJnKCIlcyBlbnRlcmVkIiwgX19mdW5jX18pOw0KIAkvKiBnZXQgdGhlIGludGVy
cnVwdCBVUkJzIHJlc3VibWl0dGVkIHVuY29uZGl0aW9uYWxseSAqLw0KQEAgLTcyNSwyMSArNzM3
LDIzIEBAIGludCB1c2Jfd3dhbl9yZXN1bWUoc3RydWN0IHVzYl9zZXJpYWwgKnNlcmlhbCkNCiAJ
CWlmIChlcnIgPCAwKSB7DQogCQkJZXJyKCIlczogRXJyb3IgJWQgZm9yIGludGVycnVwdCBVUkIg
b2YgcG9ydCVkIiwNCiAJCQkgICAgX19mdW5jX18sIGVyciwgaSk7DQotCQkJZ290byBlcnJfb3V0
Ow0KKwkJCWVycl9jb3VudCsrOw0KIAkJfQ0KIAl9DQogDQorCXNwaW5fbG9ja19pcnEoJmludGZk
YXRhLT5zdXNwX2xvY2spOw0KIAlmb3IgKGkgPSAwOyBpIDwgc2VyaWFsLT5udW1fcG9ydHM7IGkr
Kykgew0KIAkJLyogd2FsayBhbGwgcG9ydHMgKi8NCiAJCXBvcnQgPSBzZXJpYWwtPnBvcnRbaV07
DQogCQlwb3J0ZGF0YSA9IHVzYl9nZXRfc2VyaWFsX3BvcnRfZGF0YShwb3J0KTsNCiANCiAJCS8q
IHNraXAgY2xvc2VkIHBvcnRzICovDQotCQlzcGluX2xvY2tfaXJxKCZpbnRmZGF0YS0+c3VzcF9s
b2NrKTsNCi0JCWlmICghcG9ydGRhdGEtPm9wZW5lZCkgew0KLQkJCXNwaW5fdW5sb2NrX2lycSgm
aW50ZmRhdGEtPnN1c3BfbG9jayk7DQorCQlpZiAoIXBvcnRkYXRhLT5vcGVuZWQpDQogCQkJY29u
dGludWU7DQotCQl9DQorDQorCQllcnIgPSBwbGF5X2RlbGF5ZWQocG9ydCk7DQorCQlpZiAoZXJy
KQ0KKwkJCWVycl9jb3VudCsrOw0KIA0KIAkJZm9yIChqID0gMDsgaiA8IE5fSU5fVVJCOyBqKysp
IHsNCiAJCQl1cmIgPSBwb3J0ZGF0YS0+aW5fdXJic1tqXTsNCkBAIC03NDcsMTggKzc2MSwxNyBA
QCBpbnQgdXNiX3d3YW5fcmVzdW1lKHN0cnVjdCB1c2Jfc2VyaWFsICpzZXJpYWwpDQogCQkJaWYg
KGVyciA8IDApIHsNCiAJCQkJZXJyKCIlczogRXJyb3IgJWQgZm9yIGJ1bGsgVVJCICVkIiwNCiAJ
CQkJICAgIF9fZnVuY19fLCBlcnIsIGkpOw0KLQkJCQlzcGluX3VubG9ja19pcnEoJmludGZkYXRh
LT5zdXNwX2xvY2spOw0KLQkJCQlnb3RvIGVycl9vdXQ7DQorCQkJCWVycl9jb3VudCsrOw0KIAkJ
CX0NCiAJCX0NCi0JCXBsYXlfZGVsYXllZChwb3J0KTsNCi0JCXNwaW5fdW5sb2NrX2lycSgmaW50
ZmRhdGEtPnN1c3BfbG9jayk7DQogCX0NCi0Jc3Bpbl9sb2NrX2lycSgmaW50ZmRhdGEtPnN1c3Bf
bG9jayk7DQogCWludGZkYXRhLT5zdXNwZW5kZWQgPSAwOw0KIAlzcGluX3VubG9ja19pcnEoJmlu
dGZkYXRhLT5zdXNwX2xvY2spOw0KLWVycl9vdXQ6DQotCXJldHVybiBlcnI7DQorDQorCWlmIChl
cnJfY291bnQpDQorCQlyZXR1cm4gLUVJTzsNCisNCisJcmV0dXJuIDA7DQogfQ0KIEVYUE9SVF9T
WU1CT0wodXNiX3d3YW5fcmVzdW1lKTsNCiAjZW5kaWYNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Zp
ZGVvL21hdHJveC9tYXRyb3hmYl9iYXNlLmggYi9kcml2ZXJzL3ZpZGVvL21hdHJveC9tYXRyb3hm
Yl9iYXNlLmgNCmluZGV4IDU1NmQ5NmMuLjg5YThhODlhIDEwMDY0NA0KLS0tIGEvZHJpdmVycy92
aWRlby9tYXRyb3gvbWF0cm94ZmJfYmFzZS5oDQorKysgYi9kcml2ZXJzL3ZpZGVvL21hdHJveC9t
YXRyb3hmYl9iYXNlLmgNCkBAIC02OTgsNyArNjk4LDcgQEAgdm9pZCBtYXRyb3hmYl91bnJlZ2lz
dGVyX2RyaXZlcihzdHJ1Y3QgbWF0cm94ZmJfZHJpdmVyKiBkcnYpOw0KIA0KICNkZWZpbmUgbWdh
X2ZpZm8obikJZG8ge30gd2hpbGUgKChtZ2FfaW5sKE1fRklGT1NUQVRVUykgJiAweEZGKSA8IChu
KSkNCiANCi0jZGVmaW5lIFdhaXRUaWxsSWRsZSgpCWRvIHt9IHdoaWxlIChtZ2FfaW5sKE1fU1RB
VFVTKSAmIDB4MTAwMDApDQorI2RlZmluZSBXYWl0VGlsbElkbGUoKQlkbyB7IG1nYV9pbmwoTV9T
VEFUVVMpOyBkbyB7fSB3aGlsZSAobWdhX2lubChNX1NUQVRVUykgJiAweDEwMDAwKTsgfSB3aGls
ZSAoMCkNCiANCiAvKiBjb2RlIHNwZWVkdXAgKi8NCiAjaWZkZWYgQ09ORklHX0ZCX01BVFJPWF9N
SUxMRU5JVU0NCmRpZmYgLS1naXQgYS9kcml2ZXJzL3dhdGNoZG9nL2F0aDc5X3dkdC5jIGIvZHJp
dmVycy93YXRjaGRvZy9hdGg3OV93ZHQuYw0KaW5kZXggNzI1Yzg0Yi4uZDI1NmNhNyAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvd2F0Y2hkb2cvYXRoNzlfd2R0LmMNCisrKyBiL2RyaXZlcnMvd2F0Y2hk
b2cvYXRoNzlfd2R0LmMNCkBAIC0xOCw2ICsxOCw3IEBADQogICovDQogDQogI2luY2x1ZGUgPGxp
bnV4L2JpdG9wcy5oPg0KKyNpbmNsdWRlIDxsaW51eC9kZWxheS5oPg0KICNpbmNsdWRlIDxsaW51
eC9lcnJuby5oPg0KICNpbmNsdWRlIDxsaW51eC9mcy5oPg0KICNpbmNsdWRlIDxsaW51eC9pbml0
Lmg+DQpAQCAtNzMsNiArNzQsMTUgQEAgc3RhdGljIGlubGluZSB2b2lkIGF0aDc5X3dkdF9rZWVw
YWxpdmUodm9pZCkNCiBzdGF0aWMgaW5saW5lIHZvaWQgYXRoNzlfd2R0X2VuYWJsZSh2b2lkKQ0K
IHsNCiAJYXRoNzlfd2R0X2tlZXBhbGl2ZSgpOw0KKw0KKwkvKg0KKwkgKiBVcGRhdGluZyB0aGUg
VElNRVIgcmVnaXN0ZXIgcmVxdWlyZXMgYSBmZXcgbWljcm9zZWNvbmRzDQorCSAqIG9uIHRoZSBB
UjkzNHggU29DcyBhdCBsZWFzdC4gVXNlIGEgc21hbGwgZGVsYXkgdG8gZW5zdXJlDQorCSAqIHRo
YXQgdGhlIFRJTUVSIHJlZ2lzdGVyIGlzIHVwZGF0ZWQgd2l0aGluIHRoZSBoYXJkd2FyZQ0KKwkg
KiBiZWZvcmUgZW5hYmxpbmcgdGhlIHdhdGNoZG9nLg0KKwkgKi8NCisJdWRlbGF5KDIpOw0KKw0K
IAlhdGg3OV9yZXNldF93cihBUjcxWFhfUkVTRVRfUkVHX1dET0dfQ1RSTCwgV0RPR19DVFJMX0FD
VElPTl9GQ1IpOw0KIH0NCiANCmRpZmYgLS1naXQgYS9mcy9idHJmcy9leHRlbnRfaW8uYyBiL2Zz
L2J0cmZzL2V4dGVudF9pby5jDQppbmRleCA3M2U0Y2JjLi4wNTkzN2E4IDEwMDY0NA0KLS0tIGEv
ZnMvYnRyZnMvZXh0ZW50X2lvLmMNCisrKyBiL2ZzL2J0cmZzL2V4dGVudF9pby5jDQpAQCAtMTUy
Myw2ICsxNTIzLDcgQEAgYWdhaW46DQogCQkgKiBzaG9ydGVuaW5nIHRoZSBzaXplIG9mIHRoZSBk
ZWxhbGxvYyByYW5nZSB3ZSdyZSBzZWFyY2hpbmcNCiAJCSAqLw0KIAkJZnJlZV9leHRlbnRfc3Rh
dGUoY2FjaGVkX3N0YXRlKTsNCisJCWNhY2hlZF9zdGF0ZSA9IE5VTEw7DQogCQlpZiAoIWxvb3Bz
KSB7DQogCQkJdW5zaWduZWQgbG9uZyBvZmZzZXQgPSAoKnN0YXJ0KSAmIChQQUdFX0NBQ0hFX1NJ
WkUgLSAxKTsNCiAJCQltYXhfYnl0ZXMgPSBQQUdFX0NBQ0hFX1NJWkUgLSBvZmZzZXQ7DQpkaWZm
IC0tZ2l0IGEvZnMvZXh0NC9tYmFsbG9jLmMgYi9mcy9leHQ0L21iYWxsb2MuYw0KaW5kZXggODFm
ZWIxNy4uNzE2OGVlYiAxMDA2NDQNCi0tLSBhL2ZzL2V4dDQvbWJhbGxvYy5jDQorKysgYi9mcy9l
eHQ0L21iYWxsb2MuYw0KQEAgLTMwNjcsNyArMzA2Nyw3IEBAIGV4dDRfbWJfbm9ybWFsaXplX3Jl
cXVlc3Qoc3RydWN0IGV4dDRfYWxsb2NhdGlvbl9jb250ZXh0ICphYywNCiAJfQ0KIAlCVUdfT04o
c3RhcnQgKyBzaXplIDw9IGFjLT5hY19vX2V4LmZlX2xvZ2ljYWwgJiYNCiAJCQlzdGFydCA+IGFj
LT5hY19vX2V4LmZlX2xvZ2ljYWwpOw0KLQlCVUdfT04oc2l6ZSA8PSAwIHx8IHNpemUgPiBFWFQ0
X0NMVVNURVJTX1BFUl9HUk9VUChhYy0+YWNfc2IpKTsNCisJQlVHX09OKHNpemUgPD0gMCB8fCBz
aXplID4gRVhUNF9CTE9DS1NfUEVSX0dST1VQKGFjLT5hY19zYikpOw0KIA0KIAkvKiBub3cgcHJl
cGFyZSBnb2FsIHJlcXVlc3QgKi8NCiANCmRpZmYgLS1naXQgYS9mcy9leHQ0L3BhZ2UtaW8uYyBi
L2ZzL2V4dDQvcGFnZS1pby5jDQppbmRleCBiNDZhNjc1Li5kYzcyZWJmIDEwMDY0NA0KLS0tIGEv
ZnMvZXh0NC9wYWdlLWlvLmMNCisrKyBiL2ZzL2V4dDQvcGFnZS1pby5jDQpAQCAtMzg2LDI0ICsz
ODYsMjQgQEAgaW50IGV4dDRfYmlvX3dyaXRlX3BhZ2Uoc3RydWN0IGV4dDRfaW9fc3VibWl0ICpp
bywNCiAJc2V0X3BhZ2Vfd3JpdGViYWNrKHBhZ2UpOw0KIAlDbGVhclBhZ2VFcnJvcihwYWdlKTsN
CiANCisJLyoNCisJICogQ29tbWVudHMgY29waWVkIGZyb20gYmxvY2tfd3JpdGVfZnVsbF9wYWdl
X2VuZGlvOg0KKwkgKg0KKwkgKiBUaGUgcGFnZSBzdHJhZGRsZXMgaV9zaXplLiAgSXQgbXVzdCBi
ZSB6ZXJvZWQgb3V0IG9uIGVhY2ggYW5kIGV2ZXJ5DQorCSAqIHdyaXRlcGFnZSBpbnZvY2F0aW9u
IGJlY2F1c2UgaXQgbWF5IGJlIG1tYXBwZWQuICAiQSBmaWxlIGlzIG1hcHBlZA0KKwkgKiBpbiBt
dWx0aXBsZXMgb2YgdGhlIHBhZ2Ugc2l6ZS4gIEZvciBhIGZpbGUgdGhhdCBpcyBub3QgYSBtdWx0
aXBsZSBvZg0KKwkgKiB0aGUgcGFnZSBzaXplLCB0aGUgcmVtYWluaW5nIG1lbW9yeSBpcyB6ZXJv
ZWQgd2hlbiBtYXBwZWQsIGFuZA0KKwkgKiB3cml0ZXMgdG8gdGhhdCByZWdpb24gYXJlIG5vdCB3
cml0dGVuIG91dCB0byB0aGUgZmlsZS4iDQorCSAqLw0KKwlpZiAobGVuIDwgUEFHRV9DQUNIRV9T
SVpFKQ0KKwkJemVyb191c2VyX3NlZ21lbnQocGFnZSwgbGVuLCBQQUdFX0NBQ0hFX1NJWkUpOw0K
Kw0KIAlmb3IgKGJoID0gaGVhZCA9IHBhZ2VfYnVmZmVycyhwYWdlKSwgYmxvY2tfc3RhcnQgPSAw
Ow0KIAkgICAgIGJoICE9IGhlYWQgfHwgIWJsb2NrX3N0YXJ0Ow0KIAkgICAgIGJsb2NrX3N0YXJ0
ID0gYmxvY2tfZW5kLCBiaCA9IGJoLT5iX3RoaXNfcGFnZSkgew0KIA0KIAkJYmxvY2tfZW5kID0g
YmxvY2tfc3RhcnQgKyBibG9ja3NpemU7DQogCQlpZiAoYmxvY2tfc3RhcnQgPj0gbGVuKSB7DQot
CQkJLyoNCi0JCQkgKiBDb21tZW50cyBjb3BpZWQgZnJvbSBibG9ja193cml0ZV9mdWxsX3BhZ2Vf
ZW5kaW86DQotCQkJICoNCi0JCQkgKiBUaGUgcGFnZSBzdHJhZGRsZXMgaV9zaXplLiAgSXQgbXVz
dCBiZSB6ZXJvZWQgb3V0IG9uDQotCQkJICogZWFjaCBhbmQgZXZlcnkgd3JpdGVwYWdlIGludm9j
YXRpb24gYmVjYXVzZSBpdCBtYXkNCi0JCQkgKiBiZSBtbWFwcGVkLiAgIkEgZmlsZSBpcyBtYXBw
ZWQgaW4gbXVsdGlwbGVzIG9mIHRoZQ0KLQkJCSAqIHBhZ2Ugc2l6ZS4gIEZvciBhIGZpbGUgdGhh
dCBpcyBub3QgYSBtdWx0aXBsZSBvZg0KLQkJCSAqIHRoZSAgcGFnZSBzaXplLCB0aGUgcmVtYWlu
aW5nIG1lbW9yeSBpcyB6ZXJvZWQgd2hlbg0KLQkJCSAqIG1hcHBlZCwgYW5kIHdyaXRlcyB0byB0
aGF0IHJlZ2lvbiBhcmUgbm90IHdyaXR0ZW4NCi0JCQkgKiBvdXQgdG8gdGhlIGZpbGUuIg0KLQkJ
CSAqLw0KLQkJCXplcm9fdXNlcl9zZWdtZW50KHBhZ2UsIGJsb2NrX3N0YXJ0LCBibG9ja19lbmQp
Ow0KIAkJCWNsZWFyX2J1ZmZlcl9kaXJ0eShiaCk7DQogCQkJc2V0X2J1ZmZlcl91cHRvZGF0ZShi
aCk7DQogCQkJY29udGludWU7DQpkaWZmIC0tZ2l0IGEvZnMvbmZzZC9uZnM0c3RhdGUuYyBiL2Zz
L25mc2QvbmZzNHN0YXRlLmMNCmluZGV4IGIyZTBhNTUuLjZlOTFmOGIgMTAwNjQ0DQotLS0gYS9m
cy9uZnNkL25mczRzdGF0ZS5jDQorKysgYi9mcy9uZnNkL25mczRzdGF0ZS5jDQpAQCAtMzM3LDEz
ICszMzcsMjIgQEAgc3RhdGljIHZvaWQgdW5oYXNoX3N0aWQoc3RydWN0IG5mczRfc3RpZCAqcykN
CiAJaWRyX3JlbW92ZShzdGF0ZWlkcywgcy0+c2Nfc3RhdGVpZC5zaV9vcGFxdWUuc29faWQpOw0K
IH0NCiANCitzdGF0aWMgdm9pZA0KK2hhc2hfZGVsZWdhdGlvbl9sb2NrZWQoc3RydWN0IG5mczRf
ZGVsZWdhdGlvbiAqZHAsIHN0cnVjdCBuZnM0X2ZpbGUgKmZwKQ0KK3sNCisJbG9ja2RlcF9hc3Nl
cnRfaGVsZCgmcmVjYWxsX2xvY2spOw0KKw0KKwlsaXN0X2FkZCgmZHAtPmRsX3BlcmZpbGUsICZm
cC0+ZmlfZGVsZWdhdGlvbnMpOw0KKwlsaXN0X2FkZCgmZHAtPmRsX3BlcmNsbnQsICZkcC0+ZGxf
c3RpZC5zY19jbGllbnQtPmNsX2RlbGVnYXRpb25zKTsNCit9DQorDQogLyogQ2FsbGVkIHVuZGVy
IHRoZSBzdGF0ZSBsb2NrLiAqLw0KIHN0YXRpYyB2b2lkDQogdW5oYXNoX2RlbGVnYXRpb24oc3Ry
dWN0IG5mczRfZGVsZWdhdGlvbiAqZHApDQogew0KIAl1bmhhc2hfc3RpZCgmZHAtPmRsX3N0aWQp
Ow0KLQlsaXN0X2RlbF9pbml0KCZkcC0+ZGxfcGVyY2xudCk7DQogCXNwaW5fbG9jaygmcmVjYWxs
X2xvY2spOw0KKwlsaXN0X2RlbF9pbml0KCZkcC0+ZGxfcGVyY2xudCk7DQogCWxpc3RfZGVsX2lu
aXQoJmRwLT5kbF9wZXJmaWxlKTsNCiAJbGlzdF9kZWxfaW5pdCgmZHAtPmRsX3JlY2FsbF9scnUp
Ow0KIAlzcGluX3VubG9jaygmcmVjYWxsX2xvY2spOw0KQEAgLTI4MTAsMTAgKzI4MTksOCBAQCBz
dGF0aWMgaW50IG5mczRfc2V0bGVhc2Uoc3RydWN0IG5mczRfZGVsZWdhdGlvbiAqZHAsIGludCBm
bGFnKQ0KIAlpZiAoIWZsKQ0KIAkJcmV0dXJuIC1FTk9NRU07DQogCWZsLT5mbF9maWxlID0gZmlu
ZF9yZWFkYWJsZV9maWxlKGZwKTsNCi0JbGlzdF9hZGQoJmRwLT5kbF9wZXJjbG50LCAmZHAtPmRs
X3N0aWQuc2NfY2xpZW50LT5jbF9kZWxlZ2F0aW9ucyk7DQogCXN0YXR1cyA9IHZmc19zZXRsZWFz
ZShmbC0+ZmxfZmlsZSwgZmwtPmZsX3R5cGUsICZmbCk7DQogCWlmIChzdGF0dXMpIHsNCi0JCWxp
c3RfZGVsX2luaXQoJmRwLT5kbF9wZXJjbG50KTsNCiAJCWxvY2tzX2ZyZWVfbG9jayhmbCk7DQog
CQlyZXR1cm4gLUVOT01FTTsNCiAJfQ0KQEAgLTI4MjEsNyArMjgyOCw5IEBAIHN0YXRpYyBpbnQg
bmZzNF9zZXRsZWFzZShzdHJ1Y3QgbmZzNF9kZWxlZ2F0aW9uICpkcCwgaW50IGZsYWcpDQogCWZw
LT5maV9kZWxlZ19maWxlID0gZmwtPmZsX2ZpbGU7DQogCWdldF9maWxlKGZwLT5maV9kZWxlZ19m
aWxlKTsNCiAJYXRvbWljX3NldCgmZnAtPmZpX2RlbGVnZWVzLCAxKTsNCi0JbGlzdF9hZGQoJmRw
LT5kbF9wZXJmaWxlLCAmZnAtPmZpX2RlbGVnYXRpb25zKTsNCisJc3Bpbl9sb2NrKCZyZWNhbGxf
bG9jayk7DQorCWhhc2hfZGVsZWdhdGlvbl9sb2NrZWQoZHAsIGZwKTsNCisJc3Bpbl91bmxvY2so
JnJlY2FsbF9sb2NrKTsNCiAJcmV0dXJuIDA7DQogfQ0KIA0KQEAgLTI4MzcsOSArMjg0Niw4IEBA
IHN0YXRpYyBpbnQgbmZzNF9zZXRfZGVsZWdhdGlvbihzdHJ1Y3QgbmZzNF9kZWxlZ2F0aW9uICpk
cCwgaW50IGZsYWcpDQogCQlyZXR1cm4gLUVBR0FJTjsNCiAJfQ0KIAlhdG9taWNfaW5jKCZmcC0+
ZmlfZGVsZWdlZXMpOw0KLQlsaXN0X2FkZCgmZHAtPmRsX3BlcmZpbGUsICZmcC0+ZmlfZGVsZWdh
dGlvbnMpOw0KKwloYXNoX2RlbGVnYXRpb25fbG9ja2VkKGRwLCBmcCk7DQogCXNwaW5fdW5sb2Nr
KCZyZWNhbGxfbG9jayk7DQotCWxpc3RfYWRkKCZkcC0+ZGxfcGVyY2xudCwgJmRwLT5kbF9zdGlk
LnNjX2NsaWVudC0+Y2xfZGVsZWdhdGlvbnMpOw0KIAlyZXR1cm4gMDsNCiB9DQogDQpAQCAtMzM4
NSw3ICszMzkzLDcgQEAgbmZzZDRfZnJlZV9sb2NrX3N0YXRlaWQoc3RydWN0IG5mczRfb2xfc3Rh
dGVpZCAqc3RwKQ0KIAkgKiBjb3JyZXNwb25kYW5jZSwgYW5kIHdlIGhhdmUgdG8gZGVsZXRlIHRo
ZSBsb2Nrb3duZXIgd2hlbiB3ZQ0KIAkgKiBkZWxldGUgdGhlIGxvY2sgc3RhdGVpZDoNCiAJICov
DQotCXVuaGFzaF9sb2Nrb3duZXIobG8pOw0KKwlyZWxlYXNlX2xvY2tvd25lcihsbyk7DQogCXJl
dHVybiBuZnNfb2s7DQogfQ0KIA0KZGlmZiAtLWdpdCBhL2ZzL25mc2QvbmZzNHhkci5jIGIvZnMv
bmZzZC9uZnM0eGRyLmMNCmluZGV4IDQ4MzViOTAuLmE3OTMzZGQgMTAwNjQ0DQotLS0gYS9mcy9u
ZnNkL25mczR4ZHIuYw0KKysrIGIvZnMvbmZzZC9uZnM0eGRyLmMNCkBAIC0yMDM1LDggKzIwMzUs
OCBAQCBuZnNkNF9lbmNvZGVfZmF0dHIoc3RydWN0IHN2Y19maCAqZmhwLCBzdHJ1Y3Qgc3ZjX2V4
cG9ydCAqZXhwLA0KIAllcnIgPSB2ZnNfZ2V0YXR0cihleHAtPmV4X3BhdGgubW50LCBkZW50cnks
ICZzdGF0KTsNCiAJaWYgKGVycikNCiAJCWdvdG8gb3V0X25mc2VycjsNCi0JaWYgKChibXZhbDAg
JiAoRkFUVFI0X1dPUkQwX0ZJTEVTX0ZSRUUgfCBGQVRUUjRfV09SRDBfRklMRVNfVE9UQUwgfA0K
LQkJCUZBVFRSNF9XT1JEMF9NQVhOQU1FKSkgfHwNCisJaWYgKChibXZhbDAgJiAoRkFUVFI0X1dP
UkQwX0ZJTEVTX0FWQUlMIHwgRkFUVFI0X1dPUkQwX0ZJTEVTX0ZSRUUgfA0KKwkJCUZBVFRSNF9X
T1JEMF9GSUxFU19UT1RBTCB8IEZBVFRSNF9XT1JEMF9NQVhOQU1FKSkgfHwNCiAJICAgIChibXZh
bDEgJiAoRkFUVFI0X1dPUkQxX1NQQUNFX0FWQUlMIHwgRkFUVFI0X1dPUkQxX1NQQUNFX0ZSRUUg
fA0KIAkJICAgICAgIEZBVFRSNF9XT1JEMV9TUEFDRV9UT1RBTCkpKSB7DQogCQllcnIgPSB2ZnNf
c3RhdGZzKCZwYXRoLCAmc3RhdGZzKTsNCmRpZmYgLS1naXQgYS9mcy9yZWlzZXJmcy9maWxlLmMg
Yi9mcy9yZWlzZXJmcy9maWxlLmMNCmluZGV4IGFjZTYzNTAuLmYwMTExODUgMTAwNjQ0DQotLS0g
YS9mcy9yZWlzZXJmcy9maWxlLmMNCisrKyBiL2ZzL3JlaXNlcmZzL2ZpbGUuYw0KQEAgLTEyNiw3
ICsxMjYsNyBAQCBzdGF0aWMgaW50IHJlaXNlcmZzX2ZpbGVfb3BlbihzdHJ1Y3QgaW5vZGUgKmlu
b2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkNCiAJcmV0dXJuIGVycjsNCiB9DQogDQotc3RhdGljIHZv
aWQgcmVpc2VyZnNfdmZzX3RydW5jYXRlX2ZpbGUoc3RydWN0IGlub2RlICppbm9kZSkNCit2b2lk
IHJlaXNlcmZzX3Zmc190cnVuY2F0ZV9maWxlKHN0cnVjdCBpbm9kZSAqaW5vZGUpDQogew0KIAlt
dXRleF9sb2NrKCYoUkVJU0VSRlNfSShpbm9kZSktPnRhaWxwYWNrKSk7DQogCXJlaXNlcmZzX3Ry
dW5jYXRlX2ZpbGUoaW5vZGUsIDEpOw0KQEAgLTMxMiw3ICszMTIsNiBAQCBjb25zdCBzdHJ1Y3Qg
ZmlsZV9vcGVyYXRpb25zIHJlaXNlcmZzX2ZpbGVfb3BlcmF0aW9ucyA9IHsNCiB9Ow0KIA0KIGNv
bnN0IHN0cnVjdCBpbm9kZV9vcGVyYXRpb25zIHJlaXNlcmZzX2ZpbGVfaW5vZGVfb3BlcmF0aW9u
cyA9IHsNCi0JLnRydW5jYXRlID0gcmVpc2VyZnNfdmZzX3RydW5jYXRlX2ZpbGUsDQogCS5zZXRh
dHRyID0gcmVpc2VyZnNfc2V0YXR0ciwNCiAJLnNldHhhdHRyID0gcmVpc2VyZnNfc2V0eGF0dHIs
DQogCS5nZXR4YXR0ciA9IHJlaXNlcmZzX2dldHhhdHRyLA0KZGlmZiAtLWdpdCBhL2ZzL3JlaXNl
cmZzL2lub2RlLmMgYi9mcy9yZWlzZXJmcy9pbm9kZS5jDQppbmRleCBmZTY3N2MwLi5mY2IwN2U1
IDEwMDY0NA0KLS0tIGEvZnMvcmVpc2VyZnMvaW5vZGUuYw0KKysrIGIvZnMvcmVpc2VyZnMvaW5v
ZGUuYw0KQEAgLTMwOTEsOCArMzA5MSwxMCBAQCBzdGF0aWMgc3NpemVfdCByZWlzZXJmc19kaXJl
Y3RfSU8oaW50IHJ3LCBzdHJ1Y3Qga2lvY2IgKmlvY2IsDQogCQlsb2ZmX3QgaXNpemUgPSBpX3Np
emVfcmVhZChpbm9kZSk7DQogCQlsb2ZmX3QgZW5kID0gb2Zmc2V0ICsgaW92X2xlbmd0aChpb3Ys
IG5yX3NlZ3MpOw0KIA0KLQkJaWYgKGVuZCA+IGlzaXplKQ0KLQkJCXZtdHJ1bmNhdGUoaW5vZGUs
IGlzaXplKTsNCisJCWlmICgoZW5kID4gaXNpemUpICYmIGlub2RlX25ld3NpemVfb2soaW5vZGUs
IGlzaXplKSA9PSAwKSB7DQorCQkJdHJ1bmNhdGVfc2V0c2l6ZShpbm9kZSwgaXNpemUpOw0KKwkJ
CXJlaXNlcmZzX3Zmc190cnVuY2F0ZV9maWxlKGlub2RlKTsNCisJCX0NCiAJfQ0KIA0KIAlyZXR1
cm4gcmV0Ow0KQEAgLTMyMDYsOCArMzIwOCwxOSBAQCBpbnQgcmVpc2VyZnNfc2V0YXR0cihzdHJ1
Y3QgZGVudHJ5ICpkZW50cnksIHN0cnVjdCBpYXR0ciAqYXR0cikNCiAJICovDQogCXJlaXNlcmZz
X3dyaXRlX3VubG9ja19vbmNlKGlub2RlLT5pX3NiLCBkZXB0aCk7DQogCWlmICgoYXR0ci0+aWFf
dmFsaWQgJiBBVFRSX1NJWkUpICYmDQotCSAgICBhdHRyLT5pYV9zaXplICE9IGlfc2l6ZV9yZWFk
KGlub2RlKSkNCi0JCWVycm9yID0gdm10cnVuY2F0ZShpbm9kZSwgYXR0ci0+aWFfc2l6ZSk7DQor
CSAgICBhdHRyLT5pYV9zaXplICE9IGlfc2l6ZV9yZWFkKGlub2RlKSkgew0KKwkJZXJyb3IgPSBp
bm9kZV9uZXdzaXplX29rKGlub2RlLCBhdHRyLT5pYV9zaXplKTsNCisJCWlmICghZXJyb3IpIHsN
CisJCQkvKg0KKwkJCSAqIENvdWxkIHJhY2UgYWdhaW5zdCByZWlzZXJmc19maWxlX3JlbGVhc2UN
CisJCQkgKiBpZiBjYWxsZWQgZnJvbSBORlMsIHNvIHRha2UgdGFpbHBhY2sgbXV0ZXguDQorCQkJ
ICovDQorCQkJbXV0ZXhfbG9jaygmUkVJU0VSRlNfSShpbm9kZSktPnRhaWxwYWNrKTsNCisJCQl0
cnVuY2F0ZV9zZXRzaXplKGlub2RlLCBhdHRyLT5pYV9zaXplKTsNCisJCQlyZWlzZXJmc190cnVu
Y2F0ZV9maWxlKGlub2RlLCAxKTsNCisJCQltdXRleF91bmxvY2soJlJFSVNFUkZTX0koaW5vZGUp
LT50YWlscGFjayk7DQorCQl9DQorCX0NCiANCiAJaWYgKCFlcnJvcikgew0KIAkJc2V0YXR0cl9j
b3B5KGlub2RlLCBhdHRyKTsNCmRpZmYgLS1naXQgYS9mcy91Ymlmcy9maWxlLmMgYi9mcy91Ymlm
cy9maWxlLmMNCmluZGV4IGY5YzIzNGIuLjY1ODkwMDYgMTAwNjQ0DQotLS0gYS9mcy91Ymlmcy9m
aWxlLmMNCisrKyBiL2ZzL3ViaWZzL2ZpbGUuYw0KQEAgLTE1MjIsOCArMTUyMiw3IEBAIHN0YXRp
YyBpbnQgdWJpZnNfdm1fcGFnZV9ta3dyaXRlKHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hLA0K
IAkJCXViaWZzX3JlbGVhc2VfZGlydHlfaW5vZGVfYnVkZ2V0KGMsIHVpKTsNCiAJfQ0KIA0KLQl1
bmxvY2tfcGFnZShwYWdlKTsNCi0JcmV0dXJuIDA7DQorCXJldHVybiBWTV9GQVVMVF9MT0NLRUQ7
DQogDQogb3V0X3VubG9jazoNCiAJdW5sb2NrX3BhZ2UocGFnZSk7DQpkaWZmIC0tZ2l0IGEvZnMv
dWJpZnMvc2hyaW5rZXIuYyBiL2ZzL3ViaWZzL3Nocmlua2VyLmMNCmluZGV4IDllMWQwNTYuLmUw
YTdhNzYgMTAwNjQ0DQotLS0gYS9mcy91Ymlmcy9zaHJpbmtlci5jDQorKysgYi9mcy91Ymlmcy9z
aHJpbmtlci5jDQpAQCAtMTI4LDcgKzEyOCw2IEBAIHN0YXRpYyBpbnQgc2hyaW5rX3RuYyhzdHJ1
Y3QgdWJpZnNfaW5mbyAqYywgaW50IG5yLCBpbnQgYWdlLCBpbnQgKmNvbnRlbnRpb24pDQogCQkJ
ZnJlZWQgPSB1Ymlmc19kZXN0cm95X3RuY19zdWJ0cmVlKHpub2RlKTsNCiAJCQlhdG9taWNfbG9u
Z19zdWIoZnJlZWQsICZ1Ymlmc19jbGVhbl96bl9jbnQpOw0KIAkJCWF0b21pY19sb25nX3N1Yihm
cmVlZCwgJmMtPmNsZWFuX3puX2NudCk7DQotCQkJdWJpZnNfYXNzZXJ0KGF0b21pY19sb25nX3Jl
YWQoJmMtPmNsZWFuX3puX2NudCkgPj0gMCk7DQogCQkJdG90YWxfZnJlZWQgKz0gZnJlZWQ7DQog
CQkJem5vZGUgPSB6cHJldjsNCiAJCX0NCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2lycWRl
c2MuaCBiL2luY2x1ZGUvbGludXgvaXJxZGVzYy5oDQppbmRleCBmMWUyNTI3Li5lMmUxYWI1IDEw
MDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9pcnFkZXNjLmgNCisrKyBiL2luY2x1ZGUvbGludXgv
aXJxZGVzYy5oDQpAQCAtMjcsNiArMjcsOCBAQCBzdHJ1Y3QgbW9kdWxlOw0KICAqIEBpcnFfY291
bnQ6CQlzdGF0cyBmaWVsZCB0byBkZXRlY3Qgc3RhbGxlZCBpcnFzDQogICogQGxhc3RfdW5oYW5k
bGVkOglhZ2luZyB0aW1lciBmb3IgdW5oYW5kbGVkIGNvdW50DQogICogQGlycXNfdW5oYW5kbGVk
OglzdGF0cyBmaWVsZCBmb3Igc3B1cmlvdXMgdW5oYW5kbGVkIGludGVycnVwdHMNCisgKiBAdGhy
ZWFkc19oYW5kbGVkOglzdGF0cyBmaWVsZCBmb3IgZGVmZXJyZWQgc3B1cmlvdXMgZGV0ZWN0aW9u
IG9mIHRocmVhZGVkIGhhbmRsZXJzDQorICogQHRocmVhZHNfaGFuZGxlZF9sYXN0OiBjb21wYXJh
dG9yIGZpZWxkIGZvciBkZWZlcnJlZCBzcHVyaW91cyBkZXRlY3Rpb24gb2YgdGhlcmFkZWQgaGFu
ZGxlcnMNCiAgKiBAbG9jazoJCWxvY2tpbmcgZm9yIFNNUA0KICAqIEBhZmZpbml0eV9oaW50Oglo
aW50IHRvIHVzZXIgc3BhY2UgZm9yIHByZWZlcnJlZCBpcnEgYWZmaW5pdHkNCiAgKiBAYWZmaW5p
dHlfbm90aWZ5Ogljb250ZXh0IGZvciBub3RpZmljYXRpb24gb2YgYWZmaW5pdHkgY2hhbmdlcw0K
QEAgLTUzLDYgKzU1LDggQEAgc3RydWN0IGlycV9kZXNjIHsNCiAJdW5zaWduZWQgaW50CQlpcnFf
Y291bnQ7CS8qIEZvciBkZXRlY3RpbmcgYnJva2VuIElSUXMgKi8NCiAJdW5zaWduZWQgbG9uZwkJ
bGFzdF91bmhhbmRsZWQ7CS8qIEFnaW5nIHRpbWVyIGZvciB1bmhhbmRsZWQgY291bnQgKi8NCiAJ
dW5zaWduZWQgaW50CQlpcnFzX3VuaGFuZGxlZDsNCisJYXRvbWljX3QJCXRocmVhZHNfaGFuZGxl
ZDsNCisJaW50CQkJdGhyZWFkc19oYW5kbGVkX2xhc3Q7DQogCXJhd19zcGlubG9ja190CQlsb2Nr
Ow0KIAlzdHJ1Y3QgY3B1bWFzawkJKnBlcmNwdV9lbmFibGVkOw0KICNpZmRlZiBDT05GSUdfU01Q
DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9sem8uaCBiL2luY2x1ZGUvbGludXgvbHpvLmgN
CmluZGV4IGQ3OTM0OTcuLmEwODQ4ZDkgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L2x6by5o
DQorKysgYi9pbmNsdWRlL2xpbnV4L2x6by5oDQpAQCAtNCwyOCArNCwyOCBAQA0KICAqICBMWk8g
UHVibGljIEtlcm5lbCBJbnRlcmZhY2UNCiAgKiAgQSBtaW5pIHN1YnNldCBvZiB0aGUgTFpPIHJl
YWwtdGltZSBkYXRhIGNvbXByZXNzaW9uIGxpYnJhcnkNCiAgKg0KLSAqICBDb3B5cmlnaHQgKEMp
IDE5OTYtMjAwNSBNYXJrdXMgRi5YLkouIE9iZXJodW1lciA8bWFya3VzQG9iZXJodW1lci5jb20+
DQorICogIENvcHlyaWdodCAoQykgMTk5Ni0yMDEyIE1hcmt1cyBGLlguSi4gT2Jlcmh1bWVyIDxt
YXJrdXNAb2Jlcmh1bWVyLmNvbT4NCiAgKg0KICAqICBUaGUgZnVsbCBMWk8gcGFja2FnZSBjYW4g
YmUgZm91bmQgYXQ6DQogICogIGh0dHA6Ly93d3cub2Jlcmh1bWVyLmNvbS9vcGVuc291cmNlL2x6
by8NCiAgKg0KLSAqICBDaGFuZ2VkIGZvciBrZXJuZWwgdXNlIGJ5Og0KKyAqICBDaGFuZ2VkIGZv
ciBMaW51eCBrZXJuZWwgdXNlIGJ5Og0KICAqICBOaXRpbiBHdXB0YSA8bml0aW5ndXB0YTkxMEBn
bWFpbC5jb20+DQogICogIFJpY2hhcmQgUHVyZGllIDxycHVyZGllQG9wZW5lZGhhbmQuY29tPg0K
ICAqLw0KIA0KLSNkZWZpbmUgTFpPMVhfTUVNX0NPTVBSRVNTCSgxNjM4NCAqIHNpemVvZih1bnNp
Z25lZCBjaGFyICopKQ0KLSNkZWZpbmUgTFpPMVhfMV9NRU1fQ09NUFJFU1MJTFpPMVhfTUVNX0NP
TVBSRVNTDQorI2RlZmluZSBMWk8xWF8xX01FTV9DT01QUkVTUwkoODE5MiAqIHNpemVvZih1bnNp
Z25lZCBzaG9ydCkpDQorI2RlZmluZSBMWk8xWF9NRU1fQ09NUFJFU1MJTFpPMVhfMV9NRU1fQ09N
UFJFU1MNCiANCiAjZGVmaW5lIGx6bzF4X3dvcnN0X2NvbXByZXNzKHgpICgoeCkgKyAoKHgpIC8g
MTYpICsgNjQgKyAzKQ0KIA0KLS8qIFRoaXMgcmVxdWlyZXMgJ3dvcmttZW0nIG9mIHNpemUgTFpP
MVhfMV9NRU1fQ09NUFJFU1MgKi8NCisvKiBUaGlzIHJlcXVpcmVzICd3cmttZW0nIG9mIHNpemUg
TFpPMVhfMV9NRU1fQ09NUFJFU1MgKi8NCiBpbnQgbHpvMXhfMV9jb21wcmVzcyhjb25zdCB1bnNp
Z25lZCBjaGFyICpzcmMsIHNpemVfdCBzcmNfbGVuLA0KLQkJCXVuc2lnbmVkIGNoYXIgKmRzdCwg
c2l6ZV90ICpkc3RfbGVuLCB2b2lkICp3cmttZW0pOw0KKwkJICAgICB1bnNpZ25lZCBjaGFyICpk
c3QsIHNpemVfdCAqZHN0X2xlbiwgdm9pZCAqd3JrbWVtKTsNCiANCiAvKiBzYWZlIGRlY29tcHJl
c3Npb24gd2l0aCBvdmVycnVuIHRlc3RpbmcgKi8NCiBpbnQgbHpvMXhfZGVjb21wcmVzc19zYWZl
KGNvbnN0IHVuc2lnbmVkIGNoYXIgKnNyYywgc2l6ZV90IHNyY19sZW4sDQotCQkJdW5zaWduZWQg
Y2hhciAqZHN0LCBzaXplX3QgKmRzdF9sZW4pOw0KKwkJCSAgdW5zaWduZWQgY2hhciAqZHN0LCBz
aXplX3QgKmRzdF9sZW4pOw0KIA0KIC8qDQogICogUmV0dXJuIHZhbHVlcyAoPCAwID0gRXJyb3Ip
DQpAQCAtNDAsNSArNDAsNiBAQCBpbnQgbHpvMXhfZGVjb21wcmVzc19zYWZlKGNvbnN0IHVuc2ln
bmVkIGNoYXIgKnNyYywgc2l6ZV90IHNyY19sZW4sDQogI2RlZmluZSBMWk9fRV9FT0ZfTk9UX0ZP
VU5ECQkoLTcpDQogI2RlZmluZSBMWk9fRV9JTlBVVF9OT1RfQ09OU1VNRUQJKC04KQ0KICNkZWZp
bmUgTFpPX0VfTk9UX1lFVF9JTVBMRU1FTlRFRAkoLTkpDQorI2RlZmluZSBMWk9fRV9JTlZBTElE
X0FSR1VNRU5UCQkoLTEwKQ0KIA0KICNlbmRpZg0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgv
cHRyYWNlLmggYi9pbmNsdWRlL2xpbnV4L3B0cmFjZS5oDQppbmRleCA4MDBmMTEzLi5lNDkyNDBi
IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9wdHJhY2UuaA0KKysrIGIvaW5jbHVkZS9saW51
eC9wdHJhY2UuaA0KQEAgLTExMiw2ICsxMTIsNyBAQA0KIA0KICNpbmNsdWRlIDxsaW51eC9jb21w
aWxlci5oPgkJLyogRm9yIHVubGlrZWx5LiAgKi8NCiAjaW5jbHVkZSA8bGludXgvc2NoZWQuaD4J
CS8qIEZvciBzdHJ1Y3QgdGFza19zdHJ1Y3QuICAqLw0KKyNpbmNsdWRlIDxsaW51eC9waWRfbmFt
ZXNwYWNlLmg+CS8qIEZvciB0YXNrX2FjdGl2ZV9waWRfbnMuICAqLw0KIA0KIA0KIGV4dGVybiBs
b25nIGFyY2hfcHRyYWNlKHN0cnVjdCB0YXNrX3N0cnVjdCAqY2hpbGQsIGxvbmcgcmVxdWVzdCwN
CkBAIC0yMDQsNiArMjA1LDM3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBwdHJhY2VfZXZlbnQoaW50
IGV2ZW50LCB1bnNpZ25lZCBsb25nIG1lc3NhZ2UpDQogfQ0KIA0KIC8qKg0KKyAqIHB0cmFjZV9l
dmVudF9waWQgLSBwb3NzaWJseSBzdG9wIGZvciBhIHB0cmFjZSBldmVudCBub3RpZmljYXRpb24N
CisgKiBAZXZlbnQ6CSVQVFJBQ0VfRVZFTlRfKiB2YWx1ZSB0byByZXBvcnQNCisgKiBAcGlkOglw
cm9jZXNzIGlkZW50aWZpZXIgZm9yICVQVFJBQ0VfR0VURVZFTlRNU0cgdG8gcmV0dXJuDQorICoN
CisgKiBDaGVjayB3aGV0aGVyIEBldmVudCBpcyBlbmFibGVkIGFuZCwgaWYgc28sIHJlcG9ydCBA
ZXZlbnQgYW5kIEBwaWQNCisgKiB0byB0aGUgcHRyYWNlIHBhcmVudC4gIEBwaWQgaXMgcmVwb3J0
ZWQgYXMgdGhlIHBpZF90IHNlZW4gZnJvbSB0aGUNCisgKiB0aGUgcHRyYWNlIHBhcmVudCdzIHBp
ZCBuYW1lc3BhY2UuDQorICoNCisgKiBDYWxsZWQgd2l0aG91dCBsb2Nrcy4NCisgKi8NCitzdGF0
aWMgaW5saW5lIHZvaWQgcHRyYWNlX2V2ZW50X3BpZChpbnQgZXZlbnQsIHN0cnVjdCBwaWQgKnBp
ZCkNCit7DQorCS8qDQorCSAqIEZJWE1FOiBUaGVyZSdzIGEgcG90ZW50aWFsIHJhY2UgaWYgYSBw
dHJhY2VyIGluIGEgZGlmZmVyZW50IHBpZA0KKwkgKiBuYW1lc3BhY2UgdGhhbiBwYXJlbnQgYXR0
YWNoZXMgYmV0d2VlbiBjb21wdXRpbmcgbWVzc2FnZSBiZWxvdyBhbmQNCisJICogd2hlbiB3ZSBh
Y3F1aXJlIHRhc2tsaXN0X2xvY2sgaW4gcHRyYWNlX3N0b3AoKS4gIElmIHRoaXMgaGFwcGVucywN
CisJICogdGhlIHB0cmFjZXIgd2lsbCBnZXQgYSBib2d1cyBwaWQgZnJvbSBQVFJBQ0VfR0VURVZF
TlRNU0cuDQorCSAqLw0KKwl1bnNpZ25lZCBsb25nIG1lc3NhZ2UgPSAwOw0KKwlzdHJ1Y3QgcGlk
X25hbWVzcGFjZSAqbnM7DQorDQorCXJjdV9yZWFkX2xvY2soKTsNCisJbnMgPSB0YXNrX2FjdGl2
ZV9waWRfbnMocmN1X2RlcmVmZXJlbmNlKGN1cnJlbnQtPnBhcmVudCkpOw0KKwlpZiAobnMpDQor
CQltZXNzYWdlID0gcGlkX25yX25zKHBpZCwgbnMpOw0KKwlyY3VfcmVhZF91bmxvY2soKTsNCisN
CisJcHRyYWNlX2V2ZW50KGV2ZW50LCBtZXNzYWdlKTsNCit9DQorDQorLyoqDQogICogcHRyYWNl
X2luaXRfdGFzayAtIGluaXRpYWxpemUgcHRyYWNlIHN0YXRlIGZvciBhIG5ldyBjaGlsZA0KICAq
IEBjaGlsZDoJCW5ldyBjaGlsZCB0YXNrDQogICogQHB0cmFjZToJCXRydWUgaWYgY2hpbGQgc2hv
dWxkIGJlIHB0cmFjZSdkIGJ5IHBhcmVudCdzIHRyYWNlcg0KQEAgLTM3MSw2ICs0MDMsOSBAQCBz
dGF0aWMgaW5saW5lIHZvaWQgdXNlcl9zaW5nbGVfc3RlcF9zaWdpbmZvKHN0cnVjdCB0YXNrX3N0
cnVjdCAqdHNrLA0KICAqIGNhbGxpbmcgYXJjaF9wdHJhY2Vfc3RvcCgpIHdoZW4gaXQgd291bGQg
YmUgc3VwZXJmbHVvdXMuICBGb3IgZXhhbXBsZSwNCiAgKiBpZiB0aGUgdGhyZWFkIGhhcyBub3Qg
YmVlbiBiYWNrIHRvIHVzZXIgbW9kZSBzaW5jZSB0aGUgbGFzdCBzdG9wLCB0aGUNCiAgKiB0aHJl
YWQgc3RhdGUgbWlnaHQgaW5kaWNhdGUgdGhhdCBub3RoaW5nIG5lZWRzIHRvIGJlIGRvbmUuDQor
ICoNCisgKiBUaGlzIGlzIGd1YXJhbnRlZWQgdG8gYmUgaW52b2tlZCBvbmNlIGJlZm9yZSBhIHRh
c2sgc3RvcHMgZm9yIHB0cmFjZSBhbmQNCisgKiBtYXkgaW5jbHVkZSBhcmNoLXNwZWNpZmljIG9w
ZXJhdGlvbnMgbmVjZXNzYXJ5IHByaW9yIHRvIGEgcHRyYWNlIHN0b3AuDQogICovDQogI2RlZmlu
ZSBhcmNoX3B0cmFjZV9zdG9wX25lZWRlZChjb2RlLCBpbmZvKQkoMCkNCiAjZW5kaWYNCmRpZmYg
LS1naXQgYS9pbmNsdWRlL2xpbnV4L3JlaXNlcmZzX2ZzLmggYi9pbmNsdWRlL2xpbnV4L3JlaXNl
cmZzX2ZzLmgNCmluZGV4IDk2ZDQ2NWYuLjQzYzcyNTEgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xp
bnV4L3JlaXNlcmZzX2ZzLmgNCisrKyBiL2luY2x1ZGUvbGludXgvcmVpc2VyZnNfZnMuaA0KQEAg
LTE4ODIsNiArMTg4Miw3IEBAIHN0cnVjdCByZWlzZXJmc190cmFuc2FjdGlvbl9oYW5kbGUgKnJl
aXNlcmZzX3BlcnNpc3RlbnRfdHJhbnNhY3Rpb24oc3RydWN0DQogCQkJCQkJCQkgICAgKiwNCiAJ
CQkJCQkJCSAgICBpbnQgY291bnQpOw0KIGludCByZWlzZXJmc19lbmRfcGVyc2lzdGVudF90cmFu
c2FjdGlvbihzdHJ1Y3QgcmVpc2VyZnNfdHJhbnNhY3Rpb25faGFuZGxlICopOw0KK3ZvaWQgcmVp
c2VyZnNfdmZzX3RydW5jYXRlX2ZpbGUoc3RydWN0IGlub2RlICppbm9kZSk7DQogaW50IHJlaXNl
cmZzX2NvbW1pdF9wYWdlKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBwYWdlICpwYWdlLA0K
IAkJCSB1bnNpZ25lZCBmcm9tLCB1bnNpZ25lZCB0byk7DQogaW50IHJlaXNlcmZzX2ZsdXNoX29s
ZF9jb21taXRzKHN0cnVjdCBzdXBlcl9ibG9jayAqKTsNCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xp
bnV4L3NrYnVmZi5oIGIvaW5jbHVkZS9saW51eC9za2J1ZmYuaA0KaW5kZXggYzQ0NWU1Mi4uNDBj
MjcyNiAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgvc2tidWZmLmgNCisrKyBiL2luY2x1ZGUv
bGludXgvc2tidWZmLmgNCkBAIC0xNjMzLDYgKzE2MzMsMjIgQEAgc3RhdGljIGlubGluZSB2b2lk
IHNrYl9vcnBoYW4oc3RydWN0IHNrX2J1ZmYgKnNrYikNCiB9DQogDQogLyoqDQorICoJc2tiX29y
cGhhbl9mcmFncyAtIG9ycGhhbiB0aGUgZnJhZ3MgY29udGFpbmVkIGluIGEgYnVmZmVyDQorICoJ
QHNrYjogYnVmZmVyIHRvIG9ycGhhbiBmcmFncyBmcm9tDQorICoJQGdmcF9tYXNrOiBhbGxvY2F0
aW9uIG1hc2sgZm9yIHJlcGxhY2VtZW50IHBhZ2VzDQorICoNCisgKglGb3IgZWFjaCBmcmFnIGlu
IHRoZSBTS0Igd2hpY2ggbmVlZHMgYSBkZXN0cnVjdG9yIChpLmUuIGhhcyBhbg0KKyAqCW93bmVy
KSBjcmVhdGUgYSBjb3B5IG9mIHRoYXQgZnJhZyBhbmQgcmVsZWFzZSB0aGUgb3JpZ2luYWwNCisg
KglwYWdlIGJ5IGNhbGxpbmcgdGhlIGRlc3RydWN0b3IuDQorICovDQorc3RhdGljIGlubGluZSBp
bnQgc2tiX29ycGhhbl9mcmFncyhzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBnZnBfdCBnZnBfbWFzaykN
Cit7DQorCWlmIChsaWtlbHkoIShza2Jfc2hpbmZvKHNrYiktPnR4X2ZsYWdzICYgU0tCVFhfREVW
X1pFUk9DT1BZKSkpDQorCQlyZXR1cm4gMDsNCisJcmV0dXJuIHNrYl9jb3B5X3VidWZzKHNrYiwg
Z2ZwX21hc2spOw0KK30NCisNCisvKioNCiAgKglfX3NrYl9xdWV1ZV9wdXJnZSAtIGVtcHR5IGEg
bGlzdA0KICAqCUBsaXN0OiBsaXN0IHRvIGVtcHR5DQogICoNCmRpZmYgLS1naXQgYS9pbmNsdWRl
L25ldC9pbmV0cGVlci5oIGIvaW5jbHVkZS9uZXQvaW5ldHBlZXIuaA0KaW5kZXggMzRiMDZkYS4u
YmEwZGRiMCAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbmV0L2luZXRwZWVyLmgNCisrKyBiL2luY2x1
ZGUvbmV0L2luZXRwZWVyLmgNCkBAIC0xMTUsMTYgKzExNSw5IEBAIHN0YXRpYyBpbmxpbmUgdm9p
ZCBpbmV0X3BlZXJfcmVmY2hlY2soY29uc3Qgc3RydWN0IGluZXRfcGVlciAqcCkNCiAvKiBjYW4g
YmUgY2FsbGVkIHdpdGggb3Igd2l0aG91dCBsb2NhbCBCSCBiZWluZyBkaXNhYmxlZCAqLw0KIHN0
YXRpYyBpbmxpbmUgaW50IGluZXRfZ2V0aWQoc3RydWN0IGluZXRfcGVlciAqcCwgaW50IG1vcmUp
DQogew0KLQlpbnQgb2xkLCBuZXc7DQogCW1vcmUrKzsNCiAJaW5ldF9wZWVyX3JlZmNoZWNrKHAp
Ow0KLQlkbyB7DQotCQlvbGQgPSBhdG9taWNfcmVhZCgmcC0+aXBfaWRfY291bnQpOw0KLQkJbmV3
ID0gb2xkICsgbW9yZTsNCi0JCWlmICghbmV3KQ0KLQkJCW5ldyA9IDE7DQotCX0gd2hpbGUgKGF0
b21pY19jbXB4Y2hnKCZwLT5pcF9pZF9jb3VudCwgb2xkLCBuZXcpICE9IG9sZCk7DQotCXJldHVy
biBuZXc7DQorCXJldHVybiBhdG9taWNfYWRkX3JldHVybihtb3JlLCAmcC0+aXBfaWRfY291bnQp
IC0gbW9yZTsNCiB9DQogDQogI2VuZGlmIC8qIF9ORVRfSU5FVFBFRVJfSCAqLw0KZGlmZiAtLWdp
dCBhL2luY2x1ZGUvc2NzaS9zY3NpX2RldmljZS5oIGIvaW5jbHVkZS9zY3NpL3Njc2lfZGV2aWNl
LmgNCmluZGV4IDU1OTFlZDUuLjMxNTJjYzMgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL3Njc2kvc2Nz
aV9kZXZpY2UuaA0KKysrIGIvaW5jbHVkZS9zY3NpL3Njc2lfZGV2aWNlLmgNCkBAIC0yMzksNyAr
MjM5LDcgQEAgc3RydWN0IHNjc2lfdGFyZ2V0IHsNCiAJc3RydWN0IGxpc3RfaGVhZAlzaWJsaW5n
czsNCiAJc3RydWN0IGxpc3RfaGVhZAlkZXZpY2VzOw0KIAlzdHJ1Y3QgZGV2aWNlCQlkZXY7DQot
CXVuc2lnbmVkIGludAkJcmVhcF9yZWY7IC8qIHByb3RlY3RlZCBieSB0aGUgaG9zdCBsb2NrICov
DQorCXN0cnVjdCBrcmVmCQlyZWFwX3JlZjsgLyogbGFzdCBwdXQgcmVuZGVycyB0YXJnZXQgaW52
aXNpYmxlICovDQogCXVuc2lnbmVkIGludAkJY2hhbm5lbDsNCiAJdW5zaWduZWQgaW50CQlpZDsg
LyogdGFyZ2V0IGlkIC4uLiByZXBsYWNlDQogCQkJCSAgICAgKiBzY3NpX2RldmljZS5pZCBldmVu
dHVhbGx5ICovDQpAQCAtMjYxLDcgKzI2MSw2IEBAIHN0cnVjdCBzY3NpX3RhcmdldCB7DQogI2Rl
ZmluZSBTQ1NJX0RFRkFVTFRfVEFSR0VUX0JMT0NLRUQJMw0KIA0KIAljaGFyCQkJc2NzaV9sZXZl
bDsNCi0Jc3RydWN0IGV4ZWN1dGVfd29yawlldzsNCiAJZW51bSBzY3NpX3RhcmdldF9zdGF0ZQlz
dGF0ZTsNCiAJdm9pZCAJCQkqaG9zdGRhdGE7IC8qIGF2YWlsYWJsZSB0byBsb3ctbGV2ZWwgZHJp
dmVyICovDQogCXVuc2lnbmVkIGxvbmcJCXN0YXJnZXRfZGF0YVswXTsgLyogZm9yIHRoZSB0cmFu
c3BvcnQgKi8NCmRpZmYgLS1naXQgYS9pbmNsdWRlL3NvdW5kL2NvcmUuaCBiL2luY2x1ZGUvc291
bmQvY29yZS5oDQppbmRleCAyMjJmMTFlLi42YTNiMDNhIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9z
b3VuZC9jb3JlLmgNCisrKyBiL2luY2x1ZGUvc291bmQvY29yZS5oDQpAQCAtMTIwLDYgKzEyMCw4
IEBAIHN0cnVjdCBzbmRfY2FyZCB7DQogCWludCB1c2VyX2N0bF9jb3VudDsJCS8qIGNvdW50IG9m
IGFsbCB1c2VyIGNvbnRyb2xzICovDQogCXN0cnVjdCBsaXN0X2hlYWQgY29udHJvbHM7CS8qIGFs
bCBjb250cm9scyBmb3IgdGhpcyBjYXJkICovDQogCXN0cnVjdCBsaXN0X2hlYWQgY3RsX2ZpbGVz
OwkvKiBhY3RpdmUgY29udHJvbCBmaWxlcyAqLw0KKwlzdHJ1Y3QgbXV0ZXggdXNlcl9jdGxfbG9j
azsJLyogcHJvdGVjdHMgdXNlciBjb250cm9scyBhZ2FpbnN0DQorCQkJCQkgICBjb25jdXJyZW50
IGFjY2VzcyAqLw0KIA0KIAlzdHJ1Y3Qgc25kX2luZm9fZW50cnkgKnByb2Nfcm9vdDsJLyogcm9v
dCBmb3Igc291bmRjYXJkIHNwZWNpZmljIGZpbGVzICovDQogCXN0cnVjdCBzbmRfaW5mb19lbnRy
eSAqcHJvY19pZDsJLyogdGhlIGNhcmQgaWQgKi8NCmRpZmYgLS1naXQgYS9pbmNsdWRlL3RyYWNl
L3N5c2NhbGwuaCBiL2luY2x1ZGUvdHJhY2Uvc3lzY2FsbC5oDQppbmRleCAzMTk2NmE0Li41MWI3
MmQ4IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS90cmFjZS9zeXNjYWxsLmgNCisrKyBiL2luY2x1ZGUv
dHJhY2Uvc3lzY2FsbC5oDQpAQCAtNCw2ICs0LDcgQEANCiAjaW5jbHVkZSA8bGludXgvdHJhY2Vw
b2ludC5oPg0KICNpbmNsdWRlIDxsaW51eC91bmlzdGQuaD4NCiAjaW5jbHVkZSA8bGludXgvZnRy
YWNlX2V2ZW50Lmg+DQorI2luY2x1ZGUgPGxpbnV4L3RocmVhZF9pbmZvLmg+DQogDQogI2luY2x1
ZGUgPGFzbS9wdHJhY2UuaD4NCiANCkBAIC01NCw0ICs1NSwxOCBAQCBpbnQgcGVyZl9zeXNleGl0
X2VuYWJsZShzdHJ1Y3QgZnRyYWNlX2V2ZW50X2NhbGwgKmNhbGwpOw0KIHZvaWQgcGVyZl9zeXNl
eGl0X2Rpc2FibGUoc3RydWN0IGZ0cmFjZV9ldmVudF9jYWxsICpjYWxsKTsNCiAjZW5kaWYNCiAN
CisjaWYgZGVmaW5lZChDT05GSUdfVFJBQ0VQT0lOVFMpICYmIGRlZmluZWQoQ09ORklHX0hBVkVf
U1lTQ0FMTF9UUkFDRVBPSU5UUykNCitzdGF0aWMgaW5saW5lIHZvaWQgc3lzY2FsbF90cmFjZXBv
aW50X3VwZGF0ZShzdHJ1Y3QgdGFza19zdHJ1Y3QgKnApDQorew0KKwlpZiAodGVzdF90aHJlYWRf
ZmxhZyhUSUZfU1lTQ0FMTF9UUkFDRVBPSU5UKSkNCisJCXNldF90c2tfdGhyZWFkX2ZsYWcocCwg
VElGX1NZU0NBTExfVFJBQ0VQT0lOVCk7DQorCWVsc2UNCisJCWNsZWFyX3Rza190aHJlYWRfZmxh
ZyhwLCBUSUZfU1lTQ0FMTF9UUkFDRVBPSU5UKTsNCit9DQorI2Vsc2UNCitzdGF0aWMgaW5saW5l
IHZvaWQgc3lzY2FsbF90cmFjZXBvaW50X3VwZGF0ZShzdHJ1Y3QgdGFza19zdHJ1Y3QgKnApDQor
ew0KK30NCisjZW5kaWYNCisNCiAjZW5kaWYgLyogX1RSQUNFX1NZU0NBTExfSCAqLw0KZGlmZiAt
LWdpdCBhL2tlcm5lbC9hdWRpdHNjLmMgYi9rZXJuZWwvYXVkaXRzYy5jDQppbmRleCBhZWFjN2Nj
Li5kMWQyODQzIDEwMDY0NA0KLS0tIGEva2VybmVsL2F1ZGl0c2MuYw0KKysrIGIva2VybmVsL2F1
ZGl0c2MuYw0KQEAgLTY4OCw2ICs2ODgsMjIgQEAgc3RhdGljIGVudW0gYXVkaXRfc3RhdGUgYXVk
aXRfZmlsdGVyX3Rhc2soc3RydWN0IHRhc2tfc3RydWN0ICp0c2ssIGNoYXIgKiprZXkpDQogCXJl
dHVybiBBVURJVF9CVUlMRF9DT05URVhUOw0KIH0NCiANCitzdGF0aWMgaW50IGF1ZGl0X2luX21h
c2soY29uc3Qgc3RydWN0IGF1ZGl0X2tydWxlICpydWxlLCB1bnNpZ25lZCBsb25nIHZhbCkNCit7
DQorCWludCB3b3JkLCBiaXQ7DQorDQorCWlmICh2YWwgPiAweGZmZmZmZmZmKQ0KKwkJcmV0dXJu
IGZhbHNlOw0KKw0KKwl3b3JkID0gQVVESVRfV09SRCh2YWwpOw0KKwlpZiAod29yZCA+PSBBVURJ
VF9CSVRNQVNLX1NJWkUpDQorCQlyZXR1cm4gZmFsc2U7DQorDQorCWJpdCA9IEFVRElUX0JJVCh2
YWwpOw0KKw0KKwlyZXR1cm4gcnVsZS0+bWFza1t3b3JkXSAmIGJpdDsNCit9DQorDQogLyogQXQg
c3lzY2FsbCBlbnRyeSBhbmQgZXhpdCB0aW1lLCB0aGlzIGZpbHRlciBpcyBjYWxsZWQgaWYgdGhl
DQogICogYXVkaXRfc3RhdGUgaXMgbm90IGxvdyBlbm91Z2ggdGhhdCBhdWRpdGluZyBjYW5ub3Qg
dGFrZSBwbGFjZSwgYnV0IGlzDQogICogYWxzbyBub3QgaGlnaCBlbm91Z2ggdGhhdCB3ZSBhbHJl
YWR5IGtub3cgd2UgaGF2ZSB0byB3cml0ZSBhbiBhdWRpdA0KQEAgLTcwNSwxMSArNzIxLDggQEAg
c3RhdGljIGVudW0gYXVkaXRfc3RhdGUgYXVkaXRfZmlsdGVyX3N5c2NhbGwoc3RydWN0IHRhc2tf
c3RydWN0ICp0c2ssDQogDQogCXJjdV9yZWFkX2xvY2soKTsNCiAJaWYgKCFsaXN0X2VtcHR5KGxp
c3QpKSB7DQotCQlpbnQgd29yZCA9IEFVRElUX1dPUkQoY3R4LT5tYWpvcik7DQotCQlpbnQgYml0
ICA9IEFVRElUX0JJVChjdHgtPm1ham9yKTsNCi0NCiAJCWxpc3RfZm9yX2VhY2hfZW50cnlfcmN1
KGUsIGxpc3QsIGxpc3QpIHsNCi0JCQlpZiAoKGUtPnJ1bGUubWFza1t3b3JkXSAmIGJpdCkgPT0g
Yml0ICYmDQorCQkJaWYgKGF1ZGl0X2luX21hc2soJmUtPnJ1bGUsIGN0eC0+bWFqb3IpICYmDQog
CQkJICAgIGF1ZGl0X2ZpbHRlcl9ydWxlcyh0c2ssICZlLT5ydWxlLCBjdHgsIE5VTEwsDQogCQkJ
CQkgICAgICAgJnN0YXRlLCBmYWxzZSkpIHsNCiAJCQkJcmN1X3JlYWRfdW5sb2NrKCk7DQpAQCAt
NzM4LDggKzc1MSw2IEBAIHZvaWQgYXVkaXRfZmlsdGVyX2lub2RlcyhzdHJ1Y3QgdGFza19zdHJ1
Y3QgKnRzaywgc3RydWN0IGF1ZGl0X2NvbnRleHQgKmN0eCkNCiANCiAJcmN1X3JlYWRfbG9jaygp
Ow0KIAlmb3IgKGkgPSAwOyBpIDwgY3R4LT5uYW1lX2NvdW50OyBpKyspIHsNCi0JCWludCB3b3Jk
ID0gQVVESVRfV09SRChjdHgtPm1ham9yKTsNCi0JCWludCBiaXQgID0gQVVESVRfQklUKGN0eC0+
bWFqb3IpOw0KIAkJc3RydWN0IGF1ZGl0X25hbWVzICpuID0gJmN0eC0+bmFtZXNbaV07DQogCQlp
bnQgaCA9IGF1ZGl0X2hhc2hfaW5vKCh1MzIpbi0+aW5vKTsNCiAJCXN0cnVjdCBsaXN0X2hlYWQg
Kmxpc3QgPSAmYXVkaXRfaW5vZGVfaGFzaFtoXTsNCkBAIC03NDgsNyArNzU5LDcgQEAgdm9pZCBh
dWRpdF9maWx0ZXJfaW5vZGVzKHN0cnVjdCB0YXNrX3N0cnVjdCAqdHNrLCBzdHJ1Y3QgYXVkaXRf
Y29udGV4dCAqY3R4KQ0KIAkJCWNvbnRpbnVlOw0KIA0KIAkJbGlzdF9mb3JfZWFjaF9lbnRyeV9y
Y3UoZSwgbGlzdCwgbGlzdCkgew0KLQkJCWlmICgoZS0+cnVsZS5tYXNrW3dvcmRdICYgYml0KSA9
PSBiaXQgJiYNCisJCQlpZiAoYXVkaXRfaW5fbWFzaygmZS0+cnVsZSwgY3R4LT5tYWpvcikgJiYN
CiAJCQkgICAgYXVkaXRfZmlsdGVyX3J1bGVzKHRzaywgJmUtPnJ1bGUsIGN0eCwgbiwNCiAJCQkJ
ICAgIAkgICAgICAgJnN0YXRlLCBmYWxzZSkpIHsNCiAJCQkJcmN1X3JlYWRfdW5sb2NrKCk7DQpk
aWZmIC0tZ2l0IGEva2VybmVsL2V2ZW50cy9jb3JlLmMgYi9rZXJuZWwvZXZlbnRzL2NvcmUuYw0K
aW5kZXggMWQxZWRjYi4uMTRjMTExYyAxMDA2NDQNCi0tLSBhL2tlcm5lbC9ldmVudHMvY29yZS5j
DQorKysgYi9rZXJuZWwvZXZlbnRzL2NvcmUuYw0KQEAgLTExODAsNiArMTE4MCwxMSBAQCBncm91
cF9zY2hlZF9vdXQoc3RydWN0IHBlcmZfZXZlbnQgKmdyb3VwX2V2ZW50LA0KIAkJY3B1Y3R4LT5l
eGNsdXNpdmUgPSAwOw0KIH0NCiANCitzdHJ1Y3QgcmVtb3ZlX2V2ZW50IHsNCisJc3RydWN0IHBl
cmZfZXZlbnQgKmV2ZW50Ow0KKwlib29sIGRldGFjaF9ncm91cDsNCit9Ow0KKw0KIC8qDQogICog
Q3Jvc3MgQ1BVIGNhbGwgdG8gcmVtb3ZlIGEgcGVyZm9ybWFuY2UgZXZlbnQNCiAgKg0KQEAgLTEx
ODgsMTIgKzExOTMsMTUgQEAgZ3JvdXBfc2NoZWRfb3V0KHN0cnVjdCBwZXJmX2V2ZW50ICpncm91
cF9ldmVudCwNCiAgKi8NCiBzdGF0aWMgaW50IF9fcGVyZl9yZW1vdmVfZnJvbV9jb250ZXh0KHZv
aWQgKmluZm8pDQogew0KLQlzdHJ1Y3QgcGVyZl9ldmVudCAqZXZlbnQgPSBpbmZvOw0KKwlzdHJ1
Y3QgcmVtb3ZlX2V2ZW50ICpyZSA9IGluZm87DQorCXN0cnVjdCBwZXJmX2V2ZW50ICpldmVudCA9
IHJlLT5ldmVudDsNCiAJc3RydWN0IHBlcmZfZXZlbnRfY29udGV4dCAqY3R4ID0gZXZlbnQtPmN0
eDsNCiAJc3RydWN0IHBlcmZfY3B1X2NvbnRleHQgKmNwdWN0eCA9IF9fZ2V0X2NwdV9jb250ZXh0
KGN0eCk7DQogDQogCXJhd19zcGluX2xvY2soJmN0eC0+bG9jayk7DQogCWV2ZW50X3NjaGVkX291
dChldmVudCwgY3B1Y3R4LCBjdHgpOw0KKwlpZiAocmUtPmRldGFjaF9ncm91cCkNCisJCXBlcmZf
Z3JvdXBfZGV0YWNoKGV2ZW50KTsNCiAJbGlzdF9kZWxfZXZlbnQoZXZlbnQsIGN0eCk7DQogCWlm
ICghY3R4LT5ucl9ldmVudHMgJiYgY3B1Y3R4LT50YXNrX2N0eCA9PSBjdHgpIHsNCiAJCWN0eC0+
aXNfYWN0aXZlID0gMDsNCkBAIC0xMjE4LDEwICsxMjI2LDE0IEBAIHN0YXRpYyBpbnQgX19wZXJm
X3JlbW92ZV9mcm9tX2NvbnRleHQodm9pZCAqaW5mbykNCiAgKiBXaGVuIGNhbGxlZCBmcm9tIHBl
cmZfZXZlbnRfZXhpdF90YXNrLCBpdCdzIE9LIGJlY2F1c2UgdGhlDQogICogY29udGV4dCBoYXMg
YmVlbiBkZXRhY2hlZCBmcm9tIGl0cyB0YXNrLg0KICAqLw0KLXN0YXRpYyB2b2lkIHBlcmZfcmVt
b3ZlX2Zyb21fY29udGV4dChzdHJ1Y3QgcGVyZl9ldmVudCAqZXZlbnQpDQorc3RhdGljIHZvaWQg
cGVyZl9yZW1vdmVfZnJvbV9jb250ZXh0KHN0cnVjdCBwZXJmX2V2ZW50ICpldmVudCwgYm9vbCBk
ZXRhY2hfZ3JvdXApDQogew0KIAlzdHJ1Y3QgcGVyZl9ldmVudF9jb250ZXh0ICpjdHggPSBldmVu
dC0+Y3R4Ow0KIAlzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRhc2sgPSBjdHgtPnRhc2s7DQorCXN0cnVj
dCByZW1vdmVfZXZlbnQgcmUgPSB7DQorCQkuZXZlbnQgPSBldmVudCwNCisJCS5kZXRhY2hfZ3Jv
dXAgPSBkZXRhY2hfZ3JvdXAsDQorCX07DQogDQogCWxvY2tkZXBfYXNzZXJ0X2hlbGQoJmN0eC0+
bXV0ZXgpOw0KIA0KQEAgLTEyMzAsMTIgKzEyNDIsMTIgQEAgc3RhdGljIHZvaWQgcGVyZl9yZW1v
dmVfZnJvbV9jb250ZXh0KHN0cnVjdCBwZXJmX2V2ZW50ICpldmVudCkNCiAJCSAqIFBlciBjcHUg
ZXZlbnRzIGFyZSByZW1vdmVkIHZpYSBhbiBzbXAgY2FsbCBhbmQNCiAJCSAqIHRoZSByZW1vdmFs
IGlzIGFsd2F5cyBzdWNjZXNzZnVsLg0KIAkJICovDQotCQljcHVfZnVuY3Rpb25fY2FsbChldmVu
dC0+Y3B1LCBfX3BlcmZfcmVtb3ZlX2Zyb21fY29udGV4dCwgZXZlbnQpOw0KKwkJY3B1X2Z1bmN0
aW9uX2NhbGwoZXZlbnQtPmNwdSwgX19wZXJmX3JlbW92ZV9mcm9tX2NvbnRleHQsICZyZSk7DQog
CQlyZXR1cm47DQogCX0NCiANCiByZXRyeToNCi0JaWYgKCF0YXNrX2Z1bmN0aW9uX2NhbGwodGFz
aywgX19wZXJmX3JlbW92ZV9mcm9tX2NvbnRleHQsIGV2ZW50KSkNCisJaWYgKCF0YXNrX2Z1bmN0
aW9uX2NhbGwodGFzaywgX19wZXJmX3JlbW92ZV9mcm9tX2NvbnRleHQsICZyZSkpDQogCQlyZXR1
cm47DQogDQogCXJhd19zcGluX2xvY2tfaXJxKCZjdHgtPmxvY2spOw0KQEAgLTEyNTIsNiArMTI2
NCw4IEBAIHJldHJ5Og0KIAkgKiBTaW5jZSB0aGUgdGFzayBpc24ndCBydW5uaW5nLCBpdHMgc2Fm
ZSB0byByZW1vdmUgdGhlIGV2ZW50LCB1cw0KIAkgKiBob2xkaW5nIHRoZSBjdHgtPmxvY2sgZW5z
dXJlcyB0aGUgdGFzayB3b24ndCBnZXQgc2NoZWR1bGVkIGluLg0KIAkgKi8NCisJaWYgKGRldGFj
aF9ncm91cCkNCisJCXBlcmZfZ3JvdXBfZGV0YWNoKGV2ZW50KTsNCiAJbGlzdF9kZWxfZXZlbnQo
ZXZlbnQsIGN0eCk7DQogCXJhd19zcGluX3VubG9ja19pcnEoJmN0eC0+bG9jayk7DQogfQ0KQEAg
LTMwNDYsMTAgKzMwNjAsNyBAQCBpbnQgcGVyZl9ldmVudF9yZWxlYXNlX2tlcm5lbChzdHJ1Y3Qg
cGVyZl9ldmVudCAqZXZlbnQpDQogCSAqICAgICB0byB0cmlnZ2VyIHRoZSBBQi1CQSBjYXNlLg0K
IAkgKi8NCiAJbXV0ZXhfbG9ja19uZXN0ZWQoJmN0eC0+bXV0ZXgsIFNJTkdMRV9ERVBUSF9ORVNU
SU5HKTsNCi0JcmF3X3NwaW5fbG9ja19pcnEoJmN0eC0+bG9jayk7DQotCXBlcmZfZ3JvdXBfZGV0
YWNoKGV2ZW50KTsNCi0JcmF3X3NwaW5fdW5sb2NrX2lycSgmY3R4LT5sb2NrKTsNCi0JcGVyZl9y
ZW1vdmVfZnJvbV9jb250ZXh0KGV2ZW50KTsNCisJcGVyZl9yZW1vdmVfZnJvbV9jb250ZXh0KGV2
ZW50LCB0cnVlKTsNCiAJbXV0ZXhfdW5sb2NrKCZjdHgtPm11dGV4KTsNCiANCiAJZnJlZV9ldmVu
dChldmVudCk7DQpAQCAtNjQ1OSw3ICs2NDcwLDcgQEAgU1lTQ0FMTF9ERUZJTkU1KHBlcmZfZXZl
bnRfb3BlbiwNCiAJCXN0cnVjdCBwZXJmX2V2ZW50X2NvbnRleHQgKmdjdHggPSBncm91cF9sZWFk
ZXItPmN0eDsNCiANCiAJCW11dGV4X2xvY2soJmdjdHgtPm11dGV4KTsNCi0JCXBlcmZfcmVtb3Zl
X2Zyb21fY29udGV4dChncm91cF9sZWFkZXIpOw0KKwkJcGVyZl9yZW1vdmVfZnJvbV9jb250ZXh0
KGdyb3VwX2xlYWRlciwgZmFsc2UpOw0KIA0KIAkJLyoNCiAJCSAqIFJlbW92aW5nIGZyb20gdGhl
IGNvbnRleHQgZW5kcyB1cCB3aXRoIGRpc2FibGVkDQpAQCAtNjQ2OSw3ICs2NDgwLDcgQEAgU1lT
Q0FMTF9ERUZJTkU1KHBlcmZfZXZlbnRfb3BlbiwNCiAJCXBlcmZfZXZlbnRfX3N0YXRlX2luaXQo
Z3JvdXBfbGVhZGVyKTsNCiAJCWxpc3RfZm9yX2VhY2hfZW50cnkoc2libGluZywgJmdyb3VwX2xl
YWRlci0+c2libGluZ19saXN0LA0KIAkJCQkgICAgZ3JvdXBfZW50cnkpIHsNCi0JCQlwZXJmX3Jl
bW92ZV9mcm9tX2NvbnRleHQoc2libGluZyk7DQorCQkJcGVyZl9yZW1vdmVfZnJvbV9jb250ZXh0
KHNpYmxpbmcsIGZhbHNlKTsNCiAJCQlwZXJmX2V2ZW50X19zdGF0ZV9pbml0KHNpYmxpbmcpOw0K
IAkJCXB1dF9jdHgoZ2N0eCk7DQogCQl9DQpAQCAtNjYyMiwxMyArNjYzMyw3IEBAIF9fcGVyZl9l
dmVudF9leGl0X3Rhc2soc3RydWN0IHBlcmZfZXZlbnQgKmNoaWxkX2V2ZW50LA0KIAkJCSBzdHJ1
Y3QgcGVyZl9ldmVudF9jb250ZXh0ICpjaGlsZF9jdHgsDQogCQkJIHN0cnVjdCB0YXNrX3N0cnVj
dCAqY2hpbGQpDQogew0KLQlpZiAoY2hpbGRfZXZlbnQtPnBhcmVudCkgew0KLQkJcmF3X3NwaW5f
bG9ja19pcnEoJmNoaWxkX2N0eC0+bG9jayk7DQotCQlwZXJmX2dyb3VwX2RldGFjaChjaGlsZF9l
dmVudCk7DQotCQlyYXdfc3Bpbl91bmxvY2tfaXJxKCZjaGlsZF9jdHgtPmxvY2spOw0KLQl9DQot
DQotCXBlcmZfcmVtb3ZlX2Zyb21fY29udGV4dChjaGlsZF9ldmVudCk7DQorCXBlcmZfcmVtb3Zl
X2Zyb21fY29udGV4dChjaGlsZF9ldmVudCwgISFjaGlsZF9ldmVudC0+cGFyZW50KTsNCiANCiAJ
LyoNCiAJICogSXQgY2FuIGhhcHBlbiB0aGF0IHRoZSBwYXJlbnQgZXhpdHMgZmlyc3QsIGFuZCBo
YXMgZXZlbnRzDQpAQCAtNzExMywxNCArNzExOCwxNCBAQCBzdGF0aWMgdm9pZCBwZXJmX3BtdV9y
b3RhdGVfc3RvcChzdHJ1Y3QgcG11ICpwbXUpDQogDQogc3RhdGljIHZvaWQgX19wZXJmX2V2ZW50
X2V4aXRfY29udGV4dCh2b2lkICpfX2luZm8pDQogew0KKwlzdHJ1Y3QgcmVtb3ZlX2V2ZW50IHJl
ID0geyAuZGV0YWNoX2dyb3VwID0gZmFsc2UgfTsNCiAJc3RydWN0IHBlcmZfZXZlbnRfY29udGV4
dCAqY3R4ID0gX19pbmZvOw0KLQlzdHJ1Y3QgcGVyZl9ldmVudCAqZXZlbnQ7DQogDQogCXBlcmZf
cG11X3JvdGF0ZV9zdG9wKGN0eC0+cG11KTsNCiANCiAJcmN1X3JlYWRfbG9jaygpOw0KLQlsaXN0
X2Zvcl9lYWNoX2VudHJ5X3JjdShldmVudCwgJmN0eC0+ZXZlbnRfbGlzdCwgZXZlbnRfZW50cnkp
DQotCQlfX3BlcmZfcmVtb3ZlX2Zyb21fY29udGV4dChldmVudCk7DQorCWxpc3RfZm9yX2VhY2hf
ZW50cnlfcmN1KHJlLmV2ZW50LCAmY3R4LT5ldmVudF9saXN0LCBldmVudF9lbnRyeSkNCisJCV9f
cGVyZl9yZW1vdmVfZnJvbV9jb250ZXh0KCZyZSk7DQogCXJjdV9yZWFkX3VubG9jaygpOw0KIH0N
CiANCmRpZmYgLS1naXQgYS9rZXJuZWwvZm9yay5jIGIva2VybmVsL2ZvcmsuYw0KaW5kZXggY2Uw
YzE4Mi4uMTNiYmEzMCAxMDA2NDQNCi0tLSBhL2tlcm5lbC9mb3JrLmMNCisrKyBiL2tlcm5lbC9m
b3JrLmMNCkBAIC0xMzcwLDcgKzEzNzAsOSBAQCBzdGF0aWMgc3RydWN0IHRhc2tfc3RydWN0ICpj
b3B5X3Byb2Nlc3ModW5zaWduZWQgbG9uZyBjbG9uZV9mbGFncywNCiANCiAJdG90YWxfZm9ya3Mr
KzsNCiAJc3Bpbl91bmxvY2soJmN1cnJlbnQtPnNpZ2hhbmQtPnNpZ2xvY2spOw0KKwlzeXNjYWxs
X3RyYWNlcG9pbnRfdXBkYXRlKHApOw0KIAl3cml0ZV91bmxvY2tfaXJxKCZ0YXNrbGlzdF9sb2Nr
KTsNCisNCiAJcHJvY19mb3JrX2Nvbm5lY3RvcihwKTsNCiAJY2dyb3VwX3Bvc3RfZm9yayhwKTsN
CiAJaWYgKGNsb25lX2ZsYWdzICYgQ0xPTkVfVEhSRUFEKQ0KQEAgLTE1MTMsMTAgKzE1MTUsMTIg
QEAgbG9uZyBkb19mb3JrKHVuc2lnbmVkIGxvbmcgY2xvbmVfZmxhZ3MsDQogCSAqLw0KIAlpZiAo
IUlTX0VSUihwKSkgew0KIAkJc3RydWN0IGNvbXBsZXRpb24gdmZvcms7DQorCQlzdHJ1Y3QgcGlk
ICpwaWQ7DQogDQogCQl0cmFjZV9zY2hlZF9wcm9jZXNzX2ZvcmsoY3VycmVudCwgcCk7DQogDQot
CQluciA9IHRhc2tfcGlkX3ZucihwKTsNCisJCXBpZCA9IGdldF90YXNrX3BpZChwLCBQSURUWVBF
X1BJRCk7DQorCQluciA9IHBpZF92bnIocGlkKTsNCiANCiAJCWlmIChjbG9uZV9mbGFncyAmIENM
T05FX1BBUkVOVF9TRVRUSUQpDQogCQkJcHV0X3VzZXIobnIsIHBhcmVudF90aWRwdHIpOw0KQEAg
LTE1NDAsMTQgKzE1NDQsMTYgQEAgbG9uZyBkb19mb3JrKHVuc2lnbmVkIGxvbmcgY2xvbmVfZmxh
Z3MsDQogDQogCQkvKiBmb3JraW5nIGNvbXBsZXRlIGFuZCBjaGlsZCBzdGFydGVkIHRvIHJ1biwg
dGVsbCBwdHJhY2VyICovDQogCQlpZiAodW5saWtlbHkodHJhY2UpKQ0KLQkJCXB0cmFjZV9ldmVu
dCh0cmFjZSwgbnIpOw0KKwkJCXB0cmFjZV9ldmVudF9waWQodHJhY2UsIHBpZCk7DQogDQogCQlp
ZiAoY2xvbmVfZmxhZ3MgJiBDTE9ORV9WRk9SSykgew0KIAkJCWZyZWV6ZXJfZG9fbm90X2NvdW50
KCk7DQogCQkJd2FpdF9mb3JfY29tcGxldGlvbigmdmZvcmspOw0KIAkJCWZyZWV6ZXJfY291bnQo
KTsNCi0JCQlwdHJhY2VfZXZlbnQoUFRSQUNFX0VWRU5UX1ZGT1JLX0RPTkUsIG5yKTsNCisJCQlw
dHJhY2VfZXZlbnRfcGlkKFBUUkFDRV9FVkVOVF9WRk9SS19ET05FLCBwaWQpOw0KIAkJfQ0KKw0K
KwkJcHV0X3BpZChwaWQpOw0KIAl9IGVsc2Ugew0KIAkJbnIgPSBQVFJfRVJSKHApOw0KIAl9DQpk
aWZmIC0tZ2l0IGEva2VybmVsL2lycS9tYW5hZ2UuYyBiL2tlcm5lbC9pcnEvbWFuYWdlLmMNCmlu
ZGV4IDQ3NzUyMjkuLjEyN2EzMmUgMTAwNjQ0DQotLS0gYS9rZXJuZWwvaXJxL21hbmFnZS5jDQor
KysgYi9rZXJuZWwvaXJxL21hbmFnZS5jDQpAQCAtODEzLDggKzgxMyw4IEBAIHN0YXRpYyBpbnQg
aXJxX3RocmVhZCh2b2lkICpkYXRhKQ0KIA0KIAkJCXJhd19zcGluX3VubG9ja19pcnEoJmRlc2Mt
PmxvY2spOw0KIAkJCWFjdGlvbl9yZXQgPSBoYW5kbGVyX2ZuKGRlc2MsIGFjdGlvbik7DQotCQkJ
aWYgKCFub2lycWRlYnVnKQ0KLQkJCQlub3RlX2ludGVycnVwdChhY3Rpb24tPmlycSwgZGVzYywg
YWN0aW9uX3JldCk7DQorCQkJaWYgKGFjdGlvbl9yZXQgPT0gSVJRX0hBTkRMRUQpDQorCQkJCWF0
b21pY19pbmMoJmRlc2MtPnRocmVhZHNfaGFuZGxlZCk7DQogCQl9DQogDQogCQl3YWtlID0gYXRv
bWljX2RlY19hbmRfdGVzdCgmZGVzYy0+dGhyZWFkc19hY3RpdmUpOw0KZGlmZiAtLWdpdCBhL2tl
cm5lbC9pcnEvc3B1cmlvdXMuYyBiL2tlcm5lbC9pcnEvc3B1cmlvdXMuYw0KaW5kZXggNjM2MzNh
My4uNmQ0MjZlYiAxMDA2NDQNCi0tLSBhL2tlcm5lbC9pcnEvc3B1cmlvdXMuYw0KKysrIGIva2Vy
bmVsL2lycS9zcHVyaW91cy5jDQpAQCAtMjY1LDIxICsyNjUsMTE5IEBAIHRyeV9taXNyb3V0ZWRf
aXJxKHVuc2lnbmVkIGludCBpcnEsIHN0cnVjdCBpcnFfZGVzYyAqZGVzYywNCiAJcmV0dXJuIGFj
dGlvbiAmJiAoYWN0aW9uLT5mbGFncyAmIElSUUZfSVJRUE9MTCk7DQogfQ0KIA0KKyNkZWZpbmUg
U1BVUklPVVNfREVGRVJSRUQJMHg4MDAwMDAwMA0KKw0KIHZvaWQgbm90ZV9pbnRlcnJ1cHQodW5z
aWduZWQgaW50IGlycSwgc3RydWN0IGlycV9kZXNjICpkZXNjLA0KIAkJICAgIGlycXJldHVybl90
IGFjdGlvbl9yZXQpDQogew0KIAlpZiAoZGVzYy0+aXN0YXRlICYgSVJRU19QT0xMX0lOUFJPR1JF
U1MpDQogCQlyZXR1cm47DQogDQotCS8qIHdlIGdldCBoZXJlIGFnYWluIHZpYSB0aGUgdGhyZWFk
ZWQgaGFuZGxlciAqLw0KLQlpZiAoYWN0aW9uX3JldCA9PSBJUlFfV0FLRV9USFJFQUQpDQotCQly
ZXR1cm47DQotDQogCWlmIChiYWRfYWN0aW9uX3JldChhY3Rpb25fcmV0KSkgew0KIAkJcmVwb3J0
X2JhZF9pcnEoaXJxLCBkZXNjLCBhY3Rpb25fcmV0KTsNCiAJCXJldHVybjsNCiAJfQ0KIA0KKwkv
Kg0KKwkgKiBXZSBjYW5ub3QgY2FsbCBub3RlX2ludGVycnVwdCBmcm9tIHRoZSB0aHJlYWRlZCBo
YW5kbGVyDQorCSAqIGJlY2F1c2Ugd2UgbmVlZCB0byBsb29rIGF0IHRoZSBjb21wb3VuZCBvZiBh
bGwgaGFuZGxlcnMNCisJICogKHByaW1hcnkgYW5kIHRocmVhZGVkKS4gQXNpZGUgb2YgdGhhdCBp
biB0aGUgdGhyZWFkZWQNCisJICogc2hhcmVkIGNhc2Ugd2UgaGF2ZSBubyBzZXJpYWxpemF0aW9u
IGFnYWluc3QgYW4gaW5jb21pbmcNCisJICogaGFyZHdhcmUgaW50ZXJydXB0IHdoaWxlIHdlIGFy
ZSBkZWFsaW5nIHdpdGggYSB0aHJlYWRlZA0KKwkgKiByZXN1bHQuDQorCSAqDQorCSAqIFNvIGlu
IGNhc2UgYSB0aHJlYWQgaXMgd29rZW4sIHdlIGp1c3Qgbm90ZSB0aGUgZmFjdCBhbmQNCisJICog
ZGVmZXIgdGhlIGFuYWx5c2lzIHRvIHRoZSBuZXh0IGhhcmR3YXJlIGludGVycnVwdC4NCisJICoN
CisJICogVGhlIHRocmVhZGVkIGhhbmRsZXJzIHN0b3JlIHdoZXRoZXIgdGhleSBzdWNlc3NmdWxs
eQ0KKwkgKiBoYW5kbGVkIGFuIGludGVycnVwdCBhbmQgd2UgY2hlY2sgd2hldGhlciB0aGF0IG51
bWJlcg0KKwkgKiBjaGFuZ2VkIHZlcnN1cyB0aGUgbGFzdCBpbnZvY2F0aW9uLg0KKwkgKg0KKwkg
KiBXZSBjb3VsZCBoYW5kbGUgYWxsIGludGVycnVwdHMgd2l0aCB0aGUgZGVsYXllZCBieSBvbmUN
CisJICogbWVjaGFuaXNtLCBidXQgZm9yIHRoZSBub24gZm9yY2VkIHRocmVhZGVkIGNhc2Ugd2Un
ZCBqdXN0DQorCSAqIGFkZCBwb2ludGxlc3Mgb3ZlcmhlYWQgdG8gdGhlIHN0cmFpZ2h0IGhhcmRp
cnEgaW50ZXJydXB0cw0KKwkgKiBmb3IgdGhlIHNha2Ugb2YgYSBmZXcgbGluZXMgbGVzcyBjb2Rl
Lg0KKwkgKi8NCisJaWYgKGFjdGlvbl9yZXQgJiBJUlFfV0FLRV9USFJFQUQpIHsNCisJCS8qDQor
CQkgKiBUaGVyZSBpcyBhIHRocmVhZCB3b2tlbi4gQ2hlY2sgd2hldGhlciBvbmUgb2YgdGhlDQor
CQkgKiBzaGFyZWQgcHJpbWFyeSBoYW5kbGVycyByZXR1cm5lZCBJUlFfSEFORExFRC4gSWYNCisJ
CSAqIG5vdCB3ZSBkZWZlciB0aGUgc3B1cmlvdXMgZGV0ZWN0aW9uIHRvIHRoZSBuZXh0DQorCQkg
KiBpbnRlcnJ1cHQuDQorCQkgKi8NCisJCWlmIChhY3Rpb25fcmV0ID09IElSUV9XQUtFX1RIUkVB
RCkgew0KKwkJCWludCBoYW5kbGVkOw0KKwkJCS8qDQorCQkJICogV2UgdXNlIGJpdCAzMSBvZiB0
aHJlYWRfaGFuZGxlZF9sYXN0IHRvDQorCQkJICogZGVub3RlIHRoZSBkZWZlcnJlZCBzcHVyaW91
cyBkZXRlY3Rpb24NCisJCQkgKiBhY3RpdmUuIE5vIGxvY2tpbmcgbmVjZXNzYXJ5IGFzDQorCQkJ
ICogdGhyZWFkX2hhbmRsZWRfbGFzdCBpcyBvbmx5IGFjY2Vzc2VkIGhlcmUNCisJCQkgKiBhbmQg
d2UgaGF2ZSB0aGUgZ3VhcmFudGVlIHRoYXQgaGFyZA0KKwkJCSAqIGludGVycnVwdHMgYXJlIG5v
dCByZWVudHJhbnQuDQorCQkJICovDQorCQkJaWYgKCEoZGVzYy0+dGhyZWFkc19oYW5kbGVkX2xh
c3QgJiBTUFVSSU9VU19ERUZFUlJFRCkpIHsNCisJCQkJZGVzYy0+dGhyZWFkc19oYW5kbGVkX2xh
c3QgfD0gU1BVUklPVVNfREVGRVJSRUQ7DQorCQkJCXJldHVybjsNCisJCQl9DQorCQkJLyoNCisJ
CQkgKiBDaGVjayB3aGV0aGVyIG9uZSBvZiB0aGUgdGhyZWFkZWQgaGFuZGxlcnMNCisJCQkgKiBy
ZXR1cm5lZCBJUlFfSEFORExFRCBzaW5jZSB0aGUgbGFzdA0KKwkJCSAqIGludGVycnVwdCBoYXBw
ZW5lZC4NCisJCQkgKg0KKwkJCSAqIEZvciBzaW1wbGljaXR5IHdlIGp1c3Qgc2V0IGJpdCAzMSwg
YXMgaXQgaXMNCisJCQkgKiBzZXQgaW4gdGhyZWFkc19oYW5kbGVkX2xhc3QgYXMgd2VsbC4gU28g
d2UNCisJCQkgKiBhdm9pZCBleHRyYSBtYXNraW5nLiBBbmQgd2UgcmVhbGx5IGRvIG5vdA0KKwkJ
CSAqIGNhcmUgYWJvdXQgdGhlIGhpZ2ggYml0cyBvZiB0aGUgaGFuZGxlZA0KKwkJCSAqIGNvdW50
LiBXZSBqdXN0IGNhcmUgYWJvdXQgdGhlIGNvdW50IGJlaW5nDQorCQkJICogZGlmZmVyZW50IHRo
YW4gdGhlIG9uZSB3ZSBzYXcgYmVmb3JlLg0KKwkJCSAqLw0KKwkJCWhhbmRsZWQgPSBhdG9taWNf
cmVhZCgmZGVzYy0+dGhyZWFkc19oYW5kbGVkKTsNCisJCQloYW5kbGVkIHw9IFNQVVJJT1VTX0RF
RkVSUkVEOw0KKwkJCWlmIChoYW5kbGVkICE9IGRlc2MtPnRocmVhZHNfaGFuZGxlZF9sYXN0KSB7
DQorCQkJCWFjdGlvbl9yZXQgPSBJUlFfSEFORExFRDsNCisJCQkJLyoNCisJCQkJICogTm90ZTog
V2Uga2VlcCB0aGUgU1BVUklPVVNfREVGRVJSRUQNCisJCQkJICogYml0IHNldC4gV2UgYXJlIGhh
bmRsaW5nIHRoZQ0KKwkJCQkgKiBwcmV2aW91cyBpbnZvY2F0aW9uIHJpZ2h0IG5vdy4NCisJCQkJ
ICogS2VlcCBpdCBmb3IgdGhlIGN1cnJlbnQgb25lLCBzbyB0aGUNCisJCQkJICogbmV4dCBoYXJk
d2FyZSBpbnRlcnJ1cHQgd2lsbA0KKwkJCQkgKiBhY2NvdW50IGZvciBpdC4NCisJCQkJICovDQor
CQkJCWRlc2MtPnRocmVhZHNfaGFuZGxlZF9sYXN0ID0gaGFuZGxlZDsNCisJCQl9IGVsc2Ugew0K
KwkJCQkvKg0KKwkJCQkgKiBOb25lIG9mIHRoZSB0aHJlYWRlZCBoYW5kbGVycyBmZWx0DQorCQkJ
CSAqIHJlc3BvbnNpYmxlIGZvciB0aGUgbGFzdCBpbnRlcnJ1cHQNCisJCQkJICoNCisJCQkJICog
V2Uga2VlcCB0aGUgU1BVUklPVVNfREVGRVJSRUQgYml0DQorCQkJCSAqIHNldCBpbiB0aHJlYWRz
X2hhbmRsZWRfbGFzdCBhcyB3ZQ0KKwkJCQkgKiBuZWVkIHRvIGFjY291bnQgZm9yIHRoZSBjdXJy
ZW50DQorCQkJCSAqIGludGVycnVwdCBhcyB3ZWxsLg0KKwkJCQkgKi8NCisJCQkJYWN0aW9uX3Jl
dCA9IElSUV9OT05FOw0KKwkJCX0NCisJCX0gZWxzZSB7DQorCQkJLyoNCisJCQkgKiBPbmUgb2Yg
dGhlIHByaW1hcnkgaGFuZGxlcnMgcmV0dXJuZWQNCisJCQkgKiBJUlFfSEFORExFRC4gU28gd2Ug
ZG9uJ3QgY2FyZSBhYm91dCB0aGUNCisJCQkgKiB0aHJlYWRlZCBoYW5kbGVycyBvbiB0aGUgc2Ft
ZSBsaW5lLiBDbGVhcg0KKwkJCSAqIHRoZSBkZWZlcnJlZCBkZXRlY3Rpb24gYml0Lg0KKwkJCSAq
DQorCQkJICogSW4gdGhlb3J5IHdlIGNvdWxkL3Nob3VsZCBjaGVjayB3aGV0aGVyIHRoZQ0KKwkJ
CSAqIGRlZmVycmVkIGJpdCBpcyBzZXQgYW5kIHRha2UgdGhlIHJlc3VsdCBvZg0KKwkJCSAqIHRo
ZSBwcmV2aW91cyBydW4gaW50byBhY2NvdW50IGhlcmUgYXMNCisJCQkgKiB3ZWxsLiBCdXQgaXQn
cyByZWFsbHkgbm90IHdvcnRoIHRoZQ0KKwkJCSAqIHRyb3VibGUuIElmIGV2ZXJ5IG90aGVyIGlu
dGVycnVwdCBpcw0KKwkJCSAqIGhhbmRsZWQgd2UgbmV2ZXIgdHJpZ2dlciB0aGUgc3B1cmlvdXMN
CisJCQkgKiBkZXRlY3Rvci4gQW5kIGlmIHRoaXMgaXMganVzdCB0aGUgb25lIG91dA0KKwkJCSAq
IG9mIDEwMGsgdW5oYW5kbGVkIG9uZXMgd2hpY2ggaXMgaGFuZGxlZA0KKwkJCSAqIHRoZW4gd2Ug
bWVyaWx5IGRlbGF5IHRoZSBzcHVyaW91cyBkZXRlY3Rpb24NCisJCQkgKiBieSBvbmUgaGFyZCBp
bnRlcnJ1cHQuIE5vdCBhIHJlYWwgcHJvYmxlbS4NCisJCQkgKi8NCisJCQlkZXNjLT50aHJlYWRz
X2hhbmRsZWRfbGFzdCAmPSB+U1BVUklPVVNfREVGRVJSRUQ7DQorCQl9DQorCX0NCisNCiAJaWYg
KHVubGlrZWx5KGFjdGlvbl9yZXQgPT0gSVJRX05PTkUpKSB7DQogCQkvKg0KIAkJICogSWYgd2Ug
YXJlIHNlZWluZyBvbmx5IHRoZSBvZGQgc3B1cmlvdXMgSVJRIGNhdXNlZCBieQ0KZGlmZiAtLWdp
dCBhL2tlcm5lbC9ydG11dGV4LWRlYnVnLmggYi9rZXJuZWwvcnRtdXRleC1kZWJ1Zy5oDQppbmRl
eCAxNDE5M2Q1Li5hYjI5YjZhIDEwMDY0NA0KLS0tIGEva2VybmVsL3J0bXV0ZXgtZGVidWcuaA0K
KysrIGIva2VybmVsL3J0bXV0ZXgtZGVidWcuaA0KQEAgLTMxLDMgKzMxLDggQEAgc3RhdGljIGlu
bGluZSBpbnQgZGVidWdfcnRfbXV0ZXhfZGV0ZWN0X2RlYWRsb2NrKHN0cnVjdCBydF9tdXRleF93
YWl0ZXIgKndhaXRlciwNCiB7DQogCXJldHVybiAod2FpdGVyICE9IE5VTEwpOw0KIH0NCisNCitz
dGF0aWMgaW5saW5lIHZvaWQgcnRfbXV0ZXhfcHJpbnRfZGVhZGxvY2soc3RydWN0IHJ0X211dGV4
X3dhaXRlciAqdykNCit7DQorCWRlYnVnX3J0X211dGV4X3ByaW50X2RlYWRsb2NrKHcpOw0KK30N
CmRpZmYgLS1naXQgYS9rZXJuZWwvcnRtdXRleC5jIGIva2VybmVsL3J0bXV0ZXguYw0KaW5kZXgg
ZjlkODQ4Mi4uMTkyOGYzZCAxMDA2NDQNCi0tLSBhL2tlcm5lbC9ydG11dGV4LmMNCisrKyBiL2tl
cm5lbC9ydG11dGV4LmMNCkBAIC04MSw2ICs4MSw0NyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgbWFy
a19ydF9tdXRleF93YWl0ZXJzKHN0cnVjdCBydF9tdXRleCAqbG9jaykNCiAJCW93bmVyID0gKnA7
DQogCX0gd2hpbGUgKGNtcHhjaGcocCwgb3duZXIsIG93bmVyIHwgUlRfTVVURVhfSEFTX1dBSVRF
UlMpICE9IG93bmVyKTsNCiB9DQorDQorLyoNCisgKiBTYWZlIGZhc3RwYXRoIGF3YXJlIHVubG9j
azoNCisgKiAxKSBDbGVhciB0aGUgd2FpdGVycyBiaXQNCisgKiAyKSBEcm9wIGxvY2stPndhaXRf
bG9jaw0KKyAqIDMpIFRyeSB0byB1bmxvY2sgdGhlIGxvY2sgd2l0aCBjbXB4Y2hnDQorICovDQor
c3RhdGljIGlubGluZSBib29sIHVubG9ja19ydF9tdXRleF9zYWZlKHN0cnVjdCBydF9tdXRleCAq
bG9jaykNCisJX19yZWxlYXNlcyhsb2NrLT53YWl0X2xvY2spDQorew0KKwlzdHJ1Y3QgdGFza19z
dHJ1Y3QgKm93bmVyID0gcnRfbXV0ZXhfb3duZXIobG9jayk7DQorDQorCWNsZWFyX3J0X211dGV4
X3dhaXRlcnMobG9jayk7DQorCXJhd19zcGluX3VubG9jaygmbG9jay0+d2FpdF9sb2NrKTsNCisJ
LyoNCisJICogSWYgYSBuZXcgd2FpdGVyIGNvbWVzIGluIGJldHdlZW4gdGhlIHVubG9jayBhbmQg
dGhlIGNtcHhjaGcNCisJICogd2UgaGF2ZSB0d28gc2l0dWF0aW9uczoNCisJICoNCisJICogdW5s
b2NrKHdhaXRfbG9jayk7DQorCSAqCQkJCQlsb2NrKHdhaXRfbG9jayk7DQorCSAqIGNtcHhjaGco
cCwgb3duZXIsIDApID09IG93bmVyDQorCSAqCQkJCQltYXJrX3J0X211dGV4X3dhaXRlcnMobG9j
ayk7DQorCSAqCQkJCQlhY3F1aXJlKGxvY2spOw0KKwkgKiBvcjoNCisJICoNCisJICogdW5sb2Nr
KHdhaXRfbG9jayk7DQorCSAqCQkJCQlsb2NrKHdhaXRfbG9jayk7DQorCSAqCQkJCQltYXJrX3J0
X211dGV4X3dhaXRlcnMobG9jayk7DQorCSAqDQorCSAqIGNtcHhjaGcocCwgb3duZXIsIDApICE9
IG93bmVyDQorCSAqCQkJCQllbnF1ZXVlX3dhaXRlcigpOw0KKwkgKgkJCQkJdW5sb2NrKHdhaXRf
bG9jayk7DQorCSAqIGxvY2sod2FpdF9sb2NrKTsNCisJICogd2FrZSB3YWl0ZXIoKTsNCisJICog
dW5sb2NrKHdhaXRfbG9jayk7DQorCSAqCQkJCQlsb2NrKHdhaXRfbG9jayk7DQorCSAqCQkJCQlh
Y3F1aXJlKGxvY2spOw0KKwkgKi8NCisJcmV0dXJuIHJ0X211dGV4X2NtcHhjaGcobG9jaywgb3du
ZXIsIE5VTEwpOw0KK30NCisNCiAjZWxzZQ0KICMgZGVmaW5lIHJ0X211dGV4X2NtcHhjaGcobCxj
LG4pCSgwKQ0KIHN0YXRpYyBpbmxpbmUgdm9pZCBtYXJrX3J0X211dGV4X3dhaXRlcnMoc3RydWN0
IHJ0X211dGV4ICpsb2NrKQ0KQEAgLTg4LDYgKzEyOSwxNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQg
bWFya19ydF9tdXRleF93YWl0ZXJzKHN0cnVjdCBydF9tdXRleCAqbG9jaykNCiAJbG9jay0+b3du
ZXIgPSAoc3RydWN0IHRhc2tfc3RydWN0ICopDQogCQkJKCh1bnNpZ25lZCBsb25nKWxvY2stPm93
bmVyIHwgUlRfTVVURVhfSEFTX1dBSVRFUlMpOw0KIH0NCisNCisvKg0KKyAqIFNpbXBsZSBzbG93
IHBhdGggb25seSB2ZXJzaW9uOiBsb2NrLT5vd25lciBpcyBwcm90ZWN0ZWQgYnkgbG9jay0+d2Fp
dF9sb2NrLg0KKyAqLw0KK3N0YXRpYyBpbmxpbmUgYm9vbCB1bmxvY2tfcnRfbXV0ZXhfc2FmZShz
dHJ1Y3QgcnRfbXV0ZXggKmxvY2spDQorCV9fcmVsZWFzZXMobG9jay0+d2FpdF9sb2NrKQ0KK3sN
CisJbG9jay0+b3duZXIgPSBOVUxMOw0KKwlyYXdfc3Bpbl91bmxvY2soJmxvY2stPndhaXRfbG9j
ayk7DQorCXJldHVybiB0cnVlOw0KK30NCiAjZW5kaWYNCiANCiAvKg0KQEAgLTE0MSwxNCArMTkz
LDM2IEBAIHN0YXRpYyB2b2lkIHJ0X211dGV4X2FkanVzdF9wcmlvKHN0cnVjdCB0YXNrX3N0cnVj
dCAqdGFzaykNCiAgKi8NCiBpbnQgbWF4X2xvY2tfZGVwdGggPSAxMDI0Ow0KIA0KK3N0YXRpYyBp
bmxpbmUgc3RydWN0IHJ0X211dGV4ICp0YXNrX2Jsb2NrZWRfb25fbG9jayhzdHJ1Y3QgdGFza19z
dHJ1Y3QgKnApDQorew0KKwlyZXR1cm4gcC0+cGlfYmxvY2tlZF9vbiA/IHAtPnBpX2Jsb2NrZWRf
b24tPmxvY2sgOiBOVUxMOw0KK30NCisNCiAvKg0KICAqIEFkanVzdCB0aGUgcHJpb3JpdHkgY2hh
aW4uIEFsc28gdXNlZCBmb3IgZGVhZGxvY2sgZGV0ZWN0aW9uLg0KICAqIERlY3JlYXNlcyB0YXNr
J3MgdXNhZ2UgYnkgb25lIC0gbWF5IHRodXMgZnJlZSB0aGUgdGFzay4NCisgKg0KKyAqIEB0YXNr
Ogl0aGUgdGFzayBvd25pbmcgdGhlIG11dGV4IChvd25lcikgZm9yIHdoaWNoIGEgY2hhaW4gd2Fs
ayBpcw0KKyAqCQlwcm9iYWJseSBuZWVkZWQNCisgKiBAZGVhZGxvY2tfZGV0ZWN0OiBkbyB3ZSBo
YXZlIHRvIGNhcnJ5IG91dCBkZWFkbG9jayBkZXRlY3Rpb24/DQorICogQG9yaWdfbG9jazoJdGhl
IG11dGV4IChjYW4gYmUgTlVMTCBpZiB3ZSBhcmUgd2Fsa2luZyB0aGUgY2hhaW4gdG8gcmVjaGVj
aw0KKyAqCQl0aGluZ3MgZm9yIGEgdGFzayB0aGF0IGhhcyBqdXN0IGdvdCBpdHMgcHJpb3JpdHkg
YWRqdXN0ZWQsIGFuZA0KKyAqCQlpcyB3YWl0aW5nIG9uIGEgbXV0ZXgpDQorICogQG5leHRfbG9j
azoJdGhlIG11dGV4IG9uIHdoaWNoIHRoZSBvd25lciBvZiBAb3JpZ19sb2NrIHdhcyBibG9ja2Vk
IGJlZm9yZQ0KKyAqCQl3ZSBkcm9wcGVkIGl0cyBwaV9sb2NrLiBJcyBuZXZlciBkZXJlZmVyZW5j
ZWQsIG9ubHkgdXNlZCBmb3INCisgKgkJY29tcGFyaXNvbiB0byBkZXRlY3QgbG9jayBjaGFpbiBj
aGFuZ2VzLg0KKyAqIEBvcmlnX3dhaXRlcjogcnRfbXV0ZXhfd2FpdGVyIHN0cnVjdCBmb3IgdGhl
IHRhc2sgdGhhdCBoYXMganVzdCBkb25hdGVkDQorICoJCWl0cyBwcmlvcml0eSB0byB0aGUgbXV0
ZXggb3duZXIgKGNhbiBiZSBOVUxMIGluIHRoZSBjYXNlDQorICoJCWRlcGljdGVkIGFib3ZlIG9y
IGlmIHRoZSB0b3Agd2FpdGVyIGlzIGdvbmUgYXdheSBhbmQgd2UgYXJlDQorICoJCWFjdHVhbGx5
IGRlYm9vc3RpbmcgdGhlIG93bmVyKQ0KKyAqIEB0b3BfdGFzazoJdGhlIGN1cnJlbnQgdG9wIHdh
aXRlcg0KKyAqDQogICogUmV0dXJucyAwIG9yIC1FREVBRExLLg0KICAqLw0KIHN0YXRpYyBpbnQg
cnRfbXV0ZXhfYWRqdXN0X3ByaW9fY2hhaW4oc3RydWN0IHRhc2tfc3RydWN0ICp0YXNrLA0KIAkJ
CQkgICAgICBpbnQgZGVhZGxvY2tfZGV0ZWN0LA0KIAkJCQkgICAgICBzdHJ1Y3QgcnRfbXV0ZXgg
Km9yaWdfbG9jaywNCisJCQkJICAgICAgc3RydWN0IHJ0X211dGV4ICpuZXh0X2xvY2ssDQogCQkJ
CSAgICAgIHN0cnVjdCBydF9tdXRleF93YWl0ZXIgKm9yaWdfd2FpdGVyLA0KIAkJCQkgICAgICBz
dHJ1Y3QgdGFza19zdHJ1Y3QgKnRvcF90YXNrKQ0KIHsNCkBAIC0xODIsNyArMjU2LDcgQEAgc3Rh
dGljIGludCBydF9tdXRleF9hZGp1c3RfcHJpb19jaGFpbihzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRh
c2ssDQogCQl9DQogCQlwdXRfdGFza19zdHJ1Y3QodGFzayk7DQogDQotCQlyZXR1cm4gZGVhZGxv
Y2tfZGV0ZWN0ID8gLUVERUFETEsgOiAwOw0KKwkJcmV0dXJuIC1FREVBRExLOw0KIAl9DQogIHJl
dHJ5Og0KIAkvKg0KQEAgLTIwNywxMyArMjgxLDMyIEBAIHN0YXRpYyBpbnQgcnRfbXV0ZXhfYWRq
dXN0X3ByaW9fY2hhaW4oc3RydWN0IHRhc2tfc3RydWN0ICp0YXNrLA0KIAkJZ290byBvdXRfdW5s
b2NrX3BpOw0KIA0KIAkvKg0KKwkgKiBXZSBkcm9wcGVkIGFsbCBsb2NrcyBhZnRlciB0YWtpbmcg
YSByZWZjb3VudCBvbiBAdGFzaywgc28NCisJICogdGhlIHRhc2sgbWlnaHQgaGF2ZSBtb3ZlZCBv
biBpbiB0aGUgbG9jayBjaGFpbiBvciBldmVuIGxlZnQNCisJICogdGhlIGNoYWluIGNvbXBsZXRl
bHkgYW5kIGJsb2NrcyBub3cgb24gYW4gdW5yZWxhdGVkIGxvY2sgb3INCisJICogb24gQG9yaWdf
bG9jay4NCisJICoNCisJICogV2Ugc3RvcmVkIHRoZSBsb2NrIG9uIHdoaWNoIEB0YXNrIHdhcyBi
bG9ja2VkIGluIEBuZXh0X2xvY2ssDQorCSAqIHNvIHdlIGNhbiBkZXRlY3QgdGhlIGNoYWluIGNo
YW5nZS4NCisJICovDQorCWlmIChuZXh0X2xvY2sgIT0gd2FpdGVyLT5sb2NrKQ0KKwkJZ290byBv
dXRfdW5sb2NrX3BpOw0KKw0KKwkvKg0KIAkgKiBEcm9wIG91dCwgd2hlbiB0aGUgdGFzayBoYXMg
bm8gd2FpdGVycy4gTm90ZSwNCiAJICogdG9wX3dhaXRlciBjYW4gYmUgTlVMTCwgd2hlbiB3ZSBh
cmUgaW4gdGhlIGRlYm9vc3RpbmcNCiAJICogbW9kZSENCiAJICovDQotCWlmICh0b3Bfd2FpdGVy
ICYmICghdGFza19oYXNfcGlfd2FpdGVycyh0YXNrKSB8fA0KLQkJCSAgIHRvcF93YWl0ZXIgIT0g
dGFza190b3BfcGlfd2FpdGVyKHRhc2spKSkNCi0JCWdvdG8gb3V0X3VubG9ja19waTsNCisJaWYg
KHRvcF93YWl0ZXIpIHsNCisJCWlmICghdGFza19oYXNfcGlfd2FpdGVycyh0YXNrKSkNCisJCQln
b3RvIG91dF91bmxvY2tfcGk7DQorCQkvKg0KKwkJICogSWYgZGVhZGxvY2sgZGV0ZWN0aW9uIGlz
IG9mZiwgd2Ugc3RvcCBoZXJlIGlmIHdlDQorCQkgKiBhcmUgbm90IHRoZSB0b3AgcGkgd2FpdGVy
IG9mIHRoZSB0YXNrLg0KKwkJICovDQorCQlpZiAoIWRldGVjdF9kZWFkbG9jayAmJiB0b3Bfd2Fp
dGVyICE9IHRhc2tfdG9wX3BpX3dhaXRlcih0YXNrKSkNCisJCQlnb3RvIG91dF91bmxvY2tfcGk7
DQorCX0NCiANCiAJLyoNCiAJICogV2hlbiBkZWFkbG9jayBkZXRlY3Rpb24gaXMgb2ZmIHRoZW4g
d2UgY2hlY2ssIGlmIGZ1cnRoZXINCkBAIC0yMjksMTEgKzMyMiwxNiBAQCBzdGF0aWMgaW50IHJ0
X211dGV4X2FkanVzdF9wcmlvX2NoYWluKHN0cnVjdCB0YXNrX3N0cnVjdCAqdGFzaywNCiAJCWdv
dG8gcmV0cnk7DQogCX0NCiANCi0JLyogRGVhZGxvY2sgZGV0ZWN0aW9uICovDQorCS8qDQorCSAq
IERlYWRsb2NrIGRldGVjdGlvbi4gSWYgdGhlIGxvY2sgaXMgdGhlIHNhbWUgYXMgdGhlIG9yaWdp
bmFsDQorCSAqIGxvY2sgd2hpY2ggY2F1c2VkIHVzIHRvIHdhbGsgdGhlIGxvY2sgY2hhaW4gb3Ig
aWYgdGhlDQorCSAqIGN1cnJlbnQgbG9jayBpcyBvd25lZCBieSB0aGUgdGFzayB3aGljaCBpbml0
aWF0ZWQgdGhlIGNoYWluDQorCSAqIHdhbGssIHdlIGRldGVjdGVkIGEgZGVhZGxvY2suDQorCSAq
Lw0KIAlpZiAobG9jayA9PSBvcmlnX2xvY2sgfHwgcnRfbXV0ZXhfb3duZXIobG9jaykgPT0gdG9w
X3Rhc2spIHsNCiAJCWRlYnVnX3J0X211dGV4X2RlYWRsb2NrKGRlYWRsb2NrX2RldGVjdCwgb3Jp
Z193YWl0ZXIsIGxvY2spOw0KIAkJcmF3X3NwaW5fdW5sb2NrKCZsb2NrLT53YWl0X2xvY2spOw0K
LQkJcmV0ID0gZGVhZGxvY2tfZGV0ZWN0ID8gLUVERUFETEsgOiAwOw0KKwkJcmV0ID0gLUVERUFE
TEs7DQogCQlnb3RvIG91dF91bmxvY2tfcGk7DQogCX0NCiANCkBAIC0yODAsMTEgKzM3OCwyNiBA
QCBzdGF0aWMgaW50IHJ0X211dGV4X2FkanVzdF9wcmlvX2NoYWluKHN0cnVjdCB0YXNrX3N0cnVj
dCAqdGFzaywNCiAJCV9fcnRfbXV0ZXhfYWRqdXN0X3ByaW8odGFzayk7DQogCX0NCiANCisJLyoN
CisJICogQ2hlY2sgd2hldGhlciB0aGUgdGFzayB3aGljaCBvd25zIHRoZSBjdXJyZW50IGxvY2sg
aXMgcGkNCisJICogYmxvY2tlZCBpdHNlbGYuIElmIHllcyB3ZSBzdG9yZSBhIHBvaW50ZXIgdG8g
dGhlIGxvY2sgZm9yDQorCSAqIHRoZSBsb2NrIGNoYWluIGNoYW5nZSBkZXRlY3Rpb24gYWJvdmUu
IEFmdGVyIHdlIGRyb3BwZWQNCisJICogdGFzay0+cGlfbG9jayBuZXh0X2xvY2sgY2Fubm90IGJl
IGRlcmVmZXJlbmNlZCBhbnltb3JlLg0KKwkgKi8NCisJbmV4dF9sb2NrID0gdGFza19ibG9ja2Vk
X29uX2xvY2sodGFzayk7DQorDQogCXJhd19zcGluX3VubG9ja19pcnFyZXN0b3JlKCZ0YXNrLT5w
aV9sb2NrLCBmbGFncyk7DQogDQogCXRvcF93YWl0ZXIgPSBydF9tdXRleF90b3Bfd2FpdGVyKGxv
Y2spOw0KIAlyYXdfc3Bpbl91bmxvY2soJmxvY2stPndhaXRfbG9jayk7DQogDQorCS8qDQorCSAq
IFdlIHJlYWNoZWQgdGhlIGVuZCBvZiB0aGUgbG9jayBjaGFpbi4gU3RvcCByaWdodCBoZXJlLiBO
bw0KKwkgKiBwb2ludCB0byBnbyBiYWNrIGp1c3QgdG8gZmlndXJlIHRoYXQgb3V0Lg0KKwkgKi8N
CisJaWYgKCFuZXh0X2xvY2spDQorCQlnb3RvIG91dF9wdXRfdGFzazsNCisNCiAJaWYgKCFkZXRl
Y3RfZGVhZGxvY2sgJiYgd2FpdGVyICE9IHRvcF93YWl0ZXIpDQogCQlnb3RvIG91dF9wdXRfdGFz
azsNCiANCkBAIC0zOTUsOCArNTA4LDIxIEBAIHN0YXRpYyBpbnQgdGFza19ibG9ja3Nfb25fcnRf
bXV0ZXgoc3RydWN0IHJ0X211dGV4ICpsb2NrLA0KIHsNCiAJc3RydWN0IHRhc2tfc3RydWN0ICpv
d25lciA9IHJ0X211dGV4X293bmVyKGxvY2spOw0KIAlzdHJ1Y3QgcnRfbXV0ZXhfd2FpdGVyICp0
b3Bfd2FpdGVyID0gd2FpdGVyOw0KLQl1bnNpZ25lZCBsb25nIGZsYWdzOw0KKwlzdHJ1Y3QgcnRf
bXV0ZXggKm5leHRfbG9jazsNCiAJaW50IGNoYWluX3dhbGsgPSAwLCByZXM7DQorCXVuc2lnbmVk
IGxvbmcgZmxhZ3M7DQorDQorCS8qDQorCSAqIEVhcmx5IGRlYWRsb2NrIGRldGVjdGlvbi4gV2Ug
cmVhbGx5IGRvbid0IHdhbnQgdGhlIHRhc2sgdG8NCisJICogZW5xdWV1ZSBvbiBpdHNlbGYganVz
dCB0byB1bnRhbmdsZSB0aGUgbWVzcyBsYXRlci4gSXQncyBub3QNCisJICogb25seSBhbiBvcHRp
bWl6YXRpb24uIFdlIGRyb3AgdGhlIGxvY2tzLCBzbyBhbm90aGVyIHdhaXRlcg0KKwkgKiBjYW4g
Y29tZSBpbiBiZWZvcmUgdGhlIGNoYWluIHdhbGsgZGV0ZWN0cyB0aGUgZGVhZGxvY2suIFNvDQor
CSAqIHRoZSBvdGhlciB3aWxsIGRldGVjdCB0aGUgZGVhZGxvY2sgYW5kIHJldHVybiAtRURFQURM
T0NLLA0KKwkgKiB3aGljaCBpcyB3cm9uZywgYXMgdGhlIG90aGVyIHdhaXRlciBpcyBub3QgaW4g
YSBkZWFkbG9jaw0KKwkgKiBzaXR1YXRpb24uDQorCSAqLw0KKwlpZiAob3duZXIgPT0gdGFzaykN
CisJCXJldHVybiAtRURFQURMSzsNCiANCiAJcmF3X3NwaW5fbG9ja19pcnFzYXZlKCZ0YXNrLT5w
aV9sb2NrLCBmbGFncyk7DQogCV9fcnRfbXV0ZXhfYWRqdXN0X3ByaW8odGFzayk7DQpAQCAtNDE3
LDIwICs1NDMsMjggQEAgc3RhdGljIGludCB0YXNrX2Jsb2Nrc19vbl9ydF9tdXRleChzdHJ1Y3Qg
cnRfbXV0ZXggKmxvY2ssDQogCWlmICghb3duZXIpDQogCQlyZXR1cm4gMDsNCiANCisJcmF3X3Nw
aW5fbG9ja19pcnFzYXZlKCZvd25lci0+cGlfbG9jaywgZmxhZ3MpOw0KIAlpZiAod2FpdGVyID09
IHJ0X211dGV4X3RvcF93YWl0ZXIobG9jaykpIHsNCi0JCXJhd19zcGluX2xvY2tfaXJxc2F2ZSgm
b3duZXItPnBpX2xvY2ssIGZsYWdzKTsNCiAJCXBsaXN0X2RlbCgmdG9wX3dhaXRlci0+cGlfbGlz
dF9lbnRyeSwgJm93bmVyLT5waV93YWl0ZXJzKTsNCiAJCXBsaXN0X2FkZCgmd2FpdGVyLT5waV9s
aXN0X2VudHJ5LCAmb3duZXItPnBpX3dhaXRlcnMpOw0KIA0KIAkJX19ydF9tdXRleF9hZGp1c3Rf
cHJpbyhvd25lcik7DQogCQlpZiAob3duZXItPnBpX2Jsb2NrZWRfb24pDQogCQkJY2hhaW5fd2Fs
ayA9IDE7DQotCQlyYXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmb3duZXItPnBpX2xvY2ssIGZs
YWdzKTsNCi0JfQ0KLQllbHNlIGlmIChkZWJ1Z19ydF9tdXRleF9kZXRlY3RfZGVhZGxvY2sod2Fp
dGVyLCBkZXRlY3RfZGVhZGxvY2spKQ0KKwl9IGVsc2UgaWYgKGRlYnVnX3J0X211dGV4X2RldGVj
dF9kZWFkbG9jayh3YWl0ZXIsIGRldGVjdF9kZWFkbG9jaykpIHsNCiAJCWNoYWluX3dhbGsgPSAx
Ow0KKwl9DQorDQorCS8qIFN0b3JlIHRoZSBsb2NrIG9uIHdoaWNoIG93bmVyIGlzIGJsb2NrZWQg
b3IgTlVMTCAqLw0KKwluZXh0X2xvY2sgPSB0YXNrX2Jsb2NrZWRfb25fbG9jayhvd25lcik7DQog
DQotCWlmICghY2hhaW5fd2FsaykNCisJcmF3X3NwaW5fdW5sb2NrX2lycXJlc3RvcmUoJm93bmVy
LT5waV9sb2NrLCBmbGFncyk7DQorCS8qDQorCSAqIEV2ZW4gaWYgZnVsbCBkZWFkbG9jayBkZXRl
Y3Rpb24gaXMgb24sIGlmIHRoZSBvd25lciBpcyBub3QNCisJICogYmxvY2tlZCBpdHNlbGYsIHdl
IGNhbiBhdm9pZCBmaW5kaW5nIHRoaXMgb3V0IGluIHRoZSBjaGFpbg0KKwkgKiB3YWxrLg0KKwkg
Ki8NCisJaWYgKCFjaGFpbl93YWxrIHx8ICFuZXh0X2xvY2spDQogCQlyZXR1cm4gMDsNCiANCiAJ
LyoNCkBAIC00NDIsOCArNTc2LDggQEAgc3RhdGljIGludCB0YXNrX2Jsb2Nrc19vbl9ydF9tdXRl
eChzdHJ1Y3QgcnRfbXV0ZXggKmxvY2ssDQogDQogCXJhd19zcGluX3VubG9jaygmbG9jay0+d2Fp
dF9sb2NrKTsNCiANCi0JcmVzID0gcnRfbXV0ZXhfYWRqdXN0X3ByaW9fY2hhaW4ob3duZXIsIGRl
dGVjdF9kZWFkbG9jaywgbG9jaywgd2FpdGVyLA0KLQkJCQkJIHRhc2spOw0KKwlyZXMgPSBydF9t
dXRleF9hZGp1c3RfcHJpb19jaGFpbihvd25lciwgZGV0ZWN0X2RlYWRsb2NrLCBsb2NrLA0KKwkJ
CQkJIG5leHRfbG9jaywgd2FpdGVyLCB0YXNrKTsNCiANCiAJcmF3X3NwaW5fbG9jaygmbG9jay0+
d2FpdF9sb2NrKTsNCiANCkBAIC00NTMsNyArNTg3LDggQEAgc3RhdGljIGludCB0YXNrX2Jsb2Nr
c19vbl9ydF9tdXRleChzdHJ1Y3QgcnRfbXV0ZXggKmxvY2ssDQogLyoNCiAgKiBXYWtlIHVwIHRo
ZSBuZXh0IHdhaXRlciBvbiB0aGUgbG9jay4NCiAgKg0KLSAqIFJlbW92ZSB0aGUgdG9wIHdhaXRl
ciBmcm9tIHRoZSBjdXJyZW50IHRhc2tzIHdhaXRlciBsaXN0IGFuZCB3YWtlIGl0IHVwLg0KKyAq
IFJlbW92ZSB0aGUgdG9wIHdhaXRlciBmcm9tIHRoZSBjdXJyZW50IHRhc2tzIHBpIHdhaXRlciBs
aXN0IGFuZA0KKyAqIHdha2UgaXQgdXAuDQogICoNCiAgKiBDYWxsZWQgd2l0aCBsb2NrLT53YWl0
X2xvY2sgaGVsZC4NCiAgKi8NCkBAIC00NzQsMTAgKzYwOSwyMyBAQCBzdGF0aWMgdm9pZCB3YWtl
dXBfbmV4dF93YWl0ZXIoc3RydWN0IHJ0X211dGV4ICpsb2NrKQ0KIAkgKi8NCiAJcGxpc3RfZGVs
KCZ3YWl0ZXItPnBpX2xpc3RfZW50cnksICZjdXJyZW50LT5waV93YWl0ZXJzKTsNCiANCi0JcnRf
bXV0ZXhfc2V0X293bmVyKGxvY2ssIE5VTEwpOw0KKwkvKg0KKwkgKiBBcyB3ZSBhcmUgd2FraW5n
IHVwIHRoZSB0b3Agd2FpdGVyLCBhbmQgdGhlIHdhaXRlciBzdGF5cw0KKwkgKiBxdWV1ZWQgb24g
dGhlIGxvY2sgdW50aWwgaXQgZ2V0cyB0aGUgbG9jaywgdGhpcyBsb2NrDQorCSAqIG9idmlvdXNs
eSBoYXMgd2FpdGVycy4gSnVzdCBzZXQgdGhlIGJpdCBoZXJlIGFuZCB0aGlzIGhhcw0KKwkgKiB0
aGUgYWRkZWQgYmVuZWZpdCBvZiBmb3JjaW5nIGFsbCBuZXcgdGFza3MgaW50byB0aGUNCisJICog
c2xvdyBwYXRoIG1ha2luZyBzdXJlIG5vIHRhc2sgb2YgbG93ZXIgcHJpb3JpdHkgdGhhbg0KKwkg
KiB0aGUgdG9wIHdhaXRlciBjYW4gc3RlYWwgdGhpcyBsb2NrLg0KKwkgKi8NCisJbG9jay0+b3du
ZXIgPSAodm9pZCAqKSBSVF9NVVRFWF9IQVNfV0FJVEVSUzsNCiANCiAJcmF3X3NwaW5fdW5sb2Nr
X2lycXJlc3RvcmUoJmN1cnJlbnQtPnBpX2xvY2ssIGZsYWdzKTsNCiANCisJLyoNCisJICogSXQn
cyBzYWZlIHRvIGRlcmVmZXJlbmNlIHdhaXRlciBhcyBpdCBjYW5ub3QgZ28gYXdheSBhcw0KKwkg
KiBsb25nIGFzIHdlIGhvbGQgbG9jay0+d2FpdF9sb2NrLiBUaGUgd2FpdGVyIHRhc2sgbmVlZHMg
dG8NCisJICogYWNxdWlyZSBpdCBpbiBvcmRlciB0byBkZXF1ZXVlIHRoZSB3YWl0ZXIuDQorCSAq
Lw0KIAl3YWtlX3VwX3Byb2Nlc3Mod2FpdGVyLT50YXNrKTsNCiB9DQogDQpAQCAtNDkyLDggKzY0
MCw4IEBAIHN0YXRpYyB2b2lkIHJlbW92ZV93YWl0ZXIoc3RydWN0IHJ0X211dGV4ICpsb2NrLA0K
IHsNCiAJaW50IGZpcnN0ID0gKHdhaXRlciA9PSBydF9tdXRleF90b3Bfd2FpdGVyKGxvY2spKTsN
CiAJc3RydWN0IHRhc2tfc3RydWN0ICpvd25lciA9IHJ0X211dGV4X293bmVyKGxvY2spOw0KKwlz
dHJ1Y3QgcnRfbXV0ZXggKm5leHRfbG9jayA9IE5VTEw7DQogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7
DQotCWludCBjaGFpbl93YWxrID0gMDsNCiANCiAJcmF3X3NwaW5fbG9ja19pcnFzYXZlKCZjdXJy
ZW50LT5waV9sb2NrLCBmbGFncyk7DQogCXBsaXN0X2RlbCgmd2FpdGVyLT5saXN0X2VudHJ5LCAm
bG9jay0+d2FpdF9saXN0KTsNCkBAIC01MTcsMTUgKzY2NSwxNSBAQCBzdGF0aWMgdm9pZCByZW1v
dmVfd2FpdGVyKHN0cnVjdCBydF9tdXRleCAqbG9jaywNCiAJCX0NCiAJCV9fcnRfbXV0ZXhfYWRq
dXN0X3ByaW8ob3duZXIpOw0KIA0KLQkJaWYgKG93bmVyLT5waV9ibG9ja2VkX29uKQ0KLQkJCWNo
YWluX3dhbGsgPSAxOw0KKwkJLyogU3RvcmUgdGhlIGxvY2sgb24gd2hpY2ggb3duZXIgaXMgYmxv
Y2tlZCBvciBOVUxMICovDQorCQluZXh0X2xvY2sgPSB0YXNrX2Jsb2NrZWRfb25fbG9jayhvd25l
cik7DQogDQogCQlyYXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmb3duZXItPnBpX2xvY2ssIGZs
YWdzKTsNCiAJfQ0KIA0KIAlXQVJOX09OKCFwbGlzdF9ub2RlX2VtcHR5KCZ3YWl0ZXItPnBpX2xp
c3RfZW50cnkpKTsNCiANCi0JaWYgKCFjaGFpbl93YWxrKQ0KKwlpZiAoIW5leHRfbG9jaykNCiAJ
CXJldHVybjsNCiANCiAJLyogZ2V0cyBkcm9wcGVkIGluIHJ0X211dGV4X2FkanVzdF9wcmlvX2No
YWluKCkhICovDQpAQCAtNTMzLDcgKzY4MSw3IEBAIHN0YXRpYyB2b2lkIHJlbW92ZV93YWl0ZXIo
c3RydWN0IHJ0X211dGV4ICpsb2NrLA0KIA0KIAlyYXdfc3Bpbl91bmxvY2soJmxvY2stPndhaXRf
bG9jayk7DQogDQotCXJ0X211dGV4X2FkanVzdF9wcmlvX2NoYWluKG93bmVyLCAwLCBsb2NrLCBO
VUxMLCBjdXJyZW50KTsNCisJcnRfbXV0ZXhfYWRqdXN0X3ByaW9fY2hhaW4ob3duZXIsIDAsIGxv
Y2ssIG5leHRfbG9jaywgTlVMTCwgY3VycmVudCk7DQogDQogCXJhd19zcGluX2xvY2soJmxvY2st
PndhaXRfbG9jayk7DQogfQ0KQEAgLTU0Niw2ICs2OTQsNyBAQCBzdGF0aWMgdm9pZCByZW1vdmVf
d2FpdGVyKHN0cnVjdCBydF9tdXRleCAqbG9jaywNCiB2b2lkIHJ0X211dGV4X2FkanVzdF9waShz
dHJ1Y3QgdGFza19zdHJ1Y3QgKnRhc2spDQogew0KIAlzdHJ1Y3QgcnRfbXV0ZXhfd2FpdGVyICp3
YWl0ZXI7DQorCXN0cnVjdCBydF9tdXRleCAqbmV4dF9sb2NrOw0KIAl1bnNpZ25lZCBsb25nIGZs
YWdzOw0KIA0KIAlyYXdfc3Bpbl9sb2NrX2lycXNhdmUoJnRhc2stPnBpX2xvY2ssIGZsYWdzKTsN
CkBAIC01NTUsMTIgKzcwNCwxMyBAQCB2b2lkIHJ0X211dGV4X2FkanVzdF9waShzdHJ1Y3QgdGFz
a19zdHJ1Y3QgKnRhc2spDQogCQlyYXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmdGFzay0+cGlf
bG9jaywgZmxhZ3MpOw0KIAkJcmV0dXJuOw0KIAl9DQotDQorCW5leHRfbG9jayA9IHdhaXRlci0+
bG9jazsNCiAJcmF3X3NwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnRhc2stPnBpX2xvY2ssIGZsYWdz
KTsNCiANCiAJLyogZ2V0cyBkcm9wcGVkIGluIHJ0X211dGV4X2FkanVzdF9wcmlvX2NoYWluKCkh
ICovDQogCWdldF90YXNrX3N0cnVjdCh0YXNrKTsNCi0JcnRfbXV0ZXhfYWRqdXN0X3ByaW9fY2hh
aW4odGFzaywgMCwgTlVMTCwgTlVMTCwgdGFzayk7DQorDQorCXJ0X211dGV4X2FkanVzdF9wcmlv
X2NoYWluKHRhc2ssIDAsIE5VTEwsIG5leHRfbG9jaywgTlVMTCwgdGFzayk7DQogfQ0KIA0KIC8q
Kg0KQEAgLTYyMCw2ICs3NzAsMjYgQEAgX19ydF9tdXRleF9zbG93bG9jayhzdHJ1Y3QgcnRfbXV0
ZXggKmxvY2ssIGludCBzdGF0ZSwNCiAJcmV0dXJuIHJldDsNCiB9DQogDQorc3RhdGljIHZvaWQg
cnRfbXV0ZXhfaGFuZGxlX2RlYWRsb2NrKGludCByZXMsIGludCBkZXRlY3RfZGVhZGxvY2ssDQor
CQkJCSAgICAgc3RydWN0IHJ0X211dGV4X3dhaXRlciAqdykNCit7DQorCS8qDQorCSAqIElmIHRo
ZSByZXN1bHQgaXMgbm90IC1FREVBRExPQ0sgb3IgdGhlIGNhbGxlciByZXF1ZXN0ZWQNCisJICog
ZGVhZGxvY2sgZGV0ZWN0aW9uLCBub3RoaW5nIHRvIGRvIGhlcmUuDQorCSAqLw0KKwlpZiAocmVz
ICE9IC1FREVBRExPQ0sgfHwgZGV0ZWN0X2RlYWRsb2NrKQ0KKwkJcmV0dXJuOw0KKw0KKwkvKg0K
KwkgKiBZZWxsIGxvd2RseSBhbmQgc3RvcCB0aGUgdGFzayByaWdodCBoZXJlLg0KKwkgKi8NCisJ
cnRfbXV0ZXhfcHJpbnRfZGVhZGxvY2sodyk7DQorCXdoaWxlICgxKSB7DQorCQlzZXRfY3VycmVu
dF9zdGF0ZShUQVNLX0lOVEVSUlVQVElCTEUpOw0KKwkJc2NoZWR1bGUoKTsNCisJfQ0KK30NCisN
CiAvKg0KICAqIFNsb3cgcGF0aCBsb2NrIGZ1bmN0aW9uOg0KICAqLw0KQEAgLTY1Nyw4ICs4Mjcs
MTAgQEAgcnRfbXV0ZXhfc2xvd2xvY2soc3RydWN0IHJ0X211dGV4ICpsb2NrLCBpbnQgc3RhdGUs
DQogDQogCXNldF9jdXJyZW50X3N0YXRlKFRBU0tfUlVOTklORyk7DQogDQotCWlmICh1bmxpa2Vs
eShyZXQpKQ0KKwlpZiAodW5saWtlbHkocmV0KSkgew0KIAkJcmVtb3ZlX3dhaXRlcihsb2NrLCAm
d2FpdGVyKTsNCisJCXJ0X211dGV4X2hhbmRsZV9kZWFkbG9jayhyZXQsIGRldGVjdF9kZWFkbG9j
aywgJndhaXRlcik7DQorCX0NCiANCiAJLyoNCiAJICogdHJ5X3RvX3Rha2VfcnRfbXV0ZXgoKSBz
ZXRzIHRoZSB3YWl0ZXIgYml0DQpAQCAtNzE0LDEyICs4ODYsNDkgQEAgcnRfbXV0ZXhfc2xvd3Vu
bG9jayhzdHJ1Y3QgcnRfbXV0ZXggKmxvY2spDQogDQogCXJ0X211dGV4X2RlYWRsb2NrX2FjY291
bnRfdW5sb2NrKGN1cnJlbnQpOw0KIA0KLQlpZiAoIXJ0X211dGV4X2hhc193YWl0ZXJzKGxvY2sp
KSB7DQotCQlsb2NrLT5vd25lciA9IE5VTEw7DQotCQlyYXdfc3Bpbl91bmxvY2soJmxvY2stPndh
aXRfbG9jayk7DQotCQlyZXR1cm47DQorCS8qDQorCSAqIFdlIG11c3QgYmUgY2FyZWZ1bCBoZXJl
IGlmIHRoZSBmYXN0IHBhdGggaXMgZW5hYmxlZC4gSWYgd2UNCisJICogaGF2ZSBubyB3YWl0ZXJz
IHF1ZXVlZCB3ZSBjYW5ub3Qgc2V0IG93bmVyIHRvIE5VTEwgaGVyZQ0KKwkgKiBiZWNhdXNlIG9m
Og0KKwkgKg0KKwkgKiBmb28tPmxvY2stPm93bmVyID0gTlVMTDsNCisJICoJCQlydG11dGV4X2xv
Y2soZm9vLT5sb2NrKTsgICA8LSBmYXN0IHBhdGgNCisJICoJCQlmcmVlID0gYXRvbWljX2RlY19h
bmRfdGVzdChmb28tPnJlZmNudCk7DQorCSAqCQkJcnRtdXRleF91bmxvY2soZm9vLT5sb2NrKTsg
PC0gZmFzdCBwYXRoDQorCSAqCQkJaWYgKGZyZWUpDQorCSAqCQkJCWtmcmVlKGZvbyk7DQorCSAq
IHJhd19zcGluX3VubG9jayhmb28tPmxvY2stPndhaXRfbG9jayk7DQorCSAqDQorCSAqIFNvIGZv
ciB0aGUgZmFzdHBhdGggZW5hYmxlZCBrZXJuZWw6DQorCSAqDQorCSAqIE5vdGhpbmcgY2FuIHNl
dCB0aGUgd2FpdGVycyBiaXQgYXMgbG9uZyBhcyB3ZSBob2xkDQorCSAqIGxvY2stPndhaXRfbG9j
ay4gU28gd2UgZG8gdGhlIGZvbGxvd2luZyBzZXF1ZW5jZToNCisJICoNCisJICoJb3duZXIgPSBy
dF9tdXRleF9vd25lcihsb2NrKTsNCisJICoJY2xlYXJfcnRfbXV0ZXhfd2FpdGVycyhsb2NrKTsN
CisJICoJcmF3X3NwaW5fdW5sb2NrKCZsb2NrLT53YWl0X2xvY2spOw0KKwkgKglpZiAoY21weGNo
ZygmbG9jay0+b3duZXIsIG93bmVyLCAwKSA9PSBvd25lcikNCisJICoJCXJldHVybjsNCisJICoJ
Z290byByZXRyeTsNCisJICoNCisJICogVGhlIGZhc3RwYXRoIGRpc2FibGVkIHZhcmlhbnQgaXMg
c2ltcGxlIGFzIGFsbCBhY2Nlc3MgdG8NCisJICogbG9jay0+b3duZXIgaXMgc2VyaWFsaXplZCBi
eSBsb2NrLT53YWl0X2xvY2s6DQorCSAqDQorCSAqCWxvY2stPm93bmVyID0gTlVMTDsNCisJICoJ
cmF3X3NwaW5fdW5sb2NrKCZsb2NrLT53YWl0X2xvY2spOw0KKwkgKi8NCisJd2hpbGUgKCFydF9t
dXRleF9oYXNfd2FpdGVycyhsb2NrKSkgew0KKwkJLyogRHJvcHMgbG9jay0+d2FpdF9sb2NrICEg
Ki8NCisJCWlmICh1bmxvY2tfcnRfbXV0ZXhfc2FmZShsb2NrKSA9PSB0cnVlKQ0KKwkJCXJldHVy
bjsNCisJCS8qIFJlbG9jayB0aGUgcnRtdXRleCBhbmQgdHJ5IGFnYWluICovDQorCQlyYXdfc3Bp
bl9sb2NrKCZsb2NrLT53YWl0X2xvY2spOw0KIAl9DQogDQorCS8qDQorCSAqIFRoZSB3YWtldXAg
bmV4dCB3YWl0ZXIgcGF0aCBkb2VzIG5vdCBzdWZmZXIgZnJvbSB0aGUgYWJvdmUNCisJICogcmFj
ZS4gU2VlIHRoZSBjb21tZW50cyB0aGVyZS4NCisJICovDQogCXdha2V1cF9uZXh0X3dhaXRlcihs
b2NrKTsNCiANCiAJcmF3X3NwaW5fdW5sb2NrKCZsb2NrLT53YWl0X2xvY2spOw0KQEAgLTk2Niw3
ICsxMTc1LDggQEAgaW50IHJ0X211dGV4X3N0YXJ0X3Byb3h5X2xvY2soc3RydWN0IHJ0X211dGV4
ICpsb2NrLA0KIAkJcmV0dXJuIDE7DQogCX0NCiANCi0JcmV0ID0gdGFza19ibG9ja3Nfb25fcnRf
bXV0ZXgobG9jaywgd2FpdGVyLCB0YXNrLCBkZXRlY3RfZGVhZGxvY2spOw0KKwkvKiBXZSBlbmZv
cmNlIGRlYWRsb2NrIGRldGVjdGlvbiBmb3IgZnV0ZXhlcyAqLw0KKwlyZXQgPSB0YXNrX2Jsb2Nr
c19vbl9ydF9tdXRleChsb2NrLCB3YWl0ZXIsIHRhc2ssIDEpOw0KIA0KIAlpZiAocmV0ICYmICFy
dF9tdXRleF9vd25lcihsb2NrKSkgew0KIAkJLyoNCmRpZmYgLS1naXQgYS9rZXJuZWwvcnRtdXRl
eC5oIGIva2VybmVsL3J0bXV0ZXguaA0KaW5kZXggYTFhMWRkMC4uZjZhMWYzYyAxMDA2NDQNCi0t
LSBhL2tlcm5lbC9ydG11dGV4LmgNCisrKyBiL2tlcm5lbC9ydG11dGV4LmgNCkBAIC0yNCwzICsy
NCw4IEBADQogI2RlZmluZSBkZWJ1Z19ydF9tdXRleF9wcmludF9kZWFkbG9jayh3KQkJZG8geyB9
IHdoaWxlICgwKQ0KICNkZWZpbmUgZGVidWdfcnRfbXV0ZXhfZGV0ZWN0X2RlYWRsb2NrKHcsZCkJ
CShkKQ0KICNkZWZpbmUgZGVidWdfcnRfbXV0ZXhfcmVzZXRfd2FpdGVyKHcpCQkJZG8geyB9IHdo
aWxlICgwKQ0KKw0KK3N0YXRpYyBpbmxpbmUgdm9pZCBydF9tdXRleF9wcmludF9kZWFkbG9jayhz
dHJ1Y3QgcnRfbXV0ZXhfd2FpdGVyICp3KQ0KK3sNCisJV0FSTigxLCAicnRtdXRleCBkZWFkbG9j
ayBkZXRlY3RlZFxuIik7DQorfQ0KZGlmZiAtLWdpdCBhL2xpYi9kZWNvbXByZXNzX3VubHpvLmMg
Yi9saWIvZGVjb21wcmVzc191bmx6by5jDQppbmRleCA1YTdhMmFkLi4yNmY4OWFkIDEwMDY0NA0K
LS0tIGEvbGliL2RlY29tcHJlc3NfdW5sem8uYw0KKysrIGIvbGliL2RlY29tcHJlc3NfdW5sem8u
Yw0KQEAgLTMxLDcgKzMxLDcgQEANCiAgKi8NCiANCiAjaWZkZWYgU1RBVElDDQotI2luY2x1ZGUg
Imx6by9sem8xeF9kZWNvbXByZXNzLmMiDQorI2luY2x1ZGUgImx6by9sem8xeF9kZWNvbXByZXNz
X3NhZmUuYyINCiAjZWxzZQ0KICNpbmNsdWRlIDxsaW51eC9kZWNvbXByZXNzL3VubHpvLmg+DQog
I2VuZGlmDQpkaWZmIC0tZ2l0IGEvbGliL2lkci5jIGIvbGliL2lkci5jDQppbmRleCBhYWRjNTI1
Li4yZDM4NzliIDEwMDY0NA0KLS0tIGEvbGliL2lkci5jDQorKysgYi9saWIvaWRyLmMNCkBAIC0x
NjcsNyArMTY3LDcgQEAgc3RhdGljIGludCBzdWJfYWxsb2Moc3RydWN0IGlkciAqaWRwLCBpbnQg
KnN0YXJ0aW5nX2lkLCBzdHJ1Y3QgaWRyX2xheWVyICoqcGEpDQogCQkJaWQgPSAoaWQgfCAoKDEg
PDwgKElEUl9CSVRTICogbCkpIC0gMSkpICsgMTsNCiANCiAJCQkvKiBpZiBhbHJlYWR5IGF0IHRo
ZSB0b3AgbGF5ZXIsIHdlIG5lZWQgdG8gZ3JvdyAqLw0KLQkJCWlmIChpZCA+PSAxIDw8IChpZHAt
PmxheWVycyAqIElEUl9CSVRTKSkgew0KKwkJCWlmIChpZCA+IGlkcl9tYXgoaWRwLT5sYXllcnMp
KSB7DQogCQkJCSpzdGFydGluZ19pZCA9IGlkOw0KIAkJCQlyZXR1cm4gSURSX05FRURfVE9fR1JP
VzsNCiAJCQl9DQpAQCAtNjcyLDE0ICs2NzIsMTIgQEAgdm9pZCAqaWRyX3JlcGxhY2Uoc3RydWN0
IGlkciAqaWRwLCB2b2lkICpwdHIsIGludCBpZCkNCiAJaWYgKCFwKQ0KIAkJcmV0dXJuIEVSUl9Q
VFIoLUVJTlZBTCk7DQogDQotCW4gPSAocC0+bGF5ZXIrMSkgKiBJRFJfQklUUzsNCi0NCiAJaWQg
Jj0gTUFYX0lEX01BU0s7DQogDQotCWlmIChpZCA+PSAoMSA8PCBuKSkNCisJaWYgKGlkID4gaWRy
X21heChwLT5sYXllciArIDEpKQ0KIAkJcmV0dXJuIEVSUl9QVFIoLUVJTlZBTCk7DQogDQotCW4g
LT0gSURSX0JJVFM7DQorCW4gPSBwLT5sYXllciAqIElEUl9CSVRTOw0KIAl3aGlsZSAoKG4gPiAw
KSAmJiBwKSB7DQogCQlwID0gcC0+YXJ5WyhpZCA+PiBuKSAmIElEUl9NQVNLXTsNCiAJCW4gLT0g
SURSX0JJVFM7DQpkaWZmIC0tZ2l0IGEvbGliL2x6by9NYWtlZmlsZSBiL2xpYi9sem8vTWFrZWZp
bGUNCmluZGV4IGU3NjQxMTYuLmYwZjdkN2MgMTAwNjQ0DQotLS0gYS9saWIvbHpvL01ha2VmaWxl
DQorKysgYi9saWIvbHpvL01ha2VmaWxlDQpAQCAtMSw1ICsxLDUgQEANCiBsem9fY29tcHJlc3Mt
b2JqcyA6PSBsem8xeF9jb21wcmVzcy5vDQotbHpvX2RlY29tcHJlc3Mtb2JqcyA6PSBsem8xeF9k
ZWNvbXByZXNzLm8NCitsem9fZGVjb21wcmVzcy1vYmpzIDo9IGx6bzF4X2RlY29tcHJlc3Nfc2Fm
ZS5vDQogDQogb2JqLSQoQ09ORklHX0xaT19DT01QUkVTUykgKz0gbHpvX2NvbXByZXNzLm8NCiBv
YmotJChDT05GSUdfTFpPX0RFQ09NUFJFU1MpICs9IGx6b19kZWNvbXByZXNzLm8NCmRpZmYgLS1n
aXQgYS9saWIvbHpvL2x6bzF4X2NvbXByZXNzLmMgYi9saWIvbHpvL2x6bzF4X2NvbXByZXNzLmMN
CmluZGV4IGE2MDQwOTkuLjIzNmViMjEgMTAwNjQ0DQotLS0gYS9saWIvbHpvL2x6bzF4X2NvbXBy
ZXNzLmMNCisrKyBiL2xpYi9sem8vbHpvMXhfY29tcHJlc3MuYw0KQEAgLTEsMTk0ICsxLDI0MyBA
QA0KIC8qDQotICogIExaTzFYIENvbXByZXNzb3IgZnJvbSBNaW5pTFpPDQorICogIExaTzFYIENv
bXByZXNzb3IgZnJvbSBMWk8NCiAgKg0KLSAqICBDb3B5cmlnaHQgKEMpIDE5OTYtMjAwNSBNYXJr
dXMgRi5YLkouIE9iZXJodW1lciA8bWFya3VzQG9iZXJodW1lci5jb20+DQorICogIENvcHlyaWdo
dCAoQykgMTk5Ni0yMDEyIE1hcmt1cyBGLlguSi4gT2Jlcmh1bWVyIDxtYXJrdXNAb2Jlcmh1bWVy
LmNvbT4NCiAgKg0KICAqICBUaGUgZnVsbCBMWk8gcGFja2FnZSBjYW4gYmUgZm91bmQgYXQ6DQog
ICogIGh0dHA6Ly93d3cub2Jlcmh1bWVyLmNvbS9vcGVuc291cmNlL2x6by8NCiAgKg0KLSAqICBD
aGFuZ2VkIGZvciBrZXJuZWwgdXNlIGJ5Og0KKyAqICBDaGFuZ2VkIGZvciBMaW51eCBrZXJuZWwg
dXNlIGJ5Og0KICAqICBOaXRpbiBHdXB0YSA8bml0aW5ndXB0YTkxMEBnbWFpbC5jb20+DQogICog
IFJpY2hhcmQgUHVyZGllIDxycHVyZGllQG9wZW5lZGhhbmQuY29tPg0KICAqLw0KIA0KICNpbmNs
dWRlIDxsaW51eC9tb2R1bGUuaD4NCiAjaW5jbHVkZSA8bGludXgva2VybmVsLmg+DQotI2luY2x1
ZGUgPGxpbnV4L2x6by5oPg0KICNpbmNsdWRlIDxhc20vdW5hbGlnbmVkLmg+DQorI2luY2x1ZGUg
PGxpbnV4L2x6by5oPg0KICNpbmNsdWRlICJsem9kZWZzLmgiDQogDQogc3RhdGljIG5vaW5saW5l
IHNpemVfdA0KLV9sem8xeF8xX2RvX2NvbXByZXNzKGNvbnN0IHVuc2lnbmVkIGNoYXIgKmluLCBz
aXplX3QgaW5fbGVuLA0KLQkJdW5zaWduZWQgY2hhciAqb3V0LCBzaXplX3QgKm91dF9sZW4sIHZv
aWQgKndya21lbSkNCitsem8xeF8xX2RvX2NvbXByZXNzKGNvbnN0IHVuc2lnbmVkIGNoYXIgKmlu
LCBzaXplX3QgaW5fbGVuLA0KKwkJICAgIHVuc2lnbmVkIGNoYXIgKm91dCwgc2l6ZV90ICpvdXRf
bGVuLA0KKwkJICAgIHNpemVfdCB0aSwgdm9pZCAqd3JrbWVtKQ0KIHsNCisJY29uc3QgdW5zaWdu
ZWQgY2hhciAqaXA7DQorCXVuc2lnbmVkIGNoYXIgKm9wOw0KIAljb25zdCB1bnNpZ25lZCBjaGFy
ICogY29uc3QgaW5fZW5kID0gaW4gKyBpbl9sZW47DQotCWNvbnN0IHVuc2lnbmVkIGNoYXIgKiBj
b25zdCBpcF9lbmQgPSBpbiArIGluX2xlbiAtIE0yX01BWF9MRU4gLSA1Ow0KLQljb25zdCB1bnNp
Z25lZCBjaGFyICoqIGNvbnN0IGRpY3QgPSB3cmttZW07DQotCWNvbnN0IHVuc2lnbmVkIGNoYXIg
KmlwID0gaW4sICppaSA9IGlwOw0KLQljb25zdCB1bnNpZ25lZCBjaGFyICplbmQsICptLCAqbV9w
b3M7DQotCXNpemVfdCBtX29mZiwgbV9sZW4sIGRpbmRleDsNCi0JdW5zaWduZWQgY2hhciAqb3Ag
PSBvdXQ7DQorCWNvbnN0IHVuc2lnbmVkIGNoYXIgKiBjb25zdCBpcF9lbmQgPSBpbiArIGluX2xl
biAtIDIwOw0KKwljb25zdCB1bnNpZ25lZCBjaGFyICppaTsNCisJbHpvX2RpY3RfdCAqIGNvbnN0
IGRpY3QgPSAobHpvX2RpY3RfdCAqKSB3cmttZW07DQogDQotCWlwICs9IDQ7DQorCW9wID0gb3V0
Ow0KKwlpcCA9IGluOw0KKwlpaSA9IGlwOw0KKwlpcCArPSB0aSA8IDQgPyA0IC0gdGkgOiAwOw0K
IA0KIAlmb3IgKDs7KSB7DQotCQlkaW5kZXggPSAoKHNpemVfdCkoMHgyMSAqIERYMyhpcCwgNSwg
NSwgNikpID4+IDUpICYgRF9NQVNLOw0KLQkJbV9wb3MgPSBkaWN0W2RpbmRleF07DQotDQotCQlp
ZiAobV9wb3MgPCBpbikNCi0JCQlnb3RvIGxpdGVyYWw7DQotDQotCQlpZiAoaXAgPT0gbV9wb3Mg
fHwgKChzaXplX3QpKGlwIC0gbV9wb3MpID4gTTRfTUFYX09GRlNFVCkpDQotCQkJZ290byBsaXRl
cmFsOw0KLQ0KLQkJbV9vZmYgPSBpcCAtIG1fcG9zOw0KLQkJaWYgKG1fb2ZmIDw9IE0yX01BWF9P
RkZTRVQgfHwgbV9wb3NbM10gPT0gaXBbM10pDQotCQkJZ290byB0cnlfbWF0Y2g7DQotDQotCQlk
aW5kZXggPSAoZGluZGV4ICYgKERfTUFTSyAmIDB4N2ZmKSkgXiAoRF9ISUdIIHwgMHgxZik7DQot
CQltX3BvcyA9IGRpY3RbZGluZGV4XTsNCi0NCi0JCWlmIChtX3BvcyA8IGluKQ0KLQkJCWdvdG8g
bGl0ZXJhbDsNCi0NCi0JCWlmIChpcCA9PSBtX3BvcyB8fCAoKHNpemVfdCkoaXAgLSBtX3Bvcykg
PiBNNF9NQVhfT0ZGU0VUKSkNCi0JCQlnb3RvIGxpdGVyYWw7DQotDQotCQltX29mZiA9IGlwIC0g
bV9wb3M7DQotCQlpZiAobV9vZmYgPD0gTTJfTUFYX09GRlNFVCB8fCBtX3Bvc1szXSA9PSBpcFsz
XSkNCi0JCQlnb3RvIHRyeV9tYXRjaDsNCi0NCi0JCWdvdG8gbGl0ZXJhbDsNCi0NCi10cnlfbWF0
Y2g6DQotCQlpZiAoZ2V0X3VuYWxpZ25lZCgoY29uc3QgdW5zaWduZWQgc2hvcnQgKiltX3BvcykN
Ci0JCQkJPT0gZ2V0X3VuYWxpZ25lZCgoY29uc3QgdW5zaWduZWQgc2hvcnQgKilpcCkpIHsNCi0J
CQlpZiAobGlrZWx5KG1fcG9zWzJdID09IGlwWzJdKSkNCi0JCQkJCWdvdG8gbWF0Y2g7DQotCQl9
DQotDQorCQljb25zdCB1bnNpZ25lZCBjaGFyICptX3BvczsNCisJCXNpemVfdCB0LCBtX2xlbiwg
bV9vZmY7DQorCQl1MzIgZHY7DQogbGl0ZXJhbDoNCi0JCWRpY3RbZGluZGV4XSA9IGlwOw0KLQkJ
KytpcDsNCisJCWlwICs9IDEgKyAoKGlwIC0gaWkpID4+IDUpOw0KK25leHQ6DQogCQlpZiAodW5s
aWtlbHkoaXAgPj0gaXBfZW5kKSkNCiAJCQlicmVhazsNCi0JCWNvbnRpbnVlOw0KLQ0KLW1hdGNo
Og0KLQkJZGljdFtkaW5kZXhdID0gaXA7DQotCQlpZiAoaXAgIT0gaWkpIHsNCi0JCQlzaXplX3Qg
dCA9IGlwIC0gaWk7DQorCQlkdiA9IGdldF91bmFsaWduZWRfbGUzMihpcCk7DQorCQl0ID0gKChk
diAqIDB4MTgyNDQyOWQpID4+ICgzMiAtIERfQklUUykpICYgRF9NQVNLOw0KKwkJbV9wb3MgPSBp
biArIGRpY3RbdF07DQorCQlkaWN0W3RdID0gKGx6b19kaWN0X3QpIChpcCAtIGluKTsNCisJCWlm
ICh1bmxpa2VseShkdiAhPSBnZXRfdW5hbGlnbmVkX2xlMzIobV9wb3MpKSkNCisJCQlnb3RvIGxp
dGVyYWw7DQogDQorCQlpaSAtPSB0aTsNCisJCXRpID0gMDsNCisJCXQgPSBpcCAtIGlpOw0KKwkJ
aWYgKHQgIT0gMCkgew0KIAkJCWlmICh0IDw9IDMpIHsNCiAJCQkJb3BbLTJdIHw9IHQ7DQotCQkJ
fSBlbHNlIGlmICh0IDw9IDE4KSB7DQorCQkJCUNPUFk0KG9wLCBpaSk7DQorCQkJCW9wICs9IHQ7
DQorCQkJfSBlbHNlIGlmICh0IDw9IDE2KSB7DQogCQkJCSpvcCsrID0gKHQgLSAzKTsNCisJCQkJ
Q09QWTgob3AsIGlpKTsNCisJCQkJQ09QWTgob3AgKyA4LCBpaSArIDgpOw0KKwkJCQlvcCArPSB0
Ow0KIAkJCX0gZWxzZSB7DQotCQkJCXNpemVfdCB0dCA9IHQgLSAxODsNCi0NCi0JCQkJKm9wKysg
PSAwOw0KLQkJCQl3aGlsZSAodHQgPiAyNTUpIHsNCi0JCQkJCXR0IC09IDI1NTsNCisJCQkJaWYg
KHQgPD0gMTgpIHsNCisJCQkJCSpvcCsrID0gKHQgLSAzKTsNCisJCQkJfSBlbHNlIHsNCisJCQkJ
CXNpemVfdCB0dCA9IHQgLSAxODsNCiAJCQkJCSpvcCsrID0gMDsNCisJCQkJCXdoaWxlICh1bmxp
a2VseSh0dCA+IDI1NSkpIHsNCisJCQkJCQl0dCAtPSAyNTU7DQorCQkJCQkJKm9wKysgPSAwOw0K
KwkJCQkJfQ0KKwkJCQkJKm9wKysgPSB0dDsNCiAJCQkJfQ0KLQkJCQkqb3ArKyA9IHR0Ow0KKwkJ
CQlkbyB7DQorCQkJCQlDT1BZOChvcCwgaWkpOw0KKwkJCQkJQ09QWTgob3AgKyA4LCBpaSArIDgp
Ow0KKwkJCQkJb3AgKz0gMTY7DQorCQkJCQlpaSArPSAxNjsNCisJCQkJCXQgLT0gMTY7DQorCQkJ
CX0gd2hpbGUgKHQgPj0gMTYpOw0KKwkJCQlpZiAodCA+IDApIGRvIHsNCisJCQkJCSpvcCsrID0g
KmlpKys7DQorCQkJCX0gd2hpbGUgKC0tdCA+IDApOw0KIAkJCX0NCi0JCQlkbyB7DQotCQkJCSpv
cCsrID0gKmlpKys7DQotCQkJfSB3aGlsZSAoLS10ID4gMCk7DQogCQl9DQogDQotCQlpcCArPSAz
Ow0KLQkJaWYgKG1fcG9zWzNdICE9ICppcCsrIHx8IG1fcG9zWzRdICE9ICppcCsrDQotCQkJCXx8
IG1fcG9zWzVdICE9ICppcCsrIHx8IG1fcG9zWzZdICE9ICppcCsrDQotCQkJCXx8IG1fcG9zWzdd
ICE9ICppcCsrIHx8IG1fcG9zWzhdICE9ICppcCsrKSB7DQotCQkJLS1pcDsNCi0JCQltX2xlbiA9
IGlwIC0gaWk7DQorCQltX2xlbiA9IDQ7DQorCQl7DQorI2lmIGRlZmluZWQoQ09ORklHX0hBVkVf
RUZGSUNJRU5UX1VOQUxJR05FRF9BQ0NFU1MpICYmIGRlZmluZWQoTFpPX1VTRV9DVFo2NCkNCisJ
CXU2NCB2Ow0KKwkJdiA9IGdldF91bmFsaWduZWQoKGNvbnN0IHU2NCAqKSAoaXAgKyBtX2xlbikp
IF4NCisJCSAgICBnZXRfdW5hbGlnbmVkKChjb25zdCB1NjQgKikgKG1fcG9zICsgbV9sZW4pKTsN
CisJCWlmICh1bmxpa2VseSh2ID09IDApKSB7DQorCQkJZG8gew0KKwkJCQltX2xlbiArPSA4Ow0K
KwkJCQl2ID0gZ2V0X3VuYWxpZ25lZCgoY29uc3QgdTY0ICopIChpcCArIG1fbGVuKSkgXg0KKwkJ
CQkgICAgZ2V0X3VuYWxpZ25lZCgoY29uc3QgdTY0ICopIChtX3BvcyArIG1fbGVuKSk7DQorCQkJ
CWlmICh1bmxpa2VseShpcCArIG1fbGVuID49IGlwX2VuZCkpDQorCQkJCQlnb3RvIG1fbGVuX2Rv
bmU7DQorCQkJfSB3aGlsZSAodiA9PSAwKTsNCisJCX0NCisjICBpZiBkZWZpbmVkKF9fTElUVExF
X0VORElBTikNCisJCW1fbGVuICs9ICh1bnNpZ25lZCkgX19idWlsdGluX2N0emxsKHYpIC8gODsN
CisjICBlbGlmIGRlZmluZWQoX19CSUdfRU5ESUFOKQ0KKwkJbV9sZW4gKz0gKHVuc2lnbmVkKSBf
X2J1aWx0aW5fY2x6bGwodikgLyA4Ow0KKyMgIGVsc2UNCisjICAgIGVycm9yICJtaXNzaW5nIGVu
ZGlhbiBkZWZpbml0aW9uIg0KKyMgIGVuZGlmDQorI2VsaWYgZGVmaW5lZChDT05GSUdfSEFWRV9F
RkZJQ0lFTlRfVU5BTElHTkVEX0FDQ0VTUykgJiYgZGVmaW5lZChMWk9fVVNFX0NUWjMyKQ0KKwkJ
dTMyIHY7DQorCQl2ID0gZ2V0X3VuYWxpZ25lZCgoY29uc3QgdTMyICopIChpcCArIG1fbGVuKSkg
Xg0KKwkJICAgIGdldF91bmFsaWduZWQoKGNvbnN0IHUzMiAqKSAobV9wb3MgKyBtX2xlbikpOw0K
KwkJaWYgKHVubGlrZWx5KHYgPT0gMCkpIHsNCisJCQlkbyB7DQorCQkJCW1fbGVuICs9IDQ7DQor
CQkJCXYgPSBnZXRfdW5hbGlnbmVkKChjb25zdCB1MzIgKikgKGlwICsgbV9sZW4pKSBeDQorCQkJ
CSAgICBnZXRfdW5hbGlnbmVkKChjb25zdCB1MzIgKikgKG1fcG9zICsgbV9sZW4pKTsNCisJCQkJ
aWYgKHYgIT0gMCkNCisJCQkJCWJyZWFrOw0KKwkJCQltX2xlbiArPSA0Ow0KKwkJCQl2ID0gZ2V0
X3VuYWxpZ25lZCgoY29uc3QgdTMyICopIChpcCArIG1fbGVuKSkgXg0KKwkJCQkgICAgZ2V0X3Vu
YWxpZ25lZCgoY29uc3QgdTMyICopIChtX3BvcyArIG1fbGVuKSk7DQorCQkJCWlmICh1bmxpa2Vs
eShpcCArIG1fbGVuID49IGlwX2VuZCkpDQorCQkJCQlnb3RvIG1fbGVuX2RvbmU7DQorCQkJfSB3
aGlsZSAodiA9PSAwKTsNCisJCX0NCisjICBpZiBkZWZpbmVkKF9fTElUVExFX0VORElBTikNCisJ
CW1fbGVuICs9ICh1bnNpZ25lZCkgX19idWlsdGluX2N0eih2KSAvIDg7DQorIyAgZWxpZiBkZWZp
bmVkKF9fQklHX0VORElBTikNCisJCW1fbGVuICs9ICh1bnNpZ25lZCkgX19idWlsdGluX2Nseih2
KSAvIDg7DQorIyAgZWxzZQ0KKyMgICAgZXJyb3IgIm1pc3NpbmcgZW5kaWFuIGRlZmluaXRpb24i
DQorIyAgZW5kaWYNCisjZWxzZQ0KKwkJaWYgKHVubGlrZWx5KGlwW21fbGVuXSA9PSBtX3Bvc1tt
X2xlbl0pKSB7DQorCQkJZG8gew0KKwkJCQltX2xlbiArPSAxOw0KKwkJCQlpZiAoaXBbbV9sZW5d
ICE9IG1fcG9zW21fbGVuXSkNCisJCQkJCWJyZWFrOw0KKwkJCQltX2xlbiArPSAxOw0KKwkJCQlp
ZiAoaXBbbV9sZW5dICE9IG1fcG9zW21fbGVuXSkNCisJCQkJCWJyZWFrOw0KKwkJCQltX2xlbiAr
PSAxOw0KKwkJCQlpZiAoaXBbbV9sZW5dICE9IG1fcG9zW21fbGVuXSkNCisJCQkJCWJyZWFrOw0K
KwkJCQltX2xlbiArPSAxOw0KKwkJCQlpZiAoaXBbbV9sZW5dICE9IG1fcG9zW21fbGVuXSkNCisJ
CQkJCWJyZWFrOw0KKwkJCQltX2xlbiArPSAxOw0KKwkJCQlpZiAoaXBbbV9sZW5dICE9IG1fcG9z
W21fbGVuXSkNCisJCQkJCWJyZWFrOw0KKwkJCQltX2xlbiArPSAxOw0KKwkJCQlpZiAoaXBbbV9s
ZW5dICE9IG1fcG9zW21fbGVuXSkNCisJCQkJCWJyZWFrOw0KKwkJCQltX2xlbiArPSAxOw0KKwkJ
CQlpZiAoaXBbbV9sZW5dICE9IG1fcG9zW21fbGVuXSkNCisJCQkJCWJyZWFrOw0KKwkJCQltX2xl
biArPSAxOw0KKwkJCQlpZiAodW5saWtlbHkoaXAgKyBtX2xlbiA+PSBpcF9lbmQpKQ0KKwkJCQkJ
Z290byBtX2xlbl9kb25lOw0KKwkJCX0gd2hpbGUgKGlwW21fbGVuXSA9PSBtX3Bvc1ttX2xlbl0p
Ow0KKwkJfQ0KKyNlbmRpZg0KKwkJfQ0KK21fbGVuX2RvbmU6DQogDQotCQkJaWYgKG1fb2ZmIDw9
IE0yX01BWF9PRkZTRVQpIHsNCi0JCQkJbV9vZmYgLT0gMTsNCi0JCQkJKm9wKysgPSAoKChtX2xl
biAtIDEpIDw8IDUpDQotCQkJCQkJfCAoKG1fb2ZmICYgNykgPDwgMikpOw0KLQkJCQkqb3ArKyA9
IChtX29mZiA+PiAzKTsNCi0JCQl9IGVsc2UgaWYgKG1fb2ZmIDw9IE0zX01BWF9PRkZTRVQpIHsN
Ci0JCQkJbV9vZmYgLT0gMTsNCisJCW1fb2ZmID0gaXAgLSBtX3BvczsNCisJCWlwICs9IG1fbGVu
Ow0KKwkJaWkgPSBpcDsNCisJCWlmIChtX2xlbiA8PSBNMl9NQVhfTEVOICYmIG1fb2ZmIDw9IE0y
X01BWF9PRkZTRVQpIHsNCisJCQltX29mZiAtPSAxOw0KKwkJCSpvcCsrID0gKCgobV9sZW4gLSAx
KSA8PCA1KSB8ICgobV9vZmYgJiA3KSA8PCAyKSk7DQorCQkJKm9wKysgPSAobV9vZmYgPj4gMyk7
DQorCQl9IGVsc2UgaWYgKG1fb2ZmIDw9IE0zX01BWF9PRkZTRVQpIHsNCisJCQltX29mZiAtPSAx
Ow0KKwkJCWlmIChtX2xlbiA8PSBNM19NQVhfTEVOKQ0KIAkJCQkqb3ArKyA9IChNM19NQVJLRVIg
fCAobV9sZW4gLSAyKSk7DQotCQkJCWdvdG8gbTNfbTRfb2Zmc2V0Ow0KLQkJCX0gZWxzZSB7DQot
CQkJCW1fb2ZmIC09IDB4NDAwMDsNCi0NCi0JCQkJKm9wKysgPSAoTTRfTUFSS0VSIHwgKChtX29m
ZiAmIDB4NDAwMCkgPj4gMTEpDQotCQkJCQkJfCAobV9sZW4gLSAyKSk7DQotCQkJCWdvdG8gbTNf
bTRfb2Zmc2V0Ow0KKwkJCWVsc2Ugew0KKwkJCQltX2xlbiAtPSBNM19NQVhfTEVOOw0KKwkJCQkq
b3ArKyA9IE0zX01BUktFUiB8IDA7DQorCQkJCXdoaWxlICh1bmxpa2VseShtX2xlbiA+IDI1NSkp
IHsNCisJCQkJCW1fbGVuIC09IDI1NTsNCisJCQkJCSpvcCsrID0gMDsNCisJCQkJfQ0KKwkJCQkq
b3ArKyA9IChtX2xlbik7DQogCQkJfQ0KKwkJCSpvcCsrID0gKG1fb2ZmIDw8IDIpOw0KKwkJCSpv
cCsrID0gKG1fb2ZmID4+IDYpOw0KIAkJfSBlbHNlIHsNCi0JCQllbmQgPSBpbl9lbmQ7DQotCQkJ
bSA9IG1fcG9zICsgTTJfTUFYX0xFTiArIDE7DQotDQotCQkJd2hpbGUgKGlwIDwgZW5kICYmICpt
ID09ICppcCkgew0KLQkJCQltKys7DQotCQkJCWlwKys7DQotCQkJfQ0KLQkJCW1fbGVuID0gaXAg
LSBpaTsNCi0NCi0JCQlpZiAobV9vZmYgPD0gTTNfTUFYX09GRlNFVCkgew0KLQkJCQltX29mZiAt
PSAxOw0KLQkJCQlpZiAobV9sZW4gPD0gMzMpIHsNCi0JCQkJCSpvcCsrID0gKE0zX01BUktFUiB8
IChtX2xlbiAtIDIpKTsNCi0JCQkJfSBlbHNlIHsNCi0JCQkJCW1fbGVuIC09IDMzOw0KLQkJCQkJ
Km9wKysgPSBNM19NQVJLRVIgfCAwOw0KLQkJCQkJZ290byBtM19tNF9sZW47DQotCQkJCX0NCi0J
CQl9IGVsc2Ugew0KLQkJCQltX29mZiAtPSAweDQwMDA7DQotCQkJCWlmIChtX2xlbiA8PSBNNF9N
QVhfTEVOKSB7DQotCQkJCQkqb3ArKyA9IChNNF9NQVJLRVINCi0JCQkJCQl8ICgobV9vZmYgJiAw
eDQwMDApID4+IDExKQ0KKwkJCW1fb2ZmIC09IDB4NDAwMDsNCisJCQlpZiAobV9sZW4gPD0gTTRf
TUFYX0xFTikNCisJCQkJKm9wKysgPSAoTTRfTUFSS0VSIHwgKChtX29mZiA+PiAxMSkgJiA4KQ0K
IAkJCQkJCXwgKG1fbGVuIC0gMikpOw0KLQkJCQl9IGVsc2Ugew0KLQkJCQkJbV9sZW4gLT0gTTRf
TUFYX0xFTjsNCi0JCQkJCSpvcCsrID0gKE00X01BUktFUg0KLQkJCQkJCXwgKChtX29mZiAmIDB4
NDAwMCkgPj4gMTEpKTsNCi1tM19tNF9sZW46DQotCQkJCQl3aGlsZSAobV9sZW4gPiAyNTUpIHsN
Ci0JCQkJCQltX2xlbiAtPSAyNTU7DQotCQkJCQkJKm9wKysgPSAwOw0KLQkJCQkJfQ0KLQ0KLQkJ
CQkJKm9wKysgPSAobV9sZW4pOw0KKwkJCWVsc2Ugew0KKwkJCQltX2xlbiAtPSBNNF9NQVhfTEVO
Ow0KKwkJCQkqb3ArKyA9IChNNF9NQVJLRVIgfCAoKG1fb2ZmID4+IDExKSAmIDgpKTsNCisJCQkJ
d2hpbGUgKHVubGlrZWx5KG1fbGVuID4gMjU1KSkgew0KKwkJCQkJbV9sZW4gLT0gMjU1Ow0KKwkJ
CQkJKm9wKysgPSAwOw0KIAkJCQl9DQorCQkJCSpvcCsrID0gKG1fbGVuKTsNCiAJCQl9DQotbTNf
bTRfb2Zmc2V0Og0KLQkJCSpvcCsrID0gKChtX29mZiAmIDYzKSA8PCAyKTsNCisJCQkqb3ArKyA9
IChtX29mZiA8PCAyKTsNCiAJCQkqb3ArKyA9IChtX29mZiA+PiA2KTsNCiAJCX0NCi0NCi0JCWlp
ID0gaXA7DQotCQlpZiAodW5saWtlbHkoaXAgPj0gaXBfZW5kKSkNCi0JCQlicmVhazsNCisJCWdv
dG8gbmV4dDsNCiAJfQ0KLQ0KIAkqb3V0X2xlbiA9IG9wIC0gb3V0Ow0KLQlyZXR1cm4gaW5fZW5k
IC0gaWk7DQorCXJldHVybiBpbl9lbmQgLSAoaWkgLSB0aSk7DQogfQ0KIA0KLWludCBsem8xeF8x
X2NvbXByZXNzKGNvbnN0IHVuc2lnbmVkIGNoYXIgKmluLCBzaXplX3QgaW5fbGVuLCB1bnNpZ25l
ZCBjaGFyICpvdXQsDQotCQkJc2l6ZV90ICpvdXRfbGVuLCB2b2lkICp3cmttZW0pDQoraW50IGx6
bzF4XzFfY29tcHJlc3MoY29uc3QgdW5zaWduZWQgY2hhciAqaW4sIHNpemVfdCBpbl9sZW4sDQor
CQkgICAgIHVuc2lnbmVkIGNoYXIgKm91dCwgc2l6ZV90ICpvdXRfbGVuLA0KKwkJICAgICB2b2lk
ICp3cmttZW0pDQogew0KLQljb25zdCB1bnNpZ25lZCBjaGFyICppaTsNCisJY29uc3QgdW5zaWdu
ZWQgY2hhciAqaXAgPSBpbjsNCiAJdW5zaWduZWQgY2hhciAqb3AgPSBvdXQ7DQotCXNpemVfdCB0
Ow0KKwlzaXplX3QgbCA9IGluX2xlbjsNCisJc2l6ZV90IHQgPSAwOw0KIA0KLQlpZiAodW5saWtl
bHkoaW5fbGVuIDw9IE0yX01BWF9MRU4gKyA1KSkgew0KLQkJdCA9IGluX2xlbjsNCi0JfSBlbHNl
IHsNCi0JCXQgPSBfbHpvMXhfMV9kb19jb21wcmVzcyhpbiwgaW5fbGVuLCBvcCwgb3V0X2xlbiwg
d3JrbWVtKTsNCisJd2hpbGUgKGwgPiAyMCkgew0KKwkJc2l6ZV90IGxsID0gbCA8PSAoTTRfTUFY
X09GRlNFVCArIDEpID8gbCA6IChNNF9NQVhfT0ZGU0VUICsgMSk7DQorCQl1aW50cHRyX3QgbGxf
ZW5kID0gKHVpbnRwdHJfdCkgaXAgKyBsbDsNCisJCWlmICgobGxfZW5kICsgKCh0ICsgbGwpID4+
IDUpKSA8PSBsbF9lbmQpDQorCQkJYnJlYWs7DQorCQlCVUlMRF9CVUdfT04oRF9TSVpFICogc2l6
ZW9mKGx6b19kaWN0X3QpID4gTFpPMVhfMV9NRU1fQ09NUFJFU1MpOw0KKwkJbWVtc2V0KHdya21l
bSwgMCwgRF9TSVpFICogc2l6ZW9mKGx6b19kaWN0X3QpKTsNCisJCXQgPSBsem8xeF8xX2RvX2Nv
bXByZXNzKGlwLCBsbCwgb3AsIG91dF9sZW4sIHQsIHdya21lbSk7DQorCQlpcCArPSBsbDsNCiAJ
CW9wICs9ICpvdXRfbGVuOw0KKwkJbCAgLT0gbGw7DQogCX0NCisJdCArPSBsOw0KIA0KIAlpZiAo
dCA+IDApIHsNCi0JCWlpID0gaW4gKyBpbl9sZW4gLSB0Ow0KKwkJY29uc3QgdW5zaWduZWQgY2hh
ciAqaWkgPSBpbiArIGluX2xlbiAtIHQ7DQogDQogCQlpZiAob3AgPT0gb3V0ICYmIHQgPD0gMjM4
KSB7DQogCQkJKm9wKysgPSAoMTcgKyB0KTsNCkBAIC0xOTgsMTYgKzI0NywyMSBAQCBpbnQgbHpv
MXhfMV9jb21wcmVzcyhjb25zdCB1bnNpZ25lZCBjaGFyICppbiwgc2l6ZV90IGluX2xlbiwgdW5z
aWduZWQgY2hhciAqb3V0LA0KIAkJCSpvcCsrID0gKHQgLSAzKTsNCiAJCX0gZWxzZSB7DQogCQkJ
c2l6ZV90IHR0ID0gdCAtIDE4Ow0KLQ0KIAkJCSpvcCsrID0gMDsNCiAJCQl3aGlsZSAodHQgPiAy
NTUpIHsNCiAJCQkJdHQgLT0gMjU1Ow0KIAkJCQkqb3ArKyA9IDA7DQogCQkJfQ0KLQ0KIAkJCSpv
cCsrID0gdHQ7DQogCQl9DQotCQlkbyB7DQorCQlpZiAodCA+PSAxNikgZG8gew0KKwkJCUNPUFk4
KG9wLCBpaSk7DQorCQkJQ09QWTgob3AgKyA4LCBpaSArIDgpOw0KKwkJCW9wICs9IDE2Ow0KKwkJ
CWlpICs9IDE2Ow0KKwkJCXQgLT0gMTY7DQorCQl9IHdoaWxlICh0ID49IDE2KTsNCisJCWlmICh0
ID4gMCkgZG8gew0KIAkJCSpvcCsrID0gKmlpKys7DQogCQl9IHdoaWxlICgtLXQgPiAwKTsNCiAJ
fQ0KQEAgLTIyMyw0ICsyNzcsMyBAQCBFWFBPUlRfU1lNQk9MX0dQTChsem8xeF8xX2NvbXByZXNz
KTsNCiANCiBNT0RVTEVfTElDRU5TRSgiR1BMIik7DQogTU9EVUxFX0RFU0NSSVBUSU9OKCJMWk8x
WC0xIENvbXByZXNzb3IiKTsNCi0NCmRpZmYgLS1naXQgYS9saWIvbHpvL2x6bzF4X2RlY29tcHJl
c3MuYyBiL2xpYi9sem8vbHpvMXhfZGVjb21wcmVzcy5jDQpkZWxldGVkIGZpbGUgbW9kZSAxMDA2
NDQNCmluZGV4IGYyZmQwOTguLjAwMDAwMDANCi0tLSBhL2xpYi9sem8vbHpvMXhfZGVjb21wcmVz
cy5jDQorKysgL2Rldi9udWxsDQpAQCAtMSwyNTUgKzAsMCBAQA0KLS8qDQotICogIExaTzFYIERl
Y29tcHJlc3NvciBmcm9tIE1pbmlMWk8NCi0gKg0KLSAqICBDb3B5cmlnaHQgKEMpIDE5OTYtMjAw
NSBNYXJrdXMgRi5YLkouIE9iZXJodW1lciA8bWFya3VzQG9iZXJodW1lci5jb20+DQotICoNCi0g
KiAgVGhlIGZ1bGwgTFpPIHBhY2thZ2UgY2FuIGJlIGZvdW5kIGF0Og0KLSAqICBodHRwOi8vd3d3
Lm9iZXJodW1lci5jb20vb3BlbnNvdXJjZS9sem8vDQotICoNCi0gKiAgQ2hhbmdlZCBmb3Iga2Vy
bmVsIHVzZSBieToNCi0gKiAgTml0aW4gR3VwdGEgPG5pdGluZ3VwdGE5MTBAZ21haWwuY29tPg0K
LSAqICBSaWNoYXJkIFB1cmRpZSA8cnB1cmRpZUBvcGVuZWRoYW5kLmNvbT4NCi0gKi8NCi0NCi0j
aWZuZGVmIFNUQVRJQw0KLSNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4NCi0jaW5jbHVkZSA8bGlu
dXgva2VybmVsLmg+DQotI2VuZGlmDQotDQotI2luY2x1ZGUgPGFzbS91bmFsaWduZWQuaD4NCi0j
aW5jbHVkZSA8bGludXgvbHpvLmg+DQotI2luY2x1ZGUgImx6b2RlZnMuaCINCi0NCi0jZGVmaW5l
IEhBVkVfSVAoeCwgaXBfZW5kLCBpcCkgKChzaXplX3QpKGlwX2VuZCAtIGlwKSA8ICh4KSkNCi0j
ZGVmaW5lIEhBVkVfT1AoeCwgb3BfZW5kLCBvcCkgKChzaXplX3QpKG9wX2VuZCAtIG9wKSA8ICh4
KSkNCi0jZGVmaW5lIEhBVkVfTEIobV9wb3MsIG91dCwgb3ApIChtX3BvcyA8IG91dCB8fCBtX3Bv
cyA+PSBvcCkNCi0NCi0jZGVmaW5lIENPUFk0KGRzdCwgc3JjKQlcDQotCQlwdXRfdW5hbGlnbmVk
KGdldF91bmFsaWduZWQoKGNvbnN0IHUzMiAqKShzcmMpKSwgKHUzMiAqKShkc3QpKQ0KLQ0KLWlu
dCBsem8xeF9kZWNvbXByZXNzX3NhZmUoY29uc3QgdW5zaWduZWQgY2hhciAqaW4sIHNpemVfdCBp
bl9sZW4sDQotCQkJdW5zaWduZWQgY2hhciAqb3V0LCBzaXplX3QgKm91dF9sZW4pDQotew0KLQlj
b25zdCB1bnNpZ25lZCBjaGFyICogY29uc3QgaXBfZW5kID0gaW4gKyBpbl9sZW47DQotCXVuc2ln
bmVkIGNoYXIgKiBjb25zdCBvcF9lbmQgPSBvdXQgKyAqb3V0X2xlbjsNCi0JY29uc3QgdW5zaWdu
ZWQgY2hhciAqaXAgPSBpbiwgKm1fcG9zOw0KLQl1bnNpZ25lZCBjaGFyICpvcCA9IG91dDsNCi0J
c2l6ZV90IHQ7DQotDQotCSpvdXRfbGVuID0gMDsNCi0NCi0JaWYgKCppcCA+IDE3KSB7DQotCQl0
ID0gKmlwKysgLSAxNzsNCi0JCWlmICh0IDwgNCkNCi0JCQlnb3RvIG1hdGNoX25leHQ7DQotCQlp
ZiAoSEFWRV9PUCh0LCBvcF9lbmQsIG9wKSkNCi0JCQlnb3RvIG91dHB1dF9vdmVycnVuOw0KLQkJ
aWYgKEhBVkVfSVAodCArIDEsIGlwX2VuZCwgaXApKQ0KLQkJCWdvdG8gaW5wdXRfb3ZlcnJ1bjsN
Ci0JCWRvIHsNCi0JCQkqb3ArKyA9ICppcCsrOw0KLQkJfSB3aGlsZSAoLS10ID4gMCk7DQotCQln
b3RvIGZpcnN0X2xpdGVyYWxfcnVuOw0KLQl9DQotDQotCXdoaWxlICgoaXAgPCBpcF9lbmQpKSB7
DQotCQl0ID0gKmlwKys7DQotCQlpZiAodCA+PSAxNikNCi0JCQlnb3RvIG1hdGNoOw0KLQkJaWYg
KHQgPT0gMCkgew0KLQkJCWlmIChIQVZFX0lQKDEsIGlwX2VuZCwgaXApKQ0KLQkJCQlnb3RvIGlu
cHV0X292ZXJydW47DQotCQkJd2hpbGUgKCppcCA9PSAwKSB7DQotCQkJCXQgKz0gMjU1Ow0KLQkJ
CQlpcCsrOw0KLQkJCQlpZiAoSEFWRV9JUCgxLCBpcF9lbmQsIGlwKSkNCi0JCQkJCWdvdG8gaW5w
dXRfb3ZlcnJ1bjsNCi0JCQl9DQotCQkJdCArPSAxNSArICppcCsrOw0KLQkJfQ0KLQkJaWYgKEhB
VkVfT1AodCArIDMsIG9wX2VuZCwgb3ApKQ0KLQkJCWdvdG8gb3V0cHV0X292ZXJydW47DQotCQlp
ZiAoSEFWRV9JUCh0ICsgNCwgaXBfZW5kLCBpcCkpDQotCQkJZ290byBpbnB1dF9vdmVycnVuOw0K
LQ0KLQkJQ09QWTQob3AsIGlwKTsNCi0JCW9wICs9IDQ7DQotCQlpcCArPSA0Ow0KLQkJaWYgKC0t
dCA+IDApIHsNCi0JCQlpZiAodCA+PSA0KSB7DQotCQkJCWRvIHsNCi0JCQkJCUNPUFk0KG9wLCBp
cCk7DQotCQkJCQlvcCArPSA0Ow0KLQkJCQkJaXAgKz0gNDsNCi0JCQkJCXQgLT0gNDsNCi0JCQkJ
fSB3aGlsZSAodCA+PSA0KTsNCi0JCQkJaWYgKHQgPiAwKSB7DQotCQkJCQlkbyB7DQotCQkJCQkJ
Km9wKysgPSAqaXArKzsNCi0JCQkJCX0gd2hpbGUgKC0tdCA+IDApOw0KLQkJCQl9DQotCQkJfSBl
bHNlIHsNCi0JCQkJZG8gew0KLQkJCQkJKm9wKysgPSAqaXArKzsNCi0JCQkJfSB3aGlsZSAoLS10
ID4gMCk7DQotCQkJfQ0KLQkJfQ0KLQ0KLWZpcnN0X2xpdGVyYWxfcnVuOg0KLQkJdCA9ICppcCsr
Ow0KLQkJaWYgKHQgPj0gMTYpDQotCQkJZ290byBtYXRjaDsNCi0JCW1fcG9zID0gb3AgLSAoMSAr
IE0yX01BWF9PRkZTRVQpOw0KLQkJbV9wb3MgLT0gdCA+PiAyOw0KLQkJbV9wb3MgLT0gKmlwKysg
PDwgMjsNCi0NCi0JCWlmIChIQVZFX0xCKG1fcG9zLCBvdXQsIG9wKSkNCi0JCQlnb3RvIGxvb2ti
ZWhpbmRfb3ZlcnJ1bjsNCi0NCi0JCWlmIChIQVZFX09QKDMsIG9wX2VuZCwgb3ApKQ0KLQkJCWdv
dG8gb3V0cHV0X292ZXJydW47DQotCQkqb3ArKyA9ICptX3BvcysrOw0KLQkJKm9wKysgPSAqbV9w
b3MrKzsNCi0JCSpvcCsrID0gKm1fcG9zOw0KLQ0KLQkJZ290byBtYXRjaF9kb25lOw0KLQ0KLQkJ
ZG8gew0KLW1hdGNoOg0KLQkJCWlmICh0ID49IDY0KSB7DQotCQkJCW1fcG9zID0gb3AgLSAxOw0K
LQkJCQltX3BvcyAtPSAodCA+PiAyKSAmIDc7DQotCQkJCW1fcG9zIC09ICppcCsrIDw8IDM7DQot
CQkJCXQgPSAodCA+PiA1KSAtIDE7DQotCQkJCWlmIChIQVZFX0xCKG1fcG9zLCBvdXQsIG9wKSkN
Ci0JCQkJCWdvdG8gbG9va2JlaGluZF9vdmVycnVuOw0KLQkJCQlpZiAoSEFWRV9PUCh0ICsgMyAt
IDEsIG9wX2VuZCwgb3ApKQ0KLQkJCQkJZ290byBvdXRwdXRfb3ZlcnJ1bjsNCi0JCQkJZ290byBj
b3B5X21hdGNoOw0KLQkJCX0gZWxzZSBpZiAodCA+PSAzMikgew0KLQkJCQl0ICY9IDMxOw0KLQkJ
CQlpZiAodCA9PSAwKSB7DQotCQkJCQlpZiAoSEFWRV9JUCgxLCBpcF9lbmQsIGlwKSkNCi0JCQkJ
CQlnb3RvIGlucHV0X292ZXJydW47DQotCQkJCQl3aGlsZSAoKmlwID09IDApIHsNCi0JCQkJCQl0
ICs9IDI1NTsNCi0JCQkJCQlpcCsrOw0KLQkJCQkJCWlmIChIQVZFX0lQKDEsIGlwX2VuZCwgaXAp
KQ0KLQkJCQkJCQlnb3RvIGlucHV0X292ZXJydW47DQotCQkJCQl9DQotCQkJCQl0ICs9IDMxICsg
KmlwKys7DQotCQkJCX0NCi0JCQkJbV9wb3MgPSBvcCAtIDE7DQotCQkJCW1fcG9zIC09IGdldF91
bmFsaWduZWRfbGUxNihpcCkgPj4gMjsNCi0JCQkJaXAgKz0gMjsNCi0JCQl9IGVsc2UgaWYgKHQg
Pj0gMTYpIHsNCi0JCQkJbV9wb3MgPSBvcDsNCi0JCQkJbV9wb3MgLT0gKHQgJiA4KSA8PCAxMTsN
Ci0NCi0JCQkJdCAmPSA3Ow0KLQkJCQlpZiAodCA9PSAwKSB7DQotCQkJCQlpZiAoSEFWRV9JUCgx
LCBpcF9lbmQsIGlwKSkNCi0JCQkJCQlnb3RvIGlucHV0X292ZXJydW47DQotCQkJCQl3aGlsZSAo
KmlwID09IDApIHsNCi0JCQkJCQl0ICs9IDI1NTsNCi0JCQkJCQlpcCsrOw0KLQkJCQkJCWlmIChI
QVZFX0lQKDEsIGlwX2VuZCwgaXApKQ0KLQkJCQkJCQlnb3RvIGlucHV0X292ZXJydW47DQotCQkJ
CQl9DQotCQkJCQl0ICs9IDcgKyAqaXArKzsNCi0JCQkJfQ0KLQkJCQltX3BvcyAtPSBnZXRfdW5h
bGlnbmVkX2xlMTYoaXApID4+IDI7DQotCQkJCWlwICs9IDI7DQotCQkJCWlmIChtX3BvcyA9PSBv
cCkNCi0JCQkJCWdvdG8gZW9mX2ZvdW5kOw0KLQkJCQltX3BvcyAtPSAweDQwMDA7DQotCQkJfSBl
bHNlIHsNCi0JCQkJbV9wb3MgPSBvcCAtIDE7DQotCQkJCW1fcG9zIC09IHQgPj4gMjsNCi0JCQkJ
bV9wb3MgLT0gKmlwKysgPDwgMjsNCi0NCi0JCQkJaWYgKEhBVkVfTEIobV9wb3MsIG91dCwgb3Ap
KQ0KLQkJCQkJZ290byBsb29rYmVoaW5kX292ZXJydW47DQotCQkJCWlmIChIQVZFX09QKDIsIG9w
X2VuZCwgb3ApKQ0KLQkJCQkJZ290byBvdXRwdXRfb3ZlcnJ1bjsNCi0NCi0JCQkJKm9wKysgPSAq
bV9wb3MrKzsNCi0JCQkJKm9wKysgPSAqbV9wb3M7DQotCQkJCWdvdG8gbWF0Y2hfZG9uZTsNCi0J
CQl9DQotDQotCQkJaWYgKEhBVkVfTEIobV9wb3MsIG91dCwgb3ApKQ0KLQkJCQlnb3RvIGxvb2ti
ZWhpbmRfb3ZlcnJ1bjsNCi0JCQlpZiAoSEFWRV9PUCh0ICsgMyAtIDEsIG9wX2VuZCwgb3ApKQ0K
LQkJCQlnb3RvIG91dHB1dF9vdmVycnVuOw0KLQ0KLQkJCWlmICh0ID49IDIgKiA0IC0gKDMgLSAx
KSAmJiAob3AgLSBtX3BvcykgPj0gNCkgew0KLQkJCQlDT1BZNChvcCwgbV9wb3MpOw0KLQkJCQlv
cCArPSA0Ow0KLQkJCQltX3BvcyArPSA0Ow0KLQkJCQl0IC09IDQgLSAoMyAtIDEpOw0KLQkJCQlk
byB7DQotCQkJCQlDT1BZNChvcCwgbV9wb3MpOw0KLQkJCQkJb3AgKz0gNDsNCi0JCQkJCW1fcG9z
ICs9IDQ7DQotCQkJCQl0IC09IDQ7DQotCQkJCX0gd2hpbGUgKHQgPj0gNCk7DQotCQkJCWlmICh0
ID4gMCkNCi0JCQkJCWRvIHsNCi0JCQkJCQkqb3ArKyA9ICptX3BvcysrOw0KLQkJCQkJfSB3aGls
ZSAoLS10ID4gMCk7DQotCQkJfSBlbHNlIHsNCi1jb3B5X21hdGNoOg0KLQkJCQkqb3ArKyA9ICpt
X3BvcysrOw0KLQkJCQkqb3ArKyA9ICptX3BvcysrOw0KLQkJCQlkbyB7DQotCQkJCQkqb3ArKyA9
ICptX3BvcysrOw0KLQkJCQl9IHdoaWxlICgtLXQgPiAwKTsNCi0JCQl9DQotbWF0Y2hfZG9uZToN
Ci0JCQl0ID0gaXBbLTJdICYgMzsNCi0JCQlpZiAodCA9PSAwKQ0KLQkJCQlicmVhazsNCi1tYXRj
aF9uZXh0Og0KLQkJCWlmIChIQVZFX09QKHQsIG9wX2VuZCwgb3ApKQ0KLQkJCQlnb3RvIG91dHB1
dF9vdmVycnVuOw0KLQkJCWlmIChIQVZFX0lQKHQgKyAxLCBpcF9lbmQsIGlwKSkNCi0JCQkJZ290
byBpbnB1dF9vdmVycnVuOw0KLQ0KLQkJCSpvcCsrID0gKmlwKys7DQotCQkJaWYgKHQgPiAxKSB7
DQotCQkJCSpvcCsrID0gKmlwKys7DQotCQkJCWlmICh0ID4gMikNCi0JCQkJCSpvcCsrID0gKmlw
Kys7DQotCQkJfQ0KLQ0KLQkJCXQgPSAqaXArKzsNCi0JCX0gd2hpbGUgKGlwIDwgaXBfZW5kKTsN
Ci0JfQ0KLQ0KLQkqb3V0X2xlbiA9IG9wIC0gb3V0Ow0KLQlyZXR1cm4gTFpPX0VfRU9GX05PVF9G
T1VORDsNCi0NCi1lb2ZfZm91bmQ6DQotCSpvdXRfbGVuID0gb3AgLSBvdXQ7DQotCXJldHVybiAo
aXAgPT0gaXBfZW5kID8gTFpPX0VfT0sgOg0KLQkJKGlwIDwgaXBfZW5kID8gTFpPX0VfSU5QVVRf
Tk9UX0NPTlNVTUVEIDogTFpPX0VfSU5QVVRfT1ZFUlJVTikpOw0KLWlucHV0X292ZXJydW46DQot
CSpvdXRfbGVuID0gb3AgLSBvdXQ7DQotCXJldHVybiBMWk9fRV9JTlBVVF9PVkVSUlVOOw0KLQ0K
LW91dHB1dF9vdmVycnVuOg0KLQkqb3V0X2xlbiA9IG9wIC0gb3V0Ow0KLQlyZXR1cm4gTFpPX0Vf
T1VUUFVUX09WRVJSVU47DQotDQotbG9va2JlaGluZF9vdmVycnVuOg0KLQkqb3V0X2xlbiA9IG9w
IC0gb3V0Ow0KLQlyZXR1cm4gTFpPX0VfTE9PS0JFSElORF9PVkVSUlVOOw0KLX0NCi0jaWZuZGVm
IFNUQVRJQw0KLUVYUE9SVF9TWU1CT0xfR1BMKGx6bzF4X2RlY29tcHJlc3Nfc2FmZSk7DQotDQot
TU9EVUxFX0xJQ0VOU0UoIkdQTCIpOw0KLU1PRFVMRV9ERVNDUklQVElPTigiTFpPMVggRGVjb21w
cmVzc29yIik7DQotDQotI2VuZGlmDQpkaWZmIC0tZ2l0IGEvbGliL2x6by9sem8xeF9kZWNvbXBy
ZXNzX3NhZmUuYyBiL2xpYi9sem8vbHpvMXhfZGVjb21wcmVzc19zYWZlLmMNCm5ldyBmaWxlIG1v
ZGUgMTAwNjQ0DQppbmRleCAwMDAwMDAwLi44NTYzMDgxDQotLS0gL2Rldi9udWxsDQorKysgYi9s
aWIvbHpvL2x6bzF4X2RlY29tcHJlc3Nfc2FmZS5jDQpAQCAtMCwwICsxLDI1NyBAQA0KKy8qDQor
ICogIExaTzFYIERlY29tcHJlc3NvciBmcm9tIExaTw0KKyAqDQorICogIENvcHlyaWdodCAoQykg
MTk5Ni0yMDEyIE1hcmt1cyBGLlguSi4gT2Jlcmh1bWVyIDxtYXJrdXNAb2Jlcmh1bWVyLmNvbT4N
CisgKg0KKyAqICBUaGUgZnVsbCBMWk8gcGFja2FnZSBjYW4gYmUgZm91bmQgYXQ6DQorICogIGh0
dHA6Ly93d3cub2Jlcmh1bWVyLmNvbS9vcGVuc291cmNlL2x6by8NCisgKg0KKyAqICBDaGFuZ2Vk
IGZvciBMaW51eCBrZXJuZWwgdXNlIGJ5Og0KKyAqICBOaXRpbiBHdXB0YSA8bml0aW5ndXB0YTkx
MEBnbWFpbC5jb20+DQorICogIFJpY2hhcmQgUHVyZGllIDxycHVyZGllQG9wZW5lZGhhbmQuY29t
Pg0KKyAqLw0KKw0KKyNpZm5kZWYgU1RBVElDDQorI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPg0K
KyNpbmNsdWRlIDxsaW51eC9rZXJuZWwuaD4NCisjZW5kaWYNCisjaW5jbHVkZSA8YXNtL3VuYWxp
Z25lZC5oPg0KKyNpbmNsdWRlIDxsaW51eC9sem8uaD4NCisjaW5jbHVkZSAibHpvZGVmcy5oIg0K
Kw0KKyNkZWZpbmUgSEFWRV9JUCh0LCB4KQkJCQkJXA0KKwkoKChzaXplX3QpKGlwX2VuZCAtIGlw
KSA+PSAoc2l6ZV90KSh0ICsgeCkpICYmCVwNCisJICgoKHQgKyB4KSA+PSB0KSAmJiAoKHQgKyB4
KSA+PSB4KSkpDQorDQorI2RlZmluZSBIQVZFX09QKHQsIHgpCQkJCQlcDQorCSgoKHNpemVfdCko
b3BfZW5kIC0gb3ApID49IChzaXplX3QpKHQgKyB4KSkgJiYJXA0KKwkgKCgodCArIHgpID49IHQp
ICYmICgodCArIHgpID49IHgpKSkNCisNCisjZGVmaW5lIE5FRURfSVAodCwgeCkJCQkJCVwNCisJ
ZG8gewkJCQkJCVwNCisJCWlmICghSEFWRV9JUCh0LCB4KSkJCQlcDQorCQkJZ290byBpbnB1dF9v
dmVycnVuOwkJXA0KKwl9IHdoaWxlICgwKQ0KKw0KKyNkZWZpbmUgTkVFRF9PUCh0LCB4KQkJCQkJ
XA0KKwlkbyB7CQkJCQkJXA0KKwkJaWYgKCFIQVZFX09QKHQsIHgpKQkJCVwNCisJCQlnb3RvIG91
dHB1dF9vdmVycnVuOwkJXA0KKwl9IHdoaWxlICgwKQ0KKw0KKyNkZWZpbmUgVEVTVF9MQihtX3Bv
cykJCQkJCVwNCisJZG8gewkJCQkJCVwNCisJCWlmICgobV9wb3MpIDwgb3V0KQkJCVwNCisJCQln
b3RvIGxvb2tiZWhpbmRfb3ZlcnJ1bjsJXA0KKwl9IHdoaWxlICgwKQ0KKw0KK2ludCBsem8xeF9k
ZWNvbXByZXNzX3NhZmUoY29uc3QgdW5zaWduZWQgY2hhciAqaW4sIHNpemVfdCBpbl9sZW4sDQor
CQkJICB1bnNpZ25lZCBjaGFyICpvdXQsIHNpemVfdCAqb3V0X2xlbikNCit7DQorCXVuc2lnbmVk
IGNoYXIgKm9wOw0KKwljb25zdCB1bnNpZ25lZCBjaGFyICppcDsNCisJc2l6ZV90IHQsIG5leHQ7
DQorCXNpemVfdCBzdGF0ZSA9IDA7DQorCWNvbnN0IHVuc2lnbmVkIGNoYXIgKm1fcG9zOw0KKwlj
b25zdCB1bnNpZ25lZCBjaGFyICogY29uc3QgaXBfZW5kID0gaW4gKyBpbl9sZW47DQorCXVuc2ln
bmVkIGNoYXIgKiBjb25zdCBvcF9lbmQgPSBvdXQgKyAqb3V0X2xlbjsNCisNCisJb3AgPSBvdXQ7
DQorCWlwID0gaW47DQorDQorCWlmICh1bmxpa2VseShpbl9sZW4gPCAzKSkNCisJCWdvdG8gaW5w
dXRfb3ZlcnJ1bjsNCisJaWYgKCppcCA+IDE3KSB7DQorCQl0ID0gKmlwKysgLSAxNzsNCisJCWlm
ICh0IDwgNCkgew0KKwkJCW5leHQgPSB0Ow0KKwkJCWdvdG8gbWF0Y2hfbmV4dDsNCisJCX0NCisJ
CWdvdG8gY29weV9saXRlcmFsX3J1bjsNCisJfQ0KKw0KKwlmb3IgKDs7KSB7DQorCQl0ID0gKmlw
Kys7DQorCQlpZiAodCA8IDE2KSB7DQorCQkJaWYgKGxpa2VseShzdGF0ZSA9PSAwKSkgew0KKwkJ
CQlpZiAodW5saWtlbHkodCA9PSAwKSkgew0KKwkJCQkJd2hpbGUgKHVubGlrZWx5KCppcCA9PSAw
KSkgew0KKwkJCQkJCXQgKz0gMjU1Ow0KKwkJCQkJCWlwKys7DQorCQkJCQkJTkVFRF9JUCgxLCAw
KTsNCisJCQkJCX0NCisJCQkJCXQgKz0gMTUgKyAqaXArKzsNCisJCQkJfQ0KKwkJCQl0ICs9IDM7
DQorY29weV9saXRlcmFsX3J1bjoNCisjaWYgZGVmaW5lZChDT05GSUdfSEFWRV9FRkZJQ0lFTlRf
VU5BTElHTkVEX0FDQ0VTUykNCisJCQkJaWYgKGxpa2VseShIQVZFX0lQKHQsIDE1KSAmJiBIQVZF
X09QKHQsIDE1KSkpIHsNCisJCQkJCWNvbnN0IHVuc2lnbmVkIGNoYXIgKmllID0gaXAgKyB0Ow0K
KwkJCQkJdW5zaWduZWQgY2hhciAqb2UgPSBvcCArIHQ7DQorCQkJCQlkbyB7DQorCQkJCQkJQ09Q
WTgob3AsIGlwKTsNCisJCQkJCQlvcCArPSA4Ow0KKwkJCQkJCWlwICs9IDg7DQorCQkJCQkJQ09Q
WTgob3AsIGlwKTsNCisJCQkJCQlvcCArPSA4Ow0KKwkJCQkJCWlwICs9IDg7DQorCQkJCQl9IHdo
aWxlIChpcCA8IGllKTsNCisJCQkJCWlwID0gaWU7DQorCQkJCQlvcCA9IG9lOw0KKwkJCQl9IGVs
c2UNCisjZW5kaWYNCisJCQkJew0KKwkJCQkJTkVFRF9PUCh0LCAwKTsNCisJCQkJCU5FRURfSVAo
dCwgMyk7DQorCQkJCQlkbyB7DQorCQkJCQkJKm9wKysgPSAqaXArKzsNCisJCQkJCX0gd2hpbGUg
KC0tdCA+IDApOw0KKwkJCQl9DQorCQkJCXN0YXRlID0gNDsNCisJCQkJY29udGludWU7DQorCQkJ
fSBlbHNlIGlmIChzdGF0ZSAhPSA0KSB7DQorCQkJCW5leHQgPSB0ICYgMzsNCisJCQkJbV9wb3Mg
PSBvcCAtIDE7DQorCQkJCW1fcG9zIC09IHQgPj4gMjsNCisJCQkJbV9wb3MgLT0gKmlwKysgPDwg
MjsNCisJCQkJVEVTVF9MQihtX3Bvcyk7DQorCQkJCU5FRURfT1AoMiwgMCk7DQorCQkJCW9wWzBd
ID0gbV9wb3NbMF07DQorCQkJCW9wWzFdID0gbV9wb3NbMV07DQorCQkJCW9wICs9IDI7DQorCQkJ
CWdvdG8gbWF0Y2hfbmV4dDsNCisJCQl9IGVsc2Ugew0KKwkJCQluZXh0ID0gdCAmIDM7DQorCQkJ
CW1fcG9zID0gb3AgLSAoMSArIE0yX01BWF9PRkZTRVQpOw0KKwkJCQltX3BvcyAtPSB0ID4+IDI7
DQorCQkJCW1fcG9zIC09ICppcCsrIDw8IDI7DQorCQkJCXQgPSAzOw0KKwkJCX0NCisJCX0gZWxz
ZSBpZiAodCA+PSA2NCkgew0KKwkJCW5leHQgPSB0ICYgMzsNCisJCQltX3BvcyA9IG9wIC0gMTsN
CisJCQltX3BvcyAtPSAodCA+PiAyKSAmIDc7DQorCQkJbV9wb3MgLT0gKmlwKysgPDwgMzsNCisJ
CQl0ID0gKHQgPj4gNSkgLSAxICsgKDMgLSAxKTsNCisJCX0gZWxzZSBpZiAodCA+PSAzMikgew0K
KwkJCXQgPSAodCAmIDMxKSArICgzIC0gMSk7DQorCQkJaWYgKHVubGlrZWx5KHQgPT0gMikpIHsN
CisJCQkJd2hpbGUgKHVubGlrZWx5KCppcCA9PSAwKSkgew0KKwkJCQkJdCArPSAyNTU7DQorCQkJ
CQlpcCsrOw0KKwkJCQkJTkVFRF9JUCgxLCAwKTsNCisJCQkJfQ0KKwkJCQl0ICs9IDMxICsgKmlw
Kys7DQorCQkJCU5FRURfSVAoMiwgMCk7DQorCQkJfQ0KKwkJCW1fcG9zID0gb3AgLSAxOw0KKwkJ
CW5leHQgPSBnZXRfdW5hbGlnbmVkX2xlMTYoaXApOw0KKwkJCWlwICs9IDI7DQorCQkJbV9wb3Mg
LT0gbmV4dCA+PiAyOw0KKwkJCW5leHQgJj0gMzsNCisJCX0gZWxzZSB7DQorCQkJbV9wb3MgPSBv
cDsNCisJCQltX3BvcyAtPSAodCAmIDgpIDw8IDExOw0KKwkJCXQgPSAodCAmIDcpICsgKDMgLSAx
KTsNCisJCQlpZiAodW5saWtlbHkodCA9PSAyKSkgew0KKwkJCQl3aGlsZSAodW5saWtlbHkoKmlw
ID09IDApKSB7DQorCQkJCQl0ICs9IDI1NTsNCisJCQkJCWlwKys7DQorCQkJCQlORUVEX0lQKDEs
IDApOw0KKwkJCQl9DQorCQkJCXQgKz0gNyArICppcCsrOw0KKwkJCQlORUVEX0lQKDIsIDApOw0K
KwkJCX0NCisJCQluZXh0ID0gZ2V0X3VuYWxpZ25lZF9sZTE2KGlwKTsNCisJCQlpcCArPSAyOw0K
KwkJCW1fcG9zIC09IG5leHQgPj4gMjsNCisJCQluZXh0ICY9IDM7DQorCQkJaWYgKG1fcG9zID09
IG9wKQ0KKwkJCQlnb3RvIGVvZl9mb3VuZDsNCisJCQltX3BvcyAtPSAweDQwMDA7DQorCQl9DQor
CQlURVNUX0xCKG1fcG9zKTsNCisjaWYgZGVmaW5lZChDT05GSUdfSEFWRV9FRkZJQ0lFTlRfVU5B
TElHTkVEX0FDQ0VTUykNCisJCWlmIChvcCAtIG1fcG9zID49IDgpIHsNCisJCQl1bnNpZ25lZCBj
aGFyICpvZSA9IG9wICsgdDsNCisJCQlpZiAobGlrZWx5KEhBVkVfT1AodCwgMTUpKSkgew0KKwkJ
CQlkbyB7DQorCQkJCQlDT1BZOChvcCwgbV9wb3MpOw0KKwkJCQkJb3AgKz0gODsNCisJCQkJCW1f
cG9zICs9IDg7DQorCQkJCQlDT1BZOChvcCwgbV9wb3MpOw0KKwkJCQkJb3AgKz0gODsNCisJCQkJ
CW1fcG9zICs9IDg7DQorCQkJCX0gd2hpbGUgKG9wIDwgb2UpOw0KKwkJCQlvcCA9IG9lOw0KKwkJ
CQlpZiAoSEFWRV9JUCg2LCAwKSkgew0KKwkJCQkJc3RhdGUgPSBuZXh0Ow0KKwkJCQkJQ09QWTQo
b3AsIGlwKTsNCisJCQkJCW9wICs9IG5leHQ7DQorCQkJCQlpcCArPSBuZXh0Ow0KKwkJCQkJY29u
dGludWU7DQorCQkJCX0NCisJCQl9IGVsc2Ugew0KKwkJCQlORUVEX09QKHQsIDApOw0KKwkJCQlk
byB7DQorCQkJCQkqb3ArKyA9ICptX3BvcysrOw0KKwkJCQl9IHdoaWxlIChvcCA8IG9lKTsNCisJ
CQl9DQorCQl9IGVsc2UNCisjZW5kaWYNCisJCXsNCisJCQl1bnNpZ25lZCBjaGFyICpvZSA9IG9w
ICsgdDsNCisJCQlORUVEX09QKHQsIDApOw0KKwkJCW9wWzBdID0gbV9wb3NbMF07DQorCQkJb3Bb
MV0gPSBtX3Bvc1sxXTsNCisJCQlvcCArPSAyOw0KKwkJCW1fcG9zICs9IDI7DQorCQkJZG8gew0K
KwkJCQkqb3ArKyA9ICptX3BvcysrOw0KKwkJCX0gd2hpbGUgKG9wIDwgb2UpOw0KKwkJfQ0KK21h
dGNoX25leHQ6DQorCQlzdGF0ZSA9IG5leHQ7DQorCQl0ID0gbmV4dDsNCisjaWYgZGVmaW5lZChD
T05GSUdfSEFWRV9FRkZJQ0lFTlRfVU5BTElHTkVEX0FDQ0VTUykNCisJCWlmIChsaWtlbHkoSEFW
RV9JUCg2LCAwKSAmJiBIQVZFX09QKDQsIDApKSkgew0KKwkJCUNPUFk0KG9wLCBpcCk7DQorCQkJ
b3AgKz0gdDsNCisJCQlpcCArPSB0Ow0KKwkJfSBlbHNlDQorI2VuZGlmDQorCQl7DQorCQkJTkVF
RF9JUCh0LCAzKTsNCisJCQlORUVEX09QKHQsIDApOw0KKwkJCXdoaWxlICh0ID4gMCkgew0KKwkJ
CQkqb3ArKyA9ICppcCsrOw0KKwkJCQl0LS07DQorCQkJfQ0KKwkJfQ0KKwl9DQorDQorZW9mX2Zv
dW5kOg0KKwkqb3V0X2xlbiA9IG9wIC0gb3V0Ow0KKwlyZXR1cm4gKHQgIT0gMyAgICAgICA/IExa
T19FX0VSUk9SIDoNCisJCWlwID09IGlwX2VuZCA/IExaT19FX09LIDoNCisJCWlwIDwgIGlwX2Vu
ZCA/IExaT19FX0lOUFVUX05PVF9DT05TVU1FRCA6IExaT19FX0lOUFVUX09WRVJSVU4pOw0KKw0K
K2lucHV0X292ZXJydW46DQorCSpvdXRfbGVuID0gb3AgLSBvdXQ7DQorCXJldHVybiBMWk9fRV9J
TlBVVF9PVkVSUlVOOw0KKw0KK291dHB1dF9vdmVycnVuOg0KKwkqb3V0X2xlbiA9IG9wIC0gb3V0
Ow0KKwlyZXR1cm4gTFpPX0VfT1VUUFVUX09WRVJSVU47DQorDQorbG9va2JlaGluZF9vdmVycnVu
Og0KKwkqb3V0X2xlbiA9IG9wIC0gb3V0Ow0KKwlyZXR1cm4gTFpPX0VfTE9PS0JFSElORF9PVkVS
UlVOOw0KK30NCisjaWZuZGVmIFNUQVRJQw0KK0VYUE9SVF9TWU1CT0xfR1BMKGx6bzF4X2RlY29t
cHJlc3Nfc2FmZSk7DQorDQorTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOw0KK01PRFVMRV9ERVNDUklQ
VElPTigiTFpPMVggRGVjb21wcmVzc29yIik7DQorDQorI2VuZGlmDQpkaWZmIC0tZ2l0IGEvbGli
L2x6by9sem9kZWZzLmggYi9saWIvbHpvL2x6b2RlZnMuaA0KaW5kZXggYjZkNDgyYy4uNjcxMGI4
MyAxMDA2NDQNCi0tLSBhL2xpYi9sem8vbHpvZGVmcy5oDQorKysgYi9saWIvbHpvL2x6b2RlZnMu
aA0KQEAgLTEsMTkgKzEsMzcgQEANCiAvKg0KICAqICBsem9kZWZzLmggLS0gYXJjaGl0ZWN0dXJl
LCBPUyBhbmQgY29tcGlsZXIgc3BlY2lmaWMgZGVmaW5lcw0KICAqDQotICogIENvcHlyaWdodCAo
QykgMTk5Ni0yMDA1IE1hcmt1cyBGLlguSi4gT2Jlcmh1bWVyIDxtYXJrdXNAb2Jlcmh1bWVyLmNv
bT4NCisgKiAgQ29weXJpZ2h0IChDKSAxOTk2LTIwMTIgTWFya3VzIEYuWC5KLiBPYmVyaHVtZXIg
PG1hcmt1c0BvYmVyaHVtZXIuY29tPg0KICAqDQogICogIFRoZSBmdWxsIExaTyBwYWNrYWdlIGNh
biBiZSBmb3VuZCBhdDoNCiAgKiAgaHR0cDovL3d3dy5vYmVyaHVtZXIuY29tL29wZW5zb3VyY2Uv
bHpvLw0KICAqDQotICogIENoYW5nZWQgZm9yIGtlcm5lbCB1c2UgYnk6DQorICogIENoYW5nZWQg
Zm9yIExpbnV4IGtlcm5lbCB1c2UgYnk6DQogICogIE5pdGluIEd1cHRhIDxuaXRpbmd1cHRhOTEw
QGdtYWlsLmNvbT4NCiAgKiAgUmljaGFyZCBQdXJkaWUgPHJwdXJkaWVAb3BlbmVkaGFuZC5jb20+
DQogICovDQogDQotI2RlZmluZSBMWk9fVkVSU0lPTgkJMHgyMDIwDQotI2RlZmluZSBMWk9fVkVS
U0lPTl9TVFJJTkcJIjIuMDIiDQotI2RlZmluZSBMWk9fVkVSU0lPTl9EQVRFCSJPY3QgMTcgMjAw
NSINCisNCisjZGVmaW5lIENPUFk0KGRzdCwgc3JjKQlcDQorCQlwdXRfdW5hbGlnbmVkKGdldF91
bmFsaWduZWQoKGNvbnN0IHUzMiAqKShzcmMpKSwgKHUzMiAqKShkc3QpKQ0KKyNpZiBkZWZpbmVk
KF9feDg2XzY0X18pDQorI2RlZmluZSBDT1BZOChkc3QsIHNyYykJXA0KKwkJcHV0X3VuYWxpZ25l
ZChnZXRfdW5hbGlnbmVkKChjb25zdCB1NjQgKikoc3JjKSksICh1NjQgKikoZHN0KSkNCisjZWxz
ZQ0KKyNkZWZpbmUgQ09QWTgoZHN0LCBzcmMpCVwNCisJCUNPUFk0KGRzdCwgc3JjKTsgQ09QWTQo
KGRzdCkgKyA0LCAoc3JjKSArIDQpDQorI2VuZGlmDQorDQorI2lmIGRlZmluZWQoX19CSUdfRU5E
SUFOKSAmJiBkZWZpbmVkKF9fTElUVExFX0VORElBTikNCisjZXJyb3IgImNvbmZsaWN0aW5nIGVu
ZGlhbiBkZWZpbml0aW9ucyINCisjZWxpZiBkZWZpbmVkKF9feDg2XzY0X18pDQorI2RlZmluZSBM
Wk9fVVNFX0NUWjY0CTENCisjZGVmaW5lIExaT19VU0VfQ1RaMzIJMQ0KKyNlbGlmIGRlZmluZWQo
X19pMzg2X18pIHx8IGRlZmluZWQoX19wb3dlcnBjX18pDQorI2RlZmluZSBMWk9fVVNFX0NUWjMy
CTENCisjZWxpZiBkZWZpbmVkKF9fYXJtX18pICYmIChfX0xJTlVYX0FSTV9BUkNIX18gPj0gNSkN
CisjZGVmaW5lIExaT19VU0VfQ1RaMzIJMQ0KKyNlbmRpZg0KIA0KICNkZWZpbmUgTTFfTUFYX09G
RlNFVAkweDA0MDANCiAjZGVmaW5lIE0yX01BWF9PRkZTRVQJMHgwODAwDQpAQCAtMzQsMTAgKzUy
LDggQEANCiAjZGVmaW5lIE0zX01BUktFUgkzMg0KICNkZWZpbmUgTTRfTUFSS0VSCTE2DQogDQot
I2RlZmluZSBEX0JJVFMJCTE0DQotI2RlZmluZSBEX01BU0sJCSgoMXUgPDwgRF9CSVRTKSAtIDEp
DQorI2RlZmluZSBsem9fZGljdF90ICAgICAgdW5zaWduZWQgc2hvcnQNCisjZGVmaW5lIERfQklU
UwkJMTMNCisjZGVmaW5lIERfU0laRQkJKDF1IDw8IERfQklUUykNCisjZGVmaW5lIERfTUFTSwkJ
KERfU0laRSAtIDEpDQogI2RlZmluZSBEX0hJR0gJCSgoRF9NQVNLID4+IDEpICsgMSkNCi0NCi0j
ZGVmaW5lIERYMihwLCBzMSwgczIpCSgoKCgoc2l6ZV90KSgocClbMl0pIDw8IChzMikpIF4gKHAp
WzFdKSBcDQotCQkJCQkJCTw8IChzMSkpIF4gKHApWzBdKQ0KLSNkZWZpbmUgRFgzKHAsIHMxLCBz
MiwgczMpCSgoRFgyKChwKSsxLCBzMiwgczMpIDw8IChzMSkpIF4gKHApWzBdKQ0KZGlmZiAtLWdp
dCBhL2xpYi9ubGF0dHIuYyBiL2xpYi9ubGF0dHIuYw0KaW5kZXggMTkwYWUxMC4uYmUyNWUzNSAx
MDA2NDQNCi0tLSBhL2xpYi9ubGF0dHIuYw0KKysrIGIvbGliL25sYXR0ci5jDQpAQCAtMTIsNiAr
MTIsOCBAQA0KICNpbmNsdWRlIDxsaW51eC9uZXRkZXZpY2UuaD4NCiAjaW5jbHVkZSA8bGludXgv
c2tidWZmLmg+DQogI2luY2x1ZGUgPGxpbnV4L3N0cmluZy5oPg0KKyNpbmNsdWRlIDxsaW51eC9y
YXRlbGltaXQuaD4NCisjaW5jbHVkZSA8bGludXgvc2NoZWQuaD4NCiAjaW5jbHVkZSA8bGludXgv
dHlwZXMuaD4NCiAjaW5jbHVkZSA8bmV0L25ldGxpbmsuaD4NCiANCkBAIC0xOTcsOCArMTk5LDgg
QEAgaW50IG5sYV9wYXJzZShzdHJ1Y3QgbmxhdHRyICoqdGIsIGludCBtYXh0eXBlLCBjb25zdCBz
dHJ1Y3QgbmxhdHRyICpoZWFkLA0KIAl9DQogDQogCWlmICh1bmxpa2VseShyZW0gPiAwKSkNCi0J
CXByaW50ayhLRVJOX1dBUk5JTkcgIm5ldGxpbms6ICVkIGJ5dGVzIGxlZnRvdmVyIGFmdGVyIHBh
cnNpbmcgIg0KLQkJICAgICAgICJhdHRyaWJ1dGVzLlxuIiwgcmVtKTsNCisJCXByX3dhcm5fcmF0
ZWxpbWl0ZWQoIm5ldGxpbms6ICVkIGJ5dGVzIGxlZnRvdmVyIGFmdGVyIHBhcnNpbmcgYXR0cmli
dXRlcyBpbiBwcm9jZXNzIGAlcycuXG4iLA0KKwkJCQkgICAgcmVtLCBjdXJyZW50LT5jb21tKTsN
CiANCiAJZXJyID0gMDsNCiBlcnJvdXQ6DQpkaWZmIC0tZ2l0IGEvbW0vaGlnaG1lbS5jIGIvbW0v
aGlnaG1lbS5jDQppbmRleCAyYTA3Zjk3Li4wOWZjNzQ0IDEwMDY0NA0KLS0tIGEvbW0vaGlnaG1l
bS5jDQorKysgYi9tbS9oaWdobWVtLmMNCkBAIC05OCw3ICs5OCw3IEBAIHN0cnVjdCBwYWdlICpr
bWFwX3RvX3BhZ2Uodm9pZCAqdmFkZHIpDQogew0KIAl1bnNpZ25lZCBsb25nIGFkZHIgPSAodW5z
aWduZWQgbG9uZyl2YWRkcjsNCiANCi0JaWYgKGFkZHIgPj0gUEtNQVBfQUREUigwKSAmJiBhZGRy
IDw9IFBLTUFQX0FERFIoTEFTVF9QS01BUCkpIHsNCisJaWYgKGFkZHIgPj0gUEtNQVBfQUREUigw
KSAmJiBhZGRyIDwgUEtNQVBfQUREUihMQVNUX1BLTUFQKSkgew0KIAkJaW50IGkgPSAoYWRkciAt
IFBLTUFQX0FERFIoMCkpID4+IFBBR0VfU0hJRlQ7DQogCQlyZXR1cm4gcHRlX3BhZ2UocGttYXBf
cGFnZV90YWJsZVtpXSk7DQogCX0NCmRpZmYgLS1naXQgYS9tbS9odWdldGxiLmMgYi9tbS9odWdl
dGxiLmMNCmluZGV4IGNhYzI0NDEuLjZmODg2ZDkgMTAwNjQ0DQotLS0gYS9tbS9odWdldGxiLmMN
CisrKyBiL21tL2h1Z2V0bGIuYw0KQEAgLTIyNzIsNiArMjI3MiwzMSBAQCBzdGF0aWMgdm9pZCBz
ZXRfaHVnZV9wdGVwX3dyaXRhYmxlKHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hLA0KIAkJdXBk
YXRlX21tdV9jYWNoZSh2bWEsIGFkZHJlc3MsIHB0ZXApOw0KIH0NCiANCitzdGF0aWMgaW50IGlz
X2h1Z2V0bGJfZW50cnlfbWlncmF0aW9uKHB0ZV90IHB0ZSkNCit7DQorCXN3cF9lbnRyeV90IHN3
cDsNCisNCisJaWYgKGh1Z2VfcHRlX25vbmUocHRlKSB8fCBwdGVfcHJlc2VudChwdGUpKQ0KKwkJ
cmV0dXJuIDA7DQorCXN3cCA9IHB0ZV90b19zd3BfZW50cnkocHRlKTsNCisJaWYgKG5vbl9zd2Fw
X2VudHJ5KHN3cCkgJiYgaXNfbWlncmF0aW9uX2VudHJ5KHN3cCkpDQorCQlyZXR1cm4gMTsNCisJ
ZWxzZQ0KKwkJcmV0dXJuIDA7DQorfQ0KKw0KK3N0YXRpYyBpbnQgaXNfaHVnZXRsYl9lbnRyeV9o
d3BvaXNvbmVkKHB0ZV90IHB0ZSkNCit7DQorCXN3cF9lbnRyeV90IHN3cDsNCisNCisJaWYgKGh1
Z2VfcHRlX25vbmUocHRlKSB8fCBwdGVfcHJlc2VudChwdGUpKQ0KKwkJcmV0dXJuIDA7DQorCXN3
cCA9IHB0ZV90b19zd3BfZW50cnkocHRlKTsNCisJaWYgKG5vbl9zd2FwX2VudHJ5KHN3cCkgJiYg
aXNfaHdwb2lzb25fZW50cnkoc3dwKSkNCisJCXJldHVybiAxOw0KKwllbHNlDQorCQlyZXR1cm4g
MDsNCit9DQogDQogaW50IGNvcHlfaHVnZXRsYl9wYWdlX3JhbmdlKHN0cnVjdCBtbV9zdHJ1Y3Qg
KmRzdCwgc3RydWN0IG1tX3N0cnVjdCAqc3JjLA0KIAkJCSAgICBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1
Y3QgKnZtYSkNCkBAIC0yMjk5LDEwICsyMzI0LDI2IEBAIGludCBjb3B5X2h1Z2V0bGJfcGFnZV9y
YW5nZShzdHJ1Y3QgbW1fc3RydWN0ICpkc3QsIHN0cnVjdCBtbV9zdHJ1Y3QgKnNyYywNCiANCiAJ
CXNwaW5fbG9jaygmZHN0LT5wYWdlX3RhYmxlX2xvY2spOw0KIAkJc3Bpbl9sb2NrX25lc3RlZCgm
c3JjLT5wYWdlX3RhYmxlX2xvY2ssIFNJTkdMRV9ERVBUSF9ORVNUSU5HKTsNCi0JCWlmICghaHVn
ZV9wdGVfbm9uZShodWdlX3B0ZXBfZ2V0KHNyY19wdGUpKSkgew0KKwkJZW50cnkgPSBodWdlX3B0
ZXBfZ2V0KHNyY19wdGUpOw0KKwkJaWYgKGh1Z2VfcHRlX25vbmUoZW50cnkpKSB7IC8qIHNraXAg
bm9uZSBlbnRyeSAqLw0KKwkJCTsNCisJCX0gZWxzZSBpZiAodW5saWtlbHkoaXNfaHVnZXRsYl9l
bnRyeV9taWdyYXRpb24oZW50cnkpIHx8DQorCQkJCSAgICBpc19odWdldGxiX2VudHJ5X2h3cG9p
c29uZWQoZW50cnkpKSkgew0KKwkJCXN3cF9lbnRyeV90IHN3cF9lbnRyeSA9IHB0ZV90b19zd3Bf
ZW50cnkoZW50cnkpOw0KKw0KKwkJCWlmIChpc193cml0ZV9taWdyYXRpb25fZW50cnkoc3dwX2Vu
dHJ5KSAmJiBjb3cpIHsNCisJCQkJLyoNCisJCQkJICogQ09XIG1hcHBpbmdzIHJlcXVpcmUgcGFn
ZXMgaW4gYm90aA0KKwkJCQkgKiBwYXJlbnQgYW5kIGNoaWxkIHRvIGJlIHNldCB0byByZWFkLg0K
KwkJCQkgKi8NCisJCQkJbWFrZV9taWdyYXRpb25fZW50cnlfcmVhZCgmc3dwX2VudHJ5KTsNCisJ
CQkJZW50cnkgPSBzd3BfZW50cnlfdG9fcHRlKHN3cF9lbnRyeSk7DQorCQkJCXNldF9odWdlX3B0
ZV9hdChzcmMsIGFkZHIsIHNyY19wdGUsIGVudHJ5KTsNCisJCQl9DQorCQkJc2V0X2h1Z2VfcHRl
X2F0KGRzdCwgYWRkciwgZHN0X3B0ZSwgZW50cnkpOw0KKwkJfSBlbHNlIHsNCiAJCQlpZiAoY293
KQ0KIAkJCQlodWdlX3B0ZXBfc2V0X3dycHJvdGVjdChzcmMsIGFkZHIsIHNyY19wdGUpOw0KLQkJ
CWVudHJ5ID0gaHVnZV9wdGVwX2dldChzcmNfcHRlKTsNCiAJCQlwdGVwYWdlID0gcHRlX3BhZ2Uo
ZW50cnkpOw0KIAkJCWdldF9wYWdlKHB0ZXBhZ2UpOw0KIAkJCXBhZ2VfZHVwX3JtYXAocHRlcGFn
ZSk7DQpAQCAtMjMxNywzMiArMjM1OCw2IEBAIG5vbWVtOg0KIAlyZXR1cm4gLUVOT01FTTsNCiB9
DQogDQotc3RhdGljIGludCBpc19odWdldGxiX2VudHJ5X21pZ3JhdGlvbihwdGVfdCBwdGUpDQot
ew0KLQlzd3BfZW50cnlfdCBzd3A7DQotDQotCWlmIChodWdlX3B0ZV9ub25lKHB0ZSkgfHwgcHRl
X3ByZXNlbnQocHRlKSkNCi0JCXJldHVybiAwOw0KLQlzd3AgPSBwdGVfdG9fc3dwX2VudHJ5KHB0
ZSk7DQotCWlmIChub25fc3dhcF9lbnRyeShzd3ApICYmIGlzX21pZ3JhdGlvbl9lbnRyeShzd3Ap
KQ0KLQkJcmV0dXJuIDE7DQotCWVsc2UNCi0JCXJldHVybiAwOw0KLX0NCi0NCi1zdGF0aWMgaW50
IGlzX2h1Z2V0bGJfZW50cnlfaHdwb2lzb25lZChwdGVfdCBwdGUpDQotew0KLQlzd3BfZW50cnlf
dCBzd3A7DQotDQotCWlmIChodWdlX3B0ZV9ub25lKHB0ZSkgfHwgcHRlX3ByZXNlbnQocHRlKSkN
Ci0JCXJldHVybiAwOw0KLQlzd3AgPSBwdGVfdG9fc3dwX2VudHJ5KHB0ZSk7DQotCWlmIChub25f
c3dhcF9lbnRyeShzd3ApICYmIGlzX2h3cG9pc29uX2VudHJ5KHN3cCkpDQotCQlyZXR1cm4gMTsN
Ci0JZWxzZQ0KLQkJcmV0dXJuIDA7DQotfQ0KLQ0KIHZvaWQgX191bm1hcF9odWdlcGFnZV9yYW5n
ZShzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSwgdW5zaWduZWQgbG9uZyBzdGFydCwNCiAJCQkg
ICAgdW5zaWduZWQgbG9uZyBlbmQsIHN0cnVjdCBwYWdlICpyZWZfcGFnZSkNCiB7DQpkaWZmIC0t
Z2l0IGEvbW0vbWVtcG9saWN5LmMgYi9tbS9tZW1wb2xpY3kuYw0KaW5kZXggNGQxZTYzNy4uMmI1
YmNjOSAxMDA2NDQNCi0tLSBhL21tL21lbXBvbGljeS5jDQorKysgYi9tbS9tZW1wb2xpY3kuYw0K
QEAgLTU2NiwyNCArNTY2LDIzIEBAIHN0YXRpYyBpbmxpbmUgaW50IGNoZWNrX3BnZF9yYW5nZShz
dHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSwNCiAgKiBJZiBwYWdlbGlzdCAhPSBOVUxMIHRoZW4g
aXNvbGF0ZSBwYWdlcyBmcm9tIHRoZSBMUlUgYW5kDQogICogcHV0IHRoZW0gb24gdGhlIHBhZ2Vs
aXN0Lg0KICAqLw0KLXN0YXRpYyBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKg0KK3N0YXRpYyBpbnQN
CiBjaGVja19yYW5nZShzdHJ1Y3QgbW1fc3RydWN0ICptbSwgdW5zaWduZWQgbG9uZyBzdGFydCwg
dW5zaWduZWQgbG9uZyBlbmQsDQogCQljb25zdCBub2RlbWFza190ICpub2RlcywgdW5zaWduZWQg
bG9uZyBmbGFncywgdm9pZCAqcHJpdmF0ZSkNCiB7DQotCWludCBlcnI7DQotCXN0cnVjdCB2bV9h
cmVhX3N0cnVjdCAqZmlyc3QsICp2bWEsICpwcmV2Ow0KLQ0KKwlpbnQgZXJyID0gMDsNCisJc3Ry
dWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsICpwcmV2Ow0KIA0KLQlmaXJzdCA9IGZpbmRfdm1hKG1t
LCBzdGFydCk7DQotCWlmICghZmlyc3QpDQotCQlyZXR1cm4gRVJSX1BUUigtRUZBVUxUKTsNCisJ
dm1hID0gZmluZF92bWEobW0sIHN0YXJ0KTsNCisJaWYgKCF2bWEpDQorCQlyZXR1cm4gLUVGQVVM
VDsNCiAJcHJldiA9IE5VTEw7DQotCWZvciAodm1hID0gZmlyc3Q7IHZtYSAmJiB2bWEtPnZtX3N0
YXJ0IDwgZW5kOyB2bWEgPSB2bWEtPnZtX25leHQpIHsNCisJZm9yICg7IHZtYSAmJiB2bWEtPnZt
X3N0YXJ0IDwgZW5kOyB2bWEgPSB2bWEtPnZtX25leHQpIHsNCiAJCWlmICghKGZsYWdzICYgTVBP
TF9NRl9ESVNDT05USUdfT0spKSB7DQogCQkJaWYgKCF2bWEtPnZtX25leHQgJiYgdm1hLT52bV9l
bmQgPCBlbmQpDQotCQkJCXJldHVybiBFUlJfUFRSKC1FRkFVTFQpOw0KKwkJCQlyZXR1cm4gLUVG
QVVMVDsNCiAJCQlpZiAocHJldiAmJiBwcmV2LT52bV9lbmQgPCB2bWEtPnZtX3N0YXJ0KQ0KLQkJ
CQlyZXR1cm4gRVJSX1BUUigtRUZBVUxUKTsNCisJCQkJcmV0dXJuIC1FRkFVTFQ7DQogCQl9DQog
CQlpZiAoIWlzX3ZtX2h1Z2V0bGJfcGFnZSh2bWEpICYmDQogCQkgICAgKChmbGFncyAmIE1QT0xf
TUZfU1RSSUNUKSB8fA0KQEAgLTU5NywxNCArNTk2LDEyIEBAIGNoZWNrX3JhbmdlKHN0cnVjdCBt
bV9zdHJ1Y3QgKm1tLCB1bnNpZ25lZCBsb25nIHN0YXJ0LCB1bnNpZ25lZCBsb25nIGVuZCwNCiAJ
CQkJc3RhcnQgPSB2bWEtPnZtX3N0YXJ0Ow0KIAkJCWVyciA9IGNoZWNrX3BnZF9yYW5nZSh2bWEs
IHN0YXJ0LCBlbmR2bWEsIG5vZGVzLA0KIAkJCQkJCWZsYWdzLCBwcml2YXRlKTsNCi0JCQlpZiAo
ZXJyKSB7DQotCQkJCWZpcnN0ID0gRVJSX1BUUihlcnIpOw0KKwkJCWlmIChlcnIpDQogCQkJCWJy
ZWFrOw0KLQkJCX0NCiAJCX0NCiAJCXByZXYgPSB2bWE7DQogCX0NCi0JcmV0dXJuIGZpcnN0Ow0K
KwlyZXR1cm4gZXJyOw0KIH0NCiANCiAvKg0KQEAgLTk0NSwxNSArOTQyLDE4IEBAIHN0YXRpYyBp
bnQgbWlncmF0ZV90b19ub2RlKHN0cnVjdCBtbV9zdHJ1Y3QgKm1tLCBpbnQgc291cmNlLCBpbnQg
ZGVzdCwNCiAJbm9kZW1hc2tfdCBubWFzazsNCiAJTElTVF9IRUFEKHBhZ2VsaXN0KTsNCiAJaW50
IGVyciA9IDA7DQotCXN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hOw0KIA0KIAlub2Rlc19jbGVh
cihubWFzayk7DQogCW5vZGVfc2V0KHNvdXJjZSwgbm1hc2spOw0KIA0KLQl2bWEgPSBjaGVja19y
YW5nZShtbSwgbW0tPm1tYXAtPnZtX3N0YXJ0LCBtbS0+dGFza19zaXplLCAmbm1hc2ssDQorCS8q
DQorCSAqIFRoaXMgZG9lcyBub3QgImNoZWNrIiB0aGUgcmFuZ2UgYnV0IGlzb2xhdGVzIGFsbCBw
YWdlcyB0aGF0DQorCSAqIG5lZWQgbWlncmF0aW9uLiAgQmV0d2VlbiBwYXNzaW5nIGluIHRoZSBm
dWxsIHVzZXIgYWRkcmVzcw0KKwkgKiBzcGFjZSByYW5nZSBhbmQgTVBPTF9NRl9ESVNDT05USUdf
T0ssIHRoaXMgY2FsbCBjYW4gbm90IGZhaWwuDQorCSAqLw0KKwlWTV9CVUdfT04oIShmbGFncyAm
IChNUE9MX01GX01PVkUgfCBNUE9MX01GX01PVkVfQUxMKSkpOw0KKwljaGVja19yYW5nZShtbSwg
bW0tPm1tYXAtPnZtX3N0YXJ0LCBtbS0+dGFza19zaXplLCAmbm1hc2ssDQogCQkJZmxhZ3MgfCBN
UE9MX01GX0RJU0NPTlRJR19PSywgJnBhZ2VsaXN0KTsNCi0JaWYgKElTX0VSUih2bWEpKQ0KLQkJ
cmV0dXJuIFBUUl9FUlIodm1hKTsNCiANCiAJaWYgKCFsaXN0X2VtcHR5KCZwYWdlbGlzdCkpIHsN
CiAJCWVyciA9IG1pZ3JhdGVfcGFnZXMoJnBhZ2VsaXN0LCBuZXdfbm9kZV9wYWdlLCBkZXN0LA0K
QEAgLTEwNTcsMTYgKzEwNTcsMTcgQEAgb3V0Og0KIA0KIC8qDQogICogQWxsb2NhdGUgYSBuZXcg
cGFnZSBmb3IgcGFnZSBtaWdyYXRpb24gYmFzZWQgb24gdm1hIHBvbGljeS4NCi0gKiBTdGFydCBh
c3N1bWluZyB0aGF0IHBhZ2UgaXMgbWFwcGVkIGJ5IHZtYSBwb2ludGVkIHRvIGJ5IEBwcml2YXRl
Lg0KKyAqIFN0YXJ0IGJ5IGFzc3VtaW5nIHRoZSBwYWdlIGlzIG1hcHBlZCBieSB0aGUgc2FtZSB2
bWEgYXMgY29udGFpbnMgQHN0YXJ0Lg0KICAqIFNlYXJjaCBmb3J3YXJkIGZyb20gdGhlcmUsIGlm
IG5vdC4gIE4uQi4sIHRoaXMgYXNzdW1lcyB0aGF0IHRoZQ0KICAqIGxpc3Qgb2YgcGFnZXMgaGFu
ZGVkIHRvIG1pZ3JhdGVfcGFnZXMoKS0td2hpY2ggaXMgaG93IHdlIGdldCBoZXJlLS0NCiAgKiBp
cyBpbiB2aXJ0dWFsIGFkZHJlc3Mgb3JkZXIuDQogICovDQotc3RhdGljIHN0cnVjdCBwYWdlICpu
ZXdfdm1hX3BhZ2Uoc3RydWN0IHBhZ2UgKnBhZ2UsIHVuc2lnbmVkIGxvbmcgcHJpdmF0ZSwgaW50
ICoqeCkNCitzdGF0aWMgc3RydWN0IHBhZ2UgKm5ld19wYWdlKHN0cnVjdCBwYWdlICpwYWdlLCB1
bnNpZ25lZCBsb25nIHN0YXJ0LCBpbnQgKip4KQ0KIHsNCi0Jc3RydWN0IHZtX2FyZWFfc3RydWN0
ICp2bWEgPSAoc3RydWN0IHZtX2FyZWFfc3RydWN0ICopcHJpdmF0ZTsNCisJc3RydWN0IHZtX2Fy
ZWFfc3RydWN0ICp2bWE7DQogCXVuc2lnbmVkIGxvbmcgdW5pbml0aWFsaXplZF92YXIoYWRkcmVz
cyk7DQogDQorCXZtYSA9IGZpbmRfdm1hKGN1cnJlbnQtPm1tLCBzdGFydCk7DQogCXdoaWxlICh2
bWEpIHsNCiAJCWFkZHJlc3MgPSBwYWdlX2FkZHJlc3NfaW5fdm1hKHBhZ2UsIHZtYSk7DQogCQlp
ZiAoYWRkcmVzcyAhPSAtRUZBVUxUKQ0KQEAgLTEwOTIsNyArMTA5Myw3IEBAIGludCBkb19taWdy
YXRlX3BhZ2VzKHN0cnVjdCBtbV9zdHJ1Y3QgKm1tLA0KIAlyZXR1cm4gLUVOT1NZUzsNCiB9DQog
DQotc3RhdGljIHN0cnVjdCBwYWdlICpuZXdfdm1hX3BhZ2Uoc3RydWN0IHBhZ2UgKnBhZ2UsIHVu
c2lnbmVkIGxvbmcgcHJpdmF0ZSwgaW50ICoqeCkNCitzdGF0aWMgc3RydWN0IHBhZ2UgKm5ld19w
YWdlKHN0cnVjdCBwYWdlICpwYWdlLCB1bnNpZ25lZCBsb25nIHN0YXJ0LCBpbnQgKip4KQ0KIHsN
CiAJcmV0dXJuIE5VTEw7DQogfQ0KQEAgLTExMDIsNyArMTEwMyw2IEBAIHN0YXRpYyBsb25nIGRv
X21iaW5kKHVuc2lnbmVkIGxvbmcgc3RhcnQsIHVuc2lnbmVkIGxvbmcgbGVuLA0KIAkJICAgICB1
bnNpZ25lZCBzaG9ydCBtb2RlLCB1bnNpZ25lZCBzaG9ydCBtb2RlX2ZsYWdzLA0KIAkJICAgICBu
b2RlbWFza190ICpubWFzaywgdW5zaWduZWQgbG9uZyBmbGFncykNCiB7DQotCXN0cnVjdCB2bV9h
cmVhX3N0cnVjdCAqdm1hOw0KIAlzdHJ1Y3QgbW1fc3RydWN0ICptbSA9IGN1cnJlbnQtPm1tOw0K
IAlzdHJ1Y3QgbWVtcG9saWN5ICpuZXc7DQogCXVuc2lnbmVkIGxvbmcgZW5kOw0KQEAgLTExNjYs
MTkgKzExNjYsMTYgQEAgc3RhdGljIGxvbmcgZG9fbWJpbmQodW5zaWduZWQgbG9uZyBzdGFydCwg
dW5zaWduZWQgbG9uZyBsZW4sDQogCWlmIChlcnIpDQogCQlnb3RvIG1wb2xfb3V0Ow0KIA0KLQl2
bWEgPSBjaGVja19yYW5nZShtbSwgc3RhcnQsIGVuZCwgbm1hc2ssDQorCWVyciA9IGNoZWNrX3Jh
bmdlKG1tLCBzdGFydCwgZW5kLCBubWFzaywNCiAJCQkgIGZsYWdzIHwgTVBPTF9NRl9JTlZFUlQs
ICZwYWdlbGlzdCk7DQotDQotCWVyciA9IFBUUl9FUlIodm1hKTsNCi0JaWYgKCFJU19FUlIodm1h
KSkgew0KKwlpZiAoIWVycikgew0KIAkJaW50IG5yX2ZhaWxlZCA9IDA7DQogDQogCQllcnIgPSBt
YmluZF9yYW5nZShtbSwgc3RhcnQsIGVuZCwgbmV3KTsNCiANCiAJCWlmICghbGlzdF9lbXB0eSgm
cGFnZWxpc3QpKSB7DQotCQkJbnJfZmFpbGVkID0gbWlncmF0ZV9wYWdlcygmcGFnZWxpc3QsIG5l
d192bWFfcGFnZSwNCi0JCQkJCQkodW5zaWduZWQgbG9uZyl2bWEsDQotCQkJCQkJZmFsc2UsIHRy
dWUpOw0KKwkJCW5yX2ZhaWxlZCA9IG1pZ3JhdGVfcGFnZXMoJnBhZ2VsaXN0LCBuZXdfcGFnZSwN
CisJCQkJCQlzdGFydCwgZmFsc2UsIHRydWUpOw0KIAkJCWlmIChucl9mYWlsZWQpDQogCQkJCXB1
dGJhY2tfbHJ1X3BhZ2VzKCZwYWdlbGlzdCk7DQogCQl9DQpkaWZmIC0tZ2l0IGEvbW0vcm1hcC5j
IGIvbW0vcm1hcC5jDQppbmRleCA5YWM0MDViLi5mM2Y2ZmQzIDEwMDY0NA0KLS0tIGEvbW0vcm1h
cC5jDQorKysgYi9tbS9ybWFwLmMNCkBAIC0xMDMsNiArMTAzLDcgQEAgc3RhdGljIGlubGluZSB2
b2lkIGFub25fdm1hX2ZyZWUoc3RydWN0IGFub25fdm1hICphbm9uX3ZtYSkNCiAJICogTE9DSyBz
aG91bGQgc3VmZmljZSBzaW5jZSB0aGUgYWN0dWFsIHRha2luZyBvZiB0aGUgbG9jayBtdXN0DQog
CSAqIGhhcHBlbiBfYmVmb3JlXyB3aGF0IGZvbGxvd3MuDQogCSAqLw0KKwltaWdodF9zbGVlcCgp
Ow0KIAlpZiAobXV0ZXhfaXNfbG9ja2VkKCZhbm9uX3ZtYS0+cm9vdC0+bXV0ZXgpKSB7DQogCQlh
bm9uX3ZtYV9sb2NrKGFub25fdm1hKTsNCiAJCWFub25fdm1hX3VubG9jayhhbm9uX3ZtYSk7DQpA
QCAtNDM0LDggKzQzNSw5IEBAIHN0cnVjdCBhbm9uX3ZtYSAqcGFnZV9nZXRfYW5vbl92bWEoc3Ry
dWN0IHBhZ2UgKnBhZ2UpDQogCSAqIGFib3ZlIGNhbm5vdCBjb3JydXB0KS4NCiAJICovDQogCWlm
ICghcGFnZV9tYXBwZWQocGFnZSkpIHsNCisJCXJjdV9yZWFkX3VubG9jaygpOw0KIAkJcHV0X2Fu
b25fdm1hKGFub25fdm1hKTsNCi0JCWFub25fdm1hID0gTlVMTDsNCisJCXJldHVybiBOVUxMOw0K
IAl9DQogb3V0Og0KIAlyY3VfcmVhZF91bmxvY2soKTsNCkBAIC00ODUsOSArNDg3LDkgQEAgc3Ry
dWN0IGFub25fdm1hICpwYWdlX2xvY2tfYW5vbl92bWEoc3RydWN0IHBhZ2UgKnBhZ2UpDQogCX0N
CiANCiAJaWYgKCFwYWdlX21hcHBlZChwYWdlKSkgew0KKwkJcmN1X3JlYWRfdW5sb2NrKCk7DQog
CQlwdXRfYW5vbl92bWEoYW5vbl92bWEpOw0KLQkJYW5vbl92bWEgPSBOVUxMOw0KLQkJZ290byBv
dXQ7DQorCQlyZXR1cm4gTlVMTDsNCiAJfQ0KIA0KIAkvKiB3ZSBwaW5uZWQgdGhlIGFub25fdm1h
LCBpdHMgc2FmZSB0byBzbGVlcCAqLw0KQEAgLTE2NjksMTAgKzE2NzEsOSBAQCB2b2lkIF9fcHV0
X2Fub25fdm1hKHN0cnVjdCBhbm9uX3ZtYSAqYW5vbl92bWEpDQogew0KIAlzdHJ1Y3QgYW5vbl92
bWEgKnJvb3QgPSBhbm9uX3ZtYS0+cm9vdDsNCiANCisJYW5vbl92bWFfZnJlZShhbm9uX3ZtYSk7
DQogCWlmIChyb290ICE9IGFub25fdm1hICYmIGF0b21pY19kZWNfYW5kX3Rlc3QoJnJvb3QtPnJl
ZmNvdW50KSkNCiAJCWFub25fdm1hX2ZyZWUocm9vdCk7DQotDQotCWFub25fdm1hX2ZyZWUoYW5v
bl92bWEpOw0KIH0NCiANCiAjaWZkZWYgQ09ORklHX01JR1JBVElPTg0KZGlmZiAtLWdpdCBhL21t
L3Ztc2Nhbi5jIGIvbW0vdm1zY2FuLmMNCmluZGV4IDMxMzM4MWMuLmFiOThkYzYgMTAwNjQ0DQot
LS0gYS9tbS92bXNjYW4uYw0KKysrIGIvbW0vdm1zY2FuLmMNCkBAIC0zMDE2LDcgKzMwMTYsMTAg
QEAgc3RhdGljIGludCBrc3dhcGQodm9pZCAqcCkNCiAJCX0NCiAJfQ0KIA0KKwl0c2stPmZsYWdz
ICY9IH4oUEZfTUVNQUxMT0MgfCBQRl9TV0FQV1JJVEUgfCBQRl9LU1dBUEQpOw0KIAljdXJyZW50
LT5yZWNsYWltX3N0YXRlID0gTlVMTDsNCisJbG9ja2RlcF9jbGVhcl9jdXJyZW50X3JlY2xhaW1f
c3RhdGUoKTsNCisNCiAJcmV0dXJuIDA7DQogfQ0KIA0KZGlmZiAtLWdpdCBhL25ldC9ibHVldG9v
dGgvaGNpX2Nvbm4uYyBiL25ldC9ibHVldG9vdGgvaGNpX2Nvbm4uYw0KaW5kZXggNGQ5OWQ0Mi4u
ZjQ1NjY0NSAxMDA2NDQNCi0tLSBhL25ldC9ibHVldG9vdGgvaGNpX2Nvbm4uYw0KKysrIGIvbmV0
L2JsdWV0b290aC9oY2lfY29ubi5jDQpAQCAtNjE3LDcgKzYxNyw3IEBAIHN0YXRpYyBpbnQgaGNp
X2Nvbm5fYXV0aChzdHJ1Y3QgaGNpX2Nvbm4gKmNvbm4sIF9fdTggc2VjX2xldmVsLCBfX3U4IGF1
dGhfdHlwZSkNCiAJCS8qIElmIHdlJ3JlIGFscmVhZHkgZW5jcnlwdGVkIHNldCB0aGUgUkVBVVRI
X1BFTkQgZmxhZywNCiAJCSAqIG90aGVyd2lzZSBzZXQgdGhlIEVOQ1JZUFRfUEVORC4NCiAJCSAq
Lw0KLQkJaWYgKGNvbm4tPmtleV90eXBlICE9IDB4ZmYpDQorCQlpZiAoY29ubi0+bGlua19tb2Rl
ICYgSENJX0xNX0VOQ1JZUFQpDQogCQkJc2V0X2JpdChIQ0lfQ09OTl9SRUFVVEhfUEVORCwgJmNv
bm4tPnBlbmQpOw0KIAkJZWxzZQ0KIAkJCXNldF9iaXQoSENJX0NPTk5fRU5DUllQVF9QRU5ELCAm
Y29ubi0+cGVuZCk7DQpkaWZmIC0tZ2l0IGEvbmV0L2JsdWV0b290aC9oY2lfZXZlbnQuYyBiL25l
dC9ibHVldG9vdGgvaGNpX2V2ZW50LmMNCmluZGV4IDdhMTU3YjMuLmQ5OTA3NWEgMTAwNjQ0DQot
LS0gYS9uZXQvYmx1ZXRvb3RoL2hjaV9ldmVudC5jDQorKysgYi9uZXQvYmx1ZXRvb3RoL2hjaV9l
dmVudC5jDQpAQCAtMjY5MCw4ICsyNjkwLDExIEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBoY2lfdXNl
cl9jb25maXJtX3JlcXVlc3RfZXZ0KHN0cnVjdCBoY2lfZGV2ICpoZGV2LA0KIA0KIAkJLyogSWYg
d2UncmUgbm90IHRoZSBpbml0aWF0b3JzIHJlcXVlc3QgYXV0aG9yaXphdGlvbiB0bw0KIAkJICog
cHJvY2VlZCBmcm9tIHVzZXIgc3BhY2UgKG1nbXRfdXNlcl9jb25maXJtIHdpdGgNCi0JCSAqIGNv
bmZpcm1faGludCBzZXQgdG8gMSkuICovDQotCQlpZiAoIXRlc3RfYml0KEhDSV9DT05OX0FVVEhf
UEVORCwgJmNvbm4tPnBlbmQpKSB7DQorCQkgKiBjb25maXJtX2hpbnQgc2V0IHRvIDEpLiBUaGUg
ZXhjZXB0aW9uIGlzIGlmIG5laXRoZXINCisJCSAqIHNpZGUgaGFkIE1JVE0gaW4gd2hpY2ggY2Fz
ZSB3ZSBkbyBhdXRvLWFjY2VwdC4NCisJCSAqLw0KKwkJaWYgKCF0ZXN0X2JpdChIQ0lfQ09OTl9B
VVRIX1BFTkQsICZjb25uLT5wZW5kKSAmJg0KKwkJICAgIChsb2NfbWl0bSB8fCByZW1fbWl0bSkp
IHsNCiAJCQlCVF9EQkcoIkNvbmZpcm1pbmcgYXV0by1hY2NlcHQgYXMgYWNjZXB0b3IiKTsNCiAJ
CQljb25maXJtX2hpbnQgPSAxOw0KIAkJCWdvdG8gY29uZmlybTsNCmRpZmYgLS1naXQgYS9uZXQv
Y29yZS9za2J1ZmYuYyBiL25ldC9jb3JlL3NrYnVmZi5jDQppbmRleCA5MjA0ZDliLi43MTIxZDli
IDEwMDY0NA0KLS0tIGEvbmV0L2NvcmUvc2tidWZmLmMNCisrKyBiL25ldC9jb3JlL3NrYnVmZi5j
DQpAQCAtNjU1LDcgKzY1NSw3IEBAIGludCBza2JfY29weV91YnVmcyhzdHJ1Y3Qgc2tfYnVmZiAq
c2tiLCBnZnBfdCBnZnBfbWFzaykNCiAJc2tiX3NoaW5mbyhza2IpLT50eF9mbGFncyAmPSB+U0tC
VFhfREVWX1pFUk9DT1BZOw0KIAlyZXR1cm4gMDsNCiB9DQotDQorRVhQT1JUX1NZTUJPTF9HUEwo
c2tiX2NvcHlfdWJ1ZnMpOw0KIA0KIC8qKg0KICAqCXNrYl9jbG9uZQktCWR1cGxpY2F0ZSBhbiBz
a19idWZmDQpAQCAtMjY5OCw2ICsyNjk4LDkgQEAgc3RydWN0IHNrX2J1ZmYgKnNrYl9zZWdtZW50
KHN0cnVjdCBza19idWZmICpza2IsIHUzMiBmZWF0dXJlcykNCiAJCQkJCQkgc2tiX3B1dChuc2ti
LCBoc2l6ZSksIGhzaXplKTsNCiANCiAJCXdoaWxlIChwb3MgPCBvZmZzZXQgKyBsZW4gJiYgaSA8
IG5mcmFncykgew0KKwkJCWlmICh1bmxpa2VseShza2Jfb3JwaGFuX2ZyYWdzKHNrYiwgR0ZQX0FU
T01JQykpKQ0KKwkJCQlnb3RvIGVycjsNCisNCiAJCQkqZnJhZyA9IHNrYl9zaGluZm8oc2tiKS0+
ZnJhZ3NbaV07DQogCQkJX19za2JfZnJhZ19yZWYoZnJhZyk7DQogCQkJc2l6ZSA9IHNrYl9mcmFn
X3NpemUoZnJhZyk7DQpkaWZmIC0tZ2l0IGEvbmV0L2lwdjQvaXBpcC5jIGIvbmV0L2lwdjQvaXBp
cC5jDQppbmRleCA1ZGM1MTM3Li43Y2U2ZDlmIDEwMDY0NA0KLS0tIGEvbmV0L2lwdjQvaXBpcC5j
DQorKysgYi9uZXQvaXB2NC9pcGlwLmMNCkBAIC05MDksNCArOTA5LDUgQEAgc3RhdGljIHZvaWQg
X19leGl0IGlwaXBfZmluaSh2b2lkKQ0KIG1vZHVsZV9pbml0KGlwaXBfaW5pdCk7DQogbW9kdWxl
X2V4aXQoaXBpcF9maW5pKTsNCiBNT0RVTEVfTElDRU5TRSgiR1BMIik7DQorTU9EVUxFX0FMSUFT
X1JUTkxfTElOSygiaXBpcCIpOw0KIE1PRFVMRV9BTElBU19ORVRERVYoInR1bmwwIik7DQpkaWZm
IC0tZ2l0IGEvbmV0L2lwdjYvaXA2X291dHB1dC5jIGIvbmV0L2lwdjYvaXA2X291dHB1dC5jDQpp
bmRleCA3ODcxY2M2Li4xNDc1M2QzIDEwMDY0NA0KLS0tIGEvbmV0L2lwdjYvaXA2X291dHB1dC5j
DQorKysgYi9uZXQvaXB2Ni9pcDZfb3V0cHV0LmMNCkBAIC02MTIsNyArNjEyLDcgQEAgaW50IGlw
Nl9maW5kXzFzdGZyYWdvcHQoc3RydWN0IHNrX2J1ZmYgKnNrYiwgdTggKipuZXh0aGRyKQ0KIHZv
aWQgaXB2Nl9zZWxlY3RfaWRlbnQoc3RydWN0IGZyYWdfaGRyICpmaGRyLCBzdHJ1Y3QgcnQ2X2lu
Zm8gKnJ0KQ0KIHsNCiAJc3RhdGljIGF0b21pY190IGlwdjZfZnJhZ21lbnRhdGlvbl9pZDsNCi0J
aW50IG9sZCwgbmV3Ow0KKwlpbnQgaWRlbnQ7DQogDQogCWlmIChydCAmJiAhKHJ0LT5kc3QuZmxh
Z3MgJiBEU1RfTk9QRUVSKSkgew0KIAkJc3RydWN0IGluZXRfcGVlciAqcGVlcjsNCkBAIC02MjUs
MTMgKzYyNSw4IEBAIHZvaWQgaXB2Nl9zZWxlY3RfaWRlbnQoc3RydWN0IGZyYWdfaGRyICpmaGRy
LCBzdHJ1Y3QgcnQ2X2luZm8gKnJ0KQ0KIAkJCXJldHVybjsNCiAJCX0NCiAJfQ0KLQlkbyB7DQot
CQlvbGQgPSBhdG9taWNfcmVhZCgmaXB2Nl9mcmFnbWVudGF0aW9uX2lkKTsNCi0JCW5ldyA9IG9s
ZCArIDE7DQotCQlpZiAoIW5ldykNCi0JCQluZXcgPSAxOw0KLQl9IHdoaWxlIChhdG9taWNfY21w
eGNoZygmaXB2Nl9mcmFnbWVudGF0aW9uX2lkLCBvbGQsIG5ldykgIT0gb2xkKTsNCi0JZmhkci0+
aWRlbnRpZmljYXRpb24gPSBodG9ubChuZXcpOw0KKwlpZGVudCA9IGF0b21pY19pbmNfcmV0dXJu
KCZpcHY2X2ZyYWdtZW50YXRpb25faWQpOw0KKwlmaGRyLT5pZGVudGlmaWNhdGlvbiA9IGh0b25s
KGlkZW50KTsNCiB9DQogDQogaW50IGlwNl9mcmFnbWVudChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBp
bnQgKCpvdXRwdXQpKHN0cnVjdCBza19idWZmICopKQ0KZGlmZiAtLWdpdCBhL25ldC9pcHY2L2lw
Nl90dW5uZWwuYyBiL25ldC9pcHY2L2lwNl90dW5uZWwuYw0KaW5kZXggZDE5ZjQ5OS4uYWUzMmZm
NyAxMDA2NDQNCi0tLSBhL25ldC9pcHY2L2lwNl90dW5uZWwuYw0KKysrIGIvbmV0L2lwdjYvaXA2
X3R1bm5lbC5jDQpAQCAtNTcsNiArNTcsNyBAQA0KIE1PRFVMRV9BVVRIT1IoIlZpbGxlIE51b3J2
YWxhIik7DQogTU9EVUxFX0RFU0NSSVBUSU9OKCJJUHY2IHR1bm5lbGluZyBkZXZpY2UiKTsNCiBN
T0RVTEVfTElDRU5TRSgiR1BMIik7DQorTU9EVUxFX0FMSUFTX1JUTkxfTElOSygiaXA2dG5sIik7
DQogTU9EVUxFX0FMSUFTX05FVERFVigiaXA2dG5sMCIpOw0KIA0KICNpZmRlZiBJUDZfVE5MX0RF
QlVHDQpkaWZmIC0tZ2l0IGEvbmV0L2lwdjYvc2l0LmMgYi9uZXQvaXB2Ni9zaXQuYw0KaW5kZXgg
NzJhOTM5ZC4uNTJjZTE5NiAxMDA2NDQNCi0tLSBhL25ldC9pcHY2L3NpdC5jDQorKysgYi9uZXQv
aXB2Ni9zaXQuYw0KQEAgLTEyOTMsNCArMTI5Myw1IEBAIHN0YXRpYyBpbnQgX19pbml0IHNpdF9p
bml0KHZvaWQpDQogbW9kdWxlX2luaXQoc2l0X2luaXQpOw0KIG1vZHVsZV9leGl0KHNpdF9jbGVh
bnVwKTsNCiBNT0RVTEVfTElDRU5TRSgiR1BMIik7DQorTU9EVUxFX0FMSUFTX1JUTkxfTElOSygi
c2l0Iik7DQogTU9EVUxFX0FMSUFTX05FVERFVigic2l0MCIpOw0KZGlmZiAtLWdpdCBhL25ldC9t
YWM4MDIxMS9kZWJ1Z2ZzX25ldGRldi5jIGIvbmV0L21hYzgwMjExL2RlYnVnZnNfbmV0ZGV2LmMN
CmluZGV4IDkzNTI4MTkuLjg4MGE1NWQgMTAwNjQ0DQotLS0gYS9uZXQvbWFjODAyMTEvZGVidWdm
c19uZXRkZXYuYw0KKysrIGIvbmV0L21hYzgwMjExL2RlYnVnZnNfbmV0ZGV2LmMNCkBAIC0zMyw4
ICszMyw3IEBAIHN0YXRpYyBzc2l6ZV90IGllZWU4MDIxMV9pZl9yZWFkKA0KIAlzc2l6ZV90IHJl
dCA9IC1FSU5WQUw7DQogDQogCXJlYWRfbG9jaygmZGV2X2Jhc2VfbG9jayk7DQotCWlmIChzZGF0
YS0+ZGV2LT5yZWdfc3RhdGUgPT0gTkVUUkVHX1JFR0lTVEVSRUQpDQotCQlyZXQgPSAoKmZvcm1h
dCkoc2RhdGEsIGJ1Ziwgc2l6ZW9mKGJ1ZikpOw0KKwlyZXQgPSAoKmZvcm1hdCkoc2RhdGEsIGJ1
Ziwgc2l6ZW9mKGJ1ZikpOw0KIAlyZWFkX3VubG9jaygmZGV2X2Jhc2VfbG9jayk7DQogDQogCWlm
IChyZXQgPj0gMCkNCkBAIC02Miw4ICs2MSw3IEBAIHN0YXRpYyBzc2l6ZV90IGllZWU4MDIxMV9p
Zl93cml0ZSgNCiANCiAJcmV0ID0gLUVOT0RFVjsNCiAJcnRubF9sb2NrKCk7DQotCWlmIChzZGF0
YS0+ZGV2LT5yZWdfc3RhdGUgPT0gTkVUUkVHX1JFR0lTVEVSRUQpDQotCQlyZXQgPSAoKndyaXRl
KShzZGF0YSwgYnVmLCBjb3VudCk7DQorCXJldCA9ICgqd3JpdGUpKHNkYXRhLCBidWYsIGNvdW50
KTsNCiAJcnRubF91bmxvY2soKTsNCiANCiBmcmVlYnVmOg0KZGlmZiAtLWdpdCBhL25ldC9tYWM4
MDIxMS9pYnNzLmMgYi9uZXQvbWFjODAyMTEvaWJzcy5jDQppbmRleCA5ZTIwY2I4Li4xYzAxOGQx
IDEwMDY0NA0KLS0tIGEvbmV0L21hYzgwMjExL2lic3MuYw0KKysrIGIvbmV0L21hYzgwMjExL2li
c3MuYw0KQEAgLTkxNCw2ICs5MTQsNyBAQCBpbnQgaWVlZTgwMjExX2lic3Nfam9pbihzdHJ1Y3Qg
aWVlZTgwMjExX3N1Yl9pZl9kYXRhICpzZGF0YSwNCiANCiAJc2RhdGEtPnUuaWJzcy5wcml2YWN5
ID0gcGFyYW1zLT5wcml2YWN5Ow0KIAlzZGF0YS0+dS5pYnNzLmJhc2ljX3JhdGVzID0gcGFyYW1z
LT5iYXNpY19yYXRlczsNCisJc2RhdGEtPnUuaWJzcy5sYXN0X3NjYW5fY29tcGxldGVkID0gamlm
ZmllczsNCiAJbWVtY3B5KHNkYXRhLT52aWYuYnNzX2NvbmYubWNhc3RfcmF0ZSwgcGFyYW1zLT5t
Y2FzdF9yYXRlLA0KIAkgICAgICAgc2l6ZW9mKHBhcmFtcy0+bWNhc3RfcmF0ZSkpOw0KIA0KZGlm
ZiAtLWdpdCBhL25ldC9zY3RwL2Fzc29jaW9sYS5jIGIvbmV0L3NjdHAvYXNzb2Npb2xhLmMNCmlu
ZGV4IDNjMDQ2OTIuLjI1YjIwN2IgMTAwNjQ0DQotLS0gYS9uZXQvc2N0cC9hc3NvY2lvbGEuYw0K
KysrIGIvbmV0L3NjdHAvYXNzb2Npb2xhLmMNCkBAIC0zODksNyArMzg5LDcgQEAgdm9pZCBzY3Rw
X2Fzc29jaWF0aW9uX2ZyZWUoc3RydWN0IHNjdHBfYXNzb2NpYXRpb24gKmFzb2MpDQogCS8qIE9u
bHkgcmVhbCBhc3NvY2lhdGlvbnMgY291bnQgYWdhaW5zdCB0aGUgZW5kcG9pbnQsIHNvDQogCSAq
IGRvbid0IGJvdGhlciBmb3IgaWYgdGhpcyBpcyBhIHRlbXBvcmFyeSBhc3NvY2lhdGlvbi4NCiAJ
ICovDQotCWlmICghYXNvYy0+dGVtcCkgew0KKwlpZiAoIWxpc3RfZW1wdHkoJmFzb2MtPmFzb2Nz
KSkgew0KIAkJbGlzdF9kZWwoJmFzb2MtPmFzb2NzKTsNCiANCiAJCS8qIERlY3JlbWVudCB0aGUg
YmFja2xvZyB2YWx1ZSBmb3IgYSBUQ1Atc3R5bGUgbGlzdGVuaW5nDQpkaWZmIC0tZ2l0IGEvc2Ny
aXB0cy9yZWNvcmRtY291bnQuaCBiL3NjcmlwdHMvcmVjb3JkbWNvdW50LmgNCmluZGV4IDU0ZTM1
YzEuLjVlMjk2MTAgMTAwNjQ0DQotLS0gYS9zY3JpcHRzL3JlY29yZG1jb3VudC5oDQorKysgYi9z
Y3JpcHRzL3JlY29yZG1jb3VudC5oDQpAQCAtMTYzLDExICsxNjMsMTEgQEAgc3RhdGljIGludCBt
Y291bnRfYWRqdXN0ID0gMDsNCiANCiBzdGF0aWMgaW50IE1JUFNfaXNfZmFrZV9tY291bnQoRWxm
X1JlbCBjb25zdCAqcnApDQogew0KLQlzdGF0aWMgRWxmX0FkZHIgb2xkX3Jfb2Zmc2V0Ow0KKwlz
dGF0aWMgRWxmX0FkZHIgb2xkX3Jfb2Zmc2V0ID0gfihFbGZfQWRkcikwOw0KIAlFbGZfQWRkciBj
dXJyZW50X3Jfb2Zmc2V0ID0gX3cocnAtPnJfb2Zmc2V0KTsNCiAJaW50IGlzX2Zha2U7DQogDQot
CWlzX2Zha2UgPSBvbGRfcl9vZmZzZXQgJiYNCisJaXNfZmFrZSA9IChvbGRfcl9vZmZzZXQgIT0g
fihFbGZfQWRkcikwKSAmJg0KIAkJKGN1cnJlbnRfcl9vZmZzZXQgLSBvbGRfcl9vZmZzZXQgPT0g
TUlQU19GQUtFTUNPVU5UX09GRlNFVCk7DQogCW9sZF9yX29mZnNldCA9IGN1cnJlbnRfcl9vZmZz
ZXQ7DQogDQpkaWZmIC0tZ2l0IGEvc2VjdXJpdHkvaW50ZWdyaXR5L2V2bS9ldm1fbWFpbi5jIGIv
c2VjdXJpdHkvaW50ZWdyaXR5L2V2bS9ldm1fbWFpbi5jDQppbmRleCA5MmQzZDk5Li4zNDM5ODcy
IDEwMDY0NA0KLS0tIGEvc2VjdXJpdHkvaW50ZWdyaXR5L2V2bS9ldm1fbWFpbi5jDQorKysgYi9z
ZWN1cml0eS9pbnRlZ3JpdHkvZXZtL2V2bV9tYWluLmMNCkBAIC0yMDcsMTIgKzIwNywyMCBAQCBz
dGF0aWMgaW50IGV2bV9wcm90ZWN0X3hhdHRyKHN0cnVjdCBkZW50cnkgKmRlbnRyeSwgY29uc3Qg
Y2hhciAqeGF0dHJfbmFtZSwNCiAgKiBAeGF0dHJfdmFsdWU6IHBvaW50ZXIgdG8gdGhlIG5ldyBl
eHRlbmRlZCBhdHRyaWJ1dGUgdmFsdWUNCiAgKiBAeGF0dHJfdmFsdWVfbGVuOiBwb2ludGVyIHRv
IHRoZSBuZXcgZXh0ZW5kZWQgYXR0cmlidXRlIHZhbHVlIGxlbmd0aA0KICAqDQotICogVXBkYXRp
bmcgJ3NlY3VyaXR5LmV2bScgcmVxdWlyZXMgQ0FQX1NZU19BRE1JTiBwcml2aWxlZ2VzIGFuZCB0
aGF0DQotICogdGhlIGN1cnJlbnQgdmFsdWUgaXMgdmFsaWQuDQorICogQmVmb3JlIGFsbG93aW5n
IHRoZSAnc2VjdXJpdHkuZXZtJyBwcm90ZWN0ZWQgeGF0dHIgdG8gYmUgdXBkYXRlZCwNCisgKiB2
ZXJpZnkgdGhlIGV4aXN0aW5nIHZhbHVlIGlzIHZhbGlkLiAgQXMgb25seSB0aGUga2VybmVsIHNo
b3VsZCBoYXZlDQorICogYWNjZXNzIHRvIHRoZSBFVk0gZW5jcnlwdGVkIGtleSBuZWVkZWQgdG8g
Y2FsY3VsYXRlIHRoZSBITUFDLCBwcmV2ZW50DQorICogdXNlcnNwYWNlIGZyb20gd3JpdGluZyBI
TUFDIHZhbHVlLiAgV3JpdGluZyAnc2VjdXJpdHkuZXZtJyByZXF1aXJlcw0KKyAqIHJlcXVpcmVz
IENBUF9TWVNfQURNSU4gcHJpdmlsZWdlcy4NCiAgKi8NCiBpbnQgZXZtX2lub2RlX3NldHhhdHRy
KHN0cnVjdCBkZW50cnkgKmRlbnRyeSwgY29uc3QgY2hhciAqeGF0dHJfbmFtZSwNCiAJCSAgICAg
ICBjb25zdCB2b2lkICp4YXR0cl92YWx1ZSwgc2l6ZV90IHhhdHRyX3ZhbHVlX2xlbikNCiB7DQor
CWNvbnN0IHN0cnVjdCBldm1faW1hX3hhdHRyX2RhdGEgKnhhdHRyX2RhdGEgPSB4YXR0cl92YWx1
ZTsNCisNCisJaWYgKChzdHJjbXAoeGF0dHJfbmFtZSwgWEFUVFJfTkFNRV9FVk0pID09IDApDQor
CSAgICAmJiAoeGF0dHJfZGF0YS0+dHlwZSA9PSBFVk1fWEFUVFJfSE1BQykpDQorCQlyZXR1cm4g
LUVQRVJNOw0KIAlyZXR1cm4gZXZtX3Byb3RlY3RfeGF0dHIoZGVudHJ5LCB4YXR0cl9uYW1lLCB4
YXR0cl92YWx1ZSwNCiAJCQkJIHhhdHRyX3ZhbHVlX2xlbik7DQogfQ0KZGlmZiAtLWdpdCBhL3Nv
dW5kL2NvcmUvY29udHJvbC5jIGIvc291bmQvY29yZS9jb250cm9sLmMNCmluZGV4IDU1MTEzMDcu
LjkyMTA1OTQgMTAwNjQ0DQotLS0gYS9zb3VuZC9jb3JlL2NvbnRyb2wuYw0KKysrIGIvc291bmQv
Y29yZS9jb250cm9sLmMNCkBAIC0yODgsNiArMjg4LDEwIEBAIHN0YXRpYyBib29sIHNuZF9jdGxf
cmVtb3ZlX251bWlkX2NvbmZsaWN0KHN0cnVjdCBzbmRfY2FyZCAqY2FyZCwNCiB7DQogCXN0cnVj
dCBzbmRfa2NvbnRyb2wgKmtjdGw7DQogDQorCS8qIE1ha2Ugc3VyZSB0aGF0IHRoZSBpZHMgYXNz
aWduZWQgdG8gdGhlIGNvbnRyb2wgZG8gbm90IHdyYXAgYXJvdW5kICovDQorCWlmIChjYXJkLT5s
YXN0X251bWlkID49IFVJTlRfTUFYIC0gY291bnQpDQorCQljYXJkLT5sYXN0X251bWlkID0gMDsN
CisNCiAJbGlzdF9mb3JfZWFjaF9lbnRyeShrY3RsLCAmY2FyZC0+Y29udHJvbHMsIGxpc3QpIHsN
CiAJCWlmIChrY3RsLT5pZC5udW1pZCA8IGNhcmQtPmxhc3RfbnVtaWQgKyAxICsgY291bnQgJiYN
CiAJCSAgICBrY3RsLT5pZC5udW1pZCArIGtjdGwtPmNvdW50ID4gY2FyZC0+bGFzdF9udW1pZCAr
IDEpIHsNCkBAIC0zMjksNiArMzMzLDcgQEAgaW50IHNuZF9jdGxfYWRkKHN0cnVjdCBzbmRfY2Fy
ZCAqY2FyZCwgc3RydWN0IHNuZF9rY29udHJvbCAqa2NvbnRyb2wpDQogew0KIAlzdHJ1Y3Qgc25k
X2N0bF9lbGVtX2lkIGlkOw0KIAl1bnNpZ25lZCBpbnQgaWR4Ow0KKwl1bnNpZ25lZCBpbnQgY291
bnQ7DQogCWludCBlcnIgPSAtRUlOVkFMOw0KIA0KIAlpZiAoISBrY29udHJvbCkNCkBAIC0zMzYs
NiArMzQxLDkgQEAgaW50IHNuZF9jdGxfYWRkKHN0cnVjdCBzbmRfY2FyZCAqY2FyZCwgc3RydWN0
IHNuZF9rY29udHJvbCAqa2NvbnRyb2wpDQogCWlmIChzbmRfQlVHX09OKCFjYXJkIHx8ICFrY29u
dHJvbC0+aW5mbykpDQogCQlnb3RvIGVycm9yOw0KIAlpZCA9IGtjb250cm9sLT5pZDsNCisJaWYg
KGlkLmluZGV4ID4gVUlOVF9NQVggLSBrY29udHJvbC0+Y291bnQpDQorCQlnb3RvIGVycm9yOw0K
Kw0KIAlkb3duX3dyaXRlKCZjYXJkLT5jb250cm9sc19yd3NlbSk7DQogCWlmIChzbmRfY3RsX2Zp
bmRfaWQoY2FyZCwgJmlkKSkgew0KIAkJdXBfd3JpdGUoJmNhcmQtPmNvbnRyb2xzX3J3c2VtKTsN
CkBAIC0zNTcsOCArMzY1LDkgQEAgaW50IHNuZF9jdGxfYWRkKHN0cnVjdCBzbmRfY2FyZCAqY2Fy
ZCwgc3RydWN0IHNuZF9rY29udHJvbCAqa2NvbnRyb2wpDQogCWNhcmQtPmNvbnRyb2xzX2NvdW50
ICs9IGtjb250cm9sLT5jb3VudDsNCiAJa2NvbnRyb2wtPmlkLm51bWlkID0gY2FyZC0+bGFzdF9u
dW1pZCArIDE7DQogCWNhcmQtPmxhc3RfbnVtaWQgKz0ga2NvbnRyb2wtPmNvdW50Ow0KKwljb3Vu
dCA9IGtjb250cm9sLT5jb3VudDsNCiAJdXBfd3JpdGUoJmNhcmQtPmNvbnRyb2xzX3J3c2VtKTsN
Ci0JZm9yIChpZHggPSAwOyBpZHggPCBrY29udHJvbC0+Y291bnQ7IGlkeCsrLCBpZC5pbmRleCsr
LCBpZC5udW1pZCsrKQ0KKwlmb3IgKGlkeCA9IDA7IGlkeCA8IGNvdW50OyBpZHgrKywgaWQuaW5k
ZXgrKywgaWQubnVtaWQrKykNCiAJCXNuZF9jdGxfbm90aWZ5KGNhcmQsIFNORFJWX0NUTF9FVkVO
VF9NQVNLX0FERCwgJmlkKTsNCiAJcmV0dXJuIDA7DQogDQpAQCAtMzg3LDYgKzM5Niw3IEBAIGlu
dCBzbmRfY3RsX3JlcGxhY2Uoc3RydWN0IHNuZF9jYXJkICpjYXJkLCBzdHJ1Y3Qgc25kX2tjb250
cm9sICprY29udHJvbCwNCiAJCSAgICBib29sIGFkZF9vbl9yZXBsYWNlKQ0KIHsNCiAJc3RydWN0
IHNuZF9jdGxfZWxlbV9pZCBpZDsNCisJdW5zaWduZWQgaW50IGNvdW50Ow0KIAl1bnNpZ25lZCBp
bnQgaWR4Ow0KIAlzdHJ1Y3Qgc25kX2tjb250cm9sICpvbGQ7DQogCWludCByZXQ7DQpAQCAtNDIy
LDggKzQzMiw5IEBAIGFkZDoNCiAJY2FyZC0+Y29udHJvbHNfY291bnQgKz0ga2NvbnRyb2wtPmNv
dW50Ow0KIAlrY29udHJvbC0+aWQubnVtaWQgPSBjYXJkLT5sYXN0X251bWlkICsgMTsNCiAJY2Fy
ZC0+bGFzdF9udW1pZCArPSBrY29udHJvbC0+Y291bnQ7DQorCWNvdW50ID0ga2NvbnRyb2wtPmNv
dW50Ow0KIAl1cF93cml0ZSgmY2FyZC0+Y29udHJvbHNfcndzZW0pOw0KLQlmb3IgKGlkeCA9IDA7
IGlkeCA8IGtjb250cm9sLT5jb3VudDsgaWR4KyssIGlkLmluZGV4KyssIGlkLm51bWlkKyspDQor
CWZvciAoaWR4ID0gMDsgaWR4IDwgY291bnQ7IGlkeCsrLCBpZC5pbmRleCsrLCBpZC5udW1pZCsr
KQ0KIAkJc25kX2N0bF9ub3RpZnkoY2FyZCwgU05EUlZfQ1RMX0VWRU5UX01BU0tfQURELCAmaWQp
Ow0KIAlyZXR1cm4gMDsNCiANCkBAIC04OTQsOSArOTA1LDkgQEAgc3RhdGljIGludCBzbmRfY3Rs
X2VsZW1fd3JpdGUoc3RydWN0IHNuZF9jYXJkICpjYXJkLCBzdHJ1Y3Qgc25kX2N0bF9maWxlICpm
aWxlLA0KIAkJCXJlc3VsdCA9IGtjdGwtPnB1dChrY3RsLCBjb250cm9sKTsNCiAJCX0NCiAJCWlm
IChyZXN1bHQgPiAwKSB7DQorCQkJc3RydWN0IHNuZF9jdGxfZWxlbV9pZCBpZCA9IGNvbnRyb2wt
PmlkOw0KIAkJCXVwX3JlYWQoJmNhcmQtPmNvbnRyb2xzX3J3c2VtKTsNCi0JCQlzbmRfY3RsX25v
dGlmeShjYXJkLCBTTkRSVl9DVExfRVZFTlRfTUFTS19WQUxVRSwNCi0JCQkJICAgICAgICZjb250
cm9sLT5pZCk7DQorCQkJc25kX2N0bF9ub3RpZnkoY2FyZCwgU05EUlZfQ1RMX0VWRU5UX01BU0tf
VkFMVUUsICZpZCk7DQogCQkJcmV0dXJuIDA7DQogCQl9DQogCX0NCkBAIC05ODgsNiArOTk5LDcg
QEAgc3RhdGljIGludCBzbmRfY3RsX2VsZW1fdW5sb2NrKHN0cnVjdCBzbmRfY3RsX2ZpbGUgKmZp
bGUsDQogDQogc3RydWN0IHVzZXJfZWxlbWVudCB7DQogCXN0cnVjdCBzbmRfY3RsX2VsZW1faW5m
byBpbmZvOw0KKwlzdHJ1Y3Qgc25kX2NhcmQgKmNhcmQ7DQogCXZvaWQgKmVsZW1fZGF0YTsJCS8q
IGVsZW1lbnQgZGF0YSAqLw0KIAl1bnNpZ25lZCBsb25nIGVsZW1fZGF0YV9zaXplOwkvKiBzaXpl
IG9mIGVsZW1lbnQgZGF0YSBpbiBieXRlcyAqLw0KIAl2b2lkICp0bHZfZGF0YTsJCQkvKiBUTFYg
ZGF0YSAqLw0KQEAgLTEwMzEsNyArMTA0Myw5IEBAIHN0YXRpYyBpbnQgc25kX2N0bF9lbGVtX3Vz
ZXJfZ2V0KHN0cnVjdCBzbmRfa2NvbnRyb2wgKmtjb250cm9sLA0KIHsNCiAJc3RydWN0IHVzZXJf
ZWxlbWVudCAqdWUgPSBrY29udHJvbC0+cHJpdmF0ZV9kYXRhOw0KIA0KKwltdXRleF9sb2NrKCZ1
ZS0+Y2FyZC0+dXNlcl9jdGxfbG9jayk7DQogCW1lbWNweSgmdWNvbnRyb2wtPnZhbHVlLCB1ZS0+
ZWxlbV9kYXRhLCB1ZS0+ZWxlbV9kYXRhX3NpemUpOw0KKwltdXRleF91bmxvY2soJnVlLT5jYXJk
LT51c2VyX2N0bF9sb2NrKTsNCiAJcmV0dXJuIDA7DQogfQ0KIA0KQEAgLTEwNDAsMTAgKzEwNTQs
MTIgQEAgc3RhdGljIGludCBzbmRfY3RsX2VsZW1fdXNlcl9wdXQoc3RydWN0IHNuZF9rY29udHJv
bCAqa2NvbnRyb2wsDQogew0KIAlpbnQgY2hhbmdlOw0KIAlzdHJ1Y3QgdXNlcl9lbGVtZW50ICp1
ZSA9IGtjb250cm9sLT5wcml2YXRlX2RhdGE7DQotCQ0KKw0KKwltdXRleF9sb2NrKCZ1ZS0+Y2Fy
ZC0+dXNlcl9jdGxfbG9jayk7DQogCWNoYW5nZSA9IG1lbWNtcCgmdWNvbnRyb2wtPnZhbHVlLCB1
ZS0+ZWxlbV9kYXRhLCB1ZS0+ZWxlbV9kYXRhX3NpemUpICE9IDA7DQogCWlmIChjaGFuZ2UpDQog
CQltZW1jcHkodWUtPmVsZW1fZGF0YSwgJnVjb250cm9sLT52YWx1ZSwgdWUtPmVsZW1fZGF0YV9z
aXplKTsNCisJbXV0ZXhfdW5sb2NrKCZ1ZS0+Y2FyZC0+dXNlcl9jdGxfbG9jayk7DQogCXJldHVy
biBjaGFuZ2U7DQogfQ0KIA0KQEAgLTEwNjMsMTkgKzEwNzksMzIgQEAgc3RhdGljIGludCBzbmRf
Y3RsX2VsZW1fdXNlcl90bHYoc3RydWN0IHNuZF9rY29udHJvbCAqa2NvbnRyb2wsDQogCQluZXdf
ZGF0YSA9IG1lbWR1cF91c2VyKHRsdiwgc2l6ZSk7DQogCQlpZiAoSVNfRVJSKG5ld19kYXRhKSkN
CiAJCQlyZXR1cm4gUFRSX0VSUihuZXdfZGF0YSk7DQorCQltdXRleF9sb2NrKCZ1ZS0+Y2FyZC0+
dXNlcl9jdGxfbG9jayk7DQogCQljaGFuZ2UgPSB1ZS0+dGx2X2RhdGFfc2l6ZSAhPSBzaXplOw0K
IAkJaWYgKCFjaGFuZ2UpDQogCQkJY2hhbmdlID0gbWVtY21wKHVlLT50bHZfZGF0YSwgbmV3X2Rh
dGEsIHNpemUpOw0KIAkJa2ZyZWUodWUtPnRsdl9kYXRhKTsNCiAJCXVlLT50bHZfZGF0YSA9IG5l
d19kYXRhOw0KIAkJdWUtPnRsdl9kYXRhX3NpemUgPSBzaXplOw0KKwkJbXV0ZXhfdW5sb2NrKCZ1
ZS0+Y2FyZC0+dXNlcl9jdGxfbG9jayk7DQogCX0gZWxzZSB7DQotCQlpZiAoISB1ZS0+dGx2X2Rh
dGFfc2l6ZSB8fCAhIHVlLT50bHZfZGF0YSkNCi0JCQlyZXR1cm4gLUVOWElPOw0KLQkJaWYgKHNp
emUgPCB1ZS0+dGx2X2RhdGFfc2l6ZSkNCi0JCQlyZXR1cm4gLUVOT1NQQzsNCisJCWludCByZXQg
PSAwOw0KKw0KKwkJbXV0ZXhfbG9jaygmdWUtPmNhcmQtPnVzZXJfY3RsX2xvY2spOw0KKwkJaWYg
KCF1ZS0+dGx2X2RhdGFfc2l6ZSB8fCAhdWUtPnRsdl9kYXRhKSB7DQorCQkJcmV0ID0gLUVOWElP
Ow0KKwkJCWdvdG8gZXJyX3VubG9jazsNCisJCX0NCisJCWlmIChzaXplIDwgdWUtPnRsdl9kYXRh
X3NpemUpIHsNCisJCQlyZXQgPSAtRU5PU1BDOw0KKwkJCWdvdG8gZXJyX3VubG9jazsNCisJCX0N
CiAJCWlmIChjb3B5X3RvX3VzZXIodGx2LCB1ZS0+dGx2X2RhdGEsIHVlLT50bHZfZGF0YV9zaXpl
KSkNCi0JCQlyZXR1cm4gLUVGQVVMVDsNCisJCQlyZXQgPSAtRUZBVUxUOw0KK2Vycl91bmxvY2s6
DQorCQltdXRleF91bmxvY2soJnVlLT5jYXJkLT51c2VyX2N0bF9sb2NrKTsNCisJCWlmIChyZXQp
DQorCQkJcmV0dXJuIHJldDsNCiAJfQ0KIAlyZXR1cm4gY2hhbmdlOw0KIH0NCkBAIC0xMTMzLDgg
KzExNjIsNiBAQCBzdGF0aWMgaW50IHNuZF9jdGxfZWxlbV9hZGQoc3RydWN0IHNuZF9jdGxfZmls
ZSAqZmlsZSwNCiAJc3RydWN0IHVzZXJfZWxlbWVudCAqdWU7DQogCWludCBpZHgsIGVycjsNCiAN
Ci0JaWYgKCFyZXBsYWNlICYmIGNhcmQtPnVzZXJfY3RsX2NvdW50ID49IE1BWF9VU0VSX0NPTlRS
T0xTKQ0KLQkJcmV0dXJuIC1FTk9NRU07DQogCWlmIChpbmZvLT5jb3VudCA8IDEpDQogCQlyZXR1
cm4gLUVJTlZBTDsNCiAJYWNjZXNzID0gaW5mby0+YWNjZXNzID09IDAgPyBTTkRSVl9DVExfRUxF
TV9BQ0NFU1NfUkVBRFdSSVRFIDoNCkBAIC0xMTQzLDIxICsxMTcwLDE2IEBAIHN0YXRpYyBpbnQg
c25kX2N0bF9lbGVtX2FkZChzdHJ1Y3Qgc25kX2N0bF9maWxlICpmaWxlLA0KIAkJCQkgU05EUlZf
Q1RMX0VMRU1fQUNDRVNTX1RMVl9SRUFEV1JJVEUpKTsNCiAJaW5mby0+aWQubnVtaWQgPSAwOw0K
IAltZW1zZXQoJmtjdGwsIDAsIHNpemVvZihrY3RsKSk7DQotCWRvd25fd3JpdGUoJmNhcmQtPmNv
bnRyb2xzX3J3c2VtKTsNCi0JX2tjdGwgPSBzbmRfY3RsX2ZpbmRfaWQoY2FyZCwgJmluZm8tPmlk
KTsNCi0JZXJyID0gMDsNCi0JaWYgKF9rY3RsKSB7DQotCQlpZiAocmVwbGFjZSkNCi0JCQllcnIg
PSBzbmRfY3RsX3JlbW92ZShjYXJkLCBfa2N0bCk7DQotCQllbHNlDQotCQkJZXJyID0gLUVCVVNZ
Ow0KLQl9IGVsc2Ugew0KLQkJaWYgKHJlcGxhY2UpDQotCQkJZXJyID0gLUVOT0VOVDsNCisNCisJ
aWYgKHJlcGxhY2UpIHsNCisJCWVyciA9IHNuZF9jdGxfcmVtb3ZlX3VzZXJfY3RsKGZpbGUsICZp
bmZvLT5pZCk7DQorCQlpZiAoZXJyKQ0KKwkJCXJldHVybiBlcnI7DQogCX0NCi0JdXBfd3JpdGUo
JmNhcmQtPmNvbnRyb2xzX3J3c2VtKTsNCi0JaWYgKGVyciA8IDApDQotCQlyZXR1cm4gZXJyOw0K
Kw0KKwlpZiAoY2FyZC0+dXNlcl9jdGxfY291bnQgPj0gTUFYX1VTRVJfQ09OVFJPTFMpDQorCQly
ZXR1cm4gLUVOT01FTTsNCisNCiAJbWVtY3B5KCZrY3RsLmlkLCAmaW5mby0+aWQsIHNpemVvZihp
bmZvLT5pZCkpOw0KIAlrY3RsLmNvdW50ID0gaW5mby0+b3duZXIgPyBpbmZvLT5vd25lciA6IDE7
DQogCWFjY2VzcyB8PSBTTkRSVl9DVExfRUxFTV9BQ0NFU1NfVVNFUjsNCkBAIC0xMjA3LDYgKzEy
MjksNyBAQCBzdGF0aWMgaW50IHNuZF9jdGxfZWxlbV9hZGQoc3RydWN0IHNuZF9jdGxfZmlsZSAq
ZmlsZSwNCiAJdWUgPSBremFsbG9jKHNpemVvZihzdHJ1Y3QgdXNlcl9lbGVtZW50KSArIHByaXZh
dGVfc2l6ZSwgR0ZQX0tFUk5FTCk7DQogCWlmICh1ZSA9PSBOVUxMKQ0KIAkJcmV0dXJuIC1FTk9N
RU07DQorCXVlLT5jYXJkID0gY2FyZDsNCiAJdWUtPmluZm8gPSAqaW5mbzsNCiAJdWUtPmluZm8u
YWNjZXNzID0gMDsNCiAJdWUtPmVsZW1fZGF0YSA9IChjaGFyICopdWUgKyBzaXplb2YoKnVlKTsN
CkBAIC0xMzE4LDggKzEzNDEsOSBAQCBzdGF0aWMgaW50IHNuZF9jdGxfdGx2X2lvY3RsKHN0cnVj
dCBzbmRfY3RsX2ZpbGUgKmZpbGUsDQogCQl9DQogCQllcnIgPSBrY3RsLT50bHYuYyhrY3RsLCBv
cF9mbGFnLCB0bHYubGVuZ3RoLCBfdGx2LT50bHYpOyANCiAJCWlmIChlcnIgPiAwKSB7DQorCQkJ
c3RydWN0IHNuZF9jdGxfZWxlbV9pZCBpZCA9IGtjdGwtPmlkOw0KIAkJCXVwX3JlYWQoJmNhcmQt
PmNvbnRyb2xzX3J3c2VtKTsNCi0JCQlzbmRfY3RsX25vdGlmeShjYXJkLCBTTkRSVl9DVExfRVZF
TlRfTUFTS19UTFYsICZrY3RsLT5pZCk7DQorCQkJc25kX2N0bF9ub3RpZnkoY2FyZCwgU05EUlZf
Q1RMX0VWRU5UX01BU0tfVExWLCAmaWQpOw0KIAkJCXJldHVybiAwOw0KIAkJfQ0KIAl9IGVsc2Ug
ew0KZGlmZiAtLWdpdCBhL3NvdW5kL2NvcmUvaW5pdC5jIGIvc291bmQvY29yZS9pbml0LmMNCmlu
ZGV4IGZhMGYzNWIuLjYzMzNmOGIgMTAwNjQ0DQotLS0gYS9zb3VuZC9jb3JlL2luaXQuYw0KKysr
IGIvc291bmQvY29yZS9pbml0LmMNCkBAIC0yMDcsNiArMjA3LDcgQEAgaW50IHNuZF9jYXJkX2Ny
ZWF0ZShpbnQgaWR4LCBjb25zdCBjaGFyICp4aWQsDQogCUlOSVRfTElTVF9IRUFEKCZjYXJkLT5k
ZXZpY2VzKTsNCiAJaW5pdF9yd3NlbSgmY2FyZC0+Y29udHJvbHNfcndzZW0pOw0KIAlyd2xvY2tf
aW5pdCgmY2FyZC0+Y3RsX2ZpbGVzX3J3bG9jayk7DQorCW11dGV4X2luaXQoJmNhcmQtPnVzZXJf
Y3RsX2xvY2spOw0KIAlJTklUX0xJU1RfSEVBRCgmY2FyZC0+Y29udHJvbHMpOw0KIAlJTklUX0xJ
U1RfSEVBRCgmY2FyZC0+Y3RsX2ZpbGVzKTsNCiAJc3Bpbl9sb2NrX2luaXQoJmNhcmQtPmZpbGVz
X2xvY2spOw0KZGlmZiAtLWdpdCBhL3NvdW5kL3BjaS9oZGEvcGF0Y2hfcmVhbHRlay5jIGIvc291
bmQvcGNpL2hkYS9wYXRjaF9yZWFsdGVrLmMNCmluZGV4IGQzMDdhZGIuLjQwMDE2OGUgMTAwNjQ0
DQotLS0gYS9zb3VuZC9wY2kvaGRhL3BhdGNoX3JlYWx0ZWsuYw0KKysrIGIvc291bmQvcGNpL2hk
YS9wYXRjaF9yZWFsdGVrLmMNCkBAIC00OTIwLDYgKzQ5MjAsNyBAQCBlbnVtIHsNCiAJQUxDMjY5
X0ZJWFVQX1NURVJFT19ETUlDLA0KIAlBTEMyNjlfRklYVVBfUVVBTlRBX01VVEUsDQogCUFMQzI2
OV9GSVhVUF9MSUZFQk9PSywNCisJQUxDMjY5X0ZJWFVQX0xJRkVCT09LX0VYVE1JQywNCiAJQUxD
MjY5X0ZJWFVQX0FNSUMsDQogCUFMQzI2OV9GSVhVUF9ETUlDLA0KIAlBTEMyNjlWQl9GSVhVUF9B
TUlDLA0KQEAgLTUwMDgsNiArNTAwOSwxMyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGFsY19maXh1
cCBhbGMyNjlfZml4dXBzW10gPSB7DQogCQkuY2hhaW5lZCA9IHRydWUsDQogCQkuY2hhaW5faWQg
PSBBTEMyNjlfRklYVVBfUVVBTlRBX01VVEUNCiAJfSwNCisJW0FMQzI2OV9GSVhVUF9MSUZFQk9P
S19FWFRNSUNdID0gew0KKwkJLnR5cGUgPSBBTENfRklYVVBfUElOUywNCisJCS52LnBpbnMgPSAo
Y29uc3Qgc3RydWN0IGFsY19waW5jZmdbXSkgew0KKwkJCXsgMHgxOSwgMHgwMWExOTAzYyB9LCAv
KiBoZWFkc2V0IG1pYywgd2l0aCBqYWNrIGRldGVjdCAqLw0KKwkJCXsgfQ0KKwkJfSwNCisJfSwN
CiAJW0FMQzI2OV9GSVhVUF9BTUlDXSA9IHsNCiAJCS50eXBlID0gQUxDX0ZJWFVQX1BJTlMsDQog
CQkudi5waW5zID0gKGNvbnN0IHN0cnVjdCBhbGNfcGluY2ZnW10pIHsNCkBAIC01MDc5LDYgKzUw
ODcsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHNuZF9wY2lfcXVpcmsgYWxjMjY5X2ZpeHVwX3Ri
bFtdID0gew0KIAlTTkRfUENJX1FVSVJLKDB4MTAyOCwgMHgwNDcwLCAiRGVsbCBNMTAxeiIsIEFM
QzI2OV9GSVhVUF9ERUxMX00xMDFaKSwNCiAJU05EX1BDSV9RVUlSS19WRU5ET1IoMHgxMDI1LCAi
QWNlciBBc3BpcmUiLCBBTEMyNzFfRklYVVBfRE1JQyksDQogCVNORF9QQ0lfUVVJUksoMHgxMGNm
LCAweDE0NzUsICJMaWZlYm9vayIsIEFMQzI2OV9GSVhVUF9MSUZFQk9PSyksDQorCVNORF9QQ0lf
UVVJUksoMHgxMGNmLCAweDE4NDUsICJMaWZlYm9vayBVOTA0IiwgQUxDMjY5X0ZJWFVQX0xJRkVC
T09LX0VYVE1JQyksDQogCVNORF9QQ0lfUVVJUksoMHgxN2FhLCAweDIwZjIsICJUaGlua3BhZCBT
TDQxMC81MTAiLCBBTEMyNjlfRklYVVBfU0tVX0lHTk9SRSksDQogCVNORF9QQ0lfUVVJUksoMHgx
N2FhLCAweDIxNWUsICJUaGlua3BhZCBMNTEyIiwgQUxDMjY5X0ZJWFVQX1NLVV9JR05PUkUpLA0K
IAlTTkRfUENJX1FVSVJLKDB4MTdhYSwgMHgyMWI4LCAiVGhpbmtwYWQgRWRnZSAxNCIsIEFMQzI2
OV9GSVhVUF9TS1VfSUdOT1JFKSwNCkBAIC02MDU2LDYgKzYwNjUsNyBAQCBzdGF0aWMgY29uc3Qg
c3RydWN0IGhkYV9jb2RlY19wcmVzZXQgc25kX2hkYV9wcmVzZXRfcmVhbHRla1tdID0gew0KIAl7
IC5pZCA9IDB4MTBlYzA2NzAsIC5uYW1lID0gIkFMQzY3MCIsIC5wYXRjaCA9IHBhdGNoX2FsYzY2
MiB9LA0KIAl7IC5pZCA9IDB4MTBlYzA2NzEsIC5uYW1lID0gIkFMQzY3MSIsIC5wYXRjaCA9IHBh
dGNoX2FsYzY2MiB9LA0KIAl7IC5pZCA9IDB4MTBlYzA2ODAsIC5uYW1lID0gIkFMQzY4MCIsIC5w
YXRjaCA9IHBhdGNoX2FsYzY4MCB9LA0KKwl7IC5pZCA9IDB4MTBlYzA4NjcsIC5uYW1lID0gIkFM
Qzg5MSIsIC5wYXRjaCA9IHBhdGNoX2FsYzg4MiB9LA0KIAl7IC5pZCA9IDB4MTBlYzA4ODAsIC5u
YW1lID0gIkFMQzg4MCIsIC5wYXRjaCA9IHBhdGNoX2FsYzg4MCB9LA0KIAl7IC5pZCA9IDB4MTBl
YzA4ODIsIC5uYW1lID0gIkFMQzg4MiIsIC5wYXRjaCA9IHBhdGNoX2FsYzg4MiB9LA0KIAl7IC5p
ZCA9IDB4MTBlYzA4ODMsIC5uYW1lID0gIkFMQzg4MyIsIC5wYXRjaCA9IHBhdGNoX2FsYzg4MiB9
LA0K


--=-lQrz8J8T+J+UpSfnFIFj--

--=-XU+FYWrOtEvgcaQX2Rx3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU8FB8ee/yOyVhhEJAQpoXg/+Jsmw5EKadyiyxUAKWZEqBYN8CM9Fk/7o
cKepKhCBN1lFF812KZF5STs5VAld5CvZqzWhmWoMYvwpvp7mDLhW3IxRRpIzAYM9
1HPTLkM5fyuoSwB0YlWeyyTZN9MMS71UkcaXDdXDOAUmU72cJ671eJ3GMUqGMk/r
MLAkS+flIAyt+Fz76Dr7WHNhZ6IS3FbN40rR2X+IxjRwwAqaO5sxCi5fHszWFkLJ
nO53qrNmUuFhJwozwJb2nf/f1N3uJpFxn9oypaIWDrV1z3xlvqaYdq92JP/dbQ72
568CcntBgSsK0s8woyqD0PzXGHjjHacS2wu8m9mYntetJfLHVrI7vgLyuHPeVU4P
koEniRHAvQs2locJgAVe81NSt4jrUyQ/DLGa3Q7Qu+PgozWijxGH3C8/cG40g1yn
2nNSbvFhH7bV1b915pzvPXoIg2ZvcG2QNdI7WJudtDU4+OXrHXyUvi2PMEe82gJY
bqvl755RaeoyW+dHJxevbU6uKteMriBGyScK+jnlJ7aPxz0g8CzIboKOvL8uD6L2
vsD4aNqgSnMlT2b5wIotIZZ3GWji5yZolPM7brAjWBoLR5TMqk2w5OHmEwWnt/w7
HD50Kwjfpnavb/flZEwO09FhQOD2KIBOolmgEKk9Yh0I3cJGv/01hQY6VadA5Pc2
3SqRkIGRLGU=
=J0+1
-----END PGP SIGNATURE-----

--=-XU+FYWrOtEvgcaQX2Rx3--
