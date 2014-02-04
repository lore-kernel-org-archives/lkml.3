Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbaBDRXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:23:41 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35319 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaBDRXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:23:39 -0500
Date: Tue, 4 Feb 2014 17:23:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Matt Porter <mporter@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Tim Kryger <tim.kryger@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20140204172309.GG22609@sirena.org.uk>
References: <1391516352-32359-1-git-send-email-mporter@linaro.org>
 <1391516352-32359-3-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PfY+OYVI0N/4DRLF"
Content-Disposition: inline
In-Reply-To: <1391516352-32359-3-git-send-email-mporter@linaro.org>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/6] regulator: add bcm59056 pmu DT binding
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PfY+OYVI0N/4DRLF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 04, 2014 at 07:19:08AM -0500, Matt Porter wrote:
> Add a DT binding for the BCM59056 PMU. The binding inherits from
> the generic regulator bindings.

Is this really only a regulator - does the chip have no other functions?

> +- regulators: This is the list of child nodes that specify the regulator
> +  initialization data for defined regulators.  Generic regulator bindings
> +  are described in regulator/regulator.txt.

The regulators property should always be optional, the driver should be
able to start up and read back the hardware state without any further
configuration.

--PfY+OYVI0N/4DRLF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8SH6AAoJELSic+t+oim9rsYP/1L1zj3GN9KmZgnHe+QCaAtu
6WqNIr5o73Yird56+njBW2CXcIWh4eK1MzAiX7ahmqeBebQY5M08Zqff0kOklZZg
JIua3A4HWFjFw9yPwc5AI/5tCwAedRVIkj/+FoMJRDuWiUb4PdzzjB9LL+U3+A14
tIWGNDN09pp1iZQpAVUipYaI6yY2Yk4d8MkTEqBAn+wH/gxmoYzLz0CCb4oFQ++W
MWAy+EwT/uIL3Yn9f0rGZ9PjTGhP7ZWKgMg+Ol+V7KXbLm8FnW+8DRX9kV6N1QTp
hFqRdBUWQf8kD2hVsPAW0FrpvlSJRBoRDpGVkHq4AzO4HpLavncr0tehxfON2Uth
OSpSr8NoaCo+hh+CfXTLB3dMJFk3zcWjdMisE4IWDBMAh8LIox8IGwPyTAMzvhSr
scBy/oAZP9QEuxj2JG/HHS/w77cb+WkpeL2+WOmb8nFJyCisNowiXqstGv/sRecT
Md/2DjumZSGquXl6gvtTKobdsohr938KFowsqlxvoIdBkZbqESv+61Tq8OuBYH28
qF2ohti6LAORm4cz+CBZ2vrPxLVOOZdEJtg6TEbTaP3263iQvXWf+bUDvph02CC3
sP/nM+dwnCTOMuPnjhARwnNklM8+4u4lQOYwFqcbW5sMCX1MMHEQZnK9GGb1cQVb
aD3UAjGRs9AAfG5VnPoa
=IlGD
-----END PGP SIGNATURE-----

--PfY+OYVI0N/4DRLF--
