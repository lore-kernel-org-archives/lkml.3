Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab3A3IPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:15:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61788 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab3A3IPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:15:10 -0500
Date: Wed, 30 Jan 2013 09:14:53 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] pwm: Add pwm_can_sleep() as exported API to users
Message-ID: <20130130081453.GA13568@avionic-0098.mockup.avionic-design.de>
References: <1359381659-24454-1-git-send-email-florian.vaussard@epfl.ch>
 <1359381659-24454-2-git-send-email-florian.vaussard@epfl.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <1359381659-24454-2-git-send-email-florian.vaussard@epfl.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:0xhRM7ZQvve2k6+nD6DIuMcQkNInNeyRsJb3w32cQeK
 +xBRv2fdZf9/9Yo9UPjiQ5qBEqu580bBlxDOfcZ3kMMnOgThTX
 J73gxmKYPyE45riBS0pvg3gzIbz7Lcj3Y3IpPwnPpS/m+xKeQS
 zTv7gaAaUwvLdnDpYram/eGaRbcoyGD3IrUphJrTujHpotFRpf
 gnMky9X0FgHs3UuPQALjdkMqVct994+m73FQHykS5f8weCYrEy
 o7psMmLGDk2kIU+Zw90aRSDtCIU7pEIKWBUR9bi29nOZQcoWBX
 1Y/aqdKi7mPR+v7WOKAGefWyXLMSZYPf28uRgyw+RuInC5Fm3W
 nKhxuMj9UhlBWysO1er6Mvg6QsnUALTwsuKROjK/YxzZ0p8eRa
 y3JNdbH/NEABiLZJPiU7aG/9rGf5w3oZOU0q1CUH/f8ZrSJMZK
 aFHYn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 03:00:57PM +0100, Florian Vaussard wrote:
> Calls to some external PWM chips can sleep. To help users,
> add pwm_can_sleep() API.
>=20
> Cc: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
> ---
>  drivers/pwm/core.c  |   12 ++++++++++++
>  include/linux/pwm.h |   10 ++++++++++
>  2 files changed, 22 insertions(+), 0 deletions(-)

Applied (with a minor fixup to the kerneldoc comment), thanks.

Thierry

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRCNZ9AAoJEN0jrNd/PrOhdhYP/RGWwASJCyIQCjYJj6EMjxFx
SCKRtc5OespUcdXibzELdK4PHLgQNwQF4jQ8QqGjhbFg5fLniwX8ZpYTnDQZtoOK
iLSfBOFT0emPSxO+pdsgQJFb78szguOi4ooWsOB1/rWFSi2WNMBqbW1DSUqFj2OT
mckbkrVdKpIWaWdVCe48Z1THVqvBOUN43uJrhQKGPtxEFSZSXPiRvf3OGsdajqMn
dyNEH+qg1G0kJn9ilgUSadO6iPxLnJkat3UcYD/E/phlNjC4ebKI+Nm6GC4nY1vp
RlE+AbFrSHMnR35O/85BCZg6fPzkJ5g0XZYlF4JyVN8l6Ijl5ZXwlPIjc1yM/33k
iw1E/+OdkshuBkSgnymKExewtMKNo91fd/dA/fkVqVn0eWzz66anWphmF32Ijy63
qmRlIE83vFbDls99ZA4RpgSpWCR4IxxgMlShavhHrX9hTEaKCrQIx8zkvMzRC1Fm
+KuD743LMJ/0J6o8YYJGbv63Vkhk8Qv/1X+CrKWXQ7SUBMOf8jh7V6LOvHJik8f7
ySFsRxYISN/vm5nVWPqMFmxLUgQ06GxK026ktmtOiFSgul2OOtWBclv+faLTKpF1
PWJ2LBZoETFaVXOX+BLn8GyNlqsAzmNtnlabf25yX8InosJs/HXyQHFhNihHcUnI
tTkBz+3q1nIR8H33WPXz
=cMcC
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
