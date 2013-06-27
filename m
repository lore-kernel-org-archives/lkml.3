Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab3F0R7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:59:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab3F0R7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:59:37 -0400
Date: Thu, 27 Jun 2013 10:59:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.9.8
Message-ID: <20130627175936.GA8732@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.9.8 kernel.

All users of the 3.9 kernel series must upgrade.

The updated 3.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.9.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                              |    2=20
 arch/arm/Kconfig                                      |   10=20
 arch/arm/mm/cache-v7.S                                |    8=20
 arch/arm/mm/proc-v7.S                                 |    4=20
 arch/arm64/kernel/perf_event.c                        |    1=20
 arch/parisc/Kconfig                                   |    8=20
 arch/parisc/Kconfig.debug                             |   11=20
 arch/parisc/Makefile                                  |    2=20
 arch/parisc/include/asm/assembly.h                    |    1=20
 arch/parisc/include/asm/hardirq.h                     |   38 ++
 arch/parisc/include/asm/mmzone.h                      |    7=20
 arch/parisc/include/asm/pci.h                         |    5=20
 arch/parisc/include/asm/processor.h                   |    4=20
 arch/parisc/include/asm/thread_info.h                 |    2=20
 arch/parisc/include/asm/tlbflush.h                    |    2=20
 arch/parisc/kernel/cache.c                            |    6=20
 arch/parisc/kernel/drivers.c                          |    2=20
 arch/parisc/kernel/entry.S                            |   60 +++-
 arch/parisc/kernel/hardware.c                         |    2=20
 arch/parisc/kernel/irq.c                              |  198 +++++++++++++=
++
 arch/parisc/kernel/pci.c                              |   27 ++
 arch/parisc/kernel/setup.c                            |    3=20
 arch/parisc/kernel/smp.c                              |   14 -
 arch/parisc/kernel/traps.c                            |    1=20
 arch/parisc/kernel/unaligned.c                        |    3=20
 arch/parisc/kernel/vmlinux.lds.S                      |    2=20
 arch/parisc/mm/init.c                                 |    4=20
 arch/tile/lib/exports.c                               |    2=20
 arch/x86/Kconfig                                      |    1=20
 arch/x86/include/asm/microcode.h                      |    4=20
 arch/x86/kernel/cpu/mtrr/cleanup.c                    |    8=20
 arch/x86/kernel/kvmclock.c                            |    1=20
 arch/x86/kvm/x86.c                                    |    5=20
 arch/x86/platform/efi/efi.c                           |    7=20
 drivers/acpi/dock.c                                   |    2=20
 drivers/acpi/power.c                                  |    1=20
 drivers/acpi/resource.c                               |   16 -
 drivers/base/firmware_class.c                         |   27 +-
 drivers/block/rbd.c                                   |    6=20
 drivers/clk/clk.c                                     |    1=20
 drivers/gpu/drm/drm_prime.c                           |    3=20
 drivers/gpu/drm/radeon/radeon_gart.c                  |    6=20
 drivers/gpu/drm/radeon/radeon_ring.c                  |    7=20
 drivers/input/joystick/xpad.c                         |    2=20
 drivers/input/keyboard/Kconfig                        |    1=20
 drivers/input/serio/Kconfig                           |    1=20
 drivers/input/touchscreen/cyttsp_core.c               |    2=20
 drivers/net/ethernet/freescale/fec.c                  |   44 ++-
 drivers/net/ethernet/freescale/fec.h                  |   10=20
 drivers/net/ethernet/freescale/gianfar_ptp.c          |    1=20
 drivers/net/ethernet/realtek/8139cp.c                 |    1=20
 drivers/net/ethernet/realtek/r8169.c                  |   41 ++-
 drivers/net/ethernet/renesas/sh_eth.c                 |   15 -
 drivers/net/macvtap.c                                 |    9=20
 drivers/net/phy/phy.c                                 |    2=20
 drivers/net/team/team.c                               |    2=20
 drivers/net/team/team_mode_roundrobin.c               |    2=20
 drivers/net/tun.c                                     |   24 +
 drivers/net/vxlan.c                                   |   17 +
 drivers/net/wireless/ath/carl9170/tx.c                |   69 ++---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c  |   18 -
 drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h  |    6=20
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |   40 +++
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c           |  134 +++++++---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.h           |    4=20
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c          |   18 +
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c           |    4=20
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.h           |    3=20
 drivers/net/wireless/rtlwifi/usb.c                    |   13 +
 drivers/net/wireless/rtlwifi/wifi.h                   |    4=20
 drivers/net/xen-netback/netback.c                     |   12=20
 drivers/parisc/iosapic.c                              |   66 +++++
 drivers/parport/parport_gsc.c                         |    6=20
 drivers/parport/parport_gsc.h                         |    2=20
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                    |    6=20
 drivers/spi/spi-pxa2xx-dma.c                          |    2=20
 drivers/spi/spi-pxa2xx.c                              |    2=20
 drivers/target/iscsi/iscsi_target_erl0.c              |    4=20
 drivers/tty/pty.c                                     |   13 -
 drivers/tty/serial/8250/8250_gsc.c                    |   10=20
 drivers/uio/uio.c                                     |    1=20
 drivers/usb/serial/ti_usb_3410_5052.c                 |    3=20
 drivers/usb/serial/ti_usb_3410_5052.h                 |    4=20
 drivers/vhost/net.c                                   |    3=20
 include/linux/perf_event.h                            |    3=20
 include/linux/rculist_nulls.h                         |    7=20
 include/linux/skbuff.h                                |   15 +
 include/linux/socket.h                                |    3=20
 include/net/sch_generic.h                             |   18 -
 kernel/events/core.c                                  |  233 ++++++++++++-=
