Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab3C1TXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 15:23:39 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:57909 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab3C1TXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 15:23:37 -0400
Date: Thu, 28 Mar 2013 12:23:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.38
Message-ID: <20130328192335.GA18084@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.38 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                          |    2=20
 arch/x86/lib/usercopy_64.c                        |    4=20
 drivers/gpu/drm/drm_edid.c                        |    3=20
 drivers/gpu/drm/i915/i915_debugfs.c               |    2=20
 drivers/gpu/drm/i915/i915_gem_execbuffer.c        |   11 +-
 drivers/gpu/drm/i915/intel_opregion.c             |   23 +++++
 drivers/gpu/drm/radeon/ni.c                       |   11 ++
 drivers/gpu/drm/radeon/radeon_benchmark.c         |   16 ++-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c           |    8 +
 drivers/net/bonding/bond_main.c                   |    6 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h |    3=20
 drivers/net/ethernet/broadcom/tg3.c               |    8 +
 drivers/net/ethernet/sfc/bitfield.h               |   22 ++---
 drivers/net/ethernet/sfc/efx.c                    |   53 ++++++++-----
 drivers/net/ethernet/sfc/efx.h                    |   13 +++
 drivers/net/ethernet/sfc/falcon.c                 |   37 ++++++++-
 drivers/net/ethernet/sfc/mcdi.c                   |   33 ++++----
 drivers/net/ethernet/sfc/mcdi.h                   |    6 -
 drivers/net/ethernet/sfc/net_driver.h             |   14 ++-
 drivers/net/ethernet/sfc/nic.c                    |   65 +++++++++++++---
 drivers/net/ethernet/sfc/nic.h                    |    2=20
 drivers/net/ethernet/sfc/rx.c                     |   25 +++---
 drivers/net/ethernet/sfc/selftest.c               |   64 +++------------
 drivers/net/ethernet/sfc/siena.c                  |   44 +++++++++-
 drivers/net/ethernet/sfc/siena_sriov.c            |   13 ++-
 drivers/net/netconsole.c                          |   20 ++--
 drivers/net/wireless/mwifiex/join.c               |    7 -
 drivers/net/wireless/rt2x00/rt2x00dev.c           |    2=20
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c       |   89 ++++++++---------=
-----
 drivers/platform/x86/asus-laptop.c                |   17 ----
 drivers/target/iscsi/iscsi_target_auth.c          |    5 -
 drivers/tty/serial/sunsu.c                        |   21 ++---
 drivers/usb/class/cdc-acm.c                       |    3=20
 drivers/usb/core/hcd-pci.c                        |   23 +++--
 drivers/usb/host/ehci-q.c                         |   18 +---
 drivers/usb/host/xhci.c                           |    3=20
 drivers/usb/host/xhci.h                           |    4=20
 drivers/usb/serial/garmin_gps.c                   |    7 -
 drivers/usb/serial/io_ti.c                        |    1=20
 drivers/usb/serial/usb-serial.c                   |    3=20
 drivers/usb/storage/unusual_devs.h                |    7 +
 drivers/vhost/net.c                               |    3=20
 fs/binfmt_em86.c                                  |    1=20
 fs/binfmt_misc.c                                  |    6 -
 fs/binfmt_script.c                                |    4=20
 fs/cifs/asn1.c                                    |   53 +------------
 fs/exec.c                                         |   10 +-
 fs/ext4/extents.c                                 |    6 +
 fs/ext4/inode.c                                   |    3=20
 fs/isofs/export.c                                 |    1=20
 fs/jbd2/transaction.c                             |   15 ++-
 fs/udf/namei.c                                    |    1=20
 fs/udf/udf_sb.h                                   |    2=20
 include/drm/drm_pciids.h                          |   13 ++-
 include/linux/binfmts.h                           |    2=20
 include/linux/skbuff.h                            |    7 +
 include/net/inet_frag.h                           |    9 ++
 include/net/ip_fib.h                              |   12 +-
 kernel/time/tick-broadcast.c                      |    3=20
 kernel/time/tick-sched.c                          |    5 +
 kernel/trace/ftrace.c                             |    4=20
 kernel/trace/trace.c                              |    3=20
 mm/hugetlb.c                                      |    8 +
 net/core/rtnetlink.c                              |    2=20
 net/ipv4/inet_fragment.c                          |   20 ++++
 net/ipv4/ip_fragment.c                            |   11 --
 net/ipv4/ip_options.c                             |    5 -
 net/ipv4/tcp.c                                    |    2=20
 net/ipv4/tcp_output.c                             |    1=20
 net/ipv6/netfilter/nf_conntrack_reasm.c           |   11 +-
 net/ipv6/reassembly.c                             |    8 +
 net/sctp/associola.c                              |    2=20
 net/sctp/sm_statefuns.c                           |    2=20
 security/keys/keyctl.c                            |    4=20
 sound/pci/hda/hda_codec.c                         |    2=20
 sound/pci/hda/patch_conexant.c                    |    8 -
 sound/usb/mixer.c                                 |   16 ++-
 tools/hv/hv_kvp_daemon.c                          |    8 +
 78 files changed, 580 insertions(+), 411 deletions(-)

