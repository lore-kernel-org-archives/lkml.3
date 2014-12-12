Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966093AbaLLTaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 14:30:19 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57100 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581AbaLLTaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 14:30:16 -0500
Date: Fri, 12 Dec 2014 19:29:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <andrew.jackson@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141212192936.GT11764@sirena.org.uk>
References: <cover.1418372910.git.Andrew.Jackson@arm.com>
 <97f65b6037b9ac676f6ca7717a230a68cbe81fd1.1418372910.git.Andrew.Jackson@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ddlq+5wZogx8hGrT"
Content-Disposition: inline
In-Reply-To: <97f65b6037b9ac676f6ca7717a230a68cbe81fd1.1418372910.git.Andrew.Jackson@arm.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/6] ASoC: dwc: Remove unnecessary debug messages and
 tests
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ddlq+5wZogx8hGrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 12, 2014 at 09:25:00AM +0000, Andrew Jackson wrote:
> From: Andrew Jackson <Andrew.Jackson@arm.com>
>=20
> The devm_XXX allocation functions print a message on failure,
> so additional messages are not required.

Applied, thanks.

--ddlq+5wZogx8hGrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUi0IfAAoJECTWi3JdVIfQTDgIAIY5bDThEf6xA3UGvw2Sqov0
LLrnGf2Lgk8KnuNp3hZweTZzyHddqK3e0BF7rm0cSc83t31zc8sICmaLhlVuam7c
oLxxPtBFM7ej6TeGXQJQbB681bCoM2pIQuv1leS/GuKNhRb7XSCl/koKy3i7An4q
0rivYjI7wjoqUUV72QWEBlMzxp7rnfvywRWzJit0v/NN6NzrVvmkJAz1erZC6dkT
DoBeSHbGZca9xbweVJqMjXf7xSfwNVJtsVMAZD8mSGYMfrMF53x+Nn8Ud4dcXY8T
mMr0h405UvDyAEIG4uaYH7iek7OFk6+qzlNYfiBg5lclerDsUpxXRBqoRIJBgmQ=
=6kUA
-----END PGP SIGNATURE-----

--ddlq+5wZogx8hGrT--
