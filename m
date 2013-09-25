Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab3IYQGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:06:23 -0400
Received: from sauhun.de ([89.238.76.85]:50280 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675Ab3IYQGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:06:20 -0400
Date: Wed, 25 Sep 2013 18:06:06 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Josh Cartwright <joshc@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        grant.likely@linaro.org, gavidov@codeaurora.org,
        sdharia@codeaurora.org, alokc@codeaurora.org,
        linux-i2c@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: qup: Add device tree bindings information
Message-ID: <20130925160606.GA3377@katana>
References: <1377782873-31931-1-git-send-email-iivanov@mm-sol.com>
 <3A0F4153-1C55-4008-8EB1-D6FA60D87CEA@codeaurora.org>
 <1377797186.30358.14.camel@localhost>
 <767E9FBB-2975-4795-9C7E-69E302511FF2@codeaurora.org>
 <1378814937.960.37.camel@iivanov-dev.int.mm-sol.com>
 <20130910135907.GP808@joshc.qualcomm.com>
 <1378824205.960.41.camel@iivanov-dev.int.mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <1378824205.960.41.camel@iivanov-dev.int.mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > I agree with Kumar on removing this.  If we decide it is something worth
> > keeping, logic to support it doesn't belong in the QUP driver, but in
> > the i2c core.
>=20
> I don't have strong objection here, will remove aliases support.

When resubmitting, please test against v3.12-rcX.
of_i2c_register_devices() is in the core meanwhile and alias support for
of is in the core for a while, too. Check i2c_add_adapter().


--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSQwnuAAoJEBQN5MwUoCm2pZkP/jsr5BMM4uEXwLkMnbkIdV4F
ZhuY/Tha/5qPspuBWnKX7zERtQSwbIoIaZjebZaxdO4Dro2h1NGMLdDfD2asl0uK
sNYx6cJzipaHYY1QY4AYbvMwbTd6mh/ZHs1qvVxXdD4aiBwYuZVDwTLh9Q0F0EZe
vvRKiOy9V6vAhwMlj2Qznj65weSsxX2qvtqTLULSQiSCf/lfDPkk2959VcWrXOBU
tWJ2T2Hjf3xmEVjWpkS2ud/Wvh/NEcdcGtQ2KFkMUAplvCVDOIXPqgDyZ8dfxNGs
Y4kI+8lyv3zXeHp21HPq4eBGjPJO7UeScBb8Jb0NWE1KDamaMW0QIiymbRXjeU3D
nqwRSHsih7sz54gbGQTI9ZYg+/CZJWtOrE2ZfnuJfvIcJ6pBpad0/LuJ4hhF1kqv
pB7b1jqolc6sKRKSTwN6adBF8NTsnArfJKiIcBlNRZwjWZwVtpMpztmOOwvmfqfE
ZYdoXaxGlEfvNW9DpDccT6StjvYqShU4YBrnMeP+RtbKKgMsJuqIIiCWil4vBKC+
ggQor9vty73/4LAeuprKACJKRI7ExrH4tNctkYqsS/c+gy8ojPQrx7dtdK63zUJx
pJy7zdmRjoYovYGcdDkRV5+4V2kgBH9/Jvgf9E23qpeENs+hrPAjW3xxgdBiYOYU
rQ10o1EFUiJ0qstTjyD2
=bROv
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
