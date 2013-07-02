Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3GBSQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 14:16:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37296 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab3GBSQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 14:16:12 -0400
Date: Tue, 2 Jul 2013 19:15:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, rob.herring@calxeda.com, lee.jones@linaro.org,
        linus.walleij@linaro.org, ola.o.lilja@stericsson.com,
        wfp5p@virginia.edu, yongjun_wei@trendmicro.com.cn,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130702181544.GY27646@sirena.org.uk>
References: <CAPgLHd8i0kcs5RE2UUPmFS5ueMgRAzofeaAUnGz4WuYFBANeBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IbuFj1t1LJkAAh+4"
Content-Disposition: inline
In-Reply-To: <CAPgLHd8i0kcs5RE2UUPmFS5ueMgRAzofeaAUnGz4WuYFBANeBw@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: mop500: add .owner to struct snd_soc_card
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IbuFj1t1LJkAAh+4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 02, 2013 at 05:25:37PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Add missing .owner of struct snd_soc_card. This prevents the
> module from being removed from underneath its users.

Applied, thanks.

--IbuFj1t1LJkAAh+4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0xjNAAoJELSic+t+oim9WVUP/25evwO0QIx9g7+xCIMtyTrb
dmNWDo+hbZlzIJyi9mqV7Pj5LEfnxtHhxv6fxUVoli7rs0tmyYcBd/MMOr4IFrD5
Ri+73worFrx8Oyps3KsC6j6Pfx+MKnjC8Btvc+wSLFvMYe5Q/w/BlQT6VQ9ng6wB
hZXdJgkcsRCsmkUlqOx73CI9zyXHBGYMJZxU3SGbZALdg4ITPCFqxQufywfckS8N
H5ybFtFM1b+3bLbZwaX0O16JjPJqAU7DH6BIiXhubooPtzSFK+ei12hBwWC72PZZ
Q4TsRGkdiLpbHZUq4Z3xbG3VABsa6VbkJcZZVQtsF78uCp0/YPZCOkrxWvWLQTUc
goRBENFY7zm6Hjt9qTT85ijH63XHs2rK2xKRElsCwJM99GMKtO5vPP1Z/AhBMVUi
1mq2zA6bLTVWZT0GeKKffhDE5OzuEMzHAFQIyWwsdWBxSwGwk5wgMmmGi9bBLebN
ZhB2LZNjJ7IBksPm/Bj1fpDR+a7XuZ8lEb3IznUXDbBXImCBpkKb9ZY7eStUC2FN
vDAZ2sbNxYtE0yiFx7WiC97vcZ6Kk1L0Gpfzmq0jmS3PkwiFAWbfABVwYMHUPw1L
ph2kGSNywx8a6JvECFFVogL+DYqaSRKzUWauc3vf+BFhnhUX7qvbx8PYL/iF0/gs
im0LXaCo0KwvbqUdJRlc
=4hk4
-----END PGP SIGNATURE-----

--IbuFj1t1LJkAAh+4--
