Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaFWJs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:48:27 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54253 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaFWJsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:48:25 -0400
Date: Mon, 23 Jun 2014 10:47:34 +0100
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
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140623094734.GV24291@sirena.org.uk>
References: <1402941758-11216-1-git-send-email-javier.martinez@collabora.co.uk>
 <1402941758-11216-8-git-send-email-javier.martinez@collabora.co.uk>
 <20140616192500.GJ5099@sirena.org.uk>
 <53A01D54.10506@collabora.co.uk>
 <20140617141254.GP5099@sirena.org.uk>
 <53A06749.1010606@collabora.co.uk>
 <20140621204026.GH22657@sirena.org.uk>
 <53A7F339.7050608@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6qFdnjy6dKaiDX/E"
Content-Disposition: inline
In-Reply-To: <53A7F339.7050608@collabora.co.uk>
X-Cookie: This is NOT a repeat.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 07/10] regulator: Add driver for Maxim 77802 PMIC
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6qFdnjy6dKaiDX/E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 23, 2014 at 11:28:25AM +0200, Javier Martinez Canillas wrote:
> On 06/21/2014 10:40 PM, Mark Brown wrote:

> > That's not really relevant here - I'm asking if the regulators get their
> > own supplies rather than if anything uses them.

> Sorry if I keep misunderstanding your question but the regulators in this PMIC
> don't have a parent supply/regulator node.

They should, I'm pretty sure the device does actually regulate one
supply into another.

--6qFdnjy6dKaiDX/E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTp/ezAAoJELSic+t+oim9E4sQAJi2kzIJpgcPKot+Qf54PELp
qJ9WtYpSj3JJ4wlco5MFkvpwhopDBid+s2FISAGL882quUOrkw4jsYRI4IeNTcz/
w5KiX9v40Au0ybcwglsHkDLYUQKdeHfZReno0JcPvLrNBb6n7V0m4oUkerOQ2kak
29EbRwVaGEARK1Vjob2EzGGzlKIrop/O1TjCfoVcC2xnJbgg/8ERINs81gy14wVE
15MoIQ2r7nEvWNJyGR3qYUwSnkZo20toZFNnEFl4B9C6SjWTvZWUpClW4CG22HwQ
9tmxvrY54mViWD024GD8/9D3nYR/zU/l26bzjy9wTpHkEsyOhzj5cvBYn6dR4fzw
Oy8QHiGAwFCRCdNcnIUdEURKZkVQXi9bDrRHe296oGWZH2V9b+57/wiWIxtfyWm1
5H0aKPTum8Xy3xECxQ8cuvDDwONcHktqJEl5Kde9TAia19EEEwnqMmy+KZThCDjh
OxGYDERal1ctVZyYW7UWpQezV7UKtbAzmhM0lJ0LGlHb1/jmzTYULXgWieDtLTf6
q8xlLijEpq3FJ5gk9D/5lYb6pR5tZ8PbJGnvGxQX2KIeVOSzHFUMsDTzpq9wp9Pm
GRJnVflHhUR6y4vkAUNuKYSQ+9B2mN24GKMM3CunxiAoW6FfxxsL1/XtvdWDJA0M
T7jZx+7vgHd223MNo7ex
=NTZb
-----END PGP SIGNATURE-----

--6qFdnjy6dKaiDX/E--
