Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaLVMDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 07:03:23 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43792 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbaLVMDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 07:03:21 -0500
Date: Mon, 22 Dec 2014 12:02:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org
Message-ID: <20141222120253.GG17800@sirena.org.uk>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
 <1419196495-9626-28-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IuhbYIxU28t+Kd57"
Content-Disposition: inline
In-Reply-To: <1419196495-9626-28-git-send-email-wsa@the-dreams.de>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 27/28] ASoC: samsung: drop owner assignment from
 platform_drivers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IuhbYIxU28t+Kd57
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 21, 2014 at 10:14:48PM +0100, Wolfram Sang wrote:
> This platform_driver does not need to set an owner, it will be populated by the
> driver core.

Applied, thanks.

--IuhbYIxU28t+Kd57
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmAhsAAoJECTWi3JdVIfQvl4H/REH/n7ikDPfUntT1mGK2CNc
37tDsCjhuWiwDuJaoCJIe4dUg8HGZBphNeK3lEGFvd8iI2brHyLi+kwPmVzqI4wW
lfzzBr1eoLmZwMfU3wc0ExYyFt/2wBZtTkhVKmLdSSLXM5orzg3FdT0EX2P1qJyo
ZrbKVB/traPvjEhQUPBGFVkG6UfenisnhAPla9wjj/SCb/rRCl+WgltsYSwg3sZ4
l0KnkmvY3scXGHAfuHn12L+IeCEbX3pZWWYatdLAkx2HBbyT79y/OcxdFoGkBkUc
zhSM7rvFpkSPZTmnNDcMuOT7siL0DSNblV2K1BiIJajn8qTqxPEYIkda2swBAng=
=YOR6
-----END PGP SIGNATURE-----

--IuhbYIxU28t+Kd57--
