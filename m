Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab3C1TYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 15:24:22 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:35333 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab3C1TYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 15:24:19 -0400
Date: Thu, 28 Mar 2013 12:24:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.8.5
Message-ID: <20130328192416.GA19965@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.8.5 kernel.

All users of the 3.8 kernel series must upgrade.

The updated 3.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.8.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                          |    4=20
 arch/arm/boot/dts/tegra20.dtsi                    |    2=20
 arch/arm/boot/dts/tegra30.dtsi                    |    2=20
 arch/arm/mm/dma-mapping.c                         |    5=20
 arch/x86/lib/usercopy_64.c                        |    4=20
 drivers/acpi/glue.c                               |   35 ++----
 drivers/firmware/Kconfig                          |   18 +++
 drivers/firmware/efivars.c                        |   70 ++++--------
 drivers/gpu/drm/drm_edid.c                        |    3=20
 drivers/gpu/drm/i915/i915_debugfs.c               |    2=20
 drivers/gpu/drm/i915/i915_gem_execbuffer.c        |   11 +
 drivers/gpu/drm/i915/intel_dp.c                   |    2=20
 drivers/gpu/drm/i915/intel_panel.c                |   13 --
 drivers/gpu/drm/mgag200/mgag200_mode.c            |   10 -
 drivers/gpu/drm/radeon/ni.c                       |   33 ++++-
 drivers/gpu/drm/radeon/radeon_benchmark.c         |   16 +-
 drivers/gpu/drm/radeon/si.c                       |    1=20
 drivers/i2c/busses/i2c-tegra.c                    |   13 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c           |    8 +
 drivers/md/dm-bufio.c                             |    2=20
 drivers/md/dm-thin.c                              |    4=20
 drivers/md/dm-verity.c                            |   39 +++++-
 drivers/md/persistent-data/dm-btree-remove.c      |   46 ++++----
 drivers/md/raid5.c                                |  116 ++++++++++++++---=
---
 drivers/md/raid5.h                                |    1=20
 drivers/net/bonding/bond_main.c                   |    6 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |    1=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h |    3=20
 drivers/net/ethernet/broadcom/tg3.c               |    8 +
 drivers/net/ethernet/sfc/efx.c                    |   16 ++
 drivers/net/ethernet/sfc/efx.h                    |    4=20
 drivers/net/ethernet/sfc/net_driver.h             |    4=20
 drivers/net/ethernet/sfc/nic.c                    |    3=20
 drivers/net/ethernet/sfc/ptp.c                    |    2=20
 drivers/net/ethernet/sfc/rx.c                     |   25 ++--
 drivers/net/netconsole.c                          |   15 +-
 drivers/net/usb/cdc_mbim.c                        |   11 -
 drivers/net/usb/cdc_ncm.c                         |   49 +++++---
 drivers/net/usb/qmi_wwan.c                        |   49 ++------
 drivers/net/wireless/mwifiex/join.c               |    7 -
 drivers/net/wireless/rt2x00/rt2x00dev.c           |    2=20
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c       |   89 ++++++---------
 drivers/rtc/rtc-at91rm9200.c                      |   50 +++++---
 drivers/rtc/rtc-at91rm9200.h                      |    1=20
 drivers/target/iscsi/iscsi_target_auth.c          |    5=20
 drivers/target/target_core_file.h                 |    2=20
 drivers/tty/serial/sunsu.c                        |   21 +--
 drivers/usb/class/cdc-acm.c                       |    3=20
 drivers/usb/core/hcd-pci.c                        |   23 ++--
 drivers/usb/gadget/g_ffs.c                        |    4=20
 drivers/usb/host/ehci-hcd.c                       |    7 -
 drivers/usb/host/ehci-hub.c                       |    2=20
 drivers/usb/host/ehci-q.c                         |   31 ++++-
 drivers/usb/host/ehci-timer.c                     |    2=20
 drivers/usb/host/xhci.c                           |    3=20
 drivers/usb/host/xhci.h                           |    4=20
 drivers/usb/musb/da8xx.c                          |    2=20
 drivers/usb/serial/garmin_gps.c                   |    7 -
 drivers/usb/serial/io_ti.c                        |    1=20
 drivers/usb/serial/usb-serial.c                   |    3=20
 drivers/usb/storage/unusual_devs.h                |    7 +
 drivers/vhost/net.c                               |    3=20
 drivers/video/ep93xx-fb.c                         |    1=20
 drivers/watchdog/sp5100_tco.c                     |  126 +----------------=
