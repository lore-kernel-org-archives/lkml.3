Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaG1Rlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:41:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaG1Rlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:41:35 -0400
Date: Mon, 28 Jul 2014 10:41:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.14
Message-ID: <20140728174108.GA16501@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.14 kernel.

All users of the 3.14 kernel series must upgrade.

The updated 3.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                        |    2=20
 arch/arc/include/uapi/asm/ptrace.h              |    1=20
 arch/arc/kernel/ptrace.c                        |    4=20
 arch/arm/Kconfig                                |    1=20
 arch/arm/boot/dts/imx25.dtsi                    |    1=20
 arch/arm/boot/dts/imx27.dtsi                    |    1=20
 arch/arm/boot/dts/imx51.dtsi                    |    1=20
 arch/arm/boot/dts/imx53.dtsi                    |    1=20
 arch/arm64/Kconfig                              |    1=20
 arch/powerpc/Kconfig                            |    1=20
 arch/sparc/Kconfig                              |    1=20
 arch/x86/Kconfig                                |    1=20
 arch/x86/kernel/cpu/perf_event_intel.c          |    9 +
 arch/x86/kernel/tsc.c                           |    4=20
 drivers/bluetooth/hci_h5.c                      |    1=20
 drivers/gpu/drm/qxl/qxl_irq.c                   |    3=20
 drivers/gpu/drm/radeon/atombios_encoders.c      |   10 +
 drivers/gpu/drm/radeon/radeon_display.c         |    5=20
 drivers/hv/hv_kvp.c                             |   14 ++
 drivers/hv/hv_util.c                            |    2=20
 drivers/hwmon/adt7470.c                         |    6 -
 drivers/hwmon/da9052-hwmon.c                    |    2=20
 drivers/hwmon/da9055-hwmon.c                    |    2=20
 drivers/iio/industrialio-event.c                |    3=20
 drivers/irqchip/irq-gic.c                       |    7 +
 drivers/md/dm-cache-metadata.c                  |    9 +
 drivers/md/dm-thin-metadata.c                   |    9 +
 drivers/media/usb/gspca/pac7302.c               |    1=20
 drivers/mtd/devices/elm.c                       |    2=20
 drivers/net/bonding/bond_main.c                 |    2=20
 drivers/net/can/slcan.c                         |   41 +++++---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    3=20
 drivers/net/ethernet/emulex/benet/be_main.c     |    2=20
 drivers/net/ethernet/intel/e1000e/ich8lan.c     |    2=20
 drivers/net/ethernet/intel/e1000e/ich8lan.h     |    2=20
 drivers/net/ethernet/intel/igb/e1000_82575.c    |    7 +
 drivers/net/ethernet/intel/igb/e1000_defines.h  |   18 +--
 drivers/net/ethernet/intel/igb/e1000_hw.h       |    3=20
 drivers/net/ethernet/intel/igb/e1000_i210.c     |   66 ++++++++++++
 drivers/net/ethernet/intel/igb/e1000_i210.h     |   12 ++
 drivers/net/ethernet/intel/igb/e1000_regs.h     |    1=20
 drivers/net/ethernet/intel/igb/igb_main.c       |   16 +++
 drivers/net/ethernet/marvell/mvneta.c           |    4=20
 drivers/net/ethernet/sun/sunvnet.c              |   20 +++
 drivers/net/ppp/pppoe.c                         |    2=20
 drivers/net/slip/slip.c                         |   36 +++++--
 drivers/net/slip/slip.h                         |    1=20
 drivers/net/usb/huawei_cdc_ncm.c                |   10 +
 drivers/net/usb/qmi_wwan.c                      |    3=20
 drivers/net/wireless/iwlwifi/dvm/rxon.c         |   12 --
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c     |    8 -
 drivers/net/wireless/iwlwifi/pcie/drv.c         |    3=20
 drivers/net/wireless/mwifiex/main.c             |    1=20
 drivers/usb/chipidea/udc.c                      |    4=20
 drivers/usb/core/hub.c                          |   19 +++
 drivers/xen/balloon.c                           |   12 --
 fs/aio.c                                        |    7 +
 fs/fuse/dir.c                                   |    7 -
 fs/fuse/inode.c                                 |   20 +++
 fs/quota/dquot.c                                |    2=20
 include/net/sock.h                              |   16 +--
 kernel/Kconfig.locks                            |    5=20
 kernel/events/core.c                            |    2=20
 kernel/power/process.c                          |    1=20
 kernel/sched/debug.c                            |    2=20
 kernel/time/alarmtimer.c                        |   20 +++
 kernel/trace/ftrace.c                           |    4=20
 kernel/trace/ring_buffer.c                      |    4=20
 kernel/trace/trace.c                            |   18 +++
 kernel/trace/trace_events.c                     |    1=20
 mm/shmem.c                                      |  104 ++++++++++++++++++--
 mm/vmscan.c                                     |   11 --
 net/8021q/vlan_core.c                           |    5=20
 net/8021q/vlan_dev.c                            |   13 +-
 net/appletalk/ddp.c                             |    3=20
 net/core/dev.c                                  |   11 +-
 net/core/dst.c                                  |   16 ++-
 net/core/skbuff.c                               |    3=20
 net/dns_resolver/dns_query.c                    |    4=20
 net/ipv4/af_inet.c                              |    3=20
 net/ipv4/gre_offload.c                          |    3=20
 net/ipv4/icmp.c                                 |    2=20
 net/ipv4/igmp.c                                 |   10 +
 net/ipv4/ip_options.c                           |    4=20
 net/ipv4/ip_tunnel.c                            |   26 ++---
 net/ipv4/route.c                                |   15 +-
 net/ipv4/tcp.c                                  |    3=20
 net/ipv4/tcp_input.c                            |   10 -
 net/ipv4/tcp_offload.c                          |    2=20
 net/ipv4/tcp_output.c                           |    6 -
 net/ipv6/tcpv6_offload.c                        |    2=20
 net/netlink/af_netlink.c                        |    4=20
 net/sctp/sysctl.c                               |   46 ++++-----
 net/sctp/ulpevent.c                             |  122 ++-----------------=
