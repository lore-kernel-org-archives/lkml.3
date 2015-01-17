Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbbAQOiy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 09:38:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:38429 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbbAQOiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 09:38:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,417,1418112000"; 
   d="asc'?scan'208";a="671547255"
Date: Sat, 17 Jan 2015 20:07:37 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, dma <dmaengine@vger.kernel.org>
Subject: [GIT PULL] dmaengine fixes
Message-ID: <20150117143737.GL15411@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Here is the dmaengine fixes request.

Please pull to receive two patches, first by Andy to fix dw dmac runtime pm
and second one by to fix the dmaengine headers in MAINTAINERS

The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

for you to fetch changes up to 6acf3998d2c7420b2deb2b475fa78ba7573c6162:

  dmaengine: dw: balance PM runtime calls (2015-01-13 23:07:58 +0530)

----------------------------------------------------------------
Andy Shevchenko (1):
      dmaengine: dw: balance PM runtime calls

Vinod Koul (1):
      MAINTAINERS: dmaengine: fix the header file for dmaengine

 MAINTAINERS               |    2 +-
 drivers/dma/dw/core.c     |    2 --
 drivers/dma/dw/platform.c |    5 +++++
 3 files changed, 6 insertions(+), 3 deletions(-)

--=20

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJUunOxAAoJEHwUBw8lI4NHDR8P+QETYK0FfxjTRR4VnnWtuHTc
s0YZl1YDxwARUVcK+9RG0OBDuZ1XPQTqz4SXBaukgPCqJQHt4f73RbA5yA1PM05S
Y6yQIewUxgEFZx4y70zgV5/SjgPcGA6P2HPJOZEDmkRindiUH3FxmFr1Lm+AaLpy
OHj1FpLPf1ueFv2zTTYj0O4WFHyCa+0Q0nkrPf0xsRjhg4Ll1iP9rTwsx5roMRd7
ygMAR4A2SlikkkjuvtCabp2dhv2hF16UnPGoJNzHFJLFO9B6FKLQBjvL2QkOqB0J
yE6/JWTBUf36WPggDLyrFi8TywTHlyEbnR+f3jrYiWB9YyA99ZhK4tvq6tDV9vWn
Lcc9CCNfL+vNkmGQnvCWweqkOzVIS+D+WkcoGk9ThwHJgq7FHrtNDjGe9iZ0kK67
5IJgzwFT67IU02AJp/pYzXkm6q1+tevfABVOiYlwJ0GLyndgw6AmqaikBkO0vI66
2UgjlvhM+CSktBdjIBbp4boOmQ4NMXnJguFtjyTGjjNXFfHYJXemwLkr/b0UQxcw
l2OeJWATSibNArd3pcS9kVJAZbspKWydFEvkGMhRKZQDrT8t+c3xtFazF1dA7spm
9qGchxXFe6Sl2BgdmHIwdImqrQVQIoX7z2nMBrUvOPYbKwmuMnWcXkaMOy/pIJwm
Jl3+vsfsHZAYINtmNgg5
=0y9C
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
