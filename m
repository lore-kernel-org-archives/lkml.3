Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaDRQbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 12:31:18 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38037 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaDRQbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 12:31:14 -0400
Date: Fri, 18 Apr 2014 17:30:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140418163054.GH12304@sirena.org.uk>
References: <1397751967-20250-1-git-send-email-chiau.ee.chew@intel.com>
 <1397751967-20250-3-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AkLHf9T6B4f6sqTW"
Content-Disposition: inline
In-Reply-To: <1397751967-20250-3-git-send-email-chiau.ee.chew@intel.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] spi/pxa2xx-pci: Pass host clock rate info from PCI
 glue layer
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AkLHf9T6B4f6sqTW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 18, 2014 at 12:26:07AM +0800, Chew Chiau Ee wrote:
> From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
>=20
> Intel BayTrail PCI mode LPSS devices inclusive of SPI do not rely
> on common clock framework. Thus, this patch allows the PCI mode
> SPI host to pass the supported clock rate info to the core layer
> which eventually used for speed calculation.

As you mention we already have a clock API for passing around
information about clocks, it would be much better to fix the fact that
this isn't enabled on x86 than to add custom code to deal with clocks
(even simple things like this) - this is far from the only place where
it causes issues.

--AkLHf9T6B4f6sqTW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTUVM7AAoJELSic+t+oim9CycP/jpMtgXq2s4lumhZ2ZX4IwoP
jkar8PXPZMR3PPpBCSrCB5aC2MjBoowAwYqv554aKjrrXASzTQHm7Q/HxjYTt6Ph
3ES3cyCCFB+RWYk5kNzV68torNG0xI4CGf5aYSh6nM57pfhAjjK58fYcjPGYrSAX
NqTvrn/itDPCBfWvASamRuTceSnvG7djegVUjDHicIW2zPifIPA2sJURsjxRTbjy
ix8pbnCEWut/Tim2fZNgctkPhlXBlgcHXJrtc9xV0zE9zqcR6MQ3nRQMs6FPgDV2
S+Qh0TCKB1sIoBhLsPLQK+Ur1j6rvkZOEjbUJPZbEjmXuHh6jcRFKO6XGjmTdF6S
xDOoGADKE61THUEXMVMxg6jxVrzLEjpwworp5nxQUWLjLi9+e1rSOn0bc9wxcFBX
Z3HU8mmyGBlvlgrxWJOEHomvvQMn4KSE3M4T4LyeAuxpR7YPhfoecVuP3sO9QvRq
klw5U91Yr9inqge4K8dWlPErfYejl38X0cqsNMYJUHvs5E8MHhdFJGGTy/bU0sWq
5fBeT7xn6cnRbjZ7iKISoa//8anjIZOqk9s4zLzhWFdoOXpmBlUe2Ql1OEcY0tUm
/0h8xYFXqmFl1YbHn1XvmtgHvsma2V2+VElB64VGH0TbmI0QEF0MJOHqqXR+D6CB
vi2nxygsCJ2FT0XMxUYp
=x9cO
-----END PGP SIGNATURE-----

--AkLHf9T6B4f6sqTW--
