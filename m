Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbaIBSgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 14:36:35 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46905 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbaIBSgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 14:36:33 -0400
Date: Tue, 2 Sep 2014 19:36:17 +0100
From: Mark Brown <broonie@kernel.org>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140902183617.GD29327@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iaYIJ+kOC8t17Zqq"
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


--iaYIJ+kOC8t17Zqq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Changes since 20140901:

The akpm-current tree lost its conflict against Linus' tree and two
patches from it got applied.

Non-merge commits (relative to Linus' tree): 3078
 2790 files changed, 105584 insertions(+), 81173 deletions(-)

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

--iaYIJ+kOC8t17Zqq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBg4eAAoJELSic+t+oim9LdsP/jOxRP0JY+QwUZwB0vQDeJ1F
z1epalXIQCmuJZz87+zzOeTalZb1AWy+Fuh18iDWZBFuUva6vwM4SMqeQXAS2bDf
qMC/bdCTkI8aVT+6n22BzXYkmHDMRFMU/B2rJwtLw0UBZ8pNH+wC1T3+Xp3XyiAg
Nqnw+A5x9VvYPWmT1WgO8iGylp2iU0ULCd34LW7OdOADgBa0d9Cpa4orAYscJTLZ
ZD2q6r0ZXI0ai9ndUNFuHESWHD1awlqhYOJYqLshm20uSbR1X3vtSCRzezuxn/lN
VAf9H7/bv5Tz0OdQJlW8KTgF696c4bdo2nsMV0ANoxwzqSBAthxVPLAP20nfziLY
Fnx+2zKIGrBH867JO4xrb714YBqxO8gEkGzumeDykD7Ls9FXWTQakbYG73766zwN
1BPRk5G/ErixNkjKAqJM6BPMddCS0U/z70qNdHuumNYdZHTm2/yVET2Tsff4TBoi
kjIKJ/HKDTXmpBlO2+rVUdhWz68T1DDDCeF8zTsUQLB+nNhQTZ1NRohcb3JZLO8M
LerWlSHeeeNN3gie9+3nOQe9GDHhnl2C3vNqe33DV0GR+1TFhNQiFXoCYPPwGhxh
3JcgsaLQswurPvi5IyqMCEHWNG89Jhtrw1J6Cch5Q0hqnI0f6d+m7zwZFgR1cXPp
zSCOuX2C+kE61iu+5plW
=h1F6
-----END PGP SIGNATURE-----

--iaYIJ+kOC8t17Zqq--
