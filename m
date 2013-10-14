Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab3JNBMJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 21:12:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab3JNBMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 21:12:07 -0400
Date: Sun, 13 Oct 2013 18:13:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.16
Message-ID: <20131014011303.GA15922@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.16 kernel.

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

 Makefile                                               |    2=20
 arch/avr32/kernel/time.c                               |    9=20
 arch/powerpc/kernel/iommu.c                            |    2=20
 arch/powerpc/kernel/sysfs.c                            |   18 +
 arch/powerpc/kernel/tm.S                               |   94 ++++++----
 arch/powerpc/kernel/vio.c                              |   12 -
 arch/powerpc/lib/checksum_64.S                         |   58 ++++--
 arch/powerpc/perf/power8-pmu.c                         |    5=20
 arch/s390/kernel/entry.S                               |    1=20
 arch/s390/kernel/entry64.S                             |    1=20
 arch/sparc/kernel/ds.c                                 |    5=20
 arch/sparc/kernel/entry.S                              |    2=20
 arch/sparc/kernel/ktlb.S                               |    3=20
 arch/sparc/kernel/syscalls.S                           |    8=20
 arch/sparc/kernel/trampoline_64.S                      |    2=20
 arch/sparc/lib/ksyms.c                                 |    9=20
 arch/tile/include/asm/percpu.h                         |   34 +++
 drivers/acpi/acpi_ipmi.c                               |   24 +-
 drivers/block/cciss.c                                  |    1=20
 drivers/block/cpqarray.c                               |    1=20
 drivers/bluetooth/ath3k.c                              |    2=20
 drivers/bluetooth/btusb.c                              |    2=20
 drivers/dma/imx-dma.c                                  |   31 +--
 drivers/gpio/gpio-omap.c                               |  158 ++++++++++--=
