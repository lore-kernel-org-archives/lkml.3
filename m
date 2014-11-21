Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaKUTBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:01:00 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34068 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaKUTA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:00:59 -0500
Date: Fri, 21 Nov 2014 18:58:56 +0000
From: Mark Brown <broonie@kernel.org>
To: Andreas Ruprecht <rupran@einserver.de>
Cc: Heiko Stuebner <heiko@sntech.de>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141121185856.GJ3815@sirena.org.uk>
References: <1416594913-30187-1-git-send-email-rupran@einserver.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3/wSlNRiBFY7h6fz"
Content-Disposition: inline
In-Reply-To: <1416594913-30187-1-git-send-email-rupran@einserver.de>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: rockchip: i2s: Add dependency to I2S device driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3/wSlNRiBFY7h6fz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2014 at 07:35:13PM +0100, Andreas Ruprecht wrote:
> Currently, CONFIG_SND_SOC_ROCKCHIP_I2S could also be selected
> without having CONFIG_SND_SOC_ROCKCHIP enabled.
>=20
> As this makes no sense (and breaks the build, when the option
> CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM - which would be selected by
> CONFIG_SND_SOC_ROCKCHIP - is not enabled), a Kconfig dependency
> is added to CONFIG_SND_SOC_ROCKCHIP_I2S. This will make the item
> visible only if CONFIG_SND_SOC_ROCKCHIP is enabled.

This doesn't seem like an obvious fix - why is the fix not to put the
select on the I2S driver (which is the thing that actually depends on
the dmaengine stuff)? =20

--3/wSlNRiBFY7h6fz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUb4twAAoJECTWi3JdVIfQrQYH/11BKDB5c4u0DcCrYsBIZO4S
9T9+RSlxKXw+31lHTA5VAcZMdcWM09wscUrp6et0diNWxowxRQwnB2wIYbX8pJmG
pvaCEM/JFyqX3RRoMu2bE6eqrIMBnvOSzv2oc38w69tsJt9Xt2lYb7CU0pP+Lpsr
kS/c5gfRAYq6XIqvojsQ1Ub0IqIacIsnz1m2Sx1OyWOpHSGXD2hLKa6GUQdxGKml
9YeLMHxioWz62fHl4NhYZSLv4DRDh1YwKsKzM93b3FSwXiqZnv+1rI+fEJryLtg/
YTcAQkLMtv9Qk1WHy0v2Y5pwruhi4RUKjM7iIpIVs8qUzzQvyH0bJURUe98+NHY=
=zAV7
-----END PGP SIGNATURE-----

--3/wSlNRiBFY7h6fz--
