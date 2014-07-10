Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaGJHzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 03:55:05 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53239 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751225AbaGJHzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 03:55:03 -0400
Date: Thu, 10 Jul 2014 09:51:05 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/14] AT91: PIT: Cleanups and move to
 drivers/clocksource
Message-ID: <20140710075105.GA27469@lukather>
References: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Tue, Jul 01, 2014 at 11:33:13AM +0200, Maxime Ripard wrote:
> Hi everyone,
>=20
> This series cleans up the PIT driver in order for it to not depend on
> anything in mach-at91 anymore, and in the end move it out of
> mach-at91.
>=20
> Along the way, these patches also do a bit of cleanup.
>=20
> This has been tested on a G45-EK without DT and an Xplained with DT.
>=20

Even though most of this patches are not clocksource related, it would
be great if we could at least get an acked-by on the last patch that
moves the driver to drivers/clocksource, since it pretty much becomes
your burden :)

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTvkXoAAoJEBx+YmzsjxAg1cMP/Axp7YxHX6/HbqKPIZuVTJxv
PVY6yIqEEw4k9AFUSSKOERsVZb7gdjq8UxP/78t2N2wGzdovvGiipMxILUtoW/5Z
Fcg2jzRkwf+FBOjPNlmcszONOcgq0Oa+NU31c9ww9o+xY4iUh/6SexH2QksMcKmO
/VKhKfJRUtpwYijWSWuEKs8RGyIy1Xj0VWr3b9tFhAZiLeDlF/cYupH2CKFefdZx
j8iNH60TavcecfgvQAoT+kjsjlqiMzdcwYAoXZPXFB9Io8Jh/envMQGV5WMCdY02
SbkLK5CcSgbnqb/yaCMQKKkkDWLxTVjvnfjk1jBy1IX2E3LvvLjaxzZ2H5T7xrWh
nvgRMryKBORW9wF6Ay+zOrbtNK+8qX9XocdDq1zrKxQ9mjXNKYgvI2OnD9V6H0UP
J7QSmQ0D9WXlkBgSYtaKPSiTTcRG/eRVvieVeAWTd4Ga+Obm4plzRIrmFP3Mkorg
VXTImQb0SjmSbi/I2hc88blKIU+8MP/HEigBMiPKzx7NLvFUGYH3b5LM2Gu1ocS4
ThzeXJBD2njM14rK9b/Z5MK7F9wLbXbahUg8ho9c5SjcW/F10tNWSqkfaNWxHa/f
MmUDjDRBgvRTWGvpJl6MexCKdJkwQKlNxAy1APAdZiuOn5PujG6FI0gWfCp96F7G
cJN0M/lVW87zyqB1yNcV
=dHwZ
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
