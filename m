Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab3GPKSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 06:18:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35433 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab3GPKSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 06:18:03 -0400
Date: Tue, 16 Jul 2013 11:17:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Message-ID: <20130716101759.GH22506@sirena.org.uk>
References: <1373951411-8932-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N8ia4yKhAKKETby7"
Content-Disposition: inline
In-Reply-To: <1373951411-8932-1-git-send-email-festevam@gmail.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Provide __acquires/__releases annotations
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--N8ia4yKhAKKETby7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 16, 2013 at 02:10:11AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>=20
> Fix the following sparse warnings:

Applied, thanks.

--N8ia4yKhAKKETby7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5R3UAAoJELSic+t+oim9PIcP/3ZYqFep0fi3b4a+6W1lPgWY
IdUIcisxla98op3Izip+SGhfWSjwW/R88On4LWBRzVqs8TTWRriO2Yo+Jaid3B7G
gMCBqVCRZlsE2dZPeYY9sU4c3dS2ZN4KA1BNC03ZAddhrKjKeHfp+vMeicark6mc
pHkJaaRdfq/4zVzYdQdQBvOJmqVZ+XNtZ1MBcE8bT8DipfbEesBOhiWgF0BvsBk/
IOyahLDBqx3CKWoQhTe7XRW89xYe/uaemQmSehr5Q+JOnx4nUsyLGVxrVuHbRa+h
ZC+NQ+Lc6hyAEnZUdFPv0qjPPhEpGcbIlXfzNJJFl32jbN4r1BIIp7Lr3aBZmAit
ZXbbz1acuR07ioa9TfuXtWvfyRJR02Qk6m+WrT+ZKOfwJQ4h0nQkLfVWuN9CnnjZ
78uELgibcVIObWjvFcb+0UZl3cSEt702oVZen0qIG80AHSczi4pptlPU9cFXeQhd
hYFAEiKxD+wTFSkfizUy7vfqoA+4ZaYSnsK+N4hcjh9057dVSByQJiwqxUoDxkpo
kz1TCJ1KWHI0wlzSPEAcrnDGYR7ZqJLQXhJzWxlvXvX6Xf+3lXF3zXqx/nfPqJrM
Tux99pWfxSTyTsx1KMLpSECVi6Ol8nRl3HSsbTTey4jBW4QeXs9o2bkwHP6dhVsL
nwRs1JGupfv5ox29Pmu6
=aTUW
-----END PGP SIGNATURE-----

--N8ia4yKhAKKETby7--
