Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaAWRZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:25:43 -0500
Received: from sauhun.de ([89.238.76.85]:37892 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbaAWRZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:25:41 -0500
Date: Thu, 23 Jan 2014 18:25:34 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Laszlo Papp <lpapp@kde.org>
Cc: Curt Brune <curt@cumulusnetworks.com>,
        Thomas De Schampheleire <patrickdepinguin@gmail.com>,
        gregkh@linuxfoundation.org,
        Shrijeet Mukherjee <shm@cumulusnetworks.com>, wolfram@the-dreams.de,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Add at24 based EEPROMs to the eeprom_dev hardware
 class
Message-ID: <20140123172534.GA2665@katana>
References: <CAOMwXhMVgcVVWiUYbEgGcM+K5bZmKA3LO0=jZCEsyJak1TbTSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <CAOMwXhMVgcVVWiUYbEgGcM+K5bZmKA3LO0=jZCEsyJak1TbTSA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

No need to quote the whole message if you reply only to a bit of it.

> >  module_init(at24_init);
> >
> >  static void __exit at24_exit(void)
> >  {
> >         i2c_del_driver(&at24_driver);
> >  }
> >  module_exit(at24_exit);
>=20
> Couldn't you use module_i2c_driver() instead of this?

He didn't write that code. It doesn't have a + at the beginning. He used
the whole driver as context, which is highly unusual. A context of 3
lines is usually good enough.

>=20
> >  MODULE_DESCRIPTION("Driver for most I2C EEPROMs");
> >  MODULE_AUTHOR("David Brownell and Wolfram Sang");
>=20
> I would personally put your name in here if I were you, otherwise
> David and Wolfram might get contacted by some people instead of you
> (at least based on this).

See above. He changed only 10 lines. Not enough for copyright IMO.

> PS.: Fixing the broken i2c mailing list typo, and updating Wolfram's
> address from the broken (obsolete?) version.

It came through to the i2c list? What was wrong?

Regards,

   Wolfram


--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS4VCOAAoJEBQN5MwUoCm2Q+4P/0syFsu28rnYJF88Yb1p9gCs
+f5C/fWMVgG11IKKp0HvbNzdrhtUisQK5hRN+U5ofCp5gkGIb7TRncFlxiqYeuXV
C9SzpGWBiTBxiuzkagJrsvm/JKn0e1GferpDZKEHRpdRsLXYDqXtZpbnONUE2sV9
MEn4cYnW8CfH8+glETMokOY7Ec+1XZgwLmjaGgIa0G4ZekKQrl9DqxT5DZGNwyOo
oAB45+l9ZcgCzT5ldrApogsBrlwqbLdTKpu35PrtOvGnGSWZHMsTCqj9RDpArg2V
pR1m4F4quPYqV3AegsycyI8eLDC7U5OtFqA5JzSOYCvf9k6/uoz1cLbqWl1y4HWr
144lh/aSKeVHNlD6C8PDYuIc5g6rSGRM4LaKkiowzLH2BXm77YWcxZN+24+9bsVN
UGsjJ4GNB3VYkseq7aHp5M3Donu+3mSh75veMGUT8+r5T+msgUAXQqTABXWuPW5G
T0bwK2aFC6+xvMLQ4RMotejhHjqxBfObuZUYoUNhSPXorzsED9zjK27DchKfO4B9
ep8oUnne3gNRA5R5i96Xc+wKXgc6XLyLm0QZGZIKfICyRvkcdq0ySl8rkTARLyYz
JNVzzmo6r8iyDqMLJqcM0qHA5aExjSyCIkiIG4U3hVA7dMqt09H7rA9iXBgZcVPx
IRjuIEpGW6OBjlVOslKX
=3TrP
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