-----
 net/tipc/bcast.c                                |    1=20
 sound/pci/hda/hda_intel.c                       |   10 -
 sound/pci/hda/patch_hdmi.c                      |    1=20
 97 files changed, 646 insertions(+), 318 deletions(-)

Abbas Raza (1):
      usb: chipidea: udc: Disable auto ZLP generation on ep0

Alex Deucher (2):
      drm/radeon: set default bl level to something reasonable
      drm/radeon: avoid leaking edid data

Amitkumar Karwar (1):
      mwifiex: fix Tx timeout issue

Anand Avati (1):
      fuse: ignore entry-timeout on LOOKUP_REVAL

Andrey Utkin (1):
      appletalk: Fix socket referencing in skb

Anton Kolesov (1):
      ARC: Implement ptrace(PTRACE_GET_THREAD_AREA)

Axel Lin (2):
      hwmon: (da9055) Don't use dash in the name attribute
      hwmon: (da9052) Don't use dash in the name attribute

Ben Hutchings (1):
      dns_resolver: Null-terminate the right string

Ben Pfaff (1):
      netlink: Fix handling of error from netlink_dump().

Benjamin LaHaise (1):
      aio: protect reqs_available updates from changes in interrupt handlers

Bernd Wachter (1):
      net: qmi_wwan: Add ID for Telewell TW-LTE 4G v2

Bj=F8rn Mork (3):
      net: huawei_cdc_ncm: increase command buffer size
      net: qmi_wwan: add two Sierra Wireless/Netgear devices
      net: huawei_cdc_ncm: add "subclass 3" devices

Christoph Paasch (1):
      tcp: Fix divide by zero when pushing during tcp-repair

