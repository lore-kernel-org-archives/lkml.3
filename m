Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaBLPRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:17:09 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40837 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaBLPRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:17:06 -0500
Date: Wed, 12 Feb 2014 15:16:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Steve Twiss <stwiss.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Message-ID: <20140212151657.GS28112@sirena.org.uk>
References: <201402121239.s1CCdZpd014527@swsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gV1yUYniiDLxW66s"
Content-Disposition: inline
In-Reply-To: <201402121239.s1CCdZpd014527@swsrvapps-01.diasemi.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] regulator: da9063: Bug fix when setting max voltage
 on LDOs 5-11
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gV1yUYniiDLxW66s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2014 at 09:57:52AM +0000, Steve Twiss wrote:
> From: Steve Twiss <stwiss.opensource@diasemi.com>
>=20
> Bug fix to allow the setting of maximum voltage for certain LDOs.
>=20
> What the bug is:

Applied, thanks.  It's probably worth renaming the _BIAS macros when
doing the stylistic cleanups as it's not an obvious name for them - I'd
expect them to specify some sort of voltage offset.

--gV1yUYniiDLxW66s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+5BmAAoJELSic+t+oim9oaIP/0VZseGK6qmHzo10oihgaPK9
cdltZ2CSEPRFOvPkNDZuuHw4I7tvMpCNDCMRYFNipM7rPV8BkMhCm5KAzwXd2yUo
shUoPimrkZWixvM46b9ji80+irMusWu8JuYDUoDWZcIEXxfARNhqYM5li1gCkMvr
FrlS5XxBscYViFbam48kGBuHYz3n/vTJ4IieGQ0jA2irAwSzyxB+qePheRHJTwtY
xHoZSiLHSRo2n+EQsdQM8pTCGWuVHSkhTdsHnEBEJuFNt7OHkoIpKnygTGp5Pp37
LB1iLMO4aerOcs96eHivw/bwbCobi/jTrdvfTH5/fRY2SvXi0PI5xAc5IOrgSGIp
CnUZ2vBQ3+S503JJSchpQ5qwbiqlKl2TjCofjP7niHXnapYtKjVJN/Mk8UW8EJdt
xeMZUvr2pEvZZCPzKtzeLPSnGxySlMCdDdNKJpHgUz/TxF/iEH8b7J00N8NZJzG4
CoTe044FkZoYVnCWUkJpRkd7o+fP+cRLnGC3K/9OdsRHfSCotSp95vC4rNjGaUZw
+pnKN7ggvrznKAqNu+PcwdWunhWiymgF/fCrT1AZ+VNvH1/aA3iPVmRYF1HuXIg2
KcsvRpv4qzR0iDFsUlOuJemGs3Cks3Ly9ndJzGEXaSpgy6PH/Mzr0a3HV6xJ2a6z
JB+/AcOOZ9F0dXx5z7iN
=0hMK
-----END PGP SIGNATURE-----

--gV1yUYniiDLxW66s--
