Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaFCOyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:54:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52134 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaFCOya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:54:30 -0400
Date: Tue, 3 Jun 2014 15:53:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Eduardo Valentin <edubezval@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140603145347.GE31751@sirena.org.uk>
References: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org>
 <20140527192923.GC12304@sirena.org.uk>
 <CAKohpo=AnusM2FGs=JLozSyTc0N7SDXQxe+rPiLEHP6ewxY4ow@mail.gmail.com>
 <20140528173858.GG5099@sirena.org.uk>
 <CAKohpo=T3BG9X0gHfRA-x8B3ou3Y=XHcs=OTYAHikX61iAJ9xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BtLpl2nkGUzqmEOn"
Content-Disposition: inline
In-Reply-To: <CAKohpo=T3BG9X0gHfRA-x8B3ou3Y=XHcs=OTYAHikX61iAJ9xw@mail.gmail.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.148.252.180
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulators: Add definition of
 regulator_set_voltage_time() for !CONFIG_REGULATOR
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BtLpl2nkGUzqmEOn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 03, 2014 at 08:10:00PM +0530, Viresh Kumar wrote:
> On 28 May 2014 23:08, Mark Brown <broonie@kernel.org> wrote:
> > Whatever - I don't think the particular code makes any practical
> > difference.  We would need to audit existing users who don't have a
> > REGULATOR dependency for breakage though.

> Exactly what kind of drivers are we looking to fix here? These might
> be the possible cases:
> - We are checking 'regulator pointer' before calling and don't need to
> handle anything there..

I'm not sure what you mean by this.

> - None of above are true and drivers aren't checking return value of
> regulator_set_voltage()
> OR
> They are checking it and failing when it failed..

> What do we want to do in these cases?

Well, we would need to look at what the drivers were doing and figure
out something sensible - it really depends why they're trying to set the
regulator and what would happen if it doesn't work.  For drivers that
ignore the return value they won't be affected anyway.

--BtLpl2nkGUzqmEOn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjeF4AAoJELSic+t+oim9J3wQAIspMrhepkJYEelgRTHs/mvG
xyPIKNFgw2q+jfts2gk11YBuQ30vXaHke+pHG9oC3xV0un+qrJPuqV7UpTl8ebLA
3y/oD+QcUcru63SPXPt0grT2MpvmerP+yZVd1u/m/0xoGI6TuZ88Xd5DUOWMsw+L
UN9iGLZASLCumJFEMR4vlCdssZFehP7H4LHjaHLiV1naT3GTt5X7xxmDLd4n5/j3
V92Y1OpNnwAzTElOnqXulglXA9Z9HnbCUCNzzJixX38LEfnzGKAR10W3aixFSEkb
Iqs/V2qSIkRtM6bZ+6BdF2qkgJK6/LfbsniRfN99byFZTdp9T8emis4C9VdjfYUP
Njf+HYkyr3vSyuaxOqkpYqCN67HmlvbmDHXws43O1SFzF5wds3HazJOa0gfP3Agl
zGlTrsjMT9g5euq8rSqZc0molwWo7ZgdNk/UXCjt95GfiG6GBgm+R8OGrWPRpfbq
Ca8cGeOgftOTf9XXIagqOyNQ25pxG7Bvt48jMXIvKgzHDMlJAHEiTW/3KJC5nAon
iwypreKX5CPgQnc1f8kKIsmYWRQQdQ7UYwdLvgNClYhBwFinFS9BRiZGen38SGqB
TEiBjbopiapgFiV/yjb5p8U9fF6xYYhsqRDUhNOU5GavXtcHAMVxXuvb4mu1JwxD
YP12wHt5gLZWHMsQMKrW
=66zW
-----END PGP SIGNATURE-----

--BtLpl2nkGUzqmEOn--
