Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbaFITWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 15:22:18 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34281 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaFITWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 15:22:15 -0400
Date: Mon, 9 Jun 2014 20:21:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Message-ID: <20140609192133.GD5099@sirena.org.uk>
References: <1402309780-8118-1-git-send-email-cw00.choi@samsung.com>
 <1402309780-8118-2-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8ZMYqwT4qqBjIaog"
Content-Disposition: inline
In-Reply-To: <1402309780-8118-2-git-send-email-cw00.choi@samsung.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: of: Add support for parsing
 regulator_state for suspend state
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8ZMYqwT4qqBjIaog
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 09, 2014 at 07:29:39PM +0900, Chanwoo Choi wrote:

> +		ret = of_property_read_u32(suspend_np, "regulator-mode", &pval);
> +		if (!ret)
> +			suspend_state->mode = pval;

If we're going to do that we'd need to define what modes mean in the DT
binding - currently there's no support for modes at all because it's
complicated to come up with sensible and meaningful generic defintions.

--8ZMYqwT4qqBjIaog
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTlgk6AAoJELSic+t+oim9/q8QAIKJOFdSQd/ypBHEeNkpLx9z
kG1tP1rTdYy/9jmI7Z82o5JFwWe6Qfo2qQEtnwLbbEy8g7GefoPF8wi1RvhHXCi3
Y7Fn6wmSd87/zofoF3pZ58O0M0L2BswChsao+PJv/2ZJ22XDW45tFs29ThcVRb6y
1G2MWsirqM/Rg1S2YUboZPlQIho6k9TCp/QsbamjOMwFdhLJCGJ2AG+8qEDwpuzd
m0eJw4LSMcH/exs49x0mcG3zaPeN8l0lKYADBxdozkTNC8sp4wycqUqj0l+n1Zhe
rgWqlwSZcKHt+Nx8iOvWqRE5XCHePELMSxTUIJgfQ23VA4io1UwleFi9lvGfRCvM
o2CIeys+cKI7CAUXn1dl8ADRwNesqThPlJ3GPsJfRz8imBQtpvn7l+1LmgEol/TU
nGtGq/uuHqbuqeKKiejqqpUTs+APBncUcoerF3NI85hGnXvW8Ka+c27fDMN9mjex
DKwMzU9BVcqsUV736VFgDoispjsszzaXgTI4YmuRFYPsojSIl8Hvuqu37o412bd3
wLrg1dsl/hLpRlLRfqMhgx3MrRnsOvgDz0Jm/2J45dDNhOnZdYq0b0Ge/r6rrbs1
zT/HYCzQNeB4z/SlumkKbG7HaNDmOU0GeLPuRbBKqiRPOLYleXrudIqj++GNYoPT
T6ru3av1xBw03yRChUJM
=co7W
-----END PGP SIGNATURE-----

--8ZMYqwT4qqBjIaog--
