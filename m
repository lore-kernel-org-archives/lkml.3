Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbaJ0R2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:28:06 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51476 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaJ0R2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:28:02 -0400
Date: Mon, 27 Oct 2014 17:26:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Romain Perier <romain.perier@gmail.com>, heiko@sntech.de,
        devicetree@vger.kernel.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org, robh@kernel.org,
        mark.rutland@arm.com, johan@kernel.org, linux-pm@vger.kernel.org,
        linux@roeck-us.net, lee.jones@linaro.org, robh+dt@kernel.org,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, gnurou@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Message-ID: <20141027172636.GZ18557@sirena.org.uk>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
 <1414427215-14380-2-git-send-email-romain.perier@gmail.com>
 <20141027163918.GB14253@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YPOU9eFKIy6Wf5kE"
Content-Disposition: inline
In-Reply-To: <20141027163918.GB14253@saruman>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v1 02/10] dt-bindings: Document the standard property
 "system-power-controller"
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YPOU9eFKIy6Wf5kE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 27, 2014 at 11:39:18AM -0500, Felipe Balbi wrote:
> On Mon, Oct 27, 2014 at 04:26:47PM +0000, Romain Perier wrote:

> > +act8846: act8846@5 {
> > +	 compatible = "active-semi,act8846";
> > +	 status = "okay";
> > +	 system-power-controller;
> > +}

> there is no mention here that system-power-controller superseeds
> poweroff-source and deprecates that.

Given that poweroff-source hasn't made it into a released kernel yet we
can probably just kill it off completely can't we?

--YPOU9eFKIy6Wf5kE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUToBLAAoJECTWi3JdVIfQ5DYH/RI8OXmYY0W2YOW2mndiN6ux
eH0/FrQVFLEGTn4UP9EWVSBYIPVpoKFAzWmUfWqW31J0LgzsSyy2k9CRq6sD6MXS
PlqwsgVN8rNn1GBvp18w9PFJM2lDtpIPYWQLttWAJlCDmc5KXdGSuBn1p4Rutnzy
i71n4qKADI3IkDy/k6fnkyJXyTvwct61NBsfQiKImUpstqy0j4oP4qKT+c/8Mh5z
RpsWbuN+3YC/uOm11rTjGcmBGcG564BfOOueiJN+HnkE9PKB9opi/t40rQXy0s0O
FBf3dVZEkH3bqmuy0rj+b4ETBLX2SgOp/KIEZAKgh5gVploewmAGBE3yMZt9FSs=
=Gk4X
-----END PGP SIGNATURE-----

--YPOU9eFKIy6Wf5kE--
