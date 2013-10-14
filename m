Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab3JNBrE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 21:47:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34806 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475Ab3JNBrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 21:47:01 -0400
Date: Sun, 13 Oct 2013 18:47:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.11.5
Message-ID: <20131014014757.GA5333@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.11.5 kernel.

All users of the 3.11 kernel series must upgrade.

The updated 3.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.11.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                               |    2=20
 arch/arm/configs/multi_v7_defconfig                    |    1=20
 arch/arm/kvm/reset.c                                   |    6=20
 arch/arm/mach-integrator/pci_v3.h                      |    7=20
 arch/arm/mach-tegra/Kconfig                            |   21 --
 arch/avr32/kernel/time.c                               |    9=20
 arch/powerpc/kernel/iommu.c                            |    2=20
 arch/powerpc/kernel/sysfs.c                            |   18 +
 arch/powerpc/kernel/tm.S                               |   95 ++++++----
 arch/powerpc/kernel/vio.c                              |   12 -
 arch/powerpc/lib/checksum_64.S                         |   58 ++++--
 arch/powerpc/mm/init_64.c                              |    4=20
 arch/powerpc/mm/mem.c                                  |    9=20
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
 drivers/gpu/drm/radeon/radeon_asic.c                   |    4=20
 drivers/hid/Kconfig                                    |    1=20
 drivers/hid/hid-core.c                                 |   21 ++
 drivers/hid/hid-holtek-mouse.c                         |    4=20
 drivers/hid/hid-ids.h                                  |    2=20
 drivers/hid/hid-logitech-dj.c                          |   12 +
 drivers/hid/hid-picolcd_debugfs.c                      |   23 +-
 drivers/hid/hid-roccat-konepure.c                      |    3=20
 drivers/hid/hid-wiimote-modules.c                      |   40 +++-
 drivers/hid/hid-wiimote.h                              |    4=20
 drivers/hid/uhid.c                                     |    4=20
 drivers/hid/usbhid/hid-core.c                          |    5=20
 drivers/infiniband/ulp/srpt/ib_srpt.c                  |   14 -
 drivers/iommu/arm-smmu.c                               |   13 -
 drivers/md/bcache/request.c                            |    3=20
 drivers/mmc/card/block.c                               |    2=20
 drivers/net/bonding/bond_main.c                        |   13 +
 drivers/net/ethernet/arc/emac_main.c                   |    4=20
 drivers/net/ethernet/marvell/skge.c                    |    9=20
 drivers/net/ethernet/realtek/r8169.c                   |    1=20
 drivers/net/ethernet/renesas/sh_eth.c                  |   12 -
 drivers/net/ethernet/via/via-rhine.c                   |    9=20
 drivers/net/ethernet/xilinx/ll_temac_main.c            |    6=20
 drivers/net/ppp/pptp.c                                 |    2=20
 drivers/net/tun.c                                      |   11 -
 drivers/net/usb/dm9601.c                               |    2=20
 drivers/net/usb/qmi_wwan.c                             |  130 +++++++++++++
 drivers/net/vxlan.c                                    |   20 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   28 +--
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h      |    3=20
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   14 -
 drivers/net/wireless/brcm80211/brcmfmac/usb.c          |    2=20
 drivers/net/wireless/mwifiex/11n_aggr.c                |    3=20
 drivers/net/wireless/mwifiex/11n_aggr.h                |    2=20
 drivers/net/wireless/mwifiex/cmdevt.c                  |    5=20
 drivers/net/wireless/mwifiex/usb.c                     |    7=20
 drivers/net/wireless/mwifiex/wmm.c                     |    3=20
 drivers/net/wireless/p54/p54usb.c                      |    1=20
 drivers/net/wireless/rtlwifi/wifi.h                    |    2=20
 drivers/net/xen-netback/netback.c                      |   94 ++++++----
 drivers/regulator/ti-abb-regulator.c                   |   16 +
 drivers/scsi/esp_scsi.c                                |   14 -
 drivers/scsi/esp_scsi.h                                |    1=20
 drivers/staging/comedi/drivers/ni_65xx.c               |   25 +-
 drivers/target/iscsi/iscsi_target_util.c               |    4=20
 drivers/tty/hvc/hvc_xen.c                              |    1=20
 drivers/usb/chipidea/ci_hdrc_pci.c                     |    7=20
 drivers/usb/serial/option.c                            |    3=20
 fs/binfmt_elf.c                                        |   30 +--
 fs/btrfs/extent-tree.c                                 |    3=20
 fs/btrfs/inode.c                                       |    3=20
 fs/btrfs/relocation.c                                  |   14 -
 fs/btrfs/send.c                                        |    3=20
 fs/fuse/file.c                                         |   23 +-
 fs/nfs/nfs4filelayoutdev.c                             |   18 -
 fs/nfsd/nfs4state.c                                    |   31 ++-
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
 ipc/msg.c                                              |   32 ++-
 ipc/sem.c                                              |  156 ++++++++++--=