-----
 kernel/events/internal.h                              |    4=20
 kernel/range.c                                        |   21 -
 net/802/mrp.c                                         |    4=20
 net/compat.c                                          |   13 -
 net/core/dev.c                                        |    8=20
 net/core/sock.c                                       |    6=20
 net/ipv4/ip_gre.c                                     |    2=20
 net/ipv4/ipip.c                                       |    2=20
 net/ipv4/route.c                                      |    7=20
 net/ipv4/tcp.c                                        |    7=20
 net/ipv4/tcp_input.c                                  |   23 +
 net/ipv4/tcp_output.c                                 |   10=20
 net/ipv6/addrconf.c                                   |    4=20
 net/ipv6/ip6_output.c                                 |    2=20
 net/ipv6/udp_offload.c                                |   20 -
 net/l2tp/l2tp_ppp.c                                   |    6=20
 net/netlabel/netlabel_domainhash.c                    |   69 +++++
 net/packet/af_packet.c                                |   26 +-
 net/sched/act_police.c                                |    8=20
 net/sched/sch_generic.c                               |    8=20
 net/sched/sch_htb.c                                   |   42 +--
 net/sched/sch_tbf.c                                   |    8=20
 net/sctp/outqueue.c                                   |    8=20
 net/sctp/socket.c                                     |    6=20
 net/socket.c                                          |   61 +++-
 net/xfrm/xfrm_output.c                                |    1=20
 sound/pci/hda/patch_cirrus.c                          |   23 +
 sound/usb/card.c                                      |   22 +
 sound/usb/mixer.c                                     |    1=20
 119 files changed, 1412 insertions(+), 434 deletions(-)

Anders Hammarquist (1):
      USB: serial: ti_usb_3410_5052: new device id for Abbot strip port cab=
le

Andy Lutomirski (1):
      net: Block MSG_CMSG_COMPAT in send(m)msg and recv(m)msg

Ben Hutchings (2):
      x86/efi: Fix dummy variable buffer allocation
      Input: add missing dependencies on CONFIG_HAS_IOMEM

Chen Gang (2):
      parisc: memory overflow, 'name' length is too short for using
      parisc: kernel: using strlcpy() instead of strcpy()

Chris Metcalf (1):
      tilepro: work around module link error with gcc 4.7

Christian Lamparter (1):
      carl9170: fix frame drop and WARN due to minstrel_ht change

Clemens Ladisch (1):
      ALSA: usb-audio: work around Android accessory firmware bug

Damian Hobson-Garcia (1):
      drivers: uio: Fix UIO device registration failure

Daniel Borkmann (2):
      net: sctp: fix NULL pointer dereference in socket destruction
      packet: packet_getname_spkt: make sure string is always 0-terminated

