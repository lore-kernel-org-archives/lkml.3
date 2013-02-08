Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946389Ab3BHMKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:10:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35133 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946332Ab3BHMKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:10:49 -0500
Date: Fri, 8 Feb 2013 12:10:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2] i2c: convert to idr_alloc()
Message-ID: <20130208121046.GS8879@opensource.wolfsonmicro.com>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
 <1360179649-22465-38-git-send-email-tj@kernel.org>
 <20130207152831.GA14797@sirena.org.uk>
 <20130207163247.GL2875@htj.dyndns.org>
 <20130207163958.GY4720@opensource.wolfsonmicro.com>
 <20130207165547.GO2875@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mln0rGgUGuXEqmuI"
Content-Disposition: inline
In-Reply-To: <20130207165547.GO2875@htj.dyndns.org>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mln0rGgUGuXEqmuI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 07, 2013 at 08:55:47AM -0800, Tejun Heo wrote:
> Convert to the much saner new idr interface.
>=20
> Only compile tested.

Tested-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Thanks!

--mln0rGgUGuXEqmuI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRFOstAAoJELSic+t+oim96j4QAIwyGoiFfx0AXtzhX+J/s/Ai
xKps/FPCmjYelSaWqV8mKvjDTdbq9zgynOCcI9thzd7l/BRWE+TuOnZpNSQLBtNQ
zS44xmPyPxIRTS412Yq3j2ZmVxNKG61D8vHL4d3aEt9pJqm+GkwVGJncAbT5MmaC
R/eKyvyW3uIAX1v11qqmGQyT+8DJP3AbGYQl+GEWAwi8HmFjZvhrtxSFdFsHcAXa
4CKqjaLMlaw0z3qL0kE2Rxt4UTJAgt8AXgmTk2WVET3c+tBeUv6mEfdUqVzuDQvl
aAsQ8qm+TUfCEB26pTwXDNiHYrNqaiu6fE0tOMTDEaiC8pM+JXOV9QO34c8A6J61
gqkxGmPlZ+uc4MlGIxhCdihdBd9C/U2SEwR5fLBxUXVcaVYmuj5xZdoukAqpJUnD
xsozXvihoBgBcQKO1hbx/J4jbkUwSSt6gppXs/RcWQt+f1vxzb9z9H2savg99Br2
vqkzOXkaDro8oOaSNiIf/x6p45/trm3xXd3ZL7rcazUbKWluMZhmL4BexNlxiSB3
rtYnonGj3BUloe35036b1i4V5BYwlNv6OVbF4rDcjIJHmIKWpi4V29qPOeCSbLoA
/rQFvJp+h+ypqG9vkOIqLGJ+dQQ2Umb94FXSDt1VlCGghl/pU/wDaAVT2iDLwt6W
fnOgPxSEfU2vZPdmLpe2
=DJLm
-----END PGP SIGNATURE-----

--mln0rGgUGuXEqmuI--
