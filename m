Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362AbaGAEEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 00:04:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbaGAEES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 00:04:18 -0400
Date: Mon, 30 Jun 2014 21:04:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.46
Message-ID: <20140701040403.GA21509@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.46 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                     |    2=20
 arch/arm/kernel/stacktrace.c                 |   18 ++-
 arch/arm/mach-omap1/board-h2.c               |    2=20
 arch/arm/mach-omap1/board-h3.c               |    2=20
 arch/arm/mach-omap1/board-innovator.c        |    2=20
 arch/arm/mach-omap1/board-osk.c              |    2=20
 arch/arm/mm/proc-v7-3level.S                 |   18 ++-
 arch/arm64/kernel/ptrace.c                   |    4=20
 arch/s390/include/asm/lowcore.h              |   11 +-
 arch/x86/kernel/entry_32.S                   |   15 +--
 arch/x86/syscalls/syscall_64.tbl             |    6 -
 drivers/acpi/acpica/utstring.c               |    2=20
 drivers/acpi/bus.c                           |    7 +
 drivers/bluetooth/hci_ldisc.c                |   24 ++++-
 drivers/bluetooth/hci_uart.h                 |    1=20
 drivers/char/applicom.c                      |    1=20
 drivers/extcon/extcon-max8997.c              |    2=20
 drivers/hid/hid-core.c                       |   12 ++
 drivers/infiniband/ulp/isert/ib_isert.c      |   59 ++++++------
 drivers/infiniband/ulp/isert/ib_isert.h      |    2=20
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c       |    6 +
 drivers/media/usb/stk1160/stk1160-core.c     |   10 +-
 drivers/media/usb/stk1160/stk1160.h          |    1=20
 drivers/media/usb/uvc/uvc_video.c            |   15 ++-
 drivers/net/can/sja1000/peak_pci.c           |   14 +--
 drivers/net/ethernet/ti/cpsw.c               |    4=20
 drivers/staging/tidspbridge/core/dsp-clock.c |    4=20
 drivers/target/iscsi/iscsi_target.c          |    3=20
 drivers/target/iscsi/iscsi_target_login.c    |    7 -
 drivers/target/target_core_rd.c              |    2=20
 drivers/target/target_core_sbc.c             |    4=20
 drivers/target/target_core_spc.c             |    9 +
 drivers/target/target_core_transport.c       |   29 +++++-
 drivers/usb/dwc3/gadget.c                    |    4=20
 drivers/usb/gadget/inode.c                   |    2=20
 drivers/usb/host/pci-quirks.c                |   19 +++-
 drivers/usb/misc/usbtest.c                   |   40 +++++++-
 drivers/usb/phy/phy-isp1301-omap.c           |    2=20
 drivers/usb/serial/bus.c                     |   14 ++-
 drivers/usb/serial/option.c                  |   11 ++
 drivers/usb/serial/qcserial.c                |   21 ++++
 drivers/usb/serial/sierra.c                  |   55 +++++++++--
 drivers/usb/serial/usb_wwan.c                |  125 ++++++++++++++--------=
-----
 drivers/video/matrox/matroxfb_base.h         |    2=20
 fs/aio.c                                     |    6 -
 fs/btrfs/backref.c                           |   32 ++++--
 fs/btrfs/backref.h                           |    4=20
 fs/btrfs/disk-io.c                           |    5 +
 fs/btrfs/extent_io.c                         |    5 -
 fs/btrfs/free-space-cache.c                  |    4=20
 fs/btrfs/scrub.c                             |    5 -
 fs/btrfs/send.c                              |    4=20
 fs/btrfs/volumes.c                           |   32 +++++-
 fs/ext4/mballoc.c                            |    2=20
 fs/ext4/page-io.c                            |   24 ++---
 include/linux/irqdesc.h                      |    4=20
 include/linux/ptrace.h                       |   32 ++++++
 include/target/target_core_backend.h         |    1=20
 kernel/fork.c                                |   10 +-
 kernel/irq/manage.c                          |    4=20
 kernel/irq/spurious.c                        |  106 ++++++++++++++++++++++
 lib/idr.c                                    |    8 -
 mm/memory-failure.c                          |   25 +++--
 mm/rmap.c                                    |    8 +
 mm/vmscan.c                                  |   46 ++++++++-
 net/bluetooth/l2cap_sock.c                   |    5 -
 net/core/skbuff.c                            |    2=20
 net/iucv/af_iucv.c                           |    2=20
 68 files changed, 709 insertions(+), 262 deletions(-)

