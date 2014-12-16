Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaLPWOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 17:14:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56365 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaLPWOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 17:14:05 -0500
Date: Tue, 16 Dec 2014 14:14:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.17.7
Message-ID: <20141216221404.GA6026@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.17.7 kernel.

All users of the 3.17 kernel series must upgrade.

The updated 3.17.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.17.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                              |    2 -
 arch/mips/net/bpf_jit.c                               |    4 +-
 arch/x86/boot/compressed/Makefile                     |    2 -
 drivers/acpi/ec.c                                     |    4 +-
 drivers/ata/ahci.c                                    |    4 ++
 drivers/ata/sata_fsl.c                                |    2 -
 drivers/gpu/drm/i915/intel_display.c                  |    2 -
 drivers/gpu/drm/i915/intel_lvds.c                     |   22 +++++++------=
--
 drivers/gpu/drm/nouveau/core/engine/device/nvc0.c     |    1=20
 drivers/gpu/drm/nouveau/nouveau_drm.c                 |    2 -
 drivers/gpu/drm/radeon/radeon_cs.c                    |    9 ++----
 drivers/gpu/drm/radeon/radeon_kms.c                   |    2 +
 drivers/gpu/drm/radeon/radeon_object.c                |    7 ++++
 drivers/i2c/busses/i2c-cadence.c                      |   11 +++++++
 drivers/i2c/busses/i2c-davinci.c                      |    8 ++---
 drivers/i2c/busses/i2c-omap.c                         |   10 +++---
 drivers/input/evdev.c                                 |    2 -
 drivers/media/i2c/smiapp/smiapp-core.c                |    2 -
 drivers/media/rc/ir-rc6-decoder.c                     |    2 -
 drivers/media/usb/s2255/s2255drv.c                    |    2 -
 drivers/net/bonding/bond_netlink.c                    |    7 ++++
 drivers/net/ethernet/broadcom/tg3.c                   |    3 +-
 drivers/net/ethernet/marvell/mvneta.c                 |    5 ++-
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c |    2 -
 drivers/net/vxlan.c                                   |   14 +++------
 drivers/net/xen-netfront.c                            |    8 ++---
 drivers/of/fdt.c                                      |    2 -
 fs/fat/namei_vfat.c                                   |   20 +++++++------
 include/net/inet_common.h                             |    2 +
 mm/frontswap.c                                        |    4 ++
 mm/memory.c                                           |   26 +++++++++----=
-----
 mm/mmap.c                                             |   10 ++++--
 mm/rmap.c                                             |    6 ++--
 mm/slab.c                                             |    2 -
 mm/vmpressure.c                                       |    8 +++--
 net/core/rtnetlink.c                                  |    1=20
 net/ipv4/af_inet.c                                    |   11 +++++++
 net/ipv4/gre_offload.c                                |    3 ++
 net/ipv4/ip_vti.c                                     |    1=20
 net/ipv4/ping.c                                       |   12 +-------
 net/ipv4/tcp.c                                        |    2 -
 net/ipv6/ip6_gre.c                                    |    4 +-
 net/ipv6/ip6_vti.c                                    |   11 +++++++
 net/netlink/af_netlink.c                              |    2 -
 net/sctp/output.c                                     |    4 +-
 sound/pci/hda/patch_analog.c                          |    1=20
 sound/pci/hda/patch_realtek.c                         |    1=20
 sound/usb/midi.c                                      |    2 +
 48 files changed, 163 insertions(+), 111 deletions(-)

Al Viro (1):
      fat: fix oops on corrupted vfat fs

Alexander Duyck (1):
      vxlan: Fix boolean flip in VXLAN_F_UDP_ZERO_CSUM6_[TX|RX]

Alexander Kochetkov (2):
      i2c: omap: fix NACK and Arbitration Lost irq handling
      i2c: omap: fix i207 errata handling

Andrew Morton (2):
      mm/vmpressure.c: fix race in vmpressure_work_fn()
      drivers/input/evdev.c: don't kfree() a vmalloc address

Chris Clayton (1):
      x86: Use $(OBJDUMP) instead of plain objdump

Christian K=F6nig (1):
      drm/radeon: sync all BOs involved in a CS v2

Daniel Borkmann (2):
      net: sctp: use MAX_HEADER for headroom reserve in output path
      netlink: use jhash as hashfn for rhashtable

Daniel Forrest (1):
      mm: fix anon_vma_clone() error treatment

Daniel Vetter (2):
      drm/i915: More cautious with pch fifo underruns
      drm/i915: Unlock panel even when LVDS is disabled

Dave Airlie (1):
      nouveau: move the hotplug ignore to correct place.

David H=E4rdeman (1):
      media: rc-core: fix toggle handling in the rc6 decoder

David Vrabel (1):
      xen-netfront: use correct linear area after linearizing an skb

