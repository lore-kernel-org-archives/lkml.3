Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaG1RlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:41:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaG1RlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:41:09 -0400
Date: Mon, 28 Jul 2014 10:40:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.50
Message-ID: <20140728174042.GA16409@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.50 kernel.

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
 arch/arc/include/uapi/asm/ptrace.h              |    1=20
 arch/arc/kernel/ptrace.c                        |    4=20
 arch/arm/Kconfig                                |    1=20
 arch/arm64/Kconfig                              |    1=20
 arch/powerpc/Kconfig                            |    1=20
 arch/sparc/Kconfig                              |    1=20
 arch/x86/Kconfig                                |    1=20
 arch/x86/kernel/cpu/perf_event_intel.c          |    9 +
 drivers/bluetooth/hci_h5.c                      |    1=20
 drivers/gpu/drm/qxl/qxl_irq.c                   |    3=20
 drivers/gpu/drm/radeon/atombios_encoders.c      |   10 +
 drivers/gpu/drm/radeon/radeon_display.c         |    5=20
 drivers/hv/hv_kvp.c                             |   14 ++
 drivers/hv/hv_util.c                            |    2=20
 drivers/hwmon/adt7470.c                         |    6 -
 drivers/hwmon/da9052-hwmon.c                    |    2=20
 drivers/hwmon/da9055-hwmon.c                    |    2=20
 drivers/irqchip/irq-gic.c                       |    6 -
 drivers/md/dm-cache-metadata.c                  |    9 +
 drivers/md/dm-thin-metadata.c                   |    9 +
 drivers/media/usb/gspca/pac7302.c               |    1=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    3=20
 drivers/net/ethernet/emulex/benet/be_main.c     |    2=20
 drivers/net/ethernet/intel/igb/igb_main.c       |    2=20
 drivers/net/ethernet/marvell/mvneta.c           |    4=20
 drivers/net/ethernet/sun/sunvnet.c              |   20 +++
 drivers/net/ppp/pppoe.c                         |    2=20
 drivers/net/usb/qmi_wwan.c                      |    3=20
 drivers/net/wireless/iwlwifi/dvm/rxon.c         |   12 --
 drivers/net/wireless/mwifiex/main.c             |    1=20
 drivers/usb/core/hub.c                          |   19 +++
 fs/fuse/inode.c                                 |   20 +++
 include/net/sock.h                              |   16 +--
 kernel/Kconfig.locks                            |    5=20
 kernel/power/process.c                          |    1=20
 kernel/sched/debug.c                            |    2=20
 kernel/time/alarmtimer.c                        |   20 +++
 kernel/trace/ftrace.c                           |    4=20
 kernel/trace/ring_buffer.c                      |    4=20
 kernel/trace/trace.c                            |   12 +-
 mm/shmem.c                                      |  104 ++++++++++++++++++--
 net/8021q/vlan_core.c                           |    5=20
 net/appletalk/ddp.c                             |    3=20
 net/core/dst.c                                  |   16 ++-
 net/dns_resolver/dns_query.c                    |    4=20
 net/ipv4/icmp.c                                 |    2=20
 net/ipv4/igmp.c                                 |   10 +
 net/ipv4/ip_options.c                           |    4=20
 net/ipv4/ip_tunnel.c                            |   12 +-
 net/ipv4/route.c                                |   15 +-
 net/ipv4/tcp.c                                  |    3=20
 net/ipv4/tcp_input.c                            |   10 -
 net/ipv4/tcp_output.c                           |    6 -
 net/netlink/af_netlink.c                        |    4=20
 net/sctp/sysctl.c                               |    3=20
 net/sctp/ulpevent.c                             |  122 ++-----------------=
-----
 net/tipc/bcast.c                                |    1=20
 58 files changed, 354 insertions(+), 213 deletions(-)

Alex Deucher (2):
      drm/radeon: set default bl level to something reasonable
      drm/radeon: avoid leaking edid data

Amitkumar Karwar (1):
      mwifiex: fix Tx timeout issue

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

Bernd Wachter (1):
      net: qmi_wwan: Add ID for Telewell TW-LTE 4G v2

Bj=F8rn Mork (1):
      net: qmi_wwan: add two Sierra Wireless/Netgear devices

Christoph Paasch (1):
      tcp: Fix divide by zero when pushing during tcp-repair

Christoph Schulz (1):
      net: pppoe: use correct channel MTU when using Multilink PPP

Daniel Borkmann (2):
      net: sctp: check proc_dointvec result in proc_sctp_do_auth
      net: sctp: fix information leaks in ulpevent layer

Dmitry Popov (1):
      ip_tunnel: fix ip_tunnel_lookup