Alan Stern (2):
      USB: usbtest: add a timeout for scatter-gather tests
      USB: EHCI: avoid BIOS handover on the HASEE E200

Aleksander Morgado (2):
      usb: qcserial: add Netgear AirCard 341U
      usb: qcserial: add additional Sierra Wireless QMI devices

Andy Lutomirski (1):
      x86_32, entry: Do syscall exit work on badsys (CVE-2014-4508)

Benjamin LaHaise (2):
      aio: fix aio request leak when events are reaped by userspace
      aio: fix kernel memory disclosure in io_getevents() introduced in v3.=
10

Chris Mason (1):
      Btrfs: fix double free in find_lock_delalloc_range

Christian Borntraeger (1):
      s390/lowcore: reserve 96 bytes for IRB in lowcore

Dan Carpenter (1):
      applicom: dereferencing NULL on error path

David Binderman (1):
      ACPICA: utstring: Check array index bound before use.

Eric Sandeen (1):
      btrfs: fix use of uninit "ret" in end_extent_writepage()

Ezequiel Garcia (1):
      media: stk1160: Avoid stack-allocated buffer for control URBs

Felipe Balbi (2):
      usb: dwc3: gadget: clear stall when disabling endpoint
      bluetooth: hci_ldisc: fix deadlock condition

Filipe Manana (1):
      Btrfs: send, don't error in the presence of subvols/snapshots

Greg Kroah-Hartman (1):
      Linux 3.10.46

H. Peter Anvin (1):
      x86-32, espfix: Remove filter for espfix32 due to race

Huang Rui (1):
      usb: usbtest: fix unlink write error with pattern 1

Hugh Dickins (1):
      mm: fix sleeping function warning from __put_anon_vma

Jan Kara (1):
      ext4: fix zeroing of page during writeback

Jianguo Wu (1):
      ARM: 8037/1: mm: support big-endian page tables

Johan Hovold (12):
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

Jukka Taimisto (1):
      Bluetooth: Fix L2CAP deadlock

Kees Cook (1):
      HID: core: fix validation of report id 0

Krzysztof Kozlowski (1):
      extcon: max8997: Fix NULL pointer exception on missing pdata

Lai Jiangshan (1):
      idr: fix overflow bug during maximum ID calculation at maximum height

Liu Bo (3):
      Btrfs: mark mapping with error flag to report errors to userspace
      Btrfs: use right type to get real comparison
      Btrfs: fix scrub_print_warning to handle skinny metadata extents

Lv Zheng (1):
      ACPI: Fix conflict between customized DSDT and DSDT local copy

Matthew Dempsky (1):
      ptrace: fix fork event messages across pid namespaces

Maurizio Lombardi (1):
      ext4: fix wrong assert in ext4_mb_normalize_request()

Mel Gorman (1):
      mm: vmscan: do not throttle based on pfmemalloc reserves if node has =
no ZONE_NORMAL

Miao Xie (1):
      Btrfs: output warning instead of error when loading free space cache =
failed

Michael S. Tsirkin (1):
      skbuff: skb_segment: orphan frags before copying

Mike Frysinger (1):
      x86, x32: Use compat shims for io_{setup,submit}

Mikulas Patocka (1):
      matroxfb: perform a dummy read of M_STATUS

Nicholas A. Bellinger (1):
      target: Explicitly clear ramdisk_mcp backend pages

Nicholas Bellinger (3):
      target: Set CMD_T_ACTIVE bit for Task Management Requests
      target: Use complete_all for se_cmd->t_transport_stop_comp
      iscsi-target: Fix ABORT_TASK + connection reset iscsi_queue_req memor=
