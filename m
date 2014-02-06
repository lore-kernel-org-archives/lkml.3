Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbaBFPDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:03:44 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36943 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbaBFPDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:03:43 -0500
Date: Thu, 6 Feb 2014 14:30:50 +0000
From: Mark Brown <broonie@kernel.org>
To: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Guenter Roeck <linux@roeck-us.net>
Message-ID: <20140206143050.GU32298@sirena.org.uk>
References: <cover.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
 <6d76ae40cd435eaae0323f3e806515130b06a376.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
 <20140205183642.GH32298@sirena.org.uk>
 <2E89032DDAA8B9408CB92943514A03376B7E1669@SW-EX-MBX02.diasemi.com>
 <20140206120336.GL32298@sirena.org.uk>
 <2E89032DDAA8B9408CB92943514A03376B7E36B9@SW-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="28wbjzzu+2Xmo01Z"
Content-Disposition: inline
In-Reply-To: <2E89032DDAA8B9408CB92943514A03376B7E36B9@SW-EX-MBX02.diasemi.com>
X-Cookie: Take it easy, we're in a hurry.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/8] regulator: da9055: Add DT support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--28wbjzzu+2Xmo01Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 06, 2014 at 12:22:13PM +0000, Opensource [Adam Thomson] wrote:

> Is what I summised but I obviously chose the wrong direction for my fix.
> Will use platform_get_irq_byname() solely, and will make sure all works on
> both DT and non-DT setups. If not I'll dig further.

Yeah.  In general I'd say that if you've got two options for something
like this the option that makes the driver smaller or which replaces
more code with data is normally going to be the right way to go.

--28wbjzzu+2Xmo01Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS85yWAAoJELSic+t+oim9WqwP/3LhoaOTrzYs4B99Daljki9R
jDfHwyk2GQ/uC9yNcE6BtXF2wRO/I/R+dJtMzd6RUYZcheodcC6e6zFUxlk9wu0/
PABtnuCc5au2KrGsYZmAz+bQ+qd0gkpNyC373XXnvczKm8rASj11u7Da7ddRlT5G
29oBBhSFypR4wP85Vi3mPdQ8WAz9fsQR6ZOaxZbn8VB84yVy2ojG506uxwclH1+K
J4sL2HJMy9jAjdDCw2ewuuJvPILz6JHf5fh7+SksxMZEjqxjYfVhum/hzB/rYxU3
/rRXDl0UesMGpDOqZtFIF+v3+RQcB8sWsn1yKN1QtiidbgLc1xifbZMRX0//zJfR
oAB+ccBRv6Q37ZdmLZdvzyDJDEmmjYJhvvFkgjdODXT18XPkGUnINNC3/5Q3MmxT
vSwTvfnnYA0yQEz1O67Y53v+NxnFtrpH+QnMcHkw6GF8FmhEswBs4GWEqchwjx19
VZkACXnRNtQYvLW5QDKxhRM6hoDiyNE98bBih6cfFyGgvgOdrsuL70Me1mXd2ada
V7q1aWmCLzgzORC3fWOO7u+YHZ4IeqovbxXv2nzjDd+ZtG6ikuScEjV6GhbKP4ku
fYjJfOkP0w+F/LMJimgcnv71c25m3ovZvSIdJjiNzacBBpYt9g47UtHOuDbX8PK4
TBZe4jBYEEYGdGLl+EbU
=jCP6
-----END PGP SIGNATURE-----

--28wbjzzu+2Xmo01Z--
