Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbaILMO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 08:14:57 -0400
Received: from sauhun.de ([89.238.76.85]:33113 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbaILMO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 08:14:56 -0400
Date: Fri, 12 Sep 2014 14:15:10 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Marc Dietrich <marvin24@gmx.de>
Cc: linux-i2c@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean Delvare <jdelvare@suse.de>, Magnus Damm <magnus.damm@gmail.com>,
        Andrey Danin <danindrey@mail.ru>, devicetree@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [RFC 4/4] ARM: shmobile: r8a7790: adapt DTS for I2C slave support
Message-ID: <20140912121510.GD1930@katana>
References: <1410274470-12712-1-git-send-email-wsa@the-dreams.de>
 <7627175.tG5quZH0VN@fb07-iapwap2>
 <20140912095821.GB1930@katana>
 <1921859.32moD2F04k@fb07-iapwap2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BI5RvnYi6R4T2M87"
Content-Disposition: inline
In-Reply-To: <1921859.32moD2F04k@fb07-iapwap2>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BI5RvnYi6R4T2M87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > Am I missing something? Board properties can be encoded within the
> > compatible entries ("ax100-ec", "ax200-ec"...). I'd think this means
> > mostly different protocols, though.
>=20
> well, ac100 is the name of the board and nvec is the name of the protocol=
=2E=20

Yes, the driver could be named nvec, yet the compatible-strings should
be similar to above. From that, the driver can deduce the protocol
variant and possible initial settings.


--BI5RvnYi6R4T2M87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUEuPOAAoJEBQN5MwUoCm2+CQP/2133fSsmcvel6AnjbBLnA1b
WlICrWzG2ZpamkzbU2pGwQMgQ0mSfOTIHQaZmOqIJQAxz3zVGYYatLlXYEzn9qDw
XjNcHR81TGM+IoM5y3/02Yt8DEbGmqo7fiUIL/unzgjSlggyWfN+00MDOdTlvXfa
FkBbfc0drTK3xmxeK4fot5vBty/oNDe75nlB+GgLhj6QysPBWwMk5DCpwR54R50K
N/uMIj8TiAQHlng7BuoA9C7NkPAEZ1NqYI9rQJHKIN7GybZZNbtfDistL+uYog0q
KjxS4BcSL3rha2O2i4ATOUG8URBGJi5Dct7GwWGo4jkDV+Du5lYejBL+HQ2GDmdv
BtqklKnWynlx0+d4NBN6y9/EqM9h4eL5njzfuiCaMIHX9XfLLgxcOClSYt73GpVo
GH2IgpxAHY8u4g0ARXZRJKsfFQPWhfkWYMo/PnfHpTNbQ8HzcU9fptCo9q5fPw4V
bOid0iOYxIWXUhqyAS+AVawBQpaw9u0XGxYuks3/GJyvt6FCd/pZDn/j6Daqv90Y
TQrGrueOHgLjw38DiTm0cU+EeuSjqSQB10UDzu0ZW6LdLIm4hGtJc7XpaYUdzBY0
CXUlyY1tch4a+N035jYQZ637U1SJ2D/HmFdkMfS4V46WzZKxmOsNcDzjpyt4sf10
fI3Krrcbh9NsXRUEFkhI
=BXAr
-----END PGP SIGNATURE-----

--BI5RvnYi6R4T2M87--
