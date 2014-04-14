Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbaDNS6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:58:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48912 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031AbaDNS52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:57:28 -0400
Date: Mon, 14 Apr 2014 12:00:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.1
Message-ID: <20140414190026.GA25347@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.1 kernel.

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

 Makefile                                   |    2=20
 arch/arc/boot/dts/nsimosci.dts             |   12 ++-
 arch/arc/configs/nsimosci_defconfig        |    1=20
 arch/m68k/Kconfig                          |    1=20
 arch/s390/Kconfig                          |    1=20
 arch/x86/crypto/ghash-clmulni-intel_asm.S  |   29 --------
 arch/x86/crypto/ghash-clmulni-intel_glue.c |   14 +++-
 arch/x86/include/asm/efi.h                 |    3=20
 arch/x86/include/asm/pgtable_types.h       |    2=20
 arch/x86/mm/pageattr.c                     |   44 +++++++++---
 arch/x86/platform/efi/efi.c                |   99 ++++++++++++++++++++++--=
-----
 arch/x86/platform/efi/efi_32.c             |    7 +-
 arch/x86/platform/efi/efi_64.c             |   32 ++++++++-
 drivers/isdn/isdnloop/isdnloop.c           |   23 ++++--
 drivers/net/ethernet/cadence/at91_ether.c  |    3=20
 drivers/net/ethernet/sfc/ef10.c            |    7 ++
 drivers/net/ethernet/sfc/efx.c             |    3=20
 drivers/net/vxlan.c                        |    6 +
 drivers/net/wireless/iwlwifi/mvm/rs.c      |   36 +++++-----
 drivers/net/xen-netback/common.h           |    5 +
 drivers/net/xen-netback/interface.c        |   11 +++
 drivers/net/xen-netback/netback.c          |   49 ++++++++++++--
 include/linux/futex.h                      |    4 +
 init/Kconfig                               |    7 ++
 kernel/futex.c                             |   42 ++++++++----
 lib/nlattr.c                               |   10 ++
 net/ipv6/icmp.c                            |    2=20
 net/ipv6/ip6_output.c                      |    4 -
 net/ipv6/mcast.c                           |   11 +--
 net/ipv6/ping.c                            |    4 -
 net/rds/iw.c                               |    3=20
 security/selinux/hooks.c                   |   36 +++++++---
 sound/pci/hda/hda_intel.c                  |    4 -
 33 files changed, 369 insertions(+), 148 deletions(-)

Ard Biesheuvel (1):
      crypto: ghash-clmulni-intel - use C implementation for setkey()

Borislav Petkov (2):
      x86, pageattr: Export page unmapping interface
      x86/efi: Make efi virtual runtime map passing more robust

Dan Carpenter (1):
      isdnloop: several buffer overflows

Daniel Pieczko (1):
      Call efx_set_channels() before efx->type->dimension_resources()

Eyal Shapira (1):
      iwlwifi: mvm: rs: fix search cycle rules

Finn Thain (1):
      m68k: Skip futex_atomic_cmpxchg_inatomic() test

Gilles Chanteperdrix (1):
      net/at91_ether: avoid NULL pointer dereference

Greg Kroah-Hartman (1):
      Linux 3.14.1

Hannes Frederic Sowa (1):
      ipv6: some ipv6 statistic counters failed to disable bh

Heiko Carstens (1):
      futex: Allow architectures to skip futex_atomic_cmpxchg_inatomic() te=
st

Linus Torvalds (1):
      futex: avoid race between requeue and wake

Mike Rapoport (1):
      net: vxlan: fix crash when interface is created with no group

Mischa Jonker (1):
      ARC: [nsimosci] Change .dts to use generic 8250 UART

Pablo Neira (1):
      netlink: don't compare the nul-termination in nla_strcmp

Paul Durrant (3):
      xen-netback: remove pointless clause from if statement
      xen-netback: worse-case estimate in xenvif_rx_action is underestimati=
ng
      xen-netback: BUG_ON in xenvif_rx_action() not catching overflow

Paul Moore (1):
      selinux: correctly label /proc inodes in use before the policy is loa=
ded

Sasha Levin (1):
      rds: prevent dereference of a NULL device in rds_iw_laddr_check

Takashi Iwai (1):
      Revert "ALSA: hda - Increment default stream numbers for AMD HDMI con=
trollers"

Vineet Gupta (1):
      ARC: [nsimosci] Unbork console

Wei Liu (1):
      xen-netback: disable rogue vif in kthread context

YOSHIFUJI Hideaki (1):
      isdnloop: Validate NUL-terminated strings from user.


--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTDBKAAoJEDjbvchgkmk+HNsP/il6dOg9mImk3XWr7Xksg/HM
jFUw7WlHxUpQcrJcaKxpdYbWxaYmWSy6jzH3FN2aQnrnydRzhxGT4hpQ6ogUwtWR
AOSoyYPI47c2zJAsDLLW0y0ToJ5sSmkt2FQjBpCU/aK7WZG1xPIEyI5Mh7NwvycY
vJRTlvebCwnIWC8MLUzvIn8ipZXv1BNE0PbWtglTRqyUx4jyCMcTlHkwv767xnD1
xtEbQjD8zRj3EwRhyuVCVBRt6kkkm/Ce1UF5h5OUh2LSlzsnViWyLkC8a73QpT0t
NaO+jkFhRZhxGBKqjdJr+HhgQ9hz4e3L6gbzGdap7830JbPIHDSWrr52NUShNGs6
9+HE1Bv//DomqTAbAZWtWp29O4mpCTdBkX13neHFlRr51Ezi7rOdXJSMGz4jyeas
4Zo853iDVpXwoezezW1vRG54ra+8EBqdKEOIGSDlX03kLArPgThCnl1hEHUOwgqL
Edsedy2tnT+euN5D/y1FEEiRrLJ9MW82b+mAXbAGD1kWg/DDTpzJUden/BRgbwOp
k+W9han0tfOpA7ZZHDOPqA3D1Q14MKIRvLlxBrwIDbcDmTQ5nJqYJfED+PVHhHIu
8/W+Jkb4SE66/tozDrwPr6OR+sJjHzjEKyLfbTfm1xR7ADTckln/b8EnXC+kGapV
4KKgkerFvdbTS9Bf2pmn
=mQZ2
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
