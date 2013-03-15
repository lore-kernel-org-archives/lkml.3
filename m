Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab3COQx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:53:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52379 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753655Ab3COQx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:53:57 -0400
Date: Fri, 15 Mar 2013 16:53:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Remove __attribute__ ((packed))
Message-ID: <20130315165351.GA8988@opensource.wolfsonmicro.com>
References: <1363274779-20671-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <20130315013640.GG4931@opensource.wolfsonmicro.com>
 <20130315111602.GB30777@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <20130315111602.GB30777@opensource.wolfsonmicro.com>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 15, 2013 at 11:16:02AM +0000, Dimitris Papastamos wrote:

> On my system there was no benefit of using it, it just happens
> that the struct is aligned properly and needs no padding.

OK, so which system was that and is it not possible that other systems
will get something useful from this?

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQ1IYAAoJELSic+t+oim9rpcQAJ5Sm/AwYdXwUtxk9bsDs9dK
NS0ZU8gfkmAB4M7GCdXneITEENx6LGBUo760EVuVvFqpULWzti5xUS/T8/YWCpKR
H6cWyonmATP4jpRBI70T0dn7yiW5lVXlJbwJfElpUpzwx14ln01NWkh1zmJwsoTP
MTxFrwHT9Y4WwTyGqlcUdLkIPAqLBJ9nCMPMimo80EXeVGVeWNDV6NUbTWYj3YXp
O4DCITn6FmsJU802j7XXC/syXIm583r6leLKn+542U5jti9mjbSXOTwNJr2VAabu
cJmQUJf/s65WOuAbMxx5XBN6WYEyziWujbvFjYUozATnO/rTL7SU5KOz64Rml6xm
OVUhuV/gWtwxsAsuEKlCuHnUrwo6M3zYsAcZ9pibKEPOdTcORpLBNSTu76Kk399y
x8gvOf8adoidRs8HZvaBkVZbBLwbeih/33vbOatAWjWri+3nyio3UhPLw6PQOy1A
UBpT4/VAnKcf0OlGpNQ3M7ymceX/gRWAmM2PXWfURGa4uu/TZRoJ7tJwW6XK/I1l
4bpXodcTehZEebBh3raK1wxSl9GGVsSToU3U5KgslJi3oUZC1Dy9AjdO3yb2DV75
X1PUsMIDIXI5R+vy7EjzOnog6pRol1QT/o9Pep6UxlVOCDfl3I6tBjV8ch3lhu5c
UkD8StYPBxfXpLjbMOCQ
=8HNj
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
