Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbaA0UL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:11:28 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60292 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbaA0ULZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:11:25 -0500
Date: Mon, 27 Jan 2014 20:11:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        devicetree@vger.kernel.org
Message-ID: <20140127201121.GO11841@sirena.org.uk>
References: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
 <1390553044-11860-14-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mgiPvHqStUXOBTSF"
Content-Disposition: inline
In-Reply-To: <1390553044-11860-14-git-send-email-geert@linux-m68k.org>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 13/14] spi: rspi: Add DT support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mgiPvHqStUXOBTSF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 24, 2014 at 09:44:03AM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>=20
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> Cc: devicetree@vger.kernel.org

This looks good modulo Mark's comment on the binding document.

--mgiPvHqStUXOBTSF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5r1mAAoJELSic+t+oim9LUIP/0bIGdCuE/AcP9uw7WR39WuR
YSwZY2QjijQ19m2tj3WN/oEtSkwZoIxmjUECl3bxBOzvaKUSCqXFZka4hTrHYT7p
yLhNQsTzLpI/yBud3gkqmbTuq5lwSKNFBv4EMYborzsbbkMFPF8rsZkpeCEixo45
2zOOE+lfNeK0mccxdKdSp4Jtrue3zzWFHgWUbmEAZFz3XmqKXs0XDCMAvKDnXq8z
eUk+cyPqOf3mpKh8UBoj+nL74H6ynTNOCEW/p4T9C0kKRM+R3heUdG3OrDLniy8n
c4vy1EbIixL3IyGE+wWbtoTb2a3QEfwhlOA1AHI1pX9C1uAtDBESISz3E+a5nCwW
5PUZtHhL59uc1TExNRlll3g6vKSkOuFFqnP4c2lraRlOpGaDdBLfZD+VQoPg1GKQ
ez2FTAto+H0hbeazRIY+B+IGbn5mS6Kaun/rKORKTjJSPAExjNkinTI1aYta9R5N
ZROfdJ3zNKGWihXSQJyhaG/vTTOiFBnkDVM7aGh389bTA4J9R8pCIRPTbXu+zwKQ
5F37V9H9TBRpxQy3Md58YrJT96QOHKuiEbxvUnXaeLo0BW+7PKJE3SskAx4EwqrW
vOnOg5Po9eLsZe4htOYuWRIJr4TRmKKkszHxZfCgZbwNk0g4rYhaD5igzpHJsXnb
8KvuykUFpwOcZQoOjJPN
=QbZm
-----END PGP SIGNATURE-----

--mgiPvHqStUXOBTSF--
