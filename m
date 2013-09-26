Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab3IZI2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:28:43 -0400
Received: from sauhun.de ([89.238.76.85]:58550 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756275Ab3IZI2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:28:38 -0400
Date: Thu, 26 Sep 2013 10:28:35 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: i2c-dev: Create 'name' attribute automatically
Message-ID: <20130926082835.GA3057@katana>
References: <1377966619-20197-1-git-send-email-linux@roeck-us.net>
 <20130925202035.GB4290@katana>
 <20130925211104.GA2784@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20130925211104.GA2784@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

> > What race condition?
> >=20
>=20
> Userspace trying to access the name attribute before it is created.
> See http://kroah.com/log/blog/2013/06/26/how-to-create-a-sysfs-file-corre=
ctly/

Thanks!

> > Have you tried this with two instances? I don't think it will work since
> > class_register modifies the class struct.
> >=20
> Half a dozen instances, actually. Unless I am missing something, seems to=
 be

My bad. Sorry for the noise.

> Anyway, the patch is obsolete; one is supposed to use class->dev_groups n=
ow.

Are you willing to update the patch?

Thanks,

   Wolfram


--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSQ/AyAAoJEBQN5MwUoCm2N7QP/Rzg91X9n1v4ZhEPmWg/Xbtu
d2qMGI/1qtnhIbsEYjml9KXWSC2wEb2rJna8WKHbo6YI6Fj6X1lXgAHM2u1vCogr
5Sb9X0C3/Nacmg6JCAGI4NXGZLF8ZucW5KnRpJlHYmTdCm3mnyS6yzn86QrNAGtz
P72je4GmgBm2U5M6KooxAt9JHNx04cUbZklih3dd7GbiMHuHUON7d6HXOokOL6RL
3T4Z+nShHIuDapeeOLEMmK0riq5uieSzO7vASWaAg6pFaMKipJVS4uXX4Xl5CBnF
vJIjEeXNjrGLXCkGwhsBOKaCu41sGZUBGIDlNSrInhcPM20PhnHfDAuTgHeMw5BF
k+qsD0zDR6ZfsJMBs6/kacLB1tmdgFMuI8444+c965t08CRkwvy4z5RGg0utnXy5
WvV6QCkmU/0zAc7e65y5NUPLCrwHPSVywnYKTqyS5Dr7JaUyDQITWwEm+m+7zR1/
JlAidKierZXAozdI2K9P9M6A6KhD4bIPMVHTIM3hnFB4OUzPsdu/FVOFJ4DEfykt
Q1AEphH1/b1WjY+EqGBfcq5bS1kbSH5sIHcEewcXqcqtNbZp0QWQKBQPlF6sHz3J
UoMeeSM0vq9qX42IMqlfZeBaKQU+olyBKUegdLD2ZPuUcGO44cJE3c/QKhKX9j5d
cxtLorJkfQIA33WVRqXJ
=OiO5
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
