Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbaJOWYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 18:24:55 -0400
Received: from libra.uberspace.de ([95.143.172.171]:52855 "EHLO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaJOWYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 18:24:54 -0400
Date: Thu, 16 Oct 2014 00:24:47 +0200
From: Matthias Beyer <mail@beyermatthias.de>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcm/CmHost.c: Fix noisy compile warnings
Message-ID: <20141015222447.GB20142@fu.3gs>
Reply-To: Matthias Beyer <mail@beyermatthias.de>
References: <1413375999-10210-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <20141015123431.GA23154@mwanda>
 <20141015125934.GB23154@mwanda>
 <1413378213.2412.13.camel@jtkirshe-mobl>
 <20141015214151.GA20142@fu.3gs>
 <1413411584.2412.35.camel@jtkirshe-mobl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
Content-Disposition: inline
In-Reply-To: <1413411584.2412.35.camel@jtkirshe-mobl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15-10-2014 15:19:44, Jeff Kirsher wrote:
> I will just go ahead and create a patch to remove the driver.  Greg can
> then decide to either accept the patch to fix the Kconfig or accept the
> patch to remove the driver.

Don't forget the maintainers file :-)

--=20
Mit freundlichen Gr=FC=DFen,
Kind regards,
Matthias Beyer

Proudly sent with mutt.
Happily signed with gnupg.

--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUPvQvAAoJEJi+S08gyg+UBwQP/1m2vxO+2bX9dYV0wUK8Vv+M
bUJkNXy0+GPhefCyYuZiDxb+M3V5inV6O8fkJ6WG79j87KXWTT6GAR1+S1DjiDXq
VxguXAunlatwIJAnswwl2Q7U0hE/EeC/cICF3lg9KI8hle7z0PkRHbGIjfkjqsMj
MiDtRDzJnobqIAZRDpOFOtkA8RIy5YcEKcf9HVRBO6QNddMgVt69yiuDzPflTWPx
am5TurZuItSuH68Yo4GSAnCatHAoKF0/03bKm1Qygf5IZQyv+ISqpO/QhnjhQGQz
CYTGQS6fq+jiV034riM31+oAp465i8xMFL9i5qVvp1y+g1zOUAx9GhgdGA1LlB7R
cOu3+vK+99OwF1Bt9niz5jTR5+TQj+1lLiNk3RDLeov6mVq+NDPo1PQPcQ1idrGZ
tCTKJDk6Sx3YL7+XpaREC3uKlub1ubQc93lQPuBX3x7EFFwxoiokvqY43u73wKvy
o8qmxVTJOs574Kt+viWZIkFAtpO4nSHWKQzVxECLfFRUUHN8yEfTOGI+XpE5HoTt
R8Lz7nN5qV18SeKJ/lmRB97Vb2CvefGNfTG7t1CozLw6kePp3wgdaQX1XOyyDIvl
pW9ccFrY+9lfnbnY40nX1LzUh5aOh1I/flN1BAvxZjWOl50PwORptsYM31GiKQR6
rXqnIEKEJCsCQHaCuCy0
=LyEc
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--
