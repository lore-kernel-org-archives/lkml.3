Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaFBKCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:02:20 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50702 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbaFBKCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:02:19 -0400
Date: Mon, 2 Jun 2014 11:02:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Eduardo Valentin <edubezval@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140602100201.GX5099@sirena.org.uk>
References: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org>
 <20140527192923.GC12304@sirena.org.uk>
 <CAKohpo=AnusM2FGs=JLozSyTc0N7SDXQxe+rPiLEHP6ewxY4ow@mail.gmail.com>
 <20140528173858.GG5099@sirena.org.uk>
 <CAKohpokk_sNQ7Be5F8NLa7pLrssPm9qPf-fDEUYkiurJ6Etrpg@mail.gmail.com>
 <20140602095112.GV5099@sirena.org.uk>
 <CAKohpom7XNFJ7dBzNVW0TX3gyxo4RJdJ4yriYLa_noforhyciw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w2olyN7lJGFjUUv/"
Content-Disposition: inline
In-Reply-To: <CAKohpom7XNFJ7dBzNVW0TX3gyxo4RJdJ4yriYLa_noforhyciw@mail.gmail.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulators: Add definition of
 regulator_set_voltage_time() for !CONFIG_REGULATOR
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w2olyN7lJGFjUUv/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2014 at 03:24:05PM +0530, Viresh Kumar wrote:
> On 2 June 2014 15:21, Mark Brown <broonie@kernel.org> wrote:

> > When you say they check for a valid regulator how are they doing that?
> > The stub will come into play if there isn't a dependency on REGULATOR.

> I meant they fail and quit if regulator_get() failed and so the first parameter
> to regulator_set_voltage() is guaranteed to be valid.

No, think about what you're changing here.  You're changing the stub -
the stub has a regulator_get() which always succeeeds.

--w2olyN7lJGFjUUv/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjEuVAAoJELSic+t+oim9yb4P/A4GCotcLRncxX5RF0QchOEN
E+6T9EV7rTZIYLk3hqV76dBmjfdU+vBRWNpwaKiyNPHRuP2PPI/93EHVMc56inxS
zvxLVhZkKFobukZhtvjQ7Sg/udhuEat2JspAw9QKsQjbOVNnP0LTreqIgPhSQLlA
QGRD96MU5zylqKItdCYY6PXK/L2dR2l6eS8RDOyUBCwf4Nq0aXkP/m/SNzp4KoVq
ce90bqhzWOXYHhwn289VDUk0ayVCW4wztBqBBvB5bLr/g2e9sB262aj5NtH+jWEL
sVq2gnrPyNgDG9B2Ujq8RjTsOGmraAIkoas0H5eOiwTew2FOcpGbOifNyJGpXw1r
QuVXbPAg2u8ns7ONkckE7S3cROpJEmjbEKdNKWjZ9MAuGjB8z6n9xs83wE+2mDTe
xPkLKyLqOMAPrSwEm+eGw2hi1FOz+WmUOhDbYZzY3zej8HB9jHwWk8jEqkUgIWGe
H10HmlxeI5apr9VAPvcsjM98j474AIGE6QTAJA0AFW8CABnFARTwjg1hOW+bpSU7
4ObbCcOO84j3W94ObAUAoo905kyzrSZtfK7XFHPfPwo4BYATNLjyQ1ONJREF1Z0H
edxIMNRcYfO+0JYE69aB05tebuajjFu9KIfr0BvCK3bJBEJsOYdrBvZsMYXMYX+c
nTlStsF0PJHnVblhSJbz
=trPr
-----END PGP SIGNATURE-----

--w2olyN7lJGFjUUv/--