-----
 drivers/watchdog/sp5100_tco.h                     |    2=20
 fs/cifs/asn1.c                                    |   53 ---------
 fs/cifs/cifsfs.c                                  |   24 ++++
 fs/cifs/cifsfs.h                                  |    4=20
 fs/cifs/file.c                                    |    6 -
 fs/ext4/ext4.h                                    |    6 -
 fs/ext4/extents.c                                 |    8 +
 fs/ext4/ialloc.c                                  |    4=20
 fs/ext4/inode.c                                   |    3=20
 fs/ext4/mballoc.c                                 |   12 +-
 fs/ext4/resize.c                                  |    4=20
 fs/ext4/super.c                                   |    4=20
 fs/jbd2/transaction.c                             |   15 +-
 fs/nfsd/vfs.c                                     |    3=20
 fs/proc/generic.c                                 |   21 +--
 fs/proc/inode.c                                   |   12 --
 fs/udf/udf_sb.h                                   |    2=20
 include/drm/drm_pciids.h                          |   13 ++
 include/linux/skbuff.h                            |   13 +-
 include/linux/usb/cdc_ncm.h                       |    1=20
 include/net/inet_frag.h                           |    9 +
 include/net/ip_fib.h                              |   12 --
 ipc/mqueue.c                                      |    3=20
 kernel/time/tick-broadcast.c                      |    3=20
 kernel/trace/ftrace.c                             |    4=20
 kernel/trace/trace.c                              |   21 ++-
 mm/hugetlb.c                                      |    8 +
 net/batman-adv/bat_iv_ogm.c                       |    6 -
 net/bridge/br_netlink.c                           |    1=20
 net/core/rtnetlink.c                              |    2=20
 net/ipv4/inet_fragment.c                          |   20 +++
 net/ipv4/ip_fragment.c                            |   11 -
 net/ipv4/ip_gre.c                                 |    5=20
 net/ipv4/ip_options.c                             |    5=20
 net/ipv4/tcp.c                                    |    2=20
 net/ipv4/tcp_ipv4.c                               |   14 +-
 net/ipv4/tcp_output.c                             |    1=20
 net/ipv6/netfilter/nf_conntrack_reasm.c           |   12 +-
 net/ipv6/reassembly.c                             |    8 +
 net/ipv6/tcp_ipv6.c                               |    7 +
 net/sctp/associola.c                              |    2=20
 net/sctp/sm_statefuns.c                           |    2=20
 sound/pci/hda/hda_codec.c                         |    2=20
 sound/pci/hda/patch_conexant.c                    |    8 -
 sound/usb/mixer.c                                 |   21 ++-
 109 files changed, 778 insertions(+), 683 deletions(-)

Al Viro (1):
      saner proc_get_inode() calling conventions

Alan Stern (3):
      USB: EHCI: work around silicon bug in Intel's EHCI controllers
      USB: EHCI: fix regression during bus resume
      USB: EHCI: fix regression in QH unlinking

Alex Deucher (5):
      drm/radeon: add Richland pci ids
      drm/radeon: add support for Richland APUs
      drm/radeon: fix S/R on VM systems (cayman/TN/SI)
      drm/radeon: fix backend map setup on 1 RB trinity boards
      drm/radeon/benchmark: make sure bo blit copy exists before using it

Andrzej Pietrasiewicz (1):
      usb: gadget: ffs: fix enable multiple instances

Andy Grover (1):
      target/iscsi: Fix mutual CHAP auth on big-endian arches

Ben Hutchings (6):
      sfc: Properly sync RX DMA buffer when it is not the last in the page
      sfc: Fix efx_rx_buf_offset() in the presence of swiotlb
      sfc: Detach net device when stopping queues for reconfiguration
      sfc: Disable soft interrupt handling during efx_device_detach_sync()
      sfc: Only use TX push if a single descriptor is to be written
      efivars: Fix check for CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE

Bing Zhao (1):
      mwifiex: fix potential out-of-boundary access to ibss rate table

Bj=C3=B8rn Mork (2):
      net: qmi_wwan: set correct altsetting for Gobi 1K devices
      net: cdc_ncm, cdc_mbim: allow user to prefer NCM for backwards compat=