Eric Dumazet (8):
      tcp: fix tcp_md5_hash_skb_data()
      net/802/mrp: fix lockdep splat
      ipv6: fix possible crashes in ip6_cork_release()
      tcp: xps: fix reordering issues
      ip_tunnel: fix kernel panic with icmp_dest_unreach
      net: force a reload of first item in hlist_nulls_for_each_entry_rcu
      net_sched: restore "overhead xxx" handling
      net_sched: htb: do not mix 1ns and 64ns time units

Federico Vaga (1):
      net/core/sock.c: add missing VSOCK string in af_family_*_key_strings

Ferruh Yigit (1):
      Input: cyttsp - fix memcpy size param

Francois Romieu (1):
      r8169: fix offloaded tx checksum for small packets.

Frank Li (1):
      net: fec: fix kernel oops when plug/unplug cable many times

Gao feng (1):
      ipv6: assign rt6_info to inet6_ifaddr in init_loopback

Giuseppe CAVALLARO (1):
      net: phy: fix a bug when verify the EEE support

Greg Kroah-Hartman (1):
      Linux 3.9.8

Gregory CLEMENT (1):
      ARM: 7754/1: Fix the CPU ID and the mask associated to the PJ4B

Guillaume Nault (2):
      l2tp: Fix PPP header erasure and memory leak
      l2tp: Fix sendmsg() return value

Hante Meuleman (1):
      brcmfmac: Turn off ARP offloading when configured for AP.

Helge Deller (11):
      parisc: add kernel stack overflow check
      parisc: implement irq stacks
      parisc: more irq statistics in /proc/interrupts
      parisc: tlb flush counting fix for SMP and UP
      parisc: implement irq stacks - part 2 (v2)
      parisc: add rp5470 entry to machine database
      parisc: show number of FPE and unaligned access handler calls in /pro=
c/interrupts
      parisc: fix irq stack on UP and SMP
      parisc: fix kernel BUG at arch/parisc/include/asm/mmzone.h:50
      parisc: parport0: fix this legacy no-device port driver!
      parisc: fix kernel BUG at arch/parisc/include/asm/mmzone.h:50 (part 2)

Igor Mammedov (1):
      x86: kvmclock: zero initialize pvclock shared memory area

Jason Wang (9):
      tuntap: forbid changing mq flag for persistent device
      vhost_net: clear msg.control for non-zerocopy case during tx
      tuntap: set SOCK_ZEROCOPY flag during open
      tuntap: correct the return value in tun_set_iff()
      macvtap: set transport header before passing skb to lower device
      tuntap: set transport header before passing it to kernel
      packet: set transport header before doing xmit
      netback: set transport header before passing it to kernel
      net_sched: better precise estimation on packet length for untrusted p=
ackets

Jed Davis (1):
      perf: arm64: Record the user-mode PC in the call chain.

Jerome Glisse (2):
      drm/radeon: do not try to uselessly update virtual memory pagetable
      drm/radeon: update lockup tracking when scheduling in empty ring

Jiri Pirko (2):
      team: check return value of team_get_port_by_index_rcu() for NULL
      team: move add to port list before port enablement

Joern Engel (1):
      target/iscsi: don't corrupt bh_count in iscsit_stop_time2retain_timer=
()

John David Anglin (1):
      parisc: make interrupt and interruption stack allocation reentrant

Jon Medhurst (1):
      ARM: 7752/1: errata: LoUIS bit field in CLIDR register is incorrect

Josh Durgin (1):
      rbd: use the correct length for format 2 object names

Lai Jiangshan (1):
      clk: remove notifier from list before freeing it

Larry Finger (1):
      rtlwifi: rtl8192cu: Fix problem in connecting to WEP or WPA(1) networ=
ks

Laurent Pinchart (1):
      drm/prime: Honor requested file flags when exporting a buffer

Michal Kubecek (1):
      ipv4: fix redirect handling for TCP packets

Mika Westerberg (3):
      ACPI / resources: call acpi_get_override_irq() only for legacy IRQ re=
sources
      spi/pxa2xx: use GFP_ATOMIC in sg table allocation
      spi/pxa2xx: fix memory corruption due to wrong size used in devm_kzal=
loc()

