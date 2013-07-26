Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794Ab3GZQlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 12:41:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47158 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758379Ab3GZQli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 12:41:38 -0400
Date: Fri, 26 Jul 2013 17:41:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@linaro.org, linus.walleij@linaro.org, rob.herring@calxeda.com,
        rob@landley.net, sameo@linux.intel.com, lee.jones@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, gg@slimlogic.co.uk, kishon@ti.com,
        swarren@nvidia.com, devicetree@vger.kernel.org
Message-ID: <20130726164122.GT9858@sirena.org.uk>
References: <1374833754-19659-1-git-send-email-ldewangan@nvidia.com>
 <1374833754-19659-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fVqowPMy9d9Ku1/g"
Content-Disposition: inline
In-Reply-To: <1374833754-19659-3-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] pinctrl: palmas: add pincontrol driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fVqowPMy9d9Ku1/g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 26, 2013 at 03:45:54PM +0530, Laxman Dewangan wrote:

> +pins: gpio0_id, gpio1_vbus_det_led1_pwm1, gpio2_regen_led2_pwm2, gpio3_chrg_det,
> +	gpio4_sysen1, gpio5_clk32kgaudio_usb_psel, gpio6_sysen2,
> +	gpio7_msecure_pwrhold, gpio8_sim1rsti, gpio9_low_vbat,
> +	gpio10_wireless_chrg1, gpio11_rcm, gpio12_sim2rsto, gpio13, gpio14,
> +	gpio15_sim2rsti, vac, powergood_usb_psel, nreswarm, pwrdown,
> +	gpadc_start, reset_in, nsleep, enable1, enable2, int.

Would it not be easier to just name the GPIOs gpioN rather than using
the full names with the possible functions?

--fVqowPMy9d9Ku1/g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8qauAAoJELSic+t+oim9i2IP+gK8XCjkUG7Z8hMXhIGNn1zg
5JmP1sT9/aSJtfzkWGW9ndqlSoTr7u5P1H0pOT9maRF9W9yNZ5W5S42TJQvMMGMz
EsZ2OsWOGTK1iyw5JeMtRLFZ2XmzFyz3AZ3nvMlcp4mtype7tO+fkgZnbMx4MHup
UyR3aWXXVvu/tIujgHB3IYE0zt/AKD5p7btp51K4nws0cm4se+kp74We8EsOMXBg
nkw9UDoFFDAoFPMia9KKimZPk+uk85PyGPkiLtihX+U+rd1R5AqYn7MuEOlUi1vE
1hd4ZXkFihHThYTX8FKgW+C4nHzVzzrExZKmniWgEtRdZDPLQffpejfRHSoAMTqB
DqCwzhdj+E+TUpF+Zed4v5SI/LJfVzT7jTtmRx9/M1x0rMvBI2GXHL/65NJ07dW2
CjFSJxPV+PLmZmg6xnu/fCUxS3EemjohDWiA95SpQZtLLIFFJhOk01BlWVPBsxAF
VDyqR+VGw7pU6E/65CDIJXKfLCF5bnqUDFy+UEzj+eaV9dk8lQx/0+D7VI+UwWyk
0fVa7a6B/8AXURgQt63nYrogNgBIGz5ICcu1SDFqFaxY3U4xvntr5YXZD6Mw/Utu
n7i6/d0YeCvpQ3q2d0d/kRX+k8C9TGoAS9ym2n2qYM2ZxvZS+PY1vkbAxPcp3n5j
+VBZWD1yv739wFhjF78v
=T9ys
-----END PGP SIGNATURE-----

--fVqowPMy9d9Ku1/g--
