Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaFDMdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:33:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53123 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaFDMdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:33:43 -0400
Date: Wed, 4 Jun 2014 13:33:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Eduardo Valentin <edubezval@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140604123300.GI2520@sirena.org.uk>
References: <20140527192923.GC12304@sirena.org.uk>
 <CAKohpo=AnusM2FGs=JLozSyTc0N7SDXQxe+rPiLEHP6ewxY4ow@mail.gmail.com>
 <20140528173858.GG5099@sirena.org.uk>
 <CAKohpo=T3BG9X0gHfRA-x8B3ou3Y=XHcs=OTYAHikX61iAJ9xw@mail.gmail.com>
 <20140603145347.GE31751@sirena.org.uk>
 <CAKohpo=VLCf2nz1WsL-iGw6BWwpmqZ+8JwGFFHFFtjZyAS9LrA@mail.gmail.com>
 <20140603154854.GG31751@sirena.org.uk>
 <CAKohpon9G=JdZ1jSStHZH29VZDggZXm+EOqDAwedk2K0ZxD0Qg@mail.gmail.com>
 <20140604103846.GF2520@sirena.org.uk>
 <CAKohpomS24eoqJ7h9d_5mPsyXhmnRSMW4fiCT0JnLRy5U6ARgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y96v7rNg6HAoELs5"
Content-Disposition: inline
In-Reply-To: <CAKohpomS24eoqJ7h9d_5mPsyXhmnRSMW4fiCT0JnLRy5U6ARgw@mail.gmail.com>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.148.252.180
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulators: Add definition of
 regulator_set_voltage_time() for !CONFIG_REGULATOR
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y96v7rNg6HAoELs5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 04, 2014 at 04:27:48PM +0530, Viresh Kumar wrote:
> On 4 June 2014 16:08, Mark Brown <broonie@kernel.org> wrote:
> > Please, go and *think* about what's going on here.  I've repeatedly

> > If the code fails to change the voltage it needs to handle that
> > (including remembering that attempts to lower the voltage fail); if the
> > code handles the errors sensibly I would expect that to handle
> > everything.

> That's what I was asking, how should the code handle it? Code also
> has to take care of platforms which haven't configured regulators
> in kernel and want to use this generic driver.

If the code gets an error back when it tries to change the voltage then
it should assume that the attempt to change the voltage did not succeed.
Should an attempt to change the voltage not succeed it seems reasonable
to assume that the voltage did not change and is the same as before.
The obvious thing would therefore appear to be for the code to proceed
with that assumption and act accordingly.

--y96v7rNg6HAoELs5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjxH5AAoJELSic+t+oim9EoMP/3vlAKcgrF3MFhq8bGisqJgX
B1noqP1XKZC+Z8v4KydVVA7w7C19+ah6cBAG7Wq+uze90c6o4SumT+PyWs1lyrew
hAZMh79OS9qPj77LI1L3b/ohRfNgAtvHjvg+a3FThUMMX/ZbMLowjRD5OmTjURTY
SAFwqtJ5pUabexKNUl6B6+EPuDu0Rg9vdvBIOoo8XnUrO9szDks8XIRvWRp8UC9Z
v4zjjcT8HAxLr9J+zs5hzNppl6pg0dhQC8yYUaympkwlczBX8tFKv5yoRuOroh7U
1U/vq0dBhxaadZOAAPPbsyjAubEGi0SMSChP7eGm/z+qhQ2aTGrpFEuDHlgY23SP
upd0fX8HvcoCG1KvSYJMwLMpz6lg3I6NCgxgzeMXIHnogl2qjBrnJT6hCmJ/saNf
oru/uwVBRyXQKJ1EFEGRLZq6m/OQw59NoqyogqcTFfLWCEKPRG/ABPyo2yADDEUp
zCJAk6PRGKgHTlqmBLluyNbAyCIQp7LO3+LpL61151Mr5rOyqvzQRIoo4aFWj1Bo
r/rXr/5nx2+f6zThnc10b2WKD6J3851WKbpEfsfWbDTClQfr9Gq1fMeo1FI4Mksh
8b1G/akJMIJ+d48FqXoRchMIC2kdwCzOtP66wLwXJ+XTqeNNzGQ1QxLN7MTCkBkk
EMg7HSeWYVL4TNEcs0r5
=/ily
-----END PGP SIGNATURE-----

--y96v7rNg6HAoELs5--
