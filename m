Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab3LCPIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:08:19 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35496 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab3LCPIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:08:17 -0500
Date: Tue, 3 Dec 2013 15:07:55 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, alsa-devel@alsa-project.org
Message-ID: <20131203150755.GZ27568@sirena.org.uk>
References: <1386066427-6862-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IchZQccUbQrk8obU"
Content-Disposition: inline
In-Reply-To: <1386066427-6862-1-git-send-email-lee.jones@linaro.org>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: ux500_pcm: Differentiate between pdata and DT
 initialisation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IchZQccUbQrk8obU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 03, 2013 at 10:27:06AM +0000, Lee Jones wrote:
> If booting with full DT support (i.e. DMA too, the last piece of the
> puzzle), then we don't need to use the compatible_request_channel call
> back or require some of the historical bumph which probably isn't
> required by a platform data start-up now either. This will also be
> ripped out in upcoming commits.

Applied both, thanks.

--IchZQccUbQrk8obU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnfPIAAoJELSic+t+oim9LnAP/108kwuVEJ/gly3Yzp0R4R9m
8d6dKjeJLSRoD7Z86cHDpu9z+0REWDLN9rivdOFaFWdckBokLKz0mS+a5kWGTswr
oJqMtpeBTUtTMRdGGGKnFFK2FG9ygg8OgR9gbkytY0LdpLoGUSX3H97Z6UPZuN/O
DZppzk/9k6p6DKjz9gIxXOpxyRPXDMSeGK7a7YD571B4HwxNKNkNUTf4yK/uOmNE
zHLsVXvhAaYsihYy20n+3YbncTceNl0UmYOihu8WCivkjA7Gx/iSF8fJ84cShJwC
5JuAFDAi4ovgdLQukLUzqLdun7KenJDJ5rxjnUL29hTCEYnMHnIgOa5nQwBGWVqT
pO0cxYoPOxB5NRTEQN6+dODVDWsHu7uPQSROlgdyEpy4d2SjvlrNoclnoH7NQNEK
nKVPONovUCOXx8Hj+IrmW/W2kpSQkXOgJMauUfvwq18GxqGHJHaqo9JcrFDkFpwC
+OFKXLSvyDOvYp7KFzMjrEdpqKjgXeCG/XitjQyQZz/Cziiz9merk14IXVhKZy+L
NjrR+fQvykMCQGO+f5gGD6O1YA23svpoW4gLdUfZEDk5pVPwTm+ZXNITid8Nd20a
Qrojf85b1aEY4NNMNozjxxyamKbxHSnKi0a5WSVV2IRSrLlr9fo1bNlFTKNT3Z8u
GNPkfHh7cMFA5JPu+52c
=UArl
-----END PGP SIGNATURE-----

--IchZQccUbQrk8obU--
