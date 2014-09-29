Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaI2KMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 06:12:51 -0400
Received: from sauhun.de ([89.238.76.85]:57336 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbaI2KMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 06:12:49 -0400
Date: Mon, 29 Sep 2014 12:13:19 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: Anders Berg <anders.berg@avagotech.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2] i2c: axxia: Add I2C driver for AXM55xx
Message-ID: <20140929101319.GB1559@katana>
References: <1411983159-4692-1-git-send-email-anders.berg@avagotech.com>
 <54292F74.2030209@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CUfgB8w4ZwR/yMy5"
Content-Disposition: inline
In-Reply-To: <54292F74.2030209@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CUfgB8w4ZwR/yMy5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> >+	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>=20
> Error checking on *res*...?
>=20
> We should *return* on platform_get_resource() failure..
>=20
> >+	base =3D devm_ioremap_resource(&pdev->dev, res);

Nope. devm_ioremap_resource does that.


--CUfgB8w4ZwR/yMy5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUKTC+AAoJEBQN5MwUoCm2kqgP/RQj10pzNWmUtFQ1t4kHk2PL
8Oa7mbWJsMJuoMlc235rH975KxGFTkD/KxDdo7YOUNM2d8ted+kQBZQTNnwmt8rR
EBAgDsYcbLYFT6tZaPua15P+DdBD+CMQ1jSj7c9yEqHQSCofzxrGLrSiJB+awbPC
Ode2yNX5yqu9HzULxeKZTF0LpAKm0SiJnCKA4ABt2omUT+ZUY8a9eaqsdlidWDSo
eATHxTmSM3CxIlMHmVDkRyntO51W1eEVuvXXIS8/iIhNbK6Piz0rD18fIDVTvcXo
66R/6o5OMB5FSchHH/FaIVdb7VPM2BwjDdvY4/x+dWGQnnLQzr6joFYV2kzE1gTh
nLeEO4o2zWcwRjqyMYV7mPe0UOYoR0jK/xG1q2UVMdTzHp5lXQf+cw8zcNTzdd/X
SNAbb0zLUq6T5z9MGHnXgSUL+F9ToArD1rIWIzR2Aof7C+R1c1LoCKuxE16+iJa1
CwyMLCvugSaqXAJGDs5Njmrtq2B4DecfOezYSB4TqAnDYtWwfjerQ2MiBuhFPUKP
BJLlVMnhd1zJyL5WrPmKxxFKcjsBBMJ7MDZOECJxQjGHWL6jZPKdWv6K1s7suXfx
iuHhyQoMHNOFdjDuFEAVLu1nTl8YmXbzknVjOzuZF/oWmFlbEhDHQk+ehj0Tulr2
D1UkJ9ogO2bRyIaMRSZI
=uHhg
-----END PGP SIGNATURE-----

--CUfgB8w4ZwR/yMy5--
