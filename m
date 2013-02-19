Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933481Ab3BSS0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:26:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50498 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933152Ab3BSS0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:26:52 -0500
Date: Tue, 19 Feb 2013 18:26:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Axel Lin <axel.lin@ingics.com>, Mike Rapoport <mike@compulab.co.il>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps6586x: Having slew rate settings for other
 than SM0/1 is not fatal
Message-ID: <20130219182647.GD23508@opensource.wolfsonmicro.com>
References: <1361015443.11226.1.camel@phoenix>
 <5123ACA1.9000408@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n/aVsWSeQ4JHkrmm"
Content-Disposition: inline
In-Reply-To: <5123ACA1.9000408@wwwdotorg.org>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n/aVsWSeQ4JHkrmm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 19, 2013 at 09:47:29AM -0700, Stephen Warren wrote:
> On 02/16/2013 04:50 AM, Axel Lin wrote:

> > Ignore the setting and show "Only SM0/SM1 can set slew rate" warning is=
 enough,
> > then we can return 0 instead of -EINVAL in tps6586x_regulator_set_slew_=
rate().
> >=20
> > Otherwise, probe() fails.

> Why does probe() fail; what is trying to set a slew rate on a regulator
> that doesn't support it? At least a few days ago in linux-next, this
> patch wasn't needed AFAIK. Is the problem something new?

I rather suspect Axel is doing this based on code inspection and review
rather than testing (either that or he has an enormous lab somewhere
full of all sorts of hardware!) - what he's saying is that the error
handling here seems excessive.

--n/aVsWSeQ4JHkrmm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRI8PDAAoJELSic+t+oim9L5UP/0nH3LJl0wws6T+pLbjCPi85
0MJddR+tLz8x7bJb0I1uv6T3mRfQU1o/V19fmeoj3K9Tp+WkdsIUEwn78J5XhS9x
7AB6wFmBlqaS3hv7wUGongGFVKmSA+s0Pzk3EkF4Zqws4BiGtmGzRlvUJPFz4t9f
B0khv/S+Hc8GCLbDbMoUOMrNgQMkppSUfTdy30V2+qI2o/PRRu+W8z9amOfr2v6V
9oE/SHywmF6bmTV/dX35/noID0hibClqSp1ePT8oKbkHfB1LPMFO2hUqVORWx5Au
n2iWO2qVZbAs56uCqowTI9JPd9wey7CYszWiRWD6m0/ntrr+w3OBCHJrWmypKqN5
xQSLorNDEcW/JLnO5sz7MfUsPgKKXT0+4nuCBAZu6tbmq6HQnQ0n4tzFu7Vcrl0N
IF4KVh/r9UQUAmuH9uAqR8YTcuXRigcFWp7bV2lWkOvqPniOTCzfpFKAJPHwT8bQ
9Zxan8VWrzqxryuNtsxSGHY6PIPcILEeAPdU034oeuQoqhmAadAWO7BlOTp9KmQ6
QuwK+KlAbmtUzpQ+V9NbYML46DHr5TL6NCFWaOO9YyJnr8bl4Ah7aTXXjwCO3tJe
B3pkFd2nwRvF22Wv1abFWEWOGBJa2oYcEmAJU6ThL3b8oFLFUTrvmQUXqye8vuG4
hbfttbNBqCy3N5r9d7lB
=XkXL
-----END PGP SIGNATURE-----

--n/aVsWSeQ4JHkrmm--
