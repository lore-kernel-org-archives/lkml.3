Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaCMOJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 10:09:48 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59779 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbaCMOJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 10:09:46 -0400
Date: Thu, 13 Mar 2014 14:09:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, dmitry.torokhov@gmail.com,
        cooloney@gmail.com, rpurdie@rpsys.net, dbaryshkov@gmail.com,
        dwmw2@infradead.org, lgirdwood@gmail.com, a.zummo@towertech.it,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com,
        k.kozlowski@samsung.com
Message-ID: <20140313140901.GW366@sirena.org.uk>
References: <1394703532-494-1-git-send-email-r.baldyga@samsung.com>
 <1394703532-494-5-git-send-email-r.baldyga@samsung.com>
 <532191E6.6080108@samsung.com>
 <20140313125504.GA10356@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I33OQG5IFrqF2BWt"
Content-Disposition: inline
In-Reply-To: <20140313125504.GA10356@lee--X1>
X-Cookie: Some assembly required.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 4/4] mfd: max8997: move regmap handling to function
 drivers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--I33OQG5IFrqF2BWt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2014 at 12:55:04PM +0000, Lee Jones wrote:
> > Is it necessary? If previous mfd driver has various i2c line, previous =
mfd driver
> > initialize regmap/i2c setting on mfd driver.
> > I'm not sure that regmap/i2c setting code move from mfd driver to each =
driver.
> >=20
> > Dear Lee Jones,
> > I need your opinion about moving regmap/i2c code from mfd driver to eac=
h driver.

> I'd rather take advice from Mark on this one.

I don't really case that much; I'm having a hard time seeing it as
particularly useful to do the refactoring but if it makes people
happy...  Keeping things in the core would help promote reusability I
guess but I'm not sure that's likely to actually happen with this sort
of driver/device.

--I33OQG5IFrqF2BWt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTIbv6AAoJELSic+t+oim90ZUP/2+p9Guto8SsGiGIsf4AZHrb
YNgb7rBjGWuX07oxXR3x6e5zpu+8LL1SSItlF/Xj/9p9xakJyU4AlVhQXkaTNbpv
l8gmu/ZA1FTn8V7+qFT5dsWoX1AsDn62bELWXlnh0z9zXRJCRzNwv14zMf25e+BI
oXS+9qSUkO3Vp3lXiH165OMAiNgZ+GFpkFfIN2rFX91w3gBOCiEkd0Zs2ZyUNpOe
T5MHtWcMQNvTGcFuYWy4wyhkTQ46sSho0BgJa/UHdjUUhFGF2pWxXTPNpNo9al9P
gNfKg5kiPcnh7ytNbwzcxhw5nH1ydK+wj8/27o2Cdkpqum+AoTmHCGsXGIQHF7AS
RbpRyJo/p3sxtd++m+elzIW8PlCYbILz/mTvT1tVeee/MOPSxw7DgxOWxeyhGwNk
kjhAUklm8jafgnjBTi1a3AZ4Nbe3D0mejqYuhUf+V/FwxYu9/xatzbYCOaitYRzH
6rDsXE/iewg+ZYuXJysWfgWwk0zKWdehqaTtukO+OL7o9se5oGbU0tplPagEmCUn
BkwLPurRtkMeMcA+H0eR5BLoFx9N+qeQ7riy2VIhLpEPM2rwwQbDqJjMz1r9Gml+
RleaJmeyJNClYITNrnG/SetrOHvnH/UbEzKsh3kwv+5B7+DZsWkJqTmUUfO9XfOg
SPl8W/+XB4h0yHalLzg6
=nS7y
-----END PGP SIGNATURE-----

--I33OQG5IFrqF2BWt--
