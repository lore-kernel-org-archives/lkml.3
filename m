Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbaF0Mex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:34:53 -0400
Received: from sauhun.de ([89.238.76.85]:52104 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbaF0Meu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:34:50 -0400
Date: Fri, 27 Jun 2014 14:34:43 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>, Dave Jones <davej@redhat.com>,
        rspangler@chromium.org, sjg@chromium.org, sameo@linux.intel.com,
        wfrichar@chromium.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: cros_ec: Remove EC_I2C_FLAG_10BIT
Message-ID: <20140627123443.GC29156@katana>
References: <1403558406-14519-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H8ygTp4AXg6deix2"
Content-Disposition: inline
In-Reply-To: <1403558406-14519-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H8ygTp4AXg6deix2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 23, 2014 at 02:20:06PM -0700, Doug Anderson wrote:
> In <https://lkml.org/lkml/2014/6/10/265> pointed out that the 10-bit
> flag in the cros_ec_tunnel was useless.  It went into a 16-bit flags
> field but was defined at (1 << 16).
>=20
> Since we have no 10-bit i2c devices on the other side of the tunnel on
> any known devices this was never a problem.  Until we do it makes
> sense to remove this code.  On the EC side the code to handle this
> flag was removed in <https://chromium-review.googlesource.com/204162>.
>=20
> Reported-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Note that this patch is based atop my current series of posts to
> cleanup cros_ec.  It wouldn't be hard to apply it to the current ToT
> if someone wants to land this before the others.

I could take it into my tree, but I think it makes more sense if we
simply append it to your cleanup series?

Reviewed-by: Wolfram Sang <wsa@the-dreams.de>


--H8ygTp4AXg6deix2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTrWTjAAoJEBQN5MwUoCm2DUoQAJ7Aqzg8lP8lxIsZ0BgxGOvH
N8AzHieczg7PrydtTJJHHIWPn9ICpnN2sk3gyp1sNJ58VsO66rMgA3rzTJ0piHGo
Z5iruUqQPijOE2jRwSdHRMhw6wYUWZaI2eT/tw25O2jM0UesrESgTMuvd/FV0lvE
wBUU4EmcoG9LZSrHOieHHNIje0GJxshIJRbGsIrmb732w6iuRvix3sBqKTHssLTG
eWfW4UOC5TAqNLY2XmldtlFxvGrtNDl7c1LCLJcmT153hVeWkNaVQB7UcSl5jez0
stQUST29mmHyGFJEpVrPLG84jQMCColABQ64renxLC/Mnl32/QjyELn5czv5lJod
8wV7+SmshEz11Vj1TVqQa+TuAO+h5Smxwx4ZbBYoWQ0e5gL5K2j5dUuKgA87FuEj
axOCfDWFbUtE/9l1uC5aXDlIfV8nBbAeI4pGagu+b6ioH1fUJWvJJRqlrqf24jCJ
jwSxkYSqLDBwfNqthO2RcSr9JWfKHy9+Y/SryzB8G8U0cNvpeMmTpYyx4W/tLrz3
dtdN6nzQgQNDQR9ThaPzGkcyXtxybZdTDTtqE4ilycPDabw5ZLVhgFeVnv+waUDC
AvLG2E3XORJQE4hS5kPEXu/a8yTAqA01aBA+7A2MrRbX07JzQNppRP5h7Y/2tMo3
Rat0DN6oJae6XpVanEZ7
=9Foo
-----END PGP SIGNATURE-----

--H8ygTp4AXg6deix2--
