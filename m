Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbaA0U1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:27:15 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60310 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbaA0U1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:27:13 -0500
Date: Mon, 27 Jan 2014 20:27:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140127202709.GS11841@sirena.org.uk>
References: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
 <1390553044-11860-15-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w/cbcIkiD1zHilas"
Content-Disposition: inline
In-Reply-To: <1390553044-11860-15-git-send-email-geert@linux-m68k.org>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 14/14] spi: rspi: Add support for Quad and Dual SPI
 Transfers on QSPI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w/cbcIkiD1zHilas
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 24, 2014 at 09:44:04AM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>=20
> Add support for Quad and Dual SPI Transfers on the Renesas Quad Serial
> Peripheral Interface, as found in R-Car Gen2 SoCs like R-Car H2 (r8a7790)
> and R-Car M2 (r8a7791):

This looks fine but depends on the DT bindings patch so it'll need to
wait for that.

--w/cbcIkiD1zHilas
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5sEZAAoJELSic+t+oim9hAEP/RXF0qxwGhAlp4SAwP2QQZKH
6+WKys6IPShkR1QoQO7mpuigR3iY0eSKNtI5eapmKhgjMvU80EY6vjFG1k03Ryrg
XndUtr09mRxNWu4VPg5F0RPu6vxFrPAPXmX95KgmdOn4JwLbCI4oC7tmdmLfsNLw
bWjWgnutni0EWeejMinPwGd0nCzqkkfQLC3XrjNYD7N3ynrZSy6GRmTVjt4xlIMQ
hjE1mLiXGyAUwVH1Xk34AsHapBTz3TNXqMWdgemnZx5Q7ZekvnG/XjWkMyNutikK
/hl6CFYgOjIHHk0NpldB005t9EOfBjtt7uL+fv0lOIN0OrXSOKW4kuOdXgEXkIHI
kY84yHJsdhruNiw/GaFbMrldNZ6dvHLvqLaKpdeeu6A/VoTuTjIQT9dau4HTkyAT
Qf2jPDkILJ9PnV3YVAwAQRRWG3dkcPO2Pt2IvshhE3rJ+LoUbuWCK1+sdmQ19e/L
GrI1FVuBBq3EjViB0vIoiTEOjP3gzhnR7R1CwHvSKvaKopc2oEq5aLddMG9HZuup
GdnOZ+mZ8ml9qvC3uBHGe5w/WVLi09bjgIGQ1Uqr1+mg3kvIq0g+oQ4rtIPCPUMO
3VVQ1K4xXzMedUtVPLbX/viVp2apSwDtjOLGXFRVrtqdOU6gFKZYezwXjatixlT0
OVgOCM3Oe7WLUXYEgabI
=o2h4
-----END PGP SIGNATURE-----

--w/cbcIkiD1zHilas--
