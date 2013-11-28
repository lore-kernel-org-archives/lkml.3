Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796Ab3K1Hwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 02:52:39 -0500
Received: from sauhun.de ([89.238.76.85]:49333 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab3K1Hwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 02:52:37 -0500
Date: Thu, 28 Nov 2013 08:52:35 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Vincent =?iso-8859-15?Q?Stehl=E9?= <vincent.stehle@laposte.net>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] i2c: bcm-kona: fix module device table symbol
Message-ID: <20131128075235.GA2626@katana>
References: <1385591920-7714-1-git-send-email-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <1385591920-7714-1-git-send-email-vincent.stehle@laposte.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2013 at 11:38:40PM +0100, Vincent Stehl=C3=A9 wrote:
> This fixes the following compilation error when compiling in module:
>=20
>   drivers/i2c/busses/i2c-bcm-kona.c:894:1: error: =E2=80=98__mod_of_devic=
e_table=E2=80=99 aliased to undefined symbol =E2=80=98kona_i2c_of_match=E2=
=80=99
>=20
> Signed-off-by: Vincent Stehl=C3=A9 <vincent.stehle@laposte.net>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Cc: trivial@kernel.org

A fix is in my pull request for Linus today.


--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSlvZCAAoJEBQN5MwUoCm29c4P/0ZYVOcVJYJXnfgsxw/GefM8
5kdIHrjKnKxd1YufjO1SC29FtscaH538zBUErQgDh1k7Tv4Hyp7eTvACxvlu8Bhx
n8anl5bvB6mV0tjBHnT5Hm5P7oClXFR3TSKRPkUox6He8WH7vXj9zoP/TD31fS6E
hDQsXnmoLegLcKCOgFHA7iOInzDXChAyQ630ev6N51moPNIlGBOEjdYs9/G3LzON
uJb8fAXLELxGImKcF3Pbr3+9VQ5igbwofDtWi0uJbEtwqkX9CaZuE+2ylOgvKgh+
JLmo8gAbNht1D5LVFdB9OuzrB8QJFXK/W5XwEvr3OjWXZEeukBfGC4p9rKHTwSXF
Ly4L2Kdk9LsPtJJYcWDAlSOn2m2uS9k8eb+MckfSCKg7YLiV5Y4OY8MMDDVcQIsD
XdSNPF/uY7fDjMy6yKjIwEec1xxwuli/pw9QKBaClRuNoyV053hp0qBvo80He12c
jTb33UJdrjoH/iKp+7E91FL4Z5nAGT11W9NsLYefCCEpCu3cuu3bjmM/8Z5ZgNNB
pSaEFz5F1tQagdCxoUjbism0sY5ZCNZr5P+KUlohI6uQq7WOJ0NIPGUQMSOP+Ffk
LjhS4aEoOdVOqRnmUy2ieeWumXB4lMNWVaB2G5rwolkFKHX4aYTjkDQFzs35+tew
VXpUazpzz1OfxQz6PV31
=Go97
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
