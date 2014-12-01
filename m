Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbaLAQEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:04:52 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48171 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbaLAQEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:04:49 -0500
Date: Mon, 1 Dec 2014 17:04:44 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/1] GPU-DRM-MSM: Deletion of unnecessary checks before
 two function calls
Message-ID: <20141201160442.GG11943@ulmo.nvidia.com>
References: <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <54748541.4000600@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QWpDgw58+k1mSFBj"
Content-Disposition: inline
In-Reply-To: <54748541.4000600@users.sourceforge.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QWpDgw58+k1mSFBj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2014 at 02:33:53PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 25 Nov 2014 14:30:28 +0100
>=20
> The functions framebuffer_release() and vunmap() perform also input
> parameter validation. Thus the test around the call is not needed.
>=20
> This issue was detected by using the Coccinelle software.
>=20
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/gpu/drm/msm/msm_fbdev.c | 3 +--
>  drivers/gpu/drm/msm/msm_gem.c   | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)

This needs the same fix for the subject prefix that I mentioned for your
other patch, otherwise:

Reviewed-by: Thierry Reding <treding@nvidia.com>

Perhaps a good idea would be to send all of these patches with the
subject prefix fixed up as a second version and threaded in a series.
That makes it easier for people to pick them up (assuming Dave will take
them directly).

Thierry

--QWpDgw58+k1mSFBj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUfJGaAAoJEN0jrNd/PrOhN+UQALVA1kASbmuvB5PKw9VO0VaD
tgKT4rQ51vWVQ2bUjP+Y2aRT9BPgHPOQT0tFfpq1R9/saHTsZWD0PgHhtDCERtVj
T0bEvP3UTCVkONIg9UDkwSNEai+uqpgw3XG6H+T2tx5sxLpw/hsPwm/sRYih4ngk
j9faUAbACpLoq9sY72a3mWLE0DL0qQUJuOCPQNOb3iWJFCEME9OHUNMLc03ROVb+
mIlGZ+ELUOz3kIetiWI/DV6GEVXYuYUKR5LuD9++hxxYiU7WhSHfqKAknoF5uzvH
G6JLThIg7Urjth2D08NTC7t+jMd5FZbN6Ua0xaLpzVdCgAk9yQqgPV3/5wQeeUch
nJgpVjOLeSjIlhP+VwnXVowkAN5IIhNIxkPlVF5rc+WOaKbh3beejNcoinsfwe32
88CrWlGxLq1W+xY/tWKHE6unX9Qf73ubI97xBRpPO5AUZrKhuUE3Rwb0vt2W5nRJ
RCozAj2QHhd6+WWXhRwSE5i+yB9CwoXuD8eoBuFnfsOrTHbOBJ9c9urLp/zOzjBY
IG2LOKVHOH3bRZXItN03+wzAcXRVui170BQ3p69fHx90vCCoWJAO1X3+riQ03mgQ
IvCxIF4li9yUjbAJcqVk5zr8Oqgi108TR/CTBcHM835WBgQaiH6cAfPMhnzOTU9w
P45ChQuB061PgloE9hBT
=9q2y
-----END PGP SIGNATURE-----

--QWpDgw58+k1mSFBj--
