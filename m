Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbaGIIds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:33:48 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54434 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbaGIIdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:33:45 -0400
Date: Wed, 9 Jul 2014 10:32:02 +0200
From: Mark Brown <broonie@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: lgirdwood@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Keerthy <j-keerthy@ti.com>
Message-ID: <20140709083202.GJ30458@sirena.org.uk>
References: <1404846554-4095-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a58rN+WbXIGauCK9"
Content-Disposition: inline
In-Reply-To: <1404846554-4095-1-git-send-email-balbi@ti.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.127.83.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] regulators: tps65218: fix DCDC4 linear voltage range
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a58rN+WbXIGauCK9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 08, 2014 at 02:09:12PM -0500, Felipe Balbi wrote:
> The second range of this particular regulator,
> starts at 1.60V, not as 1.55V as it was originally
> implied by code.

Applied all, thanks.  Please use subject lines consistent with the style
for the subsystem - these even vary within the series!

--a58rN+WbXIGauCK9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTvP3/AAoJELSic+t+oim936MP/3UNZKcpCf3HzNWNRKmrrkVJ
w5WB818zF2U5PG6ojVoLcmvhXlsHTzibMdIQF9kbm9SCwcXVNpASgx0e5dakyrEv
rJfVpp/5QZrMyWjzjKUnd3KMwrlQIqDmczbtke1LaqG4TQXT9QVafeXtrGyKyGzG
L8z4tMhwR29fJAstbMeuxf8cnSJe0x2Q2sT07i6olda0/9XJDbO/OuMqbq8wFOqK
GpInLbAF4ThYJDRzxZexg9/Q2iDcZ4XUg9K5+gpjy3BbukWlquYOiddcSMYkb+g6
CAf+ndYmgeRGtdEjHs0skaGhMp01JklaCg/oHhxBWq/2LmhM00OVY0bTvNetEfpJ
+9mrj0waNA5pRSKjtXvG6XeypSe8tMMZ/jfuLasec3k2XW2yuZnxnDQGoigw9jYZ
ZIuXR8EesLgr2sscmE9RjUPD7615gJJvRFbWIvOzAQkxEeloLdYnSRkkt6UpoeR0
/reEqpdXEWEf8qDajV+tDDOlwCUiFuokVpd9myYj2QOsXYs3pTeh+7pDCBr37yP4
1pMlZ1e+jawOGtZM5lC7h81tdGhFRoIEKBGoFlAk2CH8a2YBl8DO8R5Xh4l1Iya8
zjcVlPOpOO0ksuI6Gn6xrs47KPAotQxaYAWxEFnooDQ2CLmE8n1N0BdbGxLj7Kko
ENbz3+3XRFob8ucHGBBN
=EDVZ
-----END PGP SIGNATURE-----

--a58rN+WbXIGauCK9--
