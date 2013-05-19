Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab3ESScM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 14:32:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3ESScK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 14:32:10 -0400
Date: Sun, 19 May 2013 11:32:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.79
Message-ID: <20130519183227.GA12698@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.79 kernel.

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

 Makefile                                     |    2 -
 arch/arm/mach-omap2/board-rx51-peripherals.c |    4 +--
 arch/x86/kvm/vmx.c                           |    6 ++++
 arch/x86/xen/enlighten.c                     |   15 +++++++++++
 drivers/acpi/acpica/exfldio.c                |   14 ++++++++++-
 drivers/acpi/ec.c                            |    4 ---
 drivers/block/drbd/drbd_receiver.c           |    1=20
 drivers/char/ipmi/ipmi_bt_sm.c               |    4 +--
 drivers/char/ipmi/ipmi_devintf.c             |   14 ++++++++++-
 drivers/dma/pch_dma.c                        |    2 -
 drivers/gpu/drm/drm_mm.c                     |   34 ++++++++++++++--------=
-----
 drivers/gpu/drm/radeon/r300_cmdbuf.c         |    2 -
 drivers/md/dm-snap.c                         |    1=20
 drivers/net/3c509.c                          |    2 +
 drivers/net/3c59x.c                          |   27 +++++++++++----------
 drivers/net/macvlan.c                        |    7 +++--
 drivers/net/r8169.c                          |   13 ++++------
 drivers/net/wireless/ath/ath9k/main.c        |    6 +++-
 drivers/net/wireless/mwifiex/cmdevt.c        |    1=20
 drivers/net/wireless/mwifiex/sta_ioctl.c     |   21 ++++------------
 drivers/rtc/rtc-pcf2123.c                    |    1=20
 drivers/scsi/sd.c                            |   20 +++++++++++++++
 drivers/scsi/sd.h                            |    1=20
 fs/ext4/mballoc.c                            |    6 +++-
 include/linux/if_cablemodem.h                |   12 ++++-----
 include/linux/rculist.h                      |   17 +++++++++++++
 include/net/sock.h                           |   12 +++++++++
 include/net/tcp.h                            |    1=20
 kernel/kmod.c                                |    5 +++
 kernel/time/tick-sched.c                     |    2 -
 kernel/timer.c                               |    2 -
 net/bridge/br_stp_timer.c                    |    2 -
 net/core/sock.c                              |   12 ---------
 net/ipv6/tcp_ipv6.c                          |   12 +++++++++
 net/ipv6/udp.c                               |   13 +++++++++-
 net/ipv6/udp_impl.h                          |    2 +
 net/ipv6/udplite.c                           |    2 -
 net/ipv6/xfrm6_policy.c                      |    4 ++-
 net/sched/act_ipt.c                          |   33 ++++++++++++++++++++++=
+---
 sound/soc/codecs/wm8994.c                    |    1=20
 40 files changed, 244 insertions(+), 96 deletions(-)

Aaro Koskinen (1):
      ARM: OMAP: RX-51: change probe order of touchscreen and panel SPI dev=
ices

Benjamin LaHaise (1):
      ipmi: ipmi_devintf: compat_ioctl method fails to take ipmi_mutex

Bing Zhao (1):
      mwifiex: clear is_suspended flag when interrupt is received early

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
      Linux 3.0.79

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

Oleg Nesterov (1):
      usermodehelper: check subprocess_info->path !=3D NULL

Philipp Reisner (1):
      drbd: fix for deadlock when using automatic split-brain-recovery

Sergei Shtylyov (2):
      3c59x: fix freeing nonexistent resource on driver unload
      3c59x: fix PCI resource management

Thomas Gleixner (1):
      tick: Cleanup NOHZ per cpu data on cpu down

Tirupathi Reddy (1):
      timer: Don't reinitialize the cpu base lock during CPU_UP_PREPARE

Tomoya MORINAGA (1):
      pch_dma: Use GFP_ATOMIC because called from interrupt context

Wei Yongjun (2):
      dm snapshot: fix error return code in snapshot_ctr
      drivers/rtc/rtc-pcf2123.c: fix error return code in pcf2123_probe()

stephen hemminger (1):
      bridge: fix race with topology change timer


--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRmRq7AAoJEDjbvchgkmk+RDAP/1LUIMoyvXU56iB7g0HXNNEo
NLZ1D2Np/MVhjIrxv0/3gbI49L+oB8C2WJ/usW8brSq2RB6PnsdR6KStCKCfTzb0
WRGvHAYcbIQ1SMPNL41KBdRjdHPPe4RTvqovvZF1ya98OWBGunoi5blyr2LN2Ben
MJ21lMdpaTzmHTVgRVwvVu+K2tZhN7HyLdTFv7JFBfzFV+ejGBb8bKwI0yJ4xZQS
6OCL7444AGrhT0+i+VvliFVRR25ZOYcDMlmLKZwbRIXoQNqXIymKvLBYRXMUfGZ9
8PIR3DpmZpvhv95gG7Bq4U6YODmDIDMRMme3W4mSe43z7eV4XlqzOv6J/0QhsQwo
5TSklRzQ3ErYhXmb+jX9nTD95egCTyB3U/zMTkO3bvnNjorHPwAkyqxUHlJy3wVx
lO+BxdndIgW7q4YSXX9WM2PyZ0kGNRT59VDr4PDQ/qsGBUKmxE9r4nkMX3t5baFi
eW+1ippXkva6Oa+UlrdpI/y1Sk9uzEnt8WA+iJ46/iVdcHpe3BnA52dbylFysaG4
Muqw2CxpJhXtegNclWFHWWbtyEDDJcHA3po9nPCfXgPr3f02IncmG+HKXryw9boO
20rzcMokhUl8n7KPr+15ln6ZqgRa6D62detQcfNGy7SFp8zDo3rwqNiendtUhB02
DBjZRz8BgRqgrOKF+dT5
=+HFm
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
