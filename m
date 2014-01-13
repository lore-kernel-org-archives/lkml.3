Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbaAMJnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 04:43:52 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55387 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbaAMJns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:43:48 -0500
Message-ID: <52D3B544.6070808@ti.com>
Date: Mon, 13 Jan 2014 11:43:32 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
CC: <plagnioj@jcrosoft.com>, <pali.rohar@gmail.com>, <pavel@ucw.cz>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Ivaylo Dimitrov <freemangordon@abv.bg>,
        Archit Taneja <archit@ti.com>
Subject: Re: [PATCH] OMAPDSS: DISPC: Fix 34xx overlay scaling calculation
References: <1389444125-5000-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1389444125-5000-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="di3IfJUimkR1swHcb3b2PUMLoDw06ux9U"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--di3IfJUimkR1swHcb3b2PUMLoDw06ux9U
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 2014-01-11 14:42, Ivaylo Dimitrov wrote:
> From: Ivaylo Dimitrov <freemangordon@abv.bg>
>=20
> commit 7faa92339bbb1e6b9a80983b206642517327eb75 OMAPDSS: DISPC: Handle
> synclost errors in OMAP3 introduces limits check to prevent SYNCLOST er=
rors
> on OMAP3. However, it misses the logic found in Nokia kernels that is
> needed to correctly calculate whether 3 tap or 5 tap rescaler to be use=
d as
> well as the logic to fallback to 3 taps if 5 taps clock results in too
> tight horizontal timings. Without that patch "horizontal timing too tig=
ht"
> errors are seen when a video with resolution above 640x350 is tried to =
be
> played. The patch is a forward-ported logic found in Nokia N900 and N9/=
50
> kernels.
>=20
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>

I had a quick test with this. Without the patch, on beagle-xm, my scaler
test immediately gives "horizontal timing too tight". With the patch, no
errors and the scaling seems to work. So looks good. I'll look at the
patch a bit more, but I think this is 3.14 material.

 Tomi



--di3IfJUimkR1swHcb3b2PUMLoDw06ux9U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS07VEAAoJEPo9qoy8lh71CTMP/0fF8a8+EtwvrdmFNhAg/0OU
e5iZSsohg0MWwGj2Ncve5UO3wdSbNhY1SLvEiEh0YRkBuoQE9uCf4cF4B01eoCot
KG+7N78cdqgeuuC/9eDeklxwZPKZMeMGxjE/CB57GsI+JDdskjEFvwgKlC+En7D1
PpY/UQvH9q4/wEFrK4iI+eHYkgE1gqR/UvEY0ulKOPjk2FunZycmA6A0G+qS/dKZ
cPG88TgtLKV4SJ9z9upDjwAhA+a+8ycydLd6XmrfecvpOz16qmGfL6ANoRAZapgS
jhQEGLErHFuk7TEqdjUE4XuzyIA6QD/VH9fE6Ag33l3SJ+F7253PsQwnsz3k9tj7
KrSIwNpKnGNY6JG8e6DDleGQS2lDbqEqyiIBsLcNIP71sXPVRQXEwx5z7zq6KcEX
TmOmYWSRoT2HOwD/KMV0woA9NKK9/Vv0005hv9d6yhuhrQxPCO0hgLioKUiZPXnD
TTHwXM23djhMo8K0bM0Ej8F4zpwnYiX2sSB3mt1qAQvV8kEQNJW6Cd5sLcYEcD/L
cqZ+s4N8PQPnAdARrWdkM0Z4Y++jTxJ2yrrujsERDCsSsyLK5T3arM+18MXy5dw9
e2opDdeJwdtvdsHRQB0thxT45CvY+qVsoeXeVpl7Qw2lyKgql/Lo0PGWVVtKXo4l
7K8uqdmt8wQbuLhur/Im
=6nsW
-----END PGP SIGNATURE-----

--di3IfJUimkR1swHcb3b2PUMLoDw06ux9U--
