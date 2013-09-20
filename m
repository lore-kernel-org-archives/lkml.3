Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab3ITNCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 09:02:24 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:33265 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab3ITNCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 09:02:13 -0400
Message-ID: <1379682070.9746.4.camel@oban>
Subject: Re: [PATCH v2 1/3] backlight: introduce backlight_device_registered
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
Date: Fri, 20 Sep 2013 15:01:10 +0200
In-Reply-To: <1379409796-29350-2-git-send-email-aaron.lu@intel.com>
References: <1379409796-29350-1-git-send-email-aaron.lu@intel.com>
	 <1379409796-29350-2-git-send-email-aaron.lu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-58w91WtYPtSbCTQSY6cQ"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-58w91WtYPtSbCTQSY6cQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mar., 2013-09-17 at 17:23 +0800, Aaron Lu wrote:
> Introduce a new API for modules to query if a specific type of
> backlight
> device has been registered. This is useful for some backlight device
> provider module(e.g. ACPI video) to know if a native control
> interface(e.g. the interface created by i915) is available and then do
> things accordingly(e.g. avoid register its own on Win8 systems).
>=20
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Tested-by: Yves-Alexis Perez <corsac@debian.org>
--=20
Yves-Alexis

--=-58w91WtYPtSbCTQSY6cQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAABCAAGBQJSPEcWAAoJEG3bU/KmdcClUQoIAJFa6UA/9Di6bcQ9BxuIwLUI
Khc9PEMmBklJpaVcNSWv+lnkaxv6tRbYkwpM2rFAccjUImMVfKkI/TucD6Ba5ZZi
aYPrd4cG5qNB4RFXLI7XxT6RDKGKPGNQmjXuUuSMHFqfOhFR4lZe21DW4wfsXB8s
qXjVZw2DDt1kuumE4ll9MWez1LboZnuAYobU0cxlWIHHKqdwyNbCS2KiRpZyv1SL
fR0iDdWfSMbZKytMK7GzVf1mIvAXBKH2GxJCI8pKb6dvg0O01HTDMeG32A7YlB2e
inulx+hGbAU2eJWXpbmU8aFe33WP9PNuj6pwvzwRjnjuwjQC9cMsvNUDE2bvKKQ=
=9VgC
-----END PGP SIGNATURE-----

--=-58w91WtYPtSbCTQSY6cQ--