ibility

CQ Tang (1):
      x86-64: Fix the failure case in copy_user_handle_tail()

Daniel Mack (2):
      ALSA: snd-usb: mixer: propagate errors up the call chain
      ALSA: snd-usb: mixer: ignore -EINVAL in snd_usb_mixer_controls()

Daniel Vetter (1):
      Revert "drm/i915: write backlight harder"

David Ward (1):
      net/ipv4: Ensure that location of timestamp option is stored

Denis V. Lunev (1):
      ipv4: fix definition of FIB_TABLE_HASHSZ

Dmitry Artamonow (1):
      usb-storage: add unusual_devs entry for Samsung YP-Z3 mp3 player

Dmitry Torokhov (1):
      USB: xhci - fix bit definitions for IMAN register

Eric Dumazet (2):
      tcp: fix skb_availroom()
      tcp: dont handle MTU reduction on LISTEN socket

Felix Fietkau (1):
      rt2x00: error in configurations with mesh support disabled

Greg Kroah-Hartman (1):
      Linux 3.8.5

H Hartley Sweeten (1):
      drivers/video/ep93xx-fb.c: include <linux/io.h> for devm_ioremap()

Hannes Frederic Sowa (1):
      inet: limit length of fragment queue hash table bucket lists

Hannes Reinecke (1):
      USB: xhci: correctly enable interrupts

Jan Kara (2):
      jbd2: fix use after free in jbd2_journal_dirty_metadata()
      udf: Fix bitmap overflow on large filesystems with small block size

Jeff Layton (1):
      cifs: ignore everything in SPNEGO blob after mechTypes

Joe Thornber (1):
      dm thin: fix discard corruption

Johan Hovold (4):
      USB: cdc-acm: fix device unregistration
      USB: serial: fix interface refcounting
      USB: garmin_gps: fix memory leak on disconnect
      USB: io_ti: fix get_icount for two port adapters

Jonathan Brassow (1):
      MD RAID5: Avoid accessing gendisk or queue structs when not available

Julia Lawall (1):
      drivers/net/ethernet/sfc/ptp.c: adjust duplicate test

Julia Lemire (1):
      drm/mgag200: Bug fix: Modified pll algorithm for EH project

Kees Cook (2):
      drm/i915: restrict kernel address leak in debugfs
      drm/i915: bounds check execbuffer relocation count

Kent Overstreet (1):
      nfsd: fix bad offset use

Larry Finger (2):
      rtlwifi: rtl8192cu: Fix schedule while atomic bug splat
      rtlwifi: rtl8192cu: Fix problem that prevents reassociation

Laxman Dewangan (2):
      i2c: tegra: check the clk_prepare_enable() return value
      ARM: tegra: fix register address of slink controller

Linus Torvalds (1):
      vfs,proc: guarantee unique inodes in /proc

Lukas Czerner (1):
      ext4: use s_extent_max_zeroout_kb value as number of kb

Maciej =C5=BBenczykowski (1):
      bnx2x: fix occasional statistics off-by-4GB error

Marek Lindner (1):
      batman-adv: verify tt len does not exceed packet len

Marek Szyprowski (1):
      ARM: DMA-mapping: add missing GFP_DMA flag for atomic buffer allocati=
on

Mark Rutland (1):
      clockevents: Don't allow dummy broadcast timers

Mateusz Guzik (1):
      cifs: delay super block destruction until all cifsFileInfo objects ar=
e gone

Michael S. Tsirkin (1):
      vhost/net: fix heads usage of ubuf_info

Michal Schmidt (1):
      bnx2x: add missing napi deletion in error path

Mike Marciniszyn (1):
      IPoIB: Fix send lockup due to missed TX completion

Mikhail Kshevetskiy (1):
      usb: musb: da8xx: Fix build breakage due to typo

Mikulas Patocka (1):
      dm verity: avoid deadlock

NeilBrown (2):
      md/raid5: schedule_construction should abort if nothing to do.
      md/raid5: ensure sync and DISCARD don't happen at the same time.

Nicholas Bellinger (1):
      target/file: Bump FD_MAX_SECTORS to 2048 to handle 1M sized I/Os

Nicolas Ferre (1):
      drivers/rtc/rtc-at91rm9200.c: use a variable for storing IMR

Nithin Sujir (1):
      tg3: 5715 does not link up when autoneg off

