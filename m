Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaAIKex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 05:34:53 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49605 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbaAIKeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 05:34:44 -0500
Date: Thu, 9 Jan 2014 10:34:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Patch Tracking <patches@linaro.org>
Message-ID: <20140109103438.GE31886@sirena.org.uk>
References: <1389162390-4582-1-git-send-email-sachin.kamat@linaro.org>
 <1389162390-4582-2-git-send-email-sachin.kamat@linaro.org>
 <20140108123002.GY31886@sirena.org.uk>
 <CAK9yfHwZN93T=Cs0jZ=ce6PBnjoFM6OcpC2cT1TCZVjHLBEJ=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s7t4U/z+yZBgBzGu"
Content-Disposition: inline
In-Reply-To: <CAK9yfHwZN93T=Cs0jZ=ce6PBnjoFM6OcpC2cT1TCZVjHLBEJ=Q@mail.gmail.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] regulator: Add support for S2MPA01 regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s7t4U/z+yZBgBzGu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 09, 2014 at 10:39:34AM +0530, Sachin Kamat wrote:
> On 8 January 2014 18:00, Mark Brown <broonie@kernel.org> wrote:

> >> +subsys_initcall(s2mpa01_pmic_init);

> > module_platform_driver().

> Just a small doubt here. Wouldn't changing this from subsys init to module init
> cause problems to devices like mmc which would want the regulators available
> (where they are not already enabled by the boot loader)?

This is resolved by using deferred probe.

--s7t4U/z+yZBgBzGu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzns7AAoJELSic+t+oim9FTEP/jWGAOscM7URbZu7wFVrobmK
8avRDPiZlMOXstpNWxrJy3R+kMB/B9EswBZQYLWSNTmxYUPf3QS9kXocD3WRy6hi
+M7oCfcslbdxpKXjUKnrFqyItobjNVNEtLmKsBDmPQcTEiUWVcLzKl6fjcQxE+Af
BS7xCerGqL9cvGvC2TSTS0B7bTiaUdpUvRN35SEv8W8UZTTTSjWpd41d0famhWOY
cjnzg9NeM5trn/gs3XIyHb0EYIkSXP8SuZdh8OmfiUwt4kOfdrU38H8TT1Cq5HC4
BgZKnGfQuFH2FPq3kb9cEmXXJf1agsL6qlZ/xR0KVDdrMzoqGk14p/rk2dOWjUHj
LmN/SDoDo3uiAFaEhrEsAObitCsrchsDDmnT8EjIGLuGkSoiz/YdTBgvIkE1iIsU
Woj0XnYZtki7vTvtUQE4LpVTKQu7byQb584RHr4zCBEhUYhnVUDGzvG772QqJ5yO
q5xt2mDdGNaG59ESKJSOTIuES2T13Ygnrk3tRgIcm02lN/kaLuZTR262TszKqPpb
dwy8u0ho85Ez90PxOCHIhQh+HzpFBF8BojfkV1DKE6IWaqpHcfc9Gc3yvxoSiwCn
dB0zJSlW01fYvVaDaoskD1YrDo2AIAMpwV4wyD6qWEODUehC/bJDgmkslHPMLJiy
GExvjW8uVJ491sO5TsZ2
=6hcC
-----END PGP SIGNATURE-----

--s7t4U/z+yZBgBzGu--
