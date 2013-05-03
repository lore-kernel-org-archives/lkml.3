Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762785Ab3ECIa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 04:30:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34070 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762526Ab3ECIaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 04:30:55 -0400
Date: Fri, 3 May 2013 09:30:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Marek Belisko <marek.belisko@gmail.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de, zonque@gmail.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@streamunlimited.com>
Message-ID: <20130503083015.GF4945@sirena.org.uk>
References: <1367559456-20208-1-git-send-email-marek.belisko@streamunlimited.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FoLtEtfbNGMjfgrs"
Content-Disposition: inline
In-Reply-To: <1367559456-20208-1-git-send-email-marek.belisko@streamunlimited.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: McASP: Fix receive clock polarity in DAIFMT_NB_NF
 mode.
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FoLtEtfbNGMjfgrs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 03, 2013 at 07:37:36AM +0200, Marek Belisko wrote:
> According documentation bit ACLKRPOL is set to 0 (receiver samples data
> on falling edge) and when set to 1 (receiver samples data on rising edge).

Applied, thanks.

--FoLtEtfbNGMjfgrs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRg3WUAAoJELSic+t+oim9iXEP/10GJesDmFRXlzzdmtB1JDYy
WMaP4gwQOqPJRg1HIbp97A0d4XEK29lhnbSGN0428WTZk96scSzgtunXN0dFdV5c
WopOHUS/YcXlFGp9I2KYAzH1S8BbnRhkUN1rD0EWC2PUEj2tQc637zRntKh77S/y
WYbt6dRUNzihLZpO+WVqzlcKNyqZaeagFiuxcClpunXwok0NwjaV9r0KNxkD3JK/
dgfrOIzbHZUWCwJcuo6k3q1d24NPjH7yjByDRJKguLYmYYNuLbA0VZaxv0aaReEL
+ba7XKJUWDUCEybcpsElbzdTggJ8uVOsLW0vC93JWVPeBeJn1Oebol6iez92TbdM
kPjy3ng8Xcuo50Ve1fL70aRHiOuKaQI9FagiecK/e3YMJECjHoUwITD/wx6zm86g
I3seGNRR3EpisoIa5w598mOwkKxO/Rw92PQcT4kfGmeuzX8f4p0bR6mtZR9BQfS9
Y7Hpty6EZfiZIX/t3bjJaR549rerON9Ar6SyfOnALqt89o0bYk2wLMymQSQzijAq
SSIAV+HAZEU1jZ94+Yy2q5BY3w1fZA2xsBFNhWHg70H2isdn1ktttlzIbxS4t7EA
kxMbWoe9zPn6bXg7tCrypJ7u3hDEaa6Y2SeMiYgb8oDrd2E/FYytwmqKXTWhLDkU
Bp9XLSaauRJDjHl2mpDI
=62Tf
-----END PGP SIGNATURE-----

--FoLtEtfbNGMjfgrs--