-----
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c        |   19 +-
 drivers/gpu/drm/radeon/radeon_asic.c                   |    2=20
 drivers/hid/hid-core.c                                 |   20 ++
 drivers/hid/hid-ids.h                                  |    1=20
 drivers/hid/hid-logitech-dj.c                          |   12 +
 drivers/hid/hid-picolcd_debugfs.c                      |   23 +-
 drivers/hid/hid-roccat-konepure.c                      |    3=20
 drivers/hid/uhid.c                                     |    4=20
 drivers/hid/usbhid/hid-core.c                          |    5=20
 drivers/infiniband/ulp/srpt/ib_srpt.c                  |   14 -
 drivers/md/bcache/request.c                            |    3=20
 drivers/net/bonding/bond_main.c                        |   13 +
 drivers/net/ethernet/realtek/r8169.c                   |    1=20
 drivers/net/ethernet/via/via-rhine.c                   |    9=20
 drivers/net/ethernet/xilinx/ll_temac_main.c            |    6=20
 drivers/net/ppp/pptp.c                                 |    2=20
 drivers/net/tun.c                                      |   11 -
 drivers/net/usb/dm9601.c                               |    2=20
 drivers/net/usb/qmi_wwan.c                             |  130 +++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   28 +--
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      |    3=20
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   14 -
 drivers/net/wireless/brcm80211/brcmfmac/usb.c          |    2=20
 drivers/net/wireless/mwifiex/11n_aggr.c                |    3=20
 drivers/net/wireless/mwifiex/11n_aggr.h                |    2=20
 drivers/net/wireless/mwifiex/cmdevt.c                  |    5=20
 drivers/net/wireless/mwifiex/main.c                    |    5=20
 drivers/net/wireless/mwifiex/sta_ioctl.c               |   18 -
 drivers/net/wireless/mwifiex/usb.c                     |    7=20
 drivers/net/wireless/mwifiex/wmm.c                     |    3=20
 drivers/net/wireless/p54/p54usb.c                      |    1=20
 drivers/net/wireless/rtlwifi/wifi.h                    |    2=20
 drivers/net/xen-netback/netback.c                      |   94 ++++++----
 drivers/scsi/esp_scsi.c                                |   14 -
 drivers/scsi/esp_scsi.h                                |    1=20
 drivers/staging/comedi/drivers/ni_65xx.c               |   25 +-
 drivers/target/iscsi/iscsi_target_util.c               |    4=20
 drivers/tty/hvc/hvc_xen.c                              |    1=20
 drivers/usb/serial/option.c                            |    3=20
 fs/binfmt_elf.c                                        |   30 +--
 fs/btrfs/extent-tree.c                                 |    3=20
 fs/btrfs/relocation.c                                  |   14 -
 fs/btrfs/send.c                                        |    3=20
 fs/fuse/file.c                                         |   23 +-
 fs/nfs/nfs4filelayoutdev.c                             |   18 -
 fs/nilfs2/page.c                                       |    2=20
 fs/nilfs2/segment.c                                    |   11 -
 fs/xfs/xfs_da_btree.c                                  |    5=20
 include/asm-generic/hugetlb.h                          |    4=20
 include/linux/balloon_compaction.h                     |   25 ++
 include/linux/hid.h                                    |    1=20
 include/linux/miscdevice.h                             |    1=20
 include/net/addrconf.h                                 |    4=20
 include/net/bluetooth/hci.h                            |    1=20
 include/net/ip.h                                       |   12 -
 include/net/secure_seq.h                               |    1=20
 kernel/softirq.c                                       |   15 +
 mm/bounce.c                                            |    2=20
 mm/migrate.c                                           |    2=20
 mm/vmscan.c                                            |    4=20
 net/bluetooth/hci_core.c                               |   26 ++
 net/bluetooth/hci_event.c                              |    6=20
 net/bluetooth/hidp/core.c                              |   15 +
 net/bridge/br_netlink.c                                |    4=20
 net/bridge/br_private.h                                |    8=20
 net/bridge/br_stp.c                                    |   23 +-
 net/bridge/br_stp_if.c                                 |   12 +
 net/caif/cfctrl.c                                      |    3=20
 net/core/flow_dissector.c                              |    6=20
 net/core/netpoll.c                                     |   11 -
 net/core/secure_seq.c                                  |   27 ++
 net/dccp/ipv6.c                                        |    1=20
 net/ipv4/af_inet.c                                     |    4=20
 net/ipv4/igmp.c                                        |    8=20
 net/ipv4/inetpeer.c                                    |    4=20
 net/ipv4/ip_output.c                                   |    8=20
 net/ipv4/ip_tunnel.c                                   |   12 -
 net/ipv4/ipmr.c                                        |    2=20
 net/ipv4/raw.c                                         |    2=20
 net/ipv4/tcp.c                                         |    3=20
 net/ipv4/xfrm4_mode_tunnel.c                           |    2=20
 net/ipv6/addrconf.c                                    |   27 ++
 net/ipv6/exthdrs.c                                     |    6=20
 net/ipv6/ip6_fib.c                                     |    2=20
 net/ipv6/ip6_gre.c                                     |    4=20
 net/ipv6/ip6_output.c                                  |   53 ++---
 net/ipv6/ip6_tunnel.c                                  |    5=20
 net/ipv6/mcast.c                                       |    4=20
 net/ipv6/sit.c                                         |   87 +++++++--
 net/netfilter/ipvs/ip_vs_xmit.c                        |    2=20
 net/sched/sch_htb.c                                    |    2=20
 net/sctp/input.c                                       |    3=20
 net/sctp/ipv6.c                                        |   44 +---
 net/sctp/socket.c                                      |    5=20
 net/sysctl_net.c                                       |    4=20
 sound/pci/hda/patch_conexant.c                         |   11 +
 sound/soc/codecs/88pm860x-codec.c                      |    3=20
 sound/soc/codecs/ab8500-codec.c                        |    7=20
 sound/soc/codecs/max98095.c                            |    4=20
 123 files changed, 1111 insertions(+), 529 deletions(-)

Amitkumar Karwar (1):
      mwifiex: fix hang issue for USB chipsets

Andre Guedes (2):
      Bluetooth: Fix security level for peripheral role
      Bluetooth: Fix encryption key size for peripheral role

Ansis Atteka (2):
      ip: use ip_hdr() in __ip_make_skb() to retrieve IP header
      ip: generate unique IP identificator if local fragmentation is allowed

Arend van Spriel (1):
      brcmfmac: obtain platform data upon module initialization

Ben Skeggs (1):
      drm/nouveau/bios/init: stub opcode 0xaa

Bing Zhao (2):
      mwifiex: fix NULL pointer dereference in usb suspend handler
      mwifiex: fix PCIe hs_cfg cancel cmd timeout

Bj=C3=B8rn Mork (1):
      net: qmi_wwan: add new Qualcomm devices

Catalin(ux) M. BOIE (1):
      IPv6 NAT: Do not drop DNATed 6to4/6rd packets

Chris Healy (1):
      resubmit bridge: fix message_age_timer calculation

Chris Metcalf (1):
      tile: use a more conservative __my_cpu_offset in CONFIG_PREEMPT

Christian Lamparter (1):
      p54usb: add USB ID for Corega WLUSB2GTST USB adapter

Dan Aloni (1):
      fs/binfmt_elf.c: prevent a coredump with a large vm_map_count from Oo=
psing

Dan Carpenter (5):
      cpqarray: fix info leak in ida_locked_ioctl()
      cciss: fix info leak in cciss_ioctl32_passthru()
      ASoC: max98095: a couple array underflows
      ASoC: 88pm860x: array overflow in snd_soc_put_volsw_2r_st()
      ASoC: ab8500-codec: info leak in anc_status_control_put()

