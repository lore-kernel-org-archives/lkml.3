Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbaA0UDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:03:17 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60265 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbaA0UDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:03:14 -0500
Date: Mon, 27 Jan 2014 20:03:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140127200310.GF11841@sirena.org.uk>
References: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
 <1390553044-11860-5-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ULkDCyeHsmlwbqED"
Content-Disposition: inline
In-Reply-To: <1390553044-11860-5-git-send-email-geert@linux-m68k.org>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 04/14] spi: rspi: Add rspi_data_{out,in,out_in}() helpers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ULkDCyeHsmlwbqED
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 24, 2014 at 09:43:54AM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>=20
> Add helpers rspi_data_{out,in,out_in}() to write, read, or write and
> read data to/from the Data Register, taking care of waiting until data
> or space is available in the buffers.

Applied, thanks.

--ULkDCyeHsmlwbqED
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5rt7AAoJELSic+t+oim9FQQP/iomgH/DOOHk+sZBNJfQ2kpN
S+SbtJyr1h+z0914RyNkNj8SseM7oGAHl7JvGRE1XoIill7+LMNb++rAFSMk5ZIO
7HnAT6akH5YxLjg8c7rjJX+Sck7xwKQBw6iMZn1IV8dxLT7GwVd/QmDw+vB5ZW23
eV9ps1tx82sau6PCppgYQgJeZV0hYcGS7+FkaGY5NkNFocJ9Wqv0+Stj8gIpcKgc
5sQcmlogwDFTaRHkyJMjDaEbJ+Ptnm7FugS40UEX5C2pHLkIHz5/lDDV0Wejr04J
7faNl+j6XU+NBaYaxcpNWAOmuSeReGw0WLvHsTQ1jy0e4S0zJPGjIeE7WuvG+SO9
0NYYS5W+JcU/28Wrc5hnPzLbIVXaonwj1obRoPM/LHHXJs3xzcWE22jjRKHxUS/7
6QtUBW1NQmjjolc37RihNFlk1+Soanh5deb+Ug8No1Kh9lMyP+kqpi6ybYP+ISiG
B3X2GqiQHvvFbdBeItHUnKyECIXVuwZNdG0HRu/EIc/v1KxeoIGxAMgayZGX2n/D
Is7ImryNhzQRxKzeRTeaW+b5RH0jJnJUs378Wkw9vAIn9GGonCauk25oNOpbOI8q
r/GKOM8VRA9OlsYiD5a82Ckax8EdLXGmkv+edeE3bw5WiTG9mKmAWz7JrEZwgKO7
S0iIMY51Ma8M/YqBVP2j
=nH6z
-----END PGP SIGNATURE-----

--ULkDCyeHsmlwbqED--