Pavel Emelyanov (1):
      skb: Propagate pfmemalloc on skb from head page only

Rafael J. Wysocki (1):
      ACPI: Rework acpi_get_child() to be more efficient

Seth Forshee (2):
      efivars: Allow disabling use as a pstore backend
      efivars: Add module parameter to disable use as a pstore backend

Steven Rostedt (Red Hat) (4):
      tracing: Fix race in snapshot swapping
      tracing: Fix free of probe entry by calling call_rcu_sched()
      tracing: Protect tracer flags with trace_types_lock
      tracing: Keep overwrite in sync between regular and snapshot buffers

Takahisa Tanaka (2):
      watchdog: sp5100_tco: Set the AcpiMmioSel bitmask value to 1 instead =
of 2
      watchdog: sp5100_tco: Remove code that may cause a boot failure

Takashi Iwai (3):
      ALSA: hda/cirrus - Fix the digital beep registration
      ALSA: hda - Fix typo in checking IEC958 emphasis bit
      Revert "drm/i915: try to train DP even harder"

Theodore Ts'o (2):
      ext4: use atomic64_t for the per-flexbg free_clusters count
      ext4: fix data=3Djournal fast mount/umount hang

Timo Ter=C3=A4s (1):
      Revert "ip_gre: make ipgre_tunnel_xmit() not parse network header as =
IP unconditionally"

Tkhai Kirill (1):
      sunsu: Fix panic in case of nonexistent port at "console=3DttySY" cmd=
line option

Torstein Hegge (1):
      ALSA: usb: Parse UAC2 extension unit like for UAC1

Torsten Duwe (2):
      KMS: fix EDID detailed timing vsync parsing
      KMS: fix EDID detailed timing frame rate

Veaceslav Falico (2):
      netconsole: don't call __netpoll_cleanup() while atomic
      bonding: don't call update_speed_duplex() under spinlocks

Vlad Yasevich (2):
      sctp: Use correct sideffect command in duplicate cookie handling
      rtnetlink: Mask the rta_type when range checking

Vladimir Davydov (1):
      mqueue: sys_mq_open: do not call mnt_drop_write() if read-only

Wanpeng Li (1):
      mm/hugetlb: fix total hugetlbfs pages count when using memory overcom=
mit accouting

Xufeng Zhang (1):
      sctp: don't break the loop while meeting the active_path so as to fin=
d the matched transport

Zheng Liu (1):
      ext4: fix the wrong number of the allocated blocks in ext4_split_exte=
nt()

stephen hemminger (1):
      bridge: reserve space for IFLA_BRPORT_FAST_LEAVE


--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRVJjgAAoJEDjbvchgkmk+4yYQAIKWuAUxBuZHRIp52zj0S7g3
yC59EoIphTIOGCLPG8V7ifX/bL63DiQQ+0GsAukZELqrC4Ehlm0R8p8Tck6RFz3T
NCOaMBgeSJghZSUGlOjvpuHR8KIZHy0GKdTTHjPVjvNyoaHoE6RGOPmepoPu8w9l
tGieHfW/ZcuIPKf8olPwRUTtWHyuHKy79WCxdWh6TvEsUEWPKQveyjEiZ4uD6dHH
UFCc//09hVh5hCXPPaMumXzyqhQrhZfTx46UtRfT1vyTOMc4fprAHw/XMfKvUwGg
kIfTH01DNTaqQKCXx1EBnckeKAFP7JsvksTmR47YAhYE8vIRR1HsCAzPdyU9s10/
mlrbrHlpMMQI9maW3sdZZPiASqSeRyKCFByEx30ZTYAeBNFzp3s1Yko9MPrfJdw/
mi7W3crMVy8scjoS7iw9WOBUeeaD/2OPivI01o+essPZ+IHa7EsG6Xaleo6TqGuN
ESyRw9TbpBD8uqaFFYK8UCFq2LgFXkFT1UO1iB85c/wibExTNP4v0AQ+WaqrPEr2
Mi9R24mq3DqPGO13ACSIinuZsX8rEy7SpWWIl3OmY39K1E6u/eOJpdRvcOz6lDfv
dtJ8YOFkR3deXugDnhP3RKcB+nr9DXWt5h8AanPZ7y1NX+QRAOwqCgm7yoLSEODF
5CT8DTT8Yv1gIu4OGAkC
=xJrP
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
