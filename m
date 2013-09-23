Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab3IWUoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:44:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50198 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab3IWUoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:44:21 -0400
Date: Mon, 23 Sep 2013 15:43:49 -0500
From: Felipe Balbi <balbi@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <linus.walleij@linaro.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 30/41] usb: musb: ux500: Don't supply a con_id when
 requesting the clock
Message-ID: <20130923204349.GJ309@radagast>
Reply-To: <balbi@ti.com>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
 <1379506478-16625-31-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HBg0C3yr6HVa1ZCc"
Content-Disposition: inline
In-Reply-To: <1379506478-16625-31-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HBg0C3yr6HVa1ZCc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi,

On Wed, Sep 18, 2013 at 01:14:27PM +0100, Lee Jones wrote:
> If we supply a con_id then the clock framework will search for that name
> in MUSB's Device Tree node for the 'clock-names' property. If it's absent
> the clock request will fail. However, if we don't supply the con_id then
> clk_get() will call into clk_sys() which will use the device name to
> search for the appropriate clock, which is much more natural than forcing
> 'usb'.
>=20
> Cc: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

fine by me :-)

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--HBg0C3yr6HVa1ZCc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSQKgFAAoJEIaOsuA1yqREuRsP/iGjHS+Rf8dQbmG52l3WCSrZ
+YIgJRBKuc4orhNdWDmUVuoJHLGddosx5cWtBOWGaCaDSLJPHRNgu7JDX3VMrarf
g7R+VtJ+Km+rCE83gdrJUHjgPgVyitT/VxocCpG/VJJDFIv/F85XhWkJNtl7gZFy
EgwVkqd/augruM9tYb5ZQygxXVkYGK5LA2OcylIYi6VXM6gyaMfOEYcY1EgetaEv
r+Y5/jQ5wuPv6bP96CskK+3PDJ7Z8RZdsXivDVOMFR6gYevfhvCnJJlQBveUPwgz
G8P8J265NbjbNqsvEeDBxMnNGtG9dWM2AqVlwaLJTAYALXJT7rtsA1ZMDMcTJi9X
Gq+PV1fUNgpKCrSmcVKV+7HjZbYfLDml3FeYnUJHizejMyLHJRHcBM/pEMpJtvnH
SzBhkpyVWhUJT+s2FaiRCU8nnGTBTGYU2SDd3Xva5QwklJqBJgRue8xXiyvd6hyb
C9qmLAJ0aryjZjYV+3bPk1H2YWbZIshwsBxT81IPpVIe5NM4EEMqwcZyMzHahivH
jqCOTUY2FZ2R1pE9c5eLmaw3RsQXVzwQO8m/wCSEJhzvK4XQH1b2WY/MSsph3ibU
z63CdQ6yZ7K/qtjslc9e3M1SgFq0TIqYAMjMd6PVZhNJw5l97iUp3mlfKW+YjRUf
Ify4cKI42oZw2nuZcxU4
=OzSd
-----END PGP SIGNATURE-----

--HBg0C3yr6HVa1ZCc--
