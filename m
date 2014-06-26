Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaFZTne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:43:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaFZTnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:43:32 -0400
Date: Thu, 26 Jun 2014 15:26:57 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.15.2
Message-ID: <20140626192657.GA24804@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.15.2 kernel.

All users of the 3.15 kernel series must upgrade.

The updated 3.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.15.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/ABI/testing/ima_policy     |    2=20
 Makefile                                 |    2=20
 arch/arm/mach-at91/sysirq_mask.c         |   22 +++--
 arch/mips/kvm/kvm_mips.c                 |    2=20
 arch/s390/kvm/interrupt.c                |    4=20
 arch/s390/kvm/kvm-s390.c                 |    2=20
 arch/s390/kvm/kvm-s390.h                 |    1=20
 arch/sparc/net/bpf_jit_comp.c            |    8 -
 arch/x86/kvm/lapic.c                     |   62 ++++++++++-----
 drivers/hv/connection.c                  |    4=20
 drivers/hv/hv_balloon.c                  |   29 ++++++-
 drivers/iio/adc/at91_adc.c               |   16 +--
 drivers/iio/adc/max1363.c                |   16 +--
 drivers/iio/adc/men_z188_adc.c           |    4=20
 drivers/iio/magnetometer/ak8975.c        |    9 --
 drivers/iio/pressure/mpl3115.c           |    6 -
 drivers/net/ethernet/renesas/sh_eth.c    |   32 +++++--
 drivers/net/ethernet/renesas/sh_eth.h    |    2=20
 drivers/net/ethernet/sfc/io.h            |    7 +
 drivers/net/ethernet/sfc/tx.c            |   22 ++++-
 drivers/net/macvlan.c                    |    1=20
 drivers/net/usb/qmi_wwan.c               |    7 +
 drivers/net/vxlan.c                      |    7 -
 drivers/rtc/rtc-at91rm9200.c             |   16 +++
 drivers/staging/iio/adc/mxs-lradc.c      |   12 +-
 drivers/staging/iio/light/tsl2x7x_core.c |    8 +
 drivers/target/iscsi/iscsi_target_auth.c |   10 ++
 drivers/target/target_core_transport.c   |    4=20
 drivers/usb/class/cdc-acm.c              |  125 ++++++++++++++++++--------=
-----
 drivers/usb/class/cdc-acm.h              |    2=20
 include/sound/core.h                     |    2=20
 include/uapi/sound/compress_offload.h    |    2=20
 lib/lz4/lz4_decompress.c                 |    2=20
 lib/lzo/lzo1x_decompress_safe.c          |   62 ++++++++++-----
 mm/shmem.c                               |    3=20
 mm/slab.c                                |   90 +++++++++++++++++-----
 net/core/dev.c                           |    5 -
 net/core/rtnetlink.c                     |   23 ++++-
 net/ipv4/datagram.c                      |   20 +++-
 net/ipv4/ipip.c                          |    5 -
 net/ipv4/udp.c                           |    4=20
 net/ipv6/ip6_tunnel.c                    |    1=20
 net/ipv6/sit.c                           |    5 -
 net/ipv6/udp.c                           |    8 -
 net/mac80211/iface.c                     |    1=20
 net/sctp/associola.c                     |    2=20
 security/integrity/evm/evm_main.c        |   12 ++
 security/integrity/ima/ima_api.c         |   10 ++
 security/integrity/ima/ima_crypto.c      |   32 +++++++
 security/integrity/ima/ima_main.c        |    5 -
 security/integrity/ima/ima_policy.c      |    6 +
 security/integrity/integrity.h           |    1=20
 sound/core/control.c                     |   78 ++++++++++++-------
 sound/core/init.c                        |    1=20
 sound/pci/hda/patch_hdmi.c               |   10 ++
 sound/pci/hda/patch_realtek.c            |   24 +++++
 sound/soc/codecs/max98090.c              |    3=20
 sound/soc/codecs/tlv320aic3x.c           |    2=20
 sound/soc/soc-dapm.c                     |   23 ++---
 59 files changed, 624 insertions(+), 262 deletions(-)

Alexei Starovoitov (2):
      net: filter: fix typo in sparc BPF JIT
      net: filter: fix sparc32 typo

Ben Dooks (1):
      sh_eth: use RNC mode for packet reception

Bj=C3=B8rn Mork (1):
      net: qmi_wwan: add Olivetti Olicard modems

Boris BREZILLON (2):
      rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq
      ARM: at91: fix at91_sysirq_mask_rtc for sam9x5 SoCs

Christian Borntraeger (1):
      KVM: s390: Drop pending interrupts on guest exit

Cong Wang (1):
      vxlan: use dev->needed_headroom instead of dev->hard_header_len

Dan Carpenter (2):
      iio: adc: checking for NULL instead of IS_ERR() in probe
      iio: adc: at91: signedness bug in at91_adc_get_trigger_value_by_name()

David Henningsson (1):
      ALSA: hda - Add quirk for external mic on Lifebook U904

Dmitry Kasatkin (1):
      ima: introduce ima_kernel_read()

Dmitry Popov (1):
      ipip, sit: fix ipv4_{update_pmtu,redirect} calls

Eric Dumazet (3):
      net: force a list_del() in unregister_netdevice_many()
      ipv4: fix a race in ip4_datagram_release_cb()
      udp: ipv4: do not waste time in __udp4_lib_mcast_demux_lookup

