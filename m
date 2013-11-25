Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab3KYPlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:41:53 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33628 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab3KYPlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:41:51 -0500
Message-ID: <52936F71.8070806@ti.com>
Date: Mon, 25 Nov 2013 11:40:33 -0400
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
	boundary="6x9oXx7jk9GCV8H5rRxSTsth7PCkp6NDU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6x9oXx7jk9GCV8H5rRxSTsth7PCkp6NDU
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 25-11-2013 11:31, Mark Rutland wrote:
> Any cooling device has a range of cooling states (i.e. different levels=

> of heat dissipation). For example a fan's cooling states correspond to
> the different fan speeds possible. Cooling states are referred to by
> single unsigned integers, where larger numbers mean greate heat
> dissipation. The precise set of cooling states associated with a device=

> (as referred to be the cooling-min-state and cooling-max-state
> properties) should be defined in a particular device's binding.

OK. Added this to the binding document.


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--6x9oXx7jk9GCV8H5rRxSTsth7PCkp6NDU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlKTb3EACgkQCXcVR3XQvP37HgEAjrZfxK+sUCNEy0AuW2snm35B
FKWMpFFWgmf7QmwojokA+gMWMa5ZKnM1Hz4ENxSRyEWrWHTbppY1g/nNBIt0xVio
=ruHP
-----END PGP SIGNATURE-----

--6x9oXx7jk9GCV8H5rRxSTsth7PCkp6NDU--
