Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbaFBOQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:16:57 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50963 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbaFBOQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:16:56 -0400
Date: Mon, 2 Jun 2014 15:15:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Balaji T K'" <balajitk@ti.com>
Message-ID: <20140602141502.GH31751@sirena.org.uk>
References: <000101cf7e2b$b5c9f9c0$215ded40$%han@samsung.com>
 <000301cf7e2c$2ec50b80$8c4f2280$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17/8oYur5Y32USnW"
Content-Disposition: inline
In-Reply-To: <000301cf7e2c$2ec50b80$8c4f2280$%han@samsung.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.170
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] regulator: pbias: remove unnecessary OOM messages
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17/8oYur5Y32USnW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2014 at 03:30:44PM +0900, Jingoo Han wrote:
> The site-specific OOM messages are unnecessary, because they
> duplicate the MM subsystem generic OOM message.

Applied, thanks.

--17/8oYur5Y32USnW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjIbjAAoJELSic+t+oim9QFQP/RJSrF9EBHj5UbZxj/iBt83z
OuWwYFNWMw1UBVasNupQjvqlANb8hluICg+AYMBL/vua1R4W1Eg2eMxBZORSP/ta
+63eCIFXFp5IrXwLinnIt+IV7bTqoZqj6iZ4j+1y4sujL5H1A2ABhGqw0Fr9MyXE
WhGcQc64t4T6j+wOPq3hM3qhyJa/w0S7iGf7htOhf/RAEM1G0W+L17HAwzEZfKuY
QmTpZYBy1OnX1Y+9G7GIUn2uMZmZI/ha+6utT2hPv5kscxz8M1YV3vLbxvlS42S5
1JzpkHuMhCY/16uRQIReiTu/rXAAhjZITx9Huvz4PxE/EUiUnZTjSd/L/JEIxFJZ
Qeu5rC9MsypNKleqKmxP2/W2RnLJ17i+SFUCv9jsTqZbFbEWL8Wk70pIIHuEau/C
cYJuq0mvd+34870hJao8A+n548+Td8U1JqedFdd/MSj1oBnohLbiBKfw5fYYC5da
vggk4FeJp98+C24hQ94ThIE17TROto6lhJlwK6QX3VkCSyRjQXFtrAozbTd0FACY
HnH0NUcgP9rA0XdBjgS3B50sMBFSaZ/VDR22iCCJfZlk1dL+3GPZcJjKK5EW9oP0
sd0bRX52Ql0uqIEvV4DN0jpmdNupPU8GcIkI6b6MVjYmJbNLPbJrRHAHz8z6SSV/
LAOqnxNN8JFol+Ajm51E
=BXdf
-----END PGP SIGNATURE-----

--17/8oYur5Y32USnW--
