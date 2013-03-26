Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212Ab3CZCMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 22:12:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38187 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab3CZCML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 22:12:11 -0400
Date: Tue, 26 Mar 2013 13:11:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        Chen Gang <gang.chen@asianux.com>, Michael Neuling <mikey@neuling.org>
Subject: [git pull] Please pull some powerpc build fixes
Message-Id: <20130326131158.51bab1d55b2cda10ebc4ea4f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Mar_2013_13_11_58_+1100_C=79Lg3SB5UZW33g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Mar_2013_13_11_58_+1100_C=79Lg3SB5UZW33g
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The following changes since commit 3912a677f68f6084e0a7b6a1a29310ac1b083713:

  Merge tag 'pinctrl-fixes-for-v3.9' of git://git.kernel.org/pub/scm/linux/=
kernel/git/linusw/linux-pinctrl (2013-03-24 10:11:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfr/next-fixes.git tags/for=
-linus

for you to fetch changes up to f9294e989fa6f2990da155242db03cea1550cac8:

  powerpc: define the conditions where the ePAPR idle hcall can be supporte=
d (2013-03-26 08:47:27 +1100)

----------------------------------------------------------------
Just a couple of build fixes for powerpc all{mod,yes}config.

Submitted by me since BenH is on vacation.

----------------------------------------------------------------
Chen Gang (1):
      powerpc: make additional room in exception vector area

Stuart Yoder (1):
      powerpc: define the conditions where the ePAPR idle hcall can be supp=
orted

 arch/powerpc/kernel/epapr_paravirt.c |   6 ++
 arch/powerpc/kernel/exceptions-64s.S | 144 +++++++++++++++++--------------=
----
 2 files changed, 78 insertions(+), 72 deletions(-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__26_Mar_2013_13_11_58_+1100_C=79Lg3SB5UZW33g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRUQPuAAoJEECxmPOUX5FEA1AP/jvf8f6TA17rjGzV/R8YWVSR
das8OhXqzp537gsxi2ognn7HQT9cd4YBn49IQP6aDxTNP6xxsnR8AfdXfAWxrUhd
DWYDk4HssuNKNhyAK+UIqQkvGlc0AP0PBMBfah3YkfxVhbd0AnJ/DJ7CT0ALeE8g
sFJxqGk8LqzNy3w3XCGQR6+8eYVX1AhR++swQ6SbPu86BcSemoJaihl61HbMrEmj
/vxYDdcgs1eakH7C3j+3r8UG2eFGq5tvF/OmUuqxQ6zrKo3QMWp+ToKMoILkbTj2
5JCa0KuAXL8AePal+om2Gnomajcgf+Lmlt/9NEl9OHFPzwKl8bJ9vp0NWKfZUSl0
7QmYdOCbaetCzzmsX78jJZ1JHc3FjD9NbqbY1jEBgSigqg0mYLvxZTkJhyPLBvzW
5dHNvV78oR5hOsUPnNFBFYkDnK2ke9hZCqBckggS/Wrjfl5bU4+gazANEiXMqt+q
q8t5DGYsKYuHnffJ0tsYGrCH+wzSzAb62CsQ5pNxULJ/ICF1Xdxb62DOlum+8yG2
HaXYT8A196JIqNZp/rcLkFW2dD2nCa6SXx4QGHbFlBPs+a9ltfKozMFTy52A6NfE
POLgPTnr7FDZMY6CK5iXszFllc9YVxq9/2x6w2X19jo7NaFfBHVAuaFwAtozc6dO
QtKD8XB+7rt+1y2Nh8KR
=tWbN
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Mar_2013_13_11_58_+1100_C=79Lg3SB5UZW33g--
