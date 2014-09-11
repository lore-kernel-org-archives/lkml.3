Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbaIKLfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:35:47 -0400
Received: from sauhun.de ([89.238.76.85]:51795 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbaIKLfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:35:45 -0400
Date: Thu, 11 Sep 2014 13:35:48 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Nick Dyer <nick.dyer@itdev.co.uk>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Lee Jones <lee.jones@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "Bowens, Alan" <Alan.Bowens@atmel.com>
Subject: Re: [PATCH] Input: atmel_mxt_ts: Add of node type to the i2c table
Message-ID: <20140911113548.GB5149@katana>
References: <1410249158-18192-1-git-send-email-sjoerd.simons@collabora.co.uk>
 <540ED495.20609@collabora.co.uk>
 <20140910092832.GM30307@lee--X1>
 <1410422429.2857.16.camel@collabora.co.uk>
 <54115F6E.3010007@collabora.co.uk>
 <5411693A.3050300@itdev.co.uk>
 <20140911110829.GA5149@katana>
 <54118687.8040802@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
Content-Disposition: inline
In-Reply-To: <54118687.8040802@collabora.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > This is a workaround. It would make sense, however, to add it because we
> > want to support i2c_board_info structures.
> >=20
>=20
> I think it really depends if an IP block can be used on non-DT platforms
> (which I think is true for this trackpad) but if a driver is for an IP bl=
ock
> that can only be used on a DT-only platform (e.g: a PMIC that is controll=
ed
> over I2C and is only compatible with a DT-only SoC) then I don't think we=
 need
> to support the i2c_board_info structure and can get rid of the I2C ID tab=
le on
> these drivers once Lee series land.

That is exactly what I meant. It should be only added if there is a
reason other than "workaround". If you say, it doesn't make sense on
non-DT, then it should not be added.


--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUEYkTAAoJEBQN5MwUoCm2LhYQAJziqMlFB0VpGXDHW4jwJLne
ZNO9Zs65dd1TG+sUJK+jSCGaWeO6BOdNU4AdDHzAIvouKrjUou5BaenD3L7z8nv5
VjqWLL8E3h1ip2QRJmtds0KsuZBFkYgEOI6AxiJ7NnOgSTSMI7/wDkB08/HdFNu7
GEEfMIo9rftaChPwss/kuAQ3LOVMXvIQ721k8Fy2yWVQ6a6dwS0kZJTiWtVR1ZnT
E3ObOESY43+OsRJcskiYN740Aq1cyf9l6PjmKaHzBspE/ZEPQTDmaF1gwtYnF5Fp
AOTabZit69orHS41WXTaB34fnDqp3Qz+pA7T1OnuVoGo9ZjvbnvCph48Elm8hPeh
U5cq4FdF8/9nHlZYnfDmDMjI6CQzA+EapFAzp+6XMuVvIuCu60TXNRpB2xeEaPmZ
jMi3WYC/2VdtB+DOHJkrVpzCKYgNc1mELz8tAVwP4qMsvBTvs0F5xRkuxLzXdXn3
8pItbVd2cS+/7N+AAa5jXbS4Jc1PlKdU24dLdl7YZCvohLmkoDhiNlVuuTWdD1a+
2iTmvIMj7GI0OJdfkWIWu1Uw9dt3RIoEbg4BLIIlP7yPiYjyemkaehphZO25MFo7
akYjmxvqQPlofcJnsCCRqwjx97AQ4b3dndYBVUIEayI34dVfiR7bI9pEzCkTf/sr
ZPd2zEOB99WvmA3BP+75
=5Osf
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--