Christoph Schulz (1):
      net: pppoe: use correct channel MTU when using Multilink PPP

Daniel Borkmann (3):
      net: sctp: propagate sysctl errors from proc_do* properly
      net: sctp: check proc_dointvec result in proc_sctp_do_auth
      net: sctp: fix information leaks in ulpevent layer

David Ertman (1):
      e1000e: Fix SHRA register access for 82579

David Vrabel (1):
      xen/balloon: set ballooned out pages as invalid in p2m

Dmitry Popov (1):
      ip_tunnel: fix ip_tunnel_lookup

Edward Allcutt (1):
      ipv4: icmp: Fix pMTU handling for rare case

Emmanuel Grumbach (2):
      iwlwifi: dvm: don't enable CTS to self
      iwlwifi: mvm: disable CTS to Self

Eric Dumazet (6):
      ipv4: fix dst race in sk_dst_get()
      ipv4: irq safe sk_dst_[re]set() and ipv4_sk_update_pmtu() fix
      net: fix sparse warning in sk_dst_set()
      vlan: free percpu stats in device destructor
      bnx2x: fix possible panic under memory stress
      ipv4: fix buffer overflow in ip_options_compile()

Gavin Guo (1):
      usb: Check if port status is equal to RxDetect

Greg Kroah-Hartman (1):
      Linux 3.14.14

Guenter Roeck (1):
      hwmon: (adt7470) Fix writes to temperature limit registers

HATAYAMA Daisuke (1):
      perf/x86/intel: ignore CondChgd bit to avoid false NMI handling

Hans de Goede (1):
      media: gspca_pac7302: Add new usb-id for Genius i-Look 317

Hugh Dickins (3):
      shmem: fix faulting into a hole while it's punched
      shmem: fix faulting into a hole, not taking i_mutex
      shmem: fix splicing from a hole while it's punched

Jason Wang (1):
      drm/qxl: return IRQ_NONE if it was not our irq

Jerry Chu (1):
      net-gre-gro: Fix a bug that breaks the forwarding path

Jiri Olsa (1):
      perf: Do not allow optimized switch for non-cloned events

John Stultz (1):
      alarmtimer: Fix bug where relative alarm timers were treated as absol=
ute

Jon Paul Maloy (1):
      tipc: clear 'next'-pointer of message fragments before reassembly

K. Y. Srinivasan (1):
      Drivers: hv: util: Fix a bug in the KVP code

Li RongQing (1):
      8021q: fix a potential memory leak

Linus Torvalds (1):
      Don't trigger congestion wait on dirty-but-not-writeout pages

Loic Poulain (1):
      Bluetooth: Ignore H5 non-link packets in non-active state

Loic Prylli (1):
      net: Fix NETDEV_CHANGE notifier usage causing spurious arp flush

Manuel Sch=F6lling (1):
      dns_resolver: assure that dns_query() result is null-terminated

Marek Vasut (1):
      ARM: dts: imx: Add alias for ethernet controller

Martin Lau (1):
      ring-buffer: Fix polling on trace_pipe

Mateusz Guzik (1):
      sched: Fix possible divide by zero in avg_atom() calculation

Matthias Brugger (1):
      irqchip: gic: Add support for cortex a7 compatible string

Mengdong Lin (1):
      ALSA: hda - initialize audio InfoFrame to be all zero

Mike Snitzer (2):
      dm thin metadata: do not allow the data block size to change
      dm cache metadata: do not allow the data block size to change

Miklos Szeredi (2):
      fuse: timeout comparison fix
      fuse: handle large user and group ID

Neal Cardwell (1):
      tcp: fix tcp_match_skb_to_sack() for unaligned SACK at end of an skb

Nikolay Aleksandrov (1):
      bonding: fix ad_select module param check

Niu Yawei (1):
      quota: missing lock in dqcache_shrink_scan()

