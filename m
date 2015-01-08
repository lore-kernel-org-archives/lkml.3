Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbbAHSRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:17:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44872 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510AbbAHSRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:17:06 -0500
Date: Thu, 8 Jan 2015 18:16:56 +0000
From: Mark Brown <broonie@kernel.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: sbkim73@samsung.com, lgirdwood@gmail.com, sameo@linux.intel.com,
        lee.jones@linaro.org, jonghwa3.lee@samsung.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Message-ID: <20150108181656.GS2634@sirena.org.uk>
References: <1420682647-6461-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZpBW6FMFksNodSH/"
Content-Disposition: inline
In-Reply-To: <1420682647-6461-1-git-send-email-cw00.choi@samsung.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: s2mps11: Fix wrong calculation of register
 offset
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZpBW6FMFksNodSH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 08, 2015 at 11:04:07AM +0900, Chanwoo Choi wrote:
> From: Jonghwa Lee <jonghwa3.lee@samsung.com>
>=20
> This patch adds missing registers('BUCK7_SW' & 'LDO29_CTRL'). Since BUCK7=
 has
> 1 more register (BUCK7_SW) than others, register offset should
> be added one more for which has bigger address than BUCK7 registers.

Applied, thanks.

--ZpBW6FMFksNodSH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUrsmXAAoJECTWi3JdVIfQOzcH/RnguTzGr4AuOyIfNYxt+S5y
ybPNJzFyjSPHaToC7qIQLioNYcFAcbh4WXNhZ/DK6vlKv+mSmcsGEzqsroha/9XS
XCpS4i2AjqwYEiYTJD/9ow+7JxMXUWIYNonV7TzoglCXQXHCa8kaTnkAF2Mkle4Q
fll+FEIzL5nLR1TQAAMhi0Tdyt2O/G62SckEbAczIBwos+qBfez4UG7xAY0xQmjV
zy6e1cNPWEsZgs+NGvdTEKEnJLOiCb49FQZyXYLk9kx3WjQ4N2Z9CJkTfPfYrGdu
poJRNz3GEUR2FgkqT3kIEV+pMa1cyDXeEpK68jCllvpKalQnwbffKNkttA1uBqs=
=PnbU
-----END PGP SIGNATURE-----

--ZpBW6FMFksNodSH/--
