Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaHPViH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 17:38:07 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38965 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbaHPViD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 17:38:03 -0400
Date: Sat, 16 Aug 2014 14:14:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: mark.rutland@arm.com, robh+dt@kernel.org, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20140816131426.GG28623@sirena.org.uk>
References: <1405398183-31345-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1giRMj6yz/+FOIRq"
Content-Disposition: inline
In-Reply-To: <1405398183-31345-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.70.240
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv6 0/2] add DT endianness binding support for regmap
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1giRMj6yz/+FOIRq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 15, 2014 at 12:23:01PM +0800, Xiubo Li wrote:
> Changes in V6:
> - there is some mistake for V5 patch series, resend it.

Applied both, thanks.

--1giRMj6yz/+FOIRq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT71kvAAoJELSic+t+oim9c4gP/2DgyOxg9YcFp4sBcIEWYGBQ
0aFROxj2XqXv86AAVp+0NwIx6CCu/UsU2ns6ueB3aq8IRSROv8AXzTEA52jLxUMg
LBPIUiJy5zj4FkyeHLuOPKYRG7wAXpY7sMZWKVFsFmNizmP3bg4D3eqLBl+wNeHX
n2D4/Tcllnw8Ofeg3Mz7v2vDugNiRSHN06RlaqYpYmSE+GX8FbCPn4Xq5tmOEHCd
lOrE2HasiSfc+ePNDNid47VB8git2Zd/Eb+Hwy68V5w9esOyu4OlQ2BAU6Wi+arF
YktgrrYimlAde1oKpJKbHhOXSWytB9LaC9zdRMzalRvFFHjeNSeCqtlFhGu5UJHP
zYhiOlatGGPndoFiRtNH9KyFWBxd9gbLRhwTP9h5LrpWgWR7I70AAinGP1WK9JDo
htprE/pUdwM2QTJWMSN9dBFNOAlAB3KraZ6mvSAtlODHZisr/NJn0CJCwoqLevTG
SG6OG8bjT4GBQBRVwGkEJaHf3i5Wl/EZNyfwCFzwQzdlaH4e34cWJAeFycqS8RYm
eJ0Afba6iUtEtUGnx7TLCTq1ebmkrWbwX1W+FfsDf93nIO3kaLg3TeRINHKOJua/
qlZOeFqdqreirTW3dfBvbXXk0hGYsqUmFutp3xhzCgqA50NLfSJkezlvAhJPf5jL
d5GLLLoqVDu8c0bDAPQy
=0EHa
-----END PGP SIGNATURE-----

--1giRMj6yz/+FOIRq--
