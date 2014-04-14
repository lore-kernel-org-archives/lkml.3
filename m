Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbaDNToy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:44:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:32862 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaDNTow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:44:52 -0400
Date: Mon, 14 Apr 2014 20:44:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Steven Miao <realmz6@kernel.org>
Cc: adi-buildroot-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Steven Miao <realmz6@gmail.com>
Message-ID: <20140414194439.GO25182@sirena.org.uk>
References: <1397265804-3018-1-git-send-email-realmz6@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3snK74p7ddXn3Qrx"
Content-Disposition: inline
In-Reply-To: <1397265804-3018-1-git-send-email-realmz6@kernel.org>
X-Cookie: Are we THERE yet?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: bfin5xx: fix build error
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3snK74p7ddXn3Qrx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 12, 2014 at 09:23:24AM +0800, Steven Miao wrote:
> From: Steven Miao <realmz6@gmail.com>
>=20
> should include linux/gpio.h

Applied, thanks.

--3snK74p7ddXn3Qrx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTDqkAAoJELSic+t+oim9t3cQAIMstrDqYMXMC/rjq3KlVrCg
FOlOGcGOUrheb8+ShkOaXKPrSd8qWHR3lQzzZYTaJYQVwP+YwUHYA3aUiH1EXdif
cHh+4Mx5bwXk+VW27btFj8W3nqSVOlGEhx16T8ylI7pioy4IBZQQSxdcC84s4tYy
IFmOdzzssRM7KqmZV+u2vaxFmkbMaAeLGC4SWN9xoQHS6sgYg8n90pl5Wf2QFI1g
zT4AKcudSIqaf95HeKmsU6RYY767vZTjsrLaBN2bxQPfA3hhRbMHh9hXVDIVbtBA
rGl5Bp9WzGruYgaqId4rsR5UZ74ZgdXGZb66OurpFnzFn8R0L20sG/sj+Q+97D20
Eg16bmFIgcKsv05cLCadfNGHp/7YJ++pJ+seiAG6SiOytAVek4uNVzCor8URjjA/
JD7m164WImST/JQA0/MuV7+GZgXNXius69GKjOUeq15xwK2U40C8zgUAy0WUH7V5
M7Pv7QtXvuJrig9VlFf+ayWmAvbfl/3s9WyKVNI2AaIZZxqQwrlMB6qQTewXC5Nn
k48EeD6FtA/j5veVx2nMMdyJpapKTd8FzC6SuOhoJ1tpZhsCFAf+RRLCr2pz2889
+ORdKR7QSNoRQAnGnO+AE9gUq/tXsr82pNUVd4nTMoLgeppvWrVgJw4Isafp4+kv
k6s50t8vRWYhyaRin/52
=o3Dx
-----END PGP SIGNATURE-----

--3snK74p7ddXn3Qrx--
