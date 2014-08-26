Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbaHZHRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:17:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33435 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186AbaHZHRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:17:42 -0400
Date: Tue, 26 Aug 2014 08:17:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Yuvaraj Cd <yuvaraj.lkml@gmail.com>, Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Prashanth G <prashanth.g@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>, sunil joshi <joshi@samsung.com>
Message-ID: <20140826071721.GV17528@sirena.org.uk>
References: <CA+NduCDL65=Y=PyU3FfXsTz0FfbmYzicGrY4U7ji3_V+nXhtCQ@mail.gmail.com>
 <53F73472.8010609@collabora.co.uk>
 <20140822144531.GV24407@sirena.org.uk>
 <53F7838F.8060906@collabora.co.uk>
 <20140822183054.GY24407@sirena.org.uk>
 <53F7BDD8.7060500@collabora.co.uk>
 <CAD=FV=WC0h7fYm2QFqu3Zka7CsU4BtG-oyPpJav+ygC+gmCR+A@mail.gmail.com>
 <CA+NduCCT-KQ=gh7QWkBE4qkA2YOJ8KCVqbkC6Tkmb1aPvCsGFQ@mail.gmail.com>
 <53FAFCBC.2050407@collabora.co.uk>
 <CAD=FV=V4TSKsbjj3dXCdSzVrh3sxH-FkpFEbEo+JA1bN9R-XWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lu4tnxbYRVx46Dqu"
Content-Disposition: inline
In-Reply-To: <CAD=FV=V4TSKsbjj3dXCdSzVrh3sxH-FkpFEbEo+JA1bN9R-XWA@mail.gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v9 1/2] regulator: Add driver for max77802 PMIC PMIC
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lu4tnxbYRVx46Dqu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 25, 2014 at 08:40:40AM -0700, Doug Anderson wrote:
> On Mon, Aug 25, 2014 at 2:07 AM, Javier Martinez Canillas

> > I see, so probably until we have a way to define the operating mode for
> > each regulator using DT we should set the opmode to normal when enabling a
> > regulator independently of the value the hardware register reported on probe.

> > Can you please test the following change [0] so I can post as a proper
> > patch? Doug, Mark do you think that forcing the regulator to opmode normal
> > when enabling is the right solution here?

> IMHO that makes sense.

No, this doesn't make any obvious sense to me at all.  Picking normal as
a default if the hardware reads back off due to overlapping
impelementation or something *might* make sense but not overwriting the
hardware state without explicit permission from the machine integration
is a key goal for the regulator API.

--lu4tnxbYRVx46Dqu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/DR+AAoJELSic+t+oim9ZN4P/jLbGogtmFYIfgc7Tfl+re1P
WMyrGA4jB7P7bJk989oii/0ES/4XFoxbUzBeNhNFNHm9nn6Uhhd6z4y7GTyvV799
EKF6SDQIcGTVuZ3WSiE7KfPcYnzwz/HM4/yTvSYlY5/1R5VpPNfGeDXpabucGw9M
rn8Pe3osE5ftP1N91od5qyQXhweE2VCg8eisQOp9ta/S3JncKigA20IViL/hQFXz
bcMc7hNwMj67DjgD/hPW9Jc/6YBhER4JGHprrzFMAhOGRzkQcsMULuq0TdP80fL0
N1QUlz0tH8MrBMIZivHn3guxNQ3/OI9x56qQc6iX+TAIQ2qlGaOH83M4XvA3XPWP
2ahgN88/JWFFjWEdVg9OL8H9ySQfB1Kab1wM+DNbcTOAmxoVc/ADKSDWTbPIUePz
Znh2f1yxMqpdXso6iGUQyW/egz6R5MycWnh/pxAHZxpzhN8CfD4uKk8tTSdjAIQ3
qzUJt4vo81ACQvci0JO0xO/UfuoqHv2scqNjbyvAO0w2U13zY9WDfR8HHdxo7Odi
1/xAEeHHI2pkUwhJNQn+4RizXCd6mBsWYSrOTARquTQUwCRXoNWKhhLC3en6E16L
VaU/a/U1nCMl11XEC7mA8bjTaT0+zH7oonqV8C/RUsiM5qnzRV4qMt8ORqGG9XA6
sO4YUGaVn8yIJMjlwQmv
=juCQ
-----END PGP SIGNATURE-----

--lu4tnxbYRVx46Dqu--
