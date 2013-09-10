Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab3IJSxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 14:53:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34044 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab3IJSxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 14:53:43 -0400
Date: Tue, 10 Sep 2013 19:52:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Wei Ni <wni@nvidia.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130910185235.GF29403@sirena.org.uk>
References: <522E93D6.2010304@roeck-us.net>
 <522E94AE.7000804@wwwdotorg.org>
 <522E97CE.4070300@roeck-us.net>
 <522E9C84.9070405@wwwdotorg.org>
 <20130910100939.GW29403@sirena.org.uk>
 <522F35BF.6070909@wwwdotorg.org>
 <20130910170438.GS29403@sirena.org.uk>
 <522F5A65.8040907@wwwdotorg.org>
 <20130910181837.GD29403@sirena.org.uk>
 <522F66FB.2000608@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hJ64AiXiG3hy1bNf"
Content-Disposition: inline
In-Reply-To: <522F66FB.2000608@wwwdotorg.org>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/2] hwmon: (lm90) Add power control
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hJ64AiXiG3hy1bNf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 10, 2013 at 12:37:47PM -0600, Stephen Warren wrote:

> OK, so for the DT binding we should make vcc-supply a required
> property, yet the driver will still work OK if that property just
> happens to be missing (or e.g. when instantiated from a board file,
> and there's no regulator).

Yup.  That way we've got both the binding and code trying to make things
work, hopefully that'll maximise robustness.

--hJ64AiXiG3hy1bNf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSL2pwAAoJELSic+t+oim9q5kP/RXrSlKvyL4QavWVPwUgeaOq
oMGisH4i71kRMbqpKFHAiy/4N3B/qFxx+o/EDyYQqc41EUxsaN9eI9VIfZwHFjou
XlLiY9nEDJ+NkpIVSZbWu+yhnV+LPxbC4xGsZNYgxsgeqoB56f3M5DsfPlnHnl1j
LSdVDQZtdruv+/ysZP9oJizpfJcG1Y7zBemRgyo0x0RL6UMK798KoJ3H/bBc8Qba
bUXMe97taby31o8UbY/P+6MJ4MPTXdAUVF8UpTKlf2eFxLfI/tCtXStTHqBgKOr2
3ndMzWMk6RbXA4MYT2AOxsXWkv6eJ5sPy2Gfjs09rizkTaAYMOX2aVVhGhV3FBgN
5iToKP1gKCl8/ME5ReHvf7mEeGS9B7DYzXQcswqmtyeMmlvoXRw7ISkR962lkySb
EaldbQAqtc6DzBbDcWDL2UKwOUEi28IGNSsxsITisp/CQp7duC1MwWVnGyqHR/C8
TzreyE6BFgEoPbKyvBGnB+mmh5ujRe9fTiq8RVoiLbssBlXEqJgcJpyqnKP0TLVL
YHMKxEEdlB7LMFg5KCSSyejqFRrwOEBZvyFAGiifYGAJO44h5dbu9NggS1kSG0Ar
Rl0koYRf2ngxun9YpGYr8ee8BDfWrSb8+VwTOsEpPSfxcqWnxmnHrkTt88DghWZC
xbQ1VHWz5qwOLT+t7CEb
=2McI
-----END PGP SIGNATURE-----

--hJ64AiXiG3hy1bNf--
