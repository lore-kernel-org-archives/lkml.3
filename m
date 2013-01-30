Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab3A3JhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 04:37:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53297 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab3A3JhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 04:37:17 -0500
Date: Wed, 30 Jan 2013 09:15:21 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] pwm: Add can_sleep property to drivers
Message-ID: <20130130081521.GB13568@avionic-0098.mockup.avionic-design.de>
References: <1359381659-24454-1-git-send-email-florian.vaussard@epfl.ch>
 <1359381659-24454-3-git-send-email-florian.vaussard@epfl.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zx4FCpZtqtKETZ7O"
Content-Disposition: inline
In-Reply-To: <1359381659-24454-3-git-send-email-florian.vaussard@epfl.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:4YqEhCGua6Xu7uf8QXL9FDU7jTv+8gIvtv33yZUtlG+
 uk5RrdHnFNu/T3222hDCJ8Qwb9VimkCUq/QGbensS+JipdS8jR
 Ragm4FKa9GQ8xfF8q78OG4+k3K42UpDOkkg8k32yPa+Xll+pHr
 iuVcF+fxKwI+pEu7Ni4jRH9nLqtx1Ai5BcBkwOfgiGKRkvjOeI
 3skOXkYFB1EExoKqa6JlHYu+Ldjdnk20znGeEwDEmxnFSerq4Q
 mjGLyXdDWaHlF4aw6eCZ6h7cVsLh6fGVi/vVEqOv3ZmAvh6aMh
 5vpEsbHSzwPta8n2ZERM4GGgK/JHydzK8TLGralYHMNdyRyOZz
 jCxiYxfxaSJQVPtBcN2Jquf1puHlWt20+MlTUtrkofTECyJ405
 vNa6xQk/+KOJgiPHMR78Ab7Oco/2NJvV+U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 03:00:58PM +0100, Florian Vaussard wrote:
> Calls to PWM drivers connected through I2C can sleep.
> Use the new can_sleep property.
>=20
> Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
> ---
>  drivers/pwm/pwm-twl-led.c |    1 +
>  drivers/pwm/pwm-twl.c     |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)

Applied, thanks.

Thierry

--zx4FCpZtqtKETZ7O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRCNaZAAoJEN0jrNd/PrOhs68QAJDU2vJmy42UiM2kuLNS8Goc
17l95f7sX3dvl17S4kJ3v/x+WkZAno/gfBOC7O+RLBh84wI36N2zY/kaQm9rn5pH
kkIJSlNadRsNRuH5c/olZJD5e3LkITklmHllzFAKvZ/uUNT0TgzqIlT8mAluYguI
ElaxqKmvkDmShquCxOFp5UA0yvSuqVwrZg4TptTGDYO7IzrZWM46j05t3GOJB3nf
/Ui6NSEXktTGEEWOMYsdRlXsLHnkfh63+ryKChKz+slkhKbTc9eHDWPBzgq4WUL/
8dbfidrz+QMYxcnWLsbEuQFnbsA0PJywqw3SE1hrZ4Pd7lDz6y7D0uDqy0v6cjMS
peFvL15mcUjAUz5aro11LqzC1ilr0s+3N6OxsbQpVdDmgvZa2fgqPQzMY9DpBdqV
+I1kPmBE5WO2tlDsV4SRq8Uddrv0+Is6qbuDBQJ5cRb6dYxBfHy5STlwS68+wfRm
ShoKGUc+VsK8iO5nQqrFbl84+qlV3Y63hJ0aSAwNVoCxgsXsmCMNcx1wa/6b7bFM
+yuXQfJ1T0nc4GiQaBX61bYggmB+gSD7+PunO+YGWm1s/BKY5rxCmN3kWXUZjcZ5
1qXhLGnz/R7AcItzM0mg/dYyp/m9JC9ZDSHxa4rAfXHDKKeX0RupgILe8uIuqFSS
sAc6Q8j0nBFJ0zuJzqMY
=tioI
-----END PGP SIGNATURE-----

--zx4FCpZtqtKETZ7O--
