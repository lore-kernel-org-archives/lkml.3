Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab3IKPor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:44:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55877 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab3IKPop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:44:45 -0400
Date: Wed, 11 Sep 2013 16:44:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20130911154433.GV29403@sirena.org.uk>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378913560-2752-8-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RdaJseOINYw+elgq"
Content-Disposition: inline
In-Reply-To: <1378913560-2752-8-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 7/9] ASoC: codecs: convert existing I2C client drivers
 to use I2C core runtime PM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RdaJseOINYw+elgq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 11, 2013 at 06:32:38PM +0300, Mika Westerberg wrote:
> The I2C core now prepares runtime PM on behalf of the I2C client device, =
so
> only thing the driver needs to do is to call pm_runtime_put() at the end =
of
> its ->probe().
>=20
> This patch converts ASoC codec drivers to use this model.

Acked-by: Mark Brown <broonie@linaro.org>

--RdaJseOINYw+elgq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSMI/eAAoJELSic+t+oim9z/0P/A6ZGNTBUHEx8uhzDYehvFEG
LKwfSnTJIOe9460TdRdjMEVDf6cZH49dkt7NiVelLPjcBowzTQTGz87bMcWKsp5J
29dTzMQEAGCRiFMA6jRMOHmXCqoAKcSOuuCDsOaM5kz2uU3PcJzcsr0XQ/1d2MoI
54Qajk4sXf8foANj9xEGj5lwfw4Si6sn2zrLQfF2JL1TF1V5Ds8GqlVCL3gghkrc
svrP+xILdfYwNQr+uoZlrTratsuQ6IRsEFjbxy/xXXbmmJb2OQvhXn87WpoIix8i
fay+ltNl7l5ZiINiRvdR0VmYraVq0vepq17y0SVkDD1I2vCUGy2PiUhTt1DXSIed
rj124eW1YJ63Lj2iT58GNJAnDIjjmNSZnvHINs2ob/hRD/NZIg1SZaty7O1Zkav6
IoaRXgrp9c11E6kCmBoSpkl1ITdRXqMnuEetQxC/SEqXCoRfMTiaAQJWQ7lEdFel
VwLZzNtp52Ljtz6V571+3ivX+8jeixKmFoBkHmMuI3k/7wWsEzcUcEk4DPcdMhwi
wCfmpuJqcvfXxfgE647Gy+WFEztNF4N7WGurE2EpGPkRWG7dhto27CjOlsm6SlLm
wFi7pu94nF+IcJi6rC6uBYrXQr9/ZGs0Ajy/tDvwHb5aW1GSIYtlD6TS9rvMR7z0
knBHPZK6h5fO7T9wXRH6
=FjZF
-----END PGP SIGNATURE-----

--RdaJseOINYw+elgq--
