Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbaENQAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:00:15 -0400
Received: from sauhun.de ([89.238.76.85]:40912 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbaENQAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:00:13 -0400
Date: Wed, 14 May 2014 17:59:56 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Olof Johansson <olof@lixom.net>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: s3c2410: resume race fix
Message-ID: <20140514155956.GD12911@katana>
References: <1397254781-23833-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cHMo6Wbp1wrKhbfi"
Content-Disposition: inline
In-Reply-To: <1397254781-23833-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cHMo6Wbp1wrKhbfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 11, 2014 at 03:19:41PM -0700, Doug Anderson wrote:
> From: Olof Johansson <olof@lixom.net>
>=20
> Don't unmark the device as suspended until after it's been re-setup.
>=20
> The main race would be w.r.t. an i2c driver that gets resumed at the same
> time (asyncronously), that is allowed to do a transfer since suspended
> is set to 0 before reinit, but really should have seen the -EIO return
> instead.
>=20
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Applied to for-current, thanks!


--cHMo6Wbp1wrKhbfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTc5L8AAoJEBQN5MwUoCm2vFgP/0MjLUA5uWZlKqPPkRI5e+5z
w3MXFVk/aRvsMro2PRwOca8Q022eL5fCl+E4PUabd4H9VNxQf5RGgcVWQgzzJfrP
QwHHYXprGH/49cLi2UU2CXiVP0O4W9s4d2nnftx1yxmj+9NenVfI49g2WMbdqeuX
wu/meeitdyNqTARTnygM8YwRrqF6Q98gi+br8ZAiC6I9lLBojwl+/yIUpvC8JmpM
bRd4AzkNmpQYcP7tx4J6z11Bg9ycSdcbPYACFVOnc2RImxLoGKVAPwBEwDiirSq/
sgQxi/c28DYpAjjlAzLig0iPlnHrzNA6I8492H+c7dLuWp/X5O6wsaXShsnz/HRX
29P3riUf3Q0meQY1V+J06437Cf7KtU4fXmCjl9mfvYs1ahSX0IGOdNxc9NdfOrXs
yFpOURI+zuI7UizyT3t+i+KOiDt7HbpVlG0EHT4zE2YTObP0Wa8qRmBErVPUExqd
3iAP9EfUxKEAYIHvAeI5YnTR7hy4dV4Lg4piwUEykgwwtA/hr0dWmL4n7Id3W+ps
2IXT/XL4/Huq8jFKWBx5iVyEiHdR1QYd1J6i/hI7QgteIK7l2fH06qx4LnXcNbpt
dl51pfuX5B2zHeJJpSQoP/+LeLHAPs8Kbpy9dqTg4ezEHVY2Ppe0Gx8Q56kLx40a
8L1dPbOsOZm2vpcNvLB+
=xQeO
-----END PGP SIGNATURE-----

--cHMo6Wbp1wrKhbfi--
