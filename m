Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762869Ab3DCRh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:37:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37320 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759403Ab3DCRh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:37:57 -0400
Date: Wed, 3 Apr 2013 18:37:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        yongjun_wei@trendmicro.com.cn, spi-devel-general@lists.sourceforge.net,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] mxs/spi: fix error return code in mxs_spi_probe()
Message-ID: <20130403173755.GJ11305@opensource.wolfsonmicro.com>
References: <CAPgLHd9u8Nhfa-7dp_atXfLb-vRBzdqVbrCbPSd5xMmh2Q5THg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Re2uCLPLNzqOLVJA"
Content-Disposition: inline
In-Reply-To: <CAPgLHd9u8Nhfa-7dp_atXfLb-vRBzdqVbrCbPSd5xMmh2Q5THg@mail.gmail.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Re2uCLPLNzqOLVJA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 03, 2013 at 09:06:40PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Fix to return a negative error code from the error handling
> case instead of 0, as returned elsewhere in this function.

Applied, thanks.

--Re2uCLPLNzqOLVJA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXGjsAAoJELSic+t+oim91l8P/0d0WQyespmZGJxLLkIZFG+f
r4gyoMQXJAglqI0C9yZwThMbCJU2mBMZoqKFiL8EIygGyMQ0+hk/98bkPdhiz6sD
JWm9ilHz/xLmgnuJjt+WdRVaFdohGRxdlKkLq1iOgPdzSzGvcyJee34xbqaMTHty
xfIhAT0eYvJJFsYVQPPG7L24ZKFH3jY6lce6Nb04iCEffa/MGeMyufu2pY7OTHjS
ZOljcKvM1ST6bteiAgimEE7lZIf1OZSpNT4JRUV8j1Me7RuO08CpWb6LXZ8kxoxk
5ZsTcxcTmjB12mTlapcyPj2QU2ImmgvIY+8Q/WZYyHfGnzWIzu/bWqKYxU7fxNpi
Zs9VrxGRDqHMF8L8HlU/bbj4+/UQEwpb9ui1DeZavLAJgE+fxMICiuk4OfiBLJuK
91jiFF1O9CHJApbL2g3t7SQYLFIxliiuUJ7dD5WbUpt+VgW6QImEACUjJv5MsGUi
5IDBQUhblerE5RjU7WvVaMMTw6D4sfYOBa98wGIKh9Krox7HPBJgQN2UDHlaeX2H
03GxjrkoQTqswmpnOXBzQw5ylwk0XcQ4OindHGOoiWHALvAZ/kF+f4oADd0HaK4P
Cq+RlYDQpvs1PQEgHdo86juBdxx132vtiJEk/kkU1ZFP3YpFbE1sZcavHZvzoCG6
5WLHGCo7q7XGiyIU1++R
=iEIB
-----END PGP SIGNATURE-----

--Re2uCLPLNzqOLVJA--
