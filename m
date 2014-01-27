Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbaA0UEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:04:16 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60271 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966AbaA0UEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:04:11 -0500
Date: Mon, 27 Jan 2014 20:04:07 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140127200407.GH11841@sirena.org.uk>
References: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
 <1390553044-11860-7-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XyBMaHrM0hrbbr/O"
Content-Disposition: inline
In-Reply-To: <1390553044-11860-7-git-send-email-geert@linux-m68k.org>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 06/14] spi: rspi: Merge rspi_send_pio() and
 rspi_receive_pio()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XyBMaHrM0hrbbr/O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 24, 2014 at 09:43:56AM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>=20
> rspi_send_pio() and rspi_receive_pio() are very similar:
>   - the former only sends data, using TX Only Mode,
>   - the latter sends and receives full duplex data to/from the hardware,
>     but uses dummy transmit data.
> Merge them into rspi_transfer_out_in(), now supporting full duplex if
> needed.

Applied, thanks.

--XyBMaHrM0hrbbr/O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5ru0AAoJELSic+t+oim94QkP/RsQrcl8qsEkVB+FjlnlwqkS
iI3jsXQMZXgrTRxz7EhbcWMGjpimZB/4cuKhNYEwIi8NIjwjs31k4YEySPyY5OMR
kkLU+3q4aA78NT3it8ZSsZJx5O2sKekP43Q0ty9E79HTicapJ23E3m3ICmwFa8Kn
k/AGG7IoA8FnzC4U1nW0VgfqikArPLcSpFDnrfgIIeZS82q6rwdwrkdcXK+c/YLm
sPW9v/uIN5KgFD8eDIej4uUA1y6MC1/AQpGYpQRzdGUkWxPzX7WrpmrVtJNqsnHH
4a6N0/7+5UtLC1uUVGVXFM/N8+iWsyiQYjvBGdnmZwUrL7gzS80QLD7IlEt6h2NK
irT5ahuUQE9QYyqV4Ymec4KpGdXVQsJxBx9K11ms5WmZmMGnSqEJgqFTKsnyc8tA
hbGbrl9WlpKbILDB/EddjRiPG1Xvfru+uW/d47fgweyNTWmRjBHAW1JErmtkO8IA
BWzRKv2Ao4oA1In0n4/eIRqQweyYJR/t+KtaYsCPTjrYnNoR0P6nUKoBIfsmnWvy
Mf+UseqSME4M2CzsH8afwtGtn69zVmfsf3aXeq/IukH8sORLMHW9N3OTnKYH9yLU
LuRGf/U+YJcjvNgp0m3xBx7Keg2X55szmTmG7CCvN03YzAcljGmduZBdCfr9DR3S
5V0yhp2yDLQkB6Q8xXXF
=O7Zi
-----END PGP SIGNATURE-----

--XyBMaHrM0hrbbr/O--
