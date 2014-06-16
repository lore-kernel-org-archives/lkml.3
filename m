Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbaFPVR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:17:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbaFPVR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:17:26 -0400
Date: Mon, 16 Jun 2014 14:17:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.94
Message-ID: <20140616211716.GA1807@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.94 kernel.

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

 Makefile                                       |    2 -
 arch/powerpc/Makefile                          |    4 ++-
 arch/powerpc/include/asm/ppc_asm.h             |    7 +++++-
 drivers/ata/ahci.c                             |    2 +
 drivers/net/ethernet/mellanox/mlx4/en_cq.c     |    1=20
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    6 -----
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h   |    1=20
 drivers/scsi/megaraid/megaraid_sas.h           |    1=20
 drivers/scsi/megaraid/megaraid_sas_base.c      |    5 ++--
 drivers/staging/zram/zram_sysfs.c              |   21 ++++++++++++++-----
 kernel/auditsc.c                               |   27 ++++++++++++++++----=
-----
 net/ipv4/netfilter/nf_defrag_ipv4.c            |    5 ++--
 12 files changed, 53 insertions(+), 29 deletions(-)

Andy Lutomirski (1):
      auditsc: audit_krule mask accesses need bounds checking

Ben Collins (1):
      SCSI: megaraid: Use resource_size_t for PCI resources, not long

Chris Mason (1):
      mlx4_en: don't use napi_synchronize inside mlx4_en_netpoll

Florian Westphal (1):
      netfilter: ipv4: defrag: set local_df flag on defragmented skb

Greg Kroah-Hartman (1):
      Linux 3.4.94

Guenter Roeck (1):
      powerpc: Fix 64 bit builds with binutils 2.24

Jiang Liu (1):
      zram: protect sysfs handler from invalid memory access

J=E9r=F4me Carretero (1):
      ahci: Add Device ID for HighPoint RocketRaid 642L

Rashika Kheria (1):
      Staging: zram: Fix memory leak by refcount mismatch


--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTn17cAAoJEDjbvchgkmk+BUkP/0XgzIPS6uV2YlDv52U9EJRh
1ws7POfHjrCBZHJ73VWKkwLuPkTQEBFomoEPPs89Uq6zWBkm+fdRJB+iTPWboOGF
/T+ichAE6ysQnETZy1aiUeg/Tkhj8od6H6Pu/0djL4WCbV1M1v/TsYDfZ082qGHw
72hCor2zKXixqkPbIrCSVSdH/Wg2wgoxdMUu1+ZUlIN+oIm7mm9FnfCH2l+2e9fa
z5lXJ3JeqEsnvbMAYkuqJ+SiTSQTJYOvvB3a8tFuL96KqmsC4V22aCaXAxUk8QTs
Zh7WtnIQA4U0mXncpAWAZztw8xu9o/1TGCrAk9C+QzNuUPQS8gQV/6qgIAfnTuhZ
X5O94rsXlisUHGaoa+VQ7/qWF/pEOrmWRu61voP3lfs3MGuxf0zv9Lfq4fe9Yb+b
09VBd+0o0aphokrJakFsudIYpsaq0yUaIYU9DPLLdhXeRNimWV7K7wSLDxWRjsvN
cNSETsDt40zMLyPO29vdcUbnIYrG7jdpcx20su11AQa4yTO9LX6gPLHRWFPwxLCD
8D8Mrl4JvSGK05TrPd6S2L+Dz+wZ/cmRZayqbgCORE/aWQcEmDHS4vkQkjmxzswz
pXJWGObeYvUnc17LE+bnCAtn3VBN50Pl32SmSiNv8Y1G1SCM9L9VUNnpkabW2bSa
3wwU0yRV+6RAZkkc9UmC
=YgnD
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
