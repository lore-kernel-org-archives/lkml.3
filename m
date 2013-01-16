Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab3APN60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:58:26 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34754 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753807Ab3APN6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:58:18 -0500
Message-ID: <1358344686.15692.105.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.37
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Wed, 16 Jan 2013 13:58:06 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-S/U1HewM/Hh8wC1wD8wK"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-S/U1HewM/Hh8wC1wD8wK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.37 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

Ben.

------------

 Documentation/networking/ip-sysctl.txt     |    5 ++
 Makefile                                   |    2 +-
 arch/powerpc/kernel/time.c                 |    5 --
 arch/powerpc/platforms/40x/ppc40x_simple.c |    3 +-
 arch/sparc/include/asm/hugetlb.h           |   10 ++-
 drivers/acpi/scan.c                        |    9 ++-
 drivers/block/aoe/aoe.h                    |    2 +-
 drivers/block/aoe/aoeblk.c                 |    5 --
 drivers/gpu/drm/i915/i915_drv.h            |    1 +
 drivers/gpu/drm/i915/intel_display.c       |   17 ++++
 drivers/gpu/drm/i915/intel_lvds.c          |    1 +
 drivers/gpu/drm/nouveau/nouveau_bo.c       |    2 +-
 drivers/gpu/drm/radeon/radeon_combios.c    |  117 ++++++++++++++++++++++++=
++++
 drivers/gpu/drm/radeon/radeon_connectors.c |   10 ++-
 drivers/gpu/drm/radeon/radeon_display.c    |   13 +++-
 drivers/gpu/drm/radeon/radeon_i2c.c        |   10 ++-
 drivers/gpu/drm/radeon/radeon_mode.h       |    4 +-
 drivers/hwmon/lm73.c                       |   16 ++--
 drivers/infiniband/hw/nes/nes.h            |    1 +
 drivers/infiniband/hw/nes/nes_hw.c         |    9 +--
 drivers/infiniband/hw/nes/nes_verbs.c      |    9 ++-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |    4 +-
 drivers/net/wireless/p54/p54usb.c          |    4 +
 drivers/net/wireless/rt2x00/rt2800lib.c    |    3 +-
 drivers/pci/quirks.c                       |    7 +-
 drivers/rtc/rtc-vt8500.c                   |   11 +--
 drivers/scsi/mvsas/mv_sas.c                |    2 +-
 drivers/video/mxsfb.c                      |    3 +-
 fs/cifs/transport.c                        |    7 ++
 fs/eventpoll.c                             |   22 +++++-
 fs/ext4/extents.c                          |   22 +++++-
 fs/ext4/super.c                            |   22 +++---
 fs/jbd2/transaction.c                      |    3 +-
 fs/nfs/super.c                             |    2 +-
 fs/udf/inode.c                             |    7 +-
 include/asm-generic/tlb.h                  |    9 +++
 include/linux/compiler-gcc.h               |    5 ++
 include/linux/page-flags.h                 |    8 +-
 include/linux/pci_ids.h                    |    1 +
 include/linux/snmp.h                       |    3 +-
 include/net/inet_connection_sock.h         |    1 +
 include/net/mac80211.h                     |    5 ++
 include/net/tcp.h                          |    1 +
 mm/memory.c                                |    5 ++
 mm/mempolicy.c                             |   64 +++++++--------
 net/dccp/ipv4.c                            |    4 +-
 net/dccp/ipv6.c                            |    3 +-
 net/ipv4/inet_connection_sock.c            |   16 ++++
 net/ipv4/proc.c                            |    3 +-
 net/ipv4/sysctl_net_ipv4.c                 |    7 ++
 net/ipv4/tcp_input.c                       |   93 ++++++++++++++++------
 net/ipv4/tcp_ipv4.c                        |    5 +-
 net/ipv6/tcp_ipv6.c                        |    3 +-
 net/mac80211/status.c                      |    6 +-
 net/sched/sch_htb.c                        |    2 +-
 net/sunrpc/sched.c                         |   27 ++++++-
 56 files changed, 489 insertions(+), 152 deletions(-)

Aaro Koskinen (1):
      drm/nouveau: fix init with agpgart-uninorth

Alex Deucher (2):
      drm/radeon: add connector table for SAM440ep embedded board
      drm/radeon: add connector table for Mac G4 Silver

Andreas Hartmann (1):
      rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe fails

Andy Lutomirski (1):
      PCI: Reduce Ricoh 0xe822 SD card reader base clock frequency to 50MHz

Ben Hutchings (1):
      Linux 3.2.37

Chris Verges (1):
      hwmon: (lm73} Detect and report i2c bus errors

Christian Lamparter (1):
      p54usb: add USBIDs for two more p54usb devices

Christoffer Dall (1):
      mm: Fix PageHead when !CONFIG_PAGEFLAGS_EXTENDED

Christoph Paasch (1):
      inet: Fix kmemleak in tcp_v4/6_syn_recv_sock and dccp_v4/6_request_re=
cv_sock

