Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbaAVT0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:26:24 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58287 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbaAVT0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:26:07 -0500
Date: Wed, 22 Jan 2014 19:25:56 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: lgirdwood@gmail.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kuninori.morimoto.gx@renesas.com,
        Xiubo Li <Li.Xiubo@freescale.com>
Message-ID: <20140122192556.GW17314@sirena.org.uk>
References: <20140115113551.0eb13409@armhf>
 <20140115165141.3ab93dc1@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LGYlOP0sYR/qQmXe"
Content-Disposition: inline
In-Reply-To: <20140115165141.3ab93dc1@armhf>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 3/8] ASoC: simple-card: simplify code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LGYlOP0sYR/qQmXe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 15, 2014 at 04:51:41PM +0100, Jean-Francois Moine wrote:
> The OF pointers are put in the stack and then copied to the card
> descriptor.
> Put them directly at their right place.

Applied, thanks.

--LGYlOP0sYR/qQmXe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4BtBAAoJELSic+t+oim9nPUP/RSAZmjxhL/Gu0uife9qVGX5
QjkqcsKUo/27AgtA3/8fQOYSqqhZ5uqVhImTqC7rhxmU5BZhv8Z+q61/QlUXPG70
LSoNJuNCZqDIp+nX2N3Kfv78mpgx+OfvsMgcnBBGXIEpPGZkOhN/D7c2+sr5VKCE
+wseHYQSzxJ7+STRziSCmzoY3hQ83j+5W8k9cL+wtsEUvsadPgd4BsvjivMMlp5u
h9DWlLFBnaxeXBXsNvI52DLtzKIa/UvMWNID1THS96KXlZ7qGcf8hPIDC7N3aRDr
RHTCVyTFhcly32ckw2Z+6Y5Tl0fsUbx/iYTpjNSFkhYayFPSC99sbntIH9MzxoJi
Pezv2WP+X2/yTJTacW6mhGrL5BotMpuHemrj7AxDGJD4ehOTL+PKAil6pOHT7gIB
zpHzj+95i4d5G9IWZZdrVXnzaaZ1JKKXvzdDIknWJ+AMAhMb7Dac7Yt8k4b8Pl9S
G3lCESb/fSsLbFB970bOf9NZk5lNt+wGxhyciguAawC5GvjNnOYr6/XoYOgNGQ9m
uiuBJtfAtaMd233DtxVdLtEmz5KhTgUUltUnoFerKYRPeq/QRBCyReB+t8LCDeoz
wh92rX5GWaXyxkBYx6/4GLs05d9w0UkNCT7caUJl2nP76CZ69BfY9jhNXawPNIC9
JY3U92nBEfBhbKXQe26a
=x3jM
-----END PGP SIGNATURE-----

--LGYlOP0sYR/qQmXe--
