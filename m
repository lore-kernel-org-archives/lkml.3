Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab3ITNDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 09:03:20 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:37516 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab3ITNDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 09:03:18 -0400
Message-ID: <1379682132.9746.6.camel@oban>
Subject: Re: [PATCH v2 3/3] ACPI / video: Do not register backlight if win8
 and native interface exists
From: Yves-Alexis Perez <corsac@debian.org>
To: Aaron Lu <aaron.lu@intel.com>
Cc: linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Jani Nikula <jani.nikula@linux.intel.com>
Date: Fri, 20 Sep 2013 15:02:12 +0200
In-Reply-To: <1379409796-29350-4-git-send-email-aaron.lu@intel.com>
References: <1379409796-29350-1-git-send-email-aaron.lu@intel.com>
	 <1379409796-29350-4-git-send-email-aaron.lu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-tewwTmGUp+Pausd/MBrU"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tewwTmGUp+Pausd/MBrU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mar., 2013-09-17 at 17:23 +0800, Aaron Lu wrote:
> According to Matthew Garrett, "Windows 8 leaves backlight control up
> to individual graphics drivers rather than making ACPI calls itself.
> There's plenty of evidence to suggest that the Intel driver for
> Windows 8 doesn't use the ACPI interface, including the fact that
> it's broken on a bunch of machines when the OS claims to support
> Windows 8.  The simplest thing to do appears to be to disable the
> ACPI backlight interface on these systems".
>=20
> So for Win8 systems, if there is native backlight control interface
> registered by GPU driver, ACPI video will not register its own. For
> users who prefer to keep ACPI video's backlight interface, the
> existing
> kernel cmdline option acpi_backlight=3Dvideo can be used.
>=20
> This patch is an evolution from previous work done by Matthew Garrett,
> Chun-Yi Lee, Seth Forshee and Rafael J. Wysocki.
>=20
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Tested-by: Yves-Alexis Perez <corsac@debian.org>
--=20
Yves-Alexis

--=-tewwTmGUp+Pausd/MBrU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAABCAAGBQJSPEdUAAoJEG3bU/KmdcClaAAH/3YwGtv83uQQ77PfJ1cmqADy
bFH4WDtWKptZ6hCZ92ID60lPKVucJHpPWcGcDYmp/wsPtGdCUa0zWJ6Xk0XPPULI
Z1RoVmyni/pXJlPK9zPRrxj2lZX857xYimgI+doISf3frUBFZFVYJIIW26QtpiQ0
WbA+ujp/46DWeGcSN88HW5alzH4pyN1nsPpEoK7KFVNLL6eV1Py3XectVPa8+TKn
15n7G9hc6YtuoJLA4NnptHxyJILXDIigluGfAFTThgBY4CFNpdD1a6F0nYma+oa+
gdP2m8GHGf95/tHwdu4c7O0OQOoyS1tITnzWuj71RO9ehGbsYZAMM1pJJJ6EfL8=
=ph5b
-----END PGP SIGNATURE-----

--=-tewwTmGUp+Pausd/MBrU--

