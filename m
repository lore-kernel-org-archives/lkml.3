Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbaCMVjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:39:16 -0400
Received: from sauhun.de ([89.238.76.85]:56940 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbaCMVjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:39:14 -0400
Date: Thu, 13 Mar 2014 22:39:12 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Richard Weinberger <richard@nod.at>
Cc: "open list:I2C SUBSYSTEM" <linux-i2c@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/28] Remove OF_I2C
Message-ID: <20140313213912.GG2696@katana>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
 <1391971686-9517-3-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iJXiJc/TAIT2rh2r"
Content-Disposition: inline
In-Reply-To: <1391971686-9517-3-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iJXiJc/TAIT2rh2r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 09, 2014 at 07:47:40PM +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
>=20
> Signed-off-by: Richard Weinberger <richard@nod.at>

BTW I updated the commit message to be more proper IMO (you didn't
actually remove the symbol, no?)

=3D=3D=3D

i2c: Remove usage of orphaned symbol OF_I2C

The symbol is an orphan, don't depend on it anymore.


--iJXiJc/TAIT2rh2r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTIiWAAAoJEBQN5MwUoCm2zPAP/RONybCvGyGGTGtYtG9upL1F
rMmZmycu8Pwgin4yZhof86eknUqY86wFDRlanZRAIwBuzJeHIiXlihyWID1CXjeO
tzO0hZadvQYv6iP23Fxt1y8tSr8FKiSDDgyHbxCyyVi9i4sSd+WO+Ek3PX9K9OIm
Xcf1HhWGpp4j4/mE7DVXzfDS3aRfKzH/feRvbCwCLkwzs/oRj+JNuGjPwT6iAOoP
aACAf247zv0DSgD4yOsyxd4SZNCDYZycAcy2DUpYcY/JkLntfiy9fG7d+jeOclvt
pQuXrlffj2AdmiJojZHAPYxtyHHLXJBA+Tw8WRiH6MGjRsJDEEmy5dnLfgTLtEaq
m3HuDyrM5GvFQSlC1yO1+aIKVrdDl/3mbMrZXSwd9QU5QGSqa3OypiaM+QoGscuk
Icwq995uJzoVQZsDmqjJLKjSP8f/Yosz0oAon+fIKm/XrwGnTolbsKWB+OHYYfPN
wqJe6GQ4k097/0D59DG+hDx8QjQWL/Lcpkcfj490mLNXv6MfYX6X2E12j9aWkNqS
Mcxwi2wJAwvcH0OeY37xNeywYkATQDD0J+/oKRiWujkLxS2EBsIxOHHAfDzAaHOq
ivaDsKTnkMf12h12JCTrsoJPT8CwaX6jYidfXCaqEwxfZqAWHp2LkooRr1/Y/X+3
XwJZtPuZw4kX6NkchYo4
=+iB9
-----END PGP SIGNATURE-----

--iJXiJc/TAIT2rh2r--
