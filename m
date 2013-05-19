Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab3ESSct (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 14:32:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3ESScr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 14:32:47 -0400
Date: Sun, 19 May 2013 11:33:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.46
Message-ID: <20130519183304.GA17958@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.46 kernel.

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

 Makefile                                     |    2=20
 arch/arm/mach-omap2/board-rx51-peripherals.c |    4=20
 arch/powerpc/include/asm/rtas.h              |    2=20
 arch/powerpc/kernel/rtas.c                   |  113 ++++++++++++++++++++++=
+++++
 arch/powerpc/platforms/pseries/suspend.c     |   22 +++++
 arch/x86/kvm/vmx.c                           |    6 +
 arch/x86/xen/enlighten.c                     |   15 +++
 drivers/acpi/acpica/exfldio.c                |   14 +++
 drivers/acpi/ec.c                            |    4=20
 drivers/block/drbd/drbd_receiver.c           |    1=20
 drivers/char/ipmi/ipmi_bt_sm.c               |    4=20
 drivers/char/ipmi/ipmi_devintf.c             |   14 +++
 drivers/dma/pch_dma.c                        |    2=20
 drivers/gpu/drm/drm_mm.c                     |   34 ++++----
 drivers/gpu/drm/radeon/r300_cmdbuf.c         |    2=20
 drivers/md/dm-snap.c                         |    1=20
 drivers/md/dm-thin.c                         |    2=20
 drivers/net/ethernet/3com/3c509.c            |    2=20
 drivers/net/ethernet/3com/3c59x.c            |   27 +++---
 drivers/net/ethernet/realtek/r8169.c         |   14 +--
 drivers/net/ethernet/sfc/mcdi.c              |    2=20
 drivers/net/macvlan.c                        |    7 -
 drivers/net/usb/qmi_wwan.c                   |  101 ++++++++++++++++++++++=
++
 drivers/net/wireless/ath/ath9k/main.c        |    6 +
 drivers/net/wireless/b43/dma.c               |   19 ++++
 drivers/net/wireless/b43/dma.h               |    4=20
 drivers/net/wireless/b43/main.c              |   43 ++++------
 drivers/net/wireless/mwifiex/cmdevt.c        |    1=20
 drivers/net/wireless/mwifiex/sta_ioctl.c     |   21 +----
 drivers/platform/x86/hp_accel.c              |    3=20
 drivers/rtc/rtc-pcf2123.c                    |    1=20
 drivers/scsi/sd.c                            |   20 ++++
 drivers/scsi/sd.h                            |    1=20
 drivers/target/iscsi/iscsi_target_erl1.c     |    7 -
 fs/ext4/mballoc.c                            |    6 +
 fs/hugetlbfs/inode.c                         |   20 ++--
 fs/nfsd/nfs4proc.c                           |   15 +++
 include/linux/audit.h                        |    2=20
 include/linux/hugetlb.h                      |    9 --
 include/linux/if_cablemodem.h                |   12 +-
 include/linux/rculist.h                      |   17 ++++
 include/net/sock.h                           |   12 ++
 include/net/tcp.h                            |    1=20
 ipc/shm.c                                    |    4=20
 kernel/kmod.c                                |    5 +
 kernel/time/tick-sched.c                     |    2=20
 kernel/timer.c                               |    2=20
 kernel/trace/trace_events_filter.c           |    4=20
 mm/mmap.c                                    |    6 +
 net/8021q/vlan_dev.c                         |    2=20
 net/bridge/br_stp_timer.c                    |    2=20
 net/core/dev.c                               |    2=20
 net/core/ethtool.c                           |    2=20
 net/core/sock.c                              |   12 --
 net/ipv6/tcp_ipv6.c                          |   12 ++
 net/ipv6/udp.c                               |   13 ++-
 net/ipv6/udp_impl.h                          |    2=20
 net/ipv6/udplite.c                           |    2=20
 net/ipv6/xfrm6_policy.c                      |    4=20
 net/packet/af_packet.c                       |   54 ++++--------
 net/sched/act_ipt.c                          |   33 +++++++
 sound/pci/hda/hda_codec.c                    |    3=20
 sound/soc/codecs/wm8994.c                    |    1=20
 63 files changed, 596 insertions(+), 186 deletions(-)

Aaro Koskinen (1):
      ARM: OMAP: RX-51: change probe order of touchscreen and panel SPI dev=
ices

Anton Blanchard (1):
      audit: Syscall rules are not applied to existing processes on non-x86

Ben Hutchings (1):
      sfc: Fix naming of MTD partitions for FPGA bitfiles

Benjamin LaHaise (1):
      ipmi: ipmi_devintf: compat_ioctl method fails to take ipmi_mutex

Bing Zhao (1):
      mwifiex: clear is_suspended flag when interrupt is received early

Bj=F8rn Mork (4):
      net: qmi_wwan: fixup missing ethernet header (firmware bug workaround)
      net: qmi_wwan: fixup destination address (firmware bug workaround)
      net: qmi_wwan: prevent duplicate mac address on link (firmware bug wo=
rkaround)
      net: vlan,ethtool: netdev_features_t is more than 32 bit

Bob Moore (1):
      ACPICA: Fix possible buffer overflow during a field unit read operati=
on

Chen Gang (1):
      drivers/char/ipmi: memcpy, need additional 2 bytes to avoid memory ov=
erflow

Cong Wang (1):
      xfrm6: release dev before returning error

Dan Carpenter (1):
      ASoC: wm8994: missing break in wm8994_aif3_hw_params()

Daniel Borkmann (1):
      packet: tpacket_v3: do not trigger bug() on wrong header status

Daniel Drake (1):
      mwifiex: fix setting of multicast filter

Daniel Vetter (1):
      drm/mm: fix dump table BUG

Eric Dumazet (2):
      tcp: force a dst refcount when prequeue packet
      ipv6: do not clear pinet6 field

Felix Fietkau (1):
      ath9k: fix key allocation error handling for powersave keys

Francois Romieu (1):
      r8169: fix vlan tag read ordering.

Gleb Natapov (1):
      KVM: VMX: fix halt emulation while emulating invalid guest sate

Greg Kroah-Hartman (1):
      Linux 3.4.46

J. Bruce Fields (1):
      nfsd4: don't allow owner override on 4.1 CLAIM_FH opens

Jamal Hadi Salim (1):
      net_sched: act_ipt forward compat with xtables

James Bottomley (1):
      SCSI: sd: fix array cache flushing bug causing performance problems

Jiri Pirko (1):
      macvlan: fix passthru mode race between dev removal and rx path

Josh Boyer (1):
      if_cablemodem.h: Add parenthesis around ioctl macros

Kees Cook (1):
      drm/radeon: check incoming cliprects pointer

Konrad Rzeszutek Wilk (1):
      xen/vcpu/pvhvm: Fix vcpu hotplugging hanging.

Lachlan McIlroy (1):
      ext4: limit group search loop for non-extent files

Lan Tianyu (1):
      ACPI / EC: Restart transaction even when the IBF flag set

Matthew Whitehead (1):
      3c509.c: call SET_NETDEV_DEV for all device types (ISA/ISAPnP/EISA)

Mike Snitzer (1):
      dm thin: do not set discard_zeroes_data

Naoya Horiguchi (1):
      hugetlbfs: fix mmap failure in unaligned size request

Oleg Nesterov (1):
      usermodehelper: check subprocess_info->path !=3D NULL

Patrick McHardy (1):
      net: use netdev_features_t in skb_needs_linearize()

Philipp Reisner (1):
      drbd: fix for deadlock when using automatic split-brain-recovery

Robert Jennings (1):
      powerpc: Bring all threads online prior to migration/hibernation

Sergei Shtylyov (2):
      3c59x: fix freeing nonexistent resource on driver unload
      3c59x: fix PCI resource management

Shlomo Pongratz (1):
      iscsi-target: Fix processing of OOO commands

Shuah Khan (1):
      hp_accel: Ignore the error from lis3lv02d_poweron() at resume

Steven Rostedt (Red Hat) (1):
      tracing: Fix leaks of filter preds

Thomas Gleixner (1):
      tick: Cleanup NOHZ per cpu data on cpu down

Thommy Jakobsson (1):
      B43: Handle DMA RX descriptor underrun

Tirupathi Reddy (1):
      timer: Don't reinitialize the cpu base lock during CPU_UP_PREPARE

Tomoya MORINAGA (1):
      pch_dma: Use GFP_ATOMIC because called from interrupt context

Wang YanQing (1):
      ALSA: HDA: Fix Oops caused by dereference NULL pointer

Wei Yongjun (2):
      dm snapshot: fix error return code in snapshot_ctr
      drivers/rtc/rtc-pcf2123.c: fix error return code in pcf2123_probe()

stephen hemminger (1):
      bridge: fix race with topology change timer


--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRmRrgAAoJEDjbvchgkmk+DnEQAJPITEtVJeRpFra+rIq/iLur
YNAWlnokXS+QRPDnoAzn5XwcquWxevmfQMeCeStQ1rwCwNYWRzTdWdCFm5sp49Py
OnwC6fCDlMcomd3E8e06lSMozmumYtuKPPBtztrsvqcW+MqsfrHT2vuRL3xzjkQq
wg6lOqAmGaawvW1gCHRxq8vdWIPIASONlQFBMByrxc04TD5V2WP/Q5+/qygLjl7V
coyH2jhVXSb2u66r5VTdL7CN7qrbyOOPO7oiKdu5w6OAhS+aIXPTZlU9Ku3MHxCW
bTB5RW/8HttRnIbhz2W3X+/CVs1g9qucYhu6yvUbodkWbS9zPZHgz3GNxhf2dT4C
YTYFFnPVD+4aq0rAciALx8m7jE5VdpaRv7esWQ7jTgecbMyCErNed1jSFQO1I45J
wwneqG8NXUZUPEcpXWWdvUeE2awXl79CtV8GcavEIywY5hNpCUXn5/8fEAr24sOQ
q0e3Nq46cU/g/dn6ffp3b+1hH27BtitYRghx2kgzc/EETGIDVinMVW0o+mlNYrLB
2YjvWQ9dWh4ylrX6aaUAqd56qGWso7XU1DXoCRMIqj84iv4Z13qx5EyLy9flMn0n
oPtOEJCAaJgcPgAng9JXUlZQ2bMwUXkt6gVFgH5Nj1jtlFgLITyx2LBaf1kvbSu0
J9Nr9BM+BmFQAJxOD8HT
=FTg+
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
