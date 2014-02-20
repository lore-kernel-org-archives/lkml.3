Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaBTKXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:23:55 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47047 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbaBTKXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:23:33 -0500
Date: Thu, 20 Feb 2014 19:23:11 +0900
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Message-ID: <20140220102311.GE2669@sirena.org.uk>
References: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1392736948-26623-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zRAgBwIUb44b1VSK"
Content-Disposition: inline
In-Reply-To: <1392736948-26623-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 02/17 v2] ASoC: dapm: Add helpers to lock/unlock DAPM
 mutex
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zRAgBwIUb44b1VSK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 03:22:13PM +0000, Charles Keepax wrote:
> Acquiring the DAPM mutex is necessary before using several DAPM
> functions and dereference is quite ugly. This patch provides a helper
> function to simplify this.

Applied, thanks.

--zRAgBwIUb44b1VSK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBdeMAAoJELSic+t+oim96zIP/ivBMXTxh0KfouvagRl7eCDC
Qqi2diS1FJSA6cYOXGhDKZ88FDXLMniKGKcWfllGxhIADxNgr1pnxwn+LXWtcj+8
c9rMlmEvH5bm80Cjo6Aj8LQKNA7Ugs+WldEMUo9xVByVC5uq2fIncWLsiXw/ojMJ
OV4hw7ia+Jx/aNrCCyGgLhSMEKECClhRRM1Aa7E8Qanrg7kkkweHbogvHw4uBYo1
UKknuDd0IqGq1Yy+W+fVLXrB7VFWiIPCOxMQN0LiAkIvpsstVdmgOPgLFq6LUpXv
6pGVZMQUQgQ7Xvo7vovxhX1Z7PF5l8ALE6DV/Pw3WzQwu2K5tQcr/MdE4nriaa59
yLaYS1/Jts3J6LD5ZUqUuDutcK9GpSXEW49JsgIwESiU6G0Cx8gBDWKz/C32P0x/
2hA07l7XFbwJ7scdwp50f4RfRZDU0w+gu2yZnm4bRlolonIKX567R/8D7XzRUCag
kNDjLGDYIvkzLfrkDqRIthUz7HaMNTXbkA9AGtb7LTCjDYp2/vBEFSlTGR/hsCAz
9FwMhSvRPGuprlOHz6YSGvychxVsIUXtVtAIApVPVkTqi3b+QnLfSEICScM2Kq0W
FKfDenAf+jjbv1cnN7Z4SlLB2MM1LGmsVhHfvIdu3KsMf8GjZNoI+48e3Bhbof72
qzeQDz/WlWaSO1NOLvh0
=s921
-----END PGP SIGNATURE-----

--zRAgBwIUb44b1VSK--
