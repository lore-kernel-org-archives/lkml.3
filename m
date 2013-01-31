Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab3AaOKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 09:10:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37806 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921Ab3AaOKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 09:10:30 -0500
Date: Thu, 31 Jan 2013 22:10:21 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ASoC: Ux500: Fix build error pertaining to missing
 include file
Message-ID: <20130131141019.GA13321@opensource.wolfsonmicro.com>
References: <1359635640-1932-1-git-send-email-lee.jones@linaro.org>
 <20130131123744.GG11078@opensource.wolfsonmicro.com>
 <20130131130340.GB2042@gmail.com>
 <20130131130631.GA12824@opensource.wolfsonmicro.com>
 <20130131140735.GD2042@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <20130131140735.GD2042@gmail.com>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 31, 2013 at 02:07:35PM +0000, Lee Jones wrote:
> On Thu, 31 Jan 2013, Mark Brown wrote:

> > I'm a bit surprised the compiler would change something like that, I'd
> > expect it to be more the build system.

> You've lost me.

> When I compile this file it succeeds. When the person who reported
> this bug compiles, it fails with the error above.

> mop500_ab8500.h is actually in the same directory as the file
> including it, so it should by rights be encapsulated in "" and not <>,
> right?

Yes, it should - but this is also something that can be overridden by
the build system.  It'd seem surprising for a compiler vendor to change
their behaviour here as there's limited benefit in changing and much
potential for error.

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRCns6AAoJELSic+t+oim9QioP/3vG70yKhlJhvNILzD2bHPYY
YeJdlDrnIm4Cm1R0BH83vB3DgRsnFTFiXhxqOl+cu3dmK5Zaw4fPy8Fb/IePG0pU
QQf1fynuy/3Z+P7gIsxnShXuxZBtmyXcCa7LWFssfObDk2XyG6mKSb9NUb9vh6gP
WVtM5G9+Imsjt73FO0LLXa2EXbGNy2+GbZ14Nr1CRl4IvbZdEpitIICDs1LSiOVr
TbkS9OOsAfKZYtZEoeDSXf8o4cZRYQdVVuSTCsFI8xQI5DugFYMXspbLLqnYShSk
7zpj/WyKGoemmXhDoZDyujDgrEPEu6zZSwobNE81WD/5Ij05mOyCmKVxq5QAcCEO
2yYdU56K5w04aNjOoSl6FLo2Y1VJLTEw+e3f9vQ/HPAzkdBzzWxS+dsSGeMP9HU3
Q6iBKgXHN33gtS/9Ilp0vdKPqUL/tyxaj1GpN29GQk7pmvgrcMo56bbBXxwjBdCt
UNbJk0T9PfJp5v/9J5y6sgpTlqs2ztYMsjcSe+EzHsBHHzCdGEZhzNPPVJw9S8M4
bu6J9Uhh6ee7xH7PJ+Zss0YnVA2K3hfrY7JP8vglM+Ol7PnEKKQxjNe/TGNSxlEe
2O17uQTyHll4Ne4vBQUhI8SOMEp+btMdncOr3hv6nzmMs39117dwqQIpL2znthN9
qdg66X1Jq3ZCnj8PWQdM
=olFc
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
