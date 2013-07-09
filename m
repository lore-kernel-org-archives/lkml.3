Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252Ab3GIV6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 17:58:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46595 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3GIV6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 17:58:02 -0400
Date: Tue, 9 Jul 2013 22:56:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org,
        Mike Frysinger <vapier@gentoo.org>
Message-ID: <20130709215657.GB3179@sirena.org.uk>
References: <1369190195-14598-1-git-send-email-swarren@wwwdotorg.org>
 <1369190195-14598-2-git-send-email-swarren@wwwdotorg.org>
 <51DC3078.5090602@monstr.eu>
 <20130709214910.GA3179@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tsOsTdHNUZQcU9Ye"
Content-Disposition: inline
In-Reply-To: <20130709214910.GA3179@sirena.org.uk>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] spi: convert drivers to use bits_per_word_mask
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 09, 2013 at 10:49:10PM +0100, Mark Brown wrote:
> On Tue, Jul 09, 2013 at 05:47:04PM +0200, Michal Simek wrote:
>=20
> > Probably the best solution is just revert this part of patch.
> > Mark: What do you think?
>=20
> We should make it so that the user does not need to supply empty
> functions if none are needed.

=2E..though this is stuff that went to Linus in the merge window so as a
bug fix we should restore that function then for v3.12 we should do the
proper fix.

--tsOsTdHNUZQcU9Ye
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR3IcmAAoJELSic+t+oim9nWMP/3ITlUQEwNmT/5NH/E8Tk7au
OTul/6/3BTyoIlJdv0HljoXUUaExc5W4Fz0W4G8nG/GWlrdDm9ywPMBsrSEZkQWH
CQQva/gZvK0JbyDpQhZW8yBzVQUbqkynpNYIVVoBdhBCF7FTmvsckYMe7X2De9Sg
hiJv4jUVdMB7scyBzZ+oVWFyq5NTvhNxYYCn4/+tzUogm/fgXk786yXEZwu2aebD
uJF2jptNRm6nfcwQ/BNUICroxaje7CL2D/vO2s17ljCMhiNMwplyqyWctOvKgyzu
sEK8fqHF0U6lffUEQRaP+UaD0k6tPXFBZb521Yy+zLxvC/EWSOi4YckQh9SqTOTV
CDOkmxO1CNTsGDxhqQTb2C2fbPL6cR49/1ygP3ItgJNjTGPoKRvpMKvs8aaV4ZcY
bjVXX133kMw6ssfawg2/CfuOvJSAXXu0oBUtUfww3oGmIpF/fzgQDMFv/UHL00sD
I2ZX4WC1yZaCJgNpS5RtlqqNEXr2soTeO0jy5adCyrufxQTTHerx3HGBJ7PsTI8i
aSIwWS3ZQNrMuZjE66++OMEBbvKsFuDE994hKdp9FwgB+1SppB/OMz3geVhO9zlR
pzGnnWKuuAG4KKdOw6n29rHk66HZLB2A6LfK1cnddVLeEj7om/5Hy8kOiV5AyK4J
wcqnkbDugMwu4zUdyce3
=43kJ
-----END PGP SIGNATURE-----

--tsOsTdHNUZQcU9Ye--
