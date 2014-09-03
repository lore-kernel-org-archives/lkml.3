Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbaICTBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 15:01:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48686 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaICTBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 15:01:52 -0400
Date: Wed, 3 Sep 2014 20:01:45 +0100
From: Mark Brown <broonie@kernel.org>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140903190145.GD29327@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KXlsDDyIxzhAJBYd"
Content-Disposition: inline
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: linux-next: Tree for Sep 2
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KXlsDDyIxzhAJBYd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Changes since 20140902:

The akpm-current tree lost its conflict against Linus' tree and two
patches from it got applied.

Non-merge commits (relative to Linus' tree): 3475
 2949 files changed, 116735 insertions(+), 88213 deletions(-)

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git .
If you are tracking the linux-next tree using git, you should not use
git pull" to do so as that will try to merge the new linux-next release
with the old one.  You should use "git fetch" and checkout or reset to
the new master.

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with an
allmodconfig for x86_64 and a multi_v7_defconfig for arm.

Below is a summary of the state of the merge.

I am currently merging 214 trees (counting Linus' and 30 trees of patches
pending for Linus' tree).

Stats about the size of the tree over time can be seen at
http://neuling.org/linux-next-size.html .

Status of Stephen's local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

--KXlsDDyIxzhAJBYd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUB2WWAAoJELSic+t+oim9J3QP/33WshgX12ARgNL0Cm2e74nx
XHv/BWdMitfAxJTyHsoij9F76z41AS8rD3//x2TpBR02GwR4O2d0VevH/R4ySUiI
zx9B+8SlZhQ+n0ANIY3gfj6yla66iIQwYGvUAnq4BT/LrfWE8Y4oPZNN0Zdg3Mv1
j0e+nNLTUEgE8EAmQIEsdM2ez++M/VEv284gHYJAhQXD5r31aVAHBdYM6ikUiOgf
1NhhDeNiYWNMK4yuHWNs2dwQ8vjPw6rIJLxpw5JkzW1w3+f2kGh1s4SFkfkgQUzB
TvJercbtspHsJ+MzYn0b2BZqY3AASTmvhmenWnrGKxqq2U5Jo7ukDqe3AE9W/FK0
m3D5I71KVf7fRGaGHh6xRkje6ygTuV8lKBGdmLoluZHmdSlwkW8D0CPNz4cXtpTd
5v1HET+Kj6KI3TDrGBhJphN6mMzbOMWca/AXekhRvBWf+6WqNlkIBOz76XUAZ6C9
YxAxkhMipPd6XOL1Qrtyf8xEeF8RmFA43+fx/WGayZoD7QabalnK5lPovZT6aBBw
qS6DIwBorw8uQas+Y8UA9EmzZCiACYb/avBZMVTBRtmrTu395NO1jqFdR/DPsrD3
VU7IgivKxbuQgcvjEkKDSiBfhaCmA0h10Os5X5yYcDLDxkLebdw/MQ7Sddf/Cia+
vBCh/8am8BfcS5r1YAwb
=xO2T
-----END PGP SIGNATURE-----

--KXlsDDyIxzhAJBYd--
