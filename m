Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbbAGRbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:31:07 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41687 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbbAGRbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:31:05 -0500
Date: Wed, 7 Jan 2015 17:30:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Hisashi Nakamura <hisashi.nakamura.ak@renesas.com>,
        Yoshihiro Kaneko <ykaneko0929@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150107173049.GZ2634@sirena.org.uk>
References: <1420645045-18804-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EAECBqR2X0HbR9Ag"
Content-Disposition: inline
In-Reply-To: <1420645045-18804-1-git-send-email-geert+renesas@glider.be>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: sh-msiof: Use async pm_runtime_put() in
 sh_msiof_spi_setup()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EAECBqR2X0HbR9Ag
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 07, 2015 at 04:37:25PM +0100, Geert Uytterhoeven wrote:
> There's no need to use the synchronous version.
>=20
> Reported-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Fixes: 015760563ec77bf1 ("spi: sh-msiof: Add runtime PM lock in initializ=
ing")
> ---
> Please note that 015760563ec77bf1 is marked for stable.

Sure, but this is just an optimisation really.  Anyway, applied.

--EAECBqR2X0HbR9Ag
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUrW1JAAoJECTWi3JdVIfQzR8IAIVOuPgFmdD0C+2xKrd2u2CS
EZVtK41XVKtnDh94TXRc9txAt1b3avpiimtkZhRUBXM1WVOSuNsjD3maCdVPSOrH
DhREiOczbnN3ylmhSnDhvisjWXpwiscqma9Fi2M6Hb9v5Lzb5aUkchkzdYgZjQei
hqeO9KKxCcBfBCEmcJJ7oRQAYCTmGOtR9xmfFZAhYjmQiBuQezioHV56uTQHb1R9
rPDI+ogbC9tTwDrbZSLS+HtLXbaa2LG9MpNWcxKuT00mpoczMFwmwxCd5Rpxxrxa
baWneQO8FaZiv8R0ER7Gbcp9s9Vb1P+W+31JBD2Jtays/BCDTIwAPFyCSZ57KiE=
=0tJq
-----END PGP SIGNATURE-----

--EAECBqR2X0HbR9Ag--
