Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaHKTBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:01:10 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58627 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbaHKTBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:01:06 -0400
Date: Mon, 11 Aug 2014 20:00:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140811190057.GM17528@sirena.org.uk>
References: <1407511775-26479-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1NsjvM78Wc2uYjy2"
Content-Disposition: inline
In-Reply-To: <1407511775-26479-1-git-send-email-geert+renesas@glider.be>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: dapm: Fix uninitialized variable in
 snd_soc_dapm_get_enum_double()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1NsjvM78Wc2uYjy2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 05:29:35PM +0200, Geert Uytterhoeven wrote:

> ---
> Is this correct? Please review.
>=20
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

BTW please remember to put the signoff *before* the --- otherwise it
gets discarded.

--1NsjvM78Wc2uYjy2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6RLmAAoJELSic+t+oim9WhEP/0VLO6NpCm9S3fWDvzoWCzcP
+C6ZKrWLHAD2ROuNn1OtZWanavx9/rBMsdmnp3x28/8j1ND5o27GpcEM2ZKIkqEV
0XTKrvkq9WcvzziH74bYFJxWkvP62aWzwupF5K9pLW0oPu2Fj9wGolCdb6fHAl8w
2PqXGOrngqDww7SfPFmOK6AJofa3H1KUSAlIB04n6Ak5WyeJGbBmvJIrxnUNVSEv
M0sSCGSlKdw+t1/3OC7ZGhRqLMzubB+CHXCGTI/uaMPu8RCcIN0qi7mAdDNRL/mJ
H2GbI+7q2ZEwWjZvdReFpOdXrGi2jN+fTKhQ13uwN20xfqJtL+hlejiQYllcOQ4N
rAzvDpJepuPs7pgnnqB3YAdvDlAuroqBoBFxperdJxFOAyab3UKVPDCthJ26/qdy
VTFTgjBU9Xk3knM2Il5RK8UMN1vXBWaz6wC8IRM3BL1s2c3mK92692bosA5ZEOGm
SpScvzQpiQGtYQA8g7mx71eQq5c8jeB8O2s1JQUXglSzwZFXKvtPbHOiQhQj0t+A
013cnjMVF91ryB+YSg98GwC3bnQNuPe8zUnHS2cig+DLSjhpAQ8wnldSrMcOzoof
Spvrux24WPcAIfshxZnDGd+YkqRUdmbL6S/B0ZN0YKr8Uiz7Q/GSpaYzYq4nmBMD
Hsdvzd14bPYKer7yNsFT
=ZZZb
-----END PGP SIGNATURE-----

--1NsjvM78Wc2uYjy2--
