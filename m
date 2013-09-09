Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab3IIL1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 07:27:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37176 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab3IIL1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 07:27:10 -0400
Date: Mon, 9 Sep 2013 12:26:43 +0100
From: Mark Brown <broonie@kernel.org>
To: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
Cc: Ashish Chavan <ashish.chavan@kpitcummins.com>, lrg <lrg@ti.com>,
        alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "kiran.padwal" <kiran.padwal@kpitcummins.com>
Message-ID: <20130909112643.GX29403@sirena.org.uk>
References: <1375717898.29528.23.camel@matrix>
 <20130805162342.GS9858@sirena.org.uk>
 <1377778108.15438.6.camel@matrix>
 <2E89032DDAA8B9408CB92943514A033751E611AF@SW-EX-MBX01.diasemi.com>
 <20130902103843.GL3084@sirena.org.uk>
 <2E89032DDAA8B9408CB92943514A033751E612F5@SW-EX-MBX01.diasemi.com>
 <20130902174121.GV3084@sirena.org.uk>
 <2E89032DDAA8B9408CB92943514A033751E6157D@SW-EX-MBX01.diasemi.com>
 <20130904183405.GX3084@sirena.org.uk>
 <2E89032DDAA8B9408CB92943514A033751E61991@SW-EX-MBX01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JjNtGRvLZqzR8wa5"
Content-Disposition: inline
In-Reply-To: <2E89032DDAA8B9408CB92943514A033751E61991@SW-EX-MBX01.diasemi.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: codecs: da9055: Update driver name to
 fix breakage due to pmic driver with same name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JjNtGRvLZqzR8wa5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 06, 2013 at 02:17:48PM +0000, Opensource [Adam Thomson] wrote:

> Bringing this back to DA9055 though, the current method of initialisation, for
> PMIC and Codec, isn't complicated or confusing nor does it require a lot of
> effort. As well as this the implementation is logically sound. It should
> remain that way in my opinion. The only thing that should be updated is the I2C
> Id of the Codec to make it more meaningful, and preferably sooner rather than
> later so the issue can be finally put to bed.

Well, the obvious approach would seem to be to just do the registration
of the CODEC I2C device from the MFD...

--JjNtGRvLZqzR8wa5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSLbBvAAoJELSic+t+oim9aa0P/1yX17viQppBzB3kcGptNhC3
DscLDJu0Cte4Y5D1UJGmuKQMDHNpU1mr4wlPdpevU/2sjqd4p2Mi1k3Nh773mT9f
hgqJj/LQoqRlyLemfa53SVc7THPC+76yQCsoqaWl/egz+7Kc4hhEhto+NJyNQpA3
sHux/0aA3tOykmCdQ4bIhWsyE1UcIHaxjrCw20P8MRf9I+iIqlSdW8lxj448HyFU
uHsD+WvWFor9upmNbOG5agQG/tVSxlNfRKSzwjip/9ct8LClc/Y6NBly6It8hYb5
M85UGG8Zixw0BC2it2Exu/+LZUfYWMxWlv6bajfm4sAtkynGXHyLqDEob7jN7dHe
yO3Os24iuMk+UO6Rq2NBoWCmFeOm9Sut68AdRK6vHaxjt88gUglqUChApqgPNlpv
tjX8XFMB4x7hXYhbPcQH0SMfEV07n7JZjTiQt6VyVJ3tKPNf7IBe7bMx6HUhSIha
qSJVriLi+ID4OKYIMV9qiOpjZV8Df3A+ngRFsUJXDjeFVWH0bW8eqXPsFd66K4ht
kwSeZgaTQAt4B5Bme+XRWZkGmqs49WjTCZIE4uAbBFUIHZZL2Y0CMGI+3Hbhh+cV
v/FT8aZa8Unxt086k7ESKBZS5lOfcGtNJyYmOxHTpBrkBmksJQX5QFVM+/YQLybO
8qmwYmtUYXGUVYfnG7CB
=UZQZ
-----END PGP SIGNATURE-----

--JjNtGRvLZqzR8wa5--
