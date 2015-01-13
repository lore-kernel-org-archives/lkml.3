Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbbAMNpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:45:05 -0500
Received: from down.free-electrons.com ([37.187.137.238]:34018 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751726AbbAMNpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:45:03 -0500
Date: Tue, 13 Jan 2015 14:43:31 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: LFBDEV <linux-fbdev@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fbdev: ssd1307fb: drop unused function
 ssd1307fb_write_data()
Message-ID: <20150113134331.GW4891@lukather>
References: <1421090474-4243-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XQSDX3NWE02rtiZq"
Content-Disposition: inline
In-Reply-To: <1421090474-4243-1-git-send-email-prabhakar.csengg@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XQSDX3NWE02rtiZq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2015 at 07:21:14PM +0000, Lad, Prabhakar wrote:
> this patch drops the unused function ssd1307fb_write_data().
>=20
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--XQSDX3NWE02rtiZq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtSEDAAoJEBx+YmzsjxAgYKwP/2E5rkyDySlyJUufvDAg/U+L
wb8xJ0lnA7J3QI/yYjH3TWNYKMXM1uFJyVcLpH2FLG1jyYc+fAE18SYmZx/CoiD/
HNp+pgjVRLBLLOMPDnyS/oQ4MSA9mBwaDKsdvRP9kKasDaXU/lZBRrWRaHyrpPPl
cLo12a1hibpdirD48u7/4KcIWyo1ko52GsvNyizSjvNUPlp1v8PgbiX9QHU0S0ZK
XAKy/qPXaMe7qucqCXhlHgVT6qJhgNzRfKdMUBA5EwmHxO6hkuQsyiXEtOdDDUEj
KdhNu+JRg2uCIyoysh7rXrNp8QCERAXIPqT6CZeYHyMMl8rZ7qvPbfGzsY0okJpl
7Xo0P4/QPxNbfhWG5VwKdqt2DyiEItAFEqSO6ijVv1Juu6yW43KMZ/q75Byepm1w
CyLd8l5ghF1a1JVbQvcriuiZjgnTS8ltpQ6XU74IHBbk0WF9QbIwkMZSQ5+bmt2N
a1jHqa4gNY5n+4BAPTReUM0tb2Np3ngMsKm8QRKiY84sMuEr9h9ED+tdgi0t0crg
G25+7yb7oAQhQfJ10qaV2HXRmm3Bcm7a2SNbr+ZPAxxp+KIiJJviqcfFYdyZ6nvq
Ajj6sBJC+Xosdo+Gnzg2TdfnD86VOe14q0Nkqe3VqjmfVSxhUjihS6We7oIIWm9n
jvN2sSM36LBLas5ejVj/
=kxiP
-----END PGP SIGNATURE-----

--XQSDX3NWE02rtiZq--