Denis Kirjanov (1):
      mips: bpf: Fix broken BPF_MOD

Devin Ryles (1):
      AHCI: Add DeviceIDs for Sunrise Point-LP SATA controller

Dmitry Torokhov (1):
      sata_fsl: fix error handling of irq_of_parse_and_map

Eric Dumazet (1):
      net: mvneta: fix race condition in mvneta_tx()

Greg Kroah-Hartman (2):
      Revert: ACPI / EC: Add support to disallow QR_EC to be issued before =
completing previous QR_EC
      Linux 3.17.7

Grygorii Strashko (1):
      i2c: davinci: generate STP always when NACK is received

Hugh Dickins (1):
      mm: fix swapoff hang after page migration and fork

Ian Campbell (1):
      of/fdt: memblock_reserve /memreserve/ regions in the case of partial =
overlap

Ilia Mirkin (1):
      drm/nouveau/gf116: remove copy1 engine

Jack Morgenstein (1):
      net/mlx4_core: Limit count field to 24 bits in qp_alloc_res

Marcelo Leitner (1):
      Fix race condition between vxlan_sock_add and vxlan_sock_release

Michel D=E4nzer (1):
      drm/radeon: Ignore RADEON_GEM_GTT_WC on 32-bit x86

Nicolas Dichtel (1):
      rtnetlink: release net refcnt on error in do_setlink()

Paul Mackerras (1):
      slab: fix nodeid bounds check for non-contiguous node IDs

Petr Mladek (1):
      drm/radeon: kernel panic in drm_calc_vbltimestamp_from_scanoutpos wit=
h 3.18.0-rc6

Sakari Ailus (1):
      media: smiapp: Only some selection targets are settable

Seth Forshee (1):
      xen-netfront: Remove BUGs on paged skb data which crosses a page boun=
dary

Takashi Iwai (3):
      ALSA: hda - Add EAPD fixup for ASUS Z99He laptop
      ALSA: hda - Fix built-in mic at resume on Lenovo Ideapad S210
      ALSA: usb-audio: Don't resubmit pending URBs at MIDI error recovery

Tejun Heo (1):
      ahci: disable MSI on SAMSUNG 0xa800 SSD

Thadeu Lima de Souza Cascardo (1):
      tg3: fix ring init when there are more TX than RX channels

Thomas Graf (1):
      bond: Check length of IFLA_BOND_ARP_IP_TARGET attributes

Tom Herbert (1):
      gre: Set inner mac header in gro complete

Vishnu Motghare (1):
      i2c: cadence: Set the hardware time-out register to maximum value

Weijie Yang (1):
      mm: frontswap: invalidate expired data on a dup-store failure

Willem de Bruijn (1):
      net-timestamp: make tcp_recvmsg call ipv6_recv_error for AF_INET6 soc=
ks

Yuri Chislov (1):
      ipv6: gre: fix wrong skb->protocol in WCCP

lucien (1):
      ip_tunnel: the lack of vti_link_ops' dellink() cause kernel panic

sensoray-dev (1):
      media: s2255drv: fix payload size for JPG, MJPEG

willy tarreau (1):
      net: mvneta: fix Tx interrupt delay


--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUkK6sAAoJEDjbvchgkmk+HCwQAMNMidrM1gOryDZZaPh7/27h
UBE3x/OdLjv4liOYJ/rYmK3CdZszrz0TYpoi3g4JWS2DpEmzg7lMPcUZp0ux9vnl
cCZzQ3nL8u+zUTyHgk07Pc6Brsy8++8hxM9YlOpOi0ccuwMrYBXkiIi+DdCuQSZ6
VJKEM/3BUwhSO7u7hZp72P84qbDxYY156exfuXhOH2gwU6cnY+uuub2FBo034Pat
8cXVlWYkgEqY57rkoCUMIzQw6jHhqYLvF2QTiqYhzDfpuWL0bI0Fq+go4MiyRzM+
fMe5mTsjCHfSjDNkhPp5rHJVl8/wM4D6z0C4gqTgeakNkLyTm/mTAPIRjMRkl6lC
E+ANKNjax9hPj+OupVioFhCpL58zP1zHdUvNAFhYbynxgpXthyiQRBYfivx31Fl1
Ps8WsisKzJ/DtUfFwE97fMPgfHESbhmp/CsfaKmIagxP4DbVz5tZNIxjqPd5GKQA
lfwttrPSjDTvCGRwk+9Tp5nIDuq1WoLIN58z+iVMMREIjhQj9Y5XHtU2oegxhPUG
UKi4giaih1SZTUqDNzGMHxOAkAQmKzDRwzViK7IXKgYHDmu8DlyxR37QmJkosgn8
o2rAHQvtl8HaENosgsAxfTAllig8S5DczVLkoCmdpCdt+YLwhfbnOucgWNPa2RQV
e4Pou4RIbqIshnl9fe6N
=geU1
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
