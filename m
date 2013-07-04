Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab3GDQ1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 12:27:16 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51142 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab3GDQ1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 12:27:14 -0400
Date: Thu, 4 Jul 2013 17:26:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "peter.p.waskiewicz.jr" <peter.p.waskiewicz.jr@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        danders <danders@circuitco.com>,
        "vishal.l.verma" <vishal.l.verma@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Grant Likely <grant.likely@linaro.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>
Message-ID: <20130704162641.GG27646@sirena.org.uk>
References: <cover.1372211451.git.dvhart@linux.intel.com>
 <a459c0b97ea41148af901fc73dbeff98778c7419.1372211451.git.dvhart@linux.intel.com>
 <CACRpkda8QGdoAvjsUs7Uu+ukUu7ST63g=H9arA7SS7ceWmMTaQ@mail.gmail.com>
 <1372398218.9243.29.camel@envy.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4vGmjSrOD7pGiAie"
Content-Disposition: inline
In-Reply-To: <1372398218.9243.29.camel@envy.home>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/8] minnowboard: Add base platform driver for the
 MinnowBoard
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4vGmjSrOD7pGiAie
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 27, 2013 at 10:43:38PM -0700, Darren Hart wrote:

> minnow_hwid() just returns an int that the minnowboard platform driver
> read from the GPIO. This seems like a proper abstraction to me. Do you
> object to this one as well?

We should really have a subsystem for this too - the general idea idea
of identifying boards, fit options and so on by looking at things like
GPIOs or numbers in flash is really common.

--4vGmjSrOD7pGiAie
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1aI+AAoJELSic+t+oim9Gi8P/irPpX97W+QL99brauSPPkJo
5M0mgyUN3SYDKTcDBCUKgr/aQ/gjvyYFQLjyGwI7910u05EF/OIF4AFUMiECmiWN
yFVbycYchEhYSet++fHL85WxNTi+G4Dxn13/F2RkX4SQo22JSSIbt7ZA52FacYfT
QLkRuVmUwKWRDhbNJDit2pfOW/VNnakfaSlcTJuEZn2h5DgBW8Mwti9KpPmENsGP
vG6YhTWh2jdHJrFpNyCfdO8mtEyO3MxBdBBdRgqDr1mltJU/f7RvXjNwXRMkXcAG
ERI3+GUpV+rS4FQx5YjJCvWC2KKvhuvNsO3uxCiFjBsoRq9S4z9RiP7Ltbqd3At5
BPF1ZBD6I/6XMCQxxmQDjVsxcPPXRFnEWu3MVQogZx1qObP7lZQ7hfSOnKE0i4q2
gDKPj79YrDhit69zKw6gmLggB1WzB/3ZmEk4a2w4l95oVdP4R5MYsiZfP1tWLDSZ
sQ6FB3OVMXww05+UEIBaX6Ilai3MzEuBUvCVrWYfvQoAQNnVQ45y2j/V9LBZMeid
LtkLsCkBVW/RysPlOZ0nPPvGK+tMWMnkLLNEHzf01Rc8BHj5A0NNPvhgLLS3QBJu
xtSL+MXNX+bApY8q+L2rIwxfAq7rW2QPcjhvbXcWUnaGpSKlACVXYcjsre3de/vr
ARVp5escNrEyh7W8YCRh
=YmUE
-----END PGP SIGNATURE-----

--4vGmjSrOD7pGiAie--
