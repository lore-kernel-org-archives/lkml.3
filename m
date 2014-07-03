Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbaGCO0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:26:40 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45017 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbaGCO0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:26:37 -0400
Date: Thu, 3 Jul 2014 15:26:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Keerthy J <j-keerthy@ti.com>,
        Tero Kristo <t-kristo@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-tegra@vger.kernel.org
Message-ID: <20140703142624.GD410@sirena.org.uk>
References: <1404143859-8160-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="89VDYHnQ8ukgENkm"
Content-Disposition: inline
In-Reply-To: <1404143859-8160-1-git-send-email-nm@ti.com>
X-Cookie: Semper Fi, dude.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2 0/6] regulator: palmas: cleanup and fixes
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--89VDYHnQ8ukgENkm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2014 at 10:57:33AM -0500, Nishanth Menon wrote:
> Hi,
> 	Original thread (v1): http://marc.info/?t=3D140380766500004&r=3D1&w=3D2
> This series is based on: git://git.kernel.org/pub/scm/linux/kernel/git/br=
oonie/regulator.git
> branch: topic/palmas (4c0c9ca Merge remote-tracking branch 'regulator/fix=
/palmas' into regulator-palmas)
>=20
> This series does a few cleanups to help ensure we dont make typo mistakes=
 and finally provides a fix as attempted by (v1).

Applied all, thanks.  Please fix your mailer to word wrap within
paragraphs.

--89VDYHnQ8ukgENkm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTtWgMAAoJELSic+t+oim9g4EP/1W5PW5hccjao2K24+M9yASp
ldBmwzIkqxif+uHWKCMAQdzUaXIebG8YOipWflG5U/gPJT4I4ZyqqHBGQ7WFUDF2
Dhyvj2tqn1X8oPrsfME9UJw2FGAtwJfegEBiOZx/5uTvul66AAGb/9VGiZH2rUt3
CA0hE3YhURYDq5kvH4GH4n0F7oaQ+37MdtoaHBF89P0wZ7fU7kJDj5i5icmNivml
IUluUk3nJ0cEmvW2NacmpL9iTSTEsRAOk4l1zeankF6t2WANIla2C0ovQu26H/Am
KbzLit6PN01WTVm3TRpOshosHqwkdVp9ftutjm0Kz6UF2/LByX8zk4YkzdUC9brr
Owpmeflhdy/7XHdF66bAs+59i48zE+G4H/PtZysYtF8RtYYpbyrOcSPO8fpN9fi6
Qc26jt3mu5odSQGzbT6pIz/oMSYR8v/VwtaBWtIsVf5eP3kryoOzsMLZE2U+4XlE
/4aHCokolHyaLwHZhwbTZ3DGaLp6NMhFvrQSKg5FXP6ZGW6y6453m6ujnuzjTL4A
MfB6kWcsHIZn+Vd2gPLK8OP2s4XHb9fmSkoPdGTdqtMSdcGlS/hphmdnHt5xOSGD
D3ssDI2jYC5ghXcNctvt82PsADN4zArI4IxqnfQa6Fgi8hwXwgTelGvgQqD0n8zA
5lDxQ1YigQ7prG0eJo7I
=zZ50
-----END PGP SIGNATURE-----

--89VDYHnQ8ukgENkm--
