Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbaKXOGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:06:03 -0500
Received: from nef2.ens.fr ([129.199.96.40]:2796 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbaKXOGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:06:01 -0500
X-Greylist: delayed 3238 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Nov 2014 09:06:01 EST
Date: Mon, 24 Nov 2014 14:12:00 +0100
From: Nicolas George <george@nsup.org>
To: linux-kernel@vger.kernel.org
Subject: Using kernel filesystems as userland libraries
Message-ID: <20141124131200.GA28582@phare.normalesup.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (nef2.ens.fr [129.199.96.32]); Mon, 24 Nov 2014 14:12:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi.

With the libraries present in e2fsprogs, it is possible to open a plain file
(or any other reasonable storage) as an EXT2 filesystem and manipulate files
inside it.

Is it possible to use the implementations in the kernel to do the same thing
with any supported normal filesystem?

Obviously, it is theoretically possible, but my question is whether it has
been done in practice. I suppose it would require writing userland
replacement for the kernel APIs (memory management, access to block devices,
scheduling) and either rebuilding the kernel source as userland code or
loading the modules directly.

Regards,

--=20
  Nicolas George

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUcy6fAAoJEHGVSyPKTcYMz9sP/Aq17ejzogit8mqdVQ9XJ19l
oK335LOoMsUZ7lRMtaqZpuNk/m6y1HebStGPgjNVXxXHZ8f/y+GPZeWuJJy97P+E
h8CFuR+z+ZJoVkzDSJaUlNRCLRT3H8InqmM2sOB1oPLgiN4poRVEv3rdidc1L0h+
z2IvfKhm+Q97SqESi/epv26V4sRb3W1Ovs1xsXXnFMZVYxzMsnUfFr2s5v39zF5U
zlpKbLelbQtw2ZyB3zMVpi3K+lPuciphU//23tGM5W0nt8b2ohQaFEBLNIHUG9wf
8cIlmdrbH6GQGDW6E5WCQPLuhMchUOlYWKu5Y6cScCvDJtkU+wXaTR/rS+krymsH
QsaqUupytOdc3U+hmtDJdix1Ej6/8PIfwqLUR0JfpJVpXKzqVsrXGlrj8JnWKOOn
J7FPBZVVZJoPwbsoM9tRF+DrDJD8Ghdge0JjR9i3t6pA+xelkSmg34jDpQKz4kUl
Dzn0CB+Km3yyCwRzE19As075WsVHHwKvTWGcESAP7oi0kBM2e6ekHSVTFTdtwig+
Kz+bMGuWXRMRFjOtITKoetQuqPcpJTcTZLUmhHFLLRXbHM1d78KjGMeeoDKYfEYM
VckpSvwAI7H4rir4+h6WWAROoivoG5jextWqwBm6oWMt7XL3T5q9xG4H9fsx6Go/
n9tKSfddcbO1JDBz/Uls
=1tW0
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
