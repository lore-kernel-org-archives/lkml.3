Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab3G2EJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 00:09:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3G2EJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 00:09:10 -0400
Date: Sun, 28 Jul 2013 21:10:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.4
Message-ID: <20130729041027.GA32206@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.4 kernel.

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

 Makefile                                        |    2=20
 arch/arm/mach-footbridge/dc21285.c              |    2=20
 arch/arm/mach-s3c24xx/clock-s3c2410.c           |  161 ++++++++++++++-----=
-----
 arch/arm/mach-s3c24xx/clock-s3c2440.c           |    3=20
 arch/arm/plat-samsung/include/plat/clock.h      |    5=20
 arch/mips/cavium-octeon/setup.c                 |    3=20
 arch/sparc/kernel/asm-offsets.c                 |    2=20
 arch/sparc/mm/hypersparc.S                      |    8 -
 arch/sparc/mm/swift.S                           |    8 -
 arch/sparc/mm/tsunami.S                         |    6=20
 arch/sparc/mm/viking.S                          |   10 -
 drivers/edac/edac_mc.c                          |    9 +
 drivers/edac/edac_mc_sysfs.c                    |   28 ++--
 drivers/edac/i5100_edac.c                       |    2=20
 drivers/md/bcache/bcache.h                      |    1=20
 drivers/md/bcache/btree.c                       |    4=20
 drivers/md/bcache/closure.c                     |    6=20
 drivers/md/bcache/journal.c                     |    7 -
 drivers/md/bcache/request.c                     |    8 +
 drivers/md/bcache/super.c                       |   31 +++-
 drivers/media/dvb-core/dmxdev.c                 |    8 -
 drivers/media/pci/saa7134/saa7134-alsa.c        |    2=20
 drivers/net/dummy.c                             |    4=20
 drivers/net/ethernet/atheros/alx/main.c         |    5=20
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c |   50 +++++++
 drivers/net/ethernet/cadence/macb.c             |    2=20
 drivers/net/ethernet/emulex/benet/be_main.c     |   14 +-
 drivers/net/ethernet/sfc/rx.c                   |   27 ++--
 drivers/net/ethernet/sun/sunvnet.c              |    2=20
 drivers/net/hyperv/netvsc_drv.c                 |    4=20
 drivers/net/ifb.c                               |    8 +
 drivers/net/macvtap.c                           |   66 ++++++---
 drivers/net/tun.c                               |   69 ++++++----
 drivers/net/virtio_net.c                        |    5=20
 drivers/rapidio/switches/idt_gen2.c             |    2=20
 drivers/scsi/megaraid/megaraid_sas_base.c       |   10 -
 drivers/scsi/mpt3sas/mpt3sas_scsih.c            |   30 ++--
 drivers/usb/serial/cp210x.c                     |    4=20
 drivers/usb/serial/option.c                     |   23 +--
 drivers/vhost/net.c                             |    9 +
 drivers/virtio/virtio_ring.c                    |   56 ++++++--
 fs/block_dev.c                                  |    9 +
 fs/ext4/extents.c                               |   11 +
 fs/fuse/dir.c                                   |   40 ++++-
 fs/lockd/svclock.c                              |    4=20
 include/linux/edac.h                            |    7 -
 include/linux/if_vlan.h                         |    3=20
 include/linux/virtio.h                          |    4=20
 include/net/addrconf.h                          |    3=20
 include/net/udp.h                               |    1=20
 include/uapi/linux/if_pppox.h                   |    4=20
 kernel/hrtimer.c                                |   28 +---
 kernel/power/autosleep.c                        |    3=20
 lib/Kconfig.debug                               |    2=20
 net/8021q/vlan_core.c                           |    2=20
 net/8021q/vlan_dev.c                            |    7 +
 net/9p/trans_common.c                           |   10 -
 net/core/dev.c                                  |   11 +
 net/core/neighbour.c                            |   12 +
 net/ipv4/ip_gre.c                               |    9 -
 net/ipv4/ip_input.c                             |    7 -
 net/ipv4/ip_tunnel.c                            |   97 ++++++++------
 net/ipv4/ip_vti.c                               |    7 -
 net/ipv4/ipip.c                                 |   12 +
 net/ipv4/udp.c                                  |    3=20
 net/ipv6/addrconf.c                             |   28 ++--
 net/ipv6/ip6_fib.c                              |   15 +-
 net/ipv6/ip6_output.c                           |   16 +-
 net/ipv6/mcast.c                                |   18 +-
 net/ipv6/route.c                                |   70 ++++++----
 net/ipv6/sit.c                                  |    2=20
 net/ipv6/udp.c                                  |    7 -
 net/l2tp/l2tp_ppp.c                             |    3=20
 net/sched/sch_qfq.c                             |   85 ++++++++----
 net/x25/af_x25.c                                |   15 +-
 sound/pci/hda/patch_sigmatel.c                  |   13 +
 sound/usb/6fire/pcm.c                           |    2=20
 77 files changed, 839 insertions(+), 437 deletions(-)

