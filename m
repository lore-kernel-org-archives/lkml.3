Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674AbaFKJPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:15:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60174 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932317AbaFKJPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:15:03 -0400
Date: Wed, 11 Jun 2014 11:10:35 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: kishon@ti.com, hdegoede@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] phy: sun4i: depend on RESET_CONTROLLER
Message-ID: <20140611091035.GD4254@lukather>
References: <1400871088-16894-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
Content-Disposition: inline
In-Reply-To: <1400871088-16894-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kishon,

On Fri, May 23, 2014 at 08:51:28PM +0200, Maxime Ripard wrote:
> The driver depend on the reset framework in a mandatory way. Make sure
> reset_control_get is defined by adding this dependency in Kconfig
>=20
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Reported-by: Arnd Bergmann <arnd@arndb.de>

Ping?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTmB0LAAoJEBx+YmzsjxAgtT4P/3UZFuloccNxqMPey+Kivrfa
JUnk0pd3wQ1US2YjqFIZkAxOcUq7QOpMPRl7lgB6tJJc6LNEWvheE1vxfnFGB3pu
UkJTntaYv2P6Qx+gmPF77+qHnr3vqpRGrrWclhDR2LMrRLKMTpNsrbUavEuAFRL3
bldOE5UOFTfc3Z7x9UrmIMUSk1RPPzb+IJuhWD/jVglijJbu+lDO8MRbmADjHrut
aMQjwz9pjDqStXzy9O2YayohE+jgbsWCo4ugXW9A/w1ao9hyC21LDdj4llaQfqYc
TxZeWdNtvypZ6llmpzm8U1xBnzVQic1ASrlYYGTmvzlrCeZroJWDGhXhQkmhjJlr
qYB79nKtd3lPxeADWl5M6kNaosv3YzdgLifGmO4alEVU2n2s14gxuZkwtONfIwsq
Bzd4Z1jTG+3dmE0vaH4FiMgV5s8F2ifWF2+fhI7maF47BEz9SgvNgTQ8GWSVbjtS
zHW73ZxzssAII34pwkHkbGRyo6B/30BoXni7wG+Z2js65FuuqnFWq0bfqbTykjxb
LwLeXc50CYni2sT2gwVL2ALNDn2mwSxEYy+laM5w7k1im9oEkuygjoeU9dbjKP/p
dm8eEA5xBdKMiGw8Ox5Zvz0DHhjkG8z/+3ezJgeS+IylRYXKOTWsmjx0FYxHroPX
X2T4/8UGYF8c8DqKMQn0
=lcN9
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
