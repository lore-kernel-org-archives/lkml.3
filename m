Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab3KYPnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:43:16 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41684 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab3KYPnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:43:14 -0500
Message-ID: <52936FC5.9000908@ti.com>
Date: Mon, 25 Nov 2013 11:41:57 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Tomasz Figa <t.figa@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "wni@nvidia.com" <wni@nvidia.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv9 02/20] thermal: introduce device tree parser
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com> <1574695.YAEZXuUskK@amdc1227> <528E2B38.5050502@ti.com> <5333248.b0sPp1ZZXY@amdc1227> <528F4F1E.60903@ti.com> <20131125153118.GG32081@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131125153118.GG32081@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="5KERGKjECwg3gSF2IEDAH4wgxPhBc025k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5KERGKjECwg3gSF2IEDAH4wgxPhBc025k
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 25-11-2013 11:31, Mark Rutland wrote:
> I think if these are needed the set of types can be extended, no?
>=20

As long as we have a real board with real use cases to be covered, yes,
why not.

--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--5KERGKjECwg3gSF2IEDAH4wgxPhBc025k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlKTb8UACgkQCXcVR3XQvP186gD9GO0vsjL1jOLvi3RHxHDGbAOY
LXYcwI4ObPf+ybjsHZsA/jXDNLXM8baQuv9LOB2GSVy/Xl0ZQ+ow+W53Y1KSUOGB
=dAMy
-----END PGP SIGNATURE-----

--5KERGKjECwg3gSF2IEDAH4wgxPhBc025k--
