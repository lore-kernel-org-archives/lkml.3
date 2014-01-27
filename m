Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaA0UCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:02:33 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60256 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbaA0UCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:02:31 -0500
Date: Mon, 27 Jan 2014 20:02:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140127200224.GC11841@sirena.org.uk>
References: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
 <1390553044-11860-2-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dy3pjCZLf6+6NySR"
Content-Disposition: inline
In-Reply-To: <1390553044-11860-2-git-send-email-geert@linux-m68k.org>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 01/14] spi: rspi: Remove unused mesg parameter from
 {send,receive}_pio()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dy3pjCZLf6+6NySR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 24, 2014 at 09:43:51AM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Applied, thanks.

--Dy3pjCZLf6+6NySR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5rtNAAoJELSic+t+oim9OzUQAIWghbso0r/bFpuruOLSQVGA
rzUT5d1qi4Vgfjw6hXCQKUd92gX/dDWwIBPx26/N2HxxCSkw0pGtDnq0UTfK2pCk
qgH/Uf38enzmJq+qHHiYqxHxqX1A1NbzOwgAFDKyrw+3AoQe4bC66ZNBQgMNq9y+
UT0r0+xJc0b/TNEXMY15dYAN9ZaT6GGCfI1ZGMLxFdrXZ6Z4Xm/uD7ZrGwX8bw0P
6OdV2dP78muLdLQXx9AujNLW1NIo0yTPCDxahYGjcPIgnvRx114M3/y/OIuoS1zC
kuo6Rj0Dzdn2uvNg1bVw1YAZsLSXuNtYRbXqMJ9v0AjncbuUP7JCOihPFJ8WN2Vx
eC6jJ1DojHX4gPHfoHUOTr9B1GnSOUyTIpefmrCd1K7s6a2//WGvhcw05uax1asG
1Jqt30t8BKwcMisWnkLEHipmzYi3CyjNdUVZFHfb8juoFwRDnkqS43n5l8ywO44z
yA5PGWAsguzmw91Sc39buT1NunWpPfoQybBFMwm/sZiGTlc5jAZsLMIi/iJS+UuA
Ij21qwfCuuuhWkXzTJ2Nu5cfWvHA9p1OGhyP+ipzXCU4NgsRXlh/DiHS5iH+6Gov
GBX2DNYSVxIuhw9ki1ReRat7hX0m/vzy0Yqhcl+S9jtEgglnb8lJBNeBTMM5qcR9
zchC78RsboxwaZWavnel
=mVJR
-----END PGP SIGNATURE-----

--Dy3pjCZLf6+6NySR--
