Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751022Ab3G2EIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 00:08:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43476 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab3G2EH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 00:07:57 -0400
Date: Sun, 28 Jul 2013 21:09:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.88
Message-ID: <20130729040915.GA32069@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.88 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                  |    2 -
 arch/sparc/kernel/asm-offsets.c           |    2 +
 arch/sparc/mm/hypersparc.S                |    8 +++----
 arch/sparc/mm/init_64.c                   |    9 +++++++-
 arch/sparc/mm/swift.S                     |    8 +++----
 arch/sparc/mm/tlb.c                       |    2 -
 arch/sparc/mm/tsunami.S                   |    6 ++---
 arch/sparc/mm/viking.S                    |   10 ++++-----
 drivers/net/dummy.c                       |    4 +++
 drivers/net/ifb.c                         |    9 +++++++-
 drivers/net/sunvnet.c                     |    2 +
 drivers/net/wireless/rt2x00/rt2800lib.c   |    4 +--
 drivers/net/wireless/rt2x00/rt61pci.c     |    3 +-
 drivers/net/wireless/rt2x00/rt73usb.c     |    3 +-
 drivers/s390/scsi/zfcp_aux.c              |    5 +++-
 drivers/s390/scsi/zfcp_fsf.c              |   25 ++++++++++++++++++------
 drivers/scsi/bnx2fc/bnx2fc_io.c           |    2 -
 drivers/scsi/megaraid/megaraid_sas_base.c |   10 +++++----
 drivers/scsi/mpt2sas/mpt2sas_scsih.c      |    6 -----
 drivers/usb/serial/cp210x.c               |    4 +++
 drivers/usb/serial/option.c               |   23 ++++++++++++----------
 fs/block_dev.c                            |   10 ++++++++-
 fs/lockd/svclock.c                        |    4 +++
 include/linux/if_pppox.h                  |    4 +--
 include/net/addrconf.h                    |    3 ++
 include/net/udp.h                         |    1=20
 kernel/events/core.c                      |   28 ++++++++++++++++++++++++-=
--
 kernel/hrtimer.c                          |   28 ++++++++++++-------------=
--
 kernel/time/tick-broadcast.c              |   10 ++++++++-
 kernel/trace/trace.c                      |   10 ++++++++-
 kernel/trace/trace_syscalls.c             |   18 +++++++++++++----
 net/8021q/vlan_dev.c                      |    7 ++++++
 net/bridge/br_multicast.c                 |    5 ++--
 net/core/neighbour.c                      |   12 ++++++-----
 net/ipv4/udp.c                            |    3 +-
 net/ipv6/addrconf.c                       |   31 ++++++++++++++++++++-----=
-----
 net/ipv6/ip6_output.c                     |    8 ++++++-
 net/ipv6/mcast.c                          |   18 +++++++++--------
 net/ipv6/udp.c                            |    7 +++++-
 net/key/af_key.c                          |    2 +
 net/l2tp/l2tp_ppp.c                       |    3 +-
 net/x25/af_x25.c                          |   15 +++++++-------
 sound/soc/codecs/sgtl5000.h               |    2 -
 sound/usb/6fire/pcm.c                     |    2 -
 44 files changed, 262 insertions(+), 116 deletions(-)

Alexandr \\\"Sky\\\" Ivanov (1):
      USB: option: add D-Link DWM-152/C1 and DWM-156/C1

Amerigo Wang (1):
      ipv6,mcast: always hold idev->lock before mca_lock

Andi Kleen (1):
      SCSI: Fix incorrect memset in bnx2fc_parse_fcp_rsp

Barry Grussling (1):
      usb: cp210x support SEL C662 Vendor/Device

Bj=F8rn Mork (2):
      SCSI: megaraid_sas: fix memory leak if SGL has zero length entries
      usb: option: add TP-LINK MA260

Changli Gao (1):
      net: Swap ver and type in pppoe_hdr

Dan Williams (1):
      usb: serial: option: add Olivetti Olicard 200

Daniel Hansel (1):
      SCSI: zfcp: fix adapter (re)open recovery while link to SAN is down

Daniil Bolsun (1):
      USB: option: append Petatel NP10T device to GSM modems list

Dave Jones (1):
      x25: Fix broken locking in ioctl error paths.

Dave Kleikamp (2):
      sparc: tsb must be flushed before tlb
      sunvnet: vnet_port_remove must call unregister_netdev

David Jeffery (1):
      lockd: protect nlm_blocked access in nlmsvc_retry_blocked

