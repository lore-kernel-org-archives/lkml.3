Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbaEYNKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 09:10:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60954 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751487AbaEYNKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 09:10:11 -0400
Date: Sun, 25 May 2014 15:09:31 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Marek Vasut <marex@denx.de>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, linux-arm-kernel@lists.infradead.org,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        rdunlap@infradead.org, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, LABBE Corentin <clabbe.montjoie@gmail.com>,
        linux-crypto@vger.kernel.org, galak@codeaurora.org,
        grant.likely@linaro.org, davem@davemloft.net
Subject: Re: [PATCH 1/3] dt: Add DT bindings documentation for SUNXI Security
 System
Message-ID: <20140525130931.GI10768@lukather>
References: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com>
 <201405242143.42693.marex@denx.de>
 <5380F85F.7020601@gmail.com>
 <201405242159.30505.marex@denx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xQR6quUbZ63TTuTU"
Content-Disposition: inline
In-Reply-To: <201405242159.30505.marex@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xQR6quUbZ63TTuTU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 24, 2014 at 09:59:30PM +0200, Marek Vasut wrote:
> On Saturday, May 24, 2014 at 09:51:59 PM, Tomasz Figa wrote:
> [...]
> > >>> Why sun7i-a20 ? Is the crypto unit different in other sunxi chips ?=
 Can
> > >>> that not be described by DT props ?
> > >>=20
> > >> A widely used convention is to define compatible strings after first
> > >> SoCs on which particular IP blocks appear. It is quite common among =
IP
> > >> blocks for which there is no well defined versioning scheme.
> > >=20
> > > Well yeah, that's fine. But in this case, "sun7i" is the entire group=
 of
> > > CPUs manufactured by AW. I find that information redundant, the
> > > "allwinner,a20- crypto" would suffice. But I wonder if that IP block
> > > might have appeared even earlier ? Or if it is CPU family specific, t=
hus
> > > "allwinner,sun7i-crypto" would be a better string ?
> >=20
> > I'm not aware of Allwinner naming schemes too much, so please correct me
> > if I'm wrong, but if A20 implies sun7i, then "allwinner,a20-crypto"
> > would be better indeed.
>=20
> True.
>=20
> > Whether it was really the first SoC is another thing. Obviously this
> > needs to be checked, although it isn't really that important. For this
> > particular naming scheme you need to specify all the SoCs for which
> > given compatible string can be used for this IP anyway, because there is
> > usually no other source of information about this available (except
> > directly comparing two datasheets...).
>=20
> Better get the DT stuff correctly right from the start. That's why I'm as=
king=20
> what chips contains the IP block, so we can guess the right name.

The name is fine, please stop this bikeshedding.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--xQR6quUbZ63TTuTU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTgeuLAAoJEBx+YmzsjxAgAsgP/jOt5x1dVFqyNp8JHXhwwCM/
+498kRuqZX2bYt5j0+c3kH2FzIA6AeEP9gFGry60I3gbdH1M/Tv3UxE9JLieMhid
73UVhciaHwndN+i7J7GKGXNlpJa+7tEjAZvMMsgUWvDNUdLaotes/ogihA9s0TqG
8QcKWVwG7ZeFNtvKOpdiTBncrH4AWmt7/6mD1A1ktk5S3RxbRlDh9VapmlQTVZ6O
bSC08udgoUGjtD+aJd+Y9CGS7vfw8wpNLhFX4+14L/ciwTFtyAL9CadFzS1VF84Z
AAjBgcIS0CjbULGC5xLzGXRgmh24dtO1bUhSh2tADG04LwurEf8d7qstPic/7qE6
hbRK6b96vpAw+L6uvIrUIH/9DCpdlrIeLNoB89AODRGPFX4dSYowhKlQ+SF866CS
wby1jyLTUepQ87NxSoTgzJEww49gtwKCZw5lEHi/jGo/Tzq01bZG/RpUPQyt+3WR
fYE81HubHzi6NBtinJfiwNbCBDsq8Ha+GruDnONNaJ5N2jHh1jdn89wKH5//4pnn
2L7wGz4a5gLEhL9QbZL/Ufyei58Kgkav04U0y6wRMGg3hMs3WopHHvN15gTBGlh6
WIuuDz1d6cy3IDnqHcsRa+gahFZxwr3J2uNLjlGPYNTYIzVrLyJwWpH0yJUTK23F
U6CiRpCzMCPq2gVFrVjk
=oTL/
-----END PGP SIGNATURE-----

--xQR6quUbZ63TTuTU--
