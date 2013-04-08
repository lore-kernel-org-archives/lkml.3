Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934543Ab3DHHyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 03:54:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42610 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934446Ab3DHHyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 03:54:11 -0400
Date: Mon, 8 Apr 2013 17:54:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Wolf <mjw@linux.vnet.ibm.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>, paulus@samba.org
Subject: [git pull] Please pull another powerpc fix
Message-Id: <20130408175402.8d12d92737b1722865db45d3@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__8_Apr_2013_17_54_02_+1000_+0rYtDrClgJo7Zpq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Apr_2013_17_54_02_+1000_+0rYtDrClgJo7Zpq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The following changes since commit 875b7679abbb232b584f2eec59fa6e45690dd6c4:

  Merge git://git.kernel.org/pub/scm/virt/kvm/kvm (2013-04-07 13:01:25 -070=
0)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/sfr/next-fixes.git tags/for=
-linus

for you to fetch changes up to 9fb2640159f9d4f5a2a9d60e490482d4cbecafdb:

  powerpc: pSeries_lpar_hpte_remove fails from Adjunct partition being perf=
ormed before the ANDCOND test (2013-04-08 15:19:09 +1000)

----------------------------------------------------------------
A single BUG_ON fix for a condition that could happen for machines with
certain hardware installed.

----------------------------------------------------------------
Michael Wolf (1):
      powerpc: pSeries_lpar_hpte_remove fails from Adjunct partition being =
performed before the ANDCOND test

 arch/powerpc/platforms/pseries/lpar.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__8_Apr_2013_17_54_02_+1000_+0rYtDrClgJo7Zpq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRYneaAAoJEECxmPOUX5FEjO8P/2GyzHtxbP+NaV77KyrTYMs3
sWs2fgPCB0Wuz06XhGy5FZEamii+nf9cSDQX82rC2L5AcMbFr5wBfs04/6wy2ViA
EzZ6LdN/o+FRs7HG0DTQdPtNtisAYNIp97BPZk926Tsp/pOUNgQLMR5L6Pwk37qP
cDc4VnerwG8u6KjqupsInKe8ZDsj3mAPMdOQ2qImEIQ8fs9AxCJJgXaZR2fSZ7Ux
fMOjqjw5lywdVw2wSUelgLFIQATITlWBGEpHtQPO327z+wEeq4yP7mRPferrMhfi
Cmy0WeeFC/lbMvm/P0RhQPkwsm/BA87lSzkuh9siEdXjpXiYDeVZ4phgR4kxM04E
zj2dy0ceT3huC2avj271X9tlLDXG72XnNQmu/kWi4vqtfiCnRBaYnXdzmCpdO+8s
mRkwlbjUu+6VuesFZNkqRd8m83rUrKXhqGhyTYlXRx9SWAq3PCt5YfiUCTpbx6Om
QrgyTcIJeiKpKplgbWc/0ic86hHMmFJwIXGCHXSmZVrIA/whqX32LzqtgWbdSod5
3ONs0TtfSG5BvVmhvPHogeeA4AYSuy+zLPW/7zYNLbDQNBw0jJU5PB8izkiyPHSq
yz4xVKmsGcDJDC9HIBdlix/IB5cdpWYGlwKNsLSFDhginlirliW6u1+ZUaOyQExP
LSbSGhFcGgPfZqsuwdVz
=WGP/
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Apr_2013_17_54_02_+1000_+0rYtDrClgJo7Zpq--