Daniel Borkmann (5):
      net: fib: fib6_add: fix potential NULL pointer dereference
      net: sctp: fix bug in sctp_poll for SOCK_SELECT_ERR_QUEUE
      net: sctp: fix smatch warning in sctp_send_asconf_del_ip
      net: sctp: fix ipv6 ipsec encryption bug in sctp_v6_xmit
      net: sctp: rfc4443: do not report ICMP redirects to user space

Daniel Drake (1):
      mwifiex: fix memory corruption when unsetting multicast list

Darrick J. Wong (1):
      mm/bounce.c: fix a regression where MS_SNAP_STABLE (stable pages snap=
shotting) was ignored

Dave Jones (2):
      caif: Add missing braces to multiline if in cfctrl_linkup_request
      tcp: Add missing braces to do_tcp_setsockopt

David Herrmann (1):
      HID: uhid: allocate static minor

David Miller (1):
      mm: Fix generic hugetlb pte check return type.

David S. Miller (3):
      esp_scsi: Fix tag state corruption when autosensing.
      sparc64: Fix buggy strlcpy() conversion in ldom_reboot().
      sparc64: Fix off by one in trampoline TLB mapping installation loop.

David Vrabel (2):
      xen-netback: count number required slots for an skb more carefully
      xen/hvc: allow xenboot console to be used again

Ding Zhi (1):
      ip6_tunnels: raddr and laddr are inverted in nl msg

Duan Jiong (1):
      net:dccp: do not report ICMP redirects to user space

Eric Dumazet (3):
      net: fix multiqueue selection
      net: flow_dissector: fix thoff for IPPROTO_AH
      net: net_secret should not depend on TCP

Eric W. Biederman (1):
      net: Update the sysctl permissions handler to test effective uid/gid

Francois Romieu (1):
      r8169: enforce RX_MULTI_EN for the 8168f.

Frederic Weisbecker (1):
      irq: Force hardirq exit's softirq processing on its own stack

Gabor Juhos (1):
      avr32: fix clockevents kernel warning

Greg Kroah-Hartman (1):
      Linux 3.10.16

Hannes Frederic Sowa (2):
      ipv6: udp packets following an UFO enqueued packet need also be handl=
ed by UFO
      ipv6: gre: correct calculation of max_headroom

Herbert Xu (1):
      bridge: Clamp forward_delay when enabling STP

Hong Zhiguo (2):
      bridge: use br_port_get_rtnl within rtnl lock
      bridge: fix NULL pointer deref of br_port_get_rcu

Ian Abbott (1):
      staging: comedi: ni_65xx: (bug fix) confine insn_bits to one subdevice

Jack Wang (1):
      ib_srpt: always set response for task management

Jason Wang (1):
      tuntap: correctly handle error in tun_set_iff()

Javier Martinez Canillas (2):
      gpio/omap: maintain GPIO and IRQ usage separately
      gpio/omap: auto-setup a GPIO when used as an IRQ

Jiri Kosina (2):
      HID: fix data access in implement()
      HID: fix unused rsize usage

Jiri Pirko (1):
      ipv6/exthdrs: accept tlv which includes only padding

Johan Hedberg (2):
      Bluetooth: Introduce a new HCI_RFKILLED flag
      Bluetooth: Fix rfkill functionality during the HCI setup stage

Josef Bacik (3):
      Btrfs: change how we queue blocks for backref checking
      Btrfs: skip subvol entries when checking if we've created a dir alrea=
dy
      Btrfs: remove ourselves from the cluster list under lock

Kees Cook (1):
      sparc: fix ldom_reboot buffer overflow harder

Kent Overstreet (1):
      bcache: Fix a null ptr deref regression

Kirill Tkhai (4):
      sparc64: Fix ITLB handler of null page
      sparc64: Remove RWSEM export leftovers
      sparc64: Fix not SRA'ed %o5 in 32-bit traced syscall
      sparc32: Fix exit flag passed from traced sys_sigreturn

Larry Finger (1):
      rtlwifi: Align private space in rtl_priv struct

Lv Zheng (1):
      ACPI / IPMI: Fix atomic context requirement of ipmi_msg_handler()

Madhavan Srinivasan (1):
      powerpc/sysfs: Disable writing to PURR in guest mode

Marcel Holtmann (1):
      HID: uhid: add devname module alias

Mark Tinguely (1):
      xfs: fix node forward in xfs_node_toosmall

Martin Schwidefsky (1):
      s390: fix system call restart after inferior call

Maxim Patlasov (2):
      fuse: wait for writeback in fuse_file_fallocate()
      fuse: fix fallocate vs. ftruncate race

Michael Ellerman (1):
      powerpc/perf: Fix handling of FAB events