Oleg Nesterov (1):
      tracing: instance_rmdir() leaks ftrace_event_file->filter

Oren Givon (1):
      iwlwifi: update the 7265 series HW IDs

Peter Zijlstra (2):
      x86, tsc: Fix cpufreq lockup
      locking/mutex: Disable optimistic spinning on some architectures

Sowmini Varadhan (1):
      sunvnet: clean up objects created in vnet_new() on vnet_exit()

Srinivas Pandruvada (1):
      iio:core: Handle error when mask type is not separate

Stefan Assmann (1):
      igb: do a reset on SR-IOV re-init if device is down

Steven Rostedt (Red Hat) (1):
      tracing: Fix graph tracer with stack tracer on other archs

Suravee Suthikulpanit (1):
      irqchip: gic: Add binding probe for ARM GIC400

Suresh Reddy (1):
      be2net: set EQ DB clear-intr bit in be_open()

Takashi Iwai (2):
      ALSA: hda - Fix broken PM due to incomplete i915 initialization
      PM / sleep: Fix request_firmware() error at resume

Ted Juan (1):
      mtd: devices: elm: fix elm_context_save() and elm_context_restore() f=
unctions

Thomas Fitzsimmons (1):
      net: mvneta: Fix big endian issue in mvneta_txq_desc_csum()

Thomas Petazzoni (1):
      net: mvneta: fix operation in 10 Mbit/s mode

Todd Fujinaka (1):
      igb: Workaround for i210 Errata 25: Slow System Clock

Tomasz Figa (1):
      irqchip: gic: Fix core ID calculation when topology is read from DT

Tyler Hall (2):
      slip: Fix deadlock in write_wakeup
      slcan: Port write_wakeup deadlock fix from slip

Wei-Chun Chao (1):
      net: fix UDP tunnel GSO of frag_list GRO packets

Yuchung Cheng (1):
      tcp: fix false undo corner cases

dingtianhong (1):
      igmp: fix the problem when mc leave group

zhangwei(Jovi) (2):
      tracing: Add ftrace_trace_stack into __trace_puts/__trace_bputs
      tracing: Add TRACE_ITER_PRINTK flag check in __trace_puts/__trace_bpu=
ts


--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT1os0AAoJEDjbvchgkmk+RbUP/iroyDAubYVaZSmZMvrqlVpv
0tW3iFMfJuwX50dqedu+W3ANLEzDWfeZqWTMGQZyLklXhcWheSwYRqIbBENQzBEe
khrJuZFcxI3UPJ4I+fMIa9zEGXZUGM0dkLrlJrFx+Iq2nAnktnwGm0+/g7xG9yPK
qoATzdDuNJRuVOeZHRNioD7HWEdEx9mURd8PFmd/degcr7gjLNq5TS6KAzB28eEa
yuDxr5/P17x6ZEU9ws4x1D/NlLoBLxDCozNyj2toxwvzVZAp7+51d0rupaJRHeD2
g2tfj7yfPukWX3t5L9DgMzfz8DLMCfQqoim5DtIjjOrIi0LvzIGkWcwJNmQF0PxY
s735W5gwIim237+mCF+Qw1j5ICYuOwnIKq5ePdVgplj6sOHHv2mXyFH2t/kDUAUG
EF6ugKl6XAPAXsUKWk7ENIn1kgBMWizqXsTZJIhKh33y9NBJ+/c6ahIsW2J5swlt
2wQJDCD8BcoC235RtE3pcjrOk5jITCjHO48iSUpjhbj4pTBmmTccLuiR+KYqga5d
rd5cZDL44YJg1wDStWqvimfz/b1nM/pv5IUbn5B//2TklAAlgXObS0ZtFMumMt1G
CfSZvBQT4RKq0pXYV0x21QyoQrBBp8NXkIYfPUY4jnU0mcnUt8whKL3fSuU3cTur
h84fnCW/M9RUCT4tJqZq
=bfTX
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
