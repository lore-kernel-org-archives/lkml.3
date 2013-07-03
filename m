Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885Ab3GCSRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:17:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab3GCSR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:17:28 -0400
Date: Wed, 3 Jul 2013 11:17:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.9.9
Message-ID: <20130703181727.GA3113@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.9.9 kernel.

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

 Makefile                                       |    2=20
 arch/arm/include/asm/cacheflush.h              |    4 -
 arch/arm/mm/flush.c                            |   33 +++++++++
 arch/arm/mm/nommu.c                            |    6 +
 arch/powerpc/platforms/pseries/eeh_pe.c        |    3=20
 arch/s390/kernel/ipl.c                         |    8 +-
 arch/s390/kernel/irq.c                         |   66 ++++++++++++++++++
 arch/s390/pci/pci.c                            |   33 ---------
 arch/x86/include/asm/irq_remapping.h           |    3=20
 arch/x86/kernel/early-quirks.c                 |   20 +++++
 crypto/algboss.c                               |   15 ++--
 crypto/api.c                                   |    6 -
 crypto/internal.h                              |    6 +
 drivers/ata/libata-acpi.c                      |   36 ++++++++++
 drivers/ata/libata-core.c                      |    2=20
 drivers/ata/libata.h                           |    2=20
 drivers/iommu/intel_irq_remapping.c            |   10 ++
 drivers/iommu/irq_remapping.c                  |    6 +
 drivers/iommu/irq_remapping.h                  |    2=20
 drivers/net/can/usb/usb_8dev.c                 |    5 +
 drivers/net/wan/dlci.c                         |   26 ++++++-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c  |    2=20
 drivers/net/wireless/iwlwifi/dvm/rxon.c        |    2=20
 drivers/net/wireless/rt2x00/rt2800lib.c        |   29 +++++---
 drivers/of/base.c                              |    4 -
 fs/exec.c                                      |   16 ++--
 fs/ubifs/dir.c                                 |   54 +++++++++++----
 kernel/events/hw_breakpoint.c                  |    6 -
 net/bluetooth/l2cap_core.c                     |    5 +
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    2=20
 net/mac80211/ieee80211_i.h                     |    4 -
 net/mac80211/mlme.c                            |   87 ++++++++++++++++++++=
++---
 net/mac80211/util.c                            |    6 -
 33 files changed, 395 insertions(+), 116 deletions(-)

Aaron Lu (1):
      libata-acpi: add back ACPI based hotplug functionality

Anderson Lizardo (1):
      Bluetooth: Fix crash in l2cap_build_cmd() with small MTU

Artem Bityutskiy (2):
      UBIFS: prepare to fix a horrid bug
      UBIFS: fix a horrid bug

Ben Hutchings (2):
      s390/pci: Implement IRQ functions if !PCI
      s390/irq: Only define synchronize_irq() on SMP

Gavin Shan (1):
      powerpc/eeh: Fix fetching bus for single-dev-PE

Greg Kroah-Hartman (1):
      Linux 3.9.9

Herbert Xu (1):
      crypto: algboss - Hold ref count on larval

Jaganath Kanakkassery (1):
      Bluetooth: Fix invalid length check in l2cap_information_rsp()

Johannes Berg (1):
      mac80211: work around broken APs not including HT info

Marc Kleine-Budde (1):
      can: usb_8dev: unregister netdev before free()ing

Michael Holzheu (1):
      s390/ipl: Fix FCP WWPN and LUN format strings for read

Neil Horman (1):
      iommu/vt-d: add quirk for broken interrupt remapping on 55XX chipsets

Nikolay Martynov (1):
      iwlwifi: dvm: fix chain noise calibration

Oleg Nesterov (2):
      hw_breakpoint: Fix cpu check in task_bp_pinned(cpu)
      hw_breakpoint: Use cpu_possible_mask in {reserve,release}_bp_slot()

Phil Oester (1):
      netfilter: nf_conntrack_ipv6: Plug sk_buff leak in fragment handling

Simon Baatz (2):
      ARM: 7755/1: handle user space mapped pages in flush_kernel_dcache_pa=
ge
      ARM: 7772/1: Fix missing flush_kernel_dcache_page() for noMMU

Stanislaw Gruszka (1):
      rt2800: fix RT5390 & RT3290 TX power settings regression

Stephane Eranian (1):
      perf: Disable monitoring on setuid processes for regular users

Sujith Manoharan (1):
      ath9k_htc: Handle IDLE state transition properly

Tang Yuantian (1):
      of/base: release the node correctly in of_parse_phandle_with_args()

Zefan Li (2):
      dlci: acquire rtnl_lock before calling __dev_get_by_name()
      dlci: validate the net device in dlci_del()


--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJR1Gq3AAoJEDjbvchgkmk+i8kQANZzz9JYozwXRpIkL1j4bjmk
U2tZRnvwB2c4DYx2ibhTooL8/LbweKJS0u6VzwCbXvnCB7A/rG/CYaLA0vrXNYmM
5+p9bTQ2akhPEVcRJXqGUJ9pcV1NU7+SfXum0a5pl98wvES2EPQSQMXjI0Pc6fn4
TcCKXe38cwnsvElcw5G+afvyePkFMY28vpXzDuTo+B0A/zfuF2oESBUYZbaskyKn
JEND80obiTxQ2eyEUwHhijk2UgsT3T1Iehf6FqrqTYm7ndoc/R65rAUdKQDSV52I
IdxFG5MM3qEK8zYGOEuV7TyvUygY9wBxA2SXtOCSIZZqJKDqN90+46RG2++sSDRf
mydtUf3XqCpFCUAU99TR3t4iUGdKCc3miRyckfH9aoFC6fZz69zUDPLzsEtW8PZV
iFGhetBqWBMlt3fYevduKRoaRRoB9w+eHDGh1toEUowDtd3QQntzJfMGybntDQ7q
l3p0RIyDApYuQskbstdaWS9CxX3KMT8qyhqlbTPOg9jm4YWcfISCQ9EGyEtwifOk
YwsBYlJJCg4i2Xpm2glQ/JHYIibTgMZAFQzmxVzf3W6KlI8qEl1L9MawMPo7vofG
1qeg4kjiK+OmGLY2ktF3mdzlt/NY47ECzFPikm1FqEh1eL3sH2cr6TkQvVV2cK1W
hlJZrn0FYoxbkhdYZrKs
=9zji
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
