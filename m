Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651AbaJ3NUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:20:41 -0400
Received: from sauhun.de ([89.238.76.85]:35894 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932774AbaJ3NUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:20:38 -0400
Date: Thu, 30 Oct 2014 14:21:36 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: Re: I2C OF IRQ parsing issue due to probe ordering
Message-ID: <20141030132136.GA23852@katana>
References: <2287003.09eTeKUr1V@avalon>
 <20141027125819.GA12641@katana>
 <20141030125645.GA19386@ulmo>
 <1441244.9DO8HMds24@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <1441244.9DO8HMds24@avalon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > See:
> >=20
> > 	9ec36cafe43b of/irq: do irq resolution in platform_get_irq
> >=20
> > I suspect a similar thing could be done for I2C.
>=20
> That could work. We would need to introduce a new i2c_get_irq() function=
=20
> though. Wolfram, would you be fine with that ?

I'd think it will look pretty similar to platform_get_irq, no? That is
fine with me.


--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUjtgAAoJEBQN5MwUoCm2kEUQAJMwlni8AXCmzVG5wNPuEZHJ
DLfxkUzXyDoOB0VLMlVcPHoaoxpZBbgzOhS1ODFVtfcoTBMmjWN4Xq5SR5BgeWxu
BHfywPFgxdGKBKYqeB0wRMOhhVyhU112XgOYQHhJhyTQHmkMYrHjImrX8zqc2KEQ
lpQhUCVawaVQd+fE+CTkDkAJozGHksGGA6HA/lg7JF2e0EfSVmcLUITLpR+aHFCc
g2GZ95VVJDH2ISgaEpf1Az23UJcy2xczsew6hAPrhNBIMlXsEmTUwJxvzA6F8JwS
4zVKiKfApguJioYRnKU6q8X6FtBsn0h1JYVDzn+f0tdjBtBiLQxJ5mLuKopCdWCr
QzgvITd8xCoHYhjRSmVBBMYTC19tjqhZoOR/HNZliXRwpONDLJNVEbDQYj42CLcr
8Eo9TDcu2hDeXY9FqPg/SI4KSYBow5OwDQs5uQ6jEiBVrhm24OX0shbjx4NZ3JKf
0RPyCuJGObbuLixN++4R1H2o82HSxO7lmTdFnVqbVHGjuLZ6LoeMxn0yIe2l1DQ6
nCB0YG0fWPbSz0+vWp4hi4PkWe5jf3iITZ+lDus9CfENy4Jz/UjmVZ94FPHIVW2g
mDMcig3Koh19Fe+OkXXGhL4CZFiklzHJN55Iic4wFKH5Ws0gbCgyg7jS/cFyYO3O
oZHOptiqZcmCw0AzCj+J
=fJtU
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