Alan Cox (1):
      key: Fix resource leak

Alex Deucher (3):
      drm/radeon: add Richland pci ids
      drm/radeon: add support for Richland APUs
      drm/radeon/benchmark: make sure bo blit copy exists before using it

Andy Grover (1):
      target/iscsi: Fix mutual CHAP auth on big-endian arches

Ben Hutchings (14):
      sfc: Convert firmware subtypes to native byte order in efx_mcdi_get_b=
oard_cfg()
      sfc: Add parentheses around use of bitfield macro arguments
      sfc: Fix MCDI structure field lookup
      sfc: Really disable flow control while flushing
      sfc: Fix timekeeping in efx_mcdi_poll()
      sfc: Disable VF queues during register self-test
      sfc: Avoid generating over-length MC_CMD_FLUSH_RX_QUEUES request
      sfc: Correctly initialise reset_method in siena_test_chip()
      sfc: Properly sync RX DMA buffer when it is not the last in the page
      sfc: Fix efx_rx_buf_offset() in the presence of swiotlb
      sfc: Detach net device when stopping queues for reconfiguration
      sfc: Disable soft interrupt handling during efx_device_detach_sync()
      sfc: Only use TX push if a single descriptor is to be written
      asus-laptop: Do not call HWRS on init

Bing Zhao (1):
      mwifiex: fix potential out-of-boundary access to ibss rate table

CQ Tang (1):
      x86-64: Fix the failure case in copy_user_handle_tail()

Daniel Mack (2):
      ALSA: snd-usb: mixer: propagate errors up the call chain
      ALSA: snd-usb: mixer: ignore -EINVAL in snd_usb_mixer_controls()

Daniel Pieczko (2):
      sfc: Work-around flush timeout when flushes have completed
      sfc: lock TX queues when calling netif_device_detach()

David Ward (1):
      net/ipv4: Ensure that location of timestamp option is stored

Denis V. Lunev (1):
      ipv4: fix definition of FIB_TABLE_HASHSZ

Dmitry Artamonow (1):
      usb-storage: add unusual_devs entry for Samsung YP-Z3 mp3 player

Dmitry Torokhov (1):
      USB: xhci - fix bit definitions for IMAN register

Eric Dumazet (1):
      tcp: fix skb_availroom()

Felix Fietkau (1):
      rt2x00: error in configurations with mesh support disabled

Frederic Weisbecker (1):
      nohz: Make tick_nohz_irq_exit() irq safe

Greg Kroah-Hartman (2):
      Revert "USB: EHCI: don't check DMA values in QH overlays"
      Linux 3.4.38

Hannes Frederic Sowa (1):
      inet: limit length of fragment queue hash table bucket lists

Hannes Reinecke (1):
      USB: xhci: correctly enable interrupts

Jan Kara (2):
      jbd2: fix use after free in jbd2_journal_dirty_metadata()
      udf: Fix bitmap overflow on large filesystems with small block size

Jeff Layton (1):
      cifs: ignore everything in SPNEGO blob after mechTypes

Johan Hovold (4):
      USB: cdc-acm: fix device unregistration
      USB: serial: fix interface refcounting
      USB: garmin_gps: fix memory leak on disconnect
      USB: io_ti: fix get_icount for two port adapters