Alexander Duyck (1):
      gre: Fix MTU sizing check for gretap tunnels

Alexandr \\\"Sky\\\" Ivanov (1):
      USB: option: add D-Link DWM-152/C1 and DWM-156/C1

Amerigo Wang (1):
      ipv6,mcast: always hold idev->lock before mca_lock

Barry Grussling (1):
      usb: cp210x support SEL C662 Vendor/Device

Ben Hutchings (1):
      sfc: Fix memory leak when discarding scattered packets

Bj=F8rn Mork (2):
      SCSI: megaraid_sas: fix memory leak if SGL has zero length entries
      usb: option: add TP-LINK MA260

Borislav Petkov (1):
      EDAC: Fix lockdep splat

Changli Gao (1):
      net: Swap ver and type in pppoe_hdr

Cong Wang (3):
      gre: fix a regression in ioctl
      vti: remove duplicated code to fix a memory leak
      ipip: fix a regression in ioctl

Dan Williams (1):
      usb: serial: option: add Olivetti Olicard 200

Daniil Bolsun (1):
      USB: option: append Petatel NP10T device to GSM modems list

Dave Jones (1):
      x25: Fix broken locking in ioctl error paths.

Dave Kleikamp (1):
      sunvnet: vnet_port_remove must call unregister_netdev

David Jeffery (1):
      lockd: protect nlm_blocked access in nlmsvc_retry_blocked

Eldad Zack (1):
      ALSA: usb-audio: 6fire: return correct XRUN indication

Enrico Mioso (3):
      usb: serial: option: blacklist ONDA MT689DC QMI interface
      usb: serial: option.c: remove ONDA MT825UP product ID fromdriver
      usb: serial: option: Add ONYX 3G device support

Eric Dumazet (4):
      neighbour: fix a race in neigh_destroy()
      ipv4: set transport header earlier
      vlan: mask vlan prio bits
      vlan: fix a race in egress prio management

Greg Kroah-Hartman (1):
      Linux 3.10.4

Haiyang Zhang (1):
      hyperv: Fix the NETIF_F_SG flag setting in netvsc

Hannes Frederic Sowa (7):
      ipv6: only apply anti-spoofing checks to not-pointopoint tunnels
      ipv6: call udp_push_pending_frames when uncorking a socket with AF_IN=
ET pending data
      ipv6: ip6_append_data_mtu did not care about pmtudisc and frag_size
      ipv6: rt6_check_neigh should successfully verify neigh if no NUD info=
rmation are available
      ipv6: in case of link failure remove route directly instead of lettin=
g it expire
      ipv6: fix route selection if kernel is not compiled with CONFIG_IPV6_=
ROUTER_PREF
      ipv6: only static routes qualify for equal cost multipathing

Jan Kara (1):
      writeback: Fix periodic writeback after fs mount

Jason Wang (4):
      tuntap: correctly linearize skb when zerocopy is used
      macvtap: correctly linearize skb when zerocopy is used
      tuntap: do not zerocopy if iov needs more pages than MAX_SKB_FRAGS
      macvtap: do not zerocopy if iov needs more pages than MAX_SKB_FRAGS

Jongsung Kim (1):
      net/cadence/macb: fix bug/typo in extracting gem_irq_read_clear bit

Kent Overstreet (6):
      bcache: Fix a dumb race
      bcache: Advertise that flushes are supported
      bcache: Shutdown fix
      bcache: Fix a sysfs splat on shutdown
      bcache: Fix GC_SECTORS_USED() calculation
      bcache: Journal replay fix

Liu ShuoX (1):
      PM / Sleep: avoid 'autosleep' in shutdown progress

Luiz Angelo Daros de Luca (1):
      usb: serial: cp210x: Add USB ID for Netgear Switches embedded serial =
adapter

