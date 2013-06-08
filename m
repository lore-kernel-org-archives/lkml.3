Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab3FHPwf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 11:52:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:55458 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab3FHPwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 11:52:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,828,1363158000"; 
   d="asc'?scan'208";a="252362285"
Date: Sat, 8 Jun 2013 20:43:18 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, djbw@fb.com
Subject: [GIT PULL] slave-dmaengine fixes
Message-ID: <20130608151318.GN23045@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please consider the follwing fixes for the slave-dmaengine.

Fix from Andy is for dmatest regression reported by Will and Rabin has fixed
runtime ref counting for st_dma40

The following changes since commit e4aa937ec75df0eea0bee03bffa3303ad36c986b:
  Linus Torvalds (1):
        Linux 3.10-rc3

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Andy Shevchenko (1):
      dmatest: do not allow to interrupt ongoing tests

Rabin Vincent (1):
      dmaengine: ste_dma40: fix pm runtime ref counting

 Documentation/dmatest.txt |    6 +++---
 drivers/dma/dmatest.c     |   45 +++++++++++++++++++++++------------------=
----
 drivers/dma/ste_dma40.c   |    8 +++++---
 3 files changed, 31 insertions(+), 28 deletions(-)

Thanks
~Vinod
--=20

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJRs0oOAAoJEHwUBw8lI4NHi0sQAKloS0BuXhBX/REhQBSU8dyz
HkmLJyZDpB5Q/Uc9QyaQxt5schEQxTTGWy0P1KDfQXx5N8mDiVkSUAx+jf8G0aXk
EvPgq+5uY0KKeySbppXECsfGV1GzdfQZDs1XViU9Qu66rPmcax8eXWch8CXxdO8e
Cc59hVb53ePSdEqTlfvZFgXThnziYVHSWICAZKl+o5RwCdqw9+R18buJ8NsAFZoh
FDoT4B/OCS7k1rMGMOV6SZUFWquJSZ6neNfwrlX1WSH2CNy4XeQNMiqaM0DZ8Mp7
OfShnygnnJNQdRRncN9V+7A9mgvcgNP/ccsELmorfNWYpYxf+k3CmZZEeFrLGAvH
vhBXT1AkCnNGDkwO9n8ic1r5V1JLb3LIM7uq+iq7EpOVGTqcnG9xAGeotb/wWCFt
bXab/CISCBQgH6H8TaB9i7DY+wDndAKYS8ko9Zd6qQgTJkNUlOzjcBKslW2n9HU4
bQQP9iGiOAzNjtvV+i5FC+H3plgQf3WR0bIftjI7e8VW4ybM8TLVgbNrhGn1yriT
RHBEajSXHFMdcwoBNY3LOvxQGBJAiEPIU1P581edEW/JmaHNz01pFDdQ7q0NqOpP
++77oKABb/YfBPFG0Z7F50jC3VN1a0W8xWXIkURymUeyv34LROV/St6HSiuBkOxO
b1FTgROwlN+1Hx9lGlHO
=LW06
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