Greg Kroah-Hartman (3):
      lzo: properly check for overruns
      lz4: ensure length does not wrap
      Linux 3.15.2

Hugh Dickins (1):
      tmpfs: ZERO_RANGE and COLLAPSE_RANGE not currently supported

James Hogan (1):
      MIPS: KVM: Allocate at least 16KB for exception handlers

Johan Hovold (10):
      USB: cdc-acm: fix write and suspend race
      USB: cdc-acm: fix write and resume race
      USB: cdc-acm: fix broken runtime suspend
      USB: cdc-acm: fix runtime PM for control messages
      USB: cdc-acm: fix shutdown and suspend race
      USB: cdc-acm: fix potential urb leak and PM imbalance in write
      USB: cdc-acm: fix open and suspend race
      USB: cdc-acm: fix failed open not being detected
      USB: cdc-acm: fix I/O after failed open
      USB: cdc-acm: fix runtime PM imbalance at shutdown

Jon Cooper (1):
      sfc: PIO:Restrict to 64bit arch and use 64-bit writes.

Jonathan Cameron (1):
      iio:adc:max1363 incorrect resolutions for max11604, max11605, max1161=
0 and max11611.

Joonsoo Kim (1):
      slab: fix oops when reading /proc/slab_allocators

K. Y. Srinivasan (1):
      Drivers: hv: balloon: Ensure pressure reports are posted regularly

Kailang Yang (2):
      ALSA: hda/realtek - Add support of ALC891 codec
      ALSA: hda/realtek - Add more entry for enable HP mute led

Lars-Peter Clausen (6):
      ASoC: dapm: Make sure to always update the DAPM graph in _put_volsw()
      ALSA: control: Protect user controls against concurrent access
      ALSA: control: Fix replacing user controls
      ALSA: control: Don't access controls outside of protected regions
      ALSA: control: Handle numid overflow
      ALSA: control: Make sure that id->index does not overflow

Liam Girdwood (1):
      ASoC: max98090: Fix reset at resume time

Mario Schuknecht (1):
      staging: iio: tsl2x7x_core: fix proximity treshold

Mengdong Lin (1):
      ALSA: hda - verify pin:converter connection on unsol event for HSW an=
d VLV

Michal Schmidt (1):
      rtnetlink: fix userspace API breakage for iproute2 < v3.9.0

Mimi Zohar (2):
      ima: audit log files opened with O_DIRECT flag
      evm: prohibit userspace writing 'security.evm' HMAC value

Nicholas Bellinger (2):
      target: Fix NULL pointer dereference for XCOPY in target_put_sess_cmd
      iscsi-target: Reject mutual authentication with reflected CHAP_C

Paolo Bonzini (1):
      KVM: lapic: sync highest ISR to hardware apic on EOI

Peter Meerwald (2):
      iio: Fix endianness issue in ak8975_read_axis()
      iio: Fix two mpl3115 issues in measurement conversion

Peter Ujfalusi (1):
      ASoC: tlv320aci3x: Fix custom snd_soc_dapm_put_volsw_aic3x() function

Radim Kr=C4=8Dm=C3=A1=C5=99 (1):
      hv: use correct order when freeing monitor_pages

Robert Hodaszi (1):
      iio: mxs-lradc: fix divider

Sergei Shtylyov (1):
      sh_eth: fix SH7619/771x support

Sven Wegener (1):
      ipv6: Fix regression caused by efe4208 in udp_v6_mcast_next()

Tom Gundersen (1):
      net: tunnels - enable module autoloading

Wang, Xiaoming (1):
      ALSA: compress: Cancel the optimization of compiler and fix the size =
of struct for all platform.

Xufeng Zhang (1):
      sctp: Fix sk_ack_backlog wrap-around problem


--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrHQBAAoJEDjbvchgkmk+Y/AP/0m5qMvNV2w5kqqcJ1RgcYcQ
UjKdXcIRcd6wvGwRZmk9qXmQoPNPucj1sG9m7R7S785/1Yk0aB0JcgvSEDanpf49
4vOpNnGTDS4HF9ZT6g54dYG5xT3yKgetIsMJ0c1W2bVpIr2vw+1RqNUByMBaAPth
2FuogdosY9cUcv+om9lxzJOPe6UIdmAoYxfWXsvfYwcdWbQ7Il7Ia3YphmvRu1zN
+b9zN+0CdE1O9IdYVOeBMUHZkhBdUDtKRYVT99YfKh+FtLhkP1mRbcUic2vcArPw
IZSwJ7LouU+B4XJJZRqak8ottLTpVNJ+AXYv41cOEDfDddF9jAEd0YH6HsH1IbV7
ehP6DNXeqwML1uZrGXAyv4aY7r8bS2TY4WJO36t3eYx91vODC2kwossYdua6yGBc
3DYyICH6VvHzXNyI0v/aqQoWzx3e3mbmwCIuEQwCLiHNeFWkVQvBVe2zabgdg3OH
fVrDx2wGQoGqaFsOpDKk5Wx3jsYkQf4ZBDrfJpfzk3iS2bsFM7njvR4XP5c6Kg7P
kVowyUDkEmjWky5n7/pyYf3y63ZhpfOgx3k0m9R8PS4mbe4mqXHoDKKxiGbOOf3g
HkYMheh6Un6uk8rihijBF7zOPNUpfTKjy8887cf156JL7VbnimPsdTMB4d/+aIpi
E/obsqFBRl13pD5qztTq
=D0lo
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
