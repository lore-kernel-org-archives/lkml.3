Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab3HWUL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:11:56 -0400
Received: from sauhun.de ([89.238.76.85]:55545 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755975Ab3HWULz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:11:55 -0400
Date: Fri, 23 Aug 2013 22:11:49 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: Re: [PATCH] misc: (at24) move header to linux/platform_data/
Message-ID: <20130823201149.GA5640@katana>
References: <20130823190247.GA3821@katana>
 <1033284781.908504.1377285587778.JavaMail.root@mail>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <1033284781.908504.1377285587778.JavaMail.root@mail>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > This message explains what the patch does but not why the change is
> > wanted. I'd be surprised if we really want *all* platform_data in one
> > single directory?
>=20
> IMHO it makes sense. Why wouldn't we want all platform_data in
> include/linux/platform_data/?

For the same reason we don't want all driver source files in one
directory? It's a mess.


--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSF8IFAAoJEBQN5MwUoCm2rVAP/2t+HLu2dUEAB2dYqb2vz+4B
gT5UTnfIay+uMYV72N8BEZeNqMUUxHwzz0n27T1nUP4YrSZ3X0LfzsqwyMyF2Ao4
y+VWuzx/d8SBeqOx5NLs+mer/C5wlMvAg4uaWMU40QbLBJi+lkh9KERsuV2AI5OU
4KdS6xH34JLytm/71p7ODiLif3TeydCnDq/APwm/gxnXFY3xbtcdbBWT4eZ6w8kQ
bGDI9gkJdZ0FvKsEn5qvHQfbaXj+8oYf2Y6WCDaii9AhpwUPUpbFphNAtzUp3zzN
FDYlqZ3sRe5Zo2EJnF66BIctlbtsajfXNLZMR4ILiAp9/eVi4I6GsKQHZt0AoWuG
fpUXl+HCB6jS1g7eagTWNJjE9vOPANNISN6vMlC4qrCkIIXFYtBU/QXQrVWId/1J
5aERvdBn9SmIupFGtbtJxKICVxPHfANJeWXaAGtvreBQe3WkZR6YfhthrHTA3Wv6
opSwBENLdEmYBKC0Hqr8wW0bMTVaZFEGCnpFxz2T2aqr5ePVHBa8sB3MwSzjUM0Z
useSGJWYbl/vnv0b5y8N6/f7VmADedejNYf3IOjpw02uklnvsrEQptsNcYEJibUS
xgaqcKTJ9gS2gM2noJK7pbh0fXg27ICXWWObrruE8MDem+cHCY2bXiYvldYpMDrB
/eagJsI2Uo9CZ8LEkH2t
=hLge
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
