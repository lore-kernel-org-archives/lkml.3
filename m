Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbaFJKyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 06:54:18 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35252 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaFJKyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 06:54:16 -0400
Date: Tue, 10 Jun 2014 11:53:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140610105334.GF5099@sirena.org.uk>
References: <1402306670-17041-1-git-send-email-javier.martinez@collabora.co.uk>
 <1402306670-17041-3-git-send-email-javier.martinez@collabora.co.uk>
 <20140609193849.GE5099@sirena.org.uk>
 <5396434D.3020402@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k4P7DRXulMjuQ+XK"
Content-Disposition: inline
In-Reply-To: <5396434D.3020402@collabora.co.uk>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/5] regulator: Add driver for Maxim 77802 PMIC regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k4P7DRXulMjuQ+XK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 10, 2014 at 01:29:17AM +0200, Javier Martinez Canillas wrote:
> On 06/09/2014 09:38 PM, Mark Brown wrote:
> > On Mon, Jun 09, 2014 at 11:37:47AM +0200, Javier Martinez Canillas wrote:

> >> +	case REGULATOR_MODE_STANDBY:			/* switch off */
> >> +		if (id != MAX77802_LDO1 && id != MAX77802_LDO20 &&
> >> +			id != MAX77802_LDO21 && id != MAX77802_LDO3) {
> >> +			val = MAX77802_OPMODE_STANDBY;
> >> +			break;
> >> +		}
> >> +		/* no break */

> > This sounds very broken...

> The problem is that not all regulators supports the same operational modes. For
> instance regulators LDO 1, 20, 21 and 3 does not support REGULATOR_MODE_STANDBY
> so if the condition is not met a break is not needed since the default case is
> to warn that the mode is not supported.

No, it's the "switch off" comment...

> But I'll rework that logic on v2 to make it cleaner and have a break on each
> case and don't rely on case cascading.

...though you should also consider splitting things up so you have
separate ops for separate regulators if they behave differently.

--k4P7DRXulMjuQ+XK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTluOrAAoJELSic+t+oim9UdsP/A2NV35f4BsE16AuepYtgcKm
q8fkRqeDl95SmG+glxmMTPbCL1lDQW2n+mpvoComlcChOeVH5FfqaSDMbuHqEFQq
O53RoZ5KWg38LLwoN0HF3IBg+jhppDejOgcGglgkjL9Uf2xfUQzKMZpQhAbNHj+W
1GSMEIyGqOLWnkqAMbV55jYav5RONYr6l6HhK3ul9FthC6Rh55zyLTUp8M0PLVBG
X7l/zA7Uxfg3NmOwgggB1UUt/VqOQU9MHrPJRfzju/8rjrMDNgJTpVH3C85Py9ck
oJRASYDdxqxv6LDk7MxoDPAMRshTfFIglbi+JzI8SElkRkYRxipi+TTHlhFM9fWM
qmxQ2/hQf1Ix/8xv6ozuT3XZvvvIYzTuH3TIUsz+pZ4seJBzSKl8caw1VvKhBwrJ
6T1+WheVRJ54CPaKOnZeEiVm3NzW3+dvGQ2Sul9dvvu5tvEqFrMDjkRTH6bo1ihr
wovMKBqwlhQPzh0EqRzLBmRZYO+rEOJOlNq4YU0umKdMWzKa1sBe49MJM1Ws3zZv
1DXcRP2HfemOeeNWjfTcsNjd/1vzmope0YQo+vIqLOGHcCrHJSh+uChQA1bMtkR5
/lCA1fyJpfWPIEGWJo/Qmh8f98T9/GtBUeGc4yq3bg1uJBkdeCIoL0dV4fWJA+bx
fL+6IdzaOmZg+FxUiVuj
=HzFx
-----END PGP SIGNATURE-----

--k4P7DRXulMjuQ+XK--