Michael Grzeschik (3):
      dmaengine: imx-dma: fix lockdep issue between irqhandler and tasklet
      dmaengine: imx-dma: fix callback path in tasklet
      dmaengine: imx-dma: fix slow path issue in prep_dma_cyclic

Michael Neuling (1):
      powerpc/tm: Switch out userspace PPR and DSCR sooner

Michal Mal=C3=BD (1):
      USB: serial: option: Ignore card reader interface on Huawei E1750

Neil Horman (1):
      bonding: Fix broken promiscuity reference counting issue

Nicholas Bellinger (2):
      ib_srpt: Destroy cm_id before destroying QP.
      iscsi-target: Only perform wait_for_tasks when performing shutdown

Nicolas Dichtel (2):
      sit: allow to use rtnl ops on fb tunnel
      ip6tnl: allow to use rtnl ops on fb tunnel

Nikolay Aleksandrov (1):
      netpoll: fix NULL pointer dereference in netpoll_cleanup

Nishanth Aravamudan (1):
      powerpc/iommu: Use GFP_KERNEL instead of GFP_ATOMIC in iommu_init_tab=
le()

Paul E. McKenney (2):
      powerpc: Fix parameter clobber in csum_partial_copy_generic()
      powerpc: Restore registers on error exit from csum_partial_copy_gener=
ic()

Peng Chen (1):
      Bluetooth: Add a new PID/VID 0cf3/e005 for AR3012.

Peter Korsgaard (1):
      dm9601: fix IFF_ALLMULTI handling

Prarit Bhargava (1):
      powerpc/vio: Fix modalias_show return values

Rafael Aquini (1):
      mm: avoid reinserting isolated balloon pages into LRU lists

Rafa=C5=82 Mi=C5=82ecki (1):
      Revert "drm/radeon: add missing hdmi callbacks for rv6xx"

Raphael Kubo da Costa (1):
      Bluetooth: Add support for BCM20702A0 [0b05, 17cb]

Ricardo Ribalda (1):
      ll_temac: Reset dma descriptors indexes on ndo_open

Roger Luethi (1):
      via-rhine: fix VLAN priority field (PCP, IEEE 802.1p)

Salam Noureddine (2):
      ipv4 igmp: use in_dev_put in timer handlers instead of __in_dev_put
      ipv6 mcast: use in6_dev_put in timer handlers instead of __in6_dev_put

Sonic Zhang (1):
      netpoll: Should handle ETH_P_ARP other than ETH_P_IP in netpoll_neigh=
_reply

Stefan Achatz (1):
      HID: roccat: add support for KonePureOptical v2

Steffen Klassert (1):
      ip_tunnel: Fix a memory corruption in ip_tunnel_xmit

Takashi Iwai (1):
      ALSA: hda - Fix GPIO for Acer Aspire 3830TG

Trond Myklebust (1):
      NFSv4.1: nfs4_fl_prepare_ds - fix bugs when the connect attempt fails

Vimalkumar (1):
      net_sched: htb: fix a typo in htb_change_class()

Vyacheslav Dubeyko (1):
      nilfs2: fix issue with race condition of competition between segments=
 for dirty blocks


--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSW0UfAAoJEDjbvchgkmk+ufYP/i4tkPJH+uZLZQVsT8XENemB
H2gT7mzn/ogCrVC3Y9TehvDlFpXNUfbWzT4gmc5AP7KisGHRJD4e4D2be6hItLmy
9w1F75Bt8fKf0CscrUJTTvAHrLkqQl/CiCl/fTSm26GtbPPt+kHeRRKRo4rXiMMs
RV0zxhameotOL2IDS6nbxLCtYS66sIxmTsnMt9fCoYP8LpXIkw8mV6jUcZryhP4N
clUj42BBIlrJiWe5IShUhNsa9eQ+lea61asn9axRm2ea5LkuOWV2J4iZ/0YXWbWs
GQf5ML0kyKUsPpU+jCdwRuFOsZKJ/p23bD5BQuNIdPvUyGQTCgiVmQh5cnYBbwcD
aNr+LSQZhB8MkCBDt2XM36zHuOVtprkRNroSp/DtXqmy+SSGlVXW1v0FGRlSPsXc
KRWgfsCkCA8xr5RJY7/eY5JnFm6RC+14PesDqsAv3O1JjisilEt9+moQLKWWHEly
R0VEGUYxeslcu6IpdLK8/KYnbOi8m4aQmGJ/cOBbRalv3LC+67MvyIjRUeA/kWtF
8Am+OV67dLUYBs/97LufkIC4OmeKiv75rKvEuBgDAWxLLFQL1YWQrCAoVeC6QX3+
BPyX/uPe63Zs1nxqT+JyfpnNQFNO6cVgcltR6PZlwulgYvGnthp6kupL527UnK/d
ittygyVZF0EQGAUx2DFM
=89gx
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
