Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab3JMXG2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 19:06:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab3JMXG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 19:06:26 -0400
Date: Sun, 13 Oct 2013 16:07:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.66
Message-ID: <20131013230722.GA13488@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.66 kernel.

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

 Makefile                                    |    2 -
 arch/arm/mm/init.c                          |    3 +
 arch/ia64/mm/contig.c                       |    2 +
 arch/ia64/mm/discontig.c                    |    2 +
 arch/parisc/mm/init.c                       |    2 +
 arch/powerpc/kernel/iommu.c                 |    2 -
 arch/powerpc/kernel/vio.c                   |   12 ++++--
 arch/powerpc/lib/checksum_64.S              |    4 +-
 arch/sparc/kernel/entry.S                   |    2 -
 arch/sparc/kernel/ktlb.S                    |    3 -
 arch/sparc/kernel/syscalls.S                |    8 ++--
 arch/sparc/kernel/trampoline_64.S           |    2 -
 arch/sparc/lib/ksyms.c                      |    9 ----
 arch/tile/include/asm/percpu.h              |   34 ++++++++++++++++-
 arch/unicore32/mm/init.c                    |    3 +
 drivers/acpi/acpi_ipmi.c                    |   24 +++++++-----
 drivers/block/cciss.c                       |    1=20
 drivers/block/cpqarray.c                    |    1=20
 drivers/dma/imx-dma.c                       |   31 +++++++---------
 drivers/infiniband/ulp/srpt/ib_srpt.c       |   14 +++----
 drivers/net/bonding/bond_main.c             |   13 +++++-
 drivers/net/ethernet/freescale/gianfar.c    |   11 +++++
 drivers/net/ethernet/freescale/gianfar.h    |   11 +++++
 drivers/net/ethernet/via/via-rhine.c        |    9 +++-
 drivers/net/ethernet/xilinx/ll_temac_main.c |    6 +++
 drivers/net/ppp/pptp.c                      |    2 -
 drivers/net/usb/dm9601.c                    |    2 -
 drivers/net/wireless/p54/p54usb.c           |    1=20
 drivers/net/wireless/rtlwifi/wifi.h         |    2 -
 drivers/scsi/esp_scsi.c                     |   14 ++++---
 drivers/scsi/esp_scsi.h                     |    1=20
 drivers/staging/comedi/drivers/ni_65xx.c    |   26 +++++--------
 drivers/usb/serial/option.c                 |    3 +
 fs/btrfs/relocation.c                       |   14 +++----
 fs/ext4/namei.c                             |    3 +
 include/linux/mm.h                          |    3 +
 include/net/ip.h                            |   12 ++++--
 include/net/ipip.h                          |    2 -
 lib/show_mem.c                              |    3 +
 mm/page_alloc.c                             |    7 +++
 net/bluetooth/hci_event.c                   |    6 ++-
 net/bridge/br_private.h                     |    1=20
 net/bridge/br_stp.c                         |   23 ++++++++----
 net/bridge/br_stp_if.c                      |   12 +++++-
 net/caif/cfctrl.c                           |    3 +
 net/core/flow_dissector.c                   |    4 +-
 net/core/netpoll.c                          |    9 ++--
 net/ipv4/igmp.c                             |    8 ++--
 net/ipv4/inetpeer.c                         |    4 +-
 net/ipv4/ip_output.c                        |    8 ++--
 net/ipv4/ipmr.c                             |    2 -
 net/ipv4/raw.c                              |    2 -
 net/ipv4/xfrm4_mode_tunnel.c                |    2 -
 net/ipv6/ip6_output.c                       |   53 +++++++++++------------=
-----
 net/ipv6/mcast.c                            |    4 +-
 net/netfilter/ipvs/ip_vs_xmit.c             |    2 -
 net/sctp/ipv6.c                             |   42 ++++++----------------
 net/sctp/socket.c                           |    3 +
 sound/soc/codecs/88pm860x-codec.c           |    3 +
 sound/soc/codecs/max98095.c                 |    4 +-
 60 files changed, 297 insertions(+), 204 deletions(-)

Andre Guedes (2):
      Bluetooth: Fix security level for peripheral role
      Bluetooth: Fix encryption key size for peripheral role

Ansis Atteka (2):
      ip: use ip_hdr() in __ip_make_skb() to retrieve IP header
      ip: generate unique IP identificator if local fragmentation is allowed

Chris Healy (1):
      resubmit bridge: fix message_age_timer calculation

Chris Metcalf (1):
      tile: use a more conservative __my_cpu_offset in CONFIG_PREEMPT

Christian Lamparter (1):
      p54usb: add USB ID for Corega WLUSB2GTST USB adapter

Claudiu Manoil (1):
      gianfar: Change default HW Tx queue scheduling mode

Dan Carpenter (4):
      cpqarray: fix info leak in ida_locked_ioctl()
      cciss: fix info leak in cciss_ioctl32_passthru()
      ASoC: max98095: a couple array underflows
      ASoC: 88pm860x: array overflow in snd_soc_put_volsw_2r_st()