Eldad Zack (1):
      ALSA: usb-audio: 6fire: return correct XRUN indication

Enrico Mioso (3):
      usb: serial: option: blacklist ONDA MT689DC QMI interface
      usb: serial: option.c: remove ONDA MT825UP product ID fromdriver
      usb: serial: option: Add ONYX 3G device support

Eric Dumazet (3):
      ipv6: ip6_sk_dst_check() must not assume ipv6 dst
      neighbour: fix a race in neigh_destroy()
      vlan: fix a race in egress prio management

Fabio Estevam (1):
      ASoC: sglt5000: Fix SGTL5000_PLL_FRAC_DIV_MASK

Gabor Juhos (1):
      rt2x00: read 5GHz TX power values from the correct offset

Gao feng (1):
      ipv6: don't call addrconf_dst_alloc again when enable lo

Greg Kroah-Hartman (1):
      Linux 3.0.88

Hannes Frederic Sowa (1):
      ipv6: call udp_push_pending_frames when uncorking a socket with AF_IN=
ET pending data

Jan Kara (1):
      writeback: Fix periodic writeback after fs mount

Jiri Olsa (2):
      perf: Clone child context from parent context pmu
      perf: Remove WARN_ON_ONCE() check in __perf_event_enable() for valid =
scenario

Linus L=FCssing (1):
      bridge: fix switched interval for MLD Query types

Luiz Angelo Daros de Luca (1):
      usb: serial: cp210x: Add USB ID for Netgear Switches embedded serial =
adapter

Mathias Krause (1):
      af_key: fix info leaks in notify messages

Olivier DANET (1):
      sparc32: vm_area_struct access for old Sun SPARCs.

Peter Zijlstra (1):
      perf: Fix perf_lock_task_context() vs RCU

Sami Rahman (1):
      USB: cp210x: add MMB and PI ZigBee USB Device Support

Sreekanth Reddy (1):
      SCSI: mpt2sas: fix firmware failure with wrong task attribute

Steffen Maier (1):
      zfcp: status read buffers on first adapter open with link down

Steven Rostedt (Red Hat) (1):
      tracing: Use current_uid() for critical time tracing

Thomas Gleixner (2):
      tick: Prevent uncontrolled switch to oneshot mode
      hrtimers: Move SMP function call to thread context

Wei Yongjun (1):
      l2tp: add missing .owner to struct pppox_proto

bob picco (1):
      sparc64 address-congruence property

dingtianhong (3):
      ifb: fix rcu_sched self-detected stalls
      dummy: fix oops when loading the dummy failed
      ifb: fix oops when loading the ifb failed

zhangwei(Jovi) (1):
      tracing: Fix irqs-off tag display in syscall tracing


--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJR9errAAoJEDjbvchgkmk+vH8QAMpsHrB3MC+2N1GieMEWQjgO
uctKiK3QE0PaxWSMyN0j6ffqTkzKKkcAgwZD282IdwX5T/4J7ckAF8Jw+p7/jjvO
cdbkZKWi0Dl40OzPrOIF/vxNFmKfqf/CdJQUqwLv+OdQTvLGZoHpm34BQ5Y/9qvl
ImvOu1pmPmZlOx9nNklEW76Mlb7EN6ELwvnhrhDeBRXXgh+VfNufRjrLZFr6cct4
THBNjRolcp4fvipfqFjgPbEhR3U00nn8NGpOv/U73BBcbkWda5nGJMRgUg4M6RKH
Az4DHj0L4zePwJSnK7wd1xL99IY+w45+2HvFO9rVMtYaiMQEptIEj4b3l5PoxIDr
j5XBJ0ZcRftJlOgsWzH/OxzPub/yoqQzvKwwOwVKLo6bNKBlKWH68bavd6Q6Z2nm
Y7mwDreLwCuGaSN8wC/2bY78jNVIT3kL0K3yoiFgc4lR8hpMxmJKufJmeoBqRzTS
9OJfRlOzDuxxE2kMJAyIgYh4+RmVsLZuQCCeY1V01taRMwCgdHBRoxgHBCTl5TEd
weNjQuof3Oxt3hbz7UBrGObEf6niZPKPwJzt3wytcwXP6pJTLOKwldjCJs6UaI6n
N4qec7izEjM8gyHE1U3SUuGVGE4RtAG38jsqdibSuSvOKvVeFy4PqK9yOOUvRZAV
PDKBI5MpTYvMjjHoRVp1
=4IVJ
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
