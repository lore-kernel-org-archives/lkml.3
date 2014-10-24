Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbaJXKyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:54:15 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46177 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbaJXKyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:54:14 -0400
Date: Fri, 24 Oct 2014 11:53:26 +0100
From: Mark Brown <broonie@kernel.org>
To: bpqw <bpqw@micron.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jason Cooper <jason@lakedaemon.net>,
        Heiko Stuebner <heiko@sntech.de>, Thierry Reding <treding@nvidia.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Andrew Lunn <andrew@lunn.ch>, Silvio F <silvio.fricke@gmail.com>,
        Hayato Suzuki <hytszk@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20141024105326.GF3729@sirena.org.uk>
References: <A765B125120D1346A63912DDE6D8B6315E79C3@NTXXIAMBX02.xacn.micron.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WlEyl6ow+jlIgNUh"
Content-Disposition: inline
In-Reply-To: <A765B125120D1346A63912DDE6D8B6315E79C3@NTXXIAMBX02.xacn.micron.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.174.112.79
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] devicetree: bindings: Add vendor prefix for Micron
 Technology Co., Ltd.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WlEyl6ow+jlIgNUh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 24, 2014 at 12:46:35AM +0000, bpqw wrote:
> This patch is used to add vendor prefix for Micron Technology Inc in the vendor-prefixes.txt file.

This is the *third* time you've sent this patch this week, please stop
and allow a reasonable time for the maintainers to respond, a few weeks
would be normal.

Please also take a look at the submission format in SubmittingPatches -
commit logs should be wrapped to less than 80 columns and you've not
added your own signoff to the patch (or at least you're using a
different name and e-mail address to that in the patch).

--WlEyl6ow+jlIgNUh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUSi+lAAoJECTWi3JdVIfQTycH/RjjGIFROfwrB7rdH777N+RF
2Q2hoqJOPoKXNshq7PIM3NqA35mrUVTaeUSqOVm6IFf300X0EAITqb8ecB41Nra+
qH3WDRs7tiD6mzdaC6gspKHM7gkrDyWV+xN+U3PwwkkutoMVZzgbsNz0bmFm6F9p
So53ru6hQYgOirz3IVTKVpICmy01SVd1VhiXgCJ6jCIqzp/DI2h6j1a4ARoegUUr
AAswVA0QuRNtOUahF6UGs84zU0p884C7Oj+JQ5qJ2WtJw5zU4nrUkJkw82lzGYqn
MRdq68YBqK/P98UR0m+MIt5Uo2lJ3JiMJYJA6qXiIdvN6aZz3qmh35er5z7KR94=
=3OyA
-----END PGP SIGNATURE-----

--WlEyl6ow+jlIgNUh--