Maarten Lankhorst (1):
      alx: fix lockdep annotation

Markos Chandras (1):
      lib/Kconfig.debug: Restrict FRAME_POINTER for MIPS

Michael S. Tsirkin (3):
      virtio: support unlocked queue poll
      virtio_net: fix race in RX VQ processing
      vhost-net: fix use-after-free in vhost_net_flush

Mike Frysinger (1):
      ARM: footbridge: fix overlapping PCI mappings

Miklos Szeredi (2):
      fuse: readdirplus: fix instantiate
      fuse: readdirplus: sanity checks

Neil Horman (2):
      atl1e: fix dma mapping warnings
      atl1e: unmap partially mapped skb on dma error and free skb

Niels de Vos (1):
      fuse: readdirplus: fix dentry leak

Olivier DANET (1):
      sparc32: vm_area_struct access for old Sun SPARCs.

Paolo Valente (1):
      pkt_sched: sch_qfq: remove a source of high packet delay/jitter

Pravin B Shelar (1):
      ip_tunnels: Use skb-len to PMTU check.

Ralf Baechle (2):
      MIPS: Oceton: Fix build error.
      RAPIDIO: IDT_GEN2: Fix build error.

Sami Rahman (1):
      USB: cp210x: add MMB and PI ZigBee USB Device Support

Sarveshwar Bandi (1):
      be2net: Fix to avoid hardware workaround when not needed

Sasha Levin (1):
      9p: fix off by one causing access violations and memory corruption

Soeren Moch (1):
      media: dmxdev: remove dvb_ringbuffer_flush() on writer side

Sreekanth Reddy (2):
      SCSI: mpt3sas: Infinite loops can occur if MPI2_IOCSTATUS_CONFIG_INVA=
LID_PAGE is not returned
      SCSI: mpt3sas: fix for kernel panic when driver loads with HBA conect=
ed to non LUN 0 configured expander

Sylwester Nawrocki (1):
      ARM: S3C24XX: Add missing clkdev entries for s3c2440 UART

Takashi Iwai (3):
      media: saa7134: Fix unlocked snd_pcm_stop() call
      ALSA: hda - Remove NO_PRESENCE bit override for Dell 1420n Laptop
      ALSA: hda - Fix EAPD GPIO control for Sigmatel codecs

Theodore Ts'o (1):
      ext4: fix error handling in ext4_ext_truncate()

Thomas Gleixner (1):
      hrtimers: Move SMP function call to thread context

Wei Yongjun (1):
      l2tp: add missing .owner to struct pppox_proto

dingtianhong (3):
      ifb: fix rcu_sched self-detected stalls
      dummy: fix oops when loading the dummy failed
      ifb: fix oops when loading the ifb failed


--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJR9eszAAoJEDjbvchgkmk+z1cP/jU6X9WaQFr8aRbemug1SWDj
FcgFOQ5+81/0Hoi+75wJHW6iN3bW/75TmOQVBuJTa/zlCWGeE1cX6AzFz7j939/7
Hw6GkV9ImzoZY8IfN3qd340NXbGMQqyw+E6uT3ex1iG676E26oF25oU+IttHsOWz
FcINJSLP4XqLzuOvp09cuhjKWBbwSWzozqDwYStlCMe5vlWJ6k2p8ZSyAZEUvSd6
2HEr2FtXJAv/DE+Z0C5SfB/DnOAWlZiThkS5SDaNizcrFUMk/1lT4ec5gGFRPRap
LeBfQB40t6YcugZBuGneibjj9jF92hz0/Fq6zChJUYOZCGX9+2KWScupm2HZ4/SX
HRoxjGDWFc7lfvvdUirnImtNDnmrhm3a1peXv220IDaFkpVCXgpWf2Kbq1+qzyE4
4QZvQkdtu5zHogm/Gu58n3fE5nYHpmjZk1vU+7nvo6hguAYUZeCn/Z2KCI618/N8
WQ676VdSAjYht9XQ1XNndOuLK8BF9ALCPBf3Zb2mjKamvsxSmMhJ175ad3a8wRXk
D8QzlX5lh9xL+nglBkcsRglN0QeiVJUxaI1ycGvzOROV3yteNm68UOgGSbdm51u0
EwHW0zGEjMhD7/BAHPpQsH/k4XWdGSJ7I7uuWZFpGi20QkD0GhZImyL1TNYDJZ/s
9siIGNAAD/v1mzapyEIu
=EgxO
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
