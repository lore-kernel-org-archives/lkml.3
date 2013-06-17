Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab3FQTpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 15:45:20 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:60746 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab3FQTpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 15:45:18 -0400
Date: Mon, 17 Jun 2013 21:45:14 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH 11/15] regulator: ti-abb: Convert to use
 devm_ioremap_resource
Message-ID: <20130617194512.GA5265@mithrandir>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
 <1370864113-17895-12-git-send-email-tushar.behera@linaro.org>
 <51BED2F9.1020307@linaro.org>
 <20130617100525.GA1403@sirena.org.uk>
 <51BEE64C.80608@linaro.org>
 <20130617160853.GG1403@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <20130617160853.GG1403@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 17, 2013 at 05:08:53PM +0100, Mark Brown wrote:
> On Mon, Jun 17, 2013 at 04:04:52PM +0530, Tushar Behera wrote:
> > On 06/17/2013 03:35 PM, Mark Brown wrote:
> > > On Mon, Jun 17, 2013 at 02:42:25PM +0530, Tushar Behera wrote:
>=20
> > >> Ping.
> i
> > > Don't send contentless pings.  I seem to recall you already got some
> > > review on this.
>=20
> >=20
> > The comment was on removal of the error message during
> > devm_ioremap_resource() error check . Since there are a few other error
> > messages in the driver (related to devm_ioremap_nocache) in the same
> > format, I prefer to leave this error message right now.
>=20
> So we should say the same thing repeatedly?  That seems silly.  That
> seems silly.   It's like the contentless pings issue...

The intention was to make resource usage more consistent with the new
devm_ioremap_resource(). Part of the consistency involved to move all
error messages into the function so that callers shouldn't have to
worry about them anymore.

So I agree with Mark that there's really no use in keeping a second copy
of the error message.

Thierry

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRv2dIAAoJEN0jrNd/PrOhxS0P/0meplrUNAKHjqwLuixsCuvm
sJ5/K0kqUrl45XdR8kU4gcG7ugUa3UYgXwJzXXP002lhfk95fAyVj7cBo83yesFX
K4q9AUx7DbtYQvlUUETT+jFzY9Zvp0oZjD6fjvdebq/TQnKdd6GoTfvN2eQnTdZG
bUj4bRH+Kde1/houA5kaPIS3P+Jrpk4rBfEwWO4gCtqOZe3syai88lhiAenCxRjJ
2YaRxIazXUWl9cXF6/V8RwBDEFgkRjmPrnDtyje9axFilfd1oUnN1KmHPj8f2t9A
nxN9+x7Pfm5YhC+ugjL7Om+PtA2g4gwqAFGY33TwN0jVz9la/WKJeL+a0ecSRnbE
KUt1vVTCuudlWc/ZhQD9vRFvJsS2u7PMqkzsXrdutOrtVr1CPa+L7U64Ak+rOFpc
QK0ukLLr8fecsRKoBo0xkxq+LQ98PYWQRzkf2TydelZ//c6xBgo3daAMJ6zx5zeD
8YnysbHINRRj8LqXIUHT1rO8Cg+6Ty/Eo5tbtqSolLYONkInPF2sjn5H50t/G8d0
K06OG5XClV5Z0gMmL8nuKhWyytpi7E2fge9qx97Nxygb1me5poLR/6aYieBUEWEc
gmthdGmeBBf4Oa6vobJ8p4u43BfR6tYXr7he4KO3kH/vi5Nl6dwQFflYMudB4OzS
60R5bZwrSQB7plEtst8h
=sXl/
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
