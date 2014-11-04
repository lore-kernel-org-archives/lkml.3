Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbaKDOkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:40:47 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56705 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaKDOkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:40:45 -0500
Date: Tue, 4 Nov 2014 08:41:16 -0600
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: Felipe Balbi <balbi@ti.com>, <myungjoo.ham@samsung.com>,
        <cw00.choi@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>, <nsekhar@ti.com>,
        <grant.likely@linaro.org>
Subject: Re: [PATCH 0/4] extcon: gpio: add DT support
Message-ID: <20141104144116.GB24983@saruman>
Reply-To: <balbi@ti.com>
References: <1415032350-8459-1-git-send-email-balbi@ti.com>
 <54586E34.6090602@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Content-Disposition: inline
In-Reply-To: <54586E34.6090602@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 04, 2014 at 11:42:04AM +0530, George Cherian wrote:
> Hi Felipe et al.
>=20
> Another series was posted by removing the platform support.
> https://lkml.org/lkml/2014/10/14/244
>=20
> I guess I forgot to copy linux-omap.

you do too many things in patch one. I wonder why you decided to combine
three patches in one for that series.

--=20
balbi

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUWOWMAAoJEIaOsuA1yqREVLkQAJAxPatL4YsmCE0YGJ6wDGCr
jRykXTqbxwe4E1JknLk7wJNHoryzimgmvbNMEu/RXfWKMVc5TQGHMTVjY1lhVF+7
6hP0Nu9nM1nJQM005vFnkiwCEBJ1gDDQHKSiZjf0AhTiPp0qJU8bh7ZdjRvQOSV2
slcLSLvZo1ZoLxmoXY4tOtPkn1M2kXWdk3zZKa5bC07osO7MmREsO3P6tUuYPSYY
zt1PbdIsVvOx/cV5ZBl11ceWQY0vIBbVrOq0qQps4yk+CFqfvM1tXqRg8fNUwEDU
3zI/S7Rm1paAaoOv68S+pZ50+Ie33gNxcIx94pti2nbvEvPVEsoQoVYLmoYWDh1i
NbKCvhA/t1PdBE8oVu7jcpb1HvP0Wg3II3SaKYWHyf6tDLvnfkSqeMGR3QrlpBAn
zw2sPvrvdr19X+ta8ehRAzAg9nBQF2E4WLrJ26IQiRQbmJxzwdvYUk5nuOR1BShY
qv3l+yv7CI82zaO0YHZ8uz2l4X+BULITVReC7j2QGy07Bdm8N6WHN9amkmq9frFy
O1zM5mBIhT1vfZzM70Efig5yNdYhkcRIU7SPABqNlAmk6zHJawKmVpplVSJZDGIE
tSwxZYzcKDbd2o+quIC7Ksj8MojvNdQ59rcBQ1ueEVSEjmhVjs0bbZtxnXNTTiMQ
pxmAdrkii0m8HdckJ0Oo
=c2JS
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