Edward Allcutt (1):
      ipv4: icmp: Fix pMTU handling for rare case

Emmanuel Grumbach (1):
      iwlwifi: dvm: don't enable CTS to self

Eric Dumazet (5):
      ipv4: fix dst race in sk_dst_get()
      ipv4: irq safe sk_dst_[re]set() and ipv4_sk_update_pmtu() fix
      net: fix sparse warning in sk_dst_set()
      bnx2x: fix possible panic under memory stress
      ipv4: fix buffer overflow in ip_options_compile()

Gavin Guo (1):
      usb: Check if port status is equal to RxDetect

Greg Kroah-Hartman (1):
      Linux 3.10.50

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

John Stultz (1):
      alarmtimer: Fix bug where relative alarm timers were treated as absol=
ute

Jon Paul Maloy (1):
      tipc: clear 'next'-pointer of message fragments before reassembly

K. Y. Srinivasan (1):
      Drivers: hv: util: Fix a bug in the KVP code

Li RongQing (1):
      8021q: fix a potential memory leak

Loic Poulain (1):
      Bluetooth: Ignore H5 non-link packets in non-active state

Manuel Sch=F6lling (1):
      dns_resolver: assure that dns_query() result is null-terminated

Martin Lau (1):
      ring-buffer: Fix polling on trace_pipe

Mateusz Guzik (1):
      sched: Fix possible divide by zero in avg_atom() calculation

Matthias Brugger (1):
      irqchip: gic: Add support for cortex a7 compatible string

Mike Snitzer (2):
      dm thin metadata: do not allow the data block size to change
      dm cache metadata: do not allow the data block size to change

Miklos Szeredi (1):
      fuse: handle large user and group ID

Neal Cardwell (1):
      tcp: fix tcp_match_skb_to_sack() for unaligned SACK at end of an skb

Peter Zijlstra (1):
      locking/mutex: Disable optimistic spinning on some architectures

Sowmini Varadhan (1):
      sunvnet: clean up objects created in vnet_new() on vnet_exit()

Stefan Assmann (1):
      igb: do a reset on SR-IOV re-init if device is down

Steven Rostedt (Red Hat) (1):
      tracing: Fix graph tracer with stack tracer on other archs

Suresh Reddy (1):
      be2net: set EQ DB clear-intr bit in be_open()

Takashi Iwai (1):
      PM / sleep: Fix request_firmware() error at resume

Thomas Fitzsimmons (1):
      net: mvneta: Fix big endian issue in mvneta_txq_desc_csum()

Thomas Petazzoni (1):
      net: mvneta: fix operation in 10 Mbit/s mode

Tomasz Figa (1):
      irqchip: gic: Fix core ID calculation when topology is read from DT

Yuchung Cheng (1):
      tcp: fix false undo corner cases

dingtianhong (1):
      igmp: fix the problem when mc leave group

zhangwei(Jovi) (1):
      tracing: Add ftrace_trace_stack into __trace_puts/__trace_bputs


--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT1osaAAoJEDjbvchgkmk+UC8P/0t59iG76t49WtpIuhqdphfA
akHmrllAuUI3SxFWwG1qG1g1wJtDaQLLUwvvAFAm+QVzlYgUqMw6+9wIGFXFBjxL
TCYTOdqbBpIvVNxOYm95BiSe1RLaIO/3NGUrO6Lx+oGG0symvd5tw2umjScJykW2
eZupWzIT166ap0UAWThwHil2nqZ2FROw1E2PXV82ao7q7yTBSINL6YbIrhe+0esy
87UFQK1MMhsmUq5JOvWTFDcjFnBwT77t/WcWY6P/GRYEkFspzOc4uk8+nVSuO/M8
d9T+TWghZDpAo2olXwkNkOqRVJoCPAYXV+iFI0/8rKCRWl1jt2+NaHaO3jVL2iVv
ZWkzZb3F9uADM/uzKvWEsInZodmO78G6G1bhXM7Giq646StuYPjnJQSx0d8sXHNl
XJ/BsgUkQo4f96M222PZ/ddMb0k+iIxMJu2fVHNdUJPQMGs+osgZ3lrzaakSDViw
9oLgP2dWys28VlJawV9Jmh6UDSDLDDLybubM0+aymkfi31rSvpgxc2jIYc9/nwS8
BdSt0zrxMvp7NcfW8SptCUggmrVBUYafpzwrXC6DJZq5JrB9C0oXqLZ5cqKhsVvR
AgqwJX33P/C7lDYstnWIhkj3klCaVQxZBsq2M5st3Rdu1uG6JmP5eX/EutvQhXYd
VqV3URUc85XvDm5LmzWr
=qpsz
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
