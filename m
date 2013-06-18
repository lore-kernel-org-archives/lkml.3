Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab3FRP6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:58:16 -0400
Received: from sauhun.de ([89.238.76.85]:60161 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755764Ab3FRP6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:58:14 -0400
Date: Tue, 18 Jun 2013 18:00:16 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: broonie@kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linus.walleij@linaro.org
Subject: Re: [PATCH] regulator: tps51632: Get regulator name from i2c_client
Message-ID: <20130618160016.GD7718@katana>
References: <1371551413-12346-1-git-send-email-mperttunen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5gxpn/Q6ypwruk0T"
Content-Disposition: inline
In-Reply-To: <1371551413-12346-1-git-send-email-mperttunen@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5gxpn/Q6ypwruk0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 18, 2013 at 01:30:13PM +0300, Mikko Perttunen wrote:
> Commit "i2c: core: make it possible to match a pure device tree driver"
> changed semantics of the i2c probing for device tree devices.
> Device tree probed devices now get a NULL i2c_device_id pointer.
> This causes the regulator name to be set to NULL and the regulator
> registration to fail.
>=20
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>

The commit in question will be reverted. This patch shouldn't hurt,
though.


--5gxpn/Q6ypwruk0T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwIQQAAoJEBQN5MwUoCm2U/4P/18zTGYbn2Xd25diOXJ2o0O1
wYgVukDU0wRIwHDv6jLLu5mC7lswal3ezrZ6WOrxHgL7F/mA6kVkNyDgJp9Zc7h2
usMTZyUgBZUP6OuaIynW6+dOg2gFPsMR+efxoKor0pHzxURpqPauhouOSwQcSyfg
d2IHUQ7toAv7FipkRFUYY/Swn08j4poyltLpJT302BAluusPYplsLf6QuPXPvC52
iA3CzhzIZEYLNBGZo2xvRVKEUbrdl0wVQW/+XIQtnjidnxYrKsrhFCiOvSgVc0Ob
nPjQPyUjNs33AcxSb9nmRiju9G+gFBRsOBKRzhx4WYlpoTqsFdYi3EzOBA3A/F0O
tf077eW5onXiAqWMhS2YIyRoQvUFVy6jFIw6sI5GXu0wGRbaPduOSrSKvxWyxtPH
aYQA2f/F2IDyR5Y8Ucbba/Rv6+EwxseRsaQNhVXM0hBrqsDaLSdHWLjsKvueygtg
ck/zdpqNlZQyTudwG9NXtf50y13mm/9/wFW3B8fmqGrO+u0GgLf7qIyn5WF4DYk4
Zf4toJ6+4m6O69hPizKhjauub9Z11QdBrdRETBuAH2xHyh8/smyYVAKN5X12x1gg
asnPpVy/izjQnWb7KIjI5nCIAsbhyuBEUSFKtYNBatLiCNVbzLmKzp4dqnKCj2Vf
96GFeU9xZwxQGDD+6/la
=KLdN
-----END PGP SIGNATURE-----

--5gxpn/Q6ypwruk0T--
