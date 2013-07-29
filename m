Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab3G2EIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 00:08:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43483 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab3G2EId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 00:08:33 -0400
Date: Sun, 28 Jul 2013 21:09:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.55
Message-ID: <20130729040951.GA32138@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.55 kernel.

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

 Makefile                                        |    2=20
 arch/sparc/kernel/asm-offsets.c                 |    2=20
 arch/sparc/mm/hypersparc.S                      |    8 +--
 arch/sparc/mm/init_64.c                         |    9 +++-
 arch/sparc/mm/swift.S                           |    8 +--
 arch/sparc/mm/tlb.c                             |    2=20
 arch/sparc/mm/tsunami.S                         |    6 +-
 arch/sparc/mm/viking.S                          |   10 ++--
 drivers/ata/ata_piix.c                          |    2=20
 drivers/ata/libata-pmp.c                        |   33 ++++++++-------
 drivers/iommu/amd_iommu.c                       |    6 ++
 drivers/net/dummy.c                             |    4 +
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c |   50 +++++++++++++++++++=
+++--
 drivers/net/ethernet/renesas/sh_eth.c           |   17 ++++----
 drivers/net/ethernet/renesas/sh_eth.h           |    2=20
 drivers/net/ethernet/sun/sunvnet.c              |    2=20
 drivers/net/ifb.c                               |    8 +++
 drivers/net/macvtap.c                           |   14 ++++--
 drivers/net/wireless/ath/ath9k/calib.c          |    1=20
 drivers/net/wireless/rt2x00/rt2800lib.c         |    4 -
 drivers/net/wireless/rt2x00/rt61pci.c           |    3 -
 drivers/net/wireless/rt2x00/rt73usb.c           |    3 -
 drivers/s390/scsi/zfcp_fsf.c                    |    4 +
 drivers/s390/scsi/zfcp_scsi.c                   |   10 +++-
 drivers/scsi/bnx2fc/bnx2fc_io.c                 |    2=20
 drivers/scsi/megaraid/megaraid_sas_base.c       |   10 ++--
 drivers/scsi/mpt2sas/mpt2sas_scsih.c            |    6 --
 drivers/usb/serial/cp210x.c                     |    4 +
 drivers/usb/serial/option.c                     |   23 ++++++-----
 fs/block_dev.c                                  |    9 +++-
 fs/ext3/inode.c                                 |    3 -
 fs/lockd/svclock.c                              |    4 +
 include/linux/if_pppox.h                        |    4 -
 include/net/addrconf.h                          |    3 +
 include/net/udp.h                               |    1=20
 kernel/events/core.c                            |   28 ++++++++++++-
 kernel/hrtimer.c                                |   28 ++++++-------
 kernel/time/tick-broadcast.c                    |   10 ++++
 kernel/trace/trace.c                            |   10 ++++
 kernel/trace/trace_syscalls.c                   |   18 ++++++--
 net/8021q/vlan_dev.c                            |    7 +++
 net/9p/trans_common.c                           |   10 ++--
 net/bridge/br_multicast.c                       |    5 +-
 net/core/neighbour.c                            |   12 +++--
 net/ipv4/tcp_ipv4.c                             |    4 -
 net/ipv4/udp.c                                  |    3 -
 net/ipv6/addrconf.c                             |   31 ++++++++++----
 net/ipv6/ip6_output.c                           |   24 ++++++++---
 net/ipv6/mcast.c                                |   18 ++++----
 net/ipv6/route.c                                |    9 ++--
 net/ipv6/udp.c                                  |    7 ++-
 net/key/af_key.c                                |    2=20
 net/l2tp/l2tp_ppp.c                             |    3 -
 net/x25/af_x25.c                                |   15 +++----
 sound/soc/codecs/sgtl5000.h                     |    2=20
 sound/usb/6fire/pcm.c                           |    2=20
 56 files changed, 364 insertions(+), 163 deletions(-)

Alex Williamson (1):
      iommu/amd: Only unmap large pages from the first pte

