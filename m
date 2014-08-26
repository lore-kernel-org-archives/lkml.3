Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934288AbaHZJMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:12:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33671 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934092AbaHZJMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:12:42 -0400
Date: Tue, 26 Aug 2014 10:12:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>, Yuvaraj Cd <yuvaraj.lkml@gmail.com>,
        Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Prashanth G <prashanth.g@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>, sunil joshi <joshi@samsung.com>
Message-ID: <20140826091226.GD17528@sirena.org.uk>
References: <20140822144531.GV24407@sirena.org.uk>
 <53F7838F.8060906@collabora.co.uk>
 <20140822183054.GY24407@sirena.org.uk>
 <53F7BDD8.7060500@collabora.co.uk>
 <CAD=FV=WC0h7fYm2QFqu3Zka7CsU4BtG-oyPpJav+ygC+gmCR+A@mail.gmail.com>
 <CA+NduCCT-KQ=gh7QWkBE4qkA2YOJ8KCVqbkC6Tkmb1aPvCsGFQ@mail.gmail.com>
 <53FAFCBC.2050407@collabora.co.uk>
 <CAD=FV=V4TSKsbjj3dXCdSzVrh3sxH-FkpFEbEo+JA1bN9R-XWA@mail.gmail.com>
 <20140826071721.GV17528@sirena.org.uk>
 <53FC4E77.2090205@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ig7JDkzUL4ONGnSW"
Content-Disposition: inline
In-Reply-To: <53FC4E77.2090205@collabora.co.uk>
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


--ig7JDkzUL4ONGnSW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 26, 2014 at 11:08:07AM +0200, Javier Martinez Canillas wrote:
> On 08/26/2014 09:17 AM, Mark Brown wrote:

> > No, this doesn't make any obvious sense to me at all.  Picking normal as
> > a default if the hardware reads back off due to overlapping
> > impelementation or something *might* make sense but not overwriting the
> > hardware state without explicit permission from the machine integration
> > is a key goal for the regulator API.

> Just to be sure I understood you correctly, what might makes sense to you
> then is to set the opmode to normal as default on probe only if off is
> read back from the hardware register but leaving the enable function as it
> is now using the opmode set on probe?

Yes.

--ig7JDkzUL4ONGnSW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/E93AAoJELSic+t+oim9Z9wP/ilHZSLQJ/CVDF09FNLu2Jpu
n844oCfKVtBN64UHeW1yulg3uO+/G2hKOllLYJVRtWMe8kocZNJm7a08tQQco3lu
TrBvp79d6Bav5vhjCL/1Oq6vCPWPpZXuYMhrWSrefT6OPViEA6CS+W5issxjBjD7
gsB1kUJY5OKs/pCw0CuSXxDIM1FMFvcAvjxcBbB5JAKPqhvIwB11J4wdT6GuKZ80
DxZwLD6xh/senl8mR9dU0RqLogNJmLtACFxG8KZ9AfJVudue8Y+L+G/UonXOYsre
OFXQq75X2FkztoIyNCh0TuLejlCk0hPDATkFLpJZSzXV6Dx+oqUUtSnfkEQiMSmB
btCC9Fc7bhK2Vc8k1cScriUd/TaaWo02ehTvao7FoZZ6lFid01HSwM2rTExu66yD
IdXVmFR+prBaLKWZJgcbndB02CDO7yOcM5Tys0y3GAEcDx+dvZx0vNt4L4YU8mNy
8HM8hR9xVa89R4Uo5SaRQW6cX741ObAFBuKfa0WlwS1KhSQtLSekRZ5msak1pdr8
7JSnhDGHFWMFRN9rXnuwB1IsHRMxcGmxvj0gsWfnhMi1GybHi10etj6H9jJh+NWX
FfPNz5TqAw6y4xxI5wWrhQJjSPVdt4xgICOXscmGwOVRlkyN5g938HIa8HJ6YGzO
HKH27p07KKyfKIgU7+uJ
=ojZJ
-----END PGP SIGNATURE-----

--ig7JDkzUL4ONGnSW--