Kees Cook (3):
      drm/i915: restrict kernel address leak in debugfs
      drm/i915: bounds check execbuffer relocation count
      exec: use -ELOOP for max recursion depth

Larry Finger (2):
      rtlwifi: rtl8192cu: Fix schedule while atomic bug splat
      rtlwifi: rtl8192cu: Fix problem that prevents reassociation

Lekensteyn (1):
      i915: initialize CADL in opregion

Maciej =C5=BBenczykowski (1):
      bnx2x: fix occasional statistics off-by-4GB error

Mark Rutland (1):
      clockevents: Don't allow dummy broadcast timers

Mathias Krause (2):
      isofs: avoid info leak on export
      udf: avoid info leak on export

Michael S. Tsirkin (1):
      vhost/net: fix heads usage of ubuf_info

Mike Marciniszyn (1):
      IPoIB: Fix send lockup due to missed TX completion

Nithin Sujir (1):
      tg3: 5715 does not link up when autoneg off

Steven Rostedt (Red Hat) (2):
      tracing: Fix race in snapshot swapping
      tracing: Fix free of probe entry by calling call_rcu_sched()

Stuart Hodgson (1):
      sfc: Do not attempt to flush queues if DMA is disabled

Takashi Iwai (2):
      ALSA: hda/cirrus - Fix the digital beep registration
      ALSA: hda - Fix typo in checking IEC958 emphasis bit

Theodore Ts'o (1):
      ext4: fix data=3Djournal fast mount/umount hang

Tkhai Kirill (1):
      sunsu: Fix panic in case of nonexistent port at "console=3DttySY" cmd=
line option

Tomas Hozza (1):
      tools: hv: Netlink source address validation allows DoS

Torsten Duwe (2):
      KMS: fix EDID detailed timing vsync parsing
      KMS: fix EDID detailed timing frame rate

Veaceslav Falico (2):
      netconsole: don't call __netpoll_cleanup() while atomic
      bonding: don't call update_speed_duplex() under spinlocks

Vlad Yasevich (2):
      sctp: Use correct sideffect command in duplicate cookie handling
      rtnetlink: Mask the rta_type when range checking

Wanpeng Li (1):
      mm/hugetlb: fix total hugetlbfs pages count when using memory overcom=
mit accouting

Xufeng Zhang (1):
      sctp: don't break the loop while meeting the active_path so as to fin=
d the matched transport

Zheng Liu (1):
      ext4: fix the wrong number of the allocated blocks in ext4_split_exte=
nt()


--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRVJi3AAoJEDjbvchgkmk+EPEP/ijEc+x7wekXeNIAn6qAhuwm
eh22/nart0wQZxq/Ntnls5Np9dTzkcb39ms2J4r6ozkrBL1aNH5w4Bka5IkAte85
mwbmNWQk6IZa/236rZCX2DKbeVqXgZi3+UyFg9J5d5oc+EctEaIdufXILZChnSrR
L1zkPN8PxlY3yKYYJaP/OkIplIUHMFU+d1KzWJATT6IDyUVdvCBnqq142ASKn4L9
Xyfe/SdpV7hE5Pa+FH9M9V5dJrYWwtMSABHGj636KDXxR/NhKm5ub0XytTJG86ak
BXHC2J92UsoySSJIjJa+vCMj6Dt4ZpFU0ONzWuz/uToGVE4fdfir8DWA+TstKj2K
qakK0cq9XlGoNEWR1mt99Emnuk6BJydE5kG0+US+Ljkf7yfPR3C0k3dAHEuTuz+x
le/WNimNay0tu0eS0g7xCM8JJhJEMuaiLxf6YQ5HX0AsPvjsHYIKtnp5lRv384PO
iBEA1gEsrEHM5POCXA/V47vDKEOTl0BDfsUTVyss+qvxZFr8ZVFjXc3tgDAXRxpu
ecc97RLt4QBYHPqkrQu+97P0iv4M5w5iESJCiRh2hp0D/8RX/3zTCJkXkqghNF6B
iSeRg6boNsAnyq+/2bVJu8JwDIYdAV/Rhfe6QSTC/crglDlxaY3/Gt+fw5X9ibU0
AIYYGCXblC01w/jZg7hz
=nr4O
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
