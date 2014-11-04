Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaKDEkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 23:40:24 -0500
Received: from ozlabs.org ([103.22.144.67]:52292 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbaKDEkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 23:40:21 -0500
Message-ID: <1415076009.24950.2.camel@concordia>
Subject: [git pull] Please pull mpe.git for-linus branch (for powerpc)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@lists.ozlabs.org, anton@samba.org, benh@kernel.crashing.org,
        ddstreet@ieee.org, fabf@skynet.be, hbathini@linux.vnet.ibm.com,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 04 Nov 2014 15:40:09 +1100
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-lxURpOgI59c/Jp7rc3vL"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lxURpOgI59c/Jp7rc3vL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Some more powerpc fixes if you please.

cheers


The following changes since commit d506aa68c23db708ad45ca8c17f0d7f5d7029a37=
:

  Merge branch 'for-linus' of git://git.kernel.dk/linux-block (2014-10-29 1=
1:57:10 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux.git for-linus

for you to fetch changes up to 10ccaf178b2b961d8bca252d647ed7ed8aae2a20:

  powerpc: use device_online/offline() instead of cpu_up/down() (2014-11-02=
 10:55:56 +1100)

----------------------------------------------------------------
Anton Blanchard (1):
      powerpc: do_notify_resume can be called with bad thread_info flags ar=
gument

Benjamin Herrenschmidt (1):
      powerpc/powernv: Properly fix LPC debugfs endianness

Dan Streetman (1):
      powerpc: use device_online/offline() instead of cpu_up/down()

Fabian Frederick (1):
      powerpc: Fix section mismatch warning

Hari Bathini (1):
      powerpc/fadump: Fix endianess issues in firmware assisted dump handli=
ng

 arch/powerpc/include/asm/fadump.h         |  52 +++++++-------
 arch/powerpc/kernel/entry_64.S            |   6 ++
 arch/powerpc/kernel/fadump.c              | 114 +++++++++++++++-----------=
----
 arch/powerpc/mm/init_32.c                 |   2 +-
 arch/powerpc/platforms/powernv/opal-lpc.c |  59 ++++++++++++++++
 arch/powerpc/platforms/pseries/dlpar.c    |   4 +-
 arch/powerpc/platforms/pseries/lpar.c     |  14 +++-
 7 files changed, 163 insertions(+), 88 deletions(-)



--=-lxURpOgI59c/Jp7rc3vL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJUWFiyAAoJEFHr6jzI4aWAYUcP/j3PuDVyuPnaJEag0GMn+cgZ
Q0KEXsT57hCQxHkILLGh3mkoXTaDQ7pOpUQjL485tP+6sVmPcGnfpXSLh8XPXzqx
yiZ2a4YIr8rPfXTIhf6cxlhAot2Dyyfmyfx1Zg1gsqPsansKMwygq9Ikt1zhL6h1
x4Q5meeVBi9eovKpebdYdRp57FybcWsrharlgPdRblitMZhtHLSGqbT5d200xdit
4Qk3kEbtsTocI/ieNiBZFlO9Q2d23Y2qTDrsMeurMOX8i0OdLp/h+FHkcH0e5bLU
uXV8HlPF2e/kKlrbasksFFPMt+pfbpm0CR3dbJ6hYeQT4xpk2doe2TlT4cC8ok2r
OoJeaWwVopJDvA+s4gozdrAM/X7Dpad31ODhCS2o/Kxs2KN0IFZnd7Jj86uTblAM
DvoZkZLCKG4LviaGb1kXIU+OP2oCVwGu/Pl6WbqglNvjeWEHAPdvMTla7taSgsR9
P58UMS+aA9r4LdzAqZ2+Or0Ad/wu3Wz8FEn0QrnJzLsdtgdQP9j89bg8toZ7ilpj
qvpOoTEpFuQB8ULSBB477sLiUczslFpDnOCtnGUbHd7gU0vT1J0bA3A3IsPB3c8x
j+3qbzMLyKKHLjoKgZ+PK/cF9hnClfTBWoOIivGXYyejrySoMBybH5uhAjw/QW+W
4F95/EjLNFSRev1XiZTA
=b6uG
-----END PGP SIGNATURE-----

--=-lxURpOgI59c/Jp7rc3vL--

