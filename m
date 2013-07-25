Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab3GYAEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 20:04:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39354 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab3GYAE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 20:04:29 -0400
Date: Thu, 25 Jul 2013 10:04:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mark Brown <broonie@kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: status of various trees
Message-Id: <20130725100410.66cf19c66164f29215228aef@canb.auug.org.au>
In-Reply-To: <CACxGe6uB5wKzaM_X3ROnD0z+wc7WZ=cHF1bm3zD=mm=mb5QJxg@mail.gmail.com>
References: <20130723095513.19b9638ab4a19157e9834dcf@canb.auug.org.au>
	<CACxGe6tjrFG1aLc9Scmmuunjb9hTm5vyH6LqXiys8484YY=Zzw@mail.gmail.com>
	<20130724102123.6d1156925959e56640c23468@canb.auug.org.au>
	<CACxGe6uB5wKzaM_X3ROnD0z+wc7WZ=cHF1bm3zD=mm=mb5QJxg@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__25_Jul_2013_10_04_10_+1000_PQesyv.LdbKm2kVg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Jul_2013_10_04_10_+1000_PQesyv.LdbKm2kVg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Wed, 24 Jul 2013 11:01:07 +0100 Grant Likely <grant.likely@secretlab.ca>=
 wrote:
>
> On Wed, Jul 24, 2013 at 1:21 AM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
> > OK, I have done all that.  I also removed the irqdomain-current and
> > spi-current trees.
> >
> > So the trees I have left that you are responsible for are:
> >
> > devicetree-current      git://git.secretlab.ca/git/linux-2.6#devicetree=
/merge
> > devicetree              git://git.secretlab.ca/git/linux-2.6#devicetree=
/next
> > arm-dt                  git://git.secretlab.ca/git/linux-2.6#devicetree=
/arm-next
>=20
> You can drop the arm-dt tree also.

Done.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__25_Jul_2013_10_04_10_+1000_PQesyv.LdbKm2kVg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR8GuDAAoJEECxmPOUX5FEMAMQAJ0hZn8SuwId7srbv92rM0IR
84Ih/+bJ1xwo4VqW+dvv+qtHztVZ4EmSWEtv+fyY9d8krhAIjowYGGlwpHcMeAMK
03N7XU3n5foG6OKtsMZouBHA6dBUlAvhDncCQ1FH2IIBncXQIsabpD3a/lKTOq8F
RboO6zbS/NJZh2ysKI8DgjtlIAYQe3DGHN0VZ6If4nwPiywQVwz3zyYp5j8UrL6E
s40Wz1n1s/gpYMUnaL+HjsYK+BwW+ZbFE4dWs2024WU1bU2wH2UB1YKhG6nSa3kj
9cUs/hiu75xIhOlzpYOHop3znZ7qoY1CyfBT9Yn50cR/GQbq67mbMjE/FWM2Ivbc
99bmPQAbs7Grqb+leaHJe0PPEIbp6d9Fka67ICn/DmBD+waT68AyVhr72Wt+URQW
962Q24tt6zh+sjiwAzHJSLyuwJ/HlbsjHPA1UL5f6Oo+qdX6cxpZQvZg/x92hFiH
J3qDJ7j/0biNv6yaheytGx0RpB3Xk0LVbZcftFPJE0XU+b7EG2Th20DD5NAHOqle
6HY5ww6PygTYoIPrxt9qp2+NCSyMjaLLTJRzc5sGGUq9YZpssdTBrh/UpqM9WwLz
rrvbD9axrHB+HX3pfG9d5hJ4qV2O1NNk5P/WQ9duUUviVev2rQPhi//knqF4FC/E
B0BGdsnmteYflDVHDNog
=Z36t
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Jul_2013_10_04_10_+1000_PQesyv.LdbKm2kVg--