Ming Lei (1):
      firmware loader: fix use-after-free by double abort

Nandita Dukkipati (1):
      tcp: bug fix in proportional rate reduction.

Neil Horman (1):
      sctp: fully initialize sctp_outq in sctp_outq_init

Paul Bolle (1):
      parisc: rename "CONFIG_PA7100" to "CONFIG_PA7000"

Paul Gortmaker (1):
      x86: Fix section mismatch on load_ucode_ap

Paul Moore (1):
      netlabel: improve domain mapping validation

Peter Hurley (1):
      tty: Fix transient pty write() EIO

Peter Zijlstra (2):
      perf: Fix perf mmap bugs
      perf: Fix mmap() accounting hole

Pravin B Shelar (1):
      udp6: Fix udp fragmentation for tunnel traffic.

Rafael J. Wysocki (2):
      ACPI / dock: Take ACPI scan lock in write_undock()
      ACPI / PM: Fix error code path for power resources initialization

Randy Dunlap (1):
      x86: fix build error and kconfig for ia32_emulation and binfmt

Roland Dreier (1):
      tcm_qla2xxx: Fix residual for underrun commands that fail

Shawn Joseph (1):
      Input: xpad - fix for "Mad Catz Street Fighter IV FightPad" controlle=
rs

Sridhar Samudrala (1):
      vxlan: Update vxlan fdb 'used' field after each usage

Takashi Iwai (2):
      ALSA: usb-audio: Fix invalid volume resolution for Logitech HD Webcam=
 c310
      ALSA: hda - Fix pin configurations for MacBook Air 4,2

Thomas Bogendoerfer (2):
      parisc: fix serial ports on C8000 workstation
      parisc: provide pci_mmap_page_range() for parisc

Timo Ter=E4s (1):
      xfrm: properly handle invalid states as an error

Wei Yongjun (1):
      gianfar: add missing iounmap() on error in gianfar_ptp_probe()

Yinghai Lu (2):
      range: Do not add new blank slot with add_range_with_merge
      x86, mtrr: Fix original mtrr range get for mtrr_cleanup

Yoshihiro Shimoda (1):
      net: sh_eth: fix incorrect RX length error if R8A7740

Zhanghaoyu (A) (1):
      KVM: x86: remove vcpu's CPL check in host-invoked XCR set

Zhao Hongjiang (1):
      parisc: remove the second argument of kmap_atomic()

stephen hemminger (1):
      8139cp: reset BQL when ring tx ring cleared


--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRzH2IAAoJEDjbvchgkmk+C20P/RNbewvv2jvKDFkZcKN/YOgm
sJtBsxeP/r1QPGSvvhBgOnhMcNgYiLYrz/9FwypR8PqRjm2B7iDWKKYOD1RTS6cE
rKho/TPhQxEIpY0OFOpx+3RTcdBmdgZd4Thtwa1/9bk36jRiRY5xIv5vNJ2iJBZZ
Y1vmD5TVabGARMdQ6b5CEbZQ0uWOr7rCKk89qDQCzCAaHFd4T9kOc/zfnTpDlAgW
tyhEvBkk9otvCkftVCTIGXCm7byYycMB2hH/7OVyPcWZ5uKUAT1BC2L6qJ/G1Ofb
DctFpLpH+iGP+BHtDCrrGLU4A1V2fv5mqhlEhcEO34STp+lt05PfFE++eSdG1Lbj
k4Mt3m66xy6yAhtKmDJ6EQyAC9poTOXxkdQfr61ld3Rs09wfGjpJF60z70p3vk1h
llKFa5Dk3PyV21mMkky0TnjQkSOhDKWvi7IAdpTBcCsfOf3GfKOeXbEKwF3ukdN7
OgRWStBOgCEXUIB9asYZ7G/6nHu7QzFzy16IgFoFocG6Rv4J2+Nsa3z9gE7TrIPw
19kaoNfeTnfET5hY1fEnPkeFGhyUksPgfA9YiyGKaMSzOYcU1BRO/nYa7GNlWw4u
A2DZYHhx1soBvtKgYwlldBx2IHDZdXm7h3GRMtndn6NclKp/RLtufqWqCTzrIjST
tAnxIXnpCIWokAIZLGkW
=HnOV
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
