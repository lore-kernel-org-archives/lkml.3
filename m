Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934344AbaHZJNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:13:40 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33676 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934092AbaHZJNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:13:38 -0400
Date: Tue, 26 Aug 2014 10:13:34 +0100
From: Mark Brown <broonie@kernel.org>
To: James Ban <james.ban.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20140826091334.GE17528@sirena.org.uk>
References: <201408250919.s7P9Jpt4047076@krsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oiA4dBusuoDXNEPU"
Content-Disposition: inline
In-Reply-To: <201408250919.s7P9Jpt4047076@krsrvapps-01.diasemi.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V1] regulator: DA9211 : support device tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oiA4dBusuoDXNEPU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 25, 2014 at 06:16:56PM +0900, James Ban wrote:

> +* Dialog Semiconductor DA9211/DA9213 Voltage Regulator
> +
> +Required properties:
> +
> +- compatible:	It should be "dlg,da9211" or "dlg,da9213".
> +- reg:		the i2c slave address of the regulator. It should be 0x68.
> +
> +Any standard regulator properties can be used to configure the
> +da9211/da9213 DCDC.
> +
> +Example 1) DA9211
> +
> +	pmic: da9211@68 {
> +		compatible = "dlg,da9211";
> +		reg = <0x68>;
> +		interrupts = <3 27>;
> +
> +		regulators {

You need to define what the valid regulators for the device are and
where their configuration should be specified in the device tree.

--oiA4dBusuoDXNEPU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/E+7AAoJELSic+t+oim9PQMP/ArE0RoeuldDwohPFB1BQHsc
md428diNwri31rokvrkxQimTNarUVZEuX/gWYhp9zcPwEvUoQkdTq+KQuLFuu2av
iU55Ze4yhZaYsUluCHKGnM6MUrjfPoxtLZpMjEIj6hYY36+zJ2OPwvFoC47yHHSZ
Pc4U5MlbNNS63iZQaeUYVVKv2e0p1w7g5o9u/B9SehyzNXOMzb+YmSph3STNOmQV
RamzplOD7mD2zgoscqVmKoAFUBkVL5/+yq+OkMJfsl5ba57iXlGHmcAkFgAWl+fV
mIS5SLma/6H9m77K9XHrT4/BnRgiqKPIrwNBuypDimSVlFp79Ok6kBw0tVCVgi6X
KtmNWaHl+B4LbL88k1RVilCHOrAYz0AM0dm3HqlKmegDUnUWew36QJZJtTkF2QMC
zbS2Qgncgd6AzS9gB5spxWjbFXN7c7Nf71c4fznAnHD8AloStZH4so6wXpq4wtnW
30702/SzPOsTt3BCVHldY2CtG2wxYk+aJU7dKvoTTVD7kAjd07pDzYWm3RkpNq9s
fgttZjL9XExeJMnFcIr5D+4kNQBulvwpt47SyHiHxr2nRck39fzDApJ5XT+1/Vg+
1mb9BZlHBkwHdflvePJ7defHIOfZxQ9bqma37jPzImcalE3OSGbwUNrE+t5iaT9S
xStnnkH660IgX+O9XWoY
=RMBu
-----END PGP SIGNATURE-----

--oiA4dBusuoDXNEPU--
