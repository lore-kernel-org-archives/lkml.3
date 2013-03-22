Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab3CVKpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 06:45:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62954 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab3CVKpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 06:45:16 -0400
Date: Fri, 22 Mar 2013 11:45:08 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Philip Avinash <avinashphilip@ti.com>
Cc: nsekhar@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com, prakash.pm@ti.com
Subject: Re: [PATCH v2] pwm: davinci: Add Kconfig support for ECAP & EHRPWM
 devices
Message-ID: <20130322104508.GA9804@avionic-0098.mockup.avionic-design.de>
References: <1363761564-14814-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <1363761564-14814-1-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:jnm0xYuWK4uZLIAC/FwgOYNcYk6B90YMkRgAu8TfHh9
 +m/nHeI5q8ohGsPkW+QaYoz+8S2MZDZP+EO9tL8tWSGWPusKUB
 k0yra6DpENIETpU4zIMaMF/NJaHqoEs2B5udWme6rkVSKoHK8q
 yMl4+f1fK92n8q9aUg1+4QntMTNBhTBlzJ/YJV1uqDKyWAYgGa
 Z2b1PIM+yhr/McDTwDAGxEWOlKhwusRkwaTGs/ucBRGN6fDB/L
 faC22BS5NS7yhbz6ajEVA41AX76i34WPTJmTGKwfSbBx5ja9uA
 LRd178WDJO8kihvEM2H8U4M9312Xlpkgwcw/VvCKe5wlwZdKc1
 86JWSJjqjKO2TfKYf1j+x97bfiubL1bVZL8xIKJ5/npeyveweR
 ENOEGzTKwO+bsavjdsdZWaIYV+zbfjYyVTr9Nrd9ARJzs9hvJO
 VzpLW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 20, 2013 at 12:09:24PM +0530, Philip Avinash wrote:
> Add EHRPWM and ECAP support build support for DAVINCI_DA8XX platforms.
>=20
> Also, since DAVINCI platforms doesn't support TI-PWM-Subsystem module,
> remove the select option for CONFIG_PWM_TIPWMSS.
>=20
> Also, update CONFIG_PWM_TIPWMSS compiler directive appropriately in
> pwm-tipwmss.h to fix the below compiler error upon removal of
> CONFIG_PWM_TIPWMSS for DAVINCI platforms.
>=20
> 	drivers/pwm/pwm-tiecap.c: In function 'ecap_pwm_probe':
> 	drivers/pwm/pwm-tiecap.c:263:4: error: 'PWMSS_ECAPCLK_EN' undeclared
> 	(first use in this function)
> 	drivers/pwm/pwm-tiecap.c:263:4: note: each undeclared identifier
> 	is reported only once for each function it appears in
> 	drivers/pwm/pwm-tiecap.c:264:17: error: 'PWMSS_ECAPCLK_EN_ACK'
> 	undeclared (first use in this function)
> 	drivers/pwm/pwm-tiecap.c: In function 'ecap_pwm_remove':
> 	drivers/pwm/pwm-tiecap.c:291:49: error: 'PWMSS_ECAPCLK_STOP_REQ'
> 	undeclared (first use in this function)
> 	make[2]: *** [drivers/pwm/pwm-tiecap.o] Error 1
> 	make[1]: *** [drivers/pwm] Error 2
> 	make: *** [drivers] Error 2
>=20
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> ---
> Changes Since v1:
> 	- Change the Kconfig dependency to ARCH_DAVINCI_DA8XX from
> 	  ARCH_DAVINCI_DA850.

Applied, thanks.

Thierry

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRTDY0AAoJEN0jrNd/PrOh3aEP/iANfAJiVIN7gCaBrD7nOgSx
bU8s+KbXNWbaVk2ZmNNwqLzHTcBfbwqpSPq0Yig9DymD4R15tu94/nZLrEq9gwrA
dXIV+3Lkp3NZwRxGZ4IKRboUZLtutKUGEaaiPZFGpFFYOPVt5jPzrwh3JLwab4sW
SFU+wM4YvnFqaDrEoz/RB6rWwdN3NX9aZBdXhEMqIkT8XA16bQ8CgI774fVNlKgg
xebwdTGGQsSGtr6529FI8VgQj71eSVZU0X8QP7U0tPT4+a4R0nxA7izzj2MACpxI
uG/YbQdhoS25P/KVx8z4CBsl/ytdxT3gQVaDjb0sChrBSdzM99hm04/kM91MiB/X
ZvJgcZvMn8RvX3ZFAz7jciO0XVgcGi9ZFFwN5usMJ1YkFHh3zcZqAHQjuDbOEoxq
6TkRDbiTU1wV8YNCCxgiFTP/EUQJfGvm974lnmijqvcUW3lPNGF+l47WbaeQfJWR
awiRG/g9EZ0t9B19PFoYdIDfW1Sugk1DwmQIt/WY6X6dj8CPnr/Df/Sk0sYvoLTk
kMZqUkfXoUDt24LUuCJJ0zOH4d+zxu9wkTao3w6RhRXGtJH6YxEYdbTzq3JRXeMH
4SV89K4GMXsuf+6TzV85c3z9Ldh8UAzQlQF3Isw1ZyikzH38QTmzFUoCQxzua8TI
J+D6Mj6bRhe/3q0+kOva
=cDs9
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