Daniel Borkmann (2):
      net: sctp: fix smatch warning in sctp_send_asconf_del_ip
      net: sctp: fix ipv6 ipsec encryption bug in sctp_v6_xmit

Dave Jones (1):
      caif: Add missing braces to multiline if in cfctrl_linkup_request

David Rientjes (1):
      mm, show_mem: suppress page counts in non-blockable contexts

David S. Miller (2):
      esp_scsi: Fix tag state corruption when autosensing.
      sparc64: Fix off by one in trampoline TLB mapping installation loop.

Eric Dumazet (1):
      net: flow_dissector: fix thoff for IPPROTO_AH

Greg Kroah-Hartman (1):
      Linux 3.4.66

Hannes Frederic Sowa (1):
      ipv6: udp packets following an UFO enqueued packet need also be handl=
ed by UFO

Herbert Xu (1):
      bridge: Clamp forward_delay when enabling STP

Ian Abbott (1):
      staging: comedi: ni_65xx: (bug fix) confine insn_bits to one subdevice

Jack Wang (1):
      ib_srpt: always set response for task management

Josef Bacik (1):
      Btrfs: change how we queue blocks for backref checking

Kirill Tkhai (4):
      sparc64: Fix ITLB handler of null page
      sparc64: Remove RWSEM export leftovers
      sparc64: Fix not SRA'ed %o5 in 32-bit traced syscall
      sparc32: Fix exit flag passed from traced sys_sigreturn

Larry Finger (1):
      rtlwifi: Align private space in rtl_priv struct

Lv Zheng (1):
      ACPI / IPMI: Fix atomic context requirement of ipmi_msg_handler()

Michael Grzeschik (3):
      dmaengine: imx-dma: fix lockdep issue between irqhandler and tasklet
      dmaengine: imx-dma: fix callback path in tasklet
      dmaengine: imx-dma: fix slow path issue in prep_dma_cyclic

Michal Mal=FD (1):
      USB: serial: option: Ignore card reader interface on Huawei E1750

Neil Horman (1):
      bonding: Fix broken promiscuity reference counting issue

Nicholas Bellinger (1):
      ib_srpt: Destroy cm_id before destroying QP.

Nikolay Aleksandrov (1):
      netpoll: fix NULL pointer dereference in netpoll_cleanup

Nishanth Aravamudan (1):
      powerpc/iommu: Use GFP_KERNEL instead of GFP_ATOMIC in iommu_init_tab=
le()

Paul E. McKenney (1):
      powerpc: Fix parameter clobber in csum_partial_copy_generic()

Peter Korsgaard (1):
      dm9601: fix IFF_ALLMULTI handling

Prarit Bhargava (1):
      powerpc/vio: Fix modalias_show return values

Ricardo Ribalda (1):
      ll_temac: Reset dma descriptors indexes on ndo_open

Roger Luethi (1):
      via-rhine: fix VLAN priority field (PCP, IEEE 802.1p)

Salam Noureddine (2):
      ipv4 igmp: use in_dev_put in timer handlers instead of __in_dev_put
      ipv6 mcast: use in6_dev_put in timer handlers instead of __in6_dev_put

Theodore Ts'o (1):
      ext4: avoid hang when mounting non-journal filesystems with orphan li=
st


--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSWyeqAAoJEDjbvchgkmk+5RwQAKsqtnpVCZg41+QL3XzcuAe7
WGwm555gEd5OiFDcH7v15woqcScsBMqGNsTfnbMV9caOmpmlcylm5njUrcFAOcTL
+64VZVxGfrwCROYXG5TDn7OGfvOtyEu4DXdJc1ISsLRgijG17IA8WP8oHypVjVs6
MIN6lNwETAIaMfKRbBG1dVBsapZ9zvr1EY+M1o6LwG/+WmFhMG8JvXmpAa6/gGj9
klXWwAvR4nZJWBUBnKzpGvo2596QTZrsISrY1I00/Y3x18/ZZxHDk/rKex0QkWrp
ccokevitAkKxbQfd7h1MB8QblC5WbRqJNGmrV2B4GBODbMwyGu7OLvO3cOFK4K5K
6AhlN2bfYyNUsBJgXKD2I4UgEvZDRgcKwqYHDzC/3V51/GRfw+jdXZr4iD3wjA/E
01Ci8Zddv/0T/7D0ubcuGYdvVRl16v/qomtvBWRHcQuA0FfYeBIWefxeGpNiYBcY
vtqxsZQYXP211CdFngYwfljYwGpdM8COmPyubpAkd7Vp+E1QGOIoeQm7j43EX254
i+XUGoA0/wnVfo5Ori5VLG8nZvgWMIjQS3lBBfImVPiQJILn8Tve0wkFEYTr2EFp
nvERyrnrrpHQtXHQaIMo++sHBJHGVUjV5FyAm0OlI+efdHAKXKYgqK3gGoT9lBsa
IAS0JIQJa3dhDpuXgkmH
=HLDc
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
