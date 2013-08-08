Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966697Ab3HHVSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 17:18:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58408 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966555Ab3HHVSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 17:18:52 -0400
Date: Thu, 8 Aug 2013 22:18:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wei Ni <wni@nvidia.com>, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-tegra@vger.kernel.org, MLongnecker@nvidia.com,
        khali@linux-fr.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20130808211825.GN6427@sirena.org.uk>
References: <1375944991-29182-1-git-send-email-wni@nvidia.com>
 <1375944991-29182-2-git-send-email-wni@nvidia.com>
 <20130808110136.GA6427@sirena.org.uk>
 <52038035.7030803@roeck-us.net>
 <20130808130840.GC6427@sirena.org.uk>
 <5203B78C.7010101@roeck-us.net>
 <20130808171554.GI6427@sirena.org.uk>
 <20130808200026.GA18226@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kzMQwe+b+L5ZMwhV"
Content-Disposition: inline
In-Reply-To: <20130808200026.GA18226@roeck-us.net>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/3] hwmon: (lm90) Add power control
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kzMQwe+b+L5ZMwhV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 08, 2013 at 01:00:26PM -0700, Guenter Roeck wrote:
> On Thu, Aug 08, 2013 at 06:15:54PM +0100, Mark Brown wrote:

> > Sure, that's the transition issues I mentioned - the regulator API does
> > have stubbing facilities which should cover things and it's very easy to
> > define stub regulators if you need to.  Like I say I expect this to be a
> > lot easier after the next merge window as another way of doing stubs is
> > being added which should make this even easier by avoiding disrupting
> > drivers that do genuinely want to check for absent supplies and handle
> > that better.

> We will need to make sure that all dts files using any of the compatible chips
> are updated accordingly. There are several entries in various dts files for
> adm1032, adt7461, lm90, and nct1008.

Yes, and probably also board files as well.  Or either just accept
bisection trouble for now or wait till the better stubbing is in there -
that will mean that for DT systems the core will just assume the supply
is really there and not fail requests if it's not in the DT.

> > The names requested by a driver are defined with regard to the device
> > and should be the names used by the chip itself as defined in the

> 9 votes for vdd, 11 votes for vcc, one undecided (no datasheet available).
> Guess one is as good as the other ;-).

What I've suggested before is to use the name from the part for which
the driver is named.  Assuming the vendor doesn't randomly change their
datasheet (but that causes problems for hardware engineers so tends to
be avoided).

--kzMQwe+b+L5ZMwhV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSBAseAAoJELSic+t+oim9HdkP/1clAmlXHvLIfuDu7yuIR1Ec
UABcJ4gtxJBYR8zc729KpJaLhsjS+LxxuKVFI0PFgUAXmOEO1jHpwy+VR9JW5eee
e7WdPzet8WZpldswORMJNOOHoE0vZpTs+0Qg2gj2dr7CJX9gyKQeb6pGS05qFHkS
LNCmWGU97sTnruiIqeSTvTVECDUp4ImE6AskOsSHnTwOIBeLiHHtelLQHXaUqSh7
3MCzj5C1Qy1VyQkFTIPezhW5pl7u7IBkgXkjBW7ki8tIDMC7Ic4wy/X7oEr7BMMx
fCimtqRXt/lpNcAzb3SdvnFiU7NigzJ2aEawoU9CzfhYcCu0Yf1qo43VDhjDWEkG
n5wCymITmin+LFZnl4+uZ+uQr9HG3C5AdffIvlmCNblEUzxCruj6DTepilSKoUEy
thnaLAHqhrvvf/cvyQx3L7bCcpIy6GwUVUzNI+6H/3b6+BIxLYCBbOB6EHufeCLA
hcTOUOiyrftSlwzy594PqY8svbHkT3nGptDSOobkWJDEtqABPCj/AwrUB2wMYP5u
Zya/KSAtO5hD3DzUaBmO1o5nhrYwMt1U7fnYEipJudFE/gJSaa3hDZuifSjElrNw
/seCyI+eThDBP59ZEICqhqpg1ZqbWPveHA+lZgkjlR2l61EJTUhKs8xnAJFtdyT4
E3SpSfLRmIV9DOuNM9Hd
=9ID7
-----END PGP SIGNATURE-----

--kzMQwe+b+L5ZMwhV--
