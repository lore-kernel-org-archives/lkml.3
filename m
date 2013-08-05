Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab3HEUge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:36:34 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50672 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754994Ab3HEUgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:36:33 -0400
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Aug 2013 16:36:33 EDT
Date: Mon, 5 Aug 2013 22:29:35 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>
Cc: Mike Turquette <mturquette@linaro.org>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] clk: sunxi: Add A10s gates
Message-ID: <20130805202935.GX2911@lukather>
References: <1374618504-19391-1-git-send-email-maxime.ripard@free-electrons.com>
 <1374618504-19391-2-git-send-email-maxime.ripard@free-electrons.com>
 <51FBC13E.9060805@elopez.com.ar>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Vx/u1Rx7tHHd/cso"
Content-Disposition: inline
In-Reply-To: <51FBC13E.9060805@elopez.com.ar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Vx/u1Rx7tHHd/cso
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Emilio,

On Fri, Aug 02, 2013 at 11:25:02AM -0300, Emilio L=F3pez wrote:
> Hi Maxime,
>=20
> El 23/07/13 19:28, Maxime Ripard escribi=F3:
> > The Allwinner A10s has a slightly different gates set than the A10 and
> > A13, so add these gates to the clk driver.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>=20
> Looks good to me, and my A10S board still boots, so
>=20
> Tested-by: Emilio L=F3pez <emilio@elopez.com.ar>
> Reviewed-by: Emilio L=F3pez <emilio@elopez.com.ar>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Vx/u1Rx7tHHd/cso
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSAAsvAAoJEBx+YmzsjxAgWKkP/204odi98KjC780Wuy52mr3k
dVrMi5y3NntggRvXHvihDs7UrTmpV1sVj4SzJBBCamSAQ5EF2ld07kJEOFHwcCqr
6bAK2x3LohRCPeS5J4h7DeEVYlc670zHgF6buqlHxGDATqVt4uFy8gp5aKn9QwQF
9ZkNwg41juguQMh0EQ5btA3HyiPiRczqdFYpUwvs29+zxrIzdf42jjA7HI0AAefl
nUwknMhQjQZ6YYv3BlhD7bz8oEYMkXIRr0v18ouTDhvHQffyyTJlL/4kyWRkQlI0
8o2i6jBvxEY6fcjCT7hNJV66a1K0/UUQ8A39NlHfDm3oGOSE0thNIKvmHNUp3obs
ioLhHnALcqdsLOCyM8O8XpGnAhUzmq91lZmFaIDX0S2ftXTqK+KIezx45wN038Bu
opIRatadLXAimgDhWFozRkg2ZC0bauqepqo3i+F5mQ+X+V4ilvaHPiw0v8k9D+Lt
jRgH+flpjfYBHH3DRhN+NtoRxvWACAEJMdHA73kYu77iEybhxUBEhienossY51hu
Lk1CmfY+d93bb6yLq/v4Hdd0078I7XrLCgKtulC1++iI7ur7UpYmi3p/TsrlDHKS
gumW0cPittVYPogsGlIw2KyeWrQaLoR0wmRXH5BD8tSwkiltSJ4EUl/vGSuQNrIM
MsUf0MMk67pC/JsbGJel
=/RHh
-----END PGP SIGNATURE-----

--Vx/u1Rx7tHHd/cso--
