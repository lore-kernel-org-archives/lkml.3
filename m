Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685AbaAaPVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:21:39 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53325 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932307AbaAaPVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:21:37 -0500
Date: Fri, 31 Jan 2014 09:19:55 -0600
From: Felipe Balbi <balbi@ti.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: <santosh.shilimkar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <ivan.khoronzhuk@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: keystone: switch to use runtime pm
Message-ID: <20140131151955.GB20736@saruman.home>
Reply-To: <balbi@ti.com>
References: <1391174426-13773-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline
In-Reply-To: <1391174426-13773-1-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 31, 2014 at 03:20:26PM +0200, Grygorii Strashko wrote:
> The Keystone PM management layer has been implemented using PM bus for
> power management clocks. As result, most of Keystone drivers don't need
> to manage clocks directly. They just need to enable runtime PM and use it
> to handle their PM state and clocks.
>=20
> Hence, remove clock management code and switch to use runtime PM.
>=20
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

quite a few weeks back I sent a series enabling runtime pm for all glue
layers. I'll use that version instead, sorry.

--=20
balbi

--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS678bAAoJEIaOsuA1yqRE89EP/j/qiApUuMpuepDhTfL+ZIBw
2Agy7ujyy+CfkBIUqJ+tBKD657KqPxBkjmj4OCXoECmpXUVJEjy/krQCbKbcg0cI
CHvi/El7Ye5ejRdVwgFRxV6s8xZG08pjgqO7zQTd5W7dh8TJPPkgu+jun+BodeG9
DK3APuyGGVnC3I/iEMJ9BL+NQKg95l1nMz+zZ5CpWDgwpj8p07L9nXBYxKHz1msO
tUHFL2vEH8uXJRyjr9dh3zes95thhQsDD6uQFcrywI3VgGZEQYySM7JaluBqsslt
XV8xeW3PUY8AR6t/LKhu7qefJZ/6xumy2/WxN2Mq7K5zgzppHMcgU5h/Lah7tDYv
Dore6lEdoyUbBEiawMMaj6XKFn3wfeS6TTQPiDQIqoaD9GnBs4rJ4YvKGx2RJw53
zR0UpAZ9pzX1/v2C63WCJyLepZ2zdazR4V+qL528tTcIjJ5R324D0iT6LWO3JMHu
Vie2liZUlmSS07J0uGChEdYNVrhdIQaipBH0ex/0o6LubGYfI5MWq9DfiGDbPxhF
CC2jeOqyfiSGSLTnTch2kBNj2DkwsawIkTz9VhABn9Pzgb9JfX3u1omffthejllJ
ZNdSoJrQLOQk2D5wKcc0uF8bikEWn0zV/M7Ms+qvq4TEEUpTEC86UVBL0E4K93vG
maCaGVEMz/W9o0u13pqy
=mqX4
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--
