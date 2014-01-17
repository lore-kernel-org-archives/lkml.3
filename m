Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbaAQS6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 13:58:00 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56136 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbaAQS55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 13:57:57 -0500
Date: Fri, 17 Jan 2014 18:57:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Arun Shamanna Lakshmi <aruns@nvidia.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Songhee Baek <sbaek@nvidia.com>
Message-ID: <20140117185747.GI17314@sirena.org.uk>
References: <1389819796-12858-1-git-send-email-aruns@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hy6Wd/+xmQCqA1QQ"
Content-Disposition: inline
In-Reply-To: <1389819796-12858-1-git-send-email-aruns@nvidia.com>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: dapm: Fix double prefix addition
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Hy6Wd/+xmQCqA1QQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 15, 2014 at 01:03:16PM -0800, Arun Shamanna Lakshmi wrote:
> The prefix for the codec driver can be used during dual identical
> codec usecases. However, dapm adds prefix twice for codec DAI widget
> in snd_soc_dapm_add_route API.
>=20
> This change is to avoid double prefix addition for codec DAI widget
> and is needed while using identical dual codecs.

Well, it's just a cosmetic thing so it's not *needed* per se but anyway.
Applied, thanks.

--Hy6Wd/+xmQCqA1QQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS2X0oAAoJELSic+t+oim96d8P/1O+PSeuDEQ50EnNEBS4G/xe
YXYexDLAHURgNh67gPRymixAyaxsiIC1CzHREPF7m/5eiOsjZxSU6Jic1j0Hkljk
BWYe7w3g0bt0eK8ZRuOT5/VvB8zloTI7IV5hkOHa2mMEQwTDMaBbc2yQvZh/1XhN
OWcOgYiTLMO2T4iwEGvnc288j9Yvxsas+uF/sbf9mya0jP7lLaCSJv1XeiNwn25f
AZYTgz0jGBW3CqT8moRNEjCpeiZHDRe/6DLdhl4VWvs/OSHsR8YUDq864eJf7/od
6UwEkFqi6xgXuJrT3LOlSnxetZcm3wgdRoMLU1NyXUr94ekLX+mfhw61WpfwTSzP
nyIUTnhC6LyeWFw49x5m7hhWuDyXV+9KJNhFJcTdujwzK1H0YP9h9oc9vw8fP6Ay
DNM1pu7h2uMXFgaXYFKs43MPRLwNktP+eTjDtRGlnQpL8okLPRJazcfkfPqNsnJz
7EgCugY5GdQrFl8taY6IV0O36COqzqnUUdSb1GuowYPAfDZErJeWPp5yFhkRkjCu
hIf3tIVxPPnwnXdU+Ssy9IVVf5ZXahkQuNbAf72IqYD7JsxjVfuLz4uj/kyF9/4U
CQ+hW6SLGCDpagAoYQbcWEArQPUmDh7IMLFucUnfyj10d7AWK933fHskz0vGYmm7
nbMuVLrmVQVoVHN9SNyM
=p4Cf
-----END PGP SIGNATURE-----

--Hy6Wd/+xmQCqA1QQ--
