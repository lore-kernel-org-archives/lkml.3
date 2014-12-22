Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbaLVMCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 07:02:52 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43776 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573AbaLVMCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 07:02:46 -0500
Date: Mon, 22 Dec 2014 12:02:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org
Message-ID: <20141222120224.GF17800@sirena.org.uk>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
 <1419196495-9626-27-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Il7n/DHsA0sMLmDu"
Content-Disposition: inline
In-Reply-To: <1419196495-9626-27-git-send-email-wsa@the-dreams.de>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 26/28] ASoC: pxa: drop owner assignment from
 platform_drivers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Il7n/DHsA0sMLmDu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 21, 2014 at 10:14:47PM +0100, Wolfram Sang wrote:
> This platform_driver does not need to set an owner, it will be populated by the
> driver core.

Applied, thanks.

--Il7n/DHsA0sMLmDu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmAhPAAoJECTWi3JdVIfQyx8H/2O0X8TpMNyaEo+Ek+COW0/w
bPmORMs8j+IRVIBct9gNlsnjPg3RKStb8/M8gklrSauVnV2R5VLE8e7yzZqWN+Tv
vsMp1nijA0S7ydUKfCotRf1esoGk5K8Cqrg6cDMRQMJeoyNo4HoxaajZs76OC03s
0Mgz1OXUqBt4k+balFUIAu67a5Q+HtROMu9J4OdW9Zs8txGNpQ+Hg0RIQTZknKZE
BW0NOJzEOIUQO6ds8DK0D6GcS2qJfAqkWLH9j32S5P38aokped2XWtkxDghcrnRi
uIfARcLztkTj6kY5tXRY+DPDENnNUFf168S6fT2OP/zCCcj6U6tNwS+QvzQg15U=
=8GOH
-----END PGP SIGNATURE-----

--Il7n/DHsA0sMLmDu--
