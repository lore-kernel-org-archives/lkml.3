Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbaKGKgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 05:36:21 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48170 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaKGKgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 05:36:19 -0500
Date: Fri, 7 Nov 2014 10:34:40 +0000
From: Mark Brown <broonie@kernel.org>
To: Beomho Seo <beomho.seo@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, sameo@linux.intel.com,
        lee.jones@linaro.org, lgirdwood@gmail.com, sre@kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        jonghwa3.lee@samsung.com, geunsik.lim@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com
Message-ID: <20141107103440.GD8509@sirena.org.uk>
References: <1415328727-16245-1-git-send-email-beomho.seo@samsung.com>
 <1415328727-16245-6-git-send-email-beomho.seo@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="c9D8mOo1KWOdrF7C"
Content-Disposition: inline
In-Reply-To: <1415328727-16245-6-git-send-email-beomho.seo@samsung.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.165.192
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/5] Documentation: Add documentation for rt5033
 multifunction device
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--c9D8mOo1KWOdrF7C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 07, 2014 at 11:52:07AM +0900, Beomho Seo wrote:

> +Required properties:
> +- compatible = Must be "richtek,rt5033-regulator"
> +
> +	regulators {
> +		compatible = "richtek,rt5033-regulator";

There should be no need for this extra compatible, it's not adding
anything we didn't know from the fact that it's part of the MFD.

> +		regulator-name {
> +			regulator-name = LDO/BUCK
> +			standard regulator constraints...
> +		};

Better to just say something like "regulator subnodes called X, Y and Z"
described using the standard regulator binding in...

--c9D8mOo1KWOdrF7C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXKA/AAoJECTWi3JdVIfQY6UH/A8e87VSq+PaEhtP9e5W4t15
HAHi/FjSL9yhX8N3I1Inh1UHmJc2Vjy+U9nN2h1+Zb1izihrMRozYkEg2JL5n0X7
GMAE7KftmbZj+mTaemTcVL5GCzTO4i067iA0f38FTq11fhB+YCeIIu+xIglRvEj1
dSzkr456EWUS5XenR/i2oJQ+eTg47FVudF01HD68A80p00weI0iYwrqQCHvYPCnI
YV+mY7YpG6crGGmlXadxxu7v70rakHFjRwLdUme5tWWA2KwGEUT1Iv8ryN9Hxu8S
EAfmN92Dj8ZpePXn6RJVR3LLW40Wco+OYPIoxomX9+68ZsyylVNGf3UqelL94eY=
=28B+
-----END PGP SIGNATURE-----

--c9D8mOo1KWOdrF7C--