----
 ipc/shm.c                                              |   17 +
 ipc/util.c                                             |   32 +--
 ipc/util.h                                             |   10 -
 kernel/kmod.c                                          |    4=20
 kernel/softirq.c                                       |   15 +
 mm/Kconfig                                             |    2=20
 mm/bounce.c                                            |    2=20
 mm/migrate.c                                           |    2=20
 mm/vmscan.c                                            |    4=20
 net/batman-adv/soft-interface.c                        |    2=20
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
 net/ipv4/ip_tunnel.c                                   |   15 -
 net/ipv4/ip_tunnel_core.c                              |    2=20
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
 net/ipv6/mcast.c                                       |    6=20
 net/ipv6/sit.c                                         |   85 +++++++--
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
 150 files changed, 1413 insertions(+), 683 deletions(-)

Amitkumar Karwar (1):
      mwifiex: fix hang issue for USB chipsets

Anders F. U. Ki=C3=A6r (1):
      HID: add Holtek USB ID 04d9:a081 SHARKOON DarkGlider

Andre Guedes (2):
      Bluetooth: Fix security level for peripheral role
      Bluetooth: Fix encryption key size for peripheral role

Ansis Atteka (2):
      ip: use ip_hdr() in __ip_make_skb() to retrieve IP header
      ip: generate unique IP identificator if local fragmentation is allowed

Antonio Quartulli (1):
      batman-adv: set the TAG flag for the vid passed to BLA

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

Dan Carpenter (7):
      cpqarray: fix info leak in ida_locked_ioctl()
      cciss: fix info leak in cciss_ioctl32_passthru()
      ASoC: max98095: a couple array underflows
      ASoC: 88pm860x: array overflow in snd_soc_put_volsw_2r_st()
      ASoC: ab8500-codec: info leak in anc_status_control_put()
      iommu/arm-smmu: fix a signedness bug
      iommu/arm-smmu: fix iommu_present() test in init

Daniel Borkmann (5):
      net: fib: fib6_add: fix potential NULL pointer dereference
      net: sctp: fix bug in sctp_poll for SOCK_SELECT_ERR_QUEUE
      net: sctp: fix smatch warning in sctp_send_asconf_del_ip
      net: sctp: fix ipv6 ipsec encryption bug in sctp_v6_xmit
      net: sctp: rfc4443: do not report ICMP redirects to user space

Darrick J. Wong (1):
      mm/bounce.c: fix a regression where MS_SNAP_STABLE (stable pages snap=
shotting) was ignored

Dave Jones (2):
      caif: Add missing braces to multiline if in cfctrl_linkup_request
      tcp: Add missing braces to do_tcp_setsockopt

David Cohen (1):
      usb: chipidea: add Intel Clovertrail pci id

David Herrmann (2):
      HID: wiimote: fix FF deadlock
      HID: uhid: allocate static minor

David Miller (1):
      mm: Fix generic hugetlb pte check return type.

David S. Miller (3):
      sparc64: Fix buggy strlcpy() conversion in ldom_reboot().
      esp_scsi: Fix tag state corruption when autosensing.
      sparc64: Fix off by one in trampoline TLB mapping installation loop.

David Vrabel (2):
      xen-netback: count number required slots for an skb more carefully
      xen/hvc: allow xenboot console to be used again

Davidlohr Bueso (2):
      ipc,msg: prevent race with rmid in msgsnd,msgrcv
      ipc: fix race with LSMs

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

Franck Jullien (1):
      mmc: fix null pointer use in mmc_blk_remove_req

Francois Romieu (1):
      r8169: enforce RX_MULTI_EN for the 8168f.

Frederic Weisbecker (1):
      irq: Force hardirq exit's softirq processing on its own stack

Gabor Juhos (1):
      avr32: fix clockevents kernel warning

Greg Kroah-Hartman (1):
      Linux 3.11.5

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

J. Bruce Fields (1):
      nfsd4: fix leak of inode reference on delegation failure

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

Joerg Roedel (1):
      ARM: mach-integrator: Add stub for pci_v3_early_init() for !CONFIG_PCI

Johan Hedberg (2):
      Bluetooth: Introduce a new HCI_RFKILLED flag
      Bluetooth: Fix rfkill functionality during the HCI setup stage

Josef Bacik (4):
      Btrfs: reset ret in record_one_backref
      Btrfs: change how we queue blocks for backref checking
      Btrfs: skip subvol entries when checking if we've created a dir alrea=
dy
      Btrfs: remove ourselves from the cluster list under lock

Kees Cook (1):
      sparc: fix ldom_reboot buffer overflow harder

Kent Overstreet (1):
      bcache: Fix a null ptr deref regression

Kirill Tkhai (4):
      sparc64: Remove RWSEM export leftovers
      sparc64: Fix ITLB handler of null page
      sparc64: Fix not SRA'ed %o5 in 32-bit traced syscall
      sparc32: Fix exit flag passed from traced sys_sigreturn

Larry Finger (1):
      rtlwifi: Align private space in rtl_priv struct

Lv Zheng (1):
      ACPI / IPMI: Fix atomic context requirement of ipmi_msg_handler()

