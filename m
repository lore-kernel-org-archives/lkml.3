Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab3A0C5f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 21:57:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41029 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755288Ab3A0C5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 21:57:33 -0500
Date: Sun, 27 Jan 2013 10:57:22 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Gyungoh Yoo <jack.yoo@maxim-ic.com>, Stephen Warren <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] regulator: max8907: Fix using wrong dev argument for
 calling of_regulator_match
Message-ID: <20130127025715.GB4650@opensource.wolfsonmicro.com>
References: <1359080429.4232.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline
In-Reply-To: <1359080429.4232.3.camel@phoenix>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 25, 2013 at 10:20:29AM +0800, Axel Lin wrote:
> The dev parameter is the device requesting the data.
> In this case it should be &pdev->dev rather than pdev->dev.parent.

Applied all, thanks.

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRBJeDAAoJELSic+t+oim9JhIP/2932B6Q+zHzhqgFREkk7kmc
PgKdzkYTNJNqKAy/JcHBzzdkQ3QjLMN3vd7IAer3mnpkJ0e6LqF6kF8DGZKDzRfF
vVl81RT1zgsCfSxA9gw+pIeOLPAbjDCAEq3pRsVJ96zlP0qku8jQqdeOLtjfDxZe
3xw3m8iRYFyyp8BsrfkCgdhqva8TjEPoS00l8VbaSolWDnk/DlLH6IVFNyoZ2zcd
l3ZLCOZvXpre78lPG3ee6/jy4x403Hss2xCvhqiD2t5AxxLBpJklBGryB/QzAqdA
7y6beOagaQmO/CSgFlDEgjZgJViBqGm3mblCA4fvokQE3LpD7PZGOupTdw2F1c2Y
iVJHmX3XswLUtUknZmNK1Wlkgw2PPIUSRqgHB09UKadyhb2d2OsG27yd5WCZyIqS
15mdiyThtsF2deotF4tuntdqLROkHXn3WbeSD2UViFOulRQKM2t+wY1zR0vCpGqG
QdxJAUCbrsVhOhDXpi9IW1kTVg6Wy3YmJ0HRT5kB4xUk2e5mEBYPsLMK+mdynK7L
cCblC69iPpdOnBEuJTtwxypiFERa+j/Y1e6pYQGIruMXIjUgx3ziuOV4IqmVvwro
ZejeTs9HbBvoT/E9ZqExwZtCT9Hmsx0Qhbef1Lw9VvSc+vpSzMKM3k3HDqoCCYAH
6kzoJqDz8JjlsaZPBMJ3
=m+ah
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--
