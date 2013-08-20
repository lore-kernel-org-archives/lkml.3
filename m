Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab3HTTOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 15:14:16 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39558 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3HTTOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 15:14:11 -0400
Date: Tue, 20 Aug 2013 20:13:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, swarren@wwwdotorg.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, rob@landley.net,
        lee.jones@linaro.org, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, gg@slimlogic.co.uk, kishon@ti.com,
        j-keerthy@ti.com, ian.campbell@citrix.com
Message-ID: <20130820191339.GT30073@sirena.org.uk>
References: <1377004456-26318-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UKUpI6lZ3P7mfoqz"
Content-Disposition: inline
In-Reply-To: <1377004456-26318-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: There is a fly on your nose.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V3] regulator: palmas: add support for external control
 of rails
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UKUpI6lZ3P7mfoqz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 20, 2013 at 06:44:15PM +0530, Laxman Dewangan wrote:

> +			econtrol = PALMAS_EXT_CONTROL_NSLEEP;
> +			if (!ret) {
> +				if (prop == 1)
> +					econtrol = PALMAS_EXT_CONTROL_ENABLE1;
> +				else if (prop == 2)
> +					econtrol = PALMAS_EXT_CONTROL_ENABLE2;
> +				else if (prop == 3)
> +					econtrol = PALMAS_EXT_CONTROL_NSLEEP;

Since Stephen identified an issue as well...  this looks like a switch
statement.   Otherwise this looks fine.

--UKUpI6lZ3P7mfoqz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSE7/fAAoJELSic+t+oim9Zp8P/RPggDonvpxfdWC3oLWcesPN
rBlNSB5f+wqhepuWSB+szOICnNWwZyE6VSdzrjspJ+HOyL0mZLcS8OX3B9g5UZd1
dN1a2e31DrFsVzc6Pez8tBU5WmdP2I25Hi6HZz7Xw6p55CtKzEjf5wMCDy9Ogw1U
pymdmheNRQ9wGuh3oKqwzyp7iVo5cqZmpL4TCWC5i2iXDptBhLFWr7XwrqAaNkZt
FbmA3/5f2doYre0yh+FVcIF0Rf0h4sZkctyDKBKH2xDh9PwCTIPT8JDamvIhJgot
U5UfjveH22gTFkT02exssgDePbshBXGz7wFGF3I/QXDPTSmVQZiQ+sdYbaIjdwpH
m9b5KceaigC51QL1BB8EQfTBhzRM1AndMwJdZ4tb9atewk9u1ZOKFej/2cTg4rfE
Wl5r4JSu9HKz+gahbLsAOG4OSl8jhISvH/Iw3TkX9SkkgmgG7ftO0EviT0GoDRtT
1/1cfUQANF7198H2clpVZ0LFgAlIfkiJpNITB5TgLXsL/MoSYtv9KIudDftoSvxo
4NBJfIP6b6RcDvBRK2OcZpK/lMbFjXU+S0kvlY/pR6Kl8oYkyKCPZByyLFqz6nCo
DgFiAvQHml13JAe1EKMxdNh5jMlvo9ClgxmvFWOrHk1KGjxOdopUuLvTNdAwyblh
J7eGaMTXYCIl6rCF45tz
=0Adl
-----END PGP SIGNATURE-----

--UKUpI6lZ3P7mfoqz--