Alexandr \\\"Sky\\\" Ivanov (1):
      USB: option: add D-Link DWM-152/C1 and DWM-156/C1

Amerigo Wang (1):
      ipv6,mcast: always hold idev->lock before mca_lock

Andi Kleen (1):
      SCSI: Fix incorrect memset in bnx2fc_parse_fcp_rsp

Aydin Arik (1):
      ipv4: Fixed MD5 key lookups when adding/ removing MD5 to/ from TCP so=
ckets.

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
      Linux 3.4.55

Hannes Frederic Sowa (3):
      ipv6: call udp_push_pending_frames when uncorking a socket with AF_IN=
ET pending data
      ipv6: ip6_append_data_mtu did not care about pmtudisc and frag_size
      ipv6: in case of link failure remove route directly instead of lettin=
g it expire

Jan Kara (2):
      ext3: fix data=3Djournal fast mount/umount hang
      writeback: Fix periodic writeback after fs mount

Jason Wang (1):
      macvtap: correctly linearize skb when zerocopy is used

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

Michael S. Tsirkin (1):
      macvtap: fix recovery from gup errors

Neil Horman (2):
      atl1e: fix dma mapping warnings
      atl1e: unmap partially mapped skb on dma error and free skb

Olivier DANET (1):
      sparc32: vm_area_struct access for old Sun SPARCs.

Peter Zijlstra (1):
      perf: Fix perf_lock_task_context() vs RCU

Sami Rahman (1):
      USB: cp210x: add MMB and PI ZigBee USB Device Support

Sasha Levin (1):
      9p: fix off by one causing access violations and memory corruption

Sergei Shtylyov (1):
      sh_eth: fix unhandled RFE interrupt

Seth Heasley (1):
      ata_piix: IDE-mode SATA patch for Intel Coleto Creek DeviceIDs

Sreekanth Reddy (1):
      SCSI: mpt2sas: fix firmware failure with wrong task attribute

Steffen Maier (1):
      zfcp: block queue limits with data router

Steven Rostedt (Red Hat) (1):
      tracing: Use current_uid() for critical time tracing

Sujith Manoharan (1):
      ath9k: Do not assign noise for NULL caldata

Tejun Heo (1):
      libata: skip SRST for all SIMG [34]7x port-multipliers

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


--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJR9esPAAoJEDjbvchgkmk+HLwP/1kO2J5mebsHxTrInRPSGav2
0fJJcS94hWmNGub9slBpEUDKAc9FiSCcyqJFVabQvYN25+SeNwIj1x5FZ9hoxeJs
9zLp76NwXDQJwAR2F58SBLBIBZCfZgCFF2SJo9Xmfs8fl+Q9Pq2vgjZfAiNAC/pe
bujIjdzq3i18tPv5SObF5obAMfwkMwd3kIJb+/wJViDb5UyYgyDodX2o0I+zhB6c
/MoOQVwa+PqvldskRgm2LGd5iWysNDpaUWobhmfEOBj6CGeQAkLDt6Sa5p8769s5
jrUtWAPNjWjFXKFGuIgLScTd7EhXF4AwbSxcwvOnNZAgnu4vPkbEUr3F7oS8PIzR
epVfbirIoNSZAMcdUgeSBsptgDWE+xEAqw+oJEyqR6Y/+F0G1NkjSLB9gUdeWldq
UXOCEvvvoh3aAwtr9yHbJ4UFjcXFGSyCNDaMVe40u4kmNyFfHYFQGOitmwU0fZVq
UqvFU4eGvobC9+Tk4SQRt6SFc2DR9MfGdgfncoJnuO+A6mn95Ln7sosD/uNycT/r
LSHzQiFxB9OO1X0YpBVT6QiB5sGyDim3OKSwzGb0GcsF9WT/iH9QVHbQmfzf4F5P
dybD5v/ropIo5ztN8MXvh6EkJVbST2kxVhdFm4zDRVVKnjPx68O1QF6Cup6hwXg8
exgsAJCYW7zMu6KH/V7e
=bORF
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