Madhavan Srinivasan (1):
      powerpc/sysfs: Disable writing to PURR in guest mode

Manfred Spraul (1):
      ipc/sem.c: fix race in sem_lock()

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

Michael Neuling (2):
      powerpc/tm: Switch out userspace PPR and DSCR sooner
      powerpc/tm: Turn interrupts hard off in tm_reclaim()

Michal Mal=C3=BD (1):
      USB: serial: option: Ignore card reader interface on Huawei E1750

Mikulas Patocka (1):
      skge: fix invalid value passed to pci_unmap_sigle

Nathan Fontenot (1):
      powerpc: Fix memory hotplug with sparse vmemmap

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

Nishanth Menon (1):
      regulator: ti-abb: Fix bias voltage glitch in transition to bypass mo=
de

Olof Johansson (2):
      ARM: kvm: rename cpu_reset to avoid name clash
      ARM: multi_v7_defconfig: enable ARM_ATAG_DTB_COMPAT

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

Pravin B Shelar (1):
      ip_tunnel: Do not use stale inner_iph pointer.

Rafael Aquini (1):
      mm: avoid reinserting isolated balloon pages into LRU lists

Rafa=C5=82 Mi=C5=82ecki (1):
      drm/radeon: fix hdmi callbacks for rv6xx (incorrectly added to r520)

Raphael Kubo da Costa (1):
      Bluetooth: Add support for BCM20702A0 [0b05, 17cb]

Ricardo Ribalda (1):
      ll_temac: Reset dma descriptors indexes on ndo_open

Roger Luethi (1):
      via-rhine: fix VLAN priority field (PCP, IEEE 802.1p)

Salam Noureddine (2):
      ipv4 igmp: use in_dev_put in timer handlers instead of __in_dev_put
      ipv6 mcast: use in6_dev_put in timer handlers instead of __in6_dev_put

Sergei Shtylyov (1):
      sh_eth: fix napi_{en|dis}able() calls racing against interrupts

Sonic Zhang (1):
      netpoll: Should handle ETH_P_ARP other than ETH_P_IP in netpoll_neigh=
_reply

Sridhar Samudrala (1):
      vxlan: Avoid creating fdb entry with NULL destination

Stefan Achatz (1):
      HID: roccat: add support for KonePureOptical v2

Steffen Klassert (2):
      ip_tunnel: Fix a memory corruption in ip_tunnel_xmit
      ip_tunnel_core: Change __skb_push back to skb_push

Stephen Warren (1):
      ARM: tegra: unify Tegra's Kconfig a bit more

Takashi Iwai (1):
      ALSA: hda - Fix GPIO for Acer Aspire 3830TG

Tetsuo Handa (1):
      kernel/kmod.c: check for NULL in call_usermodehelper_exec()

Trond Myklebust (1):
      NFSv4.1: nfs4_fl_prepare_ds - fix bugs when the connect attempt fails

Vimalkumar (1):
      net_sched: htb: fix a typo in htb_change_class()

Vineet Gupta (1):
      ethernet/arc/arc_emac: Fix huge delays in large file copies

Vyacheslav Dubeyko (1):
      nilfs2: fix issue with race condition of competition between segments=
 for dirty blocks

Will Deacon (1):
      iommu/arm-smmu: don't enable SMMU device until probing has completed


--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSW01NAAoJEDjbvchgkmk+sYIP/3+bepI0PYjclczUlO16Iard
S0M+WoBwnku1K86G2mfo8Cotpe5cTEl6R3SLMtaJK1RXQWfnQuB/VHi/HtCHTc5K
7dBk5njkOiFvnS2zNX41bpdjeYGdo7tbLH2pFSZPwIl3kilj2KWpP9dPKGa4/aL2
GOkbhUtLpHWuOhBLHOoQGDLc3D+n5m+g6MBU7B7zgk/gW6u3P8G4C22TK0ALbjSx
KNnezOOHmJGkzobbt4vmmwvjfcaoio0iZoKnG776aG/lzqfqBd5wc3vp9j4EHteg
A+dvtskWDaUDVewUicJILsXD0kK6NbHO4ChtLr0veto2o1p0YrUu/a+/1aN27+sr
rNwPDi1cSLoj2SqlSxTvqZLUFVFrMtMGIjm7nhKv23VA+BI8wmYgYxD1hH1K80ba
BGmhOlw6LvZP762wst7CCZdi/Y40xvKWhFUiF42q/2P4NB+NuQ4g1hJgokgnc1rW
Gnc9QZe6cx6Pa6QynZyzT8bQ7R6I4yyW7Bd9PnIuucDKpXYGqZ9j3FRLToSVXa92
cZFyC0OxJMc5Wz67/Uz/iQUoTJe73xj/Gm6BcoR9EmxWP4T/FSapxN8mvsfyGsR5
bo9SKC+Hq3C8PvPkyvdOr+fIJbvg4meqbKWVqMfdJwfX+fA7iIRVYC3AyUOwbfkJ
x1gYRvUHDBq4J9ISDJWD
=ld/x
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