y leak

Olivier Langlois (1):
      media: uvcvideo: Fix clock param realtime setting

Paul Bolle (3):
      staging: tidspbridge: check for CONFIG_SND_OMAP_SOC_MCBSP
      usb: gadget: rename CONFIG_USB_GADGET_PXA25X
      ARM: OMAP: replace checks for CONFIG_USB_GADGET_OMAP

Qu Wenruo (1):
      btrfs: Add ctime/mtime update for btrfs device add/remove.

Rickard Strandqvist (1):
      fs: btrfs: volumes.c: Fix for possible null pointer dereference

Roger Quadros (1):
      usb: usbtest: Add timetout to simple_io()

Roland Dreier (2):
      target: Report correct response length for some commands
      iscsi-target: Re-add chunk from backport of upstream 79d59d08082d to =
3.10

Russell King (1):
      ARM: stacktrace: avoid listing stacktrace functions in stacktrace

Sagi Grimberg (4):
      Target/iser: Bail from accept_np if np_thread is trying to close
      Target/iser: Fix hangs in connection teardown
      Target/iser: Improve cm events handling
      Target/iser: Wait for proper cleanup before unloading

Stephane Grosjean (1):
      can: peak_pci: prevent use after free at netdev removal

Takashi Iwai (1):
      media: ivtv: Fix Oops when no firmware is loaded

Thomas Gleixner (1):
      genirq: Sanitize spurious interrupt detection of threaded irqs

Tony Luck (2):
      mm/memory-failure.c-failure: send right signal code to correct thread
      mm/memory-failure.c: don't let collect_procs() skip over processes fo=
r MF_ACTION_REQUIRED

Ursula Braun (1):
      af_iucv: wrong mapping of sent and confirmed skbs

Wang Shilong (2):
      Btrfs: make sure there are not any read requests before stopping work=
ers
      Btrfs: set right total device count for seeding support

Will Deacon (1):
      arm64: ptrace: change fs when passing kernel pointer to regset code

xiao jin (2):
      USB: usb_wwan: fix urb leak in write error path
      USB: usb_wwan: fix race between write and resume


--huq684BweRXVnRxX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTsjMzAAoJEDjbvchgkmk+pp0P/2k/rPcQNjvMKv9gzWKtQDIB
agZ4185VNTJeHfRJl6HsZhZiQdLwsVS1rgDN/+z7D54V19SoJk1dzMBYGNopeRDn
jjVZB28OZdrrUd/z7BQZHEG3rsoPRpEpsnZkhZJLJyMj64yxBAI8WbOm0CLRqS+O
No57lw5107WUb+EyK/YxyZwWQOSJsnlFA/wHTJeFQ7sryiF/hUy5lXJgHCVTlewT
cTBtab2mHJ4oKBcfoLWSL2wqks3GsfKjASdf3V1PmfS/JhzdhzmxLigztHAV1l+r
/ahjuWRfa6U/LaSuhidbI8MdMGKolGY2WuTmNJh7VYRizV/CKJTEa6KYxIbxJWT5
erzNSo7b/dL4S1HAvhwlt7ZcIXfc2sjJdSCU0gfyT21tzXtYR3NuYFFST5koTcY0
DpV/6afLX36AOCEMdDMO2+jl4TsU0s/T/0HP/ZVGiw/jQAc5q2Ezfy35PMFNK29G
D7N6bh2NGTVAMKfRMg5u0+r59KMRlSpS3QpTUsb1LLHV8jxYFHS/QQGnhzFH2B79
951+W0yHecl7im5W9dH1YadSxhjb1SoH8w/+vI10oqYiOzCWZbGV6XhSq5lNDQES
h3DeCZ9lIDbY++v0Cq1L97O0c/pMeW2zROdHvGGKD1p1o65OQXe/VwK3qpovV7ju
yJhZFsxtV3/j4/6sTzvM
=Uk/u
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