Dave Kleikamp (1):
      sparc: huge_ptep_set_* functions need to call set_huge_pte_at()

Ed L. Cashin (1):
      aoe: do not call bdi_init after blk_alloc_queue

Eric Dumazet (5):
      tcp: implement RFC 5961 3.2
      tcp: implement RFC 5961 4.2
      tcp: refine SYN handling in tcp_validate_incoming
      tcp: tcp_replace_ts_recent() should not be called from tcp_validate_i=
ncoming()
      tcp: RFC 5961 5.2 Blind Data Injection Attack Mitigation

Eric Wong (1):
      epoll: prevent missed events on EPOLL_CTL_MOD

Forrest Liu (1):
      ext4: fix extent tree corruption caused by hole punch

Gabor Juhos (1):
      powerpc: Add missing NULL terminator to avoid boot panic on PPC40x

Hugh Dickins (1):
      tmpfs mempolicy: fix /proc/mounts corrupting memory

Jan Kara (2):
      ext4: check dioread_nolock on remount
      jbd2: fix assertion failure in jbd2_journal_flush()

Jeff Layton (1):
      cifs: adjust sequence number downward after signing NT_CANCEL request

Jianpeng Ma (1):
      mvsas: Fix oops when ata commond timeout.

Krzysztof Mazur (1):
      i915: ensure that VGA plane is disabled

Lothar Wa=C3=9Fmann (1):
      video: mxsfb: fix crash when unblanking the display

Michael Tokarev (1):
      ext4: do not try to write superblock on ro remount w/o journal

Michal Hocko (1):
      mm: limit mmu_gather batching to fix soft lockups on !CONFIG_PREEMPT

Namjae Jeon (1):
      udf: don't increment lenExtents while writing to a hole

Niels Ole Salscheider (1):
      drm/radeon: Properly handle DDC probe for DP bridges

Rafael J. Wysocki (1):
      ACPI / scan: Do not use dummy HID for system bus ACPI nodes

Shan Hai (1):
      powerpc/vdso: Remove redundant locking in update_vsyscall_tz()

Stanislaw Gruszka (2):
      mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
      Revert: "rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe=
 fails"

Stefan Hasko (1):
      net: sched: integer overflow fix

Steven Rostedt (1):
      ftrace: Do not function trace inlined functions

Sujith Manoharan (1):
      ath9k_hw: Fix RX gain initvals for AR9485

Tatyana Nikolova (2):
      RDMA/nes: Fix for crash when registering zero length MR for CQ
      RDMA/nes: Fix for terminate timer crash

Tomasz Guszkowski (1):
      p54usb: add USB ID for T-Com Sinus 154 data II

Tony Prisk (2):
      drivers/rtc/rtc-vt8500.c: correct handling of CR_24H bitfield
      drivers/rtc/rtc-vt8500.c: fix handling of data passed in struct rtc_t=
ime

Trond Myklebust (1):
      SUNRPC: Ensure that we free the rpc_task after cleanups are done

Xi Wang (1):
      nfs: fix null checking in nfs_get_option_str()

Zhang Rui (1):
      ACPI : do not use Lid and Sleep button for S5 wakeup



--=-S/U1HewM/Hh8wC1wD8wK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUPax7ue/yOyVhhEJAQogehAAr9MP+BJUQqeVFQXB5z6ygLoNUbJNViF7
IlrVAwaFeClf11MOHlzePYgs4FLfPM5CxL+MLIAs4jBO7wSoemFFaNzf4I9mHJ84
D/wlE3wHb/ydgykIPyf0PbD10LKSm1jt1wyf1PXcR+GC3PAPLnXCdpBSud+argsG
82rbLu2zFmoftB8bx0LKKrr4elVcmC0inA3JsTDeDltS6J94YLTZC6MNep1dvJ/L
kIApS6lZ5lOxa+GS/3FNEDDhNCrcJd6+zkWkecVUWI5ed2pG53L4A2g6p3Njeh/v
PbVPVbLGzjb56QtHP3IWFSKsl8G19w+BOEF/WrvAkBJGz1RLSCcDW/zQ/A8zXZpl
obGN5fSqSVdQTCm+eP84Wl3daZ1lItenqU27kjynlyByLiAyP6Z/gQml6VaZikpB
fg5+UkAKNeeG2wAf9C/+ITms/pY8M0UomuOexoKpynHenHtqQvM/uKFVIlytOZ2D
N5o09RdK7OWmcbnE/6tF4ud8zKM6+2pjpl3vzL6FUEWKmccQXYIx/56pmWMuxyvJ
jVokRkaY6gkiy76xaYdbLrZzLPIYglojArncJobNlH2+ihm1fTcWjV8AGU/DpwOS
pUjbaPM+SyFkd83iqcGTF0+HOY7/g5nvQ0qnJJc2ARCPZLIQoVEFnMWGbBvJI4aN
A/fss3mFHpQ=
=Iq7O
-----END PGP SIGNATURE-----

--=-S/U1HewM/Hh8wC1wD8wK--
