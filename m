Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaJ0RbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:31:11 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51483 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaJ0RbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:31:09 -0400
Date: Mon, 27 Oct 2014 17:30:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: b02247@freescale.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, alsa-devel@alsa-project.org,
        timur@tabi.org, Li.Xiubo@freescale.com, lgirdwood@gmail.com
Message-ID: <20141027173031.GA18557@sirena.org.uk>
References: <cover.1414193668.git.nicoleotsuka@gmail.com>
 <1414194502-14052-1-git-send-email-nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ds9maZbwT7uk2FVi"
Content-Disposition: inline
In-Reply-To: <1414194502-14052-1-git-send-email-nicoleotsuka@gmail.com>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl-asoc-card: Don't bypass settings if cpu-dai is
 Master
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ds9maZbwT7uk2FVi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2014 at 04:48:11PM -0700, Nicolin Chen wrote:
> When cpu-dai is the DAI Master (CBM_CFx), it may need some configurations,
> set_sysclk() call for eample, for cpu-dai side in the hw_params(), even if
> the set_bias_level() has already taken care of the codec-dai side.
>=20
> So this patch just simply adds an additional condition.

This was threaded with another patch series - did you intend to submit
this or did it get sent by accident?

--ds9maZbwT7uk2FVi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUToE2AAoJECTWi3JdVIfQTYkH/1COldDWplbfTUcsM/7aE54g
Z62JNqf6aaYMuFKyDAPXuXW6IC/KsSGLvj7eR1vT1sf4NUZSQ5qGf9LdJ4CCM//p
W/jVvoYIYSLT/erZw/t/r1QgPkmC/Vt2VdmzwqvM7cIafq5/M6drIoGru8fv4wE8
luR4Aq6Y+gqsVE8c9u6CMAumsXushHQUcDBgd0QoYVIGhuATLpV+PRVfUer9bWWg
vBjsU3KNaOU9CLOsa3tUTNoFLSSyOlUK6lcueySAkGpyvMyZ6kzhAszMDiz2m8/F
p58A6YUOX+SteJGXW2dc1sZW1a4sP0PIyM9xrCHJJRsBtRJtgC0bz/6NXB+EcBo=
=Ykv5
-----END PGP SIGNATURE-----

--ds9maZbwT7uk2FVi--
