Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaJ0R6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:58:36 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51530 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaJ0R6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:58:34 -0400
Date: Mon, 27 Oct 2014 17:57:25 +0000
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
Message-ID: <20141027175725.GB18557@sirena.org.uk>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
 <1414427215-14380-2-git-send-email-romain.perier@gmail.com>
 <20141027163918.GB14253@saruman>
 <20141027172636.GZ18557@sirena.org.uk>
 <20141027173025.GA16005@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N+dhEFW7Y2Uiel/w"
Content-Disposition: inline
In-Reply-To: <20141027173025.GA16005@saruman>
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


--N+dhEFW7Y2Uiel/w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 27, 2014 at 12:30:25PM -0500, Felipe Balbi wrote:
> On Mon, Oct 27, 2014 at 05:26:36PM +0000, Mark Brown wrote:

> > Given that poweroff-source hasn't made it into a released kernel yet we
> > can probably just kill it off completely can't we?

> please do, then we will never have that commit in Linus' tree to give us
> nightmares.

Well, the commit isn't a particularly big deal (and got cross-merged
into another tree already) - if it's convenient to rebase it out we
probably should but it's also not the end of the world either so long as
it doesn't appear in a release.  Worst case people adopt it based on the
list discussions and we check for two properties which also isn't that
bad.

--N+dhEFW7Y2Uiel/w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUToeEAAoJECTWi3JdVIfQK2AIAIN2zFphnGcpGDJz2FXka0Xt
qAnh3Xe3qYnBmY7DjvviSDrkj8epCj+POBhBocHp4VeCxTULLx/V9OptA1dULRjG
NO5gc6UZKszhCsRnbqsr53h5gHP2TqyYNVjfdi3qVTAHAs9ks7eyfKYugnL2SY0T
OIPfmpk+mL1S5DuThmGeYRcNeBQjMF0daKLR+nOGQ/8QjiUNmTvND01wiZxMAC5c
g+WF9fEi0J+Rh0TzxK+W1acaJgNndVtwEr3WwQ3aHOXvyfZeOJe7NL6y3ydd05eX
OTHZViA9JhgTRU7CeFHqI9uDKHl3MoV0GocDRIXhQVEYbzKmZO7UmYdO/rK/mkA=
=6y00
-----END PGP SIGNATURE-----

--N+dhEFW7Y2Uiel/w--
